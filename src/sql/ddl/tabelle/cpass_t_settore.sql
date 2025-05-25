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

CREATE TABLE cpass.cpass_t_settore (
  settore_id UUID NOT NULL,
  settore_codice VARCHAR(50) NOT NULL,
  settore_descrizione VARCHAR(500) NOT NULL,
  settore_indirizzo VARCHAR(500) NOT NULL,
  settore_localita VARCHAR(500) NOT NULL,
  settore_provincia VARCHAR(2) NOT NULL,
  settore_cap VARCHAR(5) NOT NULL,
  settore_telefono VARCHAR(50) NOT NULL,
  settore_num_civico VARCHAR(20),
  settore_contatto VARCHAR(200),
  settore_email VARCHAR(50),
  settore_padre_id UUID,
  ente_id UUID NOT NULL,
  tipo_settore_id INTEGER NOT NULL,
  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  optlock UUID DEFAULT uuid_generate_v4() NOT NULL,
  CONSTRAINT cpass_t_settore_pkey PRIMARY KEY(settore_id),
  CONSTRAINT fk_cpass_t_settore_d_tipo_settore FOREIGN KEY (tipo_settore_id)
    REFERENCES cpass.cpass_d_tipo_settore(tipo_settore_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_t_settore_settore FOREIGN KEY (settore_padre_id)
    REFERENCES cpass.cpass_t_settore(settore_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_t_settore_t_ente FOREIGN KEY (ente_id)
    REFERENCES cpass.cpass_t_ente(ente_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) ;


