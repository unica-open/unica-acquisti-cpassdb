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
CREATE TABLE cpass.cpass_t_servizio (
	servizio_id serial NOT NULL,
	servizio_codice varchar(50) not NULL,
	servizio_descrizione varchar(200) NULL,
	CONSTRAINT cpass_t_servizio_pkey PRIMARY KEY (servizio_id)
);