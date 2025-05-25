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
