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

-- !!!! STILO chiave parametro WSDL_LOCATION: valorizzare per produzione 
-- !!!! definito l'ente valorizzare correttamente le colonne flag_direzione, flag_utilizzabile , ente_id aggiungendo in coda all'istruzione di upd l'add del constraint NOT NULL sulla colonna ente_id
--      ALTER TABLE if exists cpass.cpass_d_tipo_settore ALTER column ente_id SET NOT NULL;
-- !!!! Integrazione NOTIER : indicare HOST e PORTA di produzione


/* da eseguire se � necessario cancellare i dati di test caricati dallo script dist\1.0.0\all.sql*/
delete from cpass_r_utente_rup_settore crurs where exists (
	select 1 from cpass_t_settore cts2, cpass_t_ente cte
	where cts2.ente_id = cte.ente_id 
	and cte.ente_denominazione = 'ENTE_TEST'
	and cts2.settore_id = crurs.settore_id );
delete from cpass.cpass_r_ruolo_utente_settore crrus where exists (
	select 1 from cpass_r_utente_settore crus2, cpass_t_settore cts2 , cpass_t_ente cte
	where cts2.ente_id = cte.ente_id and cte.ente_denominazione = 'ENTE_TEST'
	and cts2.settore_id = crus2.settore_id
	and crus2.utente_settore_id = crrus.utente_settore_id );
delete from cpass_r_utente_settore crus2 where exists (
	select 1 from cpass_t_settore cts2 , cpass_t_ente cte
	where cts2.ente_id = cte.ente_id and cte.ente_denominazione = 'ENTE_TEST'
	and cts2.settore_id = crus2.settore_id );
delete from cpass_r_ufficio_settore crus where exists (
	select 1 from cpass_t_settore cts2 , cpass_t_ente cte
	where cts2.ente_id = cte.ente_id and cte.ente_denominazione = 'ENTE_TEST'
    and cts2.settore_id = crus.settore_id );
delete from cpass_t_ufficio ctu where ctu.ufficio_codice like 'UFFTST%';
delete from cpass_t_settore_indirizzo ctsi where exists (
	select 1 from cpass_t_settore cts2 , cpass_t_ente cte
	where cts2.ente_id = cte.ente_id and cte.ente_denominazione = 'ENTE_TEST' 
    and cts2.settore_id = ctsi.settore_id );
delete from cpass_t_settore cts where exists (
	select 1 from cpass_t_ente cte 
	where cte.ente_denominazione = 'ENTE_TEST' 
	and  cts.ente_id = cte.ente_id);
delete from cpass_t_utente ctu where utente_nome = 'Demo'; -- solo se non configurato su settori di enti <> ENTE_TEST
delete from cpass_t_ente where ente_denominazione = 'ENTE_TEST';

INSERT INTO cpass.cpass_t_ente (ente_codice,ente_denominazione, ente_codice_fiscale, ente_id, utente_creazione, utente_modifica)
SELECT tmp.codice, tmp.den, tmp.cf, uuid_generate_v5(tun.uuid_namespace_value::uuid, tmp.cf), 'SYSTEM', 'SYSTEM'
FROM (VALUES
  ('REGP','REGIONE PIEMONTE', '80087670016')
) AS tmp(codice, den, cf)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_ente')
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_ente te
  WHERE te.ente_codice = tmp.codice
);

------------------------------------------- cpass_d_tipo_settore --------

delete from cpass.cpass_d_tipo_settore where tipo_settore_codice in ('4','8','21');

update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=false where tipo_settore_codice='R1-001';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=false where tipo_settore_codice='R1-002';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=false where tipo_settore_codice='R1-003';
update cpass.cpass_d_tipo_settore set flag_direzione=TRUE ,flag_utilizzabile=true  where tipo_settore_codice='R1-004';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=false where tipo_settore_codice='R1-005';
update cpass.cpass_d_tipo_settore set flag_direzione=TRUE ,flag_utilizzabile=false where tipo_settore_codice='R1-006';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=false where tipo_settore_codice='R1-007';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=true  where tipo_settore_codice='R1-008';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=true  where tipo_settore_codice='R1-009';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=false where tipo_settore_codice='R1-010';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=true  where tipo_settore_codice='R1-011';
update cpass.cpass_d_tipo_settore set flag_direzione=TRUE ,flag_utilizzabile=true  where tipo_settore_codice='R1-012';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=true  where tipo_settore_codice='R1-013';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=true  where tipo_settore_codice='R1-014';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=false where tipo_settore_codice='R1-015';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=true  where tipo_settore_codice='R1-016';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=true  where tipo_settore_codice='R1-020';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=true  where tipo_settore_codice='R1-021';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=true  where tipo_settore_codice='R1-022';
update cpass.cpass_d_tipo_settore set flag_direzione=FALSE,flag_utilizzabile=true  where tipo_settore_codice='R1-023';
update cpass.cpass_d_tipo_settore set flag_direzione=TRUE ,flag_utilizzabile=true  where tipo_settore_codice='R1-024';

