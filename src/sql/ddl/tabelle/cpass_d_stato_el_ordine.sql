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
CREATE TABLE cpass.cpass_d_stato_el_ordine (
    stato_el_ordine_id SERIAL ,
    stato_codice VARCHAR(50) NOT NULL,
    stato_descrizione VARCHAR(500) NOT NULL,
    stato_tipo VARCHAR(50) NOT NULL
     CONSTRAINT cpass_d_stato_el_ordine_pkey PRIMARY KEY(stato_el_ordine_id)
);
