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
-- PROD-COTO-01
INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('SOSTITUZIONE_DEST'                 , 'true', true, 'EVASIONE', 'CPASS', 'sostituzione destinatario','COTO')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);


--REPOSITORY_NAME	001272 Comune di Torino
--ID_AOO	
--FORMA_DOC_ORDINI	2
--STATO_EFFICACIA	5
--VITAL_RECORD_CODE	3
--APPKEY	125/-94/31/-97/105/-122/-94/-95/120/52/-24/95/-18/-66/-57/-102
--TITOLARIO_ID	1