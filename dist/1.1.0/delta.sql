---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================

ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati DROP CONSTRAINT IF EXISTS idx_intervento_id;
alter TABLE cpass.cpass_t_pba_intervento_altri_dati add CONSTRAINT idx_intervento_id UNIQUE (intervento_id);

ALTER TABLE cpass.cpass_t_fornitore DROP COLUMN if exists  cod_destinatario;


ALTER TABLE IF EXISTS cpass.cpass_t_fornitore ADD COLUMN IF NOT EXISTS data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_fornitore ADD COLUMN IF NOT EXISTS utente_creazione VARCHAR(250) NOT NULL default 'admin';
ALTER TABLE IF EXISTS cpass.cpass_t_fornitore ADD COLUMN IF NOT EXISTS data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_fornitore ADD COLUMN IF NOT EXISTS utente_modifica VARCHAR(250) NOT NULL default 'admin';
ALTER TABLE IF EXISTS cpass.cpass_t_fornitore ADD COLUMN IF NOT EXISTS data_cancellazione TIMESTAMP WITHOUT TIME ZONE;
ALTER TABLE IF EXISTS cpass.cpass_t_fornitore ADD COLUMN IF NOT EXISTS utente_cancellazione VARCHAR(250);
ALTER TABLE IF EXISTS cpass.cpass_t_fornitore ADD COLUMN IF NOT EXISTS optlock uuid DEFAULT public.uuid_generate_v4() NOT NULL;

--DROP TABLE cpass_d_provvedimento_tipo;

CREATE TABLE if not exists cpass.cpass_d_provvedimento_tipo (
     provvedimento_tipo_id SERIAL
	,provvedimento_tipo_codice  varchar(50) Not null
	,provvedimento_tipo_descrizione  varchar(50)
    ,CONSTRAINT cpass_d_provvedimento_tipo_pkey PRIMARY KEY(provvedimento_tipo_id)
);


--DROP TABLE cpass_t_provvedimento;
create table if not exists cpass.cpass_t_provvedimento (
	 provvedimento_id      SERIAL
	,provvedimento_anno    Integer  NOT NULL
	,provvedimento_numero  Integer NOT NULL
	,provvedimento_oggetto varchar(200)
	,provvedimento_descrizione varchar(200)
	,provvedimento_note    varchar(2000)
    ,provvedimento_tipo_id integer  NOT NULL
    ,ente_id               UUID not null
    ,settore_id            UUID not null
  	,data_creazione        TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
  	,utente_creazione      VARCHAR(250)  NOT NULL
  	,data_modifica         TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
  	,utente_modifica       VARCHAR(250)  NOT NULL
  	,data_cancellazione    TIMESTAMP WITHOUT TIME ZONE
  	,utente_cancellazione  VARCHAR(250)
  	,optlock UUID DEFAULT uuid_generate_v4() NOT NULL
  	,CONSTRAINT cpass_t_provvedimentoe_pkey PRIMARY KEY(provvedimento_id)
    ,CONSTRAINT fk_cpass_t_provvedimento_t_ente FOREIGN KEY (ente_id) REFERENCES cpass.cpass_t_ente(ente_id)
    ,CONSTRAINT fk_cpass_t_provvedimento_t_settore FOREIGN KEY (settore_id) REFERENCES cpass.cpass_t_settore(settore_id)
    ,CONSTRAINT fk_cpass_t_provvedimento_d_provvedimento_tipo FOREIGN KEY (provvedimento_tipo_id) REFERENCES cpass.cpass_d_provvedimento_tipo(provvedimento_tipo_id)
);

ALTER TABLE cpass.cpass_t_provvedimento DROP COLUMN if exists  utente_creazione;
ALTER TABLE cpass.cpass_t_provvedimento DROP COLUMN if exists  utente_modifica;
ALTER TABLE cpass.cpass_t_provvedimento DROP COLUMN if exists  utente_cancellazione;
ALTER TABLE cpass.cpass_t_provvedimento DROP COLUMN if exists  optlock;
ALTER TABLE cpass.cpass_t_provvedimento DROP COLUMN if exists  data_cancellazione;


ALTER TABLE cpass.cpass_t_provvedimento add COLUMN if not exists  data_validita_inizio     TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE cpass.cpass_t_provvedimento add COLUMN if not exists  data_validita_fine  TIMESTAMP   ;




--DROP TABLE cpass_t_settore_storico;

