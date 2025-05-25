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
CREATE TABLE cpass.cpass_t_ord_testata_ordine (
  testata_ordine_id UUID ,
  tipo_ordine_id INTEGER NOT NULL,
  ordine_anno INTEGER NOT NULL,
  ordine_numero INTEGER NOT NULL,
  fornitore_id UUID NOT NULL,
  
  --appalto VARCHAR(3) NOT NULL,
  --numero_appalto VARCHAR(30),
  numero_procedura  VARCHAR(30),
  tipo_procedura_id INTEGER NOT NULL
  
  data_emissione TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  data_conferma TIMESTAMP WITHOUT TIME ZONE,
  data_autorizzazione TIMESTAMP WITHOUT TIME ZONE,
  
  totale_no_iva NUMERIC(13,5),
  totale_con_iva NUMERIC(13,5),
  descrizione_acquisto VARCHAR(150) NOT NULL,
  consegna_riferimento VARCHAR(200),
  consegna_data_da TIMESTAMP WITHOUT TIME ZONE,
  consegna_data_a TIMESTAMP WITHOUT TIME ZONE,
  consegna_indirizzo VARCHAR(50),
  consegna_cap VARCHAR(5),
  consegna_localita VARCHAR(50),
  provvedimento_anno INTEGER,
  provvedimento_numero VARCHAR(10),
  lotto_anno INTEGER,
  lotto_numero INTEGER,  
  --data_invio_nso TIMESTAMP WITHOUT TIME ZONE,
  stato_nso_id INTEGER,
  utente_compilatore_id UUID NOT NULL,
  settore_emittente_id UUID NOT NULL,
  ufficio_id INTEGER ,
  stato_id INTEGER,
  note VARCHAR(4000),
  tipo_acquisto_id INTEGER,
  data_scadenza TIMESTAMP WITHOUT TIME ZONE,
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

ALTER TABLE  cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_d_stato FOREIGN KEY (stato_id) REFERENCES cpass.cpass_d_stato (stato_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE  cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_t_settore FOREIGN KEY (settore_emittente_id) REFERENCES cpass.cpass_t_settore (settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE  cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_d_ord_tipo_ordine FOREIGN KEY (tipo_ordine_id) REFERENCES cpass.cpass_d_ord_tipo_ordine (tipo_ordine_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE  cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_t_ufficio FOREIGN KEY (ufficio_id) REFERENCES cpass.cpass_t_ufficio (ufficio_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE  cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_tipo_procedura FOREIGN KEY (tipo_procedura_id) REFERENCES cpass.cpass_d_ord_tipo_procedura (tipo_procedura_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE  cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_fornitore FOREIGN KEY (fornitore_id) REFERENCES cpass.cpass_t_fornitore (fornitore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE  cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT cpass_t_ord_testata_ordine_anno_numero_settore_unique UNIQUE (ordine_anno,ordine_numero,settore_emittente_id);

ALTER TABLE ONLY cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_t_utente FOREIGN KEY (utente_compilatore_id) REFERENCES cpass.cpass_t_utente (utente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT cpass_t_ord_tipo_acquisto_fk FOREIGN KEY (tipo_acquisto_id) REFERENCES cpass.cpass_d_pba_settore_interventi (settore_interventi_id);
