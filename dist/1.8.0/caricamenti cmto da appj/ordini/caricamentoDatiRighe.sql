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

CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_caricamento_righe_ordine (
  out codicerisultato integer,
  out messaggiorisultato varchar
)
RETURNS record AS
$body$
DECLARE
	strMessaggio       				VARCHAR(1500):='';
	strMessaggioFinale 				VARCHAR(1500):='';
    recRigaOrdine    				record;
    v_stato_id						INTEGER;
    v_utente_compilatore_id			UUID;
    v_testata_ordine_id             UUID;
    v_destinatario_ordine_id        UUID;
    v_settore_destinatario_id       UUID;
    v_settore_indirizzo_id          INTEGER;
    v_aliquote_iva_id               INTEGER;
    v_oggetti_spesa_id				INTEGER;
    v_unita_misura_id				INTEGER;
BEGIN
	codiceRisultato:=1;
    messaggioRisultato:=null;
	strMessaggioFinale:='Ribaltamento testate ordini ';

	for recRigaOrdine in(
      select  
          id 
          ,ordine_anno --INTEGER,
          ,ordine_numero --INTEGER,
          ,progressivo_riga --INTEGER,
          ,progressivo_dest --INTEGER,
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
          where esito_righe is null
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
          --raise notice 'strMessaggio=%  ', strMessaggio;
     
          --estraggo lo stato
          strMessaggio := 'stato ' || recRigaOrdine.stato;
          --raise notice 'strMessaggio=%  ', strMessaggio;
          select stato_id into strict v_stato_id from cpass_d_stato where stato_codice = recRigaOrdine.stato and stato_tipo = 'RIGA_ORDINE';
          strMessaggio := 'v_stato_id ' || v_stato_id::VARCHAR;
          --raise notice 'strMessaggio=%  ', strMessaggio;

		  --estraggo id di testata ordine	
          strMessaggio := 'anno ' || recRigaOrdine.ordine_anno || ' numero ' || recRigaOrdine.ordine_numero;
          select testata_ordine_id 
          into strict v_testata_ordine_id 
          from cpass_t_ord_testata_ordine 
          where ordine_anno   = recRigaOrdine.ordine_anno 
          and ordine_numero   = recRigaOrdine.ordine_numero;

          strMessaggio := 'anno ' || recRigaOrdine.ordine_anno || ' numero ' || recRigaOrdine.ordine_numero || ' progressivo_dest ' || recRigaOrdine.progressivo_dest;
          select destinatario_id 
          into strict v_destinatario_ordine_id 
          from cpass_t_ord_destinatario_ordine 
          where testata_ordine_id   = v_testata_ordine_id
          and progressivo     = recRigaOrdine.progressivo_dest; 
          
          strMessaggio := 'v_testata_ordine_id ' || v_testata_ordine_id::VARCHAR;
          --raise notice 'strMessaggio=%  ', strMessaggio;


          select cpass_t_settore.settore_id 
          		 ,cpass_t_settore_indirizzo.settore_indirizzo_id
          into strict v_settore_destinatario_id ,v_settore_indirizzo_id
          from 	 cpass_t_settore 
          		,cpass_t_settore_indirizzo 
          where 
          		cpass_t_settore.settore_id = cpass_t_settore_indirizzo.settore_id 
			and cpass_t_settore_indirizzo.principale = true
            and cpass_t_settore.settore_codice = recRigaOrdine.destinatario;
            
          strMessaggio := 'v_settore_destinatario_id ' || v_settore_destinatario_id::VARCHAR;
          --raise notice 'strMessaggio=%  ', strMessaggio;
       
          strMessaggio := 'settore_indirizzo_id ' || v_settore_indirizzo_id::VARCHAR;
          --raise notice 'strMessaggio=%  ', strMessaggio;

          select aliquote_iva_id
          into strict  v_aliquote_iva_id
          from cpass_d_aliquote_iva
          where cpass_d_aliquote_iva.aliquote_iva_codice = recRigaOrdine.aliquota_iva;
          strMessaggio := 'v_aliquote_iva_id ' || v_aliquote_iva_id::VARCHAR;
          --raise notice 'strMessaggio=%  ', strMessaggio;
          
          
          strMessaggio := 'unita_misura ' || recRigaOrdine.unita_misura;
          --raise notice 'strMessaggio=%  ', strMessaggio;
          select unita_misura_id
          into strict  v_unita_misura_id
          from cpass_d_unita_misura
          where cpass_d_unita_misura.unita_misura_codice = recRigaOrdine.unita_misura;
          strMessaggio := 'v_unita_misura_id ' || v_unita_misura_id::VARCHAR;
          --raise notice 'strMessaggio=%  ', strMessaggio;

          strMessaggio := 'oggetto_spesa ' || recRigaOrdine.oggetto_spesa;
          --raise notice 'strMessaggio=%  ', strMessaggio;
          select oggetti_spesa_id
          into strict  v_oggetti_spesa_id
          from cpass_d_oggetti_spesa
          where oggetti_spesa_codice = recRigaOrdine.oggetto_spesa;
          strMessaggio := 'oggetto_spesa ' || v_oggetti_spesa_id::VARCHAR;
          --raise notice 'strMessaggio=%  ', strMessaggio;
          
          insert into cpass_t_ord_riga_ordine (
               riga_ordine_id --UUID NOT NULL,
              --,consegna_parziale --BOOLEAN,
              ,progressivo --INTEGER,
              ,prezzo_unitario --NUMERIC(13,5),
              ,quantita --NUMERIC(8,2),
              ,percentuale_sconto --NUMERIC(8,5),
              ,importo_sconto --NUMERIC(8,5),
              ,percentuale_sconto2 --NUMERIC(8,5),
              ,importo_sconto2 --NUMERIC(8,5),
              ,importo_netto --NUMERIC(13,5),
              ,importo_iva --NUMERIC(13,5),
              ,importo_totale --NUMERIC(13,5),
              --,note --VARCHAR(4000),
              ,oggetti_spesa_id --INTEGER NOT NULL,
              ,unita_misura_id --INTEGER NOT NULL,
              ,aliquote_iva_id --INTEGER NOT NULL,
              ,destinatario_id --UUID NOT NULL,
              ,data_creazione --TIMESTAMP WITHOUT TIME ZONE NOT NULL,
              ,utente_creazione-- VARCHAR(250) NOT NULL,
              ,utente_modifica --VARCHAR(250) NOT NULL,
              --,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
              --,utente_cancellazione --VARCHAR(250),
              --,listino_fornitore_id --INTEGER,
              ,stato_id --INTEGER,
          )values (
              uuid_generate_v5('78e0b3d0-1779-52e5-ae04-e95f047a56f8', recRigaOrdine.ordine_anno  ||'-' || recRigaOrdine.ordine_numero || '-' || recRigaOrdine.progressivo_riga ||'-'|| recRigaOrdine.progressivo_dest)
			  --,consegna_parziale --BOOLEAN,
              ,recRigaOrdine.progressivo_riga --INTEGER,
              ,recRigaOrdine.prezzo_unitario --NUMERIC(13,5),
              ,recRigaOrdine.quantita --NUMERIC(8,2),
              ,recRigaOrdine.percentuale_sconto --NUMERIC(8,5),
              ,recRigaOrdine.importo_sconto --NUMERIC(8,5),
              ,recRigaOrdine.percentuale_sconto2 --NUMERIC(8,5),
              ,recRigaOrdine.importo_sconto2 --NUMERIC(8,5),
              ,recRigaOrdine.importo_netto --NUMERIC(13,5),
              ,recRigaOrdine.importo_iva --NUMERIC(13,5),
              ,recRigaOrdine.importo_totale --NUMERIC(13,5),
              --,note --VARCHAR(4000),          
              ,v_oggetti_spesa_id --INTEGER NOT NULL,
              ,v_unita_misura_id --INTEGER NOT NULL,           
              ,v_aliquote_iva_id --INTEGER NOT NULL,
              ,v_destinatario_ordine_id --UUID NOT NULL,
              ,recRigaOrdine.data_creazione --TIMESTAMP WITHOUT TIME ZONE NOT NULL,
              ,recRigaOrdine.utente_creazione-- VARCHAR(250) NOT NULL,
              ,recRigaOrdine.utente_modifica --VARCHAR(250) NOT NULL,
              --,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
              --,utente_cancellazione --VARCHAR(250),
              --,listino_fornitore_id --INTEGER,
              ,v_stato_id --INTEGER,
          );
            
          strMessaggio:='fine loop';
          raise notice 'strMessaggio=%  ', strMessaggio;
          update appoggio_ordine_righe_dest set esito_righe = 'OK' where id = recRigaOrdine.id;
      exception
        when others  THEN
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

select * from pck_cpass_ord_caricamento_righe_ordine();





select testata_ordine_id from 
cpass_t_ord_testata_ordine
where
ordine_anno = 2017 
and ordine_numero =  14; 

select * from 
cpass_t_ord_destinatario_ordine
where
testata_ordine_id in(
  select testata_ordine_id from 
  cpass_t_ord_testata_ordine
  where
  ordine_anno = 2017 
  and ordine_numero =  14
)

--progressivo_dest 1 

--select * from cpass_d_stato where stato_tipo = 'RIGA_ORDINE'




/*

--select * from cpass_t_ord_riga_ordine;


alter table appoggio_ordine_righe_dest add column esito_righe varchar(20);



select * from cpass_d_unita_misura
where unita_misura_codice in(
    select DISTINCT(unita_misura) from appoggio_ordine_righe_dest
    where unita_misura is not null
)
;



update appoggio_ordine_righe_dest set unita_misura = 'C62' where unita_misura = 'NR'; 	
update appoggio_ordine_righe_dest set unita_misura = 'LTR' where unita_misura = 'LT';
update appoggio_ordine_righe_dest set unita_misura = 'MTR' where unita_misura = 'MT';
update appoggio_ordine_righe_dest set unita_misura = 'KGM' where unita_misura = 'KG';
update appoggio_ordine_righe_dest set unita_misura = 'GRM' where unita_misura = 'GR';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'FG';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'CO';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'C1';

update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'C2';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'C3';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'C4';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'C5';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'C6';
update appoggio_ordine_righe_dest set unita_misura = 'RM' where unita_misura = 'RS';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'C7';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'C8';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'C9';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'C0';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'CZ';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'CA';
update appoggio_ordine_righe_dest set unita_misura = 'XPK' where unita_misura = 'CF';

update appoggio_ordine_righe_dest set unita_misura = 'BQL' where unita_misura is null;


select * from appoggio_ordine_righe_dest where 
appoggio_ordine_righe_dest.ordine_anno = 2017
and appoggio_ordine_righe_dest.ordine_numero = 14;




select * from appoggio_ordine_righe_dest where 
esito is not null 
and dest_nuovo_esistente ='NUOVO';

*/


