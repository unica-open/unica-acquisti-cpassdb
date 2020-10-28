---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2020 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2020 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
---
--SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'cpass';

/*DROP TABLE IF EXISTS cpass.cpass_d_oggetti_spesa CASCADE;
DROP TABLE IF EXISTS cpass.cpass_d_ord_tipo_procedura CASCADE;
DROP TABLE IF EXISTS cpass.cpass_d_stato_el_ordine CASCADE;
DROP TABLE IF EXISTS cpass.cpass_d_unita_misura CASCADE;
DROP TABLE IF EXISTS cpass.cpass_d_aliquote_iva CASCADE;
DROP TABLE IF EXISTS cpass.cpass_d_ord_tipo_ordine CASCADE;
DROP TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine  CASCADE;
DROP TABLE IF EXISTS cpass.cpass_r_ufficio_settore CASCADE;
DROP TABLE IF EXISTS cpass.cpass_t_ufficio  CASCADE;
DROP TABLE IF EXISTS cpass.cpass_t_fornitore  CASCADE;
DROP TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine  CASCADE;
DROP TABLE IF EXISTS cpass.cpass_t_ord_destinatario  CASCADE;
DROP TABLE IF EXISTS cpass.cpass_t_settore_indirizzo CASCADE;
DROP TABLE IF EXISTS cpass.CPASS_T_SUBIMPEGNO CASCADE;
DROP TABLE IF EXISTS cpass.CPASS_T_IMPEGNO CASCADE;
DROP TABLE IF EXISTS cpass.CPASS_T_ORD_SUBIMPEGNO_ORDINE CASCADE;
DROP TABLE IF EXISTS cpass.CPASS_T_ORD_IMPEGNO_ORDINE CASCADE;
DROP TABLE IF EXISTS cpass.cpass_t_ord_impegno_associato CASCADE;
DROP TABLE IF EXISTS cpass.cpass_t_ord_subimpegno_associato CASCADE;*/
drop view if exists cpass.cpass_v_settore;


