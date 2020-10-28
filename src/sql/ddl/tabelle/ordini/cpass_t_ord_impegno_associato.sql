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
CREATE TABLE cpass.cpass_t_ord_impegno_associato (
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
) 
WITH (oids = false);

COMMENT ON TABLE cpass.cpass_t_ord_impegno_associato
IS 'UUID namespace: "cpass_t_ord_impegno_associato"';