CREATE TABLE if not exists  cpass.cpass_t_settore_storico (
	 settore_storico_id        SERIAL
    ,settore_id_attuale       UUID Not null
    ,settore_id_storico       UUID Not null
    ,settore_codice_attuale   varchar(50) Not null
    ,settore_codice_storico   varchar(50) Not null
    ,data_validita_inizio     TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    ,data_validita_fine       TIMESTAMP
    ,note                     varchar(2000)
    ,ente_id UUID not null
    ,CONSTRAINT cpass_t_settore_storico_pkey PRIMARY KEY(settore_storico_id)
    ,CONSTRAINT fk_cpass_t_settore_storico_t_ente FOREIGN KEY (ente_id)
     REFERENCES cpass.cpass_t_ente(ente_id)
    ,CONSTRAINT fk_cpass_t_settore_t_settore1 FOREIGN KEY (settore_id_attuale)
     REFERENCES cpass.cpass_t_settore(settore_id)
    ,CONSTRAINT fk_cpass_t_settore_t_settore2 FOREIGN KEY (settore_id_storico)
     REFERENCES cpass.cpass_t_settore(settore_id)
);

CREATE TABLE if not exists cpass.cpass_t_fruitore (
	fruitore_id serial NOT NULL,
	fruitore_codice varchar(50) NOT NULL,
	fruitore_ente_codice_fiscale varchar(16) NOT NULL,
	fruitore_descrizione varchar(200) NULL,
	CONSTRAINT cpass_t_fruitore_pkey PRIMARY KEY (fruitore_id)
);
CREATE TABLE if not exists cpass.cpass_t_servizio (
	servizio_id serial NOT NULL,
	servizio_codice varchar(50) not NULL,
	servizio_descrizione varchar(200) NULL,
	CONSTRAINT cpass_t_servizio_pkey PRIMARY KEY (servizio_id)
);
CREATE TABLE  if not exists  cpass.cpass_r_fruitore_servizio (
	fruitore_servizio_id serial NOT NULL,
	fruitore_id int4 NOT NULL,
	servizio_id int4 NOT NULL,
	data_validita_inizio timestamp NOT NULL DEFAULT now(),
	data_validita_fine timestamp NULL,
	CONSTRAINT cpass_r_fruitore_servizio_pkey PRIMARY KEY (fruitore_servizio_id),
	CONSTRAINT fk_cpass_r_fruitore_servizio_t_fruitore FOREIGN KEY (fruitore_id) REFERENCES cpass_t_fruitore(fruitore_id),
	CONSTRAINT fk_cpass_r_fruitore_servizio_t_servizio FOREIGN KEY (servizio_id) REFERENCES cpass_t_servizio(servizio_id)
);
--drop table if exists CPASS_T_FLUSSO_IMPEGNI_ESTERNI;
--drop table if exists CPASS_T_FLUSSO_SUBIMPEGNI_ESTERNI;

create table if not exists cpass.CPASS_T_FLUSSO_IMPEGNI_ESTERNI(
     FLUSSO_IMPEGNI_ESTERNI_ID SERIAL Primary Key
    ,ELABORAZIONE_ID	INTEGER
    ,ID_ENTE        UUID
    ,ENTE_CODICE	VARCHAR(200)
    ,BIL_ANNO	VARCHAR(200)
    ,ANNO_IMPEGNO	VARCHAR(200)
    ,NUM_IMPEGNO	VARCHAR(200)
    ,DESC_IMPEGNO	VARCHAR(200)
    ,COD_IMPEGNO	VARCHAR(200)
    ,COD_STATO_IMPEGNO	VARCHAR(200)
    ,DESC_STATO_IMPEGNO	VARCHAR(200)
    ,DATA_SCADENZA	VARCHAR(200)
    ,PARERE_FINANZIARIO	VARCHAR(200)
    ,COD_CAPITOLO	VARCHAR(200)
    ,COD_ARTICOLO	VARCHAR(200)
    ,COD_UEB	VARCHAR(200)
    ,DESC_CAPITOLO	VARCHAR(200)
    ,DESC_ARTICOLO	VARCHAR(200)
    ,COD_SOGGETTO	VARCHAR(200)
    ,DESC_SOGGETTO	VARCHAR(200)
    ,CF_SOGGETTO	VARCHAR(200)
    ,CF_ESTERO_SOGGETTO	VARCHAR(200)
    ,P_IVA_SOGGETTO	VARCHAR(200)
    ,COD_CLASSE_SOGGETTO	VARCHAR(200)
    ,DESC_CLASSE_SOGGETTO	VARCHAR(200)
    ,COD_TIPO_IMPEGNO	VARCHAR(200)
    ,DESC_TIPO_IMPEGNO	VARCHAR(200)
    ,ANNORIACCERTATO	VARCHAR(200)
    ,NUMRIACCERTATO	VARCHAR(200)
    ,ANNO_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,NUM_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,OGGETTO_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,COD_TIPO_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,COD_CDR_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,DESC_CDR_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,COD_CDC_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,DESC_CDC_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,IMPORTO_INIZIALE	VARCHAR(200)
    ,IMPORTO_ATTUALE	VARCHAR(200)
    ,IMPORTO_UTILIZZABILE	VARCHAR(200)
    ,CIG	VARCHAR(200)
    ,CUP	VARCHAR(200)
    ,IMPORTO_LIQUIDATO	VARCHAR(200)
    ,DATA_ELABORAZIONE	VARCHAR(200)
    ,NUM_ELABORAZIONE_DI_GIORNATA	VARCHAR(200)
    ,ESITO	VARCHAR(200)
    ,ERRORE	VARCHAR(4000)
);

