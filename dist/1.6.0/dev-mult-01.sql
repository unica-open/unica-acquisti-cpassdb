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
UPDATE cpass_d_provvedimento_tipo SET ente_id=ente.ente_id
FROM (SELECT ente_id,ente_denominazione  FROM  cpass_t_ente) AS ente
WHERE ente.ente_denominazione = 'ENTE_TEST';

ALTER TABLE cpass.cpass_d_provvedimento_tipo ALTER COLUMN ente_id SET NOT NULL;