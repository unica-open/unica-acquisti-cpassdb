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
CREATE TABLE cpass.cpass_d_ord_tipo_procedura (
    tipo_procedura_id SERIAL ,
    tipo_procedura_codice character varying(50) NOT NULL,
    tipo_procedura_descrizione character varying(500) NOT NULL,
    data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
    utente_creazione VARCHAR(250) NOT NULL,
    data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
    utente_modifica VARCHAR(250) NOT NULL,
    data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
    utente_cancellazione VARCHAR(250),
	optlock UUID NOT NULL DEFAULT uuid_generate_v4(),
    CONSTRAINT cpass_d_ord_tipo_procedura_pkey PRIMARY KEY(tipo_procedura_id)
);
