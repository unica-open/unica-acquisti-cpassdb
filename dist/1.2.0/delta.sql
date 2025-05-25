---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================

create table if not exists cpass.CPASS_T_FLUSSO_IMPEGNI_ESTERNI(
  flusso_impegni_esterni_id SERIAL,
  elaborazione_id INTEGER,
  id_ente UUID,
  ente_codice VARCHAR(50),
  bil_anno VARCHAR(50),
  anno_impegno VARCHAR(50),
  num_impegno VARCHAR(50),
  desc_impegno VARCHAR(500),
  cod_impegno VARCHAR(50),
  cod_stato_impegno VARCHAR(50),
  desc_stato_impegno VARCHAR(500),
  data_scadenza VARCHAR(50),
  parere_finanziario VARCHAR(500),
  cod_capitolo VARCHAR(50),
  cod_articolo VARCHAR(50),
  cod_ueb VARCHAR(50),
  desc_capitolo VARCHAR(4000),
  desc_articolo VARCHAR(500),
  cod_soggetto VARCHAR(50),
  desc_soggetto VARCHAR(500),
  cf_soggetto VARCHAR(50),
  cf_estero_soggetto VARCHAR(50),
  p_iva_soggetto VARCHAR(50),
  cod_classe_soggetto VARCHAR(500),
  desc_classe_soggetto VARCHAR(500),
  cod_tipo_impegno VARCHAR(50),
  desc_tipo_impegno VARCHAR(3980),
  annoriaccertato VARCHAR(500),
  numriaccertato VARCHAR(50),
  anno_atto_amministrativo VARCHAR(500),
  num_atto_amministrativo VARCHAR(50),
  oggetto_atto_amministrativo VARCHAR(500),
  cod_tipo_atto_amministrativo VARCHAR(50),
  cod_cdr_atto_amministrativo VARCHAR(50),
  desc_cdr_atto_amministrativo VARCHAR(500),
  cod_cdc_atto_amministrativo VARCHAR(50),
  desc_cdc_atto_amministrativo VARCHAR(500),
  importo_iniziale VARCHAR(50),
  importo_attuale VARCHAR(50),
  importo_utilizzabile VARCHAR(50),
  cig VARCHAR(50),
  cup VARCHAR(50),
  importo_liquidato VARCHAR(50),
  data_elaborazione VARCHAR(50),
  num_elaborazione_di_giornata VARCHAR(3),
  esito VARCHAR(100),
  errore VARCHAR(4000),
  data_caricamento TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  CONSTRAINT cpass_t_flusso_impegni_esterni_pkey PRIMARY KEY(flusso_impegni_esterni_id)
);

create table if not exists cpass.cpass_T_FLUSSO_SUBIMPEGNI_ESTERNI(
  FLUSSO_SUBIMPEGNI_ESTERNI_ID SERIAL,
  elaborazione_id INTEGER,
  id_ente UUID,
  ente_codice VARCHAR(50),
  bil_anno VARCHAR(50),
  anno_impegno VARCHAR(50),
  num_impegno VARCHAR(50),
  cod_subimpegno VARCHAR(50),
  desc_subimpegno VARCHAR(500),
  cod_stato_subimpegno VARCHAR(50),
  cod_soggetto VARCHAR(50),
  desc_soggetto VARCHAR(500),
  cf_soggetto VARCHAR(50),
  cf_estero_soggetto VARCHAR(50),
  p_iva_soggetto VARCHAR(50),
  cod_classe_soggetto VARCHAR(50),
  desc_classe_soggetto VARCHAR(500),
  cod_tipo_impegno VARCHAR(50),
  desc_tipo_impegno VARCHAR(500),
  annoriaccertato VARCHAR(50),
  numriaccertato VARCHAR(50),
  anno_atto_amministrativo VARCHAR(50),
  num_atto_amministrativo VARCHAR(50),
  oggetto_atto_amministrativo VARCHAR(4000),
  cod_tipo_atto_amministrativo VARCHAR(50),
  cod_cdr_atto_amministrativo VARCHAR(50),
  desc_cdr_atto_amministrativo VARCHAR(500),
  cod_cdc_atto_amministrativo VARCHAR(50),
  desc_cdc_atto_amministrativo VARCHAR(500),
  importo_iniziale VARCHAR(50),
  importo_attuale VARCHAR(50),
  importo_utilizzabile VARCHAR(50),
  importo_liquidato VARCHAR(50),
  data_elaborazione VARCHAR(50),
  esito VARCHAR(4999),
  errore VARCHAR(5000),
  data_caricamento TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  num_elaborazione_di_giornata VARCHAR(3),
  CONSTRAINT cpass_t_flusso_subimpegni_esterni_pkey PRIMARY KEY(flusso_subimpegni_esterni_id)
);

create or replace function cpass.column_exists(ptable text, pcolumn text, pschema text default 'public')
  returns boolean
  language sql stable strict
as $body$
    -- does the requested table.column exist in schema?
    select exists
         ( select null
             from information_schema.columns
             where table_name=ptable
               and column_name=pcolumn
               and table_schema=pschema
         );
$body$;

CREATE OR REPLACE FUNCTION cpass.rename_column_if_exists(ptable TEXT, pcolumn TEXT, new_name text, pschema text default 'public')
  RETURNS VOID
  LANGUAGE plpgsql
  as $BODY$
BEGIN
    -- Rename the column if it exists.
    IF column_exists(ptable, pcolumn, pschema) THEN
        EXECUTE FORMAT('ALTER TABLE %I RENAME COLUMN %I TO %I;',
            ptable, pcolumn, new_name);
    END IF;
END;
$BODY$;


