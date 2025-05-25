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
update cpass.cpass_d_oggetti_spesa set ente_id = (select ente_id from cpass_t_ente where cpass_t_ente.ente_codice = 'CSI');
update cpass.cpass_t_progressivo set ente_id = (select ente_id from cpass_t_ente where cpass_t_ente.ente_codice = 'CSI');
ALTER TABLE IF EXISTS cpass.cpass_t_progressivo DROP CONSTRAINT IF EXISTS cpass_t_progressivo_pkey;
ALTER TABLE IF EXISTS cpass.cpass_t_progressivo ADD CONSTRAINT cpass_t_progressivo_pkey PRIMARY KEY(progressivo_tipo, progressivo_codice, ente_id);