ALTER TABLE IF EXISTS cpass.cpass_t_settore ADD COLUMN IF NOT EXISTS settore_padre_id UUID;
ALTER TABLE IF EXISTS cpass.cpass_t_settore DROP CONSTRAINT IF EXISTS fk_cpass_t_settore_settore;
ALTER TABLE IF EXISTS cpass.cpass_t_settore ADD CONSTRAINT fk_cpass_t_settore_settore FOREIGN KEY (settore_padre_id) REFERENCES cpass.cpass_t_settore (settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;


CREATE TABLE if not exists cpass.cpass_t_settore_indirizzo (
    settore_indirizzo_id SERIAL
    ,descrizione varchar (50)
    ,indirizzo varchar(200)
    ,num_civico varchar(20)
    ,localita varchar(200)
    ,provincia varchar(200)
    ,cap varchar(5)
    ,contatto varchar(200)
    ,email varchar(50)
    ,telefono varchar(50)
    ,settore_id uuid
    ,data_creazione TIMESTAMP NOT NULL
    ,utente_creazione CHARACTER VARYING(250) NOT NULL
	,data_modifica TIMESTAMP NOT NULL DEFAULT now()
	,utente_modifica CHARACTER VARYING(250) NOT NULL
	,data_cancellazione TIMESTAMP
	,utente_cancellazione CHARACTER VARYING(250)
	,optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    ,CONSTRAINT cpass_t_settore_indirizzo_pkey PRIMARY KEY(settore_indirizzo_id)
    ,CONSTRAINT fk_cpass_T_settore_settore_indirizzo FOREIGN KEY (settore_id) REFERENCES cpass.cpass_T_settore(settore_id)
);

CREATE TABLE if not exists cpass.cpass_d_ord_tipo_procedura (
    tipo_procedura_id SERIAL ,
    tipo_procedura_codice VARCHAR(50) NOT NULL,
    tipo_procedura_descrizione VARCHAR(500) NOT NULL,
    tipo_procedura_numero VARCHAR(50) NOT NULL,
    CONSTRAINT cpass_d_ord_tipo_procedura_pkey PRIMARY KEY(tipo_procedura_id)
);

CREATE TABLE if not exists cpass.cpass_d_stato_el_ordine (
    stato_el_ordine_id SERIAL ,
    stato_codice VARCHAR(50) NOT NULL,
    stato_descrizione VARCHAR(500) NOT NULL,
    stato_tipo VARCHAR(50) NOT NULL,
     CONSTRAINT cpass_d_stato_el_ordine_pkey PRIMARY KEY(stato_el_ordine_id)
);


CREATE TABLE if not exists cpass.cpass_t_ufficio (
   ufficio_id  SERIAL ,
   ufficio_codice VARCHAR(50) NOT NULL,
   ufficio_descrizione VARCHAR(500) NOT NULL,
   settore_id UUID NOT NULL,
   CONSTRAINT cpass_t_ufficio_pkey PRIMARY KEY(ufficio_id)
);

--ALTER TABLE ONLY cpass.cpass_t_ufficio ADD CONSTRAINT fk_cpass_t_ufficio_t_settore FOREIGN KEY (settore_id) REFERENCES cpass.cpass_t_settore (settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

-----------------------------------------
CREATE TABLE if not exists         cpass.cpass_d_ord_tipo_ordine (
  tipo_ordine_id SERIAL ,
  tipologia_documento_codice VARCHAR(50) NOT NULL,
  tipologia_documento_descrizione VARCHAR(500) NOT NULL,
  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  CONSTRAINT cpass_d_ord_tipo_ordine_pkey PRIMARY KEY(tipo_ordine_id)
) ;

----------------------------------------
CREATE TABLE if not exists cpass.cpass_t_fornitore(
    fornitore_id UUID
    ,codice varchar(50)
    ,natura_giuridica varchar(5)
	,ragione_sociale varchar(200)	--"RAGSOC" VARCHAR2(150 BYTE) NOT NULL ENABLE,
	,cognome varchar(50)				--"COGNOME" VARCHAR2(50 BYTE),
	,nome varchar(50)   				--"NOME" VARCHAR2(50 BYTE),
	,codice_fiscale varchar(16)      --"CODFISC" VARCHAR2(16 BYTE),
	,codice_fiscale_estero varchar(21)     -- "CODFISC_ESTERO" VARCHAR2(21 BYTE),
	,partita_iva VARCHAR(11)--"PARTIVA" VARCHAR2(11 BYTE),
	--,sedime VARCHAR(10)--"SEDIME" VARCHAR2(10 BYTE),
	,indirizzo varchar(500) --"VIA" VARCHAR2(500 BYTE),
	,numero_civico varchar(40)--"N_CIVICO" VARCHAR2(40 BYTE),
	,cap varchar(5)--"CAP" VARCHAR2(5 BYTE),
	,comune varchar(200)--"COMUNE" VARCHAR2(50 BYTE),
	,provincia varchar(2)--"PROV" VARCHAR2(2 BYTE),
	--,nazione VARCHAR(3)--"COD_STATO" VARCHAR2(3 BYTE),
	--,telefono VARCHAR(20) --"TEL1" VARCHAR2(20 BYTE),
	--,telefono2 VARCHAR(20) --"TEL2" VARCHAR2(20 BYTE),
	--,fax VARCHAR(20)--"FAX" VARCHAR2(15 BYTE),
    ,stato varchar(10) --"STAOPER" VARCHAR2(1 BYTE) NOT NULL ENABLE,  dalla tabella statieventualmente
    ,CONSTRAINT cpass_t_fornitore_pkey PRIMARY KEY(fornitore_id)
    );

-----------------------------------------------

CREATE TABLE if not exists cpass.cpass_t_ord_testata_ordine (
  testata_ordine_id UUID ,
  tipo_ordine_id INTEGER NOT NULL,
  ordine_anno INTEGER NOT NULL,
  ordine_numero INTEGER NOT NULL,
  fornitore_id UUID NOT NULL,
  tipo_procedura_id INTEGER NOT NULL,
  numero_procedura VARCHAR(50),
  data_emissione DATE NOT NULL,
  data_conferma DATE,
  data_autorizzazione DATE,

  totale_no_iva NUMERIC(13,5),
  totale_con_iva NUMERIC(13,5),
  descrizione_acquisto VARCHAR(150) NOT NULL,
  consegna_riferimento VARCHAR(200),
  consegna_data_da DATE,
  consegna_data_a DATE,
  consegna_indirizzo VARCHAR(50),
  consegna_cap VARCHAR(5),
  consegna_localita VARCHAR(50),
  provvedimento_anno INTEGER,
  provvedimento_numero VARCHAR(10),
  lotto_anno INTEGER,
  lotto_numero INTEGER,
  --data_invio_nso DATE,
  stato_invio_nso VARCHAR(50),
  utente_compilatore_id UUID NOT NULL,
  settore_emittente_id UUID NOT NULL,
  ufficio_id INTEGER ,
  stato_id INTEGER,
  note VARCHAR(4000),
  data_scadenza DATE,

  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  optlock UUID DEFAULT uuid_generate_v4() NOT NULL,
  CONSTRAINT cpass_t_ord_testata_ordine_pkey PRIMARY KEY(testata_ordine_id)
) ;
COMMENT ON TABLE cpass.cpass_t_ord_testata_ordine IS 'UUID namespace: "cpass_t_ord_testata_ordine"';

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_testata_ordine_d_stato;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_d_stato FOREIGN KEY (stato_id) REFERENCES cpass.cpass_d_stato (stato_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_testata_ordine_t_settore;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_t_settore FOREIGN KEY (settore_emittente_id) REFERENCES cpass.cpass_t_settore (settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_testata_ordine_d_ord_tipo_ordine;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_d_ord_tipo_ordine FOREIGN KEY (tipo_ordine_id) REFERENCES cpass.cpass_d_ord_tipo_ordine (tipo_ordine_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_testata_ordine_t_ufficio;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_t_ufficio FOREIGN KEY (ufficio_id) REFERENCES cpass.cpass_t_ufficio (ufficio_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_testata_ordine_tipo_procedura;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_tipo_procedura FOREIGN KEY (tipo_procedura_id) REFERENCES cpass.cpass_d_ord_tipo_procedura (tipo_procedura_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_testata_ordine_fornitore;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_fornitore FOREIGN KEY (fornitore_id) REFERENCES cpass.cpass_t_fornitore (fornitore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP CONSTRAINT IF EXISTS cpass_t_ord_testata_ordine_anno_numero_settore_unique;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT cpass_t_ord_testata_ordine_anno_numero_settore_unique UNIQUE (ordine_anno,ordine_numero,settore_emittente_id);

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_testata_ordine_t_utente;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_t_utente FOREIGN KEY (utente_compilatore_id) REFERENCES cpass.cpass_t_utente (utente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;


  CREATE TABLE if not exists cpass.cpass_t_ord_destinatario(
     destinatario_id UUID
	,indirizzo varchar(200)   --"INDIR_DEST" VARCHAR2(50 BYTE),
	,num_civico varchar(20)
	,localita varchar(200)    --"LOCAL_DEST" VARCHAR2(50 BYTE),
	,provincia varchar(200)   --"PROV_DEST" VARCHAR2(2 BYTE),
	,cap varchar(5)           --"CAP_DEST" VARCHAR2(5 BYTE),
	,contatto varchar(200) --"DESCR_DEST" VARCHAR2(150 BYTE),
	,email varchar(50)        --"DESCR_DEST" VARCHAR2(150 BYTE),
	,telefono varchar(50)     --"DESCR_DEST" VARCHAR2(150 BYTE),
	,data_invio_nso DATE
    ,stato_invio_nso VARCHAR(50)
    ,settore_destinatario_id  UUID  -- cpass_d_settore
    ,stato_el_ordine_id  INTEGER NOT NULL     --> cpass_d_stato_el_ordine
    ,testata_ordine_id UUID NOT NULL
    ,progressivo INTEGER  NOT NULL
    ,data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    ,utente_creazione CHARACTER VARYING(250) NOT NULL
	,data_modifica TIMESTAMP NOT NULL DEFAULT now()
	,utente_modifica CHARACTER VARYING(250) NOT NULL
	,data_cancellazione TIMESTAMP
	,utente_cancellazione CHARACTER VARYING(250)
	,optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    ,CONSTRAINT cpass_t_ord_destinatario_pkey PRIMARY KEY(destinatario_id)
	);

COMMENT ON TABLE cpass.cpass_t_ord_destinatario IS 'UUID namespace: "cpass_t_ord_destinatario"';

ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_destinatario_testata_ordine;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario ADD CONSTRAINT fk_cpass_t_ord_destinatario_testata_ordine FOREIGN KEY (testata_ordine_id) REFERENCES cpass.cpass_t_ord_testata_ordine (testata_ordine_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_destinatario_stato_el_ordine;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario ADD CONSTRAINT fk_cpass_t_ord_destinatario_stato_el_ordine FOREIGN KEY (stato_el_ordine_id) REFERENCES cpass.cpass_d_stato_el_ordine (stato_el_ordine_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_destinatario_settore;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario ADD CONSTRAINT fk_cpass_t_ord_destinatario_settore FOREIGN KEY (settore_destinatario_id) REFERENCES cpass.cpass_t_settore (settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario DROP CONSTRAINT IF EXISTS cpass_t_ord_destinatario_testata_progressivo_unique;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario ADD CONSTRAINT cpass_t_ord_destinatario_testata_progressivo_unique UNIQUE (testata_ordine_id,progressivo);


  CREATE TABLE if not exists cpass.cpass_d_unita_misura
   (
      unita_misura_id SERIAL
    , unita_misura_codice character varying(50) NOT NULL
    , unita_misura_descrizione character varying(500) NOT NULL
	, unita_misura_ambito_utilizzo  character varying(50) NOT NULL
	, data_validita_inizio TIMESTAMP NOT NULL
	, data_validita_fine TIMESTAMP
	, data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    , utente_creazione CHARACTER VARYING(250) NOT NULL
	, data_modifica TIMESTAMP NOT NULL DEFAULT now()
	, utente_modifica CHARACTER VARYING(250) NOT NULL
	, data_cancellazione TIMESTAMP
	, utente_cancellazione CHARACTER VARYING(250)
	, optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    ,CONSTRAINT cpass_d_unita_misura_pkey PRIMARY KEY(unita_misura_id)
);

  CREATE TABLE if not exists cpass.cpass_d_aliquote_iva
   (
     aliquote_iva_id SERIAL
    , aliquote_iva_codice character varying(50) NOT NULL
    , aliquote_iva_descrizione character varying(500) NOT NULL
    , percentuale NUMERIC(5,2)
	, codifica_peppol varchar (10)
	, data_validita_inizio TIMESTAMP NOT NULL
	, data_validita_fine TIMESTAMP
	, data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    , utente_creazione CHARACTER VARYING(250) NOT NULL
	, data_modifica TIMESTAMP NOT NULL DEFAULT now()
	, utente_modifica CHARACTER VARYING(250) NOT NULL
	, data_cancellazione TIMESTAMP
	, utente_cancellazione CHARACTER VARYING(250)
	, optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    ,CONSTRAINT cpass_d_aliquote_iva_pkey PRIMARY KEY(aliquote_iva_id)
);

CREATE TABLE if not exists cpass.cpass_d_oggetti_spesa(
     oggetti_spesa_id SERIAL
    ,oggetti_spesa_codice character varying(50) NOT NULL
    ,oggetti_spesa_descrizione character varying(500) NOT NULL
	,unita_misura_id  INTEGER NOT NULL
	,cpv_id		 INTEGER NOT NULL
	,aliquote_iva_id INTEGER
	,inventariabile boolean
	, prezzo_unitario NUMERIC (13,5) NOT NULL
	, data_validita_inizio TIMESTAMP NOT NULL
	, data_validita_fine TIMESTAMP NULL
    ,data_creazione TIMESTAMP NOT NULL
    ,utente_creazione CHARACTER VARYING(250) NOT NULL
	,data_modifica TIMESTAMP NOT NULL DEFAULT now()
	,utente_modifica CHARACTER VARYING(250) NOT NULL
	,data_cancellazione TIMESTAMP
	,utente_cancellazione CHARACTER VARYING(250)
	,optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    ,CONSTRAINT cpass_d_oggetti_spesa_pkey PRIMARY KEY(oggetti_spesa_id)
);
COMMENT ON TABLE cpass.cpass_d_oggetti_spesa IS 'cpass_d_oggetti_spesa';

ALTER TABLE IF EXISTS cpass.cpass_d_oggetti_spesa DROP CONSTRAINT IF EXISTS fk_cpass_d_oggetti_spesa_aliquote_iva;
ALTER TABLE IF EXISTS cpass.cpass_d_oggetti_spesa ADD CONSTRAINT fk_cpass_d_oggetti_spesa_aliquote_iva FOREIGN KEY (aliquote_iva_id) REFERENCES cpass.cpass_d_aliquote_iva (aliquote_iva_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_d_oggetti_spesa DROP CONSTRAINT IF EXISTS fk_cpass_d_oggetti_spesa_unita_misura;
ALTER TABLE IF EXISTS cpass.cpass_d_oggetti_spesa ADD CONSTRAINT fk_cpass_d_oggetti_spesa_unita_misura FOREIGN KEY (unita_misura_id) REFERENCES cpass.cpass_d_unita_misura (unita_misura_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_d_oggetti_spesa DROP CONSTRAINT IF EXISTS fk_cpass_d_oggetti_spesa_cpv;
ALTER TABLE IF EXISTS cpass.cpass_d_oggetti_spesa ADD CONSTRAINT fk_cpass_d_oggetti_spesa_cpv FOREIGN KEY (cpv_id) REFERENCES cpass.cpass_d_cpv (cpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;


CREATE TABLE if not exists cpass.cpass_t_ord_riga_ordine(
     riga_ordine_id UUID
    ,consegna_parziale boolean
    ,progressivo INTEGER
    ,prezzo_unitario NUMERIC(13,5)
    ,quantita INTEGER
	,percentuale_sconto  NUMERIC(8,5)--"SCONTO1" NUMBER(8,5),
	,importo_sconto  NUMERIC(8,5)--"SCONTO1" NUMBER(8,5),
    ,percentuale_sconto2  NUMERIC(8,5)--"SCONTO2" NUMBER(8,5),
	,importo_sconto2  NUMERIC(8,5)--"SCONTO1" NUMBER(8,5),
	,importo_netto  NUMERIC(13,5)--"SCONTO1" NUMBER(8,5),
	,importo_iva  NUMERIC(13,5)--"SCONTO1" NUMBER(8,5),
	,importo_totale  NUMERIC(13,5)--"SCONTO1" NUMBER(8,5),
	,note	VARCHAR(4000)
    ,stato_el_ordine_id  INTEGER NOT NULL     --> cpass_d_stato_el_ordine
    ,oggetti_spesa_id INTEGER NOT NULL
    --,cpv_id INTEGER NOT NULL
    ,unita_misura_id INTEGER NOT NULL
    ,aliquote_iva_id INTEGER NOT NULL
    ,destinatario_id UUID NOT NULL
    ,data_creazione TIMESTAMP NOT NULL
    ,utente_creazione CHARACTER VARYING(250) NOT NULL
	,data_modifica TIMESTAMP NOT NULL DEFAULT now()
	,utente_modifica CHARACTER VARYING(250) NOT NULL
	,data_cancellazione TIMESTAMP
	,utente_cancellazione CHARACTER VARYING(250)
	,optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    ,CONSTRAINT cpass_t_ord_riga_ordine_pkey PRIMARY KEY(riga_ordine_id)
 );

COMMENT ON TABLE cpass.cpass_t_ord_destinatario IS 'UUID namespace: "cpass_t_ord_riga_ordine"';

ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_riga_ordine_destinatario_ordine;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_ordine_destinatario_ordine FOREIGN KEY (destinatario_id) REFERENCES cpass.cpass_t_ord_destinatario (destinatario_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_riga_ordine_aliquote_iva;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_ordine_aliquote_iva FOREIGN KEY (aliquote_iva_id) REFERENCES cpass.cpass_d_aliquote_iva (aliquote_iva_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_ordine_cpv FOREIGN KEY (cpv_id) REFERENCES cpass.cpass_d_cpv (cpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_riga_oggetti_spesa;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_oggetti_spesa FOREIGN KEY (oggetti_spesa_id) REFERENCES cpass.cpass_d_oggetti_spesa (oggetti_spesa_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_riga_ordine_unita_misura;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_ordine_unita_misura FOREIGN KEY (unita_misura_id) REFERENCES cpass.cpass_d_unita_misura (unita_misura_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_riga_ordine_stato_el_ordine;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_ordine_stato_el_ordine FOREIGN KEY (stato_el_ordine_id) REFERENCES cpass.cpass_d_stato_el_ordine (stato_el_ordine_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE if not exists cpass.cpass_t_impegno (
	impegno_id UUID
	, ente_id UUID NOT NULL
	, impegno_anno_esercizio  INTEGER NOT NULL
	, impegno_anno INTEGER NOT NULL
	, impegno_numero INTEGER NOT NULL
	, impegno_descrizione varchar(150)
	, numero_capitolo INTEGER NOT NULL
	, numero_articolo INTEGER NOT NULL
	, descrizione_capitolo varchar(500)
	, provvedimento_anno INTEGER NOT NULL
	, provvedimento_numero INTEGER NOT NULL
	, provvedimento_settore varchar(50)
	, fornitore_id UUID
	, importo_iniziale NUMERIC NOT NULL
	, importo_attuale NUMERIC NOT NULL
	, stato varchar(1)
	, liq_anno_prec NUMERIC NOT NULL
    , data_creazione TIMESTAMP NOT NULL
    , utente_creazione CHARACTER VARYING(250) NOT NULL
	, data_modifica TIMESTAMP NOT NULL DEFAULT now()
	, utente_modifica CHARACTER VARYING(250) NOT NULL
	, data_cancellazione TIMESTAMP
	, utente_cancellazione CHARACTER VARYING(250)
	, optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    , CONSTRAINT cpass_t_impegno_pkey PRIMARY KEY(impegno_id)
	);
COMMENT ON TABLE cpass.cpass_t_impegno IS 'UUID namespace: "cpass_t_impegno"';

ALTER TABLE IF EXISTS cpass.cpass_t_impegno DROP CONSTRAINT IF EXISTS fk_cpass_t_impegno_ente;
ALTER TABLE IF EXISTS cpass.cpass_t_impegno ADD CONSTRAINT fk_cpass_t_impegno_ente FOREIGN KEY (ente_id) REFERENCES cpass.cpass_t_ente (ente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_impegno DROP CONSTRAINT IF EXISTS fk_cpass_t_impegno_fornitore;
ALTER TABLE IF EXISTS cpass.cpass_t_impegno ADD CONSTRAINT fk_cpass_t_impegno_fornitore FOREIGN KEY (fornitore_id) REFERENCES cpass.cpass_t_fornitore (fornitore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE if not exists cpass.cpass_t_subimpegno (
	subimpegno_id UUID
	, impegno_id UUID NOT NULL
	, ente_id UUID NOT NULL
	, impegno_anno_esercizio  INTEGER NOT NULL
	, impegno_anno INTEGER NOT NULL
	, impegno_numero INTEGER NOT NULL
	, subimpegno_anno_esercizio  INTEGER NOT NULL
	, subimpegno_anno INTEGER NOT NULL
	, subimpegno_numero INTEGER NOT NULL
	, provvedimento_anno INTEGER NOT NULL
	, provvedimento_numero INTEGER NOT NULL
	, provvedimento_settore varchar(50)
	, fornitore_id UUID
	, importo_iniziale NUMERIC NOT NULL
	, importo_attuale NUMERIC NOT NULL
	, stato varchar(1)
	, liq_anno_prec NUMERIC NOT NULL
    , data_creazione TIMESTAMP NOT NULL
    , utente_creazione CHARACTER VARYING(250) NOT NULL
	, data_modifica TIMESTAMP NOT NULL DEFAULT now()
	, utente_modifica CHARACTER VARYING(250) NOT NULL
	, data_cancellazione TIMESTAMP
	, utente_cancellazione CHARACTER VARYING(250)
	, optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    , CONSTRAINT cpass_t_subimpegno_pkey PRIMARY KEY(subimpegno_id)
	);
COMMENT ON TABLE cpass.cpass_t_subimpegno IS 'UUID namespace: "cpass_t_subimpegno"';

ALTER TABLE IF EXISTS cpass.cpass_t_subimpegno DROP CONSTRAINT IF EXISTS fk_cpass_t_subimpegno_impegno;
ALTER TABLE IF EXISTS cpass.cpass_t_subimpegno ADD CONSTRAINT fk_cpass_t_subimpegno_impegno FOREIGN KEY (impegno_id) REFERENCES cpass.cpass_t_impegno (impegno_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_subimpegno DROP CONSTRAINT IF EXISTS fk_cpass_t_subimpegno_ente;
ALTER TABLE IF EXISTS cpass.cpass_t_subimpegno ADD CONSTRAINT fk_cpass_t_subimpegno_ente FOREIGN KEY (ente_id) REFERENCES cpass.cpass_t_ente (ente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_subimpegno DROP CONSTRAINT IF EXISTS fk_cpass_t_subimpegno_fornitore;
ALTER TABLE IF EXISTS cpass.cpass_t_subimpegno ADD CONSTRAINT fk_cpass_t_subimpegno_fornitore FOREIGN KEY (fornitore_id) REFERENCES cpass.cpass_t_fornitore (fornitore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE if not exists cpass.CPASS_T_ORD_IMPEGNO_ORDINE(
     impegno_ordine_id UUID NOT NULL
    ,impegno_id UUID NOT NULL
    ,riga_ordine_id UUID NOT NULL
    ,impegno_progressivo Integer NOT NULL
    ,impegno_anno_esercizio  INTEGER NOT NULL
	,impegno_anno INTEGER NOT NULL
	,impegno_numero INTEGER NOT NULL
    ,importo  NUMERIC(13,5)
    ,data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    ,utente_creazione VARCHAR(250) NOT NULL
    ,data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    ,utente_modifica VARCHAR(250) NOT NULL
    ,data_cancellazione TIMESTAMP WITHOUT TIME ZONE
    ,utente_cancellazione VARCHAR(250)
    ,optlock UUID DEFAULT uuid_generate_v4() NOT NULL
    ,CONSTRAINT CPASS_T_ORD_IMPEGNO_ORDINE_pkey PRIMARY KEY(impegno_ordine_id)
);
COMMENT ON TABLE cpass.CPASS_T_ORD_IMPEGNO_ORDINE IS 'UUID namespace: "CPASS_T_ORD_IMPEGNO_ORDINE"';

ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_IMPEGNO_ORDINE DROP CONSTRAINT IF EXISTS fk_CPASS_T_ORD_IMPEGNO_ORDINE_riga_ordine;
ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_IMPEGNO_ORDINE ADD CONSTRAINT fk_CPASS_T_ORD_IMPEGNO_ORDINE_riga_ordine FOREIGN KEY (riga_ordine_id) REFERENCES cpass.cpass_t_ord_riga_ordine (riga_ordine_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_IMPEGNO_ORDINE DROP CONSTRAINT IF EXISTS fk_CPASS_T_ORD_IMPEGNO_ORDINE_IMPEGNO;
ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_IMPEGNO_ORDINE ADD CONSTRAINT fk_CPASS_T_ORD_IMPEGNO_ORDINE_IMPEGNO FOREIGN KEY (impegno_id) REFERENCES cpass.cpass_t_impegno (impegno_id) ON DELETE NO ACTION ON UPDATE NO ACTION;


CREATE TABLE if not exists cpass.CPASS_T_ORD_SUBIMPEGNO_ORDINE(
     subimpegno_ordine_id UUID NOT NULL
    ,impegno_ordine_id UUID NOT NULL
    ,subimpegno_id UUID NOT NULL
	, impegno_anno_esercizio  INTEGER NOT NULL
	, impegno_anno INTEGER NOT NULL
	, impegno_numero INTEGER NOT NULL
    ,subimpegno_anno Integer
    ,subimpegno_numero Integer
    ,subimpegno_importo  NUMERIC(13,5)
    ,data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    ,utente_creazione VARCHAR(250) NOT NULL
    ,data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    ,utente_modifica VARCHAR(250) NOT NULL
    ,data_cancellazione TIMESTAMP WITHOUT TIME ZONE
    ,utente_cancellazione VARCHAR(250)
    ,optlock UUID DEFAULT uuid_generate_v4() NOT NULL
    ,CONSTRAINT CPASS_T_ORD_SUBIMPEGNO_ORDINE_pkey PRIMARY KEY(subimpegno_ordine_id)
);

COMMENT ON TABLE cpass.CPASS_T_ORD_SUBIMPEGNO_ORDINE IS 'UUID namespace: "CPASS_T_ORD_SUBIMPEGNO_ORDINE"';

ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_SUBIMPEGNO_ORDINE DROP CONSTRAINT IF EXISTS fk_CPASS_T_ORD_SUBIMPEGNO_ORDINE_IMPEGNO_ORDINE;
ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_SUBIMPEGNO_ORDINE ADD CONSTRAINT fk_CPASS_T_ORD_SUBIMPEGNO_ORDINE_IMPEGNO_ORDINE FOREIGN KEY (impegno_ordine_id) REFERENCES cpass.CPASS_T_ORD_IMPEGNO_ORDINE (impegno_ordine_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_SUBIMPEGNO_ORDINE DROP CONSTRAINT IF EXISTS fk_CPASS_T_ORD_SUBIMPEGNO_ORDINE_SUBIMPEGNO;
ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_SUBIMPEGNO_ORDINE ADD CONSTRAINT fk_CPASS_T_ORD_SUBIMPEGNO_ORDINE_SUBIMPEGNO FOREIGN KEY (subimpegno_id) REFERENCES cpass.cpass_t_subimpegno (subimpegno_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_d_ord_tipo_procedura ADD COLUMN IF NOT EXISTS data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_d_ord_tipo_procedura ADD COLUMN IF NOT EXISTS utente_creazione VARCHAR(250) NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_d_ord_tipo_procedura ADD COLUMN IF NOT EXISTS data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_d_ord_tipo_procedura ADD COLUMN IF NOT EXISTS utente_modifica VARCHAR(250) NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_d_ord_tipo_procedura ADD COLUMN IF NOT EXISTS data_cancellazione TIMESTAMP WITHOUT TIME ZONE;
ALTER TABLE IF EXISTS cpass.cpass_d_ord_tipo_procedura ADD COLUMN IF NOT EXISTS utente_cancellazione VARCHAR(250);


CREATE TABLE if not exists cpass.cpass_t_ord_impegno_associato (
  impegno_associato_id UUID NOT NULL
  ,impegno_id UUID NOT NULL
  ,testata_ordine_id UUID NOT NULL
  ,impegno_anno_esercizio  INTEGER NOT NULL
  ,impegno_anno INTEGER NOT NULL
  ,impegno_numero INTEGER NOT NULL
  ,data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
  ,utente_creazione VARCHAR(250) NOT NULL
  ,data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
  ,utente_modifica VARCHAR(250) NOT NULL
  ,data_cancellazione TIMESTAMP WITHOUT TIME ZONE
  ,utente_cancellazione VARCHAR(250)
  ,optlock UUID DEFAULT uuid_generate_v4() NOT NULL

  ,CONSTRAINT cpass_t_ord_impegno_associato_pkey PRIMARY KEY(impegno_associato_id)

  ,CONSTRAINT fk_cpass_t_ord_impegno_associato_impegno FOREIGN KEY (impegno_id)
    REFERENCES cpass.cpass_t_impegno(impegno_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE

  ,CONSTRAINT fk_cpass_t_ord_impegno_associato_testata_ordine FOREIGN KEY (testata_ordine_id)
    REFERENCES cpass.cpass_t_ord_testata_ordine(testata_ordine_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
);

COMMENT ON TABLE cpass.cpass_t_ord_impegno_associato
IS 'UUID namespace: "cpass_t_ord_impegno_associato"';

CREATE TABLE if not exists cpass.cpass_t_ord_subimpegno_associato (
  subimpegno_associato_id UUID NOT NULL,
  impegno_associato_id UUID NOT NULL,
  subimpegno_id UUID NOT NULL,
  impegno_anno_esercizio  INTEGER NOT NULL,
  impegno_anno INTEGER NOT NULL,
  impegno_numero INTEGER NOT NULL,

  subimpegno_anno INTEGER,
  subimpegno_numero INTEGER,
  subimpegno_importo NUMERIC(13,5),

  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  optlock UUID DEFAULT uuid_generate_v4() NOT NULL,

  CONSTRAINT cpass_t_ord_subimpegno_associato_pkey PRIMARY KEY(subimpegno_associato_id),
  CONSTRAINT fk_cpass_t_ord_subimpegno_associato_impegno_associato FOREIGN KEY (impegno_associato_id)
    REFERENCES cpass.cpass_t_ord_impegno_associato(impegno_associato_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_t_ord_subimpegno_associato_subimpegno FOREIGN KEY (subimpegno_id)
    REFERENCES cpass.cpass_t_subimpegno(subimpegno_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
);

COMMENT ON TABLE cpass.cpass_t_ord_subimpegno_associato
IS 'UUID namespace: "cpass_t_ord_subimpegno_associato"';

ALTER TABLE IF EXISTS cpass.cpass_d_ord_tipo_procedura ADD COLUMN IF NOT EXISTS optlock UUID NOT NULL DEFAULT uuid_generate_v4();
ALTER TABLE IF EXISTS cpass.cpass_d_ord_tipo_ordine ADD COLUMN IF NOT EXISTS optlock UUID NOT NULL DEFAULT uuid_generate_v4();
ALTER TABLE IF EXISTS cpass.cpass_d_ord_tipo_procedura DROP COLUMN IF EXISTS tipo_procedura_numero;


ALTER TABLE IF EXISTS cpass.cpass_r_utente_settore ADD COLUMN IF NOT EXISTS  data_validita_inizio TIMESTAMP NOT NULL DEFAULT now() ;
ALTER TABLE IF EXISTS cpass.cpass_r_utente_settore ADD COLUMN IF NOT EXISTS data_validita_fine TIMESTAMP;
ALTER TABLE IF EXISTS cpass.cpass_r_ruolo_utente_settore ADD COLUMN IF NOT EXISTS  data_validita_inizio TIMESTAMP NOT NULL DEFAULT now();
ALTER TABLE IF EXISTS cpass.cpass_r_ruolo_utente_settore ADD COLUMN IF NOT EXISTS data_validita_fine TIMESTAMP;
 ALTER TABLE IF EXISTS cpass.cpass_d_permesso ADD COLUMN IF NOT EXISTS permesso_trasversale boolean default false;

DROP VIEW if exists cpass.cpass_v_ordine;

ALTER TABLE cpass.cpass_t_ord_riga_ordine ALTER COLUMN quantita TYPE NUMERIC(8,2);

CREATE VIEW cpass.cpass_v_ordine AS (
    select
       row_number() OVER () AS ordine_id

    ,cpass_t_ord_testata_ordine.testata_ordine_id
    ,cpass_t_ord_testata_ordine.tipo_ordine_id
    ,cpass_t_ord_testata_ordine.ordine_anno
    ,cpass_t_ord_testata_ordine.ordine_numero
    ,cpass_t_ord_testata_ordine.fornitore_id
    ,cpass_t_ord_testata_ordine.tipo_procedura_id
    ,cpass_t_ord_testata_ordine.numero_procedura
    ,cpass_t_ord_testata_ordine.data_emissione
    ,cpass_t_ord_testata_ordine.data_conferma
    ,cpass_t_ord_testata_ordine.data_autorizzazione
    ,cpass_t_ord_testata_ordine.totale_no_iva
    ,cpass_t_ord_testata_ordine.totale_con_iva
    ,cpass_t_ord_testata_ordine.descrizione_acquisto
    ,cpass_t_ord_testata_ordine.consegna_riferimento
    ,cpass_t_ord_testata_ordine.consegna_data_da
    ,cpass_t_ord_testata_ordine.consegna_data_a
    ,cpass_t_ord_testata_ordine.consegna_indirizzo
    ,cpass_t_ord_testata_ordine.consegna_cap
    ,cpass_t_ord_testata_ordine.consegna_localita
    ,cpass_t_ord_testata_ordine.provvedimento_anno
    ,cpass_t_ord_testata_ordine.provvedimento_numero
    ,cpass_t_ord_testata_ordine.lotto_anno
    ,cpass_t_ord_testata_ordine.lotto_numero
    ,cpass_t_ord_testata_ordine.utente_compilatore_id
    ,cpass_t_ord_testata_ordine.settore_emittente_id
    ,cpass_t_ord_testata_ordine.ufficio_id
    ,cpass_t_ord_testata_ordine.stato_id
    ,cpass_t_ord_testata_ordine.note
    ,cpass_t_ord_testata_ordine.data_cancellazione data_cancellazione_testata

    ,cpass_t_ord_destinatario.destinatario_id
    ,cpass_t_ord_destinatario.indirizzo
    ,cpass_t_ord_destinatario.num_civico
    ,cpass_t_ord_destinatario.localita
    ,cpass_t_ord_destinatario.provincia
    ,cpass_t_ord_destinatario.cap
    ,cpass_t_ord_destinatario.contatto
    ,cpass_t_ord_destinatario.email
    ,cpass_t_ord_destinatario.telefono
    ,cpass_t_ord_destinatario.data_invio_nso
    ,cpass_t_ord_destinatario.settore_destinatario_id
    ,cpass_t_ord_destinatario.stato_el_ordine_id stato_el_ordine_id_destinatario
    ,cpass_t_ord_destinatario.progressivo progressivo_destinatario
    ,cpass_t_ord_destinatario.data_cancellazione data_cancellazione_destinatario

    ,cpass_t_ord_riga_ordine.riga_ordine_id
    ,cpass_t_ord_riga_ordine.consegna_parziale
    ,cpass_t_ord_riga_ordine.progressivo progressivo_riga
    ,cpass_t_ord_riga_ordine.prezzo_unitario
    ,cpass_t_ord_riga_ordine.quantita
    ,cpass_t_ord_riga_ordine.percentuale_sconto
    ,cpass_t_ord_riga_ordine.importo_sconto
    ,cpass_t_ord_riga_ordine.percentuale_sconto2
    ,cpass_t_ord_riga_ordine.importo_sconto2
    ,cpass_t_ord_riga_ordine.importo_netto
    ,cpass_t_ord_riga_ordine.importo_iva
    ,cpass_t_ord_riga_ordine.importo_totale
    ,cpass_t_ord_riga_ordine.note note_riga
    ,cpass_t_ord_riga_ordine.stato_el_ordine_id stato_el_ordine_id_riga
    ,cpass_t_ord_riga_ordine.oggetti_spesa_id
    ,cpass_t_ord_riga_ordine.unita_misura_id
    ,cpass_t_ord_riga_ordine.aliquote_iva_id
    ,cpass_t_ord_riga_ordine.data_cancellazione data_cancellazione_riga

    ,cpass_t_ord_impegno_ordine.impegno_ordine_id
    ,cpass_t_ord_impegno_ordine.impegno_id
    ,cpass_t_ord_impegno_ordine.impegno_progressivo
    ,cpass_t_ord_impegno_ordine.impegno_anno_esercizio
    ,cpass_t_ord_impegno_ordine.impegno_anno
    ,cpass_t_ord_impegno_ordine.impegno_numero
    ,cpass_t_ord_impegno_ordine.importo importo_impegno
    ,cpass_t_ord_impegno_ordine.data_cancellazione data_cancellazione_impegno

    ,cpass_t_impegno.numero_capitolo
    ,cpass_t_impegno.numero_articolo

    ,cpass_t_ord_subimpegno_ordine.subimpegno_ordine_id
    ,cpass_t_ord_subimpegno_ordine.subimpegno_id
    ,cpass_t_ord_subimpegno_ordine.subimpegno_anno
    ,cpass_t_ord_subimpegno_ordine.subimpegno_numero
    ,cpass_t_ord_subimpegno_ordine.subimpegno_importo
    ,cpass_t_ord_subimpegno_ordine.data_cancellazione data_cancellazione_subimpegno
    from
             cpass.cpass_t_ord_testata_ordine
        join cpass.cpass_t_ord_destinatario  on (cpass_t_ord_testata_ordine.testata_ordine_id=cpass_t_ord_destinatario.testata_ordine_id)
        left Outer join cpass.cpass_t_ord_riga_ordine  on (cpass_t_ord_destinatario.destinatario_id=cpass_t_ord_riga_ordine.destinatario_id)
        left Outer join cpass.cpass_t_ord_impegno_ordine  on (cpass_t_ord_riga_ordine.riga_ordine_id=cpass_t_ord_impegno_ordine.riga_ordine_id)
        left Outer join cpass.cpass_t_impegno  on (cpass_t_impegno.impegno_id=cpass_t_ord_impegno_ordine.impegno_id)
        left Outer join cpass.cpass_t_ord_subimpegno_ordine  on (cpass_t_ord_impegno_ordine.impegno_ordine_id=cpass_t_ord_subimpegno_ordine.impegno_ordine_id)
  );

ALTER TABLE IF EXISTS cpass.cpass_t_fornitore ADD COLUMN IF NOT EXISTS cod_destinatario varchar(7);

ALTER TABLE IF EXISTS cpass.cpass_t_impegno  ALTER COLUMN fornitore_id DROP NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_subimpegno ALTER COLUMN fornitore_id DROP NOT NULL;


CREATE TABLE if not exists cpass.cpass_t_LISTINO_FORNITORE (
     listino_fornitore_id SERIAL
    ,fornitore_id UUID NOT NULL
    ,oggetti_spesa_id INTEGER
    ,LISTINO_FORNITORE_codice_ods VARCHAR(50)
    ,LISTINO_FORNITORE_descrizione VARCHAR(250)
    ,data_creazione TIMESTAMP NOT NULL
    ,utente_creazione CHARACTER VARYING(250) NOT NULL
	,data_modifica TIMESTAMP NOT NULL DEFAULT now()
	,utente_modifica CHARACTER VARYING(250) NOT NULL
	,data_cancellazione TIMESTAMP
	,utente_cancellazione CHARACTER VARYING(250)
	,optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    ,CONSTRAINT cpass_t_LISTINO_FORNITORE_pkey PRIMARY KEY(listino_fornitore_id)
    ,CONSTRAINT fk_cpass_T_listino_fornitore_fornitore FOREIGN KEY (fornitore_id) REFERENCES cpass.cpass_T_fornitore(fornitore_id)
    ,CONSTRAINT fk_cpass_T_listino_fornitore_oggetti_spesa FOREIGN KEY (oggetti_spesa_id) REFERENCES cpass.cpass_d_oggetti_spesa(oggetti_spesa_id)
);

ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine ADD COLUMN IF NOT EXISTS listino_fornitore_id INTEGER;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_riga_ordine_listino_fornitore;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_ordine_listino_fornitore FOREIGN KEY (listino_fornitore_id) REFERENCES cpass.cpass_t_LISTINO_FORNITORE (listino_fornitore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;


CREATE TABLE if not exists cpass.cpass_d_ord_stato_nso (
    stato_nso_id SERIAL ,
    stato_nso_codice character varying(50) NOT NULL,
    stato_nso_descrizione character varying(500) NOT NULL,
	stato_nso_tipo character varying(200) NOT NULL,
    CONSTRAINT cpass_d_ord_stato_nso_pkey PRIMARY KEY(stato_nso_id)
);


ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario ADD COLUMN IF NOT EXISTS stato_nso_id INTEGER;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_destinatario_stato_nso_id;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario ADD CONSTRAINT fk_cpass_t_ord_destinatario_stato_nso_id FOREIGN KEY (stato_nso_id) REFERENCES cpass.cpass_d_ord_stato_nso (stato_nso_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD COLUMN IF NOT EXISTS stato_nso_id INTEGER;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_testata_ordine_stato_nso_id;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_stato_nso_id FOREIGN KEY (stato_nso_id) REFERENCES cpass.cpass_d_ord_stato_nso (stato_nso_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_destinatario_stato_nso;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario DROP COLUMN IF EXISTS stato_invio_nso;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_testata_ordine_stato_nso;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP COLUMN IF EXISTS stato_invio_nso;


CREATE TABLE if not exists  cpass.CPASS_R_DIRIGENTE_SETTORE (
  DIRIGENTE_SETTORE_id SERIAL,
  utente_id UUID NOT NULL,
  settore_id UUID NOT NULL,
  data_validita_inizio TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  data_validita_fine TIMESTAMP WITHOUT TIME ZONE,
  CONSTRAINT cpass_r_dirigente_settore_pkey PRIMARY KEY(DIRIGENTE_SETTORE_id),
  CONSTRAINT fk_cpass_r_dirigente_settore_t_settore FOREIGN KEY (settore_id)
    REFERENCES cpass.cpass_t_settore(settore_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_r_dirigente_settore_t_utente FOREIGN KEY (utente_id)
    REFERENCES cpass.cpass_t_utente(utente_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
)
WITH (oids = false);


-- 2020/06/22 - Allineamento Java/DDL - Inizio
DROP VIEW IF EXISTS cpass.cpass_v_ordine;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario ALTER COLUMN data_invio_nso TYPE timestamp WITHOUT TIME ZONE USING data_invio_nso::timestamp;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ALTER COLUMN data_emissione TYPE timestamp WITHOUT TIME ZONE USING data_emissione::timestamp;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ALTER COLUMN data_conferma TYPE timestamp WITHOUT TIME ZONE USING data_conferma::timestamp;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ALTER COLUMN data_autorizzazione TYPE timestamp WITHOUT TIME ZONE USING data_autorizzazione::timestamp;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ALTER COLUMN consegna_data_da TYPE timestamp WITHOUT TIME ZONE USING consegna_data_da::timestamp;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ALTER COLUMN consegna_data_a TYPE timestamp WITHOUT TIME ZONE USING consegna_data_a::timestamp;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ALTER COLUMN data_scadenza TYPE timestamp WITHOUT TIME ZONE USING data_scadenza::timestamp;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_programma ALTER COLUMN id_ricevuto_mit TYPE bigint USING id_ricevuto_mit::bigint;


CREATE OR REPLACE VIEW cpass.cpass_v_ordine
AS SELECT row_number() OVER () AS ordine_id,
    cpass_t_ord_testata_ordine.testata_ordine_id,
    cpass_t_ord_testata_ordine.tipo_ordine_id,
    cpass_t_ord_testata_ordine.ordine_anno,
    cpass_t_ord_testata_ordine.ordine_numero,
    cpass_t_ord_testata_ordine.fornitore_id,
    cpass_t_ord_testata_ordine.tipo_procedura_id,
    cpass_t_ord_testata_ordine.numero_procedura,
    cpass_t_ord_testata_ordine.data_emissione,
    cpass_t_ord_testata_ordine.data_conferma,
    cpass_t_ord_testata_ordine.data_autorizzazione,
    cpass_t_ord_testata_ordine.totale_no_iva,
    cpass_t_ord_testata_ordine.totale_con_iva,
    cpass_t_ord_testata_ordine.descrizione_acquisto,
    cpass_t_ord_testata_ordine.consegna_riferimento,
    cpass_t_ord_testata_ordine.consegna_data_da,
    cpass_t_ord_testata_ordine.consegna_data_a,
    cpass_t_ord_testata_ordine.consegna_indirizzo,
    cpass_t_ord_testata_ordine.consegna_cap,
    cpass_t_ord_testata_ordine.consegna_localita,
    cpass_t_ord_testata_ordine.provvedimento_anno,
    cpass_t_ord_testata_ordine.provvedimento_numero,
    cpass_t_ord_testata_ordine.lotto_anno,
    cpass_t_ord_testata_ordine.lotto_numero,
    cpass_t_ord_testata_ordine.utente_compilatore_id,
    cpass_t_ord_testata_ordine.settore_emittente_id,
    cpass_t_ord_testata_ordine.ufficio_id,
    cpass_t_ord_testata_ordine.stato_id,
    cpass_t_ord_testata_ordine.note,
    cpass_t_ord_testata_ordine.data_cancellazione AS data_cancellazione_testata,
    cpass_t_ord_destinatario.destinatario_id,
    cpass_t_ord_destinatario.indirizzo,
    cpass_t_ord_destinatario.num_civico,
    cpass_t_ord_destinatario.localita,
    cpass_t_ord_destinatario.provincia,
    cpass_t_ord_destinatario.cap,
    cpass_t_ord_destinatario.contatto,
    cpass_t_ord_destinatario.email,
    cpass_t_ord_destinatario.telefono,
    cpass_t_ord_destinatario.data_invio_nso,
    cpass_t_ord_destinatario.settore_destinatario_id,
    cpass_t_ord_destinatario.stato_el_ordine_id AS stato_el_ordine_id_destinatario,
    cpass_t_ord_destinatario.progressivo AS progressivo_destinatario,
    cpass_t_ord_destinatario.data_cancellazione AS data_cancellazione_destinatario,
    cpass_t_ord_riga_ordine.riga_ordine_id,
    cpass_t_ord_riga_ordine.consegna_parziale,
    cpass_t_ord_riga_ordine.progressivo AS progressivo_riga,
    cpass_t_ord_riga_ordine.prezzo_unitario,
    cpass_t_ord_riga_ordine.quantita,
    cpass_t_ord_riga_ordine.percentuale_sconto,
    cpass_t_ord_riga_ordine.importo_sconto,
    cpass_t_ord_riga_ordine.percentuale_sconto2,
    cpass_t_ord_riga_ordine.importo_sconto2,
    cpass_t_ord_riga_ordine.importo_netto,
    cpass_t_ord_riga_ordine.importo_iva,
    cpass_t_ord_riga_ordine.importo_totale,
    cpass_t_ord_riga_ordine.note AS note_riga,
    cpass_t_ord_riga_ordine.stato_el_ordine_id AS stato_el_ordine_id_riga,
    cpass_t_ord_riga_ordine.oggetti_spesa_id,
    cpass_t_ord_riga_ordine.unita_misura_id,
    cpass_t_ord_riga_ordine.aliquote_iva_id,
    cpass_t_ord_riga_ordine.data_cancellazione AS data_cancellazione_riga,
    cpass_t_ord_impegno_ordine.impegno_ordine_id,
    cpass_t_ord_impegno_ordine.impegno_id,
    cpass_t_ord_impegno_ordine.impegno_progressivo,
    cpass_t_ord_impegno_ordine.impegno_anno_esercizio,
    cpass_t_ord_impegno_ordine.impegno_anno,
    cpass_t_ord_impegno_ordine.impegno_numero,
    cpass_t_ord_impegno_ordine.importo AS importo_impegno,
    cpass_t_ord_impegno_ordine.data_cancellazione AS data_cancellazione_impegno,
    cpass_t_impegno.numero_capitolo,
    cpass_t_impegno.numero_articolo,
    cpass_t_ord_subimpegno_ordine.subimpegno_ordine_id,
    cpass_t_ord_subimpegno_ordine.subimpegno_id,
    cpass_t_ord_subimpegno_ordine.subimpegno_anno,
    cpass_t_ord_subimpegno_ordine.subimpegno_numero,
    cpass_t_ord_subimpegno_ordine.subimpegno_importo,
    cpass_t_ord_subimpegno_ordine.data_cancellazione AS data_cancellazione_subimpegno,
    ord_stato_nso_testata_ordine.stato_nso_descrizione AS stato_invio_nso_testata,
    ord_stato_nso_testata_ordine.stato_nso_descrizione AS stato_invio_nso_destinatario
   FROM cpass.cpass_t_ord_testata_ordine
          JOIN cpass.cpass_t_ord_destinatario ON cpass_t_ord_testata_ordine.testata_ordine_id = cpass_t_ord_destinatario.testata_ordine_id
     LEFT JOIN cpass.cpass_t_ord_riga_ordine ON cpass_t_ord_destinatario.destinatario_id = cpass_t_ord_riga_ordine.destinatario_id
     LEFT JOIN cpass.cpass_t_ord_impegno_ordine ON cpass_t_ord_riga_ordine.riga_ordine_id = cpass_t_ord_impegno_ordine.riga_ordine_id
     LEFT JOIN cpass.cpass_t_impegno ON cpass_t_impegno.impegno_id = cpass_t_ord_impegno_ordine.impegno_id
     LEFT JOIN cpass.cpass_t_ord_subimpegno_ordine ON cpass_t_ord_impegno_ordine.impegno_ordine_id = cpass_t_ord_subimpegno_ordine.impegno_ordine_id
     LEFT JOIN cpass_d_ord_stato_nso ord_stato_nso_testata_ordine ON cpass_t_ord_testata_ordine.stato_nso_id = ord_stato_nso_testata_ordine.stato_nso_id
     LEFT JOIN cpass_d_ord_stato_nso ord_stato_nso_destinatario ON cpass_t_ord_destinatario.stato_nso_id = ord_stato_nso_destinatario.stato_nso_id
     ;
-- 2020/06/22 - Allineamento Java/DDL - Fine
drop view if exists cpass.cpass_v_cpv_ods;

CREATE OR REPLACE VIEW cpass.cpass_v_cpv_ods
AS with recursive alberoCpvOds (livello, cpv_id_padre, cpv_id, cpv_codice, cpv_descrizione, cpv_codice_padre, cpv_tipologia, cpv_divisione, cpv_gruppo, cpv_classe, cpv_categoria, settore_interventi_id, settore_interventi_codice, settore_interventi_descrizione) AS (
			select livello, cpv_id_padre, cpv_id, cpv_codice, cpv_descrizione, cpv_codice_padre, cpv_tipologia, cpv_divisione, cpv_gruppo, cpv_classe, cpv_categoria, settore_interventi_id, settore_interventi_codice, settore_interventi_descrizione
			from cpass_v_cpv cvc where exists
			( select 1 from cpass_d_oggetti_spesa cdos
			where cdos.cpv_id = cvc.cpv_id )
			union all
			 select
				 cvc2.livello, cvc2.cpv_id_padre, cvc2.cpv_id, cvc2.cpv_codice, cvc2.cpv_descrizione, cvc2.cpv_codice_padre, cvc2.cpv_tipologia, cvc2.cpv_divisione, cvc2.cpv_gruppo, cvc2.cpv_classe, cvc2.cpv_categoria, cvc2.settore_interventi_id, cvc2.settore_interventi_codice, cvc2.settore_interventi_descrizione
			 FROM cpass_v_cpv cvc2,
			   alberoCpvOds alberoCpvOds
			WHERE alberoCpvOds.cpv_id_padre = cvc2.cpv_id
			        )
 SELECT row_number() OVER () AS id_v_cpv_ods, dist.*
 FROM
    ( SELECT DISTINCT
    alberoCpvOds.livello,
    alberoCpvOds.cpv_id_padre,
    alberoCpvOds.cpv_id,
    alberoCpvOds.cpv_codice,
    alberoCpvOds.cpv_descrizione,
    alberoCpvOds.cpv_codice_padre,
    alberoCpvOds.cpv_tipologia,
    alberoCpvOds.cpv_divisione,
    alberoCpvOds.cpv_gruppo,
    alberoCpvOds.cpv_classe,
    alberoCpvOds.cpv_categoria,
    alberoCpvOds.settore_interventi_id,
    alberoCpvOds.settore_interventi_codice,
    alberoCpvOds.settore_interventi_descrizione
   FROM alberoCpvOds) dist
   ORDER BY dist.livello DESC, dist.cpv_id;

-- Permissions

ALTER TABLE cpass.cpass_v_cpv OWNER TO cpass;
GRANT ALL ON TABLE cpass.cpass_v_cpv TO cpass;

ALTER TABLE cpass.cpass_t_ord_destinatario RENAME TO cpass_t_ord_destinatario_ordine;

----------------------------------------------------------------------------
---------------------------------- DML -------------------------------------
----------------------------------------------------------------------------

INSERT INTO cpass.cpass_d_ord_tipo_procedura (tipo_procedura_codice , tipo_procedura_descrizione, utente_creazione, utente_modifica)
SELECT tmp.codice, tmp.descrizione,'SYSTEM', 'SYSTEM'
FROM (values
('TRP','TRATTATIVA PRIVATA'),
('LPR','LICITAZIONE PRIVATA'),
('APC','APPALTO CONCORSO'),
('APB','ASTA PUBBLICA'),
('CSP','CONVENZIONE CONSIP'),
('AQU','ACCORDO QUADRO'),
('PAP','PROCEDURA APERTA'),
('PRT','PROCEDURA  RISTRETTA'),
('PNG','PROCEDURA  NEGOZIATA'),
('DCP','DIALOGO COMPETITIVO'),
('AEL','ASTA ELETTRONICA'),
('SDA','SISTEMA DINAMICO D''ACQUISIZIONE'),
('IPG','INCARICO DI PROGETTAZIONE'),
('CPG','CONCORSO DI PROGETTAZIONE'),
('CDI','CONCORSO D''IDEE'),
('AEC','AFFIDAMENTO IN ECONOMIA'),
('CON','CONVENZIONE'),
('CSE','CONTRATTI DI SERVIZIO'),
('AME','AFFIDAMENTO MEPA'),
('DLE','DIRITTI DOVUTI PER LEGGE')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_ord_tipo_procedura ts
  WHERE ts.tipo_procedura_codice = tmp.codice
);

INSERT INTO cpass.cpass_d_ord_tipo_ordine (tipologia_documento_codice, tipologia_documento_descrizione, utente_creazione, utente_modifica)
SELECT tmp.codice, tmp.descrizione,'SYSTEM', 'SYSTEM'
FROM (values
('INT','INTERNO'),
('SEM','SEMPLICE')) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_ord_tipo_ordine ts
  WHERE ts.tipologia_documento_codice = tmp.codice
);
INSERT INTO cpass.cpass_d_aliquote_iva (aliquote_iva_codice, aliquote_iva_descrizione,percentuale,codifica_peppol,data_validita_inizio, utente_creazione, utente_modifica)
SELECT tmp.codice, tmp.descrizione,percentuale, peppol,now(),'SYSTEM', 'SYSTEM'
FROM (values
('20','Aliquota 20%',20,'S'),
('21','Aliquota 21%',21,'S'),
('22','Aliquota 22%',22,'S'),
('4','Aliquota 4%',4,'S'),
('0','Esente Iva',0,'E')
) AS tmp(codice, descrizione,percentuale,peppol)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_aliquote_iva ts
  WHERE ts.aliquote_iva_codice = tmp.codice
);

INSERT INTO cpass.cpass_d_unita_misura (unita_misura_codice, unita_misura_descrizione,unita_misura_ambito_utilizzo,data_validita_inizio, utente_creazione, utente_modifica)
SELECT tmp.codice, tmp.descrizione,ambito_utilizzo,now(),'SYSTEM', 'SYSTEM'
FROM (values
('C62','Pezzo','Quantita'''),
('PR','Paio','Quantita'''),
('XPK','Pack','Confezionamento'),
('DZP','Dozzina','Confezionamento'),
('KT','Kit','Confezionamento'),
('RM','Risma','Confezionamento'),
('XBX','Box','Confezionamento'),
('XOB','Bancale','Confezionamento'),
('MTR','Metro','Lunghezza'),
('CMT','Centimetro','Lunghezza'),
('MMT','Millimetro','Lunghezza'),
('MTK','Metro quadrato','Superficie'),
('CMK','Centimetro quadrato','Superficie'),
('MTQ','Metro cubo','Volume'),
('CMQ','Centimetro cubo','Volume'),
('MMQ','Millimetro cubo','Volume'),
('LTR','Litro','Capacita'''),
('MLT','Millilitro','Capacita'''),
('GRM','Grammo','Peso'),
('HGM','Ettogrammo','Peso'),
('KGM','Chilogrammo','Peso'),
('MGM','Milligrammo','Peso'),
('MC','Microgrammo','Peso'),
('MIN','Minuto','Tempo'),
('HUR','Ora','Tempo'),
('DAY','Giorno','Tempo'),
('MON','Mese','Tempo'),
('ANN','Anno','Tempo'),
('E49','Giorno di lavoro','Tempo'),
('KWH','Kilowattora','Lavoro'),
('BQL','Becquerel','Elettricita''')
) AS tmp(codice, descrizione,ambito_utilizzo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_unita_misura ts
  WHERE ts.unita_misura_codice = tmp.codice
);

ALTER TABLE IF EXISTS cpass.cpass_t_ufficio DROP COLUMN IF EXISTS settore_id;
ALTER TABLE IF EXISTS cpass.cpass_t_ufficio DROP CONSTRAINT IF EXISTS fk_cpass_t_ufficio_t_settore;
ALTER TABLE IF EXISTS cpass.cpass_t_ufficio ADD COLUMN IF NOT EXISTS data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_ufficio ADD COLUMN IF NOT EXISTS utente_creazione VARCHAR(250) NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_ufficio ADD COLUMN IF NOT EXISTS data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_ufficio ADD COLUMN IF NOT EXISTS utente_modifica VARCHAR(250) NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_ufficio ADD COLUMN IF NOT EXISTS data_cancellazione TIMESTAMP WITHOUT TIME ZONE;
ALTER TABLE IF EXISTS cpass.cpass_t_ufficio ADD COLUMN IF NOT EXISTS utente_cancellazione VARCHAR(250);
ALTER TABLE IF EXISTS cpass.cpass_t_ufficio ADD COLUMN IF NOT EXISTS optlock UUID NOT NULL DEFAULT uuid_generate_v4();

CREATE TABLE if not exists cpass.cpass_r_ufficio_settore (
   ufficio_settore_id  SERIAL ,
   ufficio_id integer NOT NULL,
   settore_id UUID NOT NULL,
   data_validita_inizio TIMESTAMP NOT NULL,
   data_validita_fine TIMESTAMP,
   CONSTRAINT cpass_r_ufficio_settore_pkey PRIMARY KEY(ufficio_settore_id)
);

ALTER TABLE IF EXISTS cpass.cpass_r_ufficio_settore DROP CONSTRAINT IF EXISTS fk_cpass_r_ufficio_settore_t_ufficio;
ALTER TABLE IF EXISTS cpass.cpass_r_ufficio_settore ADD CONSTRAINT fk_cpass_r_ufficio_settore_t_ufficio FOREIGN KEY (ufficio_id) REFERENCES cpass.cpass_t_ufficio (ufficio_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_r_ufficio_settore DROP CONSTRAINT IF EXISTS fk_cpass_r_ufficio_settore_t_settore;
ALTER TABLE IF EXISTS cpass.cpass_r_ufficio_settore ADD CONSTRAINT fk_cpass_r_ufficio_settore_t_settore FOREIGN KEY (settore_id) REFERENCES cpass.cpass_t_settore (settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

INSERT INTO cpass.cpass_t_ufficio (ufficio_codice, ufficio_descrizione,utente_creazione, utente_modifica)
SELECT tmp.codice, tmp.descrizione,'SYSTEM', 'SYSTEM'
FROM (values
('0XNNK3','Telefonia'),
('1D1MZT','Direzione Competitività Sistema Regionale'),
('1MGN7P','Direzione  coordinamento politiche e fondi europei e tutti i settori tranne comunicazione uﬃcio stampa relazione esterne urp'),
('5VHG50','Audit interno'),
('6U1HQH','Settori Tecnici'),
('7K3KWF','Patrimonio immobiliare, beni mobili, economato e cassa economale'),
('81YHY9','Economato'),
('A17LZ5','Tecnico e Sicurezza'),
('ADAT4K','Direzione Sanità e tutti i settori tranne Sistemi organizzativi e risorse umane del SSR e Politiche di Welfare'),
('AX8DPY','Direzione Risorse Finanziarie e Patrimonio'),
('BR4EG5','Comunicazione, uﬃcio stampa, relazioni esterne e URP'),
('C82S84','Gabinetto Presidenza Giunta'),
('E6A9MX','Direzione ambiente energia e territorio'),
('E9J5YC','Avvocatura'),
('EFSFG6','Politiche di Welfare'),
('EOG7LT','Direzione agricoltura cibo e tutti i settori tranne il Fitosanitario e servizio tecnico- scientiﬁci'),
('F7XJX1','Fitosanitario e servizi tecnico-scientiﬁci'),
('FPRJNR','Trattamento economico, pensionistico, previdenziale e assicurativo del personale'),
('HQM2O9','Direzione della Giunta Regionale e tutti i settori tranne Formazione del personale dipendente, Stato giuridico ed ordinamento del personale, Trattamento economico, pensionistico, previdenziale e assicurativo del personale, Coordinamento e gestione servizi generali operativi - Tutela dei consumatori'),
('IHRBBE','Coordinamento e gestione servizi generali operativi - Tutela dei consumatori'),
('J9FDBP','Direzione OO.PP, Protezione Civile, Trasporti, Logistica'),
('JBJRON','Formazione del personale dipendente'),
('L77UYL','Patrimonio Servizi'),
('PT6DEI','Stato giuridico ed ordinamento del personale'),
('S04VFA','Direzione istruzione, formazione lavoro'),
('THPX37','Sistemi organizzativi e risorse umane del SSR'),
('UFES06','Uﬀ_eFatturaPA – non utilizzare'),
('V3QQD9','Protezione civile e sistema antincendi boschivi (A.I.B.)'),
('YVDPFP','Direzione cultura turismo e commercio'),
('ZRE6BX','Servizi infrastrutturali e tecnologici e Sistemi informativo Regionale')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_ufficio ts
  WHERE ts.ufficio_codice = tmp.codice
);

  ALTER TABLE IF EXISTS cpass.cpass_t_settore ADD COLUMN IF NOT EXISTS settore_num_civico VARCHAR(20);
  ALTER TABLE IF EXISTS cpass.cpass_t_settore ADD COLUMN IF NOT EXISTS settore_contatto VARCHAR(200);
  ALTER TABLE IF EXISTS cpass.cpass_t_settore ADD COLUMN IF NOT EXISTS settore_email VARCHAR(50);

  ALTER TABLE IF EXISTS cpass.cpass_t_parametro ADD COLUMN IF NOT EXISTS ente_id UUID;
  ALTER TABLE IF EXISTS cpass.cpass_t_parametro DROP constraint IF EXISTS fk_cpass_t_parametro_t_ente;
  ALTER TABLE IF EXISTS cpass.cpass_t_parametro add CONSTRAINT fk_cpass_t_parametro_t_ente FOREIGN KEY (ente_id)  REFERENCES cpass.cpass_t_ente(ente_id);


insert into cpass.cpass_d_stato_el_ordine (stato_codice, stato_descrizione, stato_tipo)
select tmp.codice, tmp.descrizione, tmp.tipo from ( values
('DAE','DA EVADERE', 'DEST_ORDINE'),
('EVP','EVASO PARZIALMENTE', 'DEST_ORDINE'),
('EVT','EVASO TOTALMENTE', 'DEST_ORDINE'),
('EVX','CHIUSO' , 'DEST_ORDINE'),
('DAE','DA EVADERE', 'RIGA_ORDINE'),
('EVP','EVASA PARZIALMENTE', 'RIGA_ORDINE'),
('EVT','EVASA TOTALMENTE', 'RIGA_ORDINE'),
('EVX','CHIUSA' , 'RIGA_ORDINE'),
('ADE','ANNULLATO DA EVADERE' , 'DEST_ORDINE'),
('ADE','ANNULLATA DA EVADERE', 'RIGA_ORDINE')
)AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato_el_ordine ts
  WHERE ts.stato_codice = tmp.codice
);

insert into cpass.cpass_d_oggetti_spesa (oggetti_spesa_codice ,oggetti_spesa_descrizione ,unita_misura_id ,cpv_id ,aliquote_iva_id ,inventariabile,prezzo_unitario, data_creazione, data_validita_inizio, utente_creazione, utente_modifica)
select tmp.codice, tmp.descrizione,dum.unita_misura_id ,dc.cpv_id ,dai.aliquote_iva_id,tmp.inventariabile ,tmp.prezzo_unitario, now(), now(), 'SYSTEM','SYSTEM'
from
( values
('AA020A','CORRETTORE A PENNELLO','30192160-0','C62','22',true,0.5689)
,('AB015A','ETICHETTE F.TO 37X70','30192800-9','XPK','22',true,0.5689)
,('AB015B','ETICHETTE F.TO 46X100','30192800-9','XPK','22',true,0.5689)
,('AB015C','ETICHETTE  F.TO A4 210X297','30192800-9','XPK','22',true,0.5689)
,('AB015D','ETICHETTE MM. 70X297 FOGLIO A4','30192800-9','XPK','22',true,0.5689)
,('AB020AQ','ETICHETTE DORSO FALDONI (TIPO AQUILA) MM.190X38','30192800-9','XPK','22',true,0.5689)
,('AB020DM','ETICHETTE PER DORSO FALDONI  CM.7X29,7','30192800-9','XPK','22',true,0.5689)
,('AB025A','ETICHETTE PER CD-ROM','30192800-9','XPK','22',true,0.5689)
,('AB030A1','ETICHETTE F.TO 70X36 FOGLIO A4','30192800-9','XPK','22',true,0.5689)
,('AB030A2','ETICHETTE 70X37 FOGLIO A4','30192800-9','XPK','22',true,0.5689)
,('AB030B','ETICHETTE F.TO 105X36 FOGLIO A4','30192800-9','XPK','22',true,0.5689)
,('AB035A','ETICHETTE PER DELIBERE 210X148 FOGLIO A4','30192800-9','XPK','22',true,0.5689)
,('AC040BC','CARTELLINA CON LOGO A COLORI E ALETTE PER CONVEGNI','22852100-8','DZP','22',true,0.5689)
,('AC040SF','SOTTOFASCICOLI','22160000-9','DZP','22',true,0.5689)
,('AC045A','CARTELLINA MANILLA CON ALETTE ARANCIO','22852100-8','DZP','22',true,0.5689)
,('AC045C','CARTELLINA MANILLA CON ALETTE CELESTE','22852100-8','DZP','22',true,0.5689)
,('AC045G','CARTELLINA MANILLA CON ALETTE GIALLA','22852100-8','DZP','22',true,0.5689)
,('AC045R','CARTELLINA MANILLA CON ALETTE ROSA','22852100-8','DZP','22',true,0.5689)
,('AC045V','CARTELLINA MANILLA CON ALETTE VERDE','22852100-8','DZP','22',true,0.5689)
,('AC050A3','CARTA A3','30197643-5','RM','22',true,0.5689)
,('AC050A4','CARTA A4','30197643-5','RM','22',true,0.5689)
,('AC050BI','CARTONCINO A4 BIANCO 160GR.','22800000-8','XPK','22',true,0.5689)
,('AC050NA','CARTA A4 ARANCIO 80 GR.','30197643-5','RM','22',true,0.5689)
,('AC050NB','CARTA A4 AZZURRA 80GR.','30197643-5','RM','22',true,0.5689)
,('AC050NG','CARTA A4 GIALLA 80GR.','30197643-5','RM','22',true,0.5689)
,('AC050NRO','CARTA A4 FOGLI COLORATI 80GR. ROSA','30197643-5','RM','22',true,0.5689)
,('AC050NRS','CARTA A4 FOGLI COLORATI 80GR. ROSSO','30197643-5','RM','22',true,0.5689)
,('AC050NV','CARTA A4 VERDE 80GR.','30197643-5','RM','22',true,0.5689)
,('AC050SA','CARTONCINO A4 SALMONE 160GR.','30197643-5','XPK','22',true,0.5689)
,('AC050SB','CARTONCINO A4 AZZURRO 160GR.','30197643-5','XPK','22',true,0.5689)
,('AC050SG','CARTONCINO A4 GIALLO 160GR.','30197643-5','XPK','22',true,0.5689)
,('AC050SR','CARTONCINO A4 ROSSO 160GR.	1908','30197643-5','XPK','22',true,0.5689)
,('AC050SV','CARTONCINO A4 VERDE 160GR.	1908','30197643-5','XPK','22',true,0.5689)
,('AC060A','CARTA OPACA PER PLOTTER HP GR.90 914X50MT.','37823700-0','DZP','22',true,0.5689)
,('AC060B','CARTA OPACA PER PLOTTER 90GR. 106,7 X 50M.','37823700-0','DZP','22',true,0.5689)
,('AF001JB','FALDONI JOLLY BOX F.TO PROTOCOLLO SENZA ANELLI CON GANCETTI','39132200-8','XPK','22',true,0.5689)
,('AF005B','FALDONE BLU - CARTELLE PORTA PROGETTI IN CARTONCINO CON BOTTONE','39132200-8','XPK','22',true,0.5689)
,('AF005R','FALDONE ROSSO - CARTELLE PORTA PROGETTI IN CARTONCINO CON BOTTONE','39132200-8','XPK','22',true,0.5689)
,('AF010DL','FALDONI CON LEGACCI (DORSO 15)','39132200-8','XPK','22',true,0.5689)
,('AF010DM','FALDONI CON LEGACCI (DORSO 8)','39132200-8','XPK','22',true,0.5689)
,('AF010DS','FALDONI CON LEGACCI (DORSO 5)','39132200-8','XPK','22',true,0.5689)
,('AF015AQ','REGISTRATORI F.TO PROTOCOLLO A 2 ANELLI (CON MACCHINETTA CENTRALE)','30197200-8','C62','22',true,0.5689)
,('AF020GF','FALDONCINI SESTETTI','39132200-8','XPK','22',true,0.5689)
,('AL005A','BLOC NOTES A QUADRETTI F.TO A4','22816100-4','DZP','22',true,0.5689)
,('AL005B','CUBO FOGLI PER APPUNTI','22816100-4','C62','22',true,0.5689)
,('AL020A','POST-IT PICCOLO MMM.38X51','22816300-6','XPK','22',true,0.5689)
,('AL020B','POST-IT GRANDE MM.76X76','22816300-6','XPK','22',true,0.5689)
,('AP001A','EVIDENZIATORI GIALLI','30192125-3','DZP','22',true,0.5689)
,('AP001B','EVIDENZIATORI COLORI ASSORTITI','30192125-3','DZP','22',true,0.5689)
,('AP005A','PENNE BLU','30192121-5','DZP','22',true,0.5689)
,('AP005B','PENNE ROSSE','30192121-5','DZP','22',true,0.5689)
,('AP005C','PENNE NERE','30192121-5','DZP','22',true,0.5689)
,('AP010A','MATITE NERE','30192130-1','DZP','22',true,0.5689)
,('AP010B','MATITE BICOLORI ROSSO/BLU','37822100-7','DZP','22',true,0.5689)
,('AP015A','PENNARELLI PUNTA GRANDE NERI','30192124-6','C62','22',true,0.5689)
,('AP015B','PENNARELLI PUNTA GRANDE 4 COLORI (NERO-BLU-VERDE-ROSSO)','30192124-6','C62','22',true,0.5689)
,('AP015C','PENNARELLO PUNTA FINE BLU','30192124-6','C62','22',true,0.5689)
,('AP015D','PENNARELLO PUNTA FINE ROSSO','30192124-6','C62','22',true,0.5689)
,('AP015F','PENNARELLO PUNTA FINE NERO','30192124-6','C62','22',true,0.5689)
,('AP020A','PORTAMINE DA 0,5MM. PER DISEGNO TECNICO','30192131-8','C62','22',true,0.5689)
,('AP020B','ASTUCCIO MINE 0,5 PER PORTAMINE','30192132-5','C62','22',true,0.5689)
,('SC0001','ETICHETTA TRASPARENTE OPACO 70X36','30199760-5','XPK','22',true,0.5689)
,('SC0004','ETICHETTE A REGISTRO VERDE DIAM.14MM.','30199760-5','XPK','22',true,0.5689)
,('SC0005','ETICHETTE IN PVC 13X7 STAMPA IN QUADRICROMIA','30199760-5','XPK','22',true,0.5689)
,('SC0006','ETICHETTE  A REGISTRO BLU DIAM.14MM.','30199760-5','XPK','22',true,0.5689)
,('SC0007','ETICHETTE A REGISTRO GIALLO DIAM.14MM.','30199760-5','XPK','22',true,0.5689)
,('SC0008','ETICHETTE A REGISTRO ROSSO DIAM.14MM.','30199760-5','XPK','22',true,0.5689)
,('SC0009','ETICHETTE A4 MM105X148','30199760-5','XPK','22',true,0.5689)
,('SC0010','SERVIZI DI PULIZIA UFFICI','90919200-4','C62','22',false,0.5689)
,('SC0011','SERVIZIO MENSA','55510000-8','C62','4',false,0.5689)
,('SC0012','SERVIZIO MENSA SCOLASTICA','55523100-3','C62','4',false,0.5689)
,('SC0013','SERVIZIO DI CATERING','55520000-1','C62','4',false,0.5689)
,('SC0014','SERVIZI DI TRASPORTO MERCI','60161000-4','C62','4',false,0.5689)
,('SC0015','SERVIZI DI TRASLOCO','98392000-7','C62','4',false,0.5689)
)
AS tmp(codice, descrizione, cpv_codice,unita_misura_codice,aliquota_iva_codice,inventariabile, prezzo_unitario)
join cpass.cpass_d_unita_misura dum on (dum.unita_misura_codice = tmp.unita_misura_codice)
join cpass.cpass_d_cpv dc on (dc.cpv_codice  = tmp.cpv_codice)
join cpass.cpass_d_aliquote_iva dai on (dai.aliquote_iva_codice = tmp.aliquota_iva_codice)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_oggetti_spesa ts
  WHERE ts.oggetti_spesa_codice = tmp.codice
);


INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo
FROM (VALUES
  ('INS_ORDINE', 'Inserimento testata ordine', 'ORDINE', false, 'V'),
('INS_DETT_ORDINE', 'Inserimento riga, dest e finanz ordine', 'ORDINE', false, 'B'),
('MOD_ORDINE', 'Modifica testata ordine', 'ORDINE', false, 'B'),
('MOD_DETT_ORDINE', 'Modifica riga, dest e finanz ordine', 'ORDINE', false, 'B'),
('CANC_ORDINE', 'Cancella ordine', 'ORDINE', false, 'B'),
('CANC_DETT_ORDINE', 'Cancella riga, dest e finanz ordine', 'ORDINE', false, 'B'),
('ANN_ORDINE', 'Annulla ordine', 'ORDINE', false, 'B'),
('CONTROLLA_ORDINE', 'Controlla ordine', 'ORDINE', false, 'B'),
('CONFERMA_ORDINE', 'Conferma ordine', 'ORDINE', false, 'B'),
('AUTORIZZA_ORDINE', 'Autorizza ordine', 'ORDINE', false, 'B'),
('INVIA_ORDINE_A_NSO', 'Invia ordine a NSO', 'ORDINE', false, 'B'),
('CONSULTA_ORDINE', 'Consulta Ordine', 'ORDINE', false, 'V')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_permesso ds
  WHERE ds.permesso_codice = tmp.codice
);


/*
ORD	ORDINSEMPLICE	ORDINATORE SEMPLICE	INSERISCE ORDINI (SOLO FINO ALLO STATO CONFERMATO)
ORD	ORDINATORE	ORDINATORE	INSERISCE ORDINI E LI FA AVANZARE NELL'ITER
ORD	INTERRORD	INTERROGATORE ORDINI	CONSULTA ORDINI
ORD	TRASM_NSO	UTENTE ABILITATO A TRASMETTERE ORDINI A NSO	UTENTE ABILITATO A TRASMETTERE ORDINI A NSO
*/



-- ruoli
INSERT INTO cpass.cpass_d_ruolo(ruolo_codice, ruolo_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
	('ORDINSEMPLICE', 'INSERISCE ORDINI (SOLO FINO ALLO STATO CONFERMATO)'),
	('ORDINATORE'   , 'INSERISCE ORDINI E LI FA AVANZARE NELL''ITER'),
	('INTERRORD'    , 'CONSULTA ORDINI'),
	('TRASM_NSO'    , 'UTENTE ABILITATO A TRASMETTERE ORDINI A NSO')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_ruolo dr
	WHERE dr.ruolo_codice = tmp.codice
);



INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('ORDINSEMPLICE', 'INS_ORDINE'),
    ('ORDINSEMPLICE', 'INS_DETT_ORDINE'),
    ('ORDINSEMPLICE', 'MOD_ORDINE'),
    ('ORDINSEMPLICE', 'MOD_DETT_ORDINE'),
    ('ORDINSEMPLICE', 'CANC_ORDINE'),
    ('ORDINSEMPLICE', 'CANC_DETT_ORDINE'),
    ('ORDINSEMPLICE', 'CONSULTA_ORDINE'),
    ('ORDINATORE', 'INS_ORDINE'),
    ('ORDINATORE', 'INS_DETT_ORDINE'),
    ('ORDINATORE', 'MOD_ORDINE'),
    ('ORDINATORE', 'MOD_DETT_ORDINE'),
    ('ORDINATORE', 'CANC_ORDINE'),
    ('ORDINATORE', 'CANC_DETT_ORDINE'),
    ('ORDINATORE', 'ANN_ORDINE'),
    ('ORDINATORE', 'CONTROLLA_ORDINE'),
    ('ORDINATORE', 'CONFERMA_ORDINE'),
    ('ORDINATORE', 'AUTORIZZA_ORDINE'),
    ('ORDINATORE', 'CONSULTA_ORDINE'),
    ('TRASM_NSO', 'INVIA_ORDINE_A_NSO'),
    ('TRASM_NSO', 'CONSULTA_ORDINE'),
    ('INTERRORD', 'CONSULTA_ORDINE')

) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);



INSERT INTO cpass.cpass_r_ruolo_utente_settore (utente_settore_id, ruolo_id)
SELECT rus.utente_settore_id, dr.ruolo_id
FROM (VALUES
	('AAAAAA00A11B000J', 'SA0001', 'ORDINSEMPLICE'),
	('AAAAAA00A11B000J', 'SA0001', 'ORDINATORE'),
	('AAAAAA00A11B000J', 'SA0001', 'INTERRORD'),
	('AAAAAA00A11B000J', 'SA0001', 'TRASM_NSO')

) AS tmp(utente, settore, ruolo)
JOIN cpass.cpass_t_utente tu ON tu.utente_codice_fiscale = tmp.utente
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
JOIN cpass.cpass_r_utente_settore rus ON (rus.utente_id = tu.utente_id AND rus.settore_id = ts.settore_id)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_utente_settore rrus
	WHERE rrus.utente_settore_id = rus.utente_settore_id
	AND rrus.ruolo_id = dr.ruolo_id
);

INSERT INTO cpass.cpass_r_ufficio_settore (ufficio_id, settore_id,data_validita_inizio)
SELECT tu.ufficio_id, ts.settore_id, now()
FROM (VALUES
('A1000A','HQM2O9'),
('A1005D','HQM2O9'),
('A1006D','JBJRON'),
('A1006D','PT6DEI'),
('A1007D','FPRJNR'),
('A1008D','HQM2O9'),
('A1011A','HQM2O9'),
('A1012A','HQM2O9'),
('A1013A','HQM2O9'),
('A1014A','HQM2O9'),
('A1015A','HQM2O9'),
('A1016A','HQM2O9'),
('XST022','HQM2O9'),
('XST023','HQM2O9'),
('A11000','AX8DPY'),
('A11000','0XNNK3'),
('A1101A','AX8DPY'),
('A1102A','AX8DPY'),
('A1103A','AX8DPY'),
('A1104A','AX8DPY'),
('A1105A','AX8DPY'),
('A1106A','AX8DPY'),
('A1107A','AX8DPY'),
('A1108A','AX8DPY'),
('A1108B','AX8DPY'),
('A1109A','AX8DPY'),
('A1109B','AX8DPY'),
('A1110A','AX8DPY'),
('A1110B','AX8DPY'),
('A1111A','AX8DPY'),
('A1111C','7K3KWF'),
('A1111C','81YHY9'),
('A1111C','L77UYL'),
('A1111C','A17LZ5'),
('A1112C','A17LZ5'),
('A1196A','AX8DPY'),
('A1197A','AX8DPY'),
('A1198A','AX8DPY'),
('XST024','AX8DPY'),
('XST025','AX8DPY'),
('A12000','C82S84'),
('A1201A','C82S84'),
('A1202A','C82S84'),
('A1203A','C82S84'),
('A1204A','C82S84'),
('A1205A','C82S84'),
('A1206A','C82S84'),
('A1207A','C82S84'),
('A1208A','C82S84'),
('A1209B','C82S84'),
('A1210B','C82S84'),
('A1211A','C82S84'),
('A1295A','C82S84'),
('A1296A','C82S84'),
('A1297A','C82S84'),
('A1298A','C82S84'),
('A1400A','EFSFG6'),
('A1400A','ADAT4K'),
('A1404B','ADAT4K'),
('A1406B','THPX37'),
('A1407B','ADAT4K'),
('A1409B','ADAT4K'),
('A1413C','ADAT4K'),
('A1414C','ADAT4K'),
('A1415C','ADAT4K'),
('A1416C','ADAT4K'),
('A1417A','ADAT4K'),
('A1418A','ADAT4K'),
('A1419A','ADAT4K'),
('A1420A','ADAT4K'),
('A1421A','ADAT4K'),
('A1500A','S04VFA'),
('A1501B','S04VFA'),
('A1502B','S04VFA'),
('A1503B','S04VFA'),
('A1504B','S04VFA'),
('A1511C','S04VFA'),
('A1600A','E6A9MX'),
('A1601B','E6A9MX'),
('A1602B','E6A9MX'),
('A1603B','E6A9MX'),
('A1604B','E6A9MX'),
('A1605B','E6A9MX'),
('A1606B','E6A9MX'),
('A1607B','E6A9MX'),
('A1608B','E6A9MX'),
('A1609B','E6A9MX'),
('A1610B','E6A9MX'),
('A1611B','E6A9MX'),
('A1612B','E6A9MX'),
('A1613B','E6A9MX'),
('A1614A','E6A9MX'),
('A1615A','E6A9MX'),
('A1616A','E6A9MX'),
('XST026','E6A9MX'),
('A1700A','EOG7LT'),
('A1701B','EOG7LT'),
('A1703B','F7XJX1'),
('A1705B','EOG7LT'),
('A1706B','EOG7LT'),
('A1707B','EOG7LT'),
('A1708B','EOG7LT'),
('A1709C','EOG7LT'),
('A1710C','EOG7LT'),
('A1711C','EOG7LT'),
('A1712C','EOG7LT'),
('A1713C','EOG7LT'),
('A1800A','J9FDBP'),
('A1801B','J9FDBP'),
('A1802B','J9FDBP'),
('A1805B','J9FDBP'),
('A1806B','J9FDBP'),
('A1810B','J9FDBP'),
('A1811B','J9FDBP'),
('A1812B','J9FDBP'),
('A1813B','J9FDBP'),
('A1814B','J9FDBP'),
('A1816B','J9FDBP'),
('A1817B','J9FDBP'),
('A1819C','J9FDBP'),
('A1820C','6U1HQH'),
('A1821A','V3QQD9'),
('A1822A','J9FDBP'),
('XST027','J9FDBP'),
('A19000','1D1MZT'),
('A1901A','1D1MZT'),
('A1902A','1D1MZT'),
('A1903A','1D1MZT'),
('A1904A','1D1MZT'),
('A1905A','1D1MZT'),
('A1906A','1D1MZT'),
('A1907A','1D1MZT'),
('A1908A','1D1MZT'),
('A1909A','1D1MZT'),
('A1910A','ZRE6BX'),
('A1911A','1D1MZT'),
('A1998A','1D1MZT'),
('A2000A','YVDPFP'),
('A2001B','YVDPFP'),
('A2002B','YVDPFP'),
('A2003B','YVDPFP'),
('A2006B','YVDPFP'),
('A2007C','YVDPFP'),
('A2008C','YVDPFP'),
('A2009A','YVDPFP'),
('A21000','1MGN7P'),
('A2101A','1MGN7P'),
('A2102A','BR4EG5'),
('A2103A','1MGN7P'),
('A2104A','1MGN7P'),
('A2105A','1MGN7P'),
('A2106A','1MGN7P')
) AS tmp(settore, ufficio)
JOIN cpass.cpass_t_ufficio tu ON tu.ufficio_codice = tmp.ufficio
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ufficio_settore rus
	WHERE rus.settore_id = ts.settore_id
	AND rus.ufficio_id = tu.ufficio_id
);

INSERT INTO cpass.cpass_d_tipo_settore (tipo_settore_codice , tipo_settore_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (values
('R1-001','ASSESSORATO')
,('R1-002','AREA DI COORDINAMENTO')
,('R1-003','GIUNTA')
,('R1-004','DIREZIONE')
,('R1-005','ORGANO POLITICO')
,('R1-006','PROGETTI STRATEGICI DIREZIONALI')
,('R1-007','PROGETTI STRATEGICI SETTORIALI')
,('R1-008','SETTORE')
,('R1-009','STRUTTURA SPECIALE')
,('R1-010','STRUTTURA AMMINISTRATIVA')
,('R1-011','STRUTTURA FLESSIBILE')
,('R1-012','STRUTTURA FLESSIBILE DIREZIONALE')
,('R1-013','STRUTTURA FLESSIBILE INTERDIREZIONALE')
,('R1-014','UFFICIO DI COMUNICAZIONE')
,('R1-015','ALTRO')
,('R1-016','STRUTTURA FLESSIBILE INTERD. (NO INTERFACCE)')
,('R1-020','SETTORE SC MAGGIOR RILEVANZA')
,('R1-021','SETTORE SC MEDIA RILEVANZA')
,('R1-022','SETTORE SC BASE')
,('R1-023','STRUTTURA TEMPORANEA')
,('R1-024','STRUTTURA STABILE DIRIGENZIALE')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_tipo_settore ts
  WHERE ts.tipo_settore_codice = tmp.codice
);

update cpass.cpass_r_utente_settore set
data_validita_inizio = TO_TIMESTAMP('01-01-2020', 'dd-mm-yyyy');

update cpass.cpass_r_ruolo_utente_settore set
data_validita_inizio = TO_TIMESTAMP('01-01-2020', 'dd-mm-yyyy');

insert  into cpass.cpass_t_settore
(settore_id, settore_codice, settore_descrizione , settore_indirizzo, settore_localita ,settore_cap, settore_provincia, tipo_settore_id,settore_telefono,ente_id, data_creazione , utente_creazione ,utente_modifica)
SELECT
uuid_generate_v5(tun.uuid_namespace_value, tmp.codice) as settore_id, tmp.codice, tmp.descrizione, tmp.indirizzo , initcap(tmp.localita), tmp.cap, upper(tmp.pv), dts.tipo_settore_id ,'0',te.ente_id , now(), 'SYSTEM', 'SYSTEM'
FROM (values
('R1-005','R1','GIUNTA REGIONALE DEL PIEMONTE',NULL,'Piazza Castello 165','torino','10121','to')	 -- Chiedere conferma indirizzo, non specificato su excel
,('R1-004','A1000A','DIREZIONE DELLA GIUNTA REGIONALE','SA','Piazza Castello 165','torino','10121','to')
,('R1-008','A1005D','Indirizzi e controlli societa'' partecipate','A1000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1006D','Stato giuridico, ordinamento e formazione del personale','A1000A','Via Viotti 8','torino','10124','to')
,('R1-008','A1007D','Trattamento economico, pensionistico, previdenziale e assicurativo del personale','A1000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1008D','Organizzazione e pianificazione delle risorse umane','A1000A','Via Viotti 8','torino','10124','to')
,('R1-008','A1011A','Attività legislativa e consulenza giuridica','A1000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1012A','Contratti-persone giuridiche-espropri-usi civici','A1000A','Via Viotti 8','torino','10124','to')
,('R1-008','A1013B','Coordinamento e gestione servizi generali operativi - Tutela dei consumatori','A1000A','Corso Regina Margherita 174','torino','10138','to')
,('R1-008','A1014B','Rapporti con le Autonomie locali, Polizia locale, Sicurezza integrata, Elezioni e Referendum','A1000A','Corso Regina Margherita 174','torino','10138','to')
,('R1-008','A1015A','Segreteria della Giunta regionale','A1000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1017A','Audit interno','A1000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1018A','Avvocatura','A1000A','Corso Regina Margherita 174','torino','10138','to')
,('R1-008','A1099C','Direzione della Giunta regionale L.R. 23/2015','A1000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A11000','RISORSE FINANZIARIE E PATRIMONIO','SA','Piazza Castello 165','torino','10121','to')
,('R1-008','A1101A','Programmazione macroeconomica, bilancio e statistica','A11000','Piazza Castello 165','torino','10121','to')
,('R1-008','A1102A','Ragioneria','A11000','Piazza Castello 165','torino','10121','to')
,('R1-008','A1103A','Politiche fiscali e contenzioso amministrativo','A11000','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-008','A1110B','Acquisizione e controllo delle risorse finanziarie','A11000','Piazza Castello 165','torino','10121','to')
,('R1-008','A1111C','Patrimonio immobiliare, beni mobili, economato e cassa economale','A11000','Via Viotti 8','torino','10124','to')
,('R1-008','A1112C','Tecnico e sicurezza degli ambienti di lavoro','A11000','Via Viotti 8','torino','10124','to')
,('R1-004','A1400A','SANITA'' E WELFARE','SA','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-008','A1404B','Assistenza farmaceutica, integrativa e protesica','A1400A','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-008','A1406B','Sistemi organizzativi e risorse umane del SSR','A1400A','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-008','A1407B','Programmazione economico-finanziaria','A1400A','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-008','A1409B','Prevenzione e veterinaria','A1400A','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-008','A1413C','Programmazione dei servizi sanitari e socio-sanitari','A1400A','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-008','A1414C','Regole del SSR nei rapporti con i soggetti erogatori','A1400A','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-008','A1415C','Politiche degli investimenti','A1400A','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-008','A1416C','Controllo di gestione, sistemi informativi, logistica sanitaria e coordinamento acquisti','A1400A','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-008','A1417A','Anticorruzione e vigilanza sui contratti e sulle strutture pubbliche e private','A1400A','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-008','A1418A','Politiche di welfare abitativo	A1400A','A1400A','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-008','A1419A','Politiche per i bambini, le famiglie, minori e giovani, sostegno alle situazioni di fragilita'' sociale','A1400A','Via Magenta 12','torino','10122','to')
,('R1-008','A1420A','Politiche per le pari opportunita'', diritti e inclusione','A1400A','Via Bertola 34','torino','10125','to')
,('R1-008','A1421A','Programmazione socio-assistenziale e socio-sanitaria, standard di servizio e qualita''','A1400A','Via Bertola 34','torino','10125','to')
,('R1-008','A1499A','Sanità e welfare L.R. 23/2015','A1400A','Corso Regina Margherita 153 bis','torino','10138','to')
,('R1-004','A1500A','ISTRUZIONE, FORMAZIONE E LAVORO','SA','Piazza Castello 165','torino','10121','to')
,('R1-008','A1501B','Raccordo amministrativo e controllo delle attività cofinanziate dal FSE','A1500A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1502B','Politiche del lavoro','A1500A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1503B','Formazione professionale','A1500A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1504B','Standard formativi e orientamento professionale','A1500A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1511C','Politiche dell''istruzione, programmazione e monitoraggio strutture scolastiche','A1500A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1598B','Istruzione, formazione e lavoro - APL - CPI','A1500A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1599B','Istruzione, formazione e lavoro L.R. 23/2015','A1500A','Piazza Castello 165','torino','10121','to')
,('R1-004','A1600A','AMBIENTE, ENERGIA E TERRITORIO','SA','Piazza Castello 165','torino','10121','to')
,('R1-008','A1601B','Biodiversità e aree naturali','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1602B','Emissioni e rischi ambientali','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1603B','Servizi ambientali','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1604B','Tutela delle acque','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1605B','Valutazioni ambientali e procedure integrate','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1606B','Copianificazione urbanistica area nord-ovest','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1607B','Copianificazione urbanistica area nord-est','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1608B','Copianificazione urbanistica area sud-est','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1609B','Copianificazione urbanistica area sud-ovest','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1610B','Territorio e paesaggio','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1611B','Giuridico legislativo','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1612B','Progettazione strategica e green economy','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1613B','Sistema informativo territoriale e ambientale','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1614A','Foreste','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1615A','Sviluppo della montagna','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1616A','Sviluppo energetico sostenibile','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1699A','Ambiente, governo e tutela del territorio L.R. 23/2015','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-004','A1700A','AGRICOLTURA E CIBO','SA','Piazza Castello 165','torino','10121','to')
,('R1-008','A1701B','Produzioni agrarie e zootecniche','A1700A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1703B','Fitosanitario e servizi tecnico-scientifici','A1700A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1705B','Programmazione e coordinamento sviluppo rurale e agricoltura sostenibile','A1700A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1706B','Servizi di sviluppo e controlli per l''agricoltura','A1700A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1707B','Strutture delle imprese agricole ed agroindustriali ed energia rinnovabile','A1700A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1708B','Valorizzazione del sistema agroalimentare e tutela della qualità','A1700A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1709C','Infrastrutture, territorio rurale, calamita'' naturali in agricoltura, caccia e pesca','A1700A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1710C','Attuazione programmi relativi alle produzioni vegetali e animali','A1700A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1711C','Attuazione programmi relativi alle strutture delle aziende agricole e alle avversità atmosferiche','A1700A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1712C','Attuazione programmi relativi ai servizi di sviluppo','A1700A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1713C','Attuazione programmi agroambientali e per l''agricoltura biologica','A1700A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1799B','Agricoltura e cibo L.R. 23/2015','A1700A','Piazza Castello 165','torino','10121','to')
,('R1-004','A1800A','OPERE PUBBLICHE, DIFESA DEL SUOLO, PROTEZIONE CIVILE, TRASPORTI E LOGISTICA','SA','Piazza Castello 165','torino','10121','to')
,('R1-008','A1801B','Attività giuridica e amministrativa','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1802B','Infrastrutture e pronto intervento','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1805B','Difesa del suolo','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1806B','Sismico','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1809B','Pianificazione e programmazione trasporti e infrastrutture','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1810B','Controllo sulla gestione dei trasporti e delle infrastrutture','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1811B','Investimenti trasporti e infrastrutture','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1812B','Infrastrutture strategiche','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1813B','Tecnico regionale area metropolitana di Torino','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1814B','Tecnico regionale - Alessandria e Asti','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1816B','Tecnico regionale - Cuneo','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1817B','Tecnico regionale - Novara e Verbania','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1819C','Geologico','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1820C','Tecnico regionale - Biella e Vercelli','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1821A','Protezione civile','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1822A','Sistema anti incendi boschivi (A.I.B.)','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-008','A1899B','Opere pubbliche, difesa del suolo, protezione civile, trasporti e logistica L.R. 23/2015','A1800A','Piazza Castello 165','torino','10121','to')
,('R1-004','A19000','COMPETITIVITA'' DEL SISTEMA REGIONALE','SA','Piazza Castello 165','torino','10121','to')
,('R1-008','A1901A','Gestione amministrativa e finanziaria','A19000','Piazza Castello 165','torino','10121','to')
,('R1-008','A1902A','Artigianato','A19000','Piazza Castello 165','torino','10121','to')
,('R1-008','A1905A','Sviluppo sostenibile e qualificazione del sistema produttivo del territorio','A19000','Piazza Castello 165','torino','10121','to')
,('R1-008','A1906A','Polizia mineraria,  cave e miniere','A19000','Piazza Castello 165','torino','10121','to')
,('R1-008','A1907A','Sistema universitario, diritto allo studio, ricerca e innovazione','A19000','Piazza Castello 165','torino','10121','to')
,('R1-008','A1908A',' Monitoraggio valutazioni e controlli','A19000','Piazza Castello 165','torino','10121','to')
,('R1-008','A1910A','Servizi infrastrutturali e tecnologici','A19000','Piazza Castello 165','torino','10121','to')
,('R1-008','A1911A','Sistema informativo regionale','A19000','Piazza Castello 165','torino','10121','to')
,('R1-008','A1912A','Promozione dello sviluppo economico e accesso al credito per le imprese','A19000','Piazza Castello 165','torino','10121','to')
,('R1-008','A1999A','Competitività del sistema regionale L.R. 23/2015','A19000','Piazza Castello 165','torino','10121','to')
,('R1-004','A2000A','CULTURA, TURISMO E COMMERCIO','SA','Piazza Castello 165','torino','10121','to')
,('R1-008','A2001B','Promozione dei beni librari e archivistici, editoria ed istituti culturali','A2000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A2002B','Valorizzazione del patrimonio culturale, musei e siti UNESCO','A2000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A2003B','Promozione delle attività culturali, del patrimonio linguistico e dello spettacolo','A2000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A2006B','Museo regionale di scienze naturali','A2000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A2007C','Offerta turistica','A2000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A2008C','Promozione turistica','A2000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A2009A','Commercio e terziario','A2000A','Piazza Castello 165','torino','10121','to')
,('R1-008','A2099B','Cultura, turismo e commercio L.R. 23/2015','A2000A','Piazza Castello 165','torino','10121','to')
,('R1-004','A21000','COORDINAMENTO POLITICHE E FONDI EUROPEI','SA','Piazza Castello 165','torino','10121','to')
,('R1-008','A2101A','Affari internazionali e cooperazione decentrata','A21000','Piazza Castello 165','torino','10121','to')
,('R1-008','A2102A','Comunicazione, ufficio stampa, relazioni esterne, URP','A21000','Piazza Castello 165','torino','10121','to')
,('R1-008','A2103A','Coordinamento Fondi Strutturali Europei e cooperazione transfrontaliera','A21000','Piazza Castello 165','torino','10121','to')
,('R1-008','A2104A','Programmazione negoziata','A21000','Piazza Castello 165','torino','10121','to')
,('R1-008','A2105A','Relazioni istituzionali e Affari europei','A21000','Piazza Castello 165','torino','10121','to')
,('R1-008','A2106A','Sport e tempo libero','A21000','Piazza Castello 165','torino','10121','to')
,('R1-008','A2199A','Coordinamento politiche e fondi europei L.R. 23/2015','A21000','Piazza Castello 165','torino','10121','to')
,('R1-003','GI','GIUNTA','OP','Piazza Castello 165','torino','10121','to')
,('R1-005','OP','ORGANI POLITICI','R1','Piazza Castello 165','torino','10121','to')
,('R1-010','SA0001','TRASPARENZA E ANTICORRUZIONE','SA','Piazza Castello 165','torino','10121','to')
,('R1-010','SA','STRUTTURE AMMINISTRATIVE','R1','Piazza Castello 165','torino','10121','to')
,('R1-014','UC','UFFICI DI COMUNICAZIONE','SA','Piazza Castello 165','torino','10121','to')
,('R1-001','ACP','XI LEG- AGRICOLTURA, CIBO, CACCIA E PESCA','OP','Piazza Castello 165','torino','10121','to')
,('R1-001','AIR','XI LEG - AMBIENTE, ENERGIA, INNOVAZIONE, RICERCA E CONNESSI RAPPORTI CON ATENEI E CENTRI DI RICERCA PUBBLICI E PRIVATI','OP','Piazza Castello 165','torino','10121','to')
,('R1-001','BAI','XI LEG - BILANCIO, FINANZE, PROGRAMMAZIONE ECONOMICO-FINANZIARIA, PATRIMONIO, SVILUPPO DELLE ATTIVITA'' PRODUTTIVE E DELL','OP','Piazza Castello 165','torino','10121','to')
,('R1-001','CTC','XI LEG - CULTURA, TURISMO, COMMERCIO','OP','Piazza Castello 165','torino','10121','to')
,('R1-001','PCP','XI LEG - INTERNAZIONALIZZAZIONE, RAPPORTI CON SOCIETA A PARTECIPAZIONE REGIONALE, SICUREZZA, POLIZIA LOCALE, IMMIGRAZION','OP','Piazza Castello 165','torino','10121','to')
,('R1-001','LFU','XI LEG - ISTRUZIONE, LAVORO, FORMAZIONE PROFESSIONALE, DIRITTO ALLO STUDIO UNIVERSITARIO','OP','Piazza Castello 165','torino','10121','to')
,('R1-001','FSP','XI LEG - POLITICHE DELLA FAMIGLIA, DEI BAMBINI E DELLA CASA, SOCIALE, PARI OPPORTUNITA''','	OP','Piazza Castello 165','torino','10121','to')
,('R1-001','PRE','XI LEG - PRESIDENZA','OP','Piazza Castello 165','torino','10121','to')
,('R1-001','DAC','XI LEG - RAPPORTI CON IL CONSIGLIO REGIONALE, DELEGIFICAZIONE E SEMPLIFICAZIONE DEI PERCORSI AMMINISTRATIVI, AFFARI LEGA','OP','Piazza Castello 165','torino','10121','to')
,('R1-001','SAE','XI LEG - SANITA'', LIVELLI ESSENZIALI DI ASSISTENZA, EDILIZIA SANITARIA','OP','Piazza Castello 165','torino','10121','to')
,('R1-001','OTP','XI LEG - TRASPORTI, INFRASTRUTTURE, OPERE PUBBLICHE, DIFESA DEL SUOLO, PROTEZIONE CIVILE, PERSONALE E ORGANIZZAZIONE','OP','Piazza Castello 165','torino','10121','to')
--,('R1-001','ACP','XI LEG - UFF. COM. AGRICOLTURA, CIBO, CACCIA E PESCA','UC','Piazza Castello 165','torino','10121','to')
,('R1-014','AIR00','XI LEG - UFF. COM. AMBIENTE, ENERGIA, INNOVAZIONE, RICERCA E CONNESSI RAPPORTI CON ATENEI E CENTRI DI RICERCA PUBBLICI E','UC','Piazza Castello 165','torino','10121','to')
,('R1-014','BAI00','XI LEG - UFF. COM. BILANCIO, FINANZE, PROGRAMMAZIONE ECONOMICO-FINANZIARIA, PATRIMONIO, SVILUPPO DELLE ATTIVITA'' PRODUTT','UC','Piazza Castello 165','torino','10121','to')
,('R1-014','CTC00','XI LEG - UFF. COM. CULTURA, TURISMO, COMMERCIO','UC','Piazza Castello 165','torino','10121','to')
,('R1-014','PCP00','XI LEG - UFF. COM. INTERNAZIONALIZZAZIONE, RAPPORTI CON SOCIETA'' A PARTECIPAZIONE REGIONALE, SICUREZZA, POLIZIA LOCALE,','UC','Piazza Castello 165','torino','10121','to')
,('R1-014','LFU00','XI LEG - UFF. COM. ISTRUZIONE, LAVORO, FORMAZIONE PROFESSIONALE, DIRITTO ALLO STUDIO UNIVERSITARIO','UC','Piazza Castello 165','torino','10121','to')
,('R1-014','FSP00','XI LEG - UFF. COM. POLITICHE DELLA FAMIGLIA, DEI BAMBINI E DELLA CASA, SOCIALE, PARI OPPORTUNITA''','UC','Piazza Castello 165','torino','10121','to')
,('R1-014','PRE00','XI LEG - UFF. COM. PRESIDENZA','UC','Piazza Castello 165','torino','10121','to')
,('R1-014','DAC00','XI LEG - UFF. COM. RAPPORTI CON IL CONSIGLIO REGIONALE, DELEGIFICAZIONE E SEMPLIFICAZIONE DEI PERCORSI AMMINISTRATIVI, A','UC','Piazza Castello 165','torino','10121','to')
,('R1-014','SAE00','XI LEG - UFF. COM. SANITA'', LIVELLI ESSENZIALI DI ASSISTENZA, EDILIZIA SANITARIA','UC','Piazza Castello 165','torino','10121','to')
,('R1-014','OTP00','XI LEG - UFF. COM. TRASPORTI, INFRASTRUTTURE, OPERE PUBBLICHE, DIFESA DEL SUOLO, PROTEZIONE CIVILE, PERSONALE E ORGANIZZ','UC','Piazza Castello 165','torino','10121','to')
,('R1-014','UTE00','XI LEG - UFF. COM. URBANISTICA, PROGRAMMAZIONE TERRITORIALE E PAESAGGISTICA, SVILUPPO DELLA MONTAGNA, FORESTE, PARCHI, E','UC','Piazza Castello 165','torino','10121','to')
,('R1-001','UTE','XI LEG - URBANISTICA, PROGRAMMAZIONE TERRITORIALE E PAESAGGISTICA, SVILUPPO DELLA MONTAGNA, FORESTE, PARCHI, ENTI LOCALI','OP','Piazza Castello 165','torino','10121','to')
,('R1-011','XST009','XST009 - Struttura temporanea per la gestione del progetto "Palazzo degli uffici della Regione Piemonte - fase di realiz','A11000','Piazza Castello 165','torino','10121','to')
,('R1-011','XST010','XST010 - Gestione progetto ZUT','A11000','Piazza Castello 165','torino','10121','to')
,('R1-011','XST022','XST022 - Piano di rafforzamento amministrativo','A1000A','Piazza Castello 165','torino','10121','to')
,('R1-011','XST023','XST023 - Iniziative di negoziazione di rilevanza strategica','A1000A','Piazza Castello 165','torino','10121','to')
,('R1-011','XST024','XST024 - Gestione del progetto "Palazzo degli uffici della Regione Piemonte - fase di realizzazione e gestione progetto','A11000','Piazza Castello 165','torino','10121','to')
,('R1-011','XST025','XST025 - Gestione del progetto "Welfare aziendale e benessere organizzativo nel palazzo degli uffici della Regione Piemo','A11000','Piazza Castello 165','torino','10121','to')
,('R1-011','XST026','XST026 - Agenda Nazionale per la semplificazione amministrativa: azioni per i procedimenti regionali in materia di Ambie','A1600A','Piazza Castello 165','torino','10121','to')
,('R1-011','XST027','XST027 - Gestione liquidatoria comunità montane','A1800A','Piazza Castello 165','torino','10121','to')
 ) AS tmp (tipo_codice, codice, descrizione,codice_padre,indirizzo,localita,cap,pv)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_settore')
join cpass.cpass_d_tipo_settore dts on (dts.tipo_settore_codice = tmp.tipo_codice)
JOIN cpass.cpass_t_ente te on ( te.ente_denominazione = 'REGIONE PIEMONTE' )
where NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore ts
  WHERE ts.settore_codice = tmp.codice
);
update cpass.cpass_t_settore set settore_indirizzo = 'CORSO INGHILTERRA', settore_num_civico = '7' where settore_indirizzo = 'CORSO INGHILTERRA, N° 7';
update cpass.cpass_t_settore set settore_indirizzo = 'Via Viotti', settore_num_civico = '8' where settore_indirizzo = 'Via Viotti 8';
update cpass.cpass_t_settore set settore_indirizzo = 'Corso Regina Margherita', settore_num_civico = '174' where settore_indirizzo = 'Corso Regina Margherita 174';
update cpass.cpass_t_settore set settore_indirizzo = 'Via Maria Vittoria', settore_num_civico = '15' where settore_indirizzo = 'Via Maria Vittoria,15';
update cpass.cpass_t_settore set settore_indirizzo = 'Piazza Castello', settore_num_civico = '165' where settore_indirizzo = 'Piazza Castello 165';
update cpass.cpass_t_settore set settore_indirizzo = 'Via Viotti', settore_num_civico = '8' where settore_indirizzo = 'Via Viotti, 8';
update cpass.cpass_t_settore set settore_indirizzo = '', settore_num_civico = '' where settore_indirizzo = 'Via Bertola 34';
update cpass.cpass_t_settore set settore_indirizzo = 'Corso Regina Margherita', settore_num_civico = '153 bis' where settore_indirizzo = 'Corso Regina Margherita 153 bis';
update cpass.cpass_t_settore set settore_indirizzo = 'Via Magenta', settore_num_civico = '12' where settore_indirizzo = 'Via Magenta 12';
update cpass.cpass_t_settore set settore_indirizzo = 'Piazza Castello', settore_num_civico = '165' where settore_indirizzo = 'Piazza Castello, 165';
update cpass.cpass_t_settore set settore_indirizzo = 'Via Magenta', settore_num_civico = '12' where settore_indirizzo = 'Via Magenta, 12';
update cpass.cpass_t_settore set settore_indirizzo = 'Corso Bolzano', settore_num_civico = '44' where settore_indirizzo = 'Corso Bolzano, 44';

Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'SA') where settore_codice = 'A1000A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'A1005D';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'A1006D';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'A1007D';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'A1008D';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'A1011A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'A1012A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'A1013B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'A1014B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'A1015A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'A1017A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'A1018A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'A1099C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'SA') where settore_codice = 'A11000';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A11000') where settore_codice = 'A1101A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A11000') where settore_codice = 'A1102A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A11000') where settore_codice = 'A1103A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A11000') where settore_codice = 'A1110B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A11000') where settore_codice = 'A1111C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A11000') where settore_codice = 'A1112C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'SA') where settore_codice = 'A1400A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1404B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1406B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1407B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1409B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1413C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1414C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1415C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1416C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1417A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1418A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1419A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1420A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1421A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1400A') where settore_codice = 'A1499A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'SA') where settore_codice = 'A1500A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1500A') where settore_codice = 'A1501B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1500A') where settore_codice = 'A1502B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1500A') where settore_codice = 'A1503B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1500A') where settore_codice = 'A1504B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1500A') where settore_codice = 'A1511C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1500A') where settore_codice = 'A1598B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1500A') where settore_codice = 'A1599B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'SA') where settore_codice = 'A1600A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1601B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1602B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1603B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1604B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1605B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1606B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1607B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1608B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1609B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1610B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1611B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1612B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1613B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1614A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1615A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1616A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'A1699A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'SA') where settore_codice = 'A1700A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1700A') where settore_codice = 'A1701B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1700A') where settore_codice = 'A1703B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1700A') where settore_codice = 'A1705B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1700A') where settore_codice = 'A1706B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1700A') where settore_codice = 'A1707B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1700A') where settore_codice = 'A1708B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1700A') where settore_codice = 'A1709C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1700A') where settore_codice = 'A1710C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1700A') where settore_codice = 'A1711C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1700A') where settore_codice = 'A1712C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1700A') where settore_codice = 'A1713C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1700A') where settore_codice = 'A1799B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'SA') where settore_codice = 'A1800A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1801B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1802B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1805B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1806B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1809B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1810B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1811B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1812B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1813B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1814B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1816B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1817B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1819C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1820C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1821A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1822A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'A1899B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'SA') where settore_codice = 'A19000';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A19000') where settore_codice = 'A1901A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A19000') where settore_codice = 'A1902A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A19000') where settore_codice = 'A1905A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A19000') where settore_codice = 'A1906A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A19000') where settore_codice = 'A1907A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A19000') where settore_codice = 'A1908A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A19000') where settore_codice = 'A1910A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A19000') where settore_codice = 'A1911A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A19000') where settore_codice = 'A1912A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A19000') where settore_codice = 'A1999A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'SA') where settore_codice = 'A2000A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A2000A') where settore_codice = 'A2001B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A2000A') where settore_codice = 'A2002B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A2000A') where settore_codice = 'A2003B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A2000A') where settore_codice = 'A2006B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A2000A') where settore_codice = 'A2007C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A2000A') where settore_codice = 'A2008C';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A2000A') where settore_codice = 'A2009A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A2000A') where settore_codice = 'A2099B';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'SA') where settore_codice = 'A21000';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A21000') where settore_codice = 'A2101A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A21000') where settore_codice = 'A2102A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A21000') where settore_codice = 'A2103A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A21000') where settore_codice = 'A2104A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A21000') where settore_codice = 'A2105A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A21000') where settore_codice = 'A2106A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A21000') where settore_codice = 'A2199A';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'GI';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'R1') where settore_codice = 'OP';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'SA') where settore_codice = 'SA0001';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'R1') where settore_codice = 'SA';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'SA') where settore_codice = 'UC';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'ACP';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'AIR';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'BAI';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'CTC';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'PCP';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'LFU';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'FSP';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'PRE';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'DAC';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'SAE';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'OTP';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'UC') where settore_codice = 'ACP';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'UC') where settore_codice = 'AIR00';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'UC') where settore_codice = 'BAI00';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'UC') where settore_codice = 'CTC00';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'UC') where settore_codice = 'PCP00';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'UC') where settore_codice = 'LFU00';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'UC') where settore_codice = 'FSP00';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'UC') where settore_codice = 'PRE00';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'UC') where settore_codice = 'DAC00';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'UC') where settore_codice = 'SAE00';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'UC') where settore_codice = 'OTP00';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'UC') where settore_codice = 'UTE00';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'OP') where settore_codice = 'UTE';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A11000') where settore_codice = 'XST009';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A11000') where settore_codice = 'XST010';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'XST022';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1000A') where settore_codice = 'XST023';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A11000') where settore_codice = 'XST024';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A11000') where settore_codice = 'XST025';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1600A') where settore_codice = 'XST026';
Update cpass.cpass_t_settore set settore_padre_id = (select settore_id from cpass.cpass_t_settore where settore_codice = 'A1800A') where settore_codice = 'XST027';

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
            s.settore_num_civico ,
            s.settore_contatto,
            s.settore_email ,
            s.ente_id
           FROM cpass.cpass_t_settore s
             --JOIN cpass.cpass_t_ente e ON e.ente_id = s.ente_id AND e.ente_denominazione::text = 'REGIONE PIEMONTE'::text
          WHERE s.settore_padre_id IS null
          and (
          	s.data_cancellazione is null or (s.data_cancellazione is not null and s.data_cancellazione >= date_trunc('day',now()))
          	)
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
            s_figlio.settore_num_civico ,
            s_figlio.settore_contatto,
            s_figlio.settore_email ,
            s_figlio.ente_id
           FROM cpass.cpass_t_settore s_figlio
           JOIN alberosettore mtree ON mtree.settore_id = s_figlio.settore_padre_id
           where (s_figlio.data_cancellazione is null or (s_figlio.data_cancellazione is not null and s_figlio.data_cancellazione >= date_trunc('day',now())))
        )
 SELECT
    row_number() OVER () AS id_v_settore,
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
    alberosettore.settore_num_civico ,
    alberosettore.settore_contatto,
    alberosettore.settore_email ,
    alberosettore.ente_id
   FROM alberosettore
  ORDER BY alberosettore.livello DESC, alberosettore.settore_id;

