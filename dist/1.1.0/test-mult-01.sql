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
-- TEST-MULT-01

INSERT INTO cpass.cpass_t_ente (ente_codice,ente_denominazione, ente_codice_fiscale, ente_id, utente_creazione, utente_modifica)
SELECT tmp.codice, tmp.den, tmp.cf, uuid_generate_v5(tun.uuid_namespace_value::uuid, tmp.cf), 'SYSTEM', 'SYSTEM'
FROM (VALUES
  ('CSI','CSI', '01995120019')
) AS tmp(codice, den, cf)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_ente')
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_ente te
  WHERE te.ente_codice = tmp.codice
);

------------------------------------------- cpass_d_tipo_settore --------

INSERT INTO cpass.cpass_d_tipo_settore (tipo_settore_codice, tipo_settore_descrizione, flag_direzione, flag_utilizzabile, ente_id)
SELECT tmp.codice, tmp.descrizione, tmp.flag_direzione, tmp.flag_utilizzabile, te.ente_id
FROM (VALUES
  ('DIR', 'DIREZIONE', true, true, 'CSI')
) AS tmp(codice, descrizione, flag_direzione, flag_utilizzabile, ente)
JOIN cpass.cpass_t_ente te ON te.ente_denominazione = tmp.ente
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_tipo_settore dts
  WHERE dts.tipo_settore_codice = tmp.codice
);

---------------INSERT SETTORI, TIPO DIREZIONE ------------------------------------------
INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, settore_indirizzo,settore_num_civico , settore_localita, settore_provincia, settore_cap, settore_telefono, ente_id, tipo_settore_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, tmp.indirizzo,tmp.num_civico, tmp.localita, tmp.provincia, tmp.cap, tmp.telefono, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM'
FROM (VALUES
	('E23','ACQUISTI E AFFARI CORPORATE','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E22','AMMINISTRAZIONE, FINANZA E CONTROLLO','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E01','ARCHITETTURE, CENTRI DI ECCELLENZA, RICERCA E SVILUPPO','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E05','ATTIVITA'' PRODUTTIVE, AMBIENTE, FPL','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E20','DIREZIONE GENERALE','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E26','DPO','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E60','FACILITY MANAGEMENT','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E03','INFRASTRUTTURE','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E25','INTERNAL AUDIT','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E04','P.A. DIGITALE','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E21','PERSONALE, ORGANIZZAZIONE E COMUNICAZIONE','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E24','PMO STRATEGICO','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E06','SANITA'' DIGITALE','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E02','SERVIZIO CLIENTI','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR'),
	('E07','SVILUPPO ATTIVITA'' NAZIONALI E INTERNAZIONALI','corso Unione Sovietica','216','Torino','TO','10100','011168','CSI','DIR')
) AS tmp(codice, descrizione, indirizzo,num_civico, localita, provincia, cap, telefono, ente, tipo)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_settore')
JOIN cpass.cpass_t_ente te ON te.ente_denominazione = tmp.ente
JOIN cpass.cpass_d_tipo_settore dts ON dts.tipo_settore_codice = tmp.tipo
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore ts
  WHERE ts.settore_codice = tmp.codice
  AND ts.ente_id = te.ente_id
);

INSERT INTO cpass.cpass_t_utente (utente_id, utente_nome, utente_cognome, utente_codice_fiscale, telefono, email, rup, data_creazione, utente_creazione, data_modifica, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.utente_codice_fiscale), tmp.utente_nome, tmp.utente_cognome, tmp.utente_codice_fiscale, tmp.telefono, tmp.email, tmp.rup, now(), 'SYSTEM', now(), 'SYSTEM'
FROM (VALUES
  ('Demo', '21', 'AAAAAA00A11B000J', '000 0000000', 'demo.21@example.com', false)
) AS tmp(utente_nome, utente_cognome, utente_codice_fiscale, telefono, email, rup)
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
	('AAAAAA00A11B000J','E23')
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
	('AAAAAA00A11B000J','E23','DELEGATO_REFP')
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

where riferimento = 'PROVVEDIMENTO' and ambiente = 'STILO' and chiave = 'WSDL_LOCATION';

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('PATH_IMPEGNI_CSV'   , ''   , true,'IMPEGNOEXT', 'IMPEGNOEXT', 'locazione del file csv per aggiornamento impegni','CSI'),
  ('PATH_SUBIMPEGNI_CSV', '', true,'IMPEGNOEXT', 'IMPEGNOEXT', 'locazione del file csv per aggiornamento subimpegni','CSI')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_denominazione = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);
