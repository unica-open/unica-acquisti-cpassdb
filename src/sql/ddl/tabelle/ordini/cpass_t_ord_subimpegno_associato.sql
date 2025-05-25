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
CREATE TABLE cpass.cpass_t_ord_subimpegno_associato (
  subimpegno_associato_id UUID NOT NULL,
  impegno_associato_id UUID NOT NULL,
  subimpegno_id UUID NOT NULL,
  impegno_anno_esercizio  INTEGER NOT NULL,
  impegno_anno INTEGER,
  impegno_numero INTEGER,
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
) 
WITH (oids = false);

COMMENT ON TABLE cpass.cpass_t_ord_subimpegno_associato
IS 'UUID namespace: "cpass_t_ord_subimpegno_associato"';
