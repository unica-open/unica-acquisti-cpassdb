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
CREATE TABLE cpass.cpass_d_ord_stato_nso (
    stato_nso_id SERIAL ,
    stato_nso_codice character varying(50) NOT NULL,
    stato_nso_descrizione character varying(500) NOT NULL,
	stato_nso_tipo character varying(200) NOT NULL,
    CONSTRAINT cpass_d_ord_stato_nso_pkey PRIMARY KEY(stato_nso_id)
);
