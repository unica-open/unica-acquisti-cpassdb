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
WHERE ente.ente_denominazione = 'REGIONE PIEMONTE';

INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
    ('WSDL_LOCATION', @value@, 'IMPEGNO', 'SIAC', 'ricerca impegni', true,'REGP')
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

INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
    ('WSDL_LOCATION', @value@, 'DOCUMENTO-SPESA', 'SIAC', 'documento spesa', true,'REGP')
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


INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
    ('WSDL_LOCATION', @value@, 'INVIO-QUOTE-DOCUMENTO', 'SIAC', 'ricerca impegni', true,'REGP'),
    ('WSDL_LOCATION', @value@, 'LEGGI-STATO-ELABORAZIONE-DOCUMENTO', 'SIAC', 'ricerca impegni', true,'REGP')
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

INSERT INTO cpass.cpass_r_ruolo_modulo (ruolo_id, modulo_id, ente_id)
SELECT dr.ruolo_id, dm.modulo_id, te.ente_id
FROM (VALUES
	('ADMIN_ENTE', 'ORD', 'REGP')
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

INSERT INTO cpass.cpass_r_utente_settore (utente_id, settore_id, utente_settore_default)
SELECT tu.utente_id, ts.settore_id, tmp.settore_default
FROM (VALUES
	('BNDNNN74M19L219J','SA0001',true)
)	AS tmp(utente, settore, settore_default)
JOIN cpass.cpass_t_utente tu ON tu.utente_codice_fiscale = tmp.utente
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_r_utente_settore rus
  WHERE rus.utente_id = tu.utente_id
  AND rus.settore_id = ts.settore_id
);

INSERT INTO cpass.cpass_r_ruolo_utente_settore (utente_settore_id, ruolo_id)
SELECT rus.utente_settore_id, dr.ruolo_id
FROM (VALUES
	('BNDNNN74M19L219J','SA0001','ADMIN')
) AS tmp(utente, settore, ruolo)
JOIN cpass.cpass_t_utente tu ON tu.utente_codice_fiscale = tmp.utente
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
JOIN cpass.cpass_r_utente_settore rus ON (rus.utente_id = tu.utente_id AND rus.settore_id = ts.settore_id)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_r_ruolo_utente_settore rrus
  WHERE rrus.utente_settore_id = rus.utente_settore_id
  AND rrus.ruolo_id = dr.ruolo_id
);