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

CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_caricamento_dest_ordine (
  out codicerisultato integer,
  out messaggiorisultato varchar
)
RETURNS record AS
$body$
DECLARE
	strMessaggio       				VARCHAR(1500):='';
	strMessaggioFinale 				VARCHAR(1500):='';
    recDestinatarioOrdine    		record;
    v_stato_id						INTEGER;
    v_utente_compilatore_id			UUID;
    v_testata_ordine_id             UUID;
    v_settore_destinatario_id       UUID;
    v_settore_indirizzo_id          INTEGER;
BEGIN
	codiceRisultato:=1;
    messaggioRisultato:=null;
	strMessaggioFinale:='Ribaltamento destinatari ordini ';

	for recDestinatarioOrdine in(
      WITH destinatario AS (
        select  distinct ordine_anno ,ordine_numero , progressivo_dest , min(progressivo_riga) progressivo_riga
        from appoggio_ordine_righe_dest
        group by ordine_anno ,ordine_numero , progressivo_dest
      ) 
      select  
          id 
          ,appoggio_ordine_righe_dest.ordine_anno --INTEGER,
          ,appoggio_ordine_righe_dest.ordine_numero --INTEGER,
          ,appoggio_ordine_righe_dest.progressivo_riga --INTEGER,
          ,appoggio_ordine_righe_dest.progressivo_dest --INTEGER,
          ,prezzo_unitario --NUMERIC(13,5),
          ,quantita --NUMERIC(8,2),
          ,percentuale_sconto --NUMERIC(8,5),
          ,importo_sconto --NUMERIC(13,5),
          ,percentuale_sconto2-- NUMERIC(8,5),
          ,importo_sconto2 --NUMERIC(13,5),
          ,importo_netto --NUMERIC(13,5),
          ,importo_iva --NUMERIC(13,5),
          ,importo_totale --NUMERIC(13,5),
          ,nota_esterna --VARCHAR(4000),
          ,nota_interna --VARCHAR(4000),
          ,oggetto_spesa --VARCHAR(50),
          ,unita_misura --VARCHAR(50),
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
          ,dest_nuovo_esistente --VARCHAR(50),
      from appoggio_ordine_righe_dest
          ,destinatario
          --(select  distinct ordine_anno ,ordine_numero progressivo_dest from appoggio_ordine_righe_dest ) as destinatario
      where 
              appoggio_ordine_righe_dest.ordine_anno 	= destinatario.ordine_anno
          and appoggio_ordine_righe_dest.ordine_numero 	= destinatario.ordine_numero
          and appoggio_ordine_righe_dest.progressivo_dest = destinatario.progressivo_dest
          and appoggio_ordine_righe_dest.progressivo_riga = destinatario.progressivo_riga
          and appoggio_ordine_righe_dest.esito is null
	)
	loop
    	strMessaggio:='inizio loop';
		raise notice  '%',strMessaggio; 
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
          strMessaggio := 'stato ' || recDestinatarioOrdine.stato;
          --raise notice 'strMessaggio=%  ', strMessaggio;
          select stato_id into strict v_stato_id from cpass_d_stato where stato_codice = recDestinatarioOrdine.stato and stato_tipo = 'DEST_ORDINE';
          strMessaggio := 'v_stato_id ' || v_stato_id::VARCHAR;

		  --estraggo id di testata ordine	
          strMessaggio := 'anno ' || recDestinatarioOrdine.ordine_anno || ' numero ' || recDestinatarioOrdine.ordine_numero ;
          select testata_ordine_id 
          into strict v_testata_ordine_id 
          from cpass_t_ord_testata_ordine 
          where ordine_anno   = recDestinatarioOrdine.ordine_anno 
          and ordine_numero = recDestinatarioOrdine.ordine_numero; 

          strMessaggio := 'v_testata_ordine_id ' || v_testata_ordine_id::VARCHAR;

          strMessaggio := 'destinatario ' || recDestinatarioOrdine.destinatario;

          select cpass_t_settore.settore_id 
          		 ,cpass_t_settore_indirizzo.settore_indirizzo_id
          into strict v_settore_destinatario_id ,v_settore_indirizzo_id
          from 	 cpass_t_settore 
          		,cpass_t_settore_indirizzo 
          where 
          		cpass_t_settore.settore_id = cpass_t_settore_indirizzo.settore_id 
			and cpass_t_settore_indirizzo.principale = true
            and cpass_t_settore.settore_codice = TRIM(recDestinatarioOrdine.destinatario);
            
          strMessaggio := 'v_settore_destinatario_id ' || v_settore_destinatario_id::VARCHAR || ' settore_indirizzo_id ' || v_settore_indirizzo_id::VARCHAR;

          
          insert into cpass_t_ord_destinatario_ordine (
             destinatario_id --UUID NOT NULL,
            ,indirizzo --VARCHAR(200),
            ,num_civico --VARCHAR(20),
            ,localita --VARCHAR(200),
            ,provincia --VARCHAR(200),
            ,cap --VARCHAR(5),
            ,contatto --VARCHAR(200),
            ,email --VARCHAR(50),
            ,telefono --VARCHAR(50),
            --,data_invio_nso --TIMESTAMP WITHOUT TIME ZONE,
            ,settore_destinatario_id --UUID,
            ,testata_ordine_id --UUID NOT NULL,
            ,progressivo --INTEGER NOT NULL,
            ,utente_creazione --VARCHAR(250) NOT NULL,
            ,utente_modifica-- VARCHAR(250) NOT NULL,
            --,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
            --,utente_cancellazione --VARCHAR(250),
            --,stato_nso_id --INTEGER,
            ,settore_indirizzo_codice --VARCHAR(50),
            ,settore_indirizzo_id --INTEGER,
            ,stato_id --INTEGER, 
          )values (
             uuid_generate_v5('158e76f1-d62f-5b8a-940e-516d0b92f14d', recDestinatarioOrdine.ordine_anno  ||'-' || recDestinatarioOrdine.ordine_numero || '-' || recDestinatarioOrdine.progressivo_riga ||'-'|| recDestinatarioOrdine.progressivo_dest)
            ,recDestinatarioOrdine.indirizzo_destinatario --VARCHAR(200),
            ,''--num_civico --VARCHAR(20),
            ,recDestinatarioOrdine.localita_destinatario --VARCHAR(200),
            ,recDestinatarioOrdine.prov_destinatario --VARCHAR(200),
            ,recDestinatarioOrdine.cap_destinatario --VARCHAR(5),
            ,recDestinatarioOrdine.contatto_destinatario --VARCHAR(200),
            ,''--email --VARCHAR(50),
            ,''--telefono --VARCHAR(50),
            --,data_invio_nso --TIMESTAMP WITHOUT TIME ZONE,
            
            ,v_settore_destinatario_id --UUID,--dastinatario
            ,v_testata_ordine_id --UUID NOT NULL,
            
            ,recDestinatarioOrdine.progressivo_dest --INTEGER NOT NULL,
            ,recDestinatarioOrdine.utente_creazione --VARCHAR(250) NOT NULL,
            ,recDestinatarioOrdine.utente_modifica-- VARCHAR(250) NOT NULL,
            --,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
            --,utente_cancellazione --VARCHAR(250),
            --,stato_nso_id --INTEGER,
            ,''--settore_indirizzo_codice --VARCHAR(50),    -- usare il principale
            ,v_settore_indirizzo_id --INTEGER,
            ,v_stato_id --INTEGER, 
          );
            
          strMessaggio:='fine loop';
          raise notice 'strMessaggio=%  ', strMessaggio;
          update appoggio_ordine_righe_dest set esito = 'OK' where id = recDestinatarioOrdine.id;
      exception
        when others  THEN
          raise notice 'strMessaggio=%  ', strMessaggio;
          raise notice '% % Errore DB % %',strMessaggioFinale,coalesce(strMessaggio,''),SQLSTATE,substring(upper(SQLERRM) from 1 for 2500);
          messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'Errore DB '||SQLSTATE||' '||substring(upper(SQLERRM) from 1 for 2500) ;
          codiceRisultato:=-1;
      END;
    end loop;
    
	codiceRisultato:=0;
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

select * from pck_cpass_ord_caricamento_dest_ordine();


 
/*

            select * from appoggio_ordine_righe_dest  where destinatario = 'PAR';
            
            delete from cpass_t_ord_riga_ordine where utente_creazione !='AAAAAA00A11B000J';
            delete from cpass_t_ord_destinatario_ordine where utente_creazione !='AAAAAA00A11B000J';
--CTE non è più gestito su cpass, quindi decodificalo come EVT
--mentre EVX da noi si chiama EPS



--update appoggio_ordine_righe_dest set stato  = 'EVT' where stato = 'CET';
--update appoggio_ordine_righe_dest set stato  = 'EPS' where stato = 'EVX';
          */
          
          
      
/*

            select * from appoggio_ordine_righe_dest  where destinatario = 'PAR';
            
            delete from cpass_t_ord_riga_ordine where utente_creazione !='AAAAAA00A11B000J';
            delete from cpass_t_ord_destinatario_ordine where utente_creazione !='AAAAAA00A11B000J';
--CTE non è più gestito su cpass, quindi decodificalo come EVT
--mentre EVX da noi si chiama EPS



--update appoggio_ordine_righe_dest set stato  = 'EVT' where stato = 'CET';
--update appoggio_ordine_righe_dest set stato  = 'EPS' where stato = 'EVX';
          */