update cpass.cpass_d_tipo_settore set ente_id = (select ente_id from cpass.cpass_t_ente where ente_codice = 'REGP');
---------------INSERT SETTORI, TIPO DIREZIONE ------------------------------------------
INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, settore_indirizzo,settore_num_civico , settore_localita, settore_provincia, settore_cap,settore_telefono, ente_id, tipo_settore_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, tmp.indirizzo,tmp.num_civico, tmp.localita, tmp.provincia, tmp.cap,'0114321111', te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM'
FROM (VALUES
	('R1','GIUNTA REGIONALE DEL PIEMONTE','R1-003','piazza Castello','165','Torino','10122','TO','REGP'))
AS tmp(codice, descrizione,tipo,indirizzo,num_civico, localita,cap,provincia, ente)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_settore')
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente
JOIN cpass.cpass_d_tipo_settore dts ON dts.tipo_settore_codice = tmp.tipo
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore ts
  WHERE ts.settore_codice = tmp.codice
  AND ts.ente_id = te.ente_id
);
INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, settore_indirizzo,settore_num_civico , settore_localita, settore_provincia, settore_cap, settore_telefono,settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, tmp.indirizzo,tmp.num_civico, tmp.localita, tmp.provincia, tmp.cap,'0114321111', ts1.settore_id, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM'
FROM (VALUES
	('SA','STRUTTURE AMMINISTRATIVE','R1-010','R1','piazza Castello','165','Torino','10122','TO','REGP'),
	('OP','ORGANI POLITICI','R1-005','R1','piazza Castello','165','Torino','10122','TO','REGP'))
AS tmp(codice, descrizione,tipo,codice_padre,indirizzo,num_civico, localita,cap,provincia, ente)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_settore')
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente
JOIN cpass.cpass_d_tipo_settore dts ON dts.tipo_settore_codice = tmp.tipo
JOIN cpass.cpass_t_settore ts1 ON ts1.settore_codice = tmp.codice_padre and ts1.ente_id=te.ente_id
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore ts
  WHERE ts.settore_codice = tmp.codice
  AND ts.ente_id = te.ente_id
);
INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, settore_indirizzo,settore_num_civico , settore_localita, settore_provincia, settore_cap, settore_telefono,settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, tmp.indirizzo,tmp.num_civico, tmp.localita, tmp.provincia, tmp.cap,'0114321111', ts1.settore_id, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM'
FROM (VALUES
	('GI','ORGANISMI DI GIUNTA','R1-005','OP','piazza Castello','165','Torino','10122','TO','REGP'))
AS tmp(codice, descrizione,tipo,codice_padre,indirizzo,num_civico, localita,cap,provincia, ente)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_settore')
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente
JOIN cpass.cpass_d_tipo_settore dts ON dts.tipo_settore_codice = tmp.tipo
JOIN cpass.cpass_t_settore ts1 ON ts1.settore_codice = tmp.codice_padre and ts1.ente_id=te.ente_id
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore ts
  WHERE ts.settore_codice = tmp.codice
  AND ts.ente_id = te.ente_id
);
INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, settore_indirizzo,settore_num_civico , settore_localita, settore_provincia, settore_cap, settore_telefono,settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, tmp.indirizzo,tmp.num_civico, tmp.localita, tmp.provincia, tmp.cap,'0114321111', ts1.settore_id, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM'
FROM (VALUES
	('UC','UFFICI DI COMUNICAZIONE','R1-014','SA','piazza Castello','165','Torino','10122','TO','REGP'),
	('SA0001','TRASPARENZA E ANTICORRUZIONE','R1-024','SA','piazza Castello','165','Torino','10122','TO','REGP'),
	('A1000A','DIREZIONE DELLA GIUNTA REGIONALE','R1-004','SA','piazza Castello','165','Torino','10122','TO','REGP'),
	('A11000','RISORSE FINANZIARIE E PATRIMONIO','R1-004','SA','piazza Castello','165','Torino','10122','TO','REGP'),
	('A1400A','SANITA'' E WELFARE','R1-004','SA','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('A1500A','ISTRUZIONE, FORMAZIONE E LAVORO','R1-004','SA','via Magenta','12','Torino','10128','TO','REGP'),
	('A1600A','AMBIENTE, ENERGIA E TERRITORIO','R1-004','SA','via Principe Amedeo','17','Torino','10123','TO','REGP'),
	('A1700A','AGRICOLTURA E CIBO','R1-004','SA','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1800A','OPERE PUBBLICHE, DIFESA DEL SUOLO, PROTEZIONE CIVILE, TRASPORTI E LOGISTICA','R1-004','SA','corso Bolzano','44','Torino','10121','TO','REGP'),
	('A19000','COMPETITIVITA'' DEL SISTEMA REGIONALE','R1-004','SA','via Pisano','6','Torino','10152','TO','REGP'),
	('A2000A','CULTURA, TURISMO E COMMERCIO','R1-004','SA','via Bertola','34','Torino','10122','TO','REGP'),
	('A21000','COORDINAMENTO POLITICHE E FONDI EUROPEI','R1-004','SA','piazza Castello','165','Torino','10122','TO','REGP'))
AS tmp(codice, descrizione,tipo,codice_padre,indirizzo,num_civico, localita,cap,provincia, ente)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_settore')
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente
JOIN cpass.cpass_d_tipo_settore dts ON dts.tipo_settore_codice = tmp.tipo
JOIN cpass.cpass_t_settore ts1 ON ts1.settore_codice = tmp.codice_padre and ts1.ente_id=te.ente_id
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore ts
  WHERE ts.settore_codice = tmp.codice
  AND ts.ente_id = te.ente_id
);
INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, settore_indirizzo,settore_num_civico , settore_localita, settore_provincia, settore_cap, settore_telefono,settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, tmp.indirizzo,tmp.num_civico, tmp.localita, tmp.provincia, tmp.cap,'0114321111', ts1.settore_id, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM'
FROM (VALUES
	('A1005D','Indirizzi e controlli societa'' partecipate','R1-008','A1000A','piazza Castello','165','Torino','10122','TO','REGP'),
	('A1006D','Stato giuridico, ordinamento e formazione del personale','R1-008','A1000A','via Viotti','8','Torino','10121','TO','REGP'),
	('A1007D','Trattamento economico, pensionistico, previdenziale e assicurativo del personale','R1-008','A1000A','piazza Castello','165','Torino','10122','TO','REGP'),
	('A1008D','Organizzazione e pianificazione delle risorse umane','R1-008','A1000A','via Viotti','8','Torino','10121','TO','REGP'),
	('A1011A','Attivit� legislativa e consulenza giuridica','R1-008','A1000A','piazza Castello','165','Torino','10122','TO','REGP'),
	('A1012A','Contratti-persone giuridiche-espropri-usi civici','R1-008','A1000A','via Viotti','8','Torino','10121','TO','REGP'),
	('A1013B','Coordinamento e gestione servizi generali operativi - Tutela dei consumatori','R1-008','A1000A','corso Regina Margherita','174','Torino','10152','TO','REGP'),
	('A1014B','Rapporti con le Autonomie locali, Polizia locale, Sicurezza integrata, Elezioni e Referendum','R1-008','A1000A','corso Regina Margherita','174','Torino','10152','TO','REGP'),
	('A1015A','Segreteria della Giunta regionale','R1-008','A1000A','piazza Castello','165','Torino','10122','TO','REGP'),
	('A1017A','Audit interno','R1-008','A1000A','piazza Castello','165','Torino','10122','TO','REGP'),
	('A1018A','Avvocatura','R1-008','A1000A','corso Regina Margherita','174','Torino','10152','TO','REGP'),
	('A1099C','Direzione della Giunta regionale L.R. 23/2015','R1-008','A1000A','piazza Castello','165','Torino','10122','TO','REGP'),
	('XST022','Piano di rafforzamento amministrativo','R1-023','A1000A','piazza Castello','165','Torino','10122','TO','REGP'),
	('XST023','Iniziative di negoziazione di rilevanza strategica','R1-023','A1000A','corso Bolzano','44','Torino','10121','TO','REGP'),
	('A1101A','Programmazione macroeconomica, bilancio e statistica','R1-008','A11000','piazza Castello','165','Torino','10122','TO','REGP'),
	('A1102A','Ragioneria','R1-008','A11000','piazza Castello','165','Torino','10122','TO','REGP'),
	('A1103A','Politiche fiscali e contenzioso amministrativo','R1-008','A11000','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('A1110B','Acquisizione e controllo delle risorse finanziarie','R1-008','A11000','piazza Castello','165','Torino','10122','TO','REGP'),
	('A1111C','Patrimonio immobiliare, beni mobili, economato e cassa economale','R1-008','A11000','via Viotti','8','Torino','10121','TO','REGP'),
	('A1112C','Tecnico e sicurezza degli ambienti di lavoro','R1-008','A11000','via Viotti','8','Torino','10121','TO','REGP'),
	('XST024','Gestione del progetto "Palazzo degli uffici della Regione Piemonte - fase di realizzazione e gestione progetto ZUT"','R1-023','A11000','via Passo Buole','22','Torino','10127','TO','REGP'),
	('XST025','Gestione del progetto "Welfare aziendale e benessere organizzativo nel palazzo degli uffici della Regione Piemonte"','R1-023','A11000','piazza Castello','165','Torino','10122','TO','REGP'),
	('XST009','Struttura temporanea per la gestione del progetto ''Palazzo degli uffici della Regione Piemonte - fase di realizzazione''','R1-023','A11000','piazza Castello','165','Torino','10122','TO','REGP'),
	('XST010','Gestione progetto ZUT','R1-023','A11000','piazza Castello','165','Torino','10122','TO','REGP'),
	('A1404B','Assistenza farmaceutica, integrativa e protesica','R1-008','A1400A','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('A1406B','Sistemi organizzativi e risorse umane del SSR','R1-008','A1400A','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('A1407B','Programmazione economico-finanziaria','R1-008','A1400A','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('A1409B','Prevenzione e veterinaria','R1-008','A1400A','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('A1413C','Programmazione dei servizi sanitari e socio-sanitari','R1-008','A1400A','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('A1414C','Regole del SSR nei rapporti con i soggetti erogatori','R1-008','A1400A','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('A1415C','Politiche degli investimenti','R1-008','A1400A','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('A1416C','Controllo di gestione, sistemi informativi, logistica sanitaria e coordinamento acquisti','R1-008','A1400A','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('A1417A','Anticorruzione e vigilanza sui contratti e sulle strutture pubbliche e private','R1-008','A1400A','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('A1418A','Politiche di welfare abitativo','R1-008','A1400A','via Bertola','34','Torino','10122','TO','REGP'),
	('A1419A','Politiche per i bambini, le famiglie, minori e giovani, sostegno alle situazioni di fragilita'' sociale','R1-008','A1400A','via Magenta','12','Torino','10128','TO','REGP'),
	('A1420A','Politiche per le pari opportunita'', diritti e inclusione','R1-008','A1400A','via Bertola','34','Torino','10122','TO','REGP'),
	('A1421A','Programmazione socio-assistenziale e socio-sanitaria; standard di servizio e qualita''','R1-008','A1400A','via Bertola','34','Torino','10122','TO','REGP'),
	('A1499A','Sanit� e welfare L.R. 23/2015','R1-008','A1400A','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('XST028','Emergenza COVID-19','R1-023','A1400A','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('A1501B','Raccordo amministrativo e controllo delle attivit� cofinanziate dal FSE','R1-008','A1500A','via Magenta','12','Torino','10128','TO','REGP'),
	('A1502B','Politiche del lavoro','R1-008','A1500A','via Magenta','12','Torino','10128','TO','REGP'),
	('A1503B','Formazione professionale','R1-008','A1500A','via Magenta','12','Torino','10128','TO','REGP'),
	('A1504B','Standard formativi e orientamento professionale','R1-008','A1500A','via Magenta','12','Torino','10128','TO','REGP'),
	('A1511C','Politiche dell''istruzione, programmazione e monitoraggio strutture scolastiche','R1-008','A1500A','via Magenta','12','Torino','10128','TO','REGP'),
	('A1598B','Istruzione, formazione e lavoro - APL - CPI','R1-008','A1500A','via Magenta','12','Torino','10128','TO','REGP'),
	('A1599B','Istruzione, formazione e lavoro L.R. 23/2015','R1-008','A1500A','via Magenta','12','Torino','10128','TO','REGP'),
	('A1601B','Biodiversit� e aree naturali','R1-008','A1600A','via Principe Amedeo','17','Torino','10123','TO','REGP'),
	('A1602B','Emissioni e rischi ambientali','R1-008','A1600A','via Principe Amedeo','17','Torino','10123','TO','REGP'),
	('A1603B','Servizi ambientali','R1-008','A1600A','via Principe Amedeo','17','Torino','10123','TO','REGP'),
	('A1604B','Tutela delle acque','R1-008','A1600A','via Principe Amedeo','17','Torino','10123','TO','REGP'),
	('A1605B','Valutazioni ambientali e procedure integrate','R1-008','A1600A','via Principe Amedeo','17','Torino','10123','TO','REGP'),
	('A1606B','Copianificazione urbanistica area nord-ovest','R1-008','A1600A','corso Bolzano','44','Torino','10121','TO','REGP'),
	('A1607B','Copianificazione urbanistica area nord-est','R1-008','A1600A','via Mora e Gibin','4','Novara','28100','NO','REGP'),
	('A1608B','Copianificazione urbanistica area sud-est','R1-008','A1600A','corso Dante','165','Asti','14100','AT','REGP'),
	('A1609B','Copianificazione urbanistica area sud-ovest','R1-008','A1600A','corso De Gasperi','40','Cuneo','12100','CN','REGP'),
	('A1610B','Territorio e paesaggio','R1-008','A1600A','corso Bolzano','44','Torino','10121','TO','REGP'),
	('A1611B','Giuridico legislativo','R1-008','A1600A','via Principe Amedeo','17','Torino','10123','TO','REGP'),
	('A1612B','Progettazione strategica e green economy','R1-008','A1600A','corso Bolzano','44','Torino','10121','TO','REGP'),
	('A1613B','Sistema informativo territoriale e ambientale','R1-008','A1600A','corso Bolzano','44','Torino','10121','TO','REGP'),
	('A1614A','Foreste','R1-008','A1600A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1615A','Sviluppo della montagna','R1-008','A1600A','via Principe Amedeo','17','Torino','10123','TO','REGP'),
	('A1616A','Sviluppo energetico sostenibile','R1-008','A1600A','corso Regina Margherita','174','Torino','10152','TO','REGP'),
	('A1699A','Ambiente, governo e tutela del territorio L.R. 23/2015','R1-008','A1600A','via Principe Amedeo','17','Torino','10123','TO','REGP'),
	('XST026','Agenda Nazionale per la semplificazione amministrativa: azioni per i procedimenti regionali in materia di Ambiente e Territorio','R1-023','A1600A','via Principe Amedeo','17','Torino','10123','TO','REGP'),
	('A1701B','Produzioni agrarie e zootecniche','R1-008','A1700A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1703B','Fitosanitario e servizi tecnico-scientifici','R1-008','A1700A','via Livorno','60','Torino','10144','TO','REGP'),
	('A1705B','Programmazione e coordinamento sviluppo rurale e agricoltura sostenibile','R1-008','A1700A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1706B','Servizi di sviluppo e controlli per l''agricoltura','R1-008','A1700A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1707B','Strutture delle imprese agricole ed agroindustriali ed energia rinnovabile','R1-008','A1700A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1708B','Valorizzazione del sistema agroalimentare e tutela della qualit�','R1-008','A1700A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1709C','Infrastrutture, territorio rurale, calamita'' naturali in agricoltura, caccia e pesca','R1-008','A1700A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1710C','Attuazione programmi relativi alle produzioni vegetali e animali','R1-008','A1700A','Piazza Alfieri','33','Asti','14100','AT','REGP'),
	('A1711C','Attuazione programmi relativi alle strutture delle aziende agricole e alle avversit� atmosferiche','R1-008','A1700A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1712C','Attuazione programmi relativi ai servizi di sviluppo','R1-008','A1700A','via Viotti','8','Torino','10121','TO','REGP'),
	('A1713C','Attuazione programmi agroambientali e per l''agricoltura biologica','R1-008','A1700A','via Viotti','8','Torino','10121','TO','REGP'),
	('A1799B','Agricoltura e cibo L.R. 23/2015','R1-008','A1700A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1801B','Attivit� giuridica e amministrativa','R1-008','A1800A','corso Bolzano','44','Torino','10121','TO','REGP'),
	('A1802B','Infrastrutture e pronto intervento','R1-008','A1800A','corso Bolzano','44','Torino','10121','TO','REGP'),
	('A1805B','Difesa del suolo','R1-008','A1800A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1806B','Sismico','R1-008','A1800A','via San Giuseppe','39','Pinerolo','10064','TO','REGP'),
	('A1809B','Pianificazione e programmazione trasporti e infrastrutture','R1-008','A1800A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1810B','Controllo sulla gestione dei trasporti e delle infrastrutture','R1-008','A1800A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1811B','Investimenti trasporti e infrastrutture','R1-008','A1800A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1812B','Infrastrutture strategiche','R1-008','A1800A','corso Stati Uniti','21','Torino','10128','TO','REGP'),
	('A1813B','Tecnico regionale area metropolitana di Torino','R1-008','A1800A','corso Bolzano','44','Torino','10121','TO','REGP'),
	('A1814B','Tecnico regionale - Alessandria e Asti','R1-008','A1800A','piazza Turati','4','Alessandria','15121','AL','REGP'),
	('A1816B','Tecnico regionale - Cuneo','R1-008','A1800A','corso Kennedy','7/bis','Cuneo','12100','CN','REGP'),
	('A1817B','Tecnico regionale - Novara e Verbania','R1-008','A1800A','via Mora e Gibin','4','Novara','28100','NO','REGP'),
	('A1819C','Geologico','R1-008','A1800A','corso Bolzano','44','Torino','10121','TO','REGP'),
	('A1820C','Tecnico regionale - Biella e Vercelli','R1-008','A1800A','via F.lli Ponti','24','Vercelli','13100','VC','REGP'),
	('A1821A','Protezione civile','R1-008','A1800A','corso Marche','79','Torino','10146','TO','REGP'),
	('A1822A','Sistema anti incendi boschivi (A.I.B.)','R1-008','A1800A','corso Bolzano','44','Torino','10121','TO','REGP'),
	('A1899B','Opere pubbliche, difesa del suolo, protezione civile, trasporti e logistica L.R. 23/2015','R1-008','A1800A','corso Bolzano','44','Torino','10121','TO','REGP'),
	('XST027','Gestione liquidatoria comunit� montane','R1-023','A1800A','piazza Castello','165','Torino','10122','TO','REGP'),
	('A1901A','Gestione amministrativa e finanziaria','R1-008','A19000','via Pisano','6','Torino','10152','TO','REGP'),
	('A1902A','Artigianato','R1-008','A19000','via Pisano','6','Torino','10152','TO','REGP'),
	('A1905A','Sviluppo sostenibile e qualificazione del sistema produttivo del territorio','R1-008','A19000','via Pisano','6','Torino','10152','TO','REGP'),
	('A1906A','Polizia mineraria,  cave e miniere','R1-008','A19000','via Pisano','6','Torino','10152','TO','REGP'),
	('A1907A','Sistema universitario, diritto allo studio, ricerca e innovazione','R1-008','A19000','via Pisano','6','Torino','10152','TO','REGP'),
	('A1908A','Monitoraggio valutazioni e controlli','R1-008','A19000','via Pisano','6','Torino','10152','TO','REGP'),
	('A1910A','Servizi infrastrutturali e tecnologici','R1-008','A19000','corso Regina Margherita','174','Torino','10152','TO','REGP'),
	('A1911A','Sistema informativo regionale','R1-008','A19000','corso Regina Margherita','174','Torino','10152','TO','REGP'),
	('A1912A','Promozione dello sviluppo economico e accesso al credito per le imprese','R1-008','A19000','via Pisano','6','Torino','10152','TO','REGP'),
	('A1999A','Competitivit� del sistema regionale L.R. 23/2015','R1-008','A19000','via Pisano','6','Torino','10152','TO','REGP'),
	('A2001B','Promozione dei beni librari e archivistici, editoria ed istituti culturali','R1-008','A2000A','via Bertola','34','Torino','10122','TO','REGP'),
	('A2002B','Valorizzazione del patrimonio culturale, musei e siti UNESCO','R1-008','A2000A','via Bertola','34','Torino','10122','TO','REGP'),
	('A2003B','Promozione delle attivit� culturali, del patrimonio linguistico e dello spettacolo','R1-008','A2000A','via Bertola','34','Torino','10122','TO','REGP'),
	('A2006B','Museo regionale di scienze naturali','R1-008','A2000A','via Bertola','34','Torino','10122','TO','REGP'),
	('A2007C','Offerta turistica','R1-008','A2000A','via Bertola','34','Torino','10122','TO','REGP'),
	('A2008C','Promozione turistica','R1-008','A2000A','via Bertola','34','Torino','10122','TO','REGP'),
	('A2009A','Commercio e terziario','R1-008','A2000A','via Pisano','6','Torino','10152','TO','REGP'),
	('A2099B','Cultura, turismo e commercio L.R. 23/2015','R1-008','A2000A','via Bertola','34','Torino','10122','TO','REGP'),
	('A2101A','Affari internazionali e cooperazione decentrata','R1-008','A21000','piazza Castello','165','Torino','10122','TO','REGP'),
	('A2102A','Comunicazione, ufficio stampa, relazioni esterne, URP','R1-008','A21000','piazza Castello','165','Torino','10122','TO','REGP'),
	('A2103A','Coordinamento Fondi Strutturali Europei e cooperazione transfrontaliera','R1-008','A21000','piazza Castello','165','Torino','10122','TO','REGP'),
	('A2104A','Programmazione negoziata','R1-008','A21000','via Bertola','34','Torino','10122','TO','REGP'),
	('A2105A','Relazioni istituzionali e Affari europei','R1-008','A21000','piazza Castello','165','Torino','10122','TO','REGP'),
	('A2106A','Sport e tempo libero','R1-008','A21000','via Bertola','34','Torino','10122','TO','REGP'),
	('PRE00','UFFICIO DI COMUNICAZIONE PRESIDENZA','R1-014','UC','piazza Castello','165','Torino','10122','TO','REGP'),
	('ACP00','UFFICIO COMUNICAZIONE AGRICOLTURA, CIBO, CACCIA E PESCA','R1-014','UC','piazza Castello','165','Torino','10122','TO','REGP'),
	('AIR00','UFFICIO COMUNICAZIONE AMBIENTE, ENERGIA, INNOVAZIONE, RICERCA E CONNESSI RAPPORTI CON ATENEI E CENTRI DI RICERCA PUBBLICI E PRIVATI','R1-014','UC','via Principe Amedeo','17','Torino','10123','TO','REGP'),
	('BAI00','UFF.COM.BIL.,FINANZE,PROGR.NE ECON.-FINAN.,PATRIM.,SVIL. ATT.TA'' PROD.VE E PICCOLE MEDIE IMPRESE:INDUSTRIA,ARTIG.TO,IMPRESE COOP.VE,ATT.TA'' ESTRATTIV','R1-014','UC','piazza Castello','165','Torino','10122','TO','REGP'),
	('CTC00','UFFICIO COMUNICAZIONE CULTURA, TURISMO, COMMERCIO','R1-014','UC','via Bertola','34','Torino','10122','TO','REGP'),
	('LFU00','UFFICIO COMUNICAZIONE ISTRUZIONE, LAVORO, FORMAZIONE PROFESSIONALE, DIRITTO ALLO STUDIO UNIVERSITARIO','R1-014','UC','via Magenta','12','Torino','10128','TO','REGP'),
	('SAE00','UFFICIO COMUNICAZIONE SANITA'', LIVELLI ESSENZIALI DI ASSISTENZA, EDILIZIA SANITARIA','R1-014','UC','corso Regina Margherita','153 bis','Torino','10122','TO','REGP'),
	('OTP00','UFFICIO COMUNICAZIONE TRASPORTI, INFRASTRUTTURE, OPERE PUBBLICHE, DIFESA DEL SUOLO, PROTEZIONE CIVILE, PERSONALE E ORGANIZZAZIONE','R1-014','UC','corso Dante','163','Asti','14100','AT','REGP'),
	('UTE00','UFFICIO COMUNICAZIONE URBANISTICA, PROGRAMMAZIONE TERRITORIALE E PAESAGGISTICA, SVILUPPO DELLA MONTAGNA, FORESTE, PARCHI, ENTI LOCALI','R1-014','UC','piazza Castello','165','Torino','10122','TO','REGP'),
	('FSP00','UFF. COM. POLITICHE DELLA FAMIGLIA, DEI BAMBINI E DELLA CASA, SOCIALE, PARI OPPORTUNITA''','R1-014','UC','via Bertola','34','Torino','10122','TO','REGP'),
	('PCP00','UFF.COM. INTERNAZIONALIZZAZIONE, RAPPORTI CON SOCIETA A PARTECIPAZIONE REGIONALE, SICUREZZA, POLIZIA LOCALE, IMMIGRAZIONE, SPORT, POLITICHE GIOVANILI','R1-014','UC','piazza Castello','165','Torino','10122','TO','REGP'),
	('DAC00','UFF.COM. RAPPORTI CON CONS. REG., DELEGIF. SEMPLIF. DEI PERCORSI AMM.VI, AFFARI LEGALI E CONTENZ., EMIGRAZIONE, COOP. DEC. INTERNAZ.,OPERE POST-OLIMP.','R1-014','UC','via Viotti','8','Torino','10121','TO','REGP'))
AS tmp(codice, descrizione,tipo,codice_padre,indirizzo,num_civico, localita,cap,provincia, ente)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_settore')
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente
JOIN cpass.cpass_d_tipo_settore dts ON dts.tipo_settore_codice = tmp.tipo
JOIN cpass.cpass_t_settore ts1 ON ts1.settore_codice = tmp.codice_padre and ts1.ente_id=te.ente_id
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore ts
  WHERE ts.settore_codice = tmp.codice
  AND ts.ente_id = te.ente_id
);

/*cpass_r_ufficio_settore - 22.12.2020 Inseriamo in un secondo momento */
INSERT INTO cpass.cpass_t_ufficio (ufficio_codice, ufficio_descrizione, data_creazione, utente_creazione, data_modifica, utente_modifica)
SELECT tmp.ufficio_codice, tmp.ufficio_descrizione, now(), 'SYSTEM', now(), 'SYSTEM'
FROM (VALUES
('0XNNK3','Telefonia'),
('1D1MZT','Direzione Competitivita'' sistema regionale'),
('1MGN7P','Direzione  coordinamento politiche e fondi europei e tutti i settori tranne comunicazione ufficio stampa relazione esterne e urp'),
('5VHG50','Audit interno'),
('6U1HQH','Settore tecnici'),
('7K3KWF','Patrimonio immobiliare, beni mobili, economato e cassa economale'),
('81YHY9','Economato'),
('A17LZ5','Tecnico e Sicurezza'),
('ADAT4K','Direzione Sanita'' e tutti i settori tranne Sistemi organizzativi, risorse umane del SSR e politiche di Welfare'),
('AX8DPY','Direzione Risorse Finanziarie e Patrimonio'),
('BR4EG5','Comunicazione, ufficio stampa, relazioni esterne e URP'),
('C82S84','Gabinetto Presidenza della Giunta'),
('E6A9MX','Direzione ambiente energia e territorio'),
('E9J5YC','Avvocatura'),
('EFSFG6','Politiche di Welfare'),
('EOG7LT','Direzione agricoltura cibo e tutti i settori tranne il Fitosanitario e servizio tecnicoscientifici'),
('F7XJX1','Fitosanitario e servizi tecnico-scientifici'),
('FPRJNR','Trattamento economico, pensionistico, previdenziale e assicurativo del personale'),
('HQM2O9','Direzione della Giunta Regionale e tutti i settori tranne Formazione del personale dipendente, Stato giuridico ed ordinamento del personale, Trattamento economico, pensionistico, previdenziale e assicurativo del personale, Coordinamento e gestione servizi generali operativi - Tutela dei consumatori'),
('IHRBBE','Coordinamento e gestione servizi generali operativi - Tutela dei consumatori'),
('J9FDBP','Direzione OO.PP, Protezione Civile, Trasporti, Logistica'),
('JBJRON','Formazione del personale dipendente'),
('JKNPJS','Ufficio per la transizione al Digitale'),
('L77UYL','Patrimonio SERVIZI'),
('PT6DEI','Stato giuridico, ordinamento e formazione del personale'),
('S04VFA','Direzione istruzione, formazione lavoro'),
('THPX37','Sistemi organizzativi e risorse umane del SSR'),
('UFES06','Uff_eFatturaPA'),
('V3QQD9','Protezione civile e sistema antincendi boschivi (A.I.B.)'),
('YVDPFP','Direzione cultura turismo e commercio'),
('ZRE6BX','Servizi infrastrutturali e tecnologici e Sistema informativo Regionale')
) AS tmp(ufficio_codice, ufficio_descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_ufficio current
  WHERE current.ufficio_codice = tmp.ufficio_codice
);

---------------UTENTE-----------------------------------
INSERT INTO cpass.cpass_t_utente (utente_id, utente_nome, utente_cognome, utente_codice_fiscale, telefono, email, rup, data_creazione, utente_creazione, data_modifica, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.utente_codice_fiscale), tmp.utente_nome, tmp.utente_cognome, tmp.utente_codice_fiscale, tmp.telefono, NULL, tmp.rup, now(), 'SYSTEM', now(), 'SYSTEM'
FROM (VALUES
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

INSERT INTO cpass.cpass_r_utente_settore (utente_id, settore_id, utente_settore_default)
SELECT tu.utente_id, ts.settore_id, tmp.settore_default
FROM (VALUES
	('CPNCLD71M25L219I','SA0001',true),
	('TRTSLV63L42L219B','SA0001',true),
	('TLLNRT69E56D122C','SA0001',true),
	('TRNDNL82R65D810B','SA0001',true),
	('STRLSS92R24G317X','SA0001',true)
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
	('CPNCLD71M25L219I','SA0001','ADMIN'),
	('TRTSLV63L42L219B','SA0001','ADMIN'),
	('TLLNRT69E56D122C','SA0001','ADMIN'),
	('TRNDNL82R65D810B','SA0001','ADMIN'),
	('STRLSS92R24G317X','SA0001','ADMIN')
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


-- STILO (valorizzare correttamente per produzione)

insert into cpass.cpass_t_fruitore (fruitore_codice , fruitore_ente_codice_fiscale)
select tmp.codice, tmp.fe_ente
from (values 
	('SIAC', '80087670016')
	)AS tmp(codice, fe_ente)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_t_fruitore rfs
	WHERE rfs.fruitore_codice = tmp.codice
	AND rfs.fruitore_ente_codice_fiscale = tmp.fe_ente
);

INSERT INTO cpass_r_fruitore_servizio  (servizio_id , fruitore_id )
SELECT s.servizio_id, f.fruitore_id
FROM (VALUES
	('VERIFICA_EVASIONE', 'SIAC', '80087670016')
) AS tmp(servizio, fruitore_codice, fruitore_cf)
JOIN cpass_t_servizio s ON s.servizio_codice = tmp.servizio
JOIN cpass_t_fruitore f ON f.fruitore_codice = tmp.fruitore_codice and f.fruitore_ente_codice_fiscale = tmp.fruitore_cf
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_r_fruitore_servizio rfs
	WHERE rfs.servizio_id = s.servizio_id
	AND rfs.fruitore_id = f.fruitore_id
);

-- integrazione NOTIER  (valorizzare correttamente per produzione)
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('IMPLEMENTOR',           'notier',                                                                               'NSO', '',       'Per interrogazione NSO', true),
	('IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.notier.NSOHelperImpl', 	                      'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('NSO_CUSTOMIZATION_ID',  'urn:fdc:peppol.eu:poacc:trns:order:3:restrictive:urn:www.agid.gov.it:trns:ordine:3.1', 'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('NSO_PROFILE_ID',        'urn:fdc:peppol.eu:poacc:bis:order_only:3',                                             'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('HOST_NOTIER',           'test-notier.regione.emilia-romagna.it',                                                'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('PORTA_NOTIER',          '8443',                                                                                 'NSO', 'NOTIER', 'Per interrogazione NSO', true)
	) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);