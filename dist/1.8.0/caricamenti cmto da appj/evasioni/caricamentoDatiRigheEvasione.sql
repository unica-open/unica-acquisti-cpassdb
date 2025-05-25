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
/*

delete from cpass_t_ord_riga_evasione where utente_creazione != 'AAAAAA00A11B000J' ;
delete from cpass_t_ord_destinatario_evasione where utente_creazione != 'AAAAAA00A11B000J' ;
delete from cpass_t_ord_testata_evasione where utente_creazione != 'AAAAAA00A11B000J' ;


update  appoggio_testata_evasione set esito = null ;
update  appoggio_righe_dest_evasione set esito = null ;
update  appoggio_righe_dest_evasione set esito_riga = null ;

*/


CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_caricamento_righe_evasione (
  cod_ente varchar,
  out codicerisultato integer,
  out messaggiorisultato varchar
)
RETURNS record AS
$body$
DECLARE
	strMessaggio       				VARCHAR(1500):='';
	strMessaggioFinale 				VARCHAR(1500):='';
    recRigaEvasione   				record;
    v_stato_id						INTEGER;
    v_utente_compilatore_id			UUID;
    v_testata_evasione_id           UUID;
    v_destinatario_evasione_id      UUID;
    v_riga_ordine_id                UUID;
    --v_settore_destinatario_id       UUID;
    --v_settore_indirizzo_id          INTEGER;
    v_aliquote_iva_id               INTEGER;
    v_oggetti_spesa_id				INTEGER;
    v_unita_misura_id				INTEGER;
