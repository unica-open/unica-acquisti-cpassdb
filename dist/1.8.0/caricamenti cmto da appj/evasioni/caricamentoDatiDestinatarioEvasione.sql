---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
---
CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_caricamento_dest_evasione (
    IN  code_ente          varchar, 
	out codicerisultato    integer,
    out messaggiorisultato varchar
)
RETURNS record AS
$body$
DECLARE
	strMessaggio       				VARCHAR(1500):='';
	strMessaggioFinale 				VARCHAR(1500):='';
    recDestinatarioEvasione    		record;
    v_stato_id						INTEGER;
    v_utente_compilatore_id			UUID;
    v_testata_evasione_id           UUID;
    v_destinatario_ordine_id        UUID;
    v_settore_destinatario_id       UUID;

BEGIN
	codiceRisultato:=0;
    messaggioRisultato:=null;
	strMessaggioFinale:='Ribaltamento destinatari ordini ';

	for recDestinatarioEvasione in(
      WITH destinatario AS (
        select  distinct evasione_anno ,evasione_numero , progressivo_dest , min(progressivo_riga) progressivo_riga
        from appoggio_righe_dest_evasione
        group by evasione_anno ,evasione_numero , progressivo_dest
      ) 
      select  
             id 
            ,appoggio_righe_dest_evasione.evasione_anno --INTEGER,
            ,appoggio_righe_dest_evasione.evasione_numero --INTEGER,
            ,appoggio_righe_dest_evasione.progressivo_riga --INTEGER,
            ,appoggio_righe_dest_evasione.progressivo_dest --INTEGER,
            ,ordine_anno --INTEGER,
            ,ordine_numero --INTEGER,
            ,progr_riga_ordine --INTEGER,
            ,progr_dest_ordine --INTEGER,
            ,prezzo_unitario --NUMERIC(13,5),
            ,quantita_evasa --NUMERIC(8,2),
            ,importo_totale --NUMERIC(13,5),
            ,oggetto_spesa --VARCHAR(50),
            ,aliquota_iva --VARCHAR(50),
            ,destinatario --VARCHAR(50),
            ,descrizione_destinatario --VARCHAR(500),
            ,indirizzo_destinatario --VARCHAR(50),
            ,localita_destinatario --VARCHAR(50),
            ,prov_destinatario --VARCHAR(10),
            ,cap_destinatario --VARCHAR(5),
            ,contatto_destinatario --VARCHAR(50),
            ,data_creazione --TIMESTAMP WITHOUT TIME ZONE,
            ,utente_creazione --VARCHAR(50),
            ,data_modifica --TIMESTAMP WITHOUT TIME ZONE,
            ,utente_modifica --VARCHAR(50),
            ,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
            ,utente_cancellazione --VARCHAR(50),
            ,stato --VARCHAR(50),
            ,dest_nuovo_esistente --VARCHAR(50)
      from appoggio_righe_dest_evasione
          ,destinatario
      where 
              appoggio_righe_dest_evasione.evasione_anno 	= destinatario.evasione_anno
          and appoggio_righe_dest_evasione.evasione_numero 	= destinatario.evasione_numero
          and appoggio_righe_dest_evasione.progressivo_dest = destinatario.progressivo_dest
          and appoggio_righe_dest_evasione.progressivo_riga = destinatario.progressivo_riga
          and appoggio_righe_dest_evasione.esito is null
	)
	loop
    	strMessaggio:='inizio loop';
        begin
          --PER TEST E DEV SCHIANTO DEMO 21
          --strMessaggio := 'nome ' || recDestinatarioOrdine.utente_compilatore_nome || ' cognome ' || recDestinatarioOrdine.utente_compilatore_cognome;
          --raise notice 'strMessaggio=%  ', strMessaggio;
          --select utente_id into strict v_utente_compilatore_id from cpass_t_utente 
          --where UPPER(utente_nome) = recTestataOrdine.utente_compilatore_nome
          --  and UPPER(utente_cognome) = recTestataOrdine.utente_compilatore_cognome      ;
          select utente_id into strict v_utente_compilatore_id from cpass_t_utente 
          where utente_nome = 'Demo'
          and utente_cognome = '21'      ;
          strMessaggio := 'v_utente_compilatore_id ' || v_utente_compilatore_id::VARCHAR;
     
          --estraggo lo stato
          strMessaggio := 'stato ' || recDestinatarioEvasione.stato;
          --raise notice 'strMessaggio=%  ', strMessaggio;
          select stato_id into strict v_stato_id from cpass_d_stato where stato_codice = recDestinatarioEvasione.stato and stato_tipo = 'DESTINATARIO_EVASIONE';
          strMessaggio := 'v_stato_id ' || v_stato_id::VARCHAR;

		  --estraggo id di testata evasione	
          strMessaggio := 'anno ' || recDestinatarioEvasione.evasione_anno || ' numero ' || recDestinatarioEvasione.evasione_numero ;
          select testata_evasione_id 
          into strict v_testata_evasione_id 
          from cpass_t_ord_testata_evasione
          where evasione_anno   = recDestinatarioEvasione.evasione_anno 
          and   evasione_numero = recDestinatarioEvasione.evasione_numero; 
          strMessaggio := 'v_testata_evasione_id ' || v_testata_evasione_id::VARCHAR;

		  --estraggo id di destinatario ordine	
          strMessaggio := 'anno ord ' || recDestinatarioEvasione.ordine_anno || ' numero ord ' || recDestinatarioEvasione.ordine_numero || ' progr_dest_ordine '|| recDestinatarioEvasione.progr_dest_ordine ;
          select cpass_t_ord_destinatario_ordine.destinatario_id 
          into strict v_destinatario_ordine_id 
          from 
          	cpass_t_ord_testata_ordine
          	,cpass_t_ord_destinatario_ordine
          where cpass_t_ord_testata_ordine.testata_ordine_id   = cpass_t_ord_destinatario_ordine.testata_ordine_id
          and   cpass_t_ord_testata_ordine.ordine_numero = recDestinatarioEvasione.ordine_numero
          and   cpass_t_ord_testata_ordine.ordine_anno = recDestinatarioEvasione.ordine_anno
          and   cpass_t_ord_destinatario_ordine.progressivo = recDestinatarioEvasione.progr_dest_ordine
          ; 
          strMessaggio := 'v_destinatario_ordine_id ' || v_destinatario_ordine_id::VARCHAR;


		  strMessaggio := 'destinatario ' || recDestinatarioEvasione.destinatario;
          select cpass_t_settore.settore_id 
          into  strict v_settore_destinatario_id 
          from 	cpass_t_settore 
          where cpass_t_settore.settore_codice = TRIM(recDestinatarioEvasione.destinatario);
            
          strMessaggio := 'v_settore_destinatario_id ' || v_settore_destinatario_id::VARCHAR;

          
          insert into cpass_t_ord_destinatario_evasione (
             destinatario_evasione_id --UUID NOT NULL,
            ,testata_evasione_id --UUID NOT NULL,
            ,progressivo --INTEGER NOT NULL,
            ,indirizzo --VARCHAR(200),
            --,num_civico --VARCHAR(20),
            ,localita --VARCHAR(200),
            ,provincia --VARCHAR(200),
            ,cap --VARCHAR(5),
            ,contatto --VARCHAR(200),
            --,email --VARCHAR(50),
            --,telefono --VARCHAR(50),
            ,destinatario_id --UUID NOT NULL,
            ,settore_destinatario_id --UUID,
            ,data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
            ,utente_creazione --VARCHAR(250) NOT NULL,
            ,data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
            ,utente_modifica --VARCHAR(250) NOT NULL,
            ,stato_id --INTEGER,
          )values (
             uuid_generate_v5('158e76f1-d62f-5b8a-940e-516d0b92f14d', recDestinatarioEvasione.evasione_anno  ||'-' || recDestinatarioEvasione.evasione_numero || '-' ||recDestinatarioEvasione.progressivo_dest)
			,v_testata_evasione_id --UUID NOT NULL,
            ,recDestinatarioEvasione.progressivo_dest --INTEGER NOT NULL,
            ,recDestinatarioEvasione.indirizzo_destinatario --VARCHAR(200),
            --,recDestinatarioEvasione.num_civico --VARCHAR(20),
            ,recDestinatarioEvasione.localita_destinatario --VARCHAR(200),
            ,recDestinatarioEvasione.prov_destinatario --VARCHAR(200),
            ,recDestinatarioEvasione.cap_destinatario --VARCHAR(5),
            ,recDestinatarioEvasione.contatto_destinatario --VARCHAR(200),
            --,recDestinatarioEvasione.email --VARCHAR(50),
            --,recDestinatarioEvasione.telefono --VARCHAR(50),
            ,v_destinatario_ordine_id --UUID NOT NULL,
            ,v_settore_destinatario_id --UUID,
            ,recDestinatarioEvasione.data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
            ,recDestinatarioEvasione.utente_creazione --VARCHAR(250) NOT NULL,
            ,recDestinatarioEvasione.data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
            ,recDestinatarioEvasione.utente_modifica --VARCHAR(250) NOT NULL,
            ,v_stato_id --INTEGER,
          );
            
          strMessaggio:='fine loop';
		  codiceRisultato := codiceRisultato + 1;
          update appoggio_righe_dest_evasione set esito = 'OK' where id = recDestinatarioEvasione.id;
      exception
        when others  THEN
          raise notice 'strMessaggio=%  ', strMessaggio;
          raise notice '% % Errore DB % %',strMessaggioFinale,coalesce(strMessaggio,''),SQLSTATE,substring(upper(SQLERRM) from 1 for 2500);
          messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'Errore DB '||SQLSTATE||' '||substring(upper(SQLERRM) from 1 for 2500) ;
      END;
    end loop;
    
    messaggioRisultato:=strMessaggioFinale||' FINE';
    return;

exception
    when RAISE_EXCEPTION THEN
        raise notice 'strMessaggio=%  ', strMessaggio;
        raise notice '% % ERRORE : %',strMessaggioFinale,coalesce(strMessaggio,''),substring(upper(SQLERRM) from 1 for 500);
        messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'ERRORE :'||' '||substring(upper(SQLERRM) from 1 for 2500) ;
        codiceRisultato:=-1;
        return;
	when no_data_found THEN
		raise notice ' % % Nessun elemento trovato.' ,strMessaggioFinale,coalesce(strMessaggio,'');
        messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'Nessun elemento trovato.' ;
        codiceRisultato:=-1;
		return;
	when others  THEN
		raise notice '% % Errore DB % %',strMessaggioFinale,coalesce(strMessaggio,''),SQLSTATE,substring(upper(SQLERRM) from 1 for 2500);
        messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'Errore DB '||SQLSTATE||' '||substring(upper(SQLERRM) from 1 for 2500) ;
        codiceRisultato:=-1;
        return;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

select * from pck_cpass_ord_caricamento_dest_evasione('CMTO');
