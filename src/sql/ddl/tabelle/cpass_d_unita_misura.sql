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
  CREATE TABLE cpass_d_unita_misura
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
    CONSTRAINT cpass_d_unita_misura_pkey PRIMARY KEY(unita_misura_id)	
);
