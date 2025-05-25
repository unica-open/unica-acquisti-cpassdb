---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_caricamento_ordine (
  in  p_ente_code     varchar,
  out codicerisultato integer,
  out messaggiorisultato varchar
)
RETURNS record AS
$body$
DECLARE
	strMessaggio       				VARCHAR(1500):='';
	strMessaggioFinale 				VARCHAR(1500):='';
    recTestataOrdine    			record;
	v_settore_emittente_id 			UUID;
	v_settore_emittente_id_str 		VARCHAR(200);
    v_tipo_ordine_id       			INTEGER; 
    v_fornitore_id       			UUID; 
    v_tipo_procedura_id         	INTEGER;
	v_utente_compilatore_nome		VARCHAR(500);
	v_utente_compilatore_cognome    VARCHAR(500);
    v_utente_compilatore_id         UUID;
    v_stato_id						INTEGER;
    v_settore_interventi_id         INTEGER; 
    v_provvedimento_tipo_codice     VARCHAR :='';
BEGIN
	codiceRisultato:=1;
    messaggioRisultato:=null;
	strMessaggioFinale:='Ribaltamento testate ordini ';

	for recTestataOrdine in(
	select  
      	id
        ,tipo_ordine --VARCHAR(3),
        ,ordine_anno --INTEGER,
        ,ordine_numero --INTEGER,
        ,fornitore::varchar --INTEGER,
        ,tipo_procedura --VARCHAR(3),
        ,numero_procedura --VARCHAR(50),
        ,data_emissione --TIMESTAMP WITHOUT TIME ZONE,
        ,data_conferma --TIMESTAMP WITHOUT TIME ZONE,
        ,data_autorizzazione --TIMESTAMP WITHOUT TIME ZONE,
        ,totale_no_iva --NUMERIC(13,5),
        ,totale_con_iva --NUMERIC(13,5),
        ,descrizione_acquisto --VARCHAR(150),
        ,consegna_riferimento --VARCHAR(200),
        ,consegna_data_da --TIMESTAMP WITHOUT TIME ZONE,
        ,consegna_data_a --TIMESTAMP WITHOUT TIME ZONE,
        ,consegna_indirizzo --VARCHAR(50),
        ,consegna_cap --VARCHAR(5),
        ,consegna_localita --VARCHAR(50),
        ,provvedimento_anno --INTEGER,
        ,to_number(provvedimento_numero)::VARCHAR  provvedimento_numero --VARCHAR(10),
        ,lotto_anno --INTEGER,
        ,lotto_numero --INTEGER,
        ,UPPER (utente_compilatore) utente_compilatore --VARCHAR(50),
        ,upper( SUBSTRING (utente_compilatore,1, POSITION('-' In utente_compilatore)-1) ) utente_compilatore_cognome
        ,upper( SUBSTRING (utente_compilatore,POSITION('-' In utente_compilatore)+1,LENGTH(utente_compilatore))) utente_compilatore_nome
        ,settore_emittente --VARCHAR(50),
        ,stato --VARCHAR(50),
        ,note --VARCHAR(4000),
        ,data_creazione --TIMESTAMP WITHOUT TIME ZONE,
        ,utente_creazione --VARCHAR(50),
        ,data_modifica --TIMESTAMP WITHOUT TIME ZONE,
        ,utente_modifica --VARCHAR(50),
        ,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
        ,utente_cancellazione --VARCHAR(50),
        ,settore_interventi_tipo --VARCHAR(1)
		from appoggio_testata_ordine
        where esito is null
	)
	loop
    	strMessaggio:='inizio loop';
		raise notice  '%',strMessaggio || ' Settore Emittente '|| recTestataOrdine.settore_emittente::VARCHAR; 
        begin
          --TODO da vedere poi 
          select  settore_id ,settore_id::varchar as settore_id_str
          into strict v_settore_emittente_id , v_settore_emittente_id_str
          from cpass_t_settore 
          where settore_codice = recTestataOrdine.settore_emittente;
          strMessaggio := 'id calcolato';
          raise notice 'strMessaggio=%  ', strMessaggio;

          select tipo_ordine_id into strict v_tipo_ordine_id from cpass_d_ord_tipo_ordine where tipologia_documento_codice = recTestataOrdine.tipo_ordine;
          strMessaggio := 'v_tipo_ordine_id --> '|| v_tipo_ordine_id::VARCHAR;
          raise notice 'strMessaggio=%  ', strMessaggio;
          
          strMessaggio := 'fornitore ' || recTestataOrdine.fornitore;
          raise notice 'strMessaggio=%  ', strMessaggio;
          select fornitore_id into strict v_fornitore_id from cpass_t_fornitore where codice = recTestataOrdine.fornitore;
          strMessaggio := 'v_fornitore_id ' || v_fornitore_id::VARCHAR;
          raise notice 'strMessaggio=%  ', strMessaggio;

          
          strMessaggio := 'parametro recTestataOrdine.tipo_procedura ' || recTestataOrdine.tipo_procedura;
          raise notice 'strMessaggio=%  ', strMessaggio;
          select tipo_procedura_id into strict v_tipo_procedura_id from cpass_d_ord_tipo_procedura where tipo_procedura_codice = recTestataOrdine.tipo_procedura;
          strMessaggio := 'v_tipo_procedura_id ' || v_tipo_procedura_id::VARCHAR;
          raise notice 'strMessaggio=%  ', strMessaggio;
          
          strMessaggio := 'provvedimento_anno ' || recTestataOrdine.provvedimento_anno|| ' provvedimento numero  ' || recTestataOrdine.provvedimento_numero;
          raise notice 'strMessaggio=%  ', strMessaggio;

          --select cpass_d_provvedimento_tipo.provvedimento_tipo_codice
          --into  strict v_provvedimento_tipo_codice
          --into  v_provvedimento_tipo_codice
          --from  cpass_t_provvedimento ,cpass_d_provvedimento_tipo
          --where cpass_t_provvedimento.provvedimento_tipo_id =  cpass_d_provvedimento_tipo.provvedimento_tipo_id
          --    and cpass_t_provvedimento.provvedimento_anno      =  recTestataOrdine.provvedimento_anno 
          --    and cpass_t_provvedimento.provvedimento_numero    =  recTestataOrdine.provvedimento_numero;
          --strMessaggio := 'v_provvedimento_tipo_codice ' || v_provvedimento_tipo_codice;
          --raise notice 'strMessaggio=%  ', strMessaggio;


          --PER TEST E DEV SCHIANTO DEMO 21

          strMessaggio := 'nome ' || recTestataOrdine.utente_compilatore_nome || ' cognome ' || recTestataOrdine.utente_compilatore_cognome;
          raise notice 'strMessaggio=%  ', strMessaggio;
          --select utente_id into strict v_utente_compilatore_id from cpass_t_utente 
          --where UPPER(utente_nome) = recTestataOrdine.utente_compilatore_nome
          --  and UPPER(utente_cognome) = recTestataOrdine.utente_compilatore_cognome      ;
          select utente_id into strict v_utente_compilatore_id from cpass_t_utente 
          where utente_nome = 'Demo'
          and utente_cognome = '21'      ;

          strMessaggio := 'v_utente_compilatore_id ' || v_utente_compilatore_id::VARCHAR;
          raise notice 'strMessaggio=%  ', strMessaggio;
                
          select stato_id into strict v_stato_id from cpass_d_stato where stato_codice = recTestataOrdine.stato and stato_tipo = 'ORDINE';
          strMessaggio := 'v_stato_id ' || v_stato_id::VARCHAR;
          raise notice 'strMessaggio=%  ', strMessaggio;

          select  settore_interventi_id 
          into strict v_settore_interventi_id
          from cpass_d_pba_settore_interventi 
          where settore_interventi_codice = recTestataOrdine.settore_interventi_tipo;

          strMessaggio := 'FINE DECODIFICHE INIZIO INSERT';
          raise notice 'strMessaggio=%  ', strMessaggio;		

          insert into cpass_t_ord_testata_ordine (
                  testata_ordine_id
                  ,tipo_ordine_id --INTEGER NOT NULL,
                  ,ordine_anno --INTEGER NOT NULL,
                  ,ordine_numero --INTEGER NOT NULL,
                  ,fornitore_id --UUID NOT NULL,
                  ,tipo_procedura_id --INTEGER NOT NULL,
                  ,numero_procedura --VARCHAR(50),
                  ,data_emissione --TIMESTAMP WITHOUT TIME ZONE NOT NULL,
                  ,data_conferma --TIMESTAMP WITHOUT TIME ZONE,
                  ,data_autorizzazione --TIMESTAMP WITHOUT TIME ZONE,
                  
                  ,totale_no_iva --NUMERIC(13,5),
                  ,totale_con_iva --NUMERIC(13,5),
                  ,descrizione_acquisto --VARCHAR(150) NOT NULL,
                  ,consegna_riferimento --VARCHAR(200),
                  ,consegna_data_da --TIMESTAMP WITHOUT TIME ZONE,
                  ,consegna_data_a --TIMESTAMP WITHOUT TIME ZONE,
                  ,consegna_indirizzo --VARCHAR(50),
                  ,consegna_cap --VARCHAR(5),
                  ,consegna_localita --VARCHAR(50),
                  ,provvedimento_anno --INTEGER,
                  
                  ,provvedimento_numero --VARCHAR(10),
                  ,lotto_anno --INTEGER,
                  ,lotto_numero --INTEGER,
                  ,utente_compilatore_id --UUID NOT NULL,
                  ,settore_emittente_id --UUID NOT NULL,
                  --,ufficio_id --INTEGER,
                  ,stato_id --INTEGER,
                  ,note --VARCHAR(4000),
                  --,data_scadenza --TIMESTAMP WITHOUT TIME ZONE,
                  ,utente_creazione --VARCHAR(250) NOT NULL,
                  ,utente_modifica --VARCHAR(250) NOT NULL,
                  --,stato_nso_id --INTEGER,
                  
                  ,data_annullamento --TIMESTAMP WITHOUT TIME ZONE,
                  ,settore_interventi_id --INTEGER,
                  ,provvedimento_tipo --VARCHAR(50),
                  
                  --,provvedimento_settore --VARCHAR(50),
                  --,provvedimento_descrizione --VARCHAR(200),
                  --,scarico_mepa_testata_id --INTEGER,
                  --,cig --VARCHAR(10),
                  --,motivi_esclusione_id --INTEGER,
            )values (
                   uuid_generate_v5('936d19b9-658d-5298-b93c-6e5717818816', recTestataOrdine.ordine_anno  ||'-' || recTestataOrdine.ordine_numero || '-' || v_settore_emittente_id_str)
                  ,v_tipo_ordine_id 
                  ,recTestataOrdine.ordine_anno 
                  ,recTestataOrdine.ordine_numero 
                  ,v_fornitore_id
                  ,v_tipo_procedura_id
                  ,recTestataOrdine.numero_procedura
                  ,recTestataOrdine.data_emissione
                  ,recTestataOrdine.data_conferma 
                  ,recTestataOrdine.data_autorizzazione
                  
                  ,recTestataOrdine.totale_no_iva
                  ,recTestataOrdine.totale_con_iva
                  ,recTestataOrdine.descrizione_acquisto
                  ,recTestataOrdine.consegna_riferimento 
                  ,recTestataOrdine.consegna_data_da
                  ,recTestataOrdine.consegna_data_a
                  ,recTestataOrdine.consegna_indirizzo 
                  ,recTestataOrdine.consegna_cap
                  ,recTestataOrdine.consegna_localita 
                  ,recTestataOrdine.provvedimento_anno 
                  
                  ,recTestataOrdine.provvedimento_numero 
                  ,recTestataOrdine.lotto_anno 
                  ,recTestataOrdine.lotto_numero 
                  ,v_utente_compilatore_id
                  ,v_settore_emittente_id
                  --,ufficio_id
                  ,v_stato_id
                  ,recTestataOrdine.note 
                  --,recTestataOrdine.data_scadenza
                  ,recTestataOrdine.utente_compilatore
                  ,recTestataOrdine.utente_modifica
                  --,stato_nso_id
                  ,recTestataOrdine.data_cancellazione
                  ,v_settore_interventi_id
                  
                  ,'32'--v_provvedimento_tipo_codice
                  --,recTestataOrdine.provvedimento_settore
                  --,recTestataOrdine.provvedimento_descrizione
                  --,scarico_mepa_testata_id
                  --,recTestataOrdine.cig
                  --,motivi_esclusione_id 
            );
            
  	

          strMessaggio:='fine loop';
          raise notice 'strMessaggio=%  ', strMessaggio;
          update appoggio_testata_ordine set esito = 'OK' where id = recTestataOrdine.id;
      exception
        when others  THEN
          raise notice '% % Errore DB % %',strMessaggioFinale,coalesce(strMessaggio,''),SQLSTATE,substring(upper(SQLERRM) from 1 for 2500);
          messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'Errore DB '||SQLSTATE||' '||substring(upper(SQLERRM) from 1 for 2500) ;
          codiceRisultato:=-1;
      END;
    end loop;
    
    delete from cpass_t_progressivo where  progressivo_tipo = 'ORDINE.TESTATA';
	insert into cpass_t_progressivo 
	select 
	  'ORDINE.TESTATA' as tipo
	  ,p_ente_code || '-' || cpass_t_ord_testata_ordine.ordine_anno as chiave
	  ,max(cpass_t_ord_testata_ordine.ordine_numero) 
	  ,cpass_t_ente.ente_id
	from 
		cpass_t_ord_testata_ordine
		,cpass_t_settore
		,cpass_t_ente
	where 
	    cpass_t_ord_testata_ordine.settore_emittente_id= cpass_t_settore.settore_id
	and	cpass_t_settore.ente_id = cpass_t_ente.ente_id
	and cpass_t_ente.ente_codice= p_ente_code
	group by 
	  tipo
	  ,chiave
	  ,cpass_t_ente.ente_id
	order by chiave;

	codiceRisultato:=0;
    messaggioRisultato:=strMessaggioFinale||' FINE';
    return;

exception
    when RAISE_EXCEPTION THEN
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

select * from pck_cpass_ord_caricamento_ordine('CMTO');


