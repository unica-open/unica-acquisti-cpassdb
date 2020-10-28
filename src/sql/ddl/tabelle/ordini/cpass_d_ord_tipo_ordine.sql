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
CREATE TABLE         cpass.cpass_d_ord_tipo_ordine (
  tipo_ordine_id SERIAL ,
  tipologia_documento_codice VARCHAR(50) NOT NULL,
  tipologia_documento_descrizione VARCHAR(500) NOT NULL,
  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  optlock UUID NOT NULL DEFAULT uuid_generate_v4(),
  CONSTRAINT cpass_d_ord_tipologia_documento_pkey PRIMARY KEY(tipo_ordine_id)
) ;
