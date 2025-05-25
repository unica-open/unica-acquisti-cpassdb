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

CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_caricamento_evasione (
  in  p_ente_code     varchar,
  out codicerisultato integer,
  out messaggiorisultato varchar
)
RETURNS record AS
$body$
DECLARE
	strMessaggio       				VARCHAR(1500):='';
	strMessaggioFinale 				VARCHAR(1500):='';
    recTestataEvasione    			record;
	v_settore_id 					UUID;
	v_settore_id_str 				VARCHAR(200);
    v_tipo_evasione_id       		INTEGER; 
    v_fornitore_id       			UUID; 
    v_tipo_procedura_id         	INTEGER;
	v_utente_compilatore_nome		VARCHAR(500);
	v_utente_compilatore_cognome    VARCHAR(500);
    v_utente_compilatore_id         UUID;
    v_stato_id						INTEGER;
    v_settore_interventi_id         INTEGER; 
    v_provvedimento_tipo_codice     VARCHAR :='';
BEGIN
	codiceRisultato:=0;
    messaggioRisultato:=null;
	strMessaggioFinale:='Ribaltamento testate evasioni ';

	for recTestataEvasione in(
	select  
      	id
        ,evasione_anno --INTEGER,
        ,evasione_numero --INTEGER,
        ,fornitore --INTEGER,
        ,data_inserimento --TIMESTAMP WITHOUT TIME ZONE,
        ,settore_competente --VARCHAR(50),
        ,stato --VARCHAR(50),
        ,totale_con_iva --NUMERIC(13,5),
        ,utente_compilatore --VARCHAR(50),

        ,descrizione --VARCHAR(150),
        ,data_conferma --TIMESTAMP WITHOUT TIME ZONE,
        ,data_ripartizione --TIMESTAMP WITHOUT TIME ZONE,
        ,data_autorizzazione --TIMESTAMP WITHOUT TIME ZONE,
        ,fattura_anno --INTEGER,
        ,fattura_numero --VARCHAR(200),
        ,fattura_tipo --VARCHAR(10),
        ,fattura_codice --VARCHAR(50),
        ,fattura_protocollo_anno --INTEGER,
        ,fattura_protocollo_numero --INTEGER,

        ,fattura_totale --NUMERIC(13,5),
        ,fattura_totale_liquidabile --NUMERIC(13,5),
        ,data_consegna --TIMESTAMP WITHOUT TIME ZONE,
        ,documento_consegna --VARCHAR(200),
        ,documento_data_consegna --TIMESTAMP WITHOUT TIME ZONE,
        ,tipo_evasione --VARCHAR(5),
        ,data_creazione --TIMESTAMP WITHOUT TIME ZONE,
        ,utente_creazione --VARCHAR(50),
        ,data_modifica --TIMESTAMP WITHOUT TIME ZONE,

        ,utente_modifica --VARCHAR(50),
        ,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
        ,utente_cancellazione --VARCHAR(50),
        ,data_invio_contabilita --TIMESTAMP WITHOUT TIME ZONE
	from appoggio_testata_evasione
        where esito is null
	)
	loop
    	strMessaggio:='inizio loop';

    	begin
          strMessaggio := 'recTestataEvasione.settore_competente ' || recTestataEvasione.settore_competente;
          select  settore_id ,settore_id::varchar as settore_id_str
          into strict v_settore_id , v_settore_id_str
          from cpass_t_settore 
          where settore_codice = recTestataEvasione.settore_competente;

          select tipo_evasione_id into strict v_tipo_evasione_id from cpass_d_ord_tipo_evasione where tipo_evasione_codice = recTestataEvasione.tipo_evasione;
          strMessaggio := 'v_tipo_evasione_id --> '|| v_tipo_evasione_id::VARCHAR;
          
          strMessaggio := 'fornitore ' || recTestataEvasione.fornitore;
          select fornitore_id into strict v_fornitore_id from cpass_t_fornitore where codice = recTestataEvasione.fornitore::VARCHAR;
          strMessaggio := 'v_fornitore_id ' || v_fornitore_id::VARCHAR;

          
          --strMessaggio := 'parametro recTestataEvasione.tipo_procedura ' || recTestataEvasione.tipo_procedura;
          --select tipo_procedura_id into strict v_tipo_procedura_id from cpass_d_ord_tipo_procedura where tipo_procedura_codice = recTestataEvasione.tipo_procedura;
          --strMessaggio := 'v_tipo_procedura_id ' || v_tipo_procedura_id::VARCHAR;
          
          --strMessaggio := 'provvedimento_anno ' || recTestataEvasione.provvedimento_anno|| ' provvedimento numero  ' || recTestataEvasione.provvedimento_numero;

          --select cpass_d_provvedimento_tipo.provvedimento_tipo_codice
          --into  strict v_provvedimento_tipo_codice
          --into  v_provvedimento_tipo_codice
          --from  cpass_t_provvedimento ,cpass_d_provvedimento_tipo
          --where cpass_t_provvedimento.provvedimento_tipo_id =  cpass_d_provvedimento_tipo.provvedimento_tipo_id
          --    and cpass_t_provvedimento.provvedimento_anno      =  recTestataEvasione.provvedimento_anno 
          --    and cpass_t_provvedimento.provvedimento_numero    =  recTestataEvasione.provvedimento_numero;
          --strMessaggio := 'v_provvedimento_tipo_codice ' || v_provvedimento_tipo_codice;
          --raise notice 'strMessaggio=%  ', strMessaggio;


          --PER TEST E DEV SCHIANTO DEMO 21
          --strMessaggio := 'nome ' || recTestataEvasione.utente_nome || ' cognome ' || recTestataEvasione.utente_cognome;
          --select utente_id into strict v_utente_compilatore_id from cpass_t_utente 
          --where UPPER(utente_nome) = recTestataEvasione.utente_compilatore_nome
          --  and UPPER(utente_cognome) = recTestataEvasione.utente_compilatore_cognome      ;
          select utente_id into strict v_utente_compilatore_id from cpass_t_utente 
          where utente_nome = 'Demo'
          and utente_cognome = '21'      ;

          strMessaggio := 'v_utente_compilatore_id ' || v_utente_compilatore_id::VARCHAR;
                
          strMessaggio := 'recTestataEvasione.stato ' || recTestataEvasione.stato;
          select stato_id into strict v_stato_id from cpass_d_stato where stato_codice = recTestataEvasione.stato and stato_tipo = 'EVASIONE';
          strMessaggio := 'v_stato_id ' || v_stato_id::VARCHAR;

          --select  settore_interventi_id 
          --into strict v_settore_interventi_id
          --from cpass_d_pba_settore_interventi 
          --where settore_interventi_codice = recTestataEvasione.settore_interventi_tipo;

          strMessaggio := 'FINE DECODIFICHE INIZIO INSERT';

          insert into cpass_t_ord_testata_evasione (
                   testata_evasione_id
                  ,evasione_anno --INTEGER NOT NULL,
                  ,evasione_numero --INTEGER NOT NULL,
                  ,fornitore_id --UUID NOT NULL,
                  ,data_inserimento --TIMESTAMP WITHOUT TIME ZONE NOT NULL,
                  ,settore_competente_id --UUID NOT NULL,
                  ,stato_id --INTEGER,
                  --,ufficio_id --INTEGER,
                  ,totale_con_iva --NUMERIC(13,5),
                  ,utente_compilatore_id --UUID NOT NULL,
                  ,descrizione --VARCHAR(150) NOT NULL,
                  ,data_conferma --TIMESTAMP WITHOUT TIME ZONE,
                  ,data_ripartizione --TIMESTAMP WITHOUT TIME ZONE,
                  ,data_autorizzazione --TIMESTAMP WITHOUT TIME ZONE,
                  ,fattura_anno --INTEGER,
                  ,fattura_numero --VARCHAR(200),
                  ,fattura_tipo --VARCHAR(10),
                  ,fattura_codice --VARCHAR(50),
                  ,fattura_protocollo_anno --INTEGER,
                  ,fattura_protocollo_numero --INTEGER,
                  ,fattura_totale --NUMERIC(13,5),
                  ,fattura_totale_liquidabile --NUMERIC(13,5),
                  ,data_consegna --TIMESTAMP WITHOUT TIME ZONE,
                  ,documento_consegna --VARCHAR(200),
                  ,documento_data_consegna --TIMESTAMP WITHOUT TIME ZONE,
                  ,tipo_evasione_id --INTEGER,
                  --,note --VARCHAR(4000),
                  ,data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
                  ,utente_creazione-- VARCHAR(250) NOT NULL,
                  ,data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
                  ,utente_modifica-- VARCHAR(250) NOT NULL,
                  ,data_invio_contabilita --TIMESTAMP WITHOUT TIME ZONE,
                  --,documento_trasporto_id --INTEGER,
            )values (
                   uuid_generate_v5('936d19b9-658d-5298-b93c-6e5717818816', recTestataEvasione.evasione_anno  ||'-' || recTestataEvasione.evasione_numero || '-' || v_settore_id_str)
                  ,recTestataEvasione.evasione_anno --INTEGER NOT NULL,
                  ,recTestataEvasione.evasione_numero --INTEGER NOT NULL,
                  ,v_fornitore_id --UUID NOT NULL,
                  ,recTestataEvasione.data_inserimento --TIMESTAMP WITHOUT TIME ZONE NOT NULL,
                  ,v_settore_id --UUID NOT NULL,
                  ,v_stato_id --INTEGER,
                  --,ufficio_id --INTEGER,
                  ,recTestataEvasione.totale_con_iva --NUMERIC(13,5),
                  ,v_utente_compilatore_id --UUID NOT NULL,
                  ,recTestataEvasione.descrizione --VARCHAR(150) NOT NULL,
                  ,recTestataEvasione.data_conferma --TIMESTAMP WITHOUT TIME ZONE,
                  ,recTestataEvasione.data_ripartizione --TIMESTAMP WITHOUT TIME ZONE,
                  ,recTestataEvasione.data_autorizzazione --TIMESTAMP WITHOUT TIME ZONE,
                  ,recTestataEvasione.fattura_anno --INTEGER,
                  ,recTestataEvasione.fattura_numero --VARCHAR(200),
                  ,recTestataEvasione.fattura_tipo --VARCHAR(10),
                  ,recTestataEvasione.fattura_codice --VARCHAR(50),
                  ,recTestataEvasione.fattura_protocollo_anno --INTEGER,
                  ,recTestataEvasione.fattura_protocollo_numero --INTEGER,
                  ,recTestataEvasione.fattura_totale --NUMERIC(13,5),
                  ,recTestataEvasione.fattura_totale_liquidabile --NUMERIC(13,5),
                  ,recTestataEvasione.data_consegna --TIMESTAMP WITHOUT TIME ZONE,
                  ,recTestataEvasione.documento_consegna --VARCHAR(200),
                  ,recTestataEvasione.documento_data_consegna --TIMESTAMP WITHOUT TIME ZONE,
                  ,v_tipo_evasione_id --INTEGER,
                  --,note --VARCHAR(4000),
                  ,recTestataEvasione.data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
                  ,recTestataEvasione.utente_creazione-- VARCHAR(250) NOT NULL,
                  ,recTestataEvasione.data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
                  ,recTestataEvasione.utente_modifica-- VARCHAR(250) NOT NULL,
                  ,recTestataEvasione.data_invio_contabilita --TIMESTAMP WITHOUT TIME ZONE,
                  --,documento_trasporto_id --INTEGER,
            );
            
  	

          strMessaggio:='fine loop';
          --raise notice 'strMessaggio=%  ', strMessaggio;
          update appoggio_testata_evasione set esito = 'OK' where id = recTestataEvasione.id;
      exception
        when others  THEN
          raise notice '% % Errore DB % %',strMessaggioFinale,coalesce(strMessaggio,''),SQLSTATE,substring(upper(SQLERRM) from 1 for 2500);
          messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'Errore DB '||SQLSTATE||' '||substring(upper(SQLERRM) from 1 for 2500) ;
          codiceRisultato:=-1;
      END;
      codiceRisultato:= 	codiceRisultato +1 ;
  
    end loop;
    
    delete from cpass_t_progressivo where  progressivo_tipo = 'EVASIONE.TESTATA';
	insert into cpass_t_progressivo 
	select 
	  'EVASIONE.TESTATA' as tipo
	  ,p_ente_code || '-' || cpass_t_ord_testata_evasione.evasione_anno as chiave
	  ,max(cpass_t_ord_testata_evasione.evasione_numero) 
	  ,cpass_t_ente.ente_id
	from 
		cpass_t_ord_testata_evasione
		,cpass_t_settore
		,cpass_t_ente
	where 
	    cpass_t_ord_testata_evasione.settore_competente_id= cpass_t_settore.settore_id
	and	cpass_t_settore.ente_id = cpass_t_ente.ente_id
	and cpass_t_ente.ente_codice= p_ente_code
	group by 
	  tipo
	  ,chiave
	  ,cpass_t_ente.ente_id
	order by chiave;

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

select * from pck_cpass_ord_caricamento_evasione('CMTO');
          
