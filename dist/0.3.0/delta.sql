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
----------------------------------------------------------------------------------------------------------------------------------
------------------------------------------DDL-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
/*
drop table if exists cpass.cpass_t_ord_subimpegno_evasione;
drop table if exists cpass.cpass_t_ord_impegno_evasione;
drop table if exists cpass.cpass_t_ord_riga_evasione;
drop table if exists cpass.cpass_t_ord_destinatario_evasione;
drop table if exists cpass.cpass_t_ord_testata_evasione;
drop table if exists cpass.cpass_d_ord_tipo_evasione;
drop table if exists cpass.cpass_d_ord_causale_sospensione_evasione;
drop table if exists cpass.cpass_t_ord_documento_trasporto_riga;
drop table if exists cpass.cpass_t_ord_documento_trasporto;
*/
drop view if EXISTS cpass_v_riepilogo_fattura_evasione ;
drop view if EXISTS cpass.cpass_v_evasione;


CREATE TABLE if not exists  cpass.cpass_t_ord_documento_trasporto (
	documento_trasporto_id  SERIAL 
   ,CONSTRAINT cpass_t_ord_documento_trasporto_pkey PRIMARY KEY(documento_trasporto_id)
);
  
COMMENT ON TABLE cpass.cpass_t_ord_documento_trasporto
IS 'UUID namespace: "cpass_t_ord_documento_trasporto"';

CREATE TABLE if not exists  cpass.cpass_t_ord_documento_trasporto_riga (
	documento_trasporto_riga_id  SERIAL 
   ,documento_trasporto_id integer not null
   ,CONSTRAINT cpass_t_ord_documento_trasporto_riga_pkey PRIMARY KEY(documento_trasporto_riga_id)
   ,CONSTRAINT fk_cpass_t_documento_trasporto_documento_trasporto_riga FOREIGN KEY (documento_trasporto_id)
    REFERENCES cpass.cpass_t_ord_documento_trasporto(documento_trasporto_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
);
COMMENT ON TABLE cpass.cpass_t_ord_documento_trasporto_riga
IS 'UUID namespace: "cpass_t_ord_documento_trasporto_riga"';

CREATE TABLE IF NOT EXISTS cpass.cpass_d_ord_causale_sospensione_evasione (
  causale_sospensione_id SERIAL ,
  causale_sospensione_codice VARCHAR(50) NOT NULL,
  causale_sospensione_descrizione VARCHAR(500) NOT NULL,
  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  CONSTRAINT cpass_d_ord_causale_sospensione_evasione_pkey PRIMARY KEY(causale_sospensione_id)
);

CREATE TABLE if not exists cpass.cpass_d_ord_tipo_evasione (                  
  tipo_evasione_id SERIAL ,
  tipo_evasione_codice VARCHAR(50) NOT NULL,
  tipo_evasione_descrizione VARCHAR(500) NOT NULL,
  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  CONSTRAINT cpass_d_ord_tipo_evasione_pkey PRIMARY KEY(tipo_evasione_id)
) ;

CREATE TABLE if not exists  cpass.cpass_t_ord_testata_evasione (
  testata_evasione_id UUID NOT NULL,
  evasione_anno INTEGER NOT NULL,
  evasione_numero INTEGER NOT NULL,
  fornitore_id UUID NOT NULL,
  data_inserimento TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  settore_competente_id  UUID NOT NULL,
  stato_id INTEGER,
  ufficio_id INTEGER,
  totale_con_iva NUMERIC(13,5),
  utente_compilatore_id UUID NOT NULL,
  descrizione VARCHAR(150) NOT NULL,
  data_conferma TIMESTAMP WITHOUT TIME ZONE,
  data_ripartizione TIMESTAMP WITHOUT TIME ZONE,
  data_invio TIMESTAMP WITHOUT TIME ZONE,
  data_autorizzazione TIMESTAMP WITHOUT TIME ZONE, 
  fattura_anno INTEGER,
  fattura_numero VARCHAR(200),
  fattura_tipo VARCHAR(10),
  fattura_codice VARCHAR(50),   --??fattuira codice beneficiario?
  fattura_protocollo_anno INTEGER ,
  fattura_protocollo_numero INTEGER ,
  fattura_totale NUMERIC(13,5),
  fattura_totale_liquidabile NUMERIC(13,5),
  data_consegna TIMESTAMP WITHOUT TIME ZONE,
  documento_consegna      VARCHAR(200),
  documento_data_consegna TIMESTAMP WITHOUT TIME ZONE,
  documento_trasporto_id INTEGER, --si vedrà in futuro come va trattata
  --IDENTIFICATIVO DDT FK TABELLA DDT
  --causale_sospensione_id INTEGER,
  tipo_evasione_id INTEGER,
  NOTE VARCHAR(4000),
  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  optlock UUID DEFAULT uuid_generate_v4() NOT NULL
  --CONSTRAINT cpass_t_ord_testata_ordine_anno_numero_settore_unique UNIQUE(ordine_anno, ordine_numero, settore_emittente_id),
  ,CONSTRAINT cpass_t_ord_testata_evasione_pkey PRIMARY KEY(testata_evasione_id)  
  ,CONSTRAINT fk_cpass_t_ord_testata_evasione_t_settore FOREIGN KEY (settore_competente_id)
    REFERENCES cpass.cpass_t_settore(settore_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
  ,CONSTRAINT fk_cpass_t_ord_testata_evasione_t_utente FOREIGN KEY (utente_compilatore_id)
    REFERENCES cpass.cpass_t_utente(utente_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
 ,CONSTRAINT fk_cpass_t_ord_testata_evasione_d_stato FOREIGN KEY (stato_id)
    REFERENCES cpass.cpass_d_stato(stato_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
  ,CONSTRAINT fk_cpass_t_ord_testata_evasione_fornitore FOREIGN KEY (fornitore_id)
    REFERENCES cpass.cpass_t_fornitore(fornitore_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
 ,CONSTRAINT fk_cpass_t_ord_testata_evasione_DDT FOREIGN KEY (documento_trasporto_id)
    REFERENCES cpass.cpass_t_ord_documento_trasporto(documento_trasporto_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
 /*   
 ,CONSTRAINT fk_cpass_t_ord_testata_evasione_causale_sospensione FOREIGN KEY (causale_sospensione_id)
    REFERENCES cpass.cpass_d_ord_causale_sospensione_evasione(causale_sospensione_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
 */
 ,CONSTRAINT fk_cpass_t_ord_testata_evasione_tipo FOREIGN KEY (tipo_evasione_id)
    REFERENCES cpass.cpass_d_ord_tipo_evasione(tipo_evasione_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
 ,CONSTRAINT fk_cpass_t_ord_testata_evasione_t_ufficio FOREIGN KEY (ufficio_id)
    REFERENCES cpass.cpass_t_ufficio(ufficio_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE

);
 COMMENT ON TABLE cpass.cpass_t_ord_testata_evasione
IS 'UUID namespace: "cpass_t_ord_testata_evasione"';

ALTER TABLE cpass.cpass_t_ord_testata_evasione
  ALTER COLUMN fattura_numero TYPE VARCHAR(200);
  
CREATE TABLE if not exists  cpass.cpass_t_ord_destinatario_evasione (
  destinatario_evasione_id UUID NOT NULL,
  testata_evasione_id UUID NOT NULL,
  progressivo INTEGER NOT NULL, 
  
  indirizzo VARCHAR(200),
  num_civico VARCHAR(20),
  localita VARCHAR(200),
  provincia VARCHAR(200),
  cap VARCHAR(5),
  contatto VARCHAR(200),
  email VARCHAR(50),
  telefono VARCHAR(50),

  destinatario_id UUID NOT NULL,
  settore_destinatario_id UUID,
  stato_el_ordine_id INTEGER NOT NULL,
  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  optlock UUID DEFAULT uuid_generate_v4() NOT NULL
  ,CONSTRAINT cpass_t_ord_destinatario_evasione_pkey PRIMARY KEY(destinatario_evasione_id)  
  
  ,CONSTRAINT fk_cpass_t_ord_destinatario_evasione_testata_evasione FOREIGN KEY (testata_evasione_id)
    REFERENCES cpass.cpass_t_ord_testata_evasione(testata_evasione_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
  
  ,CONSTRAINT fk_cpass_t_ord_destinatario_evasione_destinatario_ordine FOREIGN KEY (destinatario_id)
    REFERENCES cpass.cpass_t_ord_destinatario_ordine(destinatario_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
   
   ,CONSTRAINT fk_cpass_t_ord_destinatario_evasione_settore FOREIGN KEY (settore_destinatario_id)
    REFERENCES cpass.cpass_t_settore(settore_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
  
  ,CONSTRAINT fk_cpass_t_ord_destinatario_evasione_stato_el_ordine FOREIGN KEY (stato_el_ordine_id)
    REFERENCES cpass.cpass_d_stato_el_ordine(stato_el_ordine_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE 
    
);
COMMENT ON TABLE cpass.cpass_t_ord_destinatario_evasione
IS 'UUID namespace: "cpass_t_ord_destinatario_evasione"';



CREATE TABLE if not exists  cpass.cpass_t_ord_riga_evasione (
  riga_evasione_id UUID NOT NULL,
  progressivo INTEGER NOT NULL, 
  --quantita NUMERIC(8,2),
  importo_totale NUMERIC(13,5),
  prezzo_unitario NUMERIC(13,5),
  destinatario_evasione_id UUID NOT NULL,
  riga_ordine_id UUID NOT NULL,
  aliquote_iva_id INTEGER NOT NULL,
  oggetti_spesa_id INTEGER NOT NULL,
  stato_el_ordine_id INTEGER NOT NULL,
  listino_fornitore_id INTEGER,
  documento_trasporto_riga_id INTEGER, 
  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  optlock UUID DEFAULT uuid_generate_v4() NOT NULL
  ,CONSTRAINT cpass_t_ord_riga_evasione_pkey PRIMARY KEY(riga_evasione_id)  
  ,CONSTRAINT fk_cpass_t_ord_riga_evasione_destinatario_evasione FOREIGN KEY (destinatario_evasione_id)
      REFERENCES cpass.cpass_t_ord_destinatario_evasione(destinatario_evasione_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE

  ,CONSTRAINT fk_cpass_t_ord_riga_evasione_riga_ordine FOREIGN KEY (riga_ordine_id)
      REFERENCES cpass.cpass_t_ord_riga_ordine(riga_ordine_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE
   
   ,CONSTRAINT fk_cpass_t_ord_riga_evasione_aliquote_iva FOREIGN KEY (aliquote_iva_id)
      REFERENCES cpass.cpass_d_aliquote_iva(aliquote_iva_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE

    ,CONSTRAINT fk_cpass_t_ord_riga_evasione_oggetti_spesa FOREIGN KEY (oggetti_spesa_id)
      REFERENCES cpass.cpass_d_oggetti_spesa(oggetti_spesa_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE
      
    ,CONSTRAINT fk_cpass_t_ord_riga_evasione_stato_el_ordine FOREIGN KEY (stato_el_ordine_id)
      REFERENCES cpass.cpass_d_stato_el_ordine(stato_el_ordine_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE
    
    ,CONSTRAINT fk_cpass_t_ord_riga_evasionee_listino_fornitore FOREIGN KEY (listino_fornitore_id)
      REFERENCES cpass.cpass_t_listino_fornitore(listino_fornitore_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE
      
     ,CONSTRAINT fk_cpass_t_ord_riga_evasionee_ddt FOREIGN KEY (documento_trasporto_riga_id)
      REFERENCES cpass.cpass_t_ord_documento_trasporto_riga(documento_trasporto_riga_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE      
);

 COMMENT ON TABLE cpass.cpass_t_ord_riga_evasione
IS 'UUID namespace: "cpass_t_ord_riga_evasione"';




CREATE TABLE if not exists  cpass.cpass_t_ord_impegno_evasione (
    impegno_evasione_id UUID NOT NULL,
    riga_evasione_id UUID NOT NULL,
    impegno_id UUID NOT NULL,
    impegno_ordine_id UUID NOT NULL,
    impegno_progressivo INTEGER NOT NULL,
    impegno_anno_esercizio INTEGER NOT NULL,
    impegno_anno INTEGER NOT NULL,
    impegno_numero INTEGER NOT NULL,
    importo_ripartito NUMERIC(13,5),
    importo_sospeso NUMERIC(13,5),    
    importo_liquidato NUMERIC(13,5),
    --sospensione_causale varchar(4000),
    causale_sospensione_id INTEGER,
    data_sospensione TIMESTAMP WITHOUT TIME ZONE,   
    data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
    utente_creazione VARCHAR(250) NOT NULL,
    data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
    utente_modifica VARCHAR(250) NOT NULL,
    data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
    utente_cancellazione VARCHAR(250),
    optlock UUID DEFAULT uuid_generate_v4() NOT NULL
	,CONSTRAINT cpass_t_ord_impegno_evasione_pkey PRIMARY KEY(impegno_evasione_id)  
    
    ,CONSTRAINT fk_cpass_t_ord_impegno_evasione_riga_evasione FOREIGN KEY (riga_evasione_id)
      REFERENCES cpass.cpass_t_ord_riga_evasione(riga_evasione_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE
    ,CONSTRAINT fk_cpass_t_ord_impegno_evasione_impegno FOREIGN KEY (impegno_id)
    	REFERENCES cpass.cpass_t_impegno(impegno_id)
    	ON DELETE NO ACTION
    	ON UPDATE NO ACTION
    	NOT DEFERRABLE
    ,CONSTRAINT fk_cpass_t_ord_impegno_evasione_impegno_ordine FOREIGN KEY (impegno_ordine_id)
    	REFERENCES cpass.cpass_t_ord_impegno_ordine(impegno_ordine_id)
    	ON DELETE NO ACTION
    	ON UPDATE NO ACTION
    	NOT DEFERRABLE
    ,CONSTRAINT fk_cpass_t_ord_impegno_evasione_causale_sospensione FOREIGN KEY (causale_sospensione_id)
	    REFERENCES cpass.cpass_d_ord_causale_sospensione_evasione(causale_sospensione_id)
	    ON DELETE NO ACTION
	    ON UPDATE NO ACTION
	    NOT DEFERRABLE
 );
 
 COMMENT ON TABLE cpass.cpass_t_ord_impegno_evasione
IS 'UUID namespace: "cpass_t_ord_impegno_evasione"';




CREATE TABLE if not exists  cpass.cpass_t_ord_subimpegno_evasione (
    subimpegno_evasione_id UUID NOT NULL,
    impegno_evasione_id UUID NOT NULL,
    impegno_anno_esercizio INTEGER NOT NULL,
    impegno_anno INTEGER NOT NULL,
    impegno_numero INTEGER NOT NULL,
    subimpegno_anno INTEGER,
    subimpegno_numero INTEGER,
    importo_ripartito NUMERIC(13,5),
    importo_sospeso NUMERIC(13,5),
    importo_liquidato NUMERIC(13,5),
    subimpegno_id UUID NOT NULL,
    subimpegno_ordine_id  UUID NOT NULL,
    data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
    utente_creazione VARCHAR(250) NOT NULL,
    data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
    utente_modifica VARCHAR(250) NOT NULL,
    data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
    utente_cancellazione VARCHAR(250),
    optlock UUID DEFAULT uuid_generate_v4() NOT NULL
    ,CONSTRAINT cpass_t_ord_subimpegno_evasione_pkey PRIMARY KEY(subimpegno_evasione_id)  

    ,CONSTRAINT fk_cpass_t_ord_impegno_evasione_subimpegno FOREIGN KEY (impegno_evasione_id)
          REFERENCES cpass.cpass_t_ord_impegno_evasione(impegno_evasione_id)
          ON DELETE NO ACTION
          ON UPDATE NO ACTION
          NOT DEFERRABLE    
    ,CONSTRAINT fk_cpass_t_ord_subimpegno_evaso_subimpegno FOREIGN KEY (subimpegno_id)
        REFERENCES cpass.cpass_t_subimpegno(subimpegno_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
        NOT DEFERRABLE

    ,CONSTRAINT fk_cpass_t_ord_subimpegno_evaso_ord_subimpegno FOREIGN KEY (subimpegno_ordine_id)
        REFERENCES cpass.cpass_t_ord_subimpegno_ordine(subimpegno_ordine_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
        NOT DEFERRABLE

);


COMMENT ON TABLE cpass.cpass_t_ord_impegno_evasione
IS 'UUID namespace: "cpass_t_ord_subimpegno_evasione"';

ALTER TABLE cpass.cpass_t_ord_impegno_evasione
  DROP COLUMN if exists  sospeso;
  
ALTER TABLE cpass.cpass_t_ord_subimpegno_evasione
  drop COLUMN if EXISTS subimpegno_importo_evaso;

ALTER TABLE cpass.cpass_t_ord_subimpegno_evasione
  drop COLUMN if EXISTS subimpegno_importo_liquidato;
  
ALTER TABLE cpass.cpass_t_ord_subimpegno_evasione
add COLUMN if NOT EXISTS importo_ripartito numeric (13,5);
   
ALTER TABLE cpass.cpass_t_ord_subimpegno_evasione
add COLUMN if NOT EXISTS importo_sospeso numeric (13,5);
   
ALTER TABLE cpass.cpass_t_ord_subimpegno_evasione
add COLUMN if NOT EXISTS importo_liquidato numeric (13,5);

ALTER TABLE cpass.cpass_t_ord_testata_evasione DROP COLUMN if exists causale_sospensione_id;
  
ALTER TABLE cpass.cpass_t_ord_testata_evasione DROP CONSTRAINT if exists fk_cpass_t_ord_testata_evasione_causale_sospensione;

ALTER TABLE cpass.cpass_t_ord_impegno_evasione DROP COLUMN if exists sospensione_causale;

ALTER TABLE cpass.cpass_t_ord_impegno_evasione ADD COLUMN if not exists causale_sospensione_id INTEGER;

ALTER TABLE cpass.cpass_t_ord_impegno_evasione DROP CONSTRAINT fk_cpass_t_ord_impegno_evasione_causale_sospensione;

ALTER TABLE cpass.cpass_t_ord_impegno_evasione ADD CONSTRAINT fk_cpass_t_ord_impegno_evasione_causale_sospensione FOREIGN KEY (causale_sospensione_id) REFERENCES cpass.cpass_d_ord_causale_sospensione_evasione(causale_sospensione_id);
	
ALTER TABLE cpass.CPASS_D_ORD_TIPO_ORDINE ADD COLUMN if not exists flag_trasm_nso boolean default false;



ALTER TABLE cpass.cpass_d_ord_causale_sospensione_evasione ADD COLUMN if not exists ente_id UUID ;

ALTER TABLE cpass.cpass_d_ord_causale_sospensione_evasione DROP CONSTRAINT if exists fk_cpass_d_ord_causale_sospensione_evasione_ente;

ALTER TABLE cpass.cpass_d_ord_causale_sospensione_evasione ADD CONSTRAINT fk_cpass_d_ord_causale_sospensione_evasione_ente FOREIGN KEY (ente_id) REFERENCES cpass.cpass_t_ente(ente_id);

ALTER TABLE cpass.cpass_t_ord_testata_evasione ADD COLUMN if not exists data_invio_contabilita TIMESTAMP ;

ALTER TABLE cpass.cpass_t_elaborazione ADD COLUMN if not exists elaborazione_id_esterno VARCHAR(50) ;

ALTER TABLE cpass.cpass_t_elaborazione DROP COLUMN if exists elaborazione_tipo  ;


CREATE OR REPLACE VIEW cpass.cpass_v_evasione 
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
    cpass_t_ord_testata_evasione.documento_trasporto_id,
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
    cpass_t_ord_destinatario_evasione.stato_el_ordine_id AS  stato_el_ordine_id_destinatario,
    cpass_t_ord_destinatario_evasione.data_cancellazione AS data_cancellazione_destinatario,
    cpass_t_ord_riga_evasione.riga_evasione_id,
    cpass_t_ord_riga_evasione.progressivo AS progressivo_riga,
    cpass_t_ord_riga_evasione.importo_totale,
    cpass_t_ord_riga_evasione.prezzo_unitario,
    cpass_t_ord_riga_evasione.riga_ordine_id,
    cpass_t_ord_riga_evasione.aliquote_iva_id,
    cpass_t_ord_riga_evasione.oggetti_spesa_id,
    cpass_t_ord_riga_evasione.stato_el_ordine_id,
    cpass_t_ord_riga_evasione.listino_fornitore_id,
    cpass_t_ord_riga_evasione.documento_trasporto_riga_id,
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
    cpass_t_ord_subimpegno_evasione.importo_ripartito sub_importo_ripartito,
    cpass_t_ord_subimpegno_evasione.importo_sospeso sub_importo_sospeso,
    cpass_t_ord_subimpegno_evasione.importo_liquidato sub_importo_liquidato,
    cpass_t_ord_subimpegno_evasione.subimpegno_id,
    cpass_t_ord_subimpegno_evasione.subimpegno_ordine_id,
    cpass_t_ord_subimpegno_evasione.data_creazione,
    cpass_t_ord_subimpegno_evasione.data_cancellazione AS data_cancellazione_subimpegno
FROM 
               cpass_t_ord_testata_evasione
          JOIN cpass_t_ord_destinatario_evasione ON cpass_t_ord_testata_evasione.testata_evasione_id = cpass_t_ord_destinatario_evasione.testata_evasione_id
     LEFT JOIN cpass_t_ord_riga_evasione ON cpass_t_ord_destinatario_evasione.destinatario_evasione_id = cpass_t_ord_riga_evasione.destinatario_evasione_id
     LEFT JOIN cpass_t_ord_impegno_evasione ON cpass_t_ord_riga_evasione.riga_evasione_id = cpass_t_ord_impegno_evasione.riga_evasione_id
     
     LEFT JOIN cpass_d_ord_causale_sospensione_evasione ON cpass_t_ord_impegno_evasione.causale_sospensione_id = cpass_d_ord_causale_sospensione_evasione.causale_sospensione_id
     
     LEFT JOIN cpass_t_impegno ON cpass_t_impegno.impegno_id =cpass_t_ord_impegno_evasione.impegno_id
     LEFT JOIN cpass_t_ord_subimpegno_evasione ON cpass_t_ord_impegno_evasione.impegno_evasione_id = cpass_t_ord_subimpegno_evasione.impegno_evasione_id;
  
ALTER TABLE cpass.cpass_t_ord_testata_evasione
  DROP COLUMN if exists data_invio
;
   
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
    data_sospensione
    )
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
        tmp.impegno_anno, tmp.impegno_numero, tmp.subimpegno_anno, tmp.subimpegno_numero, tmp.causale_sospensione_codice, tmp.causale_sospensione_descrizione,tmp.data_sospensione
    ORDER BY tmp.testata_evasione_id, tmp.impegno_anno_esercizio,
        tmp.impegno_anno, tmp.impegno_numero, tmp.subimpegno_anno, tmp.subimpegno_numero
    ) riepilogo;
         
         
----------------------------------------------------------------------------------------------------------------------------------
------------------------------------------DML-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
INSERT INTO cpass.cpass_d_ord_tipo_evasione (tipo_evasione_codice, tipo_evasione_descrizione, utente_creazione, utente_modifica)
SELECT tmp.codice, tmp.descrizione,'SYSTEM', 'SYSTEM'
FROM (values
('MAN','MANUALE'),
('RIC','RICEVUTA DA NSO')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_ord_tipo_evasione ts
  WHERE ts.tipo_evasione_codice = tmp.codice
);

INSERT INTO cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.tipo
FROM (VALUES
('BOZZA','BOZZA','EVASIONE'),
('AUTORIZZATA','AUTORIZZATA','EVASIONE'),
('ANNULLATA','ANNULLATA','EVASIONE'),
('INVIATA','INVIATA','EVASIONE')
) AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_stato ds
	WHERE ds.stato_codice = tmp.codice
	and   ds.stato_tipo = tmp.tipo
);

INSERT INTO cpass.cpass_d_ord_causale_sospensione_evasione (causale_sospensione_codice, causale_sospensione_descrizione, utente_creazione, utente_modifica)
SELECT tmp.codice, tmp.descrizione,'SYSTEM', 'SYSTEM'
FROM (values
('050','QUOTA SOSPESA PER LO 0,50'),
('GEN','CAUSALE GENERICA')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_ord_causale_sospensione_evasione ts
  WHERE ts.causale_sospensione_codice = tmp.codice
);

insert into cpass.cpass_d_stato_el_ordine (stato_codice, stato_descrizione, stato_tipo)
select tmp.codice, tmp.descrizione, tmp.tipo 
from ( values
('DAF','DA FATTURARE','RIGA_EVASIONE'),	
('EPF','PARZIALMENTE FATTURATA','RIGA_EVASIONE'),	
('ETF','TOTALMENTE FATTURATA','RIGA_EVASIONE'),	
('ANN','ANNULLATA','RIGA_EVASIONE'),	
('DAF','DA FATTURARE','DESTINATARIO_EVASIONE'),	
('EPF','PARZIALMENTE FATTURATO','DESTINATARIO_EVASIONE'),	
('ETF','TOTALMENTE FATTURATO','DESTINATARIO_EVASIONE'),	
('ANN','ANNULLATO','DESTINATARIO_EVASIONE')	
)AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato_el_ordine ts
  WHERE ts.stato_codice = tmp.codice
);

update CPASS_D_ORD_TIPO_ORDINE set flag_trasm_nso = true where tipologia_documento_codice in ('SEM','COM');
update CPASS_D_ORD_TIPO_ORDINE set flag_trasm_nso = false where tipologia_documento_codice in ('INT');


insert into cpass.cpass_d_elaborazione_tipo (
  elaborazione_tipo_codice
  ,elaborazione_tipo_descrizione
  ,modulo_codice
)
select 
   tmp.elaborazione_tipo_codice
  ,tmp.elaborazione_tipo_descrizione
  ,tmp.modulo_codice
from( VALUES('INVIO_EVASIONE','INVIO EVASIONE IN CONTABILITA','ORD')) AS tmp(elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo ts
  WHERE ts.elaborazione_tipo_codice = tmp.elaborazione_tipo_codice
);


delete from cpass_d_stato_el_ordine where cpass_d_stato_el_ordine.stato_codice = 'EVX';

insert into cpass.cpass_d_stato_el_ordine (stato_codice, stato_descrizione, stato_tipo)
select tmp.codice, tmp.descrizione, tmp.tipo 
from ( values
('CEP','CHIUSO EVASO PARZIALMENTE','DESTINATARIO_ORDINE'),	
('CEP','CHIUSA EVASA PARZIALMENTE','RIGA_ORDINE'),
('CDE','CHIUSA DA EVADERE','RIGA_ORDINE'),
('CDE','CHIUSO DA EVADERE','DESTINATARIO_ORDINE')
)AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato_el_ordine ts
  WHERE ts.stato_codice = tmp.codice
);

INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo
FROM (VALUES
	('CHIUDI_ORDINE', 'chiusura ordine', 'ORDINE', false, 'B')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );
    
    

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('MODALITA_INVIO_EVASIONE',    'ASINCRONA', 'EVASIONE', '', 'Per salvare idOperazione del invio a contabilita nella tabella Elaborazione', true),
	('SERVIZIO_VERIFICA_EVASIONE', 'FALSE',     'EVASIONE', '', 'Per aggiornamenti dopo invio contabilita',                                    true)
) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass.cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);


INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo
FROM (VALUES
('INS_EVASIONE', 'Inserimento testata evasione', 'EVASIONE', false, 'V'),
('INS_DETT_EVASIONE', 'Inserimento finanziario evasione', 'EVASIONE', false, 'B'),
('MOD_EVASIONE', 'Modifica testata evasione', 'EVASIONE', false, 'B'),
('MOD_DETT_EVASIONE', 'modifica destinatario e finanz evasione', 'EVASIONE', false, 'B'),
('CANC_EVASIONE', 'Cancella evasione', 'EVASIONE', false, 'B'),
('CANC_DETT_EVASIONE', 'Cancella riga, dest e finanz evasione', 'EVASIONE', false, 'B'),
('AUTORIZZA_EVASIONE', 'Autorizza evasione', 'EVASIONE', false, 'B'),
('CONSULTA_EVASIONE', 'Consulta evasione', 'EVASIONE', false, 'V'),
('ANN_EVASIONE', 'Annulla evasione', 'EVASIONE', false, 'B'),
('INVIA_EVASIONE_CONTABILITA', 'Invia evasione in contabilità', 'EVASIONE', false, 'B')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_permesso ds
  WHERE ds.permesso_codice = tmp.codice
);

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('ORDINATORE','INS_EVASIONE'),
('ORDINATORE','INS_DETT_EVASIONE'),
('ORDINATORE','MOD_EVASIONE'),
('ORDINATORE','MOD_DETT_EVASIONE'),
('ORDINATORE','CANC_EVASIONE'),
('ORDINATORE','CANC_DETT_EVASIONE'),
('ORDINATORE','AUTORIZZA_EVASIONE'),
('ORDINATORE','CONSULTA_EVASIONE'),
('ORDINATORE','ANN_EVASIONE'),
('ORDINATORE','INVIA_EVASIONE_CONTABILITA'),
	('ORDINSEMPLICE', 'INS_EVASIONE'),
    ('ORDINSEMPLICE', 'INS_DETT_EVASIONE'),
    ('ORDINSEMPLICE', 'MOD_EVASIONE'),
    ('ORDINSEMPLICE', 'MOD_DETT_EVASIONE'),
    ('ORDINSEMPLICE', 'CANC_EVASIONE'),
    ('ORDINSEMPLICE', 'CANC_DETT_EVASIONE')
    ,('ORDINSEMPLICE', 'CONSULTA_EVASIONE')

) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);


INSERT INTO cpass.cpass_d_ruolo(ruolo_codice, ruolo_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
	('CHIUSURA_ORDINI', 'UTENTE CHE CHIUDE ORDINI')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_ruolo dr
	WHERE dr.ruolo_codice = tmp.codice
);
INSERT INTO cpass_r_ruolo_modulo (ruolo_id, modulo_id)
SELECT dr.ruolo_id, dm.modulo_id
FROM (VALUES
	('CHIUSURA_ORDINI', 'ORD')
) AS tmp(ruolo, modulo)
JOIN cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass_d_modulo dm ON dm.modulo_codice = tmp.modulo
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_r_ruolo_modulo rrm
	WHERE rrm.ruolo_id = dr.ruolo_id
	AND rrm.modulo_id = dm.modulo_id
);

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('CHIUSURA_ORDINI', 'CHIUDI_ORDINE')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