-- Permissions

ALTER TABLE IF EXISTS cpass.cpass_v_settore OWNER TO cpass;

INSERT INTO cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.tipo
FROM (VALUES
	('BOZZA' , 'BOZZA', 'ORDINE'),
	('CONFERMATO','CONFERMATO', 'ORDINE'),
	('ANNULLATO','ANNULLATO', 'ORDINE'),
	('AUTORIZZATO','AUTORIZZATO', 'ORDINE')
) AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_stato ds
	WHERE ds.stato_codice = tmp.codice
	and   ds.stato_tipo = tmp.tipo
);

-- aggiorno stato errato BOZZA della testata
UPDATE cpass.cpass_t_ord_testata_ordine
SET stato_id = 9
WHERE stato_id = 1
;

insert  into cpass.cpass_t_settore_indirizzo
(descrizione,indirizzo,num_civico,localita,provincia,cap,contatto,email,telefono,settore_id,data_creazione,utente_creazione,utente_modifica)
SELECT
tmp.descrizione, tmp.indirizzo , tmp.num_civico, initcap(tmp.localita),upper(tmp.pv), tmp.cap,tmp.contatto,tmp.email,tmp.telefono,cts.settore_id,now(), 'SYSTEM', 'SYSTEM'
FROM (values
('A2102A','SEDE DI BIELLA','Via Quintino Sella','12','Biella','BI','13900','PINCO PALLINO','pinco@pallino.it','015 855'),
('A2102A','SEDE DI CUNEO','Corso Kennedy','7 bis','Cuneo','CN','12100','BOERO','i@boeri.it','0171 603'),
('A2102A','SEDE DI NOVARA','Via Mora Gibin','4','Novara','NO','28100','MORA','mora@gibin.it','0321 455'),
('A2102A','SEDE DI TORINO','Piazza Castello','165','Torino','TO','10122','SIGNORA LIA','signora@lia.it','011 432 4'),
('A2102A','SEDE DI VERBANIA','Via V. Veneto','107','Verbania','VB','28922','MISTER TAMBURINO','mister@tamburino.it','0323 509'),
('A2102A','SEDE DI VERCELLI','Via Fratelli Ponti, 24 (presso Palazzo Verga)','24','Vercelli','VC','13100','MALAVOGLIA','i@malavoglia.it','0161 600'),
('A1419A','SEDE SECONDARIA','Via Bertola','34','torino','to','10122','SIG. NESSUNO','nessuno@reg.it','011 432')
)AS tmp (settore_codice, descrizione,indirizzo,num_civico,localita,pv,cap,contatto,email,telefono)
join cpass.cpass_t_settore cts on (cts.settore_codice = tmp.settore_codice)
where NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore_indirizzo ts
  WHERE ts.settore_id = cts.settore_id
);


