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
  CREATE TABLE cpass_d_aliquote_iva
   (	
     aliquote_iva_id SERIAL ,
    , aliquote_iva_codice character varying(50) NOT NULL,
    , aliquote_iva_descrizione character varying(500) NOT NULL,
    , percentuale NUMERIC(5,2),
	, codifica_peppol varchar (10),
	, data_validita_inizio TIMESTAMP NOT NULL 
	, data_validita_fine TIMESTAMP 
	, data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    , utente_creazione CHARACTER VARYING(250) NOT NULL
	, data_modifica TIMESTAMP NOT NULL DEFAULT now()
	, utente_modifica CHARACTER VARYING(250) NOT NULL
	, data_cancellazione TIMESTAMP
	, utente_cancellazione CHARACTER VARYING(250)
	, optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    CONSTRAINT cpass_d_aliquote_iva_pkey PRIMARY KEY(aliquote_iva_id)	 
);
