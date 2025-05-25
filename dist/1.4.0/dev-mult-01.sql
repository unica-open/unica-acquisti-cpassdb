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
INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('UTENTE_BATCH', 'AAAAAA00A11B000J', true, 'BATCH', 'BATCH', 'utenza identificata come batch','CSI')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);
INSERT INTO cpass.CPASS_T_SCHEDULAZIONE_BATCH (ente_id ,ente_codice,nome_job,attivazione,note)
SELECT te.ente_id, tmp.ente_codice, tmp.nome_job, tmp.attivazione, tmp.note
FROM (VALUES
   ('CSI','CSI','VERIFICA_INVIO_CONTABILITA',FALSE,'batch verifica invio contabilita')
  ,('CSI','CSI','AGGIORNAMENTO_IMPEGNI',FALSE,'batch aggiornamento impegni')
  ,('CSI','CSI','DDT',FALSE,'batch documento di trasporto')
  ,('CSI','CSI','RECUPERO_NOTIFICA_NSO',FALSE,'batch notifica nso')
  ,('CSI','CSI','SMISTATORE',FALSE,'batch smistatore rms')
) AS tmp (ente ,ente_codice,nome_job,attivazione,note)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.CPASS_T_SCHEDULAZIONE_BATCH current
  WHERE current.ente_codice = tmp.ente_codice
  AND current.nome_job = tmp.nome_job
);