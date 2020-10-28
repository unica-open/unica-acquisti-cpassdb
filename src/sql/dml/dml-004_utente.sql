---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2020 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2020 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
---
INSERT INTO cpass.cpass_r_utente_settore (utente_id, settore_id, utente_rup_id)
SELECT tu.utente_id, ts.settore_id, tur.utente_id
FROM (VALUES
	('AAAAAA00B77B000F', 'SA0001', 'AAAAAA00B77B000F'),
	('AAAAAA00B77B000F', 'A11000', 'AAAAAA00B77B000F'),
	('AAAAAA00A11B000J', 'SA0001', 'AAAAAA00A11B000J'),
	('AAAAAA00A11B000J', 'A11000', 'AAAAAA00A11B000J'),
	('AAAAAA00A11C000K', 'SA0001', 'AAAAAA00A11C000K'),
	('AAAAAA00A11C000K', 'A11000', 'AAAAAA00A11C000K')
) AS tmp(utente, settore, rup)
JOIN cpass.cpass_t_utente tu ON tu.utente_codice_fiscale = tmp.utente
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
JOIN cpass.cpass_t_utente tur ON tur.utente_codice_fiscale = tmp.rup
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_utente_settore rus
	WHERE rus.utente_id = tu.utente_id
	AND rus.settore_id = ts.settore_id
);

INSERT INTO cpass.cpass_r_ruolo_utente_settore (utente_settore_id, ruolo_id)
SELECT rus.utente_settore_id, dr.ruolo_id
FROM (VALUES
	('AAAAAA00B77B000F', 'SA0001', 'RUP'),
	('AAAAAA00B77B000F', 'A11000', 'OPPROG'),
	('AAAAAA00A11B000J', 'SA0001', 'RUP'),
	('AAAAAA00A11B000J', 'A11000', 'OPPROG'),
	('AAAAAA00A11C000K', 'SA0001', 'RUP'),
	('AAAAAA00A11C000K', 'A11000', 'OPPROG')
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

INSERT INTO cpass.cpass_r_ruolo_modulo (ruolo_id, modulo_id)
SELECT dr.ruolo_id, dm.modulo_id
FROM (VALUES
	('RUP', 'PBA'),
	('REFP', 'PBA'),
	('OPPROC', 'PBA'),
	('OPPROG', 'PBA')
) AS tmp(ruolo, modulo)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_modulo dm ON dm.modulo_codice = tmp.modulo
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_modulo rrm
	WHERE rrm.ruolo_id = dr.ruolo_id
	AND rrm.modulo_id = dm.modulo_id
);

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('RUP', 'INS_INTERVENTO'),
	('RUP', 'ANN_INTERVENTO_APPROV'),
	('RUP', 'ANN_INTERVENTO_BOZZA'),
	('RUP', 'APP_INTERVENTO'),
	('RUP', 'STAMPA_INTERVENTO'),
	('REFP', 'ANN_INTERVENTO_BOZZA'),
	('REFP', 'ANN_INTERVENTO_APPROV'),
	('REFP', 'STAMPA_INTERVENTO'),
	('OPPROC', 'INS_INTERVENTO'),
	('OPPROC', 'ANN_INTERVENTO_BOZZA'),
	('OPPROC', 'STAMPA_INTERVENTO')
	
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

INSERT INTO cpass.cpass_t_comunicazione (comunicazione_tipo, comunicazione_testo, comunicazione_data_inizio, comunicazione_data_fine, utente_creazione, utente_modifica)
SELECT tmp.tipo, tmp.testo, to_timestamp('YYYY-MM-DD HH24:MI:SS', tmp.di), null, 'SYSTEM', 'SYSTEM'
FROM (VALUES
	('S', '<strong>Mercoled&igrave; 18/12/2019 ore 08.00</strong><div>Per manutenzione programmata &egrave; prevista l''interruzione del servizio.</div>', '2019-12-26 00:00:00'),
	('S', '<strong>Mercoled&igrave; 25/12/2019 ore 08.00</strong><div>Per manutenzione programmata &egrave; prevista l''interruzione del servizio.</div>', '2019-12-24 00:00:00')
) AS tmp(tipo, testo, di)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_comunicazione tc
	WHERE tc.comunicazione_data_inizio = to_timestamp('YYYY-MM-DD HH24:MI:SS', tmp.di)
	AND tc.comunicazione_testo = tmp.testo
);

