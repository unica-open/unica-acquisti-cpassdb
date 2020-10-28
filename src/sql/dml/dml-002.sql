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
-- RISORSE
INSERT INTO cpass.cpass_d_risorsa(risorsa_codice, risorsa_descrizione, risorsa_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.tipo
FROM (VALUES
	('1', 'risorse derivate da entrate aventi destinazione vincolata per legge', 'BILANCIO'),
	('2', 'risorse derivate da entrate acquisite mediante contrazione di mutuo', 'BILANCIO'),
	('3', 'risorse acquisite mediante apporti di capitali privati', 'BILANCIO'),
	('5', 'finanziamenti acquisibili ai sensi dell''articolo 3 del decreto-legge 31 ottobre 1990, n. 310, convertito con modificazioni dalla legge 22 dicembre 1990, n. 403', 'BILANCIO'),
	('4', 'stanziamenti di bilancio', 'BILANCIO'),
	('6', 'risorse derivanti da trasferimento di immobili', 'BILANCIO'),
	('7', 'altro', 'BILANCIO'),
	('1', 'finanza di progetto', 'CAPITALE PRIVATO'),
	('2', 'concessione di forniture e servizi', 'CAPITALE PRIVATO'),
	('3', 'sponsorizzazione', 'CAPITALE PRIVATO'),
	('4', 'societa'' partecipate o di scopo', 'CAPITALE PRIVATO'),
	('5', 'locazione finananziaria', 'CAPITALE PRIVATO'),
	('6', 'contratto di disponibilita''', 'CAPITALE PRIVATO'),
	('9', 'altro', 'CAPITALE PRIVATO')
) AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_risorsa dr
	WHERE dr.risorsa_codice = tmp.codice
	AND dr.risorsa_tipo = tmp.tipo
);

-- CODICI AUSA , per ora riportiamo solo 3 codici, da verificare con CSI/Ente committente quali codici riportare
INSERT INTO cpass.cpass_d_ausa (ausa_codice, ausa_descrizione, ausa_codice_fiscale)
SELECT tmp.codice, tmp.descrizione, tmp.cf
FROM (VALUES
	('0000236482', 'SOCIETA'' DI COMMITTENZA REGIONE PIEMONTE S.P.A. SIGLABILE S.C.R. - PIEMONTE S.P.A.', '9740180014'),
	('0000168808', 'COMUNE DI TORINO', '514490010'),
	('0000193155', 'CITTA'' METROPOLITANA DI TORINO', '1907990012')
) AS tmp(codice, descrizione, cf)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_ausa da
	WHERE da.ausa_codice = tmp.codice
);

-- cpass_d_acquisto_variato
INSERT INTO cpass.cpass_d_acquisto_variato(acquisto_variato_codice, acquisto_variato_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
	('1', 'modifica ex art.7 comma 8 lettera b)'),
	('2', 'modifica ex art.7 comma 8 lettera c)'),
	('3', 'modifica ex art.7 comma 8 lettera d)'),
	('4', 'modifica ex art.7 comma 8 lettera e)'),
	('5', 'modifica ex art.7 comma 9')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_acquisto_variato dav
	WHERE dav.acquisto_variato_codice = tmp.codice
);

-- moduli
INSERT INTO cpass.cpass_d_modulo (modulo_codice, modulo_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
	('PBA', 'Programmazione Biennale Acquisti'),
	('ORD', 'Approvvigionamenti')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_modulo dm
	WHERE dm.modulo_codice = tmp.codice
);

--- tipo ricompreso
INSERT INTO cpass.cpass_d_ricompreso_tipo (ricompreso_tipo_codice, ricompreso_tipo_descrizione, ricompreso_tipo_cui_obbligatorio)
SELECT tmp.codice, tmp.descrizione, tmp.flag
FROM (VALUES
	('1', 'no', false),
	('2', 'si', true),
	('3', 'si, CUI non ancora attribuito', false),
	('4', 'si, interventi o acquisti diversi', false)
) AS tmp(codice, descrizione, flag)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_ricompreso_tipo drt
	WHERE drt.ricompreso_tipo_codice = tmp.codice
);

-- ruoli
INSERT INTO cpass.cpass_d_ruolo(ruolo_codice, ruolo_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
	('REFP', 'REFERENTE DI PROGRAMMA'),
	('RUP', 'RESPONSABILE UNICO PROCEDIMENTO'),
	('OPPROC', 'OPERATORE PROCEDIMENTO'),
	('OPPROG','OPERATORE PROGRAMMA')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_ruolo dr
	WHERE dr.ruolo_codice = tmp.codice
);

-- stati
INSERT INTO cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.tipo
FROM (VALUES
	('BOZZA' , 'BOZZA', 'INTERVENTO'),
	('APPROVATO','APPROVATO', 'INTERVENTO'),
	('ANNULLATO','ANNULLATO', 'INTERVENTO'),
	('BOZZA','BOZZA', 'PROGRAMMA'),
	('APPROVATO','APPROVATO', 'PROGRAMMA'),
	('ANNULLATO','ANNULLATO', 'PROGRAMMA')
) AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_stato ds
	WHERE ds.stato_codice = tmp.codice
);

-- enti
INSERT INTO cpass.cpass_t_ente (ente_id, ente_denominazione, ente_codice_fiscale, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.den), tmp.den, tmp.cf, 'SYSTEM', 'SYSTEM'
FROM (VALUES
	('REGIONE PIEMONTE', '80087670016'),
	('CITTA'' METROPOLITANA DI TORINO', '01907990012')
) AS tmp(den, cf)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_ente')
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_ente te
	WHERE te.ente_denominazione = tmp.den
);

-- tipo settori
INSERT INTO cpass.cpass_d_tipo_settore (tipo_settore_codice, tipo_settore_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
	('DP', 'DIREZIONE DI INTEGRAZIONE DI PROCESSO'),
	('21', 'STRUTTURA STABILE DIRIGENZIALE')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_tipo_settore dts
	WHERE dts.tipo_settore_codice = tmp.codice
);

-- settori (per ora due settoriOPR di prova per Regione ed uno per CMTO)
INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, settore_indirizzo, settore_localita, settore_provincia, settore_cap, settore_telefono, ente_id, tipo_settore_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, tmp.indirizzo, tmp.localita, tmp.provincia, tmp.cap, tmp.telefono, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM'
FROM (VALUES
	('SA0001', 'TRASPARENZA E ANTICORRUZIONE', 'Corso Bolzano, 44', 'Torino', 'TO', '10121', '24206', 'REGIONE PIEMONTE', '21'),
	('A11000', 'A11000- RISORSE FINANZIARIE E PATRIMONIO', 'Via Maria Vittoria,15', 'Torino', 'TO', '10121', '24300', 'REGIONE PIEMONTE', '21'),
	('100041', 'RA2 - PROGRAMMAZIONE E MONITORAGGIO OO.PP. BENI E SERVIZI', 'CORSO INGHILTERRA, N° 7', 'Torino', 'TO', '10138', '011861', 'CITTA'' METROPOLITANA DI TORINO', 'DP')
) AS tmp(codice, descrizione, indirizzo, localita, provincia, cap, telefono, ente, tipo)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_settore')
JOIN cpass.cpass_t_ente te ON te.ente_denominazione = tmp.ente
JOIN cpass.cpass_d_tipo_settore dts ON dts.tipo_settore_codice = tmp.tipo
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_settore ts
	WHERE ts.settore_codice = tmp.codice
	AND ts.ente_id = te.ente_id
);

-- programmi
INSERT INTO cpass.cpass_t_programma (programma_id, programma_anno, programma_referente, stato_id, ente_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, te.ente_id || '_' || tmp.anno), tmp.anno, tmp.referente, ds.stato_id, te.ente_id, 'SYSTEM', 'SYSTEM'
FROM (VALUES
	(2020, 'DEMO 21 REGIONE', 'REGIONE PIEMONTE', 'BOZZA'),
	(2020, 'DEMO 21 CMTO', 'CITTA'' METROPOLITANA DI TORINO', 'BOZZA')
) AS tmp(anno, referente, ente, stato)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_programma')
JOIN cpass.cpass_t_ente te ON te.ente_denominazione = tmp.ente
JOIN cpass.cpass_d_stato ds ON (ds.stato_codice = tmp.stato AND ds.stato_tipo = 'PROGRAMMA')
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_programma tp
	WHERE tp.programma_anno = tmp.anno
	AND tp.ente_id = te.ente_id
);