create table if not exists cpass.cpass_T_FLUSSO_SUBIMPEGNI_ESTERNI(
     FLUSSO_SUBIMPEGNI_ESTERNI_ID SERIAL Primary Key
    ,ELABORAZIONE_ID	INTEGER
    ,ID_ENTE UUID
    ,ENTE_CODICE	VARCHAR(200)
    ,BIL_ANNO	VARCHAR(200)
    ,ANNO_IMPEGNO	VARCHAR(200)
    ,NUM_IMPEGNO	VARCHAR(200)
    ,COD_SUBIMPEGNO	VARCHAR(200)
    ,DESC_SUBIMPEGNO	VARCHAR(200)
    ,COD_STATO_SUBIMPEGNO	VARCHAR(200)
    ,COD_SOGGETTO	VARCHAR(200)
    ,DESC_SOGGETTO	VARCHAR(200)
    ,CF_SOGGETTO	VARCHAR(200)
    ,CF_ESTERO_SOGGETTO	VARCHAR(200)
    ,P_IVA_SOGGETTO	VARCHAR(200)
    ,COD_CLASSE_SOGGETTO	VARCHAR(200)
    ,DESC_CLASSE_SOGGETTO	VARCHAR(200)
    ,COD_TIPO_IMPEGNO	VARCHAR(200)
    ,DESC_TIPO_IMPEGNO	VARCHAR(200)
    ,ANNORIACCERTATO	VARCHAR(200)
    ,NUMRIACCERTATO	VARCHAR(200)
    ,ANNO_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,NUM_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,OGGETTO_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,COD_TIPO_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,COD_CDR_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,DESC_CDR_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,COD_CDC_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,DESC_CDC_ATTO_AMMINISTRATIVO	VARCHAR(200)
    ,IMPORTO_INIZIALE	VARCHAR(200)
    ,IMPORTO_ATTUALE	VARCHAR(200)
    ,IMPORTO_UTILIZZABILE	VARCHAR(200)
    ,IMPORTO_LIQUIDATO	VARCHAR(200)
    ,DATA_ELABORAZIONE	VARCHAR(200)
    ,ESITO	VARCHAR(200)
    ,ERRORE	VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS cpass.cpass_t_testi_notifiche (
	testo_id serial NOT NULL,
	codice VARCHAR(50),
	it_testo VARCHAR(2000),
	en_testo VARCHAR(2000),
	CONSTRAINT cpass_t_testi_notifiche_pk PRIMARY KEY (testo_id)
);

-- aggiorno solo i campi se la tabella già esiste nella sua prima versione --
ALTER TABLE IF EXISTS cpass.cpass_t_notifica ADD IF NOT EXISTS parametri jsonb NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_notifica DROP COLUMN IF EXISTS utente_id;
ALTER TABLE IF EXISTS cpass.cpass_t_notifica DROP COLUMN IF EXISTS testo_notifica;
ALTER TABLE IF EXISTS cpass.cpass_t_notifica ADD IF NOT EXISTS testo_id integer NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_notifica DROP COLUMN IF EXISTS flg_letto;

-- se non esiste la creo nel modo corretto
create table if not exists cpass.cpass_t_notifica(
     notifica_id serial Primary key
    ,testo_id integer NOT NULL
    ,entita_id VARCHAR(50)--(testata_ordine_id. etc)
    ,entita_tipo VARCHAR(50) --(stringa es. ORDINE, ACQUISTO.etc)
    ,fonte VARCHAR(50) --(MIT, NSO)
    ,data_inizio TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    ,data_fine   TIMESTAMP
    ,flg_generico boolean default false
    ,parametri JSONB
    ,CONSTRAINT cpass_t_notifica_testi_fk FOREIGN KEY (testo_id)
                	REFERENCES cpass_t_testi_notifiche (testo_id)
);

CREATE TABLE IF NOT EXISTS cpass.cpass_r_notifica_utente (
	notifica_utente_id serial NOT NULL,
	notifica_id integer,
	utente_id uuid,
	flg_letto bool NOT NULL DEFAULT false,
	CONSTRAINT cpass_r_notifica_utente_pkey PRIMARY KEY (notifica_utente_id),
	CONSTRAINT cpass_r_notifica_utente_utente_fk FOREIGN KEY (utente_id) REFERENCES cpass_t_utente (utente_id),
	CONSTRAINT cpass_r_notifica_utente_notifica_fk FOREIGN KEY (notifica_id) REFERENCES cpass_t_notifica (notifica_id)
);

ALTER TABLE IF EXISTS cpass.cpass_d_tipo_settore ADD COLUMN IF NOT EXISTS flag_direzione boolean DEFAULT false NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_d_tipo_settore ADD COLUMN IF NOT EXISTS flag_utilizzabile boolean DEFAULT false NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_d_tipo_settore ADD COLUMN IF NOT EXISTS ente_id UUID;
ALTER TABLE IF EXISTS cpass.cpass_d_tipo_settore DROP CONSTRAINT IF EXISTS fk_cpass_d_tipo_settore_t_ente;
ALTER TABLE IF EXISTS cpass.cpass_d_tipo_settore ADD CONSTRAINT fk_cpass_d_tipo_settore_t_ente FOREIGN KEY (ente_id) REFERENCES cpass.cpass_t_ente(ente_id);

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD COLUMN IF NOT EXISTS tipo_acquisto_id Integer;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP CONSTRAINT IF EXISTS cpass_t_ord_tipo_acquisto_fk;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT cpass_t_ord_tipo_acquisto_fk FOREIGN KEY (tipo_acquisto_id) REFERENCES cpass_d_pba_settore_interventi (settore_interventi_id);

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD COLUMN IF NOT EXISTS provvedimento_tipo varchar(50);
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD COLUMN IF NOT EXISTS provvedimento_settore varchar(50);
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD COLUMN IF NOT EXISTS provvedimento_descrizione varchar(200);
ALTER TABLE IF EXISTS cpass.cpass_t_impegno ADD COLUMN IF NOT EXISTS provvedimento_tipo varchar(50);
ALTER TABLE IF EXISTS cpass.cpass_t_subimpegno ADD COLUMN IF NOT EXISTS provvedimento_tipo varchar(50);


ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_evasione ADD COLUMN IF NOT EXISTS note varchar(4000);
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_evasione DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_testata_evasione_ddt ;
DROP VIEW IF EXISTS cpass.cpass_v_riepilogo_fattura_evasione; 
DROP VIEW IF EXISTS cpass.cpass_v_evasione ;
DROP VIEW IF EXISTS cpass.cpass_v_settore ;


CREATE OR REPLACE VIEW cpass.cpass_v_evasione (
    evasione_id,
    testata_evasione_id,
    evasione_anno,
    evasione_numero,
    fornitore_id,
    data_inserimento,
    settore_competente_id,
    stato_id,
    ufficio_id,
    totale_con_iva,
    utente_compilatore_id,
    descrizione,
    data_conferma,
    data_ripartizione,
    data_invio_contabilita,
    data_autorizzazione,
    fattura_anno,
    fattura_numero,
    fattura_tipo,
    fattura_codice,
    fattura_protocollo_anno,
    fattura_protocollo_numero,
    fattura_totale,
    fattura_totale_liquidabile,
    data_consegna,
    documento_consegna,
    documento_data_consegna,
    --documento_trasporto_id,
    tipo_evasione_id,
    note,
    data_cancellazione_testata,
    destinatario_evasione_id,
    progressivo_destinatario,
    indirizzo,
    num_civico,
    localita,
    provincia,
    cap,
    contatto,
    email,
    telefono,
    destinatario_id,
    settore_destinatario_id,
    stato_el_ordine_id_destinatario,
    data_cancellazione_destinatario,
    riga_evasione_id,
    progressivo_riga,
    importo_totale,
    prezzo_unitario,
    riga_ordine_id,
    aliquote_iva_id,
    oggetti_spesa_id,
    stato_el_ordine_id,
    listino_fornitore_id,
    --documento_trasporto_riga_id,
    data_cancellazione_riga,
    impegno_evasione_id,
    impegno_id,
    impegno_ordine_id,
    impegno_progressivo,
    impegno_anno_esercizio,
    impegno_anno,
    impegno_numero,
    importo_ripartito,
    importo_sospeso,
    importo_liquidato,
    causale_sospensione_id,
    data_sospensione,
    data_cancellazione_impegno,
    causale_sospensione_codice,
    causale_sospensione_descrizione,
    numero_capitolo,
    numero_articolo,
    subimpegno_evasione_id,
    subimpegno_anno,
    subimpegno_numero,
    sub_importo_ripartito,
    sub_importo_sospeso,
    sub_importo_liquidato,
    subimpegno_id,
    subimpegno_ordine_id,
    data_creazione,
    data_cancellazione_subimpegno)
AS
SELECT row_number() OVER () AS evasione_id,
    cpass_t_ord_testata_evasione.testata_evasione_id,
    cpass_t_ord_testata_evasione.evasione_anno,
    cpass_t_ord_testata_evasione.evasione_numero,
    cpass_t_ord_testata_evasione.fornitore_id,
    cpass_t_ord_testata_evasione.data_inserimento,
    cpass_t_ord_testata_evasione.settore_competente_id,
    cpass_t_ord_testata_evasione.stato_id,
    cpass_t_ord_testata_evasione.ufficio_id,
    cpass_t_ord_testata_evasione.totale_con_iva,
    cpass_t_ord_testata_evasione.utente_compilatore_id,
    cpass_t_ord_testata_evasione.descrizione,
    cpass_t_ord_testata_evasione.data_conferma,
    cpass_t_ord_testata_evasione.data_ripartizione,
    cpass_t_ord_testata_evasione.data_invio_contabilita,
    cpass_t_ord_testata_evasione.data_autorizzazione,
    cpass_t_ord_testata_evasione.fattura_anno,
    cpass_t_ord_testata_evasione.fattura_numero,
    cpass_t_ord_testata_evasione.fattura_tipo,
    cpass_t_ord_testata_evasione.fattura_codice,
    cpass_t_ord_testata_evasione.fattura_protocollo_anno,
    cpass_t_ord_testata_evasione.fattura_protocollo_numero,
    cpass_t_ord_testata_evasione.fattura_totale,
    cpass_t_ord_testata_evasione.fattura_totale_liquidabile,
    cpass_t_ord_testata_evasione.data_consegna,
    cpass_t_ord_testata_evasione.documento_consegna,
    cpass_t_ord_testata_evasione.documento_data_consegna,
    --cpass_t_ord_testata_evasione.documento_trasporto_id,
    cpass_t_ord_testata_evasione.tipo_evasione_id,
    cpass_t_ord_testata_evasione.note,
    cpass_t_ord_testata_evasione.data_cancellazione AS data_cancellazione_testata,
    cpass_t_ord_destinatario_evasione.destinatario_evasione_id,
    cpass_t_ord_destinatario_evasione.progressivo AS progressivo_destinatario,
    cpass_t_ord_destinatario_evasione.indirizzo,
    cpass_t_ord_destinatario_evasione.num_civico,
    cpass_t_ord_destinatario_evasione.localita,
    cpass_t_ord_destinatario_evasione.provincia,
    cpass_t_ord_destinatario_evasione.cap,
    cpass_t_ord_destinatario_evasione.contatto,
    cpass_t_ord_destinatario_evasione.email,
    cpass_t_ord_destinatario_evasione.telefono,
    cpass_t_ord_destinatario_evasione.destinatario_id,
    cpass_t_ord_destinatario_evasione.settore_destinatario_id,
    cpass_t_ord_destinatario_evasione.stato_el_ordine_id AS
        stato_el_ordine_id_destinatario,
    cpass_t_ord_destinatario_evasione.data_cancellazione AS
        data_cancellazione_destinatario,
    cpass_t_ord_riga_evasione.riga_evasione_id,
    cpass_t_ord_riga_evasione.progressivo AS progressivo_riga,
    cpass_t_ord_riga_evasione.importo_totale,
    cpass_t_ord_riga_evasione.prezzo_unitario,
    cpass_t_ord_riga_evasione.riga_ordine_id,
    cpass_t_ord_riga_evasione.aliquote_iva_id,
    cpass_t_ord_riga_evasione.oggetti_spesa_id,
    cpass_t_ord_riga_evasione.stato_el_ordine_id,
    cpass_t_ord_riga_evasione.listino_fornitore_id,
    --cpass_t_ord_riga_evasione.documento_trasporto_riga_id,
    cpass_t_ord_riga_evasione.data_cancellazione AS data_cancellazione_riga,
    cpass_t_ord_impegno_evasione.impegno_evasione_id,
    cpass_t_ord_impegno_evasione.impegno_id,
    cpass_t_ord_impegno_evasione.impegno_ordine_id,
    cpass_t_ord_impegno_evasione.impegno_progressivo,
    cpass_t_ord_impegno_evasione.impegno_anno_esercizio,
    cpass_t_ord_impegno_evasione.impegno_anno,
    cpass_t_ord_impegno_evasione.impegno_numero,
    cpass_t_ord_impegno_evasione.importo_ripartito,
    cpass_t_ord_impegno_evasione.importo_sospeso,
    cpass_t_ord_impegno_evasione.importo_liquidato,
    cpass_t_ord_impegno_evasione.causale_sospensione_id,
    cpass_t_ord_impegno_evasione.data_sospensione,
    cpass_t_ord_impegno_evasione.data_cancellazione AS data_cancellazione_impegno,
    cpass_d_ord_causale_sospensione_evasione.causale_sospensione_codice,
    cpass_d_ord_causale_sospensione_evasione.causale_sospensione_descrizione,
    cpass_t_impegno.numero_capitolo,
    cpass_t_impegno.numero_articolo,
    cpass_t_ord_subimpegno_evasione.subimpegno_evasione_id,
    cpass_t_ord_subimpegno_evasione.subimpegno_anno,
    cpass_t_ord_subimpegno_evasione.subimpegno_numero,
    cpass_t_ord_subimpegno_evasione.importo_ripartito AS sub_importo_ripartito,
    cpass_t_ord_subimpegno_evasione.importo_sospeso AS sub_importo_sospeso,
    cpass_t_ord_subimpegno_evasione.importo_liquidato AS sub_importo_liquidato,
    cpass_t_ord_subimpegno_evasione.subimpegno_id,
    cpass_t_ord_subimpegno_evasione.subimpegno_ordine_id,
    cpass_t_ord_subimpegno_evasione.data_creazione,
    cpass_t_ord_subimpegno_evasione.data_cancellazione AS data_cancellazione_subimpegno
FROM cpass_t_ord_testata_evasione
     JOIN cpass_t_ord_destinatario_evasione ON
         cpass_t_ord_testata_evasione.testata_evasione_id = cpass_t_ord_destinatario_evasione.testata_evasione_id
     LEFT JOIN cpass_t_ord_riga_evasione ON
         cpass_t_ord_destinatario_evasione.destinatario_evasione_id = cpass_t_ord_riga_evasione.destinatario_evasione_id
     LEFT JOIN cpass_t_ord_impegno_evasione ON
         cpass_t_ord_riga_evasione.riga_evasione_id = cpass_t_ord_impegno_evasione.riga_evasione_id
     LEFT JOIN cpass_d_ord_causale_sospensione_evasione ON
         cpass_t_ord_impegno_evasione.causale_sospensione_id = cpass_d_ord_causale_sospensione_evasione.causale_sospensione_id
     LEFT JOIN cpass_t_impegno ON cpass_t_impegno.impegno_id =
         cpass_t_ord_impegno_evasione.impegno_id
     LEFT JOIN cpass_t_ord_subimpegno_evasione ON
         cpass_t_ord_impegno_evasione.impegno_evasione_id = cpass_t_ord_subimpegno_evasione.impegno_evasione_id;
         
CREATE OR REPLACE VIEW cpass.cpass_v_riepilogo_fattura_evasione (
    riepilogo_fattura_evasione_id,
    testata_evasione_id,
    impegno_anno_esercizio,
    impegno_anno,
    impegno_numero,
    subimpegno_anno,
    subimpegno_numero,
    ripartito,
    sospeso,
    causale_sospensione_codice,
    causale_sospensione_descrizione,
    data_sospensione)
AS
SELECT row_number() OVER () AS riepilogo_fattura_evasione_id,
    riepilogo.testata_evasione_id,
    riepilogo.impegno_anno_esercizio,
    riepilogo.impegno_anno,
    riepilogo.impegno_numero,
    riepilogo.subimpegno_anno,
    riepilogo.subimpegno_numero,
        CASE
            WHEN riepilogo.subimpegno_anno IS NULL THEN riepilogo.imp_ripartito
            ELSE riepilogo.subimp_ripartito
        END AS ripartito,
        CASE
            WHEN riepilogo.subimpegno_anno IS NULL THEN riepilogo.imp_sospeso
            ELSE riepilogo.subimp_sospeso
        END AS sospeso,
    riepilogo.causale_sospensione_codice,
    riepilogo.causale_sospensione_descrizione,
    riepilogo.data_sospensione
FROM (
    SELECT tmp.testata_evasione_id,
            tmp.impegno_anno_esercizio,
            tmp.impegno_anno,
            tmp.impegno_numero,
            tmp.subimpegno_anno,
            tmp.subimpegno_numero,
            tmp.causale_sospensione_codice,
            tmp.causale_sospensione_descrizione,
            tmp.data_sospensione,
            sum(COALESCE(tmp.importo_ripartito, 0::numeric)) AS imp_ripartito,
            sum(COALESCE(tmp.importo_sospeso, 0::numeric)) AS imp_sospeso,
            sum(COALESCE(tmp.sub_importo_ripartito, 0::numeric)) AS subimp_ripartito,
            sum(COALESCE(tmp.sub_importo_sospeso, 0::numeric)) AS subimp_sospeso
    FROM cpass_v_evasione tmp
    WHERE tmp.impegno_anno IS NOT NULL
    GROUP BY tmp.testata_evasione_id, tmp.impegno_anno_esercizio,
        tmp.impegno_anno, tmp.impegno_numero, tmp.subimpegno_anno, tmp.subimpegno_numero, tmp.causale_sospensione_codice, tmp.causale_sospensione_descrizione, tmp.data_sospensione
    ORDER BY tmp.testata_evasione_id, tmp.impegno_anno_esercizio,
        tmp.impegno_anno, tmp.impegno_numero, tmp.subimpegno_anno, tmp.subimpegno_numero
    ) riepilogo;

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
  ORDER BY alberosettore.livello DESC, alberosettore.settore_id;

-- Permissions

ALTER TABLE cpass.cpass_v_settore OWNER TO cpass;

ALTER TABLE cpass.cpass_t_ord_testata_evasione DROP COLUMN if exists documento_trasporto_id;
ALTER TABLE cpass.cpass_t_ord_riga_evasione    DROP COLUMN if exists documento_trasporto_riga_id;


drop table if exists CPASS_T_ORD_DOCUMENTO_TRASPORTO_XML;
drop table if exists cpass_t_ord_documento_trasporto_riga;
drop table if exists cpass_t_ord_documento_trasporto;

CREATE TABLE cpass.cpass_t_ord_documento_trasporto (
  documento_trasporto_id SERIAL,
  despatch_advice_id INTEGER,
  id_notier varchar(200) NOT NULL,
  stato_id INTEGER NOT NULL,
  fornitore_id UUID  NOT NULL,
  testata_evasione_id UUID,
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
  CONSTRAINT cpass_t_ord_documento_trasporto_pkey PRIMARY KEY(documento_trasporto_id)
) 
WITH (oids = false);

COMMENT ON TABLE cpass.cpass_t_ord_documento_trasporto
IS 'UUID namespace: "cpass_t_ord_documento_trasporto"';

ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto DROP CONSTRAINT IF EXISTS fk_cpass_T_DOCUMENTO_TRASPORTO_RIGA_stato;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto DROP CONSTRAINT IF EXISTS fk_cpass_T_DOCUMENTO_TRASPORTO_fornitore;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto DROP CONSTRAINT IF EXISTS fk_cpass_T_DOCUMENTO_TRASPORTO_evasione;



ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto ADD CONSTRAINT fk_cpass_T_DOCUMENTO_TRASPORTO_STATO FOREIGN KEY (STATO_ID) 
REFERENCES cpass.CPASS_D_STATO(STATO_ID);

ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto ADD CONSTRAINT fk_cpass_T_DOCUMENTO_TRASPORTO_fornitore FOREIGN KEY (fornitore_id) 
REFERENCES cpass.CPASS_T_FORNITORE(fornitore_id);

ALTER TABLE IF EXISTS cpass.cpass_t_ord_documento_trasporto ADD CONSTRAINT fk_cpass_T_DOCUMENTO_TRASPORTO_evasione FOREIGN KEY (testata_evasione_id) 
REFERENCES cpass.CPASS_T_ORD_TESTATA_EVASIONE(testata_evasione_id);

CREATE TABLE if not exists CPASS_T_ORD_DOCUMENTO_TRASPORTO_XML(
		 DOCUMENTO_TRASPORTO_XML_ID SERIAL PRIMARY KEY
		,DOCUMENTO_TRASPORTO_ID INTEGER not null
		,DESPATCH_ADVICE_ID INTEGER not null
		,DATA_CONSEGNA varchar(10)
		,NOTE varchar(4000)
		,TIPODOC varchar(4000)
		,File_xml text 
		,PATH_file  varchar(400)
		,DATA_SPOSTAMENTO timestamp
);
ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_DOCUMENTO_TRASPORTO_XML ADD CONSTRAINT fk_CPASS_T_ORD_DOCUMENTO_TRASPORTO_XML_doc_trasporto FOREIGN KEY (DOCUMENTO_TRASPORTO_ID) REFERENCES cpass.CPASS_T_ORD_DOCUMENTO_TRASPORTO(DOCUMENTO_TRASPORTO_ID);


CREATE TABLE cpass.cpass_t_ord_documento_trasporto_riga (
  documento_trasporto_riga_id SERIAL,
  documento_trasporto_id INTEGER NOT NULL,
  progressivo_riga_id INTEGER NOT NULL,
  unita_misura VARCHAR(40),
  qta_evasa INTEGER,
  qta_inevasa INTEGER,
  motivo_qta_inevasa VARCHAR(4000),
  progressivo_riga_ordine_evasa INTEGER,
  testata_ordine_id UUID,
  riga_ordine_id UUID,
  ordine_nso_id INTEGER NOT NULL,
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
    NOT DEFERRABLE
  
) 
WITH (oids = false);

COMMENT ON TABLE cpass.cpass_t_ord_documento_trasporto_riga
IS 'UUID namespace: "cpass_t_ord_documento_trasporto_riga"';

ALTER TABLE cpass.cpass_t_ufficio add COLUMN if not exists  id_notier varchar(200)   ;



----------------------------------------------------------------------------- DML

INSERT INTO cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
SELECT tmp.stato_codice, tmp.stato_descrizione, tmp.stato_tipo
FROM (VALUES
  ('IN_CONTABILITA','IN CONTABILITA','EVASIONE'),
  ('AUTORIZZATA','AUTORIZZATA','EVASIONE')

) AS tmp(stato_codice, stato_descrizione, stato_tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato current
  WHERE current.stato_codice = tmp.stato_codice
);


INSERT INTO cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.tipo
FROM (VALUES
('CONFERMATA','CONFERMATA','EVASIONE')
) AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_stato ds
	WHERE ds.stato_codice = tmp.codice
	and   ds.stato_tipo = tmp.tipo
);

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, NULL
FROM (VALUES
  ('IMPLEMENTOR','siac',true,'LEGGI-STATO-ELABORAZIONE-DOCUMENTO','','Per interrogazione LEGGI-STATO-ELABORAZIONE-DOCUMENTOO'),
  ('IMPLEMENTOR_POJO_NAME','it.csi.cpass.cpassbe.lib.external.impl.siac.LeggiStatoElaborazioneDocumentoHelperImpl',true,'LEGGI-STATO-ELABORAZIONE-DOCUMENTO','SIAC','Per interrogazione LEGGI-STATO-ELABORAZIONE-DOCUMENTO')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, NULL
FROM (VALUES
  ('IMPLEMENTOR','stilo',true,'PROVVEDIMENTO','','Per interrogazione PROVVEDIMENTO STILO '),
  ('IMPLEMENTOR_POJO_NAME','it.csi.cpass.cpassbe.lib.external.impl.stilo.ProvvedimentoHelperImpl',true,'PROVVEDIMENTO','STILO','Per interrogazione PROVVEDIMENTO')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);

INSERT INTO cpass.cpass_d_provvedimento_tipo (provvedimento_tipo_codice, provvedimento_tipo_descrizione)
SELECT tmp.provvedimento_tipo_codice, tmp.provvedimento_tipo_descrizione
FROM (VALUES
('AD','Atto Dirigenziale'),
('DD','Determina Dirigenziale')

) AS tmp(provvedimento_tipo_codice, provvedimento_tipo_descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_provvedimento_tipo current
  WHERE current.provvedimento_tipo_codice = tmp.provvedimento_tipo_codice
);

insert into cpass.cpass_t_servizio (servizio_codice)
select tmp.codice 
from (values 
	('VERIFICA_EVASIONE')
	)AS tmp(codice)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_t_servizio rfs
	WHERE rfs.servizio_codice = tmp.codice
);

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata,tmp.riferimento,tmp.ambiente,tmp.note
FROM (values
	('POLL_TIME_NOTIFICATIONS', '2.0', true, 'NOTIFICA', '', 'Minuti tra una chiamata e l''altra per il poll delle notifiche')
) AS tmp (chiave, valore, abilitata,riferimento,ambiente,note)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_t_parametro ctp
	WHERE ctp.chiave = tmp.chiave
);

INSERT INTO cpass.cpass_d_pba_ausa (ausa_codice, ausa_descrizione, ausa_codice_fiscale)
SELECT tmp.codice, tmp.descrizione, tmp.cf
FROM (VALUES
  ('0000226120','CONSIP SPA UNIP.','05359681003')

) AS tmp(codice, descrizione, cf)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_pba_ausa da
  WHERE da.ausa_codice = tmp.codice
);

INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('VERIFICA_STRUTTURA_PROVVEDIMENTO','A',true,'PROVVEDIMENTO','','')
	) AS tmp(chiave, valore, abilitata, riferimento,ambiente, note)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);



INSERT INTO cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
SELECT tmp.stato_codice, tmp.stato_descrizione, tmp.stato_tipo
FROM (VALUES
  ('DA_ABBINARE','DA ABBINARE','DOCUMENTO_DI_TRASPORTO'),
  ('ABBINATO','ABBINATO','DOCUMENTO_DI_TRASPORTO'),
  ('SCARTATO','SCARTATO','DOCUMENTO_DI_TRASPORTO')

) AS tmp(stato_codice, stato_descrizione, stato_tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato current
  WHERE current.stato_codice = tmp.stato_codice
);

