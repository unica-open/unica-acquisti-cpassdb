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

UPDATE cpass.cpass_t_ufficio SET ente_id=ente.ente_id
FROM (SELECT ente_id,ente_denominazione  FROM  cpass_t_ente) AS ente
WHERE ente.ente_denominazione = 'ENTE_TEST';

ALTER TABLE cpass.cpass_t_ufficio ALTER COLUMN ente_id SET NOT NULL;

INSERT INTO cpass.cpass_r_ruolo_modulo (ruolo_id, modulo_id, ente_id)
SELECT dr.ruolo_id, dm.modulo_id, te.ente_id
FROM (VALUES
	('GESTORE_STRUTTURA', 'BO', 'REGP')
) AS tmp(ruolo, modulo, ente)
JOIN cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass_d_modulo dm ON dm.modulo_codice = tmp.modulo
JOIN cpass_t_ente te ON te.ente_codice = tmp.ente
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_r_ruolo_modulo rrm
	WHERE rrm.ruolo_id = dr.ruolo_id
	AND rrm.modulo_id = dm.modulo_id
	and rrm.ente_id = te.ente_id
);
INSERT INTO cpass.CPASS_T_SCHEDULAZIONE_BATCH (ente_id ,ente_codice,nome_job,attivazione,note)
SELECT te.ente_id, tmp.ente_codice, tmp.nome_job, tmp.attivazione, tmp.note
FROM (VALUES
      ('CSI','CSI','AGG_STRUTTURA',FALSE,'batch aggiornamento struttura organizzativa')
) AS tmp (ente ,ente_codice,nome_job,attivazione,note)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.CPASS_T_SCHEDULAZIONE_BATCH current
  WHERE current.ente_codice = tmp.ente_codice
  AND current.nome_job = tmp.nome_job
);

INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
    ('NUMERAZIONE_ATTI_UNIVOCA', 'false', 'IMPEGNO', 'SIAC', 'Per interrogazione IMPEGNO', true,'CSI')
) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata,ente)
JOIN cpass_t_ente te ON te.ente_codice = tmp.ente
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
    and tp.ente_id = te.ente_id
);