--drop table if exists cpass.CPASS_T_ORD_DOCUMENTO_TRASPORTO_XML;
--drop table if exists cpass.cpass_t_ord_documento_trasporto_riga;
--drop table if exists cpass.cpass_t_ord_documento_trasporto;

CREATE TABLE if not exists cpass.cpass_t_ord_documento_trasporto (
  documento_trasporto_id SERIAL,
  despatch_advice_id VARCHAR(200),
  id_notier VARCHAR(200) NOT NULL,
  stato_id INTEGER NOT NULL,
  fornitore_id UUID,
  testata_evasione_id UUID,
  testata_ordine_id UUID,
  data_consegna VARCHAR(10),
  note VARCHAR(4000),
  ordine_unico_id VARCHAR(400),
  ordine_unico_data VARCHAR(10),
  ordine_unico_tipo VARCHAR(400),
  endpoint_id VARCHAR(400),
  indirizzo_destinatario VARCHAR(400),
  localita_destinatario VARCHAR(400),
  cap_destinatario VARCHAR(5),
  provincia_destinatario VARCHAR(400),
  contatto_destinatario VARCHAR(400),
  telefono_destinatario VARCHAR(40),
  settore_emittente_ordine VARCHAR(400),
  partita_iva_fornitore VARCHAR(16),
  ragione_sociale_fornitore VARCHAR(400),
  CONSTRAINT cpass_t_ord_documento_trasporto_pkey PRIMARY KEY(documento_trasporto_id),
  CONSTRAINT fk_cpass_T_DOCUMENTO_TRASPORTO_STATO FOREIGN KEY (STATO_ID) REFERENCES cpass.CPASS_D_STATO(STATO_ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_T_DOCUMENTO_TRASPORTO_fornitore FOREIGN KEY (fornitore_id) REFERENCES cpass.CPASS_T_FORNITORE(fornitore_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_T_DOCUMENTO_TRASPORTO_evasione FOREIGN KEY (testata_evasione_id) REFERENCES cpass.CPASS_T_ORD_TESTATA_EVASIONE(testata_evasione_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_t_documento_trasporto_t_testata_ordine FOREIGN KEY (testata_ordine_id) REFERENCES cpass.cpass_t_ord_testata_ordine(testata_ordine_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
)
WITH (oids = false);

COMMENT ON TABLE cpass.cpass_t_ord_documento_trasporto
IS 'UUID namespace: "cpass_t_ord_documento_trasporto"';

--ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto DROP CONSTRAINT IF EXISTS fk_cpass_T_DOCUMENTO_TRASPORTO_RIGA_stato;
--ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto DROP CONSTRAINT IF EXISTS fk_cpass_T_DOCUMENTO_TRASPORTO_fornitore;
--ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto DROP CONSTRAINT IF EXISTS fk_cpass_T_DOCUMENTO_TRASPORTO_evasione;
--ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto ADD CONSTRAINT fk_cpass_T_DOCUMENTO_TRASPORTO_STATO FOREIGN KEY (STATO_ID)
--REFERENCES cpass.CPASS_D_STATO(STATO_ID);
--ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto ADD CONSTRAINT fk_cpass_T_DOCUMENTO_TRASPORTO_fornitore FOREIGN KEY (fornitore_id)
--REFERENCES cpass.CPASS_T_FORNITORE(fornitore_id);
--ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto ADD CONSTRAINT fk_cpass_T_DOCUMENTO_TRASPORTO_evasione FOREIGN KEY (testata_evasione_id)
--REFERENCES cpass.CPASS_T_ORD_TESTATA_EVASIONE(testata_evasione_id);
--ALTER TABLE if exists cpass.cpass_t_ord_documento_trasporto  ALTER COLUMN fornitore_id DROP NOT NULL;
--ALTER TABLE if exists cpass.cpass_t_ord_documento_trasporto add COLUMN if not exists testata_ordine_id UUID;
--ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto
--DROP CONSTRAINT IF EXISTS fk_cpass_t_documento_trasporto_t_testata_ordine;
--ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto
--ADD CONSTRAINT fk_cpass_t_documento_trasporto_t_testata_ordine FOREIGN KEY (testata_ordine_id) REFERENCES cpass.cpass_t_ord_testata_ordine(testata_ordine_id);
--ALTER TABLE cpass.cpass_t_ord_documento_trasporto
--  ALTER COLUMN despatch_advice_id TYPE VARCHAR(200);
--ALTER TABLE cpass.cpass_t_ord_documento_trasporto
--  ALTER COLUMN id_notier TYPE VARCHAR(200);

CREATE TABLE if not exists cpass.CPASS_T_ORD_DOCUMENTO_TRASPORTO_XML(
		 DOCUMENTO_TRASPORTO_XML_ID SERIAL PRIMARY KEY
		,DOCUMENTO_TRASPORTO_ID INTEGER not null
		,DESPATCH_ADVICE_ID VARCHAR(200) not null
		,DATA_CONSEGNA varchar(10)
		,NOTE varchar(4000)
		,TIPODOC varchar(4000)
		,File_xml text
		,PATH_file  varchar(400)
		,DATA_SPOSTAMENTO timestamp,
		CONSTRAINT fk_CPASS_T_ORD_DOCUMENTO_TRASPORTO_XML_doc_trasporto FOREIGN KEY (DOCUMENTO_TRASPORTO_ID)
		  REFERENCES cpass.CPASS_T_ORD_DOCUMENTO_TRASPORTO(DOCUMENTO_TRASPORTO_ID)
		  ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE
);
--ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_DOCUMENTO_TRASPORTO_XML ADD CONSTRAINT fk_CPASS_T_ORD_DOCUMENTO_TRASPORTO_XML_doc_trasporto FOREIGN KEY (DOCUMENTO_TRASPORTO_ID) REFERENCES cpass.CPASS_T_ORD_DOCUMENTO_TRASPORTO(DOCUMENTO_TRASPORTO_ID);
--ALTER TABLE cpass.cpass_t_ord_documento_trasporto_xml
--  ALTER COLUMN despatch_advice_id TYPE VARCHAR(200);

CREATE TABLE IF NOT EXISTS cpass.cpass_t_ord_documento_trasporto_riga (
  documento_trasporto_riga_id SERIAL,
  documento_trasporto_id INTEGER NOT NULL,
  progressivo_riga_id VARCHAR(40) NOT NULL,
  unita_misura VARCHAR(40),
  qta_evasa numeric(8,2),
  qta_inevasa numeric(8,2),
  motivo_qta_inevasa VARCHAR(4000),
  progressivo_riga_ordine_evasa  VARCHAR(40),
  testata_ordine_id UUID,
  riga_ordine_id UUID,
  riga_evasione_id UUID,
  ordine_nso_id VARCHAR (40),
  ordine_data VARCHAR(10),
  ordine_tipo VARCHAR(40),
  codice_listino_fornitore VARCHAR(400),
  note_fornitore VARCHAR(4000),
  CONSTRAINT cpass_t_ord_documento_trasporto_riga_pkey PRIMARY KEY(documento_trasporto_riga_id),
  CONSTRAINT fk_cpass_t_documento_trasporto_documento_trasporto_riga FOREIGN KEY (documento_trasporto_id)
    REFERENCES cpass.cpass_t_ord_documento_trasporto(documento_trasporto_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_t_documento_trasporto_riga_ordine FOREIGN KEY (testata_ordine_id)
    REFERENCES cpass.cpass_t_ord_testata_ordine(testata_ordine_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_t_documento_trasporto_ordine FOREIGN KEY (riga_ordine_id)
    REFERENCES cpass.cpass_t_ord_riga_ordine(riga_ordine_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_t_documento_trasporto_evasione FOREIGN KEY (riga_evasione_id)
    REFERENCES cpass.cpass_t_ord_riga_evasione(riga_evasione_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE

)
WITH (oids = false);

--ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto_riga ADD COLUMN IF NOT EXISTS progressivo_riga_id VARCHAR(40);

COMMENT ON TABLE cpass.cpass_t_ord_documento_trasporto_riga
IS 'UUID namespace: "cpass_t_ord_documento_trasporto_riga"';

ALTER TABLE if exists cpass.cpass_t_ufficio add COLUMN if not exists  id_notier varchar(200)   ;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_evasione ADD COLUMN IF NOT EXISTS quantita_evasa numeric(8,2);

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_evasione add column if not exists documento_trasporto_id integer;

ALTER TABLE IF EXISTS cpass.cpass_t_settore_indirizzo ADD COLUMN IF NOT EXISTS settore_indirizzo_codice VARCHAR(50);

ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario_ordine ADD COLUMN IF NOT EXISTS settore_indirizzo_codice VARCHAR(50);

ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario_ordine ADD COLUMN IF NOT EXISTS settore_indirizzo_id INTEGER;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_destinatario_settore_indirizzo;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario_ordine ADD CONSTRAINT fk_cpass_t_ord_destinatario_settore_indirizzo FOREIGN KEY (settore_indirizzo_id)
REFERENCES cpass.cpass_t_settore_indirizzo(settore_indirizzo_id);

ALTER TABLE IF EXISTS cpass.cpass_t_settore ADD COLUMN IF NOT EXISTS settore_indirizzo_codice VARCHAR(50);

CREATE TABLE IF NOT EXISTS cpass.cpass_t_ord_destinatario_invio_nso
(destinatario_invio_nso_id SERIAL
, destinatario_id UUID
, testata_ordine_id UUID
, progressivo_invio INTEGER NOT NULL
, cbc_id VARCHAR(50) NOT NULL
, order_document_reference_id VARCHAR(100) NULL
, esito_invio VARCHAR(10)
, esito_invio_errore_codice VARCHAR(50)
, esito_invio_errore_descrizione VARCHAR(4000)
, esito_consegna_mdn VARCHAR(10)
, esito_consegna_mdn_errore_codice VARCHAR(50)
, esito_consegna_mdn_errore_descrizione VARCHAR(4000)
, esito_consegna_nso VARCHAR(10)
, esito_consegna_nso_errore_codice VARCHAR(50)
, esito_consegna_nso_errore_descrizione VARCHAR(4000)
, urn VARCHAR(200)
, utente_invio UUID
, data_creazione timestamp NOT NULL DEFAULT now()
, utente_creazione varchar(250) NOT NULL
, data_modifica timestamp NOT NULL DEFAULT now()
, utente_modifica varchar(250) NOT NULL
, CONSTRAINT cpass_t_ord_destinatario_invio_nso_pkey PRIMARY KEY(destinatario_invio_nso_id)
, CONSTRAINT fk_cpass_t_ord_destinatario_invio_nso_destinatario FOREIGN KEY (destinatario_id)
    REFERENCES cpass.cpass_t_ord_destinatario_ordine(destinatario_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
, CONSTRAINT fk_cpass_t_ord_destinatario_invio_nso_ordine FOREIGN KEY (testata_ordine_id)
    REFERENCES cpass.cpass_t_ord_testata_ordine(testata_ordine_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
, constraint fk_cpass_t_ord_destinatario_invio_nso_t_utente FOREIGN KEY (utente_invio)
	REFERENCES cpass_t_utente(utente_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
);

CREATE TABLE IF NOT EXISTS cpass.cpass_t_ord_destinatario_invio_nso_xml
(destinatario_invio_nso_xml_id SERIAL
, destinatario_invio_nso_id int4 NOT NULL
, identificativo_trasmissione varchar(200)
, data_consegna varchar(10)
, note VARCHAR(4000)
, tipodoc VARCHAR(4000)
, file_xml text NULL
, path_file varchar(400) NULL
, data_spostamento timestamp NULL
, CONSTRAINT cpass_r_ord_destinatario_invio_nso_xml_pkey PRIMARY KEY(destinatario_invio_nso_xml_id)
, CONSTRAINT fk_cpass_t_ord_destinatario_invio_nso_xml_invio_nso FOREIGN KEY (destinatario_invio_nso_id)
    REFERENCES cpass.cpass_t_ord_destinatario_invio_nso(destinatario_invio_nso_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
);

ALTER TABLE if exists cpass.cpass_t_elaborazione ALTER COLUMN elaborazione_esito      TYPE VARCHAR(200);
ALTER TABLE if exists cpass.cpass_t_elaborazione ALTER COLUMN elaborazione_id_esterno TYPE VARCHAR(200);

select * from rename_column_if_exists ('cpass_t_ord_testata_ordine','tipo_acquisto_id', 'settore_interventi_id','cpass');

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_allegato_ii (
  p_programma_id varchar
)
RETURNS TABLE (
  id_allegato_scheda integer,
  intervento_cui varchar,
  intervento_anno_avvio integer,
  intervento_cup varchar,
  ricompreso_tipo_codice varchar,
  ricompreso_tipo_descrizione varchar,
  intervento_lotto_funzionale boolean,
  nuts_codice varchar,
  nuts_descrizione varchar,
  settore_interventi_codice varchar,
  settore_interventi_descrizione varchar,
  cpv_codice varchar,
  cpv_descrizione varchar,
  intervento_descrizione_acquisto varchar,
  priorita_codice varchar,
  priorita_descrizione varchar,
  utente_nome varchar,
  utente_cognome varchar,
  utente_codice_fiscale varchar,
  intervento_durata_mesi integer,
  intervento_nuovo_affid boolean,
  intervento_copia_tipo varchar,
  motivazione_non_riproposto varchar,
  ausa varchar,
  ausa_descrizione varchar,
  acquisto_variato_codice varchar,
  acquisto_variato_descrizione varchar,
  programma_id uuid,
  programma_anno integer,
  ente_id uuid,
  ente_codice_fiscale varchar,
  ente_denominazione varchar,
  importo_anno_primo numeric,
  importo_anno_secondo numeric,
  importo_anni_successivi numeric,
  totale_importi numeric,
  cap_privati_importo_anno_primo numeric,
  cap_privati_importo_anno_secondo numeric,
  cap_privati_importo_anni_successivi numeric,
  cap_privati_totale_importi numeric,
  descrizione_risorsa varchar,
  tipologia varchar
) AS
$body$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query
WITH importi AS (
SELECT      int_1.intervento_id,
            programma_1.programma_id,
            sum(intimp.intervento_importi_importo_anno_primo)      AS importo_anno_primo,
            sum(intimp.intervento_importi_importo_anno_secondo)    AS importo_anno_secondo,
            sum(intimp.intervento_importi_importo_anni_successivi) AS importo_anni_successivi,
            sum(intimp.intervento_importi_importo_anno_primo +
                intimp.intervento_importi_importo_anno_secondo +
                intimp.intervento_importi_importo_anni_successivi) AS totale_importi
FROM cpass_t_pba_intervento int_1
             JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id =  intimp.intervento_id
             JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id =  programma_1.programma_id
            JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id =  risorsa.risorsa_id AND risorsa.risorsa_tipo::text = 'BILANCIO'::text
 GROUP BY int_1.intervento_id, programma_1.programma_id),
importi_cap_privati AS (
     SELECT int_1.intervento_id,
            programma_1.programma_id,
            risorsa.risorsa_id,
            sum(intimp.intervento_importi_importo_anno_primo)      AS cap_privati_importo_anno_primo,
            sum(intimp.intervento_importi_importo_anno_secondo)    AS cap_privati_importo_anno_secondo,
            sum(intimp.intervento_importi_importo_anni_successivi) AS cap_privati_importo_anni_successivi,
            sum(intimp.intervento_importi_importo_anno_primo +
                intimp.intervento_importi_importo_anno_secondo +
                intimp.intervento_importi_importo_anni_successivi) AS cap_privati_totale_importi
    FROM cpass_t_pba_intervento int_1
             JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id =   intimp.intervento_id
             JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id =     programma_1.programma_id
             JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id =  risorsa.risorsa_id AND risorsa.risorsa_tipo::text = 'CAPITALE PRIVATO'::text
    GROUP BY int_1.intervento_id, programma_1.programma_id, risorsa.risorsa_id
    )
    select distinct
    	--row_number() OVER ()::INTEGER AS id_allegato_scheda
        0 AS id_allegato_scheda
        ,"int".intervento_cui
        ,"int".intervento_anno_avvio
        ,"int".intervento_cup
        ,rt.ricompreso_tipo_codice
        ,"int".intervento_ricompreso_cui    --rt.ricompreso_tipo_descrizione
        ,"int".intervento_lotto_funzionale
        ,nuts.nuts_codice
        ,nuts.nuts_descrizione
        ,si.settore_interventi_codice
        ,si.settore_interventi_descrizione
        ,cpv.cpv_codice
        ,cpv.cpv_descrizione
        ,"int".intervento_descrizione_acquisto
        ,priorita.priorita_codice
        ,priorita.priorita_descrizione
        ,ute.utente_nome
        ,ute.utente_cognome
        ,ute.utente_codice_fiscale
        ,"int".intervento_durata_mesi
        ,"int".intervento_nuovo_affid
        ,"int".intervento_copia_tipo
        ,"int".motivazione_non_riproposto
        ,ausa.ausa_codice AS ausa
        ,ausa.ausa_descrizione
        ,av.acquisto_variato_codice
        ,av.acquisto_variato_descrizione
        ,programma.programma_id
        ,programma.programma_anno
        --,programma.programma_referente
        ,ente.ente_id
        ,ente.ente_codice_fiscale
        ,ente.ente_denominazione
        ,importi.importo_anno_primo importo_anno_primo
        ,importi.importo_anno_secondo importo_anno_secondo
        ,importi.importo_anni_successivi  importo_anni_successivi
        ,importi.totale_importi totale_importi
        ,importi_cap_privati.cap_privati_importo_anno_primo cap_privati_importo_anno_primo
        ,importi_cap_privati.cap_privati_importo_anno_secondo cap_privati_importo_anno_secondo
        ,importi_cap_privati.cap_privati_importo_anni_successivi cap_privati_importo_anni_successivi
        ,importi_cap_privati.cap_privati_totale_importi cap_privati_totale_importi
        --,risorsa.risorsa_descrizione descrizione_risorsa
        ,''::character varying descrizione_risorsa
        ,risorsa.risorsa_tipo tipologia --        ,'CAPITALE PRIVATO'::character varying AS tipologia
    FROM cpass_t_pba_intervento "int"
       JOIN cpass_d_stato stato ON "int".stato_id = stato.stato_id and stato.stato_tipo = 'INTERVENTO' AND stato.stato_codice <>'ANNULLATO'
       JOIN cpass_d_pba_nuts nuts ON "int".nuts_id = nuts.nuts_id
       JOIN cpass_d_pba_priorita priorita ON "int".priorita_id = priorita.priorita_id
       JOIN cpass_d_pba_settore_interventi si ON "int".settore_interventi_id = si.settore_interventi_id
       JOIN cpass_d_cpv cpv ON "int".cpv_id = cpv.cpv_id
       JOIN cpass_t_utente ute ON "int".utente_rup_id = ute.utente_id
       LEFT JOIN cpass_d_pba_acquisto_variato av ON "int".acquisto_variato_id =av.acquisto_variato_id
       LEFT JOIN cpass_d_pba_ricompreso_tipo rt ON "int".ricompreso_tipo_id = rt.ricompreso_tipo_id
       LEFT JOIN cpass_d_pba_ausa ausa ON "int".ausa_id = ausa.ausa_id
       JOIN cpass_t_pba_programma programma ON "int".programma_id = programma.programma_id
       JOIN cpass_t_ente ente ON ente.ente_id = programma.ente_id
       JOIN importi ON "int".programma_id = importi.programma_id AND "int".intervento_id = importi.intervento_id
       LEFT JOIN importi_cap_privati ON "int".programma_id = importi_cap_privati.programma_id AND "int".intervento_id = importi_cap_privati.intervento_id
       LEFT JOIN cpass_d_pba_risorsa risorsa ON risorsa.risorsa_id =  importi_cap_privati.risorsa_id and importi_cap_privati.cap_privati_totale_importi > 0
     where
     	programma.programma_id = p_programma_id::UUID
     	--and ("int".intervento_copia_tipo != 'ACQ_NON_RIPROPOSTO' or "int".intervento_copia_tipo is null)
;


exception
	when no_data_found THEN
		raise notice 'Nessun dato trovato';
		return;
	when others  THEN
		RAISE EXCEPTION '% Errore : %-%.',RTN_MESSAGGIO,SQLSTATE,substring(SQLERRM from 1 for 500);
		return;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;

create table if not exists cpass.cpass_t_flusso_anomalie(
  flusso_anomalie_id serial
  ,impegno_id uuid
  ,subimpegno_id uuid
  ,importo_attuale NUMERIC
  ,LIQ_ANNO_PREC_CALCOLATO NUMERIC
  ,DATA_ELABORAZIONE varchar(50)
  ,CONSTRAINT cpass_t_flusso_anomalie_pkey PRIMARY KEY(flusso_anomalie_id )
);

ALTER TABLE IF EXISTS cpass.cpass_t_flusso_impegni_esterni    ADD COLUMN IF NOT EXISTS data_caricamento timestamp NOT NULL DEFAULT now();
ALTER TABLE IF EXISTS cpass.cpass_t_flusso_subimpegni_esterni ADD COLUMN IF NOT EXISTS data_caricamento timestamp NOT NULL DEFAULT now();

CREATE TABLE if not exists cpass.cpass_t_scarico_mepa_testata
(scarico_mepa_testata_id SERIAL
, Order_id varchar(200)
, stato_id int4
, issue_date varchar(200)
, order_Type_Code varchar(200)
, note varchar(200) not null
, customer_Reference varchar(200)
, end_date varchar(200)
, Originator_Document_Reference_Id varchar(200)
, Additional_Document_Reference_ID varchar(200)
, Additional_Document_Reference_Document_Type varchar(200)
, Buyer_Customer_Party_ID varchar(200)
, Buyer_Customer_Party_Name varchar(200)
, Buyer_Customer_Party_Street_Name varchar(200)
, Buyer_Customer_Party_City_Name varchar(200)
, Buyer_Customer_Party_Postal_Zone varchar(200)
, Buyer_Customer_Party_Company_ID varchar(200)
, SellerSupplierParty_Endpoint_ID varchar(200)
, SellerSupplierParty_Name varchar(200)
, SellerSupplierParty_Street_Name varchar(200)
, SellerSupplierParty_City_Name varchar(200)
, SellerSupplierParty_Postal_Zone varchar(200)
, SellerSupplierParty_Registration_Name varchar(200)
, Delivery_Location_ID varchar(200)
, Delivery_Location_Street_Name varchar(200)
, Delivery_Location_City_Name varchar(200)
, Delivery_Location_Postal_Zone varchar(200)
, RequestedDeliveryPeriod_Start_Date varchar(200)
, RequestedDeliveryPeriod_End_Date varchar(200)
, DeliverParty_Id varchar(200)
, DeliverParty_Name varchar(200)
, DeliverParty_Contact_Name varchar(200)
, DeliverParty_Contact_Telephone varchar(200)
, DeliverParty_Contact_Email varchar(200)
, Tax_Total numeric
, AnticipatedMonetaryTotal_Line_Extension_Amount numeric
, AnticipatedMonetaryTotal_Allowance_Total_Amount numeric
, AnticipatedMonetaryTotal_Tax_Exclusive_Amount numeric
, AnticipatedMonetaryTotal_Tax_Inclusive_Amount numeric
, AnticipatedMonetaryTotal_Payable_Amount numeric
, CONSTRAINT cpass_t_scarico_mepa_testata_pkey PRIMARY KEY (scarico_mepa_testata_id)
, constraint fk_cpass_t_scarico_mepa_testata_stato FOREIGN KEY (stato_id)
    REFERENCES cpass.cpass_d_stato(stato_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE);

CREATE TABLE if not exists cpass.cpass_t_scarico_mepa_riga
(scarico_mepa_riga_id SERIAL
, scarico_mepa_testata_id int4
, OrderLine_Note varchar(200)
, OrderLine_Id varchar(200)
, OrderLine_Quantity numeric
, OrderLine_Quantity_Unit_Code varchar(200)
, OrderLine_Line_Extension_Amount numeric
, OrderLine_Line_Partial_Delivery_Indicator boolean
, OrderLine_Line_Delivery_Id varchar(200)
, PriceAmount numeric
, BaseQuantity numeric
, Item_Name varchar(200)
, Item_Buyers_Id varchar(200)
, Item_Sellers_Id varchar(200)
, Item_Classification_Code varchar(200)
, ClassifiedTaxCategory_Id varchar(200)
, ClassifiedTaxCategory_Percent numeric
, ClassifiedTaxCategory_TaxScheme_Id varchar(200)
, CONSTRAINT cpass_t_scarico_mepa_riga_pkey PRIMARY KEY (scarico_mepa_riga_id)
, constraint fk_cpass_t_scarico_mepa_riga_scarico_mepa_testata FOREIGN KEY (scarico_mepa_testata_id)
    REFERENCES cpass.cpass_t_scarico_mepa_testata(scarico_mepa_testata_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE);

CREATE TABLE if not exists cpass.cpass_t_scarico_mepa_sconti
(scarico_mepa_sconti_id SERIAL
, scarico_mepa_riga_id int4
, OrderLine_Line_AllowanceCharge_Indicator boolean
, OrderLine_Line_AllowanceCharge_Reason varchar(200)
, OrderLine_Line_AllowanceCharge_Multiplier_Factor_Numeric numeric
, OrderLine_Line_AllowanceCharge_Amount numeric
, OrderLine_Line_AllowanceCharge_Base_Amount numeric
, CONSTRAINT cpass_t_scarico_mepa_sconti_pkey PRIMARY KEY (scarico_mepa_sconti_id)
, constraint fk_cpass_t_scarico_mepa_sconti_scarico_mepa_riga FOREIGN KEY (scarico_mepa_riga_id)
    REFERENCES cpass.cpass_t_scarico_mepa_riga(scarico_mepa_riga_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE);

CREATE TABLE if not exists cpass.cpass_t_scarico_mepa_xml
(scarico_mepa_xml_id SERIAL
, scarico_mepa_testata_id int4
, file_xml text NULL
, path_file varchar(400) NULL
, data_spostamento timestamp NULL
, CONSTRAINT cpass_t_scarico_mepa_xml_pkey PRIMARY KEY (scarico_mepa_xml_id)
, constraint fk_cpass_t_scarico_mepa_xml_scarico_mepa_testata FOREIGN KEY (scarico_mepa_testata_id)
    REFERENCES cpass.cpass_t_scarico_mepa_testata(scarico_mepa_testata_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE);

ALTER TABLE cpass.cpass_t_flusso_subimpegni_esterni
  ALTER COLUMN errore TYPE VARCHAR(4000) COLLATE pg_catalog."default";

ALTER TABLE if exists cpass.cpass_t_notifica ALTER COLUMN parametri TYPE varchar(500);
ALTER TABLE IF EXISTS cpass.cpass_t_notifica drop constraint if exists cpass_t_testi_notifica_codice_unique;
ALTER TABLE if exists cpass.cpass_t_testi_notifica ADD constraint  cpass_t_testi_notifica_codice_unique UNIQUE (codice);

  CREATE INDEX if not exists idx_t_impegno ON cpass_t_impegno
(
  impegno_anno_esercizio
  ,impegno_anno
  ,impegno_numero
  ,ente_id
);

alter table if exists cpass.cpass_t_ente add column if not exists path_logo VARCHAR(200);
alter table if exists cpass.cpass_t_ente add column if not exists link varchar(200);

-------------------------------------------------------------------------------------------------------------
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN ente_codice TYPE  VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN bil_anno  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN anno_impegno TYPE  VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN num_impegno TYPE  VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN desc_impegno  TYPE VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cod_impegno  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cod_stato_impegno  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN desc_stato_impegno TYPE VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN data_scadenza  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN parere_finanziario  TYPE VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cod_capitolo TYPE  VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cod_articolo TYPE  VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cod_ueb  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN desc_capitolo  TYPE VARCHAR(4000);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN desc_articolo  TYPE VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cod_soggetto  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN desc_soggetto TYPE  VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cf_soggetto TYPE  VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cf_estero_soggetto  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN p_iva_soggetto  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cod_classe_soggetto  TYPE VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN desc_classe_soggetto TYPE  VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cod_tipo_impegno TYPE  VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN desc_tipo_impegno TYPE  VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN annoriaccertato  TYPE VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN numriaccertato  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN anno_atto_amministrativo TYPE  VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN num_atto_amministrativo  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN oggetto_atto_amministrativo  TYPE VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cod_tipo_atto_amministrativo  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cod_cdr_atto_amministrativo  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN desc_cdr_atto_amministrativo  TYPE VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cod_cdc_atto_amministrativo  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN desc_cdc_atto_amministrativo TYPE  VARCHAR(500);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN importo_iniziale  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN importo_attuale  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN importo_utilizzabile  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cig  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN cup  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN importo_liquidato  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN data_elaborazione  TYPE VARCHAR(50);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN num_elaborazione_di_giornata TYPE  VARCHAR(5);
  ALTER TABLE cpass.cpass_t_flusso_impegni_esterni ALTER COLUMN esito TYPE  VARCHAR(100);

CREATE OR REPLACE VIEW cpass.cpass_v_settore
AS WITH RECURSIVE alberosettore AS (
         SELECT 1 AS livello,
            NULL::uuid AS settore_id_padre,
            s.settore_id,
            s.settore_codice,
            s.settore_descrizione,
            s.settore_indirizzo,
            s.settore_localita,
            s.settore_cap,
            s.settore_provincia,
            s.settore_telefono,
            s.settore_num_civico,
            s.settore_contatto,
            s.settore_email,
            s.ente_id,
            ts.tipo_settore_id,
            ts.flag_utilizzabile
           FROM cpass_t_settore s,
            cpass_d_tipo_settore ts
          WHERE s.settore_padre_id IS NULL AND (s.data_cancellazione IS NULL OR s.data_cancellazione IS NOT NULL AND s.data_cancellazione >= date_trunc('day'::text, now())) AND s.tipo_settore_id = ts.tipo_settore_id
        UNION ALL
         SELECT mtree.livello + 1,
            mtree.settore_id AS settore_id_padre,
            s_figlio.settore_id,
            s_figlio.settore_codice,
            s_figlio.settore_descrizione,
            s_figlio.settore_indirizzo,
            s_figlio.settore_localita,
            s_figlio.settore_cap,
            s_figlio.settore_provincia,
            s_figlio.settore_telefono,
            s_figlio.settore_num_civico,
            s_figlio.settore_contatto,
            s_figlio.settore_email,
            s_figlio.ente_id,
            ts.tipo_settore_id,
            ts.flag_utilizzabile
           FROM cpass_t_settore s_figlio
             JOIN alberosettore mtree ON mtree.settore_id = s_figlio.settore_padre_id
             JOIN cpass_d_tipo_settore ts ON s_figlio.tipo_settore_id = ts.tipo_settore_id
          WHERE s_figlio.data_cancellazione IS NULL OR s_figlio.data_cancellazione IS NOT NULL AND s_figlio.data_cancellazione >= date_trunc('day'::text, now())
        )
 SELECT row_number() OVER () AS id_v_settore,
    alberosettore.livello,
    alberosettore.settore_id_padre,
    alberosettore.settore_id,
    alberosettore.settore_codice,
    alberosettore.settore_descrizione,
    alberosettore.settore_indirizzo,
    alberosettore.settore_localita,
    alberosettore.settore_cap,
    alberosettore.settore_provincia,
    alberosettore.settore_telefono,
    alberosettore.settore_num_civico,
    alberosettore.settore_contatto,
    alberosettore.settore_email,
    alberosettore.ente_id,
    alberosettore.tipo_settore_id,
    alberosettore.flag_utilizzabile
   FROM alberosettore
  ORDER BY alberosettore.livello DESC, alberosettore.settore_codice;

  alter table if exists cpass.cpass_t_ord_testata_ordine add column if not exists scarico_mepa_testata_id integer;
  alter table if exists cpass.cpass_t_ord_testata_ordine drop constraint if exists fk_cpass_t_ord_testata_ordine_scarico_mepa_testata;
  alter table if exists cpass.cpass_t_ord_testata_ordine add constraint fk_cpass_t_ord_testata_ordine_scarico_mepa_testata
  	foreign key (scarico_mepa_testata_id) references cpass.cpass_t_scarico_mepa_testata (scarico_mepa_testata_id)
  	ON DELETE NO ACTION ON UPDATE NO ACTION;


----------------------------------------------------------------------------------------------------------------------------------------------------

delete from cpass.cpass_d_elaborazione_tipo where elaborazione_tipo_codice = 'INVIO_A_NSO' and modulo_codice = 'ORD';

INSERT INTO cpass.cpass_d_elaborazione_tipo (elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
SELECT tmp.elaborazione_tipo_codice, tmp.elaborazione_tipo_descrizione, tmp.modulo_codice
FROM (VALUES
  ('RICEZIONE_DDT','RICEZIONE DDT','ORD')
  ,('RICEZIONE_NOTIFICHE','RICEZIONE NOTIFICHE','ORD')
) AS tmp(elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo current
  WHERE current.elaborazione_tipo_codice = tmp.elaborazione_tipo_codice
);

  INSERT INTO cpass.cpass_d_provvedimento_tipo (provvedimento_tipo_codice, provvedimento_tipo_descrizione)
SELECT tmp.provvedimento_tipo_codice, tmp.provvedimento_tipo_descrizione
FROM (VALUES
('AD','Atto Dirigenziale'),
('DD','Determina Dirigenziale'),
('DG','Determina')

) AS tmp(provvedimento_tipo_codice, provvedimento_tipo_descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_provvedimento_tipo current
  WHERE current.provvedimento_tipo_codice = tmp.provvedimento_tipo_codice
);

insert into cpass.cpass_d_stato_el_ordine (stato_codice, stato_descrizione, stato_tipo)
select tmp.codice, tmp.descrizione, tmp.tipo
from ( values
	('EPS','EVASA CON SCONTO','RIGA_ORDINE')
)AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato_el_ordine ts
  WHERE ts.stato_codice = tmp.codice
  AND ts.stato_tipo = tmp.tipo
);

insert into cpass.cpass_d_stato_el_ordine (stato_codice, stato_descrizione, stato_tipo)
select tmp.codice, tmp.descrizione, tmp.tipo
from ( values
  ('EPS', 'EVASO CON SCONTO', 'DEST_ORDINE')
)AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato_el_ordine ts
  WHERE ts.stato_codice = tmp.codice
  AND ts.stato_tipo = tmp.tipo
);

INSERT INTO cpass.cpass_t_testi_notifiche (codice, it_testo, en_testo)
SELECT tmp.codice, tmp.it_testo, tmp.en_testo
FROM ( VALUES
    ('N0001','L''ordine {anno}/{numero} e'' stato inviato a NSO e sono state recepite le notifiche di consegna. Per i dettagli, consultare l''ordine.','')
	) AS tmp(codice, it_testo, en_testo)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_testi_notifiche tp
	WHERE tp.codice = tmp.codice
);


INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
    ('PROXY_HOSTNAME_NOTIER','','NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('PROXY_PORT_NOTIER','','NSO', 'NOTIER', 'Per interrogazione NSO', true)
	) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);

INSERT INTO cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.tipo
FROM (VALUES
('DA_CARICARE','DA CARICARE','ORDINE_MEPA'),
('CARICATO','CARICATO','ORDINE_MEPA')
) AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_stato ds
	WHERE ds.stato_codice = tmp.codice
	and   ds.stato_tipo = tmp.tipo
);

INSERT INTO cpass.cpass_d_ord_stato_nso (stato_nso_codice, stato_nso_descrizione, stato_nso_tipo)
select tmp.codice, tmp.descrizione, tmp.tipo
from ( values
		('INVIATO', 'INVIATO', 'ORDINE')
	)as tmp(codice, descrizione, tipo)
where not exists (
	select 1 from cpass.cpass_d_ord_stato_nso sn
	where sn.stato_nso_codice = tmp.codice
	and sn.stato_nso_tipo = tmp.tipo
	);

INSERT INTO cpass.cpass_d_ord_tipo_ordine (tipologia_documento_codice, tipologia_documento_descrizione, flag_trasm_nso, data_creazione, utente_creazione, data_modifica, utente_modifica)
SELECT tmp.tipologia_documento_codice, tmp.tipologia_documento_descrizione, tmp.flag_trasm_nso, now(), 'SYSTEM', now(), 'SYSTEM'
FROM (VALUES
  ('MEP','MEPA',true)
) AS tmp(tipologia_documento_codice, tipologia_documento_descrizione, flag_trasm_nso)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_ord_tipo_ordine current
  WHERE current.tipologia_documento_codice = tmp.tipologia_documento_codice
);

insert into cpass.cpass_t_testi_notifiche (codice, it_testo)
SELECT tmp.codice, tmp.it_testo
FROM (VALUES
('N0001','L''ordine {anno}/{numero} e'' stato inviato a NSO e sono state recepite le notifiche di consegna. Per i dettagli, consultare l''ordine.'),
('N0002','L''ordine {anno}/{numero} e'' stato inviato a NSO ma non e'' stato consegnato al fornitore. Per i dettagli, consultare l''ordine.')
) AS tmp(codice, it_testo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_testi_notifiche tn
	WHERE tn.codice = tmp.codice
);

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
    ('STORICO_GG_FLUSSI','5','IMPEGNOEXT', 'IMPEGNOEXT', 'giorni prima della cancellazione', true)
	) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);

update cpass_t_testi_notifiche set
it_testo = 'L''ordine {{anno}}/{{numero}} e'' stato inviato a NSO e sono state recepite le notifiche di consegna. Per i dettagli, consultare l''ordine.'
where codice  ='N0001';

update cpass_t_testi_notifiche set
it_testo = 'L''ordine {{anno}}/{{numero}} e'' stato inviato a NSO ma non e'' stato consegnato al fornitore. Per i dettagli, consultare l''ordine.'
where codice  ='N0002';

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
    ('GG_FINE_NOTIFICA','10','NOTIFICA', 'CPASS', 'numero di giorni usati per definire la data fine della notifica', true)
	) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);

insert into cpass.cpass_d_stato_el_ordine (stato_codice, stato_descrizione, stato_tipo)
  select tmp.codice, tmp.descrizione, tmp.tipo
  from ( values('CDE','CHIUSO DA EVADERE','DEST_ORDINE'))
  AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato_el_ordine ts
  WHERE ts.stato_codice = tmp.codice
  AND ts.stato_tipo = tmp.tipo
);

update cpass_d_stato_el_ordine set stato_tipo = 'DEST_ORDINE'
  where stato_codice = 'CEP' and stato_tipo = 'DESTINATARIO_ORDINE';
