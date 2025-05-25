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

update cpass.cpass_d_oggetti_spesa set ente_id = (select ente_id from cpass_t_ente where cpass_t_ente.ente_codice = 'REGP');
update cpass.cpass_t_progressivo set ente_id = (select ente_id from cpass_t_ente where cpass_t_ente.ente_codice = 'REGP');
ALTER TABLE IF EXISTS cpass.cpass_t_progressivo DROP CONSTRAINT IF EXISTS cpass_t_progressivo_pkey;
ALTER TABLE IF EXISTS cpass.cpass_t_progressivo ADD CONSTRAINT cpass_t_progressivo_pkey PRIMARY KEY(progressivo_tipo, progressivo_codice, ente_id);


-- configurazione utente / ruolo / settore
update cpass.cpass_r_utente_settore 
set data_validita_fine = now()
where utente_id = (select tu.utente_id from cpass.cpass_t_utente tu where tu.utente_codice_fiscale = 'AAAAAA00A11B000J')
and settore_id = (select ts.settore_id from cpass.cpass_t_settore ts where ts.settore_codice = 'A15000')
and data_validita_fine is null;

update cpass.cpass_r_ruolo_utente_settore 
set data_validita_fine = now()
where utente_settore_id in (select utente_settore_id from cpass.cpass_r_utente_settore crus where data_validita_fine is not null)
and data_validita_fine is null;

update cpass.cpass_t_settore set data_cancellazione =  (now() - INTERVAL '1 day'), utente_cancellazione = 'SYSTEM' where settore_codice = 'A15000' and data_cancellazione is null;


INSERT INTO cpass.cpass_r_utente_settore (utente_id, settore_id)
SELECT tu.utente_id, ts.settore_id
FROM (VALUES
	('AAAAAA00A11B000J','A1500A')
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
	('AAAAAA00A11B000J','A1500A','VALIDATORE_RMS'),
	('AAAAAA00A11B000J','A1500A','RICHIEDENTE_RMS')
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

INSERT INTO cpass.cpass_t_progressivo (progressivo_tipo, progressivo_codice, progressivo_numero)
SELECT tmp.progressivo_tipo, tmp.progressivo_codice, tmp.progressivo_numero
FROM (VALUES
  ('RMS.TESTATA','REGP-2021',0)
) AS tmp(progressivo_tipo, progressivo_codice,progressivo_numero)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_progressivo current
  WHERE current.progressivo_tipo = tmp.progressivo_tipo
  	AND current.progressivo_codice = tmp.progressivo_codice
);

INSERT INTO cpass.cpass_d_oggetti_spesa (	
	oggetti_spesa_codice,
	oggetti_spesa_descrizione,
	unita_misura_id,
	cpv_id,
	prezzo_unitario,
	data_validita_inizio,
	data_creazione,
	utente_creazione,
	utente_modifica,
	generico
)
SELECT tmp.codice, tmp.descrizione, ui.unita_misura_id, cpv.cpv_id, tmp.prezzo_unitario, now(),now(),'SYSTEM','SYSTEM',tmp.generico
FROM (VALUES
  ('999999','Oggetto generico per materiale ufficio','C62','30000000-9',0,true)
) AS tmp (codice, descrizione, unita_misura, cpv, prezzo_unitario, generico)
join cpass_d_unita_misura ui on ( ui.unita_misura_codice = tmp.unita_misura)
join cpass_d_cpv cpv on (cpv_codice = tmp.cpv)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_oggetti_spesa current
  WHERE current.oggetti_spesa_codice = tmp.codice
);