-- parametro "tolleranza iva"
INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('ORD_TOLLERANZA_IVA', '0.05', 'RIGA-ORDINE', '', 'Per controllo tolleranza iva', true)
) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass.cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);


insert into cpass.cpass_d_ord_stato_nso (stato_nso_codice, stato_nso_descrizione, stato_nso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.tipo
FROM ( VALUES
	('OK', 'OK', 'ORDINE'),
	('KO', 'KO', 'ORDINE')
) AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass.cpass_d_ord_stato_nso tp
	WHERE tp.stato_nso_codice = tmp.codice
);


-- Stampa ORD -- INIZIO
INSERT INTO cpass_t_parametro_stampa (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
SELECT tmp.modulo, tmp.nome_stampa, tmp.file_name_template, tmp.parametro, tmp.parametro_tipo, tmp.ordinamento, tmp.procedure_utilizzate, tmp.note, tmp.formato_stampa
FROM (VALUES
    ('ORD', 'PRT_T_ORD', 'Stampa_Copia_Fornitore.rptdesign', 'p_ordine_id', 'UUID', 1, NULL, NULL, 'pdf')
) AS tmp (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
WHERE NOT EXISTS (
    SELECT 1
    FROM cpass_t_parametro_stampa tps
    WHERE tps.modulo = tmp.modulo
    AND tps.nome_stampa = tmp.nome_stampa
    AND tps.parametro = tmp.parametro
    AND tps.ordinamento = tmp.ordinamento
);
-- Stampa ORD -- FINE

-- JIRA CPASS-133 ORD-RUOLI E ABILITAZIONI - PROBLEMA SULL'ADMIN - inizio
-- associati all'ADMIN tutti i permessi relativi all'ordine
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (
	select permesso_codice as permesso
	from cpass_d_permesso p
	where permesso_titolo_box = 'ORDINE'
) AS tmp
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = 'ADMIN'
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

-- relazione ruolo ADMIN, modulo ORD
INSERT INTO cpass_r_ruolo_modulo (ruolo_id, modulo_id)
SELECT dr.ruolo_id, dm.modulo_id
FROM (VALUES
	('INTERRORD', 'ORD'),
	('ORDINATORE', 'ORD'),
	('ORDINSEMPLICE', 'ORD'),
	('RUP', 'ORD'),
	('TRASM_NSO', 'ORD'),
	('ADMIN', 'ORD')
) AS tmp(ruolo, modulo)
JOIN cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass_d_modulo dm ON dm.modulo_codice = tmp.modulo
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_r_ruolo_modulo rrm
	WHERE rrm.ruolo_id = dr.ruolo_id
	AND rrm.modulo_id = dm.modulo_id
);
-- JIRA CPASS-133 ORD-RUOLI E ABILITAZIONI - PROBLEMA SULL'ADMIN - fine
