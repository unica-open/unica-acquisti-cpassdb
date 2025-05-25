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
-- PROD-RP-01
INSERT INTO cpass.cpass_d_tipo_settore (tipo_settore_codice, tipo_settore_descrizione)
SELECT tmp.tipo_settore_codice, tmp.tipo_settore_descrizione
FROM (VALUES
  ('4','DIREZIONE'),
  ('8','SETTORE'),
  ('21','STRUTTURA STABILE DIRIGENZIALE'),
  ('R1-001','ASSESSORATO'),
  ('R1-002','AREA DI COORDINAMENTO'),
  ('R1-003','GIUNTA'),
  ('R1-004','DIREZIONE'),
  ('R1-005','ORGANO POLITICO'),
  ('R1-006','PROGETTI STRATEGICI DIREZIONALI'),
  ('R1-007','PROGETTI STRATEGICI SETTORIALI'),
  ('R1-008','SETTORE'),
  ('R1-009','STRUTTURA SPECIALE'),
  ('R1-010','STRUTTURA AMMINISTRATIVA'),
  ('R1-011','STRUTTURA FLESSIBILE'),
  ('R1-012','STRUTTURA FLESSIBILE DIREZIONALE'),
  ('R1-013','STRUTTURA FLESSIBILE INTERDIREZIONALE'),
  ('R1-014','UFFICIO DI COMUNICAZIONE'),
  ('R1-015','ALTRO'),
  ('R1-016','STRUTTURA FLESSIBILE INTERD. (NO INTERFACCE)'),
  ('R1-020','SETTORE SC MAGGIOR RILEVANZA'),
  ('R1-021','SETTORE SC MEDIA RILEVANZA'),
  ('R1-022','SETTORE SC BASE'),
  ('R1-023','STRUTTURA TEMPORANEA'),
  ('R1-024','STRUTTURA STABILE DIRIGENZIALE')
) AS tmp(tipo_settore_codice, tipo_settore_descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_tipo_settore current
  WHERE current.tipo_settore_codice = tmp.tipo_settore_codice
);


/* inserire settore prima di inserire gli utenti, inserimento settori sospeso per ora
INSERT INTO cpass.cpass_t_utente (utente_id, utente_nome, utente_cognome, utente_codice_fiscale, telefono, email, rup, data_creazione, utente_creazione, data_modifica, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.utente_codice_fiscale), tmp.utente_nome, tmp.utente_cognome, tmp.utente_codice_fiscale, tmp.telefono, NULL, tmp.rup, now(), 'SYSTEM', now(), 'SYSTEM'
FROM (VALUES
	('CPNCLD71M25L219I', 'CAPONE', 'CLAUDIO', '0113168',false),
	('TRTSLV63L42L219B', 'TORTA', 'SILVIA', '0113168',false),
	('TLLNRT69E56D122C', 'TALLARICO', 'ANNA RITA', '0113168',false),
	('TRNDNL82R65D810B', 'TARANTINO', 'DANIELA', '0113168',false)
) AS tmp(utente_codice_fiscale,utente_cognome,utente_nome, telefono, rup)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_utente')
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_utente current
  WHERE current.utente_codice_fiscale = tmp.utente_codice_fiscale
);

-------------------------UTENTE_SETTORE-------------------------------

INSERT INTO cpass.cpass_r_utente_settore (utente_id, settore_id)
SELECT tu.utente_id, ts.settore_id
FROM (VALUES
	('CPNCLD71M25L219I','?'),
	('TRTSLV63L42L219B','?'),
	('TLLNRT69E56D122C','?'),
	('TRNDNL82R65D810B','?')
)	AS tmp(utente, settore)
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
	('CPNCLD71M25L219I','?','ADMIN'),
	('TRTSLV63L42L219B','?','ADMIN'),
	('TLLNRT69E56D122C','?','ADMIN'),
	('TRNDNL82R65D810B','?','ADMIN')
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
*/