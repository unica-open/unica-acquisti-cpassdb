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
-- PROD-MULT-01

-- DELETE EXAMPLE DATA
/*delete from cpass_r_utente_rup_settore;
delete from cpass.cpass_r_ruolo_utente_settore;
delete from cpass.cpass_r_utente_settore;
delete from cpass.cpass_r_ufficio_settore;
delete from cpass.cpass_t_ufficio;
delete from cpass.cpass_t_settore_indirizzo;
delete from cpass.cpass_t_settore;
delete from cpass.cpass_t_utente;
delete from cpass.cpass_t_ente;*/

INSERT INTO cpass.cpass_t_ente (ente_codice,ente_denominazione, ente_codice_fiscale, ente_id, utente_creazione, utente_modifica)
SELECT tmp.codice, tmp.den, tmp.cf, uuid_generate_v5(tun.uuid_namespace_value::uuid, tmp.cf), 'SYSTEM', 'SYSTEM'
FROM (VALUES
  ('CSI','CSI PIEMONTE', '01995120019')
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

---------------UTENTE-----------------------------------
INSERT INTO cpass.cpass_t_utente (utente_id, utente_nome, utente_cognome, utente_codice_fiscale, telefono, email, rup, data_creazione, utente_creazione, data_modifica, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.utente_codice_fiscale), tmp.utente_nome, tmp.utente_cognome, tmp.utente_codice_fiscale, tmp.telefono, NULL, tmp.rup, now(), 'SYSTEM', now(), 'SYSTEM'
FROM (VALUES
	('BRBFRZ64A01L219J', 'BARBERO', 'FABRIZIO', '0113168',true),
	('CGGNNE65M12A182Q', 'CAGGIATI', 'ENNIO', '0113168',true),
	('FRRFNC60A27B041C', 'FERRARA', 'FRANCO', '0113168',true),
	('FTTPLA56R01L219A', 'FOIETTA', 'PAOLO', '0113168',true),
	('GHSNNL72A10L219I', 'GHISAURA', 'ANTONELLO', '0113168',true),
	('GLOFNC71D05B791Z', 'GOLA', 'FRANCO', '0113168',true),
	('GLZGGS55R25Z614X', 'GOLZIO', 'GIORGIO OSVALDO', '0113168',true),
	('GVGCRL61H58D205U', 'GAVEGLIO', 'CARLA ELVIRA', '0113168',true),
	('LSTSFN62S10L219T', 'LISTA', 'STEFANO', '0113168',true),
	('RBNGNN59D03A662A', 'RUBINO', 'GIOVANNI', '0113168',true),
	('RFLBRN57T25L219W', 'ORIFALCO', 'BRUNO', '0113168',true),
	('TVLPLA59P54L219F', 'TAVELLA', 'PAOLA', '0113168',true),
	('MCHRRT69L24E379D', 'MICHIELETTO', 'ROBERTO', '0113168',false),
	('SMTJLU74R58Z152D', 'SEMIATKOVA', 'JULIA', '0113168',false),
	('CPNCLD71M25L219I', 'CAPONE', 'CLAUDIO', '0113168',false),
	('TRTSLV63L42L219B', 'TORTA', 'SILVIA', '0113168',false),
	('TLLNRT69E56D122C', 'TALLARICO', 'ANNA RITA', '0113168',false),
	('TRNDNL82R65D810B', 'TARANTINO', 'DANIELA', '0113168',false),
	('STRLSS92R24G317X', 'STRUZZO', 'ALESSIO', '0113168',false)
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
	('BRBFRZ64A01L219J','E01'),
	('CGGNNE65M12A182Q','E23'),
	('FRRFNC60A27B041C','E22'),
	('FTTPLA56R01L219A','E23'),
	('GHSNNL72A10L219I','E05'),
	('GLOFNC71D05B791Z','E04'),
	('GLZGGS55R25Z614X','E60'),
	('GVGCRL61H58D205U','E06'),
	('LSTSFN62S10L219T','E03'),
	('RBNGNN59D03A662A','E21'),
	('RFLBRN57T25L219W','E60'),
	('TVLPLA59P54L219F','E24'),
	('MCHRRT69L24E379D','E23'),
	('SMTJLU74R58Z152D','E23'),
	('CPNCLD71M25L219I','E23'),
	('TRTSLV63L42L219B','E23'),
	('TLLNRT69E56D122C','E23'),
	('TRNDNL82R65D810B','E23'),
	('STRLSS92R24G317X','E23')
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
	('BRBFRZ64A01L219J','E01','RUP'),
	('CGGNNE65M12A182Q','E23','RUP'),
	('FRRFNC60A27B041C','E22','RUP'),
	('FTTPLA56R01L219A','E23','RUP'),
	('GHSNNL72A10L219I','E05','RUP'),
	('GLOFNC71D05B791Z','E04','RUP'),
	('GLZGGS55R25Z614X','E60','RUP'),
	('GVGCRL61H58D205U','E06','RUP'),
	('LSTSFN62S10L219T','E03','RUP'),
	('RBNGNN59D03A662A','E21','RUP'),
	('RFLBRN57T25L219W','E60','RUP'),
	('TVLPLA59P54L219F','E24','RUP'),
	('MCHRRT69L24E379D','E23','DELEGATO_REFP'),
	('SMTJLU74R58Z152D','E23','REFP'),
	('CPNCLD71M25L219I','E23','ADMIN'),
	('TRTSLV63L42L219B','E23','ADMIN'),
	('TLLNRT69E56D122C','E23','ADMIN'),
	('TRNDNL82R65D810B','E23','ADMIN'),
	('STRLSS92R24G317X','E23','ADMIN')
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

-- cpass_r_utente_rup_settore
INSERT INTO cpass.cpass_r_utente_rup_settore (utente_id, settore_id)
SELECT tu.utente_id, ts.settore_id
FROM (VALUES
	('BRBFRZ64A01L219J','E01'),
	('CGGNNE65M12A182Q','E23'),
	('FRRFNC60A27B041C','E22'),
	('FTTPLA56R01L219A','E23'),
	('GHSNNL72A10L219I','E05'),
	('GLOFNC71D05B791Z','E04'),
	('GLZGGS55R25Z614X','E60'),
	('GVGCRL61H58D205U','E06'),
	('LSTSFN62S10L219T','E03'),
	('RBNGNN59D03A662A','E21'),
	('RFLBRN57T25L219W','E60'),
	('TVLPLA59P54L219F','E24')
)AS tmp(utente, settore)
JOIN cpass.cpass_t_utente tu ON tu.utente_codice_fiscale = tmp.utente
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_r_utente_rup_settore rus
  WHERE rus.utente_id = tu.utente_id
  AND rus.settore_id = ts.settore_id
);

-- set cpass_t_parametro
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