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
-- TEST-CMTO-01
INSERT INTO cpass.cpass_t_ufficio (ufficio_codice, ufficio_descrizione,data_creazione, utente_creazione, data_modifica, utente_modifica,  ente_id) VALUES ('0E175J','Servizi alle imprese, SPL e partecipazioni',now(), 'SYSTEM', now(), 'SYSTEM', (select ente_id from cpass_t_ente where ente_codice ='CMTO'));
INSERT INTO cpass.cpass_t_ufficio (ufficio_codice, ufficio_descrizione,data_creazione, utente_creazione, data_modifica, utente_modifica,  ente_id) VALUES ('R54BIF','Tutela del territorio',now(), 'SYSTEM', now(), 'SYSTEM', (select ente_id from cpass_t_ente where ente_codice ='CMTO'));
INSERT INTO cpass.cpass_t_ufficio (ufficio_codice, ufficio_descrizione,data_creazione, utente_creazione, data_modifica, utente_modifica,  ente_id) VALUES ('TWNJQH','Progetti e programmi europei ed internazionali',now(), 'SYSTEM', now(), 'SYSTEM', (select ente_id from cpass_t_ente where ente_codice ='CMTO'));
INSERT INTO cpass.cpass_t_ufficio (ufficio_codice, ufficio_descrizione,data_creazione, utente_creazione, data_modifica, utente_modifica,  ente_id) VALUES ('W1Q2QO','Risorse umane',now(), 'SYSTEM', now(), 'SYSTEM', (select ente_id from cpass_t_ente where ente_codice ='CMTO'));
INSERT INTO cpass.cpass_t_ufficio (ufficio_codice, ufficio_descrizione,data_creazione, utente_creazione, data_modifica, utente_modifica,  ente_id) VALUES ('W282BR','Finanza e Patrimonio',now(), 'SYSTEM', now(), 'SYSTEM', (select ente_id from cpass_t_ente where ente_codice ='CMTO'));
INSERT INTO cpass.cpass_t_ufficio (ufficio_codice, ufficio_descrizione,data_creazione, utente_creazione, data_modifica, utente_modifica,  ente_id) VALUES ('W49ZYL','Performance, Innovazione, ICT',now(), 'SYSTEM', now(), 'SYSTEM', (select ente_id from cpass_t_ente where ente_codice ='CMTO'));
INSERT INTO cpass.cpass_t_ufficio (ufficio_codice, ufficio_descrizione,data_creazione, utente_creazione, data_modifica, utente_modifica,  ente_id) VALUES ('XNJMHF','DIREZIONE GENERALE Pianificazione, programmazione e controllo strategico',now(), 'SYSTEM', now(), 'SYSTEM', (select ente_id from cpass_t_ente where ente_codice ='CMTO'));
INSERT INTO cpass.cpass_t_ufficio (ufficio_codice, ufficio_descrizione,data_creazione, utente_creazione, data_modifica, utente_modifica,  ente_id) VALUES ('Z3N82Q','Dipartimento Ambiente e vigilanza ambientale',now(), 'SYSTEM', now(), 'SYSTEM', (select ente_id from cpass_t_ente where ente_codice ='CMTO'));
INSERT INTO cpass.cpass_t_ufficio (ufficio_codice, ufficio_descrizione,data_creazione, utente_creazione, data_modifica, utente_modifica,  ente_id) VALUES ('ZMFNP8','Urbanistica e copianificazione',now(), 'SYSTEM', now(), 'SYSTEM', (select ente_id from cpass_t_ente where ente_codice ='CMTO'));

INSERT INTO cpass.cpass_r_ufficio_settore (ufficio_id, settore_id, data_validita_inizio)
SELECT ufficio.ufficio_id, settore.settore_id, now()
FROM (VALUES
		('SA0'	,'0CWI00'),	
		('SA1'	,'0E175J'),	
		('UA0'	,'0ZIRBV'),	
		('SA31' , '422Z7M'),	
		('SA4'	,'912Q7N'),	
		('UA41' , 'DJN7N5'),	
		('SA3'	,'JEV1NU'),	
		('TA01' , 'K31IU4'),	
		('VA0'	,'MG3061'),	
		('RA51' , 'R54BIF'),	
		('SA01' , 'TWNJQH'),	
		('QA4'	,'W1Q2QO'),	
		('QA3'	,'W282BR'),	
		('QA1'	,'W49ZYL'),	
		('A50'	,'XNJMHF'),	
		('TA'	,'Z3N82Q'),	
		('TA0'	,'Z3N82Q'),	
		('UA01' , 'ZMFNP8')
) AS tmp(settore_codice, ufficio_codice)
JOIN cpass_t_settore settore on settore.settore_codice = tmp.settore_codice
join cpass_t_ufficio ufficio on ufficio.ufficio_codice = tmp.ufficio_codice
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ufficio_settore tu
	WHERE tu.ufficio_id = ufficio.ufficio_id
	and   tu.settore_id = settore.settore_id
);

delete from cpass_r_ufficio_settore 
where settore_id = (select settore_id from cpass_t_settore where settore_codice = 'SA3')
and  ufficio_id = (select ufficio_id from cpass_t_ufficio where ufficio_codice = '912Q7N');

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('VISTO_RAGIONERIA'                 , 'false', true, 'PBA', 'CPASS', 'visto ragioneria','CMTO')
 ,('GESTIONE_ACQUISTO_VERS_DEFINITIVA', 'false',TRUE, 'PBA', 'CPASS', 'acq vers definitiva','CMTO')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);