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
INSERT INTO cpass.cpass_t_uuid_namespace(uuid_namespace_table, uuid_namespace_value)
SELECT tmp.tab, tmp.val::uuid
FROM (VALUES
	('cpass_t_utente', 'da1eb474-aca6-58dc-a7ba-012a655f6855'),
	('cpass_t_settore', 'b7fcf183-a9ad-5b9e-928b-7ad2a903fcf4'),
	('cpass_t_intervento_importi', '0a6cbfee-6a4e-588e-a963-9714f24e009b'),
	('cpass_t_intervento', 'b128dcb1-ce93-5a44-9f7f-b13a5996989b'),
	('cpass_t_programma', '303e83fc-cede-58e8-8744-0801cd354225'),
	('cpass_t_ente', '8863d583-f86b-53b1-8b9d-842fd53d75e8')
) tmp(tab, val)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_uuid_namespace tun
	WHERE tun.uuid_namespace_table = tmp.tab
);

INSERT INTO cpass.cpass_t_ente (ente_denominazione, ente_codice_fiscale, ente_id, utente_creazione, utente_modifica)
SELECT tmp.den, tmp.cf, uuid_generate_v5(tun.uuid_namespace_value::uuid, tmp.cf), 'admin', 'admin'
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

INSERT INTO cpass.cpass_d_mod_affidamento (mod_affidamento_codice, mod_affidamento_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
	('ND', 'NON DELEGATO'),
	('D',  'DELEGATO')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_mod_affidamento dma
	WHERE dma.mod_affidamento_codice = tmp.codice
);

INSERT INTO cpass.cpass_d_priorita (priorita_codice, priorita_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
	('1','MASSIMA'),
	('2','MEDIA'),
	('3','MINIMA')
) AS tmp(codice,descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_priorita dp
	WHERE dp.priorita_codice = tmp.codice
);

INSERT INTO cpass.cpass_d_settore_interventi (settore_interventi_codice,settore_interventi_descrizione)
SELECT tmp.codice,tmp.descrizione
FROM (VALUES
	('F','FORNITURE'),
	('S','SERVIZI')
) AS tmp(codice,descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_priorita dp
	WHERE dp.priorita_codice = tmp.codice
);


INSERT INTO cpass.cpass_d_nuts (nuts_codice, nuts_descrizione)
SELECT tmp.code, tmp.descr
FROM (VALUES
	('ITC11', 'TORINO'),
	('ITC43', 'LECCO')
) AS tmp(code, descr)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_nuts dn
	WHERE dn.nuts_codice = tmp.code
);

INSERT INTO cpass.cpass_t_utente (utente_id, utente_nome, utente_cognome, utente_codice_fiscale, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value::uuid, tmp.cf), tmp.nome, tmp.cognome, tmp.cf, 'admin', 'admin'
FROM (VALUES
	('Demo', '20', 'AAAAAA00B77B000F'),
	('Demo', '21', 'AAAAAA00A11B000J'),
	('Demo', '22', 'AAAAAA00A11C000K')
) AS tmp(nome, cognome, cf)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_utente')
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_utente tu
	WHERE tu.utente_codice_fiscale = tmp.cf
);

INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo
FROM (VALUES
	('INS_INTERVENTO', 'voce di menu inserisci intervento', 'INTERVENTI', true, 'V'),
	('APP_INTERVENTO', 'funzione approvazione intervento', 'INTERVENTI', false, 'B'),
	('ANN_INTERVENTO_BOZZA', 'funzione annullamento intervento in bozza', 'INTERVENTI', false, 'B'),
	('ANN_INTERVENTO_APPROV', 'funzione annullamento intervento approvato', 'INTERVENTI', false, 'B'),
	('STAMPA_INTERVENTO', 'funzione di stampa dei prospetti', 'INTERVENTI', true, 'V')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
);
