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

delete from cpass.cpass_t_parametro where chiave in ('INTEGRAZIONE_NSO','NSO_UNICO_DESTINATARIO') and ambiente <> 'NOTIER';
INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('INTEGRAZIONE_NSO', 'false', true, 'NSO', 'NOTIER', 'indica se il sistema si integra con NSO','CSI'),
  ('NSO_UNICO_DESTINATARIO', 'true', true, 'NSO', 'NOTIER', 'indica se il sistema si integra con NSO','CSI')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);

UPDATE cpass.cpass_t_ente SET path_logo='/img/logocsi.png', link='https://www.csipiemonte.it/web/'
where ente_codice ='CSI';

