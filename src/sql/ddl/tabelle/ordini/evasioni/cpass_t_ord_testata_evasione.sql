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
CREATE TABLE if not exists  cpass.cpass_t_ord_testata_evasione (
  testata_evasione_id UUID NOT NULL,
  evasione_anno INTEGER NOT NULL,
  evasione_numero INTEGER NOT NULL,
  fornitore_id UUID NOT NULL,
  data_inserimento TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  settore_competente_id  UUID NOT NULL,
  stato_id INTEGER,
  totale_con_iva NUMERIC(13,5),
  utente_compilatore_id UUID NOT NULL,
  descrizione VARCHAR(150) NOT NULL,
  data_conferma TIMESTAMP WITHOUT TIME ZONE,
  data_ripartizione TIMESTAMP WITHOUT TIME ZONE,
  data_invio_contabilita TIMESTAMP WITHOUT TIME ZONE,
  data_autorizzazione TIMESTAMP WITHOUT TIME ZONE, 
  fattura_anno INTEGER,
  fattura_numero VARCHAR(200),
  fattura_tipo VARCHAR(10),
  fattura_codice VARCHAR(50),   --??fattuira codice beneficiario?
  fattura_protocollo_anno INTEGER NOT NULL,
  fattura_protocollo_numero INTEGER NOT NULL,
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

);
 COMMENT ON TABLE cpass.cpass_t_ord_testata_evasione
IS 'UUID namespace: "cpass_t_ord_testata_evasione"';
