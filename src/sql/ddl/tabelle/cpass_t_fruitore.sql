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
CREATE TABLE cpass.cpass_t_fruitore (
	fruitore_id serial NOT NULL,
	fruitore_codice varchar(50) NOT NULL,
	fruitore_ente_codice_fiscale varchar(16) NOT NULL,
	fruitore_descrizione varchar(200) NULL,
	CONSTRAINT cpass_t_fruitore_pkey PRIMARY KEY (fruitore_id)
);