BEGIN
	codiceRisultato:=0;
    messaggioRisultato:=null;
	strMessaggioFinale:='Ribaltamento righe evasioni ';

	for recRigaEvasione in(
      select  
             id 
            ,evasione_anno --INTEGER,
            ,evasione_numero --INTEGER,
            ,progressivo_riga --INTEGER,
            ,progressivo_dest --INTEGER,
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
      where esito_riga is null
	)
	loop
    	strMessaggio:='inizio loop';
        begin

          --estraggo lo stato
          strMessaggio := 'stato ' || recRigaEvasione.stato;
          select stato_id into strict v_stato_id from cpass_d_stato where stato_codice = recRigaEvasione.stato and stato_tipo = 'RIGA_EVASIONE';
          strMessaggio := 'v_stato_id ' || v_stato_id::VARCHAR;

		  --estraggo il destinatario evasione id 	
          strMessaggio := 'estraggo il destinatario evasione id anno eva ' || recRigaEvasione.evasione_anno || ' numero eva ' || recRigaEvasione.evasione_numero || ' progressivo_dest ' || recRigaEvasione.progressivo_dest;
          select cpass_t_ord_destinatario_evasione.destinatario_evasione_id 
          	into strict v_destinatario_evasione_id 
          from 
          		cpass_t_ord_testata_evasione          
          		,cpass_t_ord_destinatario_evasione 
          where           
              cpass_t_ord_testata_evasione.testata_evasione_id =  cpass_t_ord_destinatario_evasione.testata_evasione_id 
          and cpass_t_ord_testata_evasione.evasione_anno       =  recRigaEvasione.evasione_anno
          and cpass_t_ord_testata_evasione.evasione_numero     =  recRigaEvasione.evasione_numero 
          and cpass_t_ord_destinatario_evasione.progressivo    =  recRigaEvasione.progressivo_dest; 
          
          
        	--estraggo id di riga ordine	
          strMessaggio := 'anno ord ' || recRigaEvasione.ordine_anno || ' numero ord ' || recRigaEvasione.ordine_numero || ' progr_dest_ordine '|| recRigaEvasione.progr_dest_ordine ;
          select cpass_t_ord_riga_ordine.riga_ordine_id 
          into strict v_riga_ordine_id
          from 
          	cpass_t_ord_testata_ordine
          	,cpass_t_ord_destinatario_ordine
          	,cpass_t_ord_riga_ordine
          where cpass_t_ord_testata_ordine.testata_ordine_id    = cpass_t_ord_destinatario_ordine.testata_ordine_id
          and   cpass_t_ord_destinatario_ordine.destinatario_id = cpass_t_ord_riga_ordine.destinatario_id
          and   cpass_t_ord_testata_ordine.ordine_numero = recRigaEvasione.ordine_numero
          and   cpass_t_ord_testata_ordine.ordine_anno = recRigaEvasione.ordine_anno
          and   cpass_t_ord_destinatario_ordine.progressivo = recRigaEvasione.progr_dest_ordine 
          and   cpass_t_ord_riga_ordine.progressivo = recRigaEvasione.progr_riga_ordine; 
          

          
          
		  --estraggo aliquota iva
          strMessaggio := 'IVA ' || recRigaEvasione.aliquota_iva;
          select aliquote_iva_id
          into strict  v_aliquote_iva_id
          from cpass_d_aliquote_iva
          where cpass_d_aliquote_iva.aliquote_iva_codice = recRigaEvasione.aliquota_iva;
          strMessaggio := 'v_aliquote_iva_id ' || v_aliquote_iva_id::VARCHAR;

          strMessaggio := 'oggetto_spesa ' || recRigaEvasione.oggetto_spesa;
          select oggetti_spesa_id
          into strict  v_oggetti_spesa_id
          from cpass_d_oggetti_spesa
          where lpad (oggetti_spesa_codice,6,'0') = lpad(recRigaEvasione.oggetto_spesa,6,'0');
          strMessaggio := 'v_oggetti_spesa_id ' || v_oggetti_spesa_id::VARCHAR;

          strMessaggio := 'prima di inserire destinatario_evasione_id ' || v_destinatario_evasione_id::VARCHAR;

          insert into cpass_t_ord_riga_evasione (
               riga_evasione_id --UUID NOT NULL,
              ,progressivo --INTEGER NOT NULL,
              ,importo_totale --NUMERIC(13,5),
              ,prezzo_unitario --NUMERIC(13,5),
              ,destinatario_evasione_id --UUID NOT NULL,
              ,riga_ordine_id --UUID NOT NULL,
              ,aliquote_iva_id --INTEGER NOT NULL,
              ,oggetti_spesa_id --INTEGER NOT NULL,
              --,listino_fornitore_id --INTEGER,
              ,data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
              ,utente_creazione --VARCHAR(250) NOT NULL,
              ,data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
              ,utente_modifica --VARCHAR(250) NOT NULL,
              --note VARCHAR(4000),
              ,quantita_evasa --NUMERIC(8,2),
              ,stato_id --INTEGER,
          )values (
              uuid_generate_v5('78e0b3d0-1779-52e5-ae04-e95f047a56f8', recRigaEvasione.evasione_anno  ||'-' || recRigaEvasione.evasione_numero || '-' || recRigaEvasione.progressivo_riga ||'-'|| recRigaEvasione.progressivo_dest)
              ,recRigaEvasione.progressivo_riga --INTEGER NOT NULL,
              ,recRigaEvasione.importo_totale --NUMERIC(13,5),
              ,recRigaEvasione.prezzo_unitario --NUMERIC(13,5),
              
              ,v_destinatario_evasione_id --UUID NOT NULL,
              ,v_riga_ordine_id --UUID NOT NULL,
             
              ,v_aliquote_iva_id --INTEGER NOT NULL,
              ,v_oggetti_spesa_id --INTEGER NOT NULL,
              --,listino_fornitore_id --INTEGER,
              ,recRigaEvasione.data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
              ,recRigaEvasione.utente_creazione --VARCHAR(250) NOT NULL,
              ,recRigaEvasione.data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
              ,recRigaEvasione.utente_modifica --VARCHAR(250) NOT NULL,
              --note VARCHAR(4000),
              ,recRigaEvasione.quantita_evasa --NUMERIC(8,2),           
              ,v_stato_id --INTEGER,
          );
            
          strMessaggio:='fine loop';
          update appoggio_ordine_righe_dest set esito_righe = 'OK' where id = recRigaEvasione.id;
      exception
        when others  THEN
          raise notice '% % Errore DB % %',strMessaggioFinale,coalesce(strMessaggio,''),SQLSTATE,substring(upper(SQLERRM) from 1 for 2500);
          messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'Errore DB '||SQLSTATE||' '||substring(upper(SQLERRM) from 1 for 2500) ;
      END;
      
      codiceRisultato := codiceRisultato + 1 ;
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


select * from pck_cpass_ord_caricamento_righe_evasione('CMTO');
