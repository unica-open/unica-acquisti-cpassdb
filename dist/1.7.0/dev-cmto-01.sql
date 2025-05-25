---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
---
-- DEV-CMTO-01

INSERT INTO cpass.cpass_t_ente (ente_id, ente_denominazione, ente_codice_fiscale, codice_ipa_amministrazione, 
dipartimento, ufficio, regione,
  provincia, indirizzo, telefono, email, emailpec, ente_codice, data_creazione, utente_creazione, data_modifica, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value::uuid, tmp.ente_denominazione), tmp.ente_denominazione, tmp.ente_codice_fiscale, tmp.codice_ipa_amministrazione,
  tmp.dipartimento, tmp.ufficio, tmp.regione, tmp.provincia, tmp.indirizzo, tmp.telefono, tmp.email, tmp.emailpec, tmp.ente_codice, now(), 'SYSTEM', now(), 'SYSTEM'
FROM (VALUES
  ('CITTA'' METROPOLITANA DI TORINO', '01907990012', '', '', '', 'PIEMONTE', 'TORINO', 'CORSO INGHILTERRA 7, TORINO', '', '', '', 'CMTO')
) AS tmp(ente_denominazione, ente_codice_fiscale, codice_ipa_amministrazione, dipartimento, ufficio, regione, provincia, indirizzo, telefono, email, emailpec, ente_codice)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_ente')
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_ente current
  WHERE current.ente_denominazione = tmp.ente_denominazione
);


INSERT INTO cpass.cpass_r_ruolo_modulo (ruolo_modulo_id,ruolo_id ,modulo_id ,ente_id )
SELECT 
	 tmp.ruolo_modulo_id
    ,tmp.ruolo_id 
    ,tmp.modulo_id
    ,te.ente_id
FROM (VALUES
(1, 2, 1,'CMTO'),
(2, 1, 1,'CMTO'),
(3, 3, 1,'CMTO'),
(4, 4, 1,'CMTO'),
(8, 5, 1,'CMTO'),
(9, 6, 1,'CMTO'),
(14, 7, 2,'CMTO'),
(15, 8, 2,'CMTO'),
(16, 9, 2,'CMTO'),
(17, 10, 2,'CMTO'),
(18, 6, 2,'CMTO'),
(19, 14, 1,'CMTO'),
(20, 15, 1,'CMTO'),
(21, 13, 2,'CMTO'),
(22, 6, 4,'CMTO'),
(23, 16, 4,'CMTO'),
(24, 17, 4,'CMTO'),
(25, 18, 5,'CMTO'),
(26, 6, 3,'CMTO'),
(27, 19, 3,'CMTO'),
(28, 19, 3,'CMTO'),
(29, 20, 3,'CMTO'),
(30, 21, 3,'CMTO'),
(31, 22, 3,'CMTO'),
(32, 23, 2,'CMTO'),
(33, 24, 5,'CMTO')

)AS tmp(ruolo_modulo_id,ruolo_id ,modulo_id,ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_r_ruolo_modulo ts
  WHERE 
  
      ts.ruolo_id = tmp.ruolo_id
  AND ts.modulo_id = tmp.modulo_id
  AND ts.ente_id = te.ente_id
);

--select * from  cpass.cpass_d_tipo_settore;

delete from cpass_d_tipo_settore;
delete from cpass.cpass_t_settore;

INSERT INTO cpass.cpass_d_tipo_settore
(tipo_settore_id, tipo_settore_codice, tipo_settore_descrizione, flag_direzione, flag_utilizzabile, ente_id)
VALUES(nextval('cpass_d_tipo_settore_tipo_settore_id_seq'), 'DG', 'DIREZIONE GENERALE', true, true, '0ced449c-a147-5419-802f-01acfab32807');

INSERT INTO cpass.cpass_d_tipo_settore
(tipo_settore_id, tipo_settore_codice, tipo_settore_descrizione, flag_direzione, flag_utilizzabile, ente_id)
VALUES(nextval('cpass_d_tipo_settore_tipo_settore_id_seq'), 'SG', 'SEGRETERIA GENERALE', true, true, '0ced449c-a147-5419-802f-01acfab32807');

INSERT INTO cpass.cpass_d_tipo_settore
(tipo_settore_id, tipo_settore_codice, tipo_settore_descrizione, flag_direzione, flag_utilizzabile, ente_id)
VALUES(nextval('cpass_d_tipo_settore_tipo_settore_id_seq'), 'US', 'UNITÀ SPECIALIZZATA DI LIVELLO NON DIRIGENZIALE', true, true, '0ced449c-a147-5419-802f-01acfab32807');

INSERT INTO cpass.cpass_d_tipo_settore
(tipo_settore_id, tipo_settore_codice, tipo_settore_descrizione, flag_direzione, flag_utilizzabile, ente_id)
VALUES(nextval('cpass_d_tipo_settore_tipo_settore_id_seq'), 'AR', 'AREA', true, true, '0ced449c-a147-5419-802f-01acfab32807');

INSERT INTO cpass.cpass_d_tipo_settore
(tipo_settore_id, tipo_settore_codice, tipo_settore_descrizione, flag_direzione, flag_utilizzabile, ente_id)
VALUES(nextval('cpass_d_tipo_settore_tipo_settore_id_seq'), 'SE', 'SERVIZIO', true, true, '0ced449c-a147-5419-802f-01acfab32807');

INSERT INTO cpass.cpass_d_tipo_settore
(tipo_settore_id, tipo_settore_codice, tipo_settore_descrizione, flag_direzione, flag_utilizzabile, ente_id)
VALUES(nextval('cpass_d_tipo_settore_tipo_settore_id_seq'), 'DS', 'DIREZIONE DI SUPPORTO', true, true, '0ced449c-a147-5419-802f-01acfab32807');

INSERT INTO cpass.cpass_d_tipo_settore
(tipo_settore_id, tipo_settore_codice, tipo_settore_descrizione, flag_direzione, flag_utilizzabile, ente_id)
VALUES(nextval('cpass_d_tipo_settore_tipo_settore_id_seq'), 'DP', 'DIREZIONE DI INTEGRAZIONE DI PROCESSO', true, true, '0ced449c-a147-5419-802f-01acfab32807');

INSERT INTO cpass.cpass_d_tipo_settore
(tipo_settore_id, tipo_settore_codice, tipo_settore_descrizione, flag_direzione, flag_utilizzabile, ente_id)
VALUES(nextval('cpass_d_tipo_settore_tipo_settore_id_seq'), 'DI', 'DIPARTIMENTO', true, true, '0ced449c-a147-5419-802f-01acfab32807');

INSERT INTO cpass.cpass_d_tipo_settore
(tipo_settore_id, tipo_settore_codice, tipo_settore_descrizione, flag_direzione, flag_utilizzabile, ente_id)
VALUES(nextval('cpass_d_tipo_settore_tipo_settore_id_seq'), 'DL', 'DIREZIONE DI LINEA', true, true, '0ced449c-a147-5419-802f-01acfab32807');

INSERT INTO cpass.cpass_d_tipo_settore
(tipo_settore_id, tipo_settore_codice, tipo_settore_descrizione, flag_direzione, flag_utilizzabile, ente_id)
VALUES(nextval('cpass_d_tipo_settore_tipo_settore_id_seq'), 'FS', 'FUNZIONE SPECIALIZZATA', true, true, '0ced449c-a147-5419-802f-01acfab32807');

INSERT INTO cpass.cpass_d_tipo_settore
(tipo_settore_id, tipo_settore_codice, tipo_settore_descrizione, flag_direzione, flag_utilizzabile, ente_id)
VALUES(nextval('cpass_d_tipo_settore_tipo_settore_id_seq'), 'CM', 'CITTA'' METROPOLITANA DI TORINO', true, true, '0ced449c-a147-5419-802f-01acfab32807');

 
--select * from  cpass.cpass_t_settore;

INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, ente_id, tipo_settore_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM'
FROM (VALUES
	('CMTO','CITTA'' METROPOLITANA DI TORINO','CM','CMTO'))
AS tmp(codice, descrizione,tipo, ente)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_settore')
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente
JOIN cpass.cpass_d_tipo_settore dts ON dts.tipo_settore_codice = tmp.tipo
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore ts
  WHERE ts.settore_codice = tmp.codice
  AND ts.ente_id = te.ente_id
);
	 
INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, 
settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica, data_creazione, data_cancellazione)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, 
ts1.settore_id, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM', tmp.data_inizio, tmp.data_fine
FROM (VALUES
('AA','AREA RELAZIONI E COMUNICAZIONE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('BA','AREA ISTITUZIONALE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('DA','AREA RISORSE UMANE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('EA','AREA RISORSE FINANZIARIE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('FA','AREA PATRIMONIO E SERVIZI INTERNI','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('HE','AREA LAVORI PUBBLICI','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('IA','AREA TERRITORIO, TRASPORTI E PROTEZIONE CIVILE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('LB','AREA SVILUPPO SOSTENIBILE E PIANIFICAZIONE AMBIENTALE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('LC','AREA RISORSE IDRICHE E QUALITA'' DELL''ARIA','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03 ','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('MD','AREA ATTIVITA'' PRODUTTIVE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-3','YYYY-MM-DD'))
)AS tmp(codice, descrizione,tipo,codice_padre,ente,data_inizio,data_fine)
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

INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, 
settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica, data_creazione, data_cancellazione)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, 
ts1.settore_id, 
te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM', tmp.data_inizio, tmp.data_fine
FROM (VALUES
        ('AA7','COMUNICAZIONE ISTITUZIONALE, INFORMAZIONE E RELAZIONI INTERNE ED ESTERNE','SE','AA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('AAA','RELAZIONI E PROGETTI EUROPEI E INTERNAZIONALI','SE','AA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('BA2','PRESIDENTE E GIUNTA','SE','BA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-3','YYYY-MM-DD')),
        ('BA3','STAFF AL SEGRETARIO GENERALE E DOCUMENTAZIONE','SE','BA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('DA3','SVILUPPO RISORSE UMANE','SE','DA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('DA6','ACQUISIZIONE E GESTIONE RISORSE UMANE, SERVIZI SOCIALI AI DIPENDENTI','SE','DA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('EA3','FINANZE, TRIBUTI E STATISTICA','SE','EA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('EA4','ECONOMATO E LIQUIDITA''','SE','EA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FA3','LOGISTICA','SE','FA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FA5','PATRIMONIO','SE','FA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FAB','SERVIZI GENERALI','SE','FA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FAC','CQUISTI E PROVVEDITORATO','SE','FA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE0','DIREZIONE AREA LAVORI PUBBLICI','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE2','CONCESSIONI E APPROVVIGIONAMENTI','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE3','IMPIANTI TECONOLOGICI E GESTIONE ENERGIA','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE4','EDILIZIA SCOLASTICA 1','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE5','EDILIZIA SCOLASTICA 2','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE7','VIABILITA'' 1','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE8','VIABILITA'' 2','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03 ','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE9','VIABILITA'' 3','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),

        ('IA8','TRASPORTI','SE','IA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('IAG','PIANIFICAZIONE E GESTIONE RETE ECOLOGICA E AREE PROTETTE, VIGILANZA AMBIENTALE','SE','IA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-3','YYYY-MM-DD')),
        ('LB7','PINAIFICAZIONE E GESTIONE RIFIUTI, BONIFICHE, SOSTENIBILITA'' AMBIENTALE','SE','LB','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),

        ('LC6','DIFESA DEL SUOLO E ATTIVITA'' ESTRATTIVA','SE','LB','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('MD3','PROGRAMMAZIONE ATTIVITA'' PRODUTTIVE E CONCERTAZIONE TERRITORIALE','SE','MD','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('MD4','AGRICOLTURA','SE','MD','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('MD7','TUTELA DELLA FAUNA E DELLA FLORA','SE','MD','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD'))

)AS tmp(codice, descrizione,tipo,codice_padre,ente,data_inizio,data_fine)
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





INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, ts1.settore_id, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM'
FROM (VALUES
('A50','DIREZIONE GENERALE, PIANIFICAZIONE, PROGRAMMAZIONE E CONTROLLO STRATEGICO','DG','CMTO','CMTO')
)AS tmp(codice, descrizione,tipo,codice_padre, ente)
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

INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, ts1.settore_id, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM'
FROM (VALUES
('A00','SEGRETERIA GENERALE','SG','CMTO','CMTO')
)AS tmp(codice, descrizione,tipo,codice_padre, ente)
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


INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, ts1.settore_id, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM'
FROM (VALUES
 ('A51','AVVOCATURA','US','A00','CMTO'),
 ('A52','SERVIZIO PREVENZIONE E PROTEZIONE','US','A50','CMTO'),
 ('A53','AUDIT; CONTROLLO DI GESTIONE','US','A50','CMTO'),
 ('QA1','PERFORMANCE, INNOVAZIONE, ICT','DS','A50','CMTO'),
 ('A55','POLIZIA METROPOLITANA'        ,'US','A50','CMTO'),    
 ('QA3','FINANZA E PATRIMONIO','DS','A50','CMTO'),
 ('QA4','RISORSE UMANE','DS','A50','CMTO'),
 ('QA5','COMUNICAZIONE E RAPPORTI CON I CITTADINI E I TERRITORI','DS','A50','CMTO'),
 ('QA6','ORGANIZZAZIONE','DS','A50','CMTO'),
 ('RA1','INTEGRAZIONE PROCESSI FINANZIARI E CONTABILI','DP','A50','CMTO'),
 ('RA2','PROGRAMMAZIONE E MONITORAGGIO OO.PP. BENI E SERVIZI','DP','A50','CMTO'),
 ('RA3','CENTRALE UNICA APPALTI E CONTRATTI','DP','A50','CMTO'),
 ('RA4','FLUSSI INFORMATIVI','DP','A50','CMTO'),
 ('RA5','AZIONI INTEGRATE CON GLI EE.LL.','DP','A50','CMTO'),
 ('SA','DIPARTIMENTO SVILUPPO ECONOMICO','DI','A50','CMTO'),
 ('TA','DIPARTIMENTO AMBIENTE E VIGILANZA AMBIENTALE','DI','A50','CMTO'),
 ('UA','DIPARTIMENTO TERRITORIO, EDILIZIA E VIABILITA''','DI','A50','CMTO'),
 ('VA','DIPARTIMENTO EDUCAZIONE E WELFARE','DI','A50','CMTO')
)AS tmp(codice, descrizione,tipo,codice_padre,ente)
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

INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice)
, tmp.codice
, tmp.descrizione
, ts1.settore_id
, te.ente_id
, dts.tipo_settore_id
, 'SYSTEM'
, 'SYSTEM'
FROM (VALUES
    ('RA51','TUTELA DEL TERRITORIO','FS','RA5','CMTO'),
    ('SA0' ,'DIREZIONE DIPARTIMENTO SVILUPPO ECONOMICO','DL','SA','CMTO'),
    ('SA01','PROGETTI E PROGRAMMI EUROPEI ED INTERNAZIONALI','FS','SA0','CMTO'),
    ('SA1','SERVIZI ALLE IMPRESE, SPL E PARTECIPAZIONI','DL','SA','CMTO'),
    ('SA2','ATTIVITA'' PRODUTTIVE','DL','SA','CMTO'),
    ('SA3','SVILUPPO RURALE E MONTANO','DL','SA','CMTO'),
    ('SA31','TUTELA FLORA E FAUNA','FS','SA3','CMTO'),
    ('TA0','DIREZIONE DIPARTIMENTO AMBIENTE E VIGILANZA AMBIENTALE','DL','TA','CMTO'),
    ('TA01','VALUTAZIONI AMBIENTALI','FS','TA0','CMTO'),     --????
    ('TA1','RIFIUTI, BONIFICHE E SICUREZZA SITI PRODUTTIVI','DL','TA','CMTO'),
    ('TA2','RISORSE IDRICHE E TUTELA DELL''ATMOSFERA','DL','TA','CMTO'),
    ('TA3','SISTEMI NATURALI','DL','TA','CMTO'),
    ('UA0','DIREZIONE DIPARTIMENTO TERRITORIO, EDILIZIA E VIABILITA''','DL','UA','CMTO'),
    ('UA01','URBANISTICA E COPIANIFICAZIONE','FS','UA0','CMTO'),
    ('UA3','COORDINAMENTO VIABILITA''-VIABILITA'' 1','DL','UA','CMTO'),
    ('UA4','VIABILITA'' 2','DL','UA','CMTO'),
    ('UA41','PROTEZIONE CIVILE','FS','UA4','CMTO'),
    ('UA5','COORDINAMENTO EDILIZIA-EDILIZIA SCOLASTICA 1','DL','UA','CMTO'),
    ('UA6','EDILIZIA SCOLASTICA 2','DL','UA','CMTO'),
    ('VA0','DIREZIONE DIPARTIMENTO "EDUCAZIONE E WELFARE"','DL','VA','CMTO'),
    ('VA1','AMMINISTRAZIONE, MONITORAGGIO E CONTROLLI','DL','VA','CMTO'),
    ('VA2','FORMAZIONE PROFESSIONALE E ORIENTAMENTO','DL','VA','CMTO')
    
)AS tmp(codice, descrizione,tipo,codice_padre,ente)
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

INSERT INTO cpass.cpass_t_ente_logo VALUES (1, 'Logo', './image001.png');        



--DA FARE
--INSERT INTO cpass.cpass_t_ord_sezione VALUES (2, '100', 'SEZIONE ACQUISTI E PROVVEDITORATO', '0ced449c-a147-5419-802f-01acfab32807', '2021-05-27 00:00:00', 'admin', '2021-05-27 00:00:00', 'admin', NULL, NULL, '9e27ef73-c31e-49e9-89e0-4b46a84ac593', 'bfaa1bf7-c1cb-53dd-80c7-cd4b8d8859aa');
delete from cpass_d_provvedimento_tipo;
INSERT INTO cpass.cpass_d_provvedimento_tipo VALUES (1, '1',  'DELIBERA', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_d_provvedimento_tipo VALUES (2, 'DD', 'Determina Dirigenziale', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_d_provvedimento_tipo VALUES (3, '32', 'DETERMINAZIONE 01/07/1999 DECRETO DIRIGENTE', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_d_provvedimento_tipo VALUES (4, '521', 'DECRETO DEL SINDACO METROPOLITANO', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_d_provvedimento_tipo VALUES (5, '522', 'DELIBERA DEL CONSIGLIO METROPOLITANO', '0ced449c-a147-5419-802f-01acfab32807');


ALTER TABLE cpass.cpass_t_provvedimento
  ALTER COLUMN provvedimento_descrizione TYPE VARCHAR(2000);
  
ALTER TABLE cpass.cpass_t_provvedimento
  ALTER COLUMN provvedimento_oggetto TYPE VARCHAR(2000) ;  
  
ALTER TABLE cpass.cpass_t_ord_testata_ordine
  ALTER COLUMN provvedimento_descrizione TYPE VARCHAR(2000) COLLATE pg_catalog."default";
		 
delete from cpass.cpass_t_provvedimento;
INSERT INTO cpass.cpass_t_provvedimento (provvedimento_anno,provvedimento_numero,
provvedimento_descrizione,provvedimento_tipo_id,
ente_id,settore_id,data_creazione,data_modifica,data_validita_inizio)
SELECT tmp.anno,tmp.numero,tmp.descrizione,t.provvedimento_tipo_id,
EN.ente_id
,ts.settore_id
,tmp.data_creazione,tmp.data_modifica,tmp.data_validita_inizio
FROM (VALUES
(2019,651,'EDIFICI SCOLASTICI ED EDIFICI PATRIMONIALI VARI. VERIFICHE PERIO- DICHE BIENNALI SUGLI IMPIANTI ASCENSORI E MONTACARICHI. AFFIDA- MENTO ALLA SOCIETA'' INSPECTA S.R.L.  -  CIG Z3426AA477 (U.I. EURO 17.513,10)','32','CMTO','UA5',to_timestamp('11/01/2019','dd/MM/yyyy'), to_timestamp('11/01/2019','dd/MM/yyyy'), to_timestamp('01/02/2019','dd/MM/yyyy')), 
(2019,972,'INDENNITA'' DI PERSENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/2/2002 E DALLA D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/5/2004. PRIMO IMPEGNO  DI SPESA PER COMMISSIONI ANNO 2019. ACCERTAMENTO DALLE PROVINCE E VAL D''AOSTA PER ESAMI.(E/A EURO 5.968,82 - U/PR EURO 2.614,54)','32','CMTO','UA2',to_timestamp('24/01/2019','dd/MM/yyyy'), to_timestamp('19/03/2019','dd/MM/yyyy'), to_timestamp('13/03/2019','dd/MM/yyyy')), 
(2019,1465,'SITO EX IL CAT, BORGARO T.SE. APPROVAZIONE E AFFIDAMENTO SERVIZIO DI MONITORAGGIO E PROVE BIOGAS ALLA SOCIETA'' ENVIARS S.R.L. (CIG Z26270BD85)  (U.I. EURO 21.472,00=)','32','CMTO','UA3',to_timestamp('06/02/2019','dd/MM/yyyy'), to_timestamp('11/06/2019','dd/MM/yyyy'), to_timestamp('25/03/2019','dd/MM/yyyy')), 
(2017,1845,'INDENNITA'' DI PRESENZA AI COMPNENTI DELLE COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/2002 E DALLA D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/05/2004. PRIMO IMPEGNO DI SPESA PER COMMISSIONI ANNO 2017. ACCERTAMENTO DALLE PROVINCE PER ESAMI. (U./PR. EURO 2.514,55- E./A. EURO 4.739,83)','32','CMTO','IA8',to_timestamp('15/02/2017','dd/MM/yyyy'), to_timestamp('26/02/2019','dd/MM/yyyy'), to_timestamp('20/03/2017','dd/MM/yyyy')), 
(2019,1888,'NOLEGGIO FOTOCOPIATORI OLIVETTI D-COPIA 5000MF - CONSIP 26 LOTTO 3 - PRODUTTIVITA'' MEDIA - CIG DERIVATO 725470866D. RETTIFICA PER ERRORE MATERIALE.','32','CMTO','RA3',to_timestamp('19/02/2019','dd/MM/yyyy'), to_timestamp('03/07/2019','dd/MM/yyyy'), to_timestamp('07/03/2019','dd/MM/yyyy')), 
(2019,2039,'SERVIZI FINALIZZATI ALLE RIPARAZIONI DECENTRATE DI MEZZI MECCANI CI ED ATTREZZATURE COMPRESE REVISIONI VARIE. AUTORIZZAZIONE E PRENOTAZIONE DI SPESA PER L''ANNO 2019. ( U.PR. EURO 15.000,00 )','32','CMTO','UA3',to_timestamp('22/02/2019','dd/MM/yyyy'), to_timestamp('21/06/2019','dd/MM/yyyy'), to_timestamp('11/03/2019','dd/MM/yyyy')), 
(2019,2141,'RDO 2105060 SUL MEPA - SERVIZI DI COMUNICAZIONE DEL PIANO  INTEGRATO TERRITORIALE GRAIES LAB PER IL PERIODO 2019-2022 CIG. ZB92583AEC - CUP J19F18000830005. AGGIUDICAZIONE DEFINITIVA  A LIGURIA DIGITALE SPA. (U.S. ANNI 2019-2022 EURO 38.552,00=)','32','CMTO','QA5',to_timestamp('26/02/2019','dd/MM/yyyy'), to_timestamp('08/11/2019','dd/MM/yyyy'), to_timestamp('06/03/2019','dd/MM/yyyy')), 
(2019,2142,'RDO 2106556 SUL MEPA - SERVIZI DI COMUNICAZIONE DEL PIANO  INTEGRATO TERRITORIALE LE ALTE VALLI - CUORE DELLE ALPI PER IL  PERIODO 2019-2022. CIG Z292586096 - CUP J19F18000840005. AGGIUDICAZIONE DEFINITIVA A LIGURIA DIGITALE SPA. (U.S. ANNI 2019-2022 EURO 38.942,40=)','32','CMTO','QA5',to_timestamp('26/02/2019','dd/MM/yyyy'), to_timestamp('18/11/2019','dd/MM/yyyy'), to_timestamp('06/03/2019','dd/MM/yyyy')), 
(2019,2143,'RDO 2106980 SUL MEPA - SERVIZI DI COMUNICAZIONE SOCIAL DEL PIANO  INTEGRATO TERRITORIALE LE ALTE VALLI - CUORE DELLE ALPI PER IL  PERIODO 2019-2022. CIG Z1B2586894 - CUP J19F18000840005. AGGIUDICAZIONE DEFINITIVA A LIGURIA DIGITALE SPA. (U.S. ANNI 2019-2022 EURO 21.276,80=)','32','CMTO','QA5',to_timestamp('26/02/2019','dd/MM/yyyy'), to_timestamp('25/11/2019','dd/MM/yyyy'), to_timestamp('06/03/2019','dd/MM/yyyy')), 
(2019,2245,'EDIFICI SCOLASTICI DELLA ZONA A. INTERVENTI DI MANUTENZIONE ORDI- NARIA DEGLI IMPIANTI ELETTRICI. AFFIDAMENTO LAVORI IN ECONOMIA A  SAMET S.R.L.  - CIG ZAE276FA1A (U.I. EURO 48459,96 - U.PR. EURO 794,43)','32','CMTO','UA5',to_timestamp('28/02/2019','dd/MM/yyyy'), to_timestamp('28/02/2019','dd/MM/yyyy'), to_timestamp('12/03/2019','dd/MM/yyyy')), 
(2019,2336,'PIANO TERRITORIALE INTEGRATO GRAIES LAB. PROCEDURA NEGOZIATA  TELEMATICA TRAMITE R.D.O. SUL MEPA. APPROVAZIONE CAPITOLATO  D''ONERI PER L''AFFIDAMENTO DEL SERVIZIO DI ASSISTENZA TECNICA PER  IL PERIODO 2019-2022. (E.A. 2019-2022 EURO 45.140,00= U.PR. 2019-2022 EURO 45.140,00=)','32','CMTO','QA5',to_timestamp('04/03/2019','dd/MM/yyyy'), to_timestamp('29/11/2019','dd/MM/yyyy'), to_timestamp('12/03/2019','dd/MM/yyyy')), 
(2019,2356,'EDIFICI SCOLASTICI DELLA ZONA B. INTERVENTI DI MANUTENZIONE  ORDINARIA DEGLI IMPIANTI ELETTRICI. AFFIDAMENTO LAVORI IN ECONO- MIA A SAMET S.R.L.   - CIG Z30276FA75 (U.I. EURO 48.339,94 - U/PR EURO 792,46)','32','CMTO','UA5',to_timestamp('04/03/2019','dd/MM/yyyy'), to_timestamp('04/03/2019','dd/MM/yyyy'), to_timestamp('12/03/2019','dd/MM/yyyy')), 
(2019,2402,'PROGETTO ALCOTRA 2014-2020 PITER COEUR''ALP PROGETTO N. 3926  COEUR SOLIDAIRE SERVIZI DI SUPPORTO PER L''ATTIVITA'' DI COORDINA MENTO GESTIONE E ANIMAZIONE DEL PROGETTO AUTORIZZAZIONE ALL''INDI ZIONE DI UNA PROCEDURA NEGOZIATA SU MEPA E PRENOTAZIONE IMPEGNO CUP N. J79F1800093007 CIG. N. ZCD273448A E/A-U/PR= EURO 35.014,00','32','CMTO','SA3',to_timestamp('06/03/2019','dd/MM/yyyy'), to_timestamp('14/10/2019','dd/MM/yyyy'), to_timestamp('25/03/2019','dd/MM/yyyy')), 
(2019,2403,'CONVENZIONE 2016-2020 PER LA GESTIONE DEL SERVIZIO DI TESORERIA DELLA CITTA'' METROPOLITANA DI TORINO.  IMPUTAZIONE ONERI DI TESORERIA ANNO 2019. CIG. 6600893D36 (U.PR. EURO 8.540,00.=) ( U.PR. EURO 91.460,00=)','32','CMTO','QA3',to_timestamp('06/03/2019','dd/MM/yyyy'), to_timestamp('08/04/2019','dd/MM/yyyy'), to_timestamp('13/03/2019','dd/MM/yyyy')), 
(2019,2724,'SERVIZIO DI GESTIONE MANUTENTIVA DEGLI IMPIANTI ASCENSORI PRESSO  EDIFICI SEDI DI UFFICI DI COMPETENZA PER IL PERIODO 2? SEMESTRE  2018 - 1? SEMESTRE 2022. INTEGRAZIONE DI IMPEGNI PER L''ANNO 2021. (U.I EURO 23.342,72 - U.PR.  EURO 814,40)','32','CMTO','UA5',to_timestamp('13/03/2019','dd/MM/yyyy'), to_timestamp('13/03/2019','dd/MM/yyyy'), to_timestamp('01/04/2019','dd/MM/yyyy')), 
(2019,2800,'SERVIZIO DI MANUTENZIONE DELL''UTENZA DI ACCESSO ALLA PIATTAFORMA WEB MT-X DI MONTE TITOLI S.P.A. PER L''ANNO 2019. CIG N. Z13276BF77. (U.I. - EURO 103,70)','32','CMTO','QA3',to_timestamp('14/03/2019','dd/MM/yyyy'), to_timestamp('12/12/2019','dd/MM/yyyy'), to_timestamp('21/03/2019','dd/MM/yyyy')), 
(2019,2975,'EDIFICI DI EDILIZA GENERALE.. INTERVENTI DI MANUTENZIONE  ORDINARIA DEGLI IMPIANTI ELETTRICI . AFFIDAMENTO LAVORI IN  ECONOMIA A TIELLE IMPIANTI S.R.L. - CIG Z6D279FCE1 (U.I. EURO 46.414,90 - U./PR. 760,90','32','CMTO','UA5',to_timestamp('19/03/2019','dd/MM/yyyy'), to_timestamp('19/03/2019','dd/MM/yyyy'), to_timestamp('01/04/2019','dd/MM/yyyy')), 
(2018,3199,'SERVIZIO ENERGETICO DEGLI EDIFICI DI PROPRIETA'' E DI COMPETENZA DELLA CITTA'' METROPOLITANA. RIDUZIONE E REIMPUTAZIONE IMPEGNI DI  SPESA.  (U.I.  EURO 29.713.404,60)','32','CMTO','HE3',to_timestamp('02/02/2018','dd/MM/yyyy'), to_timestamp('13/09/2018','dd/MM/yyyy'), to_timestamp('15/05/2018','dd/MM/yyyy')), 
(2018,3226,'NOLEGGIO FOTOCOPIATORI OLIVETTI 5000MF PRODUTTIVITA'' MEDIA - CONSIP 26 LOTTO 3 - IMPEGNI ANNO 2020. CIG DERIVATO 725470866D. (U.I. EURO 40.992,00).','32','CMTO','FAC',to_timestamp('05/02/2018','dd/MM/yyyy'), to_timestamp('21/10/2016','dd/MM/yyyy'), to_timestamp('24/08/2018','dd/MM/yyyy')), 
(2018,3229,'NOLEGGIO FOTOCOPIATORI OLIVETTI 5000MF PRODUTTIVITA'' BASSA CONSIP 26 LOTTO 3 - IMPEGNI ANNO 2020. CIG DERIVATO 7254788871. (U.I. EURO 5.709,96).','32','CMTO','FAC',to_timestamp('05/02/2018','dd/MM/yyyy'), to_timestamp('05/12/2016','dd/MM/yyyy'), to_timestamp('16/05/2018','dd/MM/yyyy')), 
(2018,3230,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/202 E DALLA  D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/05/2004. PRIMO IMPEGNO DI SPESA PER COMMISSIONI ANNO 2018. ACCERTAMENTO DALLE PROVINCE E VAL D''AOSTA PER ESAMI. (E./A. EURO 4.118,97-U./PR. EURO 3.963,58)','32','CMTO','IA8',to_timestamp('05/02/2018','dd/MM/yyyy'), to_timestamp('04/03/2019','dd/MM/yyyy'), to_timestamp('14/03/2018','dd/MM/yyyy')), 
(2019,3471,'SERVIZI DI PULIZIA E IGIENE AMBIENTALE AFFIDATI A MANITAL SOCIETA CONSORTILE PER I SERVIZI INTEGRATI. PROROGA TECNICA PER IL  PERIODO APRILE 2019 - MAGGIO 2019. CIG DERIVATO 348422054C U.I. EURO 92.054,25 - U. PR. EURO 6.880,00','32','CMTO','RA3',to_timestamp('27/03/2019','dd/MM/yyyy'), to_timestamp('24/07/2019','dd/MM/yyyy'), to_timestamp('29/03/2019','dd/MM/yyyy')), 
(2019,3894,'SERVIZIO MANUTENZIONE PARCHI, RISERVE NATURALI E SITI RETE NATURA 2000 (Z.S.C.) ZONA NORD DEL TERRITORIO CITTA'' METROPOLITANA. AF- FIDAMENTO ALLA DITTA HORTILUS E VIVAI S.R.L. DI COLLERETTO GIACO- SA (TO). IMPEGNO DI SPESA PER L''ANNO 2019. (CIG Z1E257E6FC) (U.I. EURO 35.815,45)','32','CMTO','TA3',to_timestamp('05/04/2019','dd/MM/yyyy'), to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('03/05/2019','dd/MM/yyyy')), 
(2019,3904,'PIANO INTEGRATO TERRITORIALE ALCOTRA GRAIES LAB - SERVIZIO DI SUPPORTO ALLA GESTIONE FINANZIARIA. AFFIDAMENTO PREVIA TRATTATIVA DIRETTA MEPA - CUP. J19F18000830005 - CIG. Z5627DD6EA  (E.A./U.I. ANNI 2019-2022 EURO 12.180,48=)','32','CMTO','QA5',to_timestamp('05/04/2019','dd/MM/yyyy'), to_timestamp('29/11/2019','dd/MM/yyyy'), to_timestamp('23/04/2019','dd/MM/yyyy')), 
(2019,3931,'PROGETTAZIONE INTERVENTI RELATIVI AL PRIMO PROGRAMMA OPERATIVO  DEL PIANO DI GESTIONE SEDIMENTI DEL TORRENTE ORCO-COMUNI VARI. ACCERTAMENTO ED IMPEGNO FONDI. APPROVAZIONE CONTRATTO DI RICERCA TRA C.M. E POLITECNICO DI TORINO-DIATI PER ATTIVITA'' DI SUPPORTO  CUP J76C18000260002-CIG 7869513F8D (EA-UI-PR EURO 232.500,00)','32','CMTO','RA5',to_timestamp('08/04/2019','dd/MM/yyyy'), to_timestamp('04/06/2019','dd/MM/yyyy'), to_timestamp('15/04/2019','dd/MM/yyyy')), 
(2019,4018,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO MEZZI OPERATIVI PER LA  M.O.  DELLE SP DI COMPETENZA DEL SERVIZIO VIABILITA'' 3. LOTTO 1 E LOTTO 2 PROCEDURA APERTA. APPROV. OPERAZ.DI GARA E AGGIUDICAZIONE DEFINITIVA A MILANO LUCA. (CIG LOTTO 1 7627715D88-CIG LOTTO 2  7627722352) (U.S. EURO 183.000,00)','32','CMTO','UA3',to_timestamp('09/04/2019','dd/MM/yyyy'), to_timestamp('01/07/2019','dd/MM/yyyy'), to_timestamp('22/07/2019','dd/MM/yyyy')), 
(2019,4154,'PROGRAMMA ALCOTRA 2014-2020.  SERVIZIO DI SUPPORTO ALLA GESTIONE  E RENDICONTAZIONE DEI PROGETTI RISKFOR (N.3824) E RISKGEST  (N. 3845) ALLA DOTT.SSA SUSANNE NILSSON    -    CIG  Z0227E292F (E.A. EURO 15.225,60/U.I. EURO 23.853,44)','32','CMTO','UA1',to_timestamp('12/04/2019','dd/MM/yyyy'), to_timestamp('25/10/2019','dd/MM/yyyy'), to_timestamp('10/05/2019','dd/MM/yyyy')), 
(2019,4296,'PIANO INTERVENTO TRIENNALE RAPPEZZATURA DELLA PAV. STRADALE PER MO DELLE SP DI COMPETENZA DEL S. VIABILITA'' 1. PROC. APERTA APPROVAZ. OPERAZIONI GARA E AGG. DEFINITIVA LOTTO 1 A SELVA MERCU RIO(CIG 76451587F5)-LOTTO2 A CITRINITI G. MASSIMO(CIG 76451777A3) LOTTO3 A CITRINITI G. M.(CIG 764519025F)US 585600,00-UI 73200,00','32','CMTO','UA3',to_timestamp('16/04/2019','dd/MM/yyyy'), to_timestamp('27/09/2019','dd/MM/yyyy'), to_timestamp('10/05/2019','dd/MM/yyyy')), 
(2019,4348,'PIANO DI INTERV.TRIENNALE DI MANUT.ORDINARIA DI MODESTA ENTITA'' DELLE SP DI COMPETENZA DEL SERVIZIO VIABILITA''1.LOTTO2-UO2-ZONA  OMOGENEA 11 PARTE DELLA ZONA OMOGENEA 3(AMT SUD).PROCEDURA APERTA APPROVAZ.OPERAZIONI DI GARA E AGGIUDICAZ DEFVA A  BUA COSTRUZIONI (PR 3585/18 CIG7639721136) (US EURO 234.240,00 UI EURO 29.280,00)','32','CMTO','UA3',to_timestamp('17/04/2019','dd/MM/yyyy'), to_timestamp('01/10/2019','dd/MM/yyyy'), to_timestamp('28/05/2019','dd/MM/yyyy')), 
(2019,4381,'PROGETTO ALCOTRA 2014-2020 PITER COEUR''ALP PROGETTO N. 3926  COEUR SOLIDAIRE. SERVIZI DI SUPPORTO PER L''ATTIVITA'' DI COORDI- NAMENTO, GESTIONE E ANIMAZIONE DEL PROGETTO. AFFIDAMENTO ALLA  DITTA QUESITE SRL VIA SANTA BARBARA 57 - BAGNOLO P.TE (CN) CIG ZCD273448A CUP J79F18000930007 U/S= EURO 27.836,13','32','CMTO','SA3',to_timestamp('17/04/2019','dd/MM/yyyy'), to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('09/05/2019','dd/MM/yyyy')), 
(2015,4968,'COMMISSIONE PROVINCIALE ESPROPRI - GETTONE DI PRESENZA DEI COMPO- NENTI.  COSTITUZIONE FONDO ECONOMALE PER L''ANNO 2015. (U/PR/2015 EURO 2.464,75 - U/PR/2015 IRAP 114,75)','32','CMTO','BA2',to_timestamp('19/02/2015','dd/MM/yyyy'), to_timestamp('18/03/2015','dd/MM/yyyy'), to_timestamp('14/09/2015','dd/MM/yyyy')), 
(2016,5154,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/2002 E DALLA  D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/05/2004. IMPEGNO DI  SPESA PER LE COMMISSIONI ANNO 2016. ACCERTAMENTO DALLA PROVINCE PER ESAMI (U./PR. EURO 7.629,93- E./A. EURO 7.650,97)','32','CMTO','IA8',to_timestamp('16/02/2016','dd/MM/yyyy'), to_timestamp('26/02/2019','dd/MM/yyyy'), to_timestamp('08/03/2016','dd/MM/yyyy')), 
(2019,5249,'SERVIZIO DI PULIZIA E IGIENE AMBIENTALE NEGLI EDIFICI SEDI DI 3 UFFICI DELL''ENTE PER UN PERIODO DI 36 MESI MEDIANTE SISTEMA  DINAMICO DI ACQUISIZIONE (SDAPA) - APPALTO SPECIFICO 1888297  CIG  7466043596 U.I. - U.S. EURO 915988,37','32','CMTO','RA3',to_timestamp('14/05/2019','dd/MM/yyyy'), to_timestamp('07/10/2019','dd/MM/yyyy'), to_timestamp('16/05/2019','dd/MM/yyyy')), 
(2019,5697,'VERIFICHE PERIODICHE DEGLI IMPIANTI DI MESSA A TERRA E PROTEZIONE SCARICHE ATMOSFERICHE EX D.P.R. 462/2001 PRESSO EDIFICI SCOLASTI CI DI COMPETENZA. AFFIDAMENTO DIRETTO A INSPECTA S.R.L.  (U.I. EURO 5.490,00) CIG  ZBB2887586','32','CMTO','UA5',to_timestamp('23/05/2019','dd/MM/yyyy'), to_timestamp('23/05/2019','dd/MM/yyyy'), to_timestamp('28/05/2019','dd/MM/yyyy')), 
(2019,5709,'AACORDO QUADRO PER LA GESTIONE DEL SERVIZIO DI PULIZIE  STRAORDINARIE, DISINFESTAZIONE, DERATTIZZAZIONE A BASSO IMPATTO  AMBIENTALE NEGLI EDIFICI SCOLASTICI DELLA CITTA'' METROPOLITANA DI TORINO. RDO 2016897. CIG 7572827E85 U.I. 63.646,00','32','CMTO','RA3',to_timestamp('23/05/2019','dd/MM/yyyy'), to_timestamp('07/10/2019','dd/MM/yyyy'), to_timestamp('28/05/2019','dd/MM/yyyy')), 
(2017,5763,'AFFIDAMENTO PER IL SERVIZIO DI ATTIVAZIONE/MODIFICA DI ALLACCIA- MENTO IDRICO IN COMUNE DI VIGONE, VIA TORINO 26 (PUNTO DI  RAGGRUPPAMENTO DEL CIRCOLO DI VIGONE) CIG Z3A1E2138C (U.I. EURO 297,00)','32','CMTO','HE8',to_timestamp('05/04/2017','dd/MM/yyyy'), to_timestamp('16/05/2017','dd/MM/yyyy'), to_timestamp('20/04/2017','dd/MM/yyyy')), 
(2019,5841,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO MEZZI OPERATIVI PER LA  MANUTENZIONE ORDINARIA DELLE SP DI COMPETENZA DEL SERVIZIO VIAB.3 PROCEDURA APERTA-APPROVAZIONE OPERAZIONI DI GARA E AGGIUDICAZIONE LOTTO 3(CIG 7627731ABD) E LOTTO 4(CIG 762773915A) A AIMO BOOT SRL (U.S. 122.000,00 - U.I. 61.000,00 - U.PR. 63.000,00)','32','CMTO','UA3',to_timestamp('27/05/2019','dd/MM/yyyy'), to_timestamp('15/10/2019','dd/MM/yyyy'), to_timestamp('05/06/2019','dd/MM/yyyy')), 
(2019,5956,'PIANO DI INTERV.TRIENNALE DI MANUT.ORD. DI MODESTA ENTITA'' DELLE  SP DI COMPETENZA DEL SERV.VIABILITA''1.LOTTO1-UO1 ZONA OMOGENEA 10 (CHIVASSESE),PARTE DELLA ZONA OMOG 4(AMT NORD).PROCEDURA APERTA APPROVAZ OPERAZ.DI GARA E AGGIUDICAZ DEFINITIVA A CO.E.STRA SRL (PR.3585/2018 CIG 76397118F3)(U.S EURO 234.240,00 UI E 29.280,00)','32','CMTO','UA3',to_timestamp('29/05/2019','dd/MM/yyyy'), to_timestamp('23/10/2019','dd/MM/yyyy'), to_timestamp('03/06/2019','dd/MM/yyyy')), 
(2019,6125,'PROGRAMMA ALCOTRA 2014-2020  PROGETTO RISK-GEST N. 3845 AFFIDAMENDO DEL SERVIZIO RELATIVO ALLA COSTRUZIONE DI UN PORTALE ON-LINE SULLE INFORMAZIONI STORICHE DI EVENTI IDROGEOLOGICI AL  C.N.R. I.R.P.I.      CIG  ZD028ADE04 (E.A. EURO 38.927,70/U.I. EURO 47.580,00)','32','CMTO','UA1',to_timestamp('03/06/2019','dd/MM/yyyy'), to_timestamp('04/11/2019','dd/MM/yyyy'), to_timestamp('12/06/2019','dd/MM/yyyy')), 
(2019,6144,'PIANO DI INTERV.TRIENNALE DI MANUT.ORD.DI MODESTA ENTITA'' DELLE  SP DI COMPETENZA DEL SERVIZIO VIABILITA'' 1.LOTTO3.UO3 ZONA  OMOGENEA2PARTE DELLA ZONA OMOGENEA3 E 4.PROCEDURA APERTA.APPROVAZ OPERAZ.DI GARA E AGGIUDICAZ.DEFINIVA A BUILDING&DESIGN2008 SRL. (PR.3585/18 CIG 7639865809).(US EURO234.240,00 UI EURO 29.280,00)','32','CMTO','UA3',to_timestamp('04/06/2019','dd/MM/yyyy'), to_timestamp('24/10/2019','dd/MM/yyyy'), to_timestamp('17/06/2019','dd/MM/yyyy')), 
(2019,6195,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO A CALDO DI MEZZI OPERAT PER LA MANUTENZ. ORD. DELLE SP DI COMPETENZA DEL SERV. VIAB. 2 - PROCED. APERTA APPROV. OPERAZIONI DI GARA E AGGIUDICAZIONE DEFIN. LOTTO 1 (CIG77912517B7) E LOTTO 2 (CIG 77912685BF) ALLA DITTA PASCHETTO SNC DI PASCHETTO ROBERTO. (U.S. EURO 183.000,00)','32','CMTO','UA4',to_timestamp('04/06/2019','dd/MM/yyyy'), to_timestamp('04/06/2019','dd/MM/yyyy'), to_timestamp('17/06/2019','dd/MM/yyyy')), 
(2019,6299,'RDO 2248060 - SERVIZIO DI ASSISTENZA TECNICA PER IL SUPPORTO AL COORDINAMENTO DEL PIANO INTEGRATO TERRITORIALE GRAIESLAB PER IL PERIODO 2019-2022. AFFIDAMENTO ALLA DITTA QUESITE S.R.L.  CUP N. J19F18000830005 - CIG N. ZC9278C756 (U.I.  ANNI 2019-2022 EURO 36.112,00=)','32','CMTO','QA5',to_timestamp('06/06/2019','dd/MM/yyyy'), to_timestamp('31/07/2019','dd/MM/yyyy'), to_timestamp('21/06/2019','dd/MM/yyyy')), 
(2019,6511,'INTERVENTI URGENTI DI MESSA IN SICUREZZA DEGLI IMPIANTI ELETTRICI PRESSO EDIFICI SCOLASTICI. AFFIDAMENTO LAVORI ALLA DITTA SAMET  S.R.L.  - C.I.G. ZC828BF541 (U.I. EURO 46.213,60 U./PR. EURO 757,60)','32','CMTO','UA5',to_timestamp('11/06/2019','dd/MM/yyyy'), to_timestamp('11/06/2019','dd/MM/yyyy'), to_timestamp('25/06/2019','dd/MM/yyyy')), 
(2019,6654,'CONVENZIONE CON IL CONS. INTERCOMUNALE SERVIZI SOCIALI PINEROLO  PER LA REALIZZAZIONE DI ATTIVITA'' D''INTERESSE COMUNE NELL''AMBITO  DEL PROGETTO ALCOTRA PITER N 3926 COEUR SOLIDAIRE RELATIVAMENTE ALLA PROGETTAZIONE ED EROGAZIONE DI SERVIZI SPERIMENTALI E DIVUL- GAZIONE DIRITTI E SERVIZI ESISTENTI  E/A-U/I= EURO 125.000,00','32','CMTO','SA3',to_timestamp('14/06/2019','dd/MM/yyyy'), to_timestamp('29/10/2019','dd/MM/yyyy'), to_timestamp('05/08/2019','dd/MM/yyyy')), 
(2019,6655,'CONVENZIONE CON IL CONS. INTERCOMUNALE SOCIO ASSISTENZIALE SUSA   PER LA REALIZZAZIONE DI ATTIVITA'' D''INTERESSE COMUNE NELL''AMBITO  DEL PROGETTO ALCOTRA PITER N 3926 COEUR SOLIDAIRE RELATIVAMENTE ALLA PROGETTAZIONE ED EROGAZIONE DI SERVIZI SPERIMENTALI  E/A-U/I= EURO 70.000,00','32','CMTO','SA3',to_timestamp('14/06/2019','dd/MM/yyyy'), to_timestamp('25/11/2019','dd/MM/yyyy'), to_timestamp('05/08/2019','dd/MM/yyyy')), 
(2019,6934,'INTERVENTI DI MANUTENZIONE DEGLI IMPIANTI ELEVATORI INSTALLATI  PRESSO GLI ISTITUTI SCOLASTICI DELLA CITTA'' METROPOLITANA DI TO RINO. AFFIDAMENTO ALL''IMPRESA CIOCCA S.R.L. CIG Z4828EE41C (U.I. EURO 48.611,39 -U./PR. 796,91)','32','CMTO','UA5',to_timestamp('21/06/2019','dd/MM/yyyy'), to_timestamp('21/06/2019','dd/MM/yyyy'), to_timestamp('01/07/2019','dd/MM/yyyy')), 
(2019,7077,'INCARICO DI COLLABORAZIONE COORDINATA E CONTINUATIVA DI ESPERTO  GIURISTA IN MATERIA DI GESTIONE PROCEDURE DI GARA ANCHE IN  QUALITA'' DI STAZIONE UNICA APPALTANTE E SOGGETTO AGGREGATORE E  CONSEGUENTI ADEMPIMENTI AL DOTT. DANILO CASSARA'' (U.I. EURO 12.838,70=)','32','CMTO','RA3',to_timestamp('27/06/2019','dd/MM/yyyy'), to_timestamp('24/01/2019','dd/MM/yyyy'), to_timestamp('28/06/2019','dd/MM/yyyy')), 
(2019,7123,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO A CALDO DI MEZZI OPERAT PER LA MANUTENZ. ORD. DELLE SP DI COMPETENZA DEL SERV. VIAB. 2 -  PROCED. APERTA APPROV. OPERAZIONI DI GARA E AGGIUDICAZIONE DEFIN. LOTTO 3 (CIG 779128649A) ALLA CARELLO & COGERINO SNC.  (U.I. EURO 91.500,00)','32','CMTO','UA4',to_timestamp('27/06/2019','dd/MM/yyyy'), to_timestamp('27/06/2019','dd/MM/yyyy'), to_timestamp('12/07/2019','dd/MM/yyyy')), 
(2019,7197,'INTERVENTI DI MANUTENZIONE ORDINARIA E RIPARATIVA PRESSO GLI  EDIFICI SEDI DI UFFICI DELLA CITTA'' METROPOLITANA DI TORINO -  PERIODO 2019-2020-2021. RIMODULAZIONE Q.E. E INDIVIDUAZIONE MOD. DI AFFIDAMNETO MEDIANTE PROCEDURA APERTA. (PROG. 3420/18 - CUP J15H18000030003) (U.PR. EURO 63.055,19 - ECO. EURO 684,73)','32','CMTO','UA5',to_timestamp('01/07/2019','dd/MM/yyyy'), to_timestamp('01/07/2019','dd/MM/yyyy'), to_timestamp('11/07/2019','dd/MM/yyyy')), 
(2019,7307,'PROGRAMMA ALCOTRA-PROGETTORISKGEST N 3845    AFFIDAMENTO DEL SERVIZIO DI SUPPORTO ALLA REDAZIONEDI PIANI DI PROTEZIONE CIVILE PARTECIPATI SU COMUNI PILOTA ALL''ARCH. GIANFRANCO MESSINA CIG Z8928CAB4F    CUP J15B19000930007 (E.A. EURO 49.483,20/U.I. 49.483,20)','32','CMTO','UA1',to_timestamp('03/07/2019','dd/MM/yyyy'), to_timestamp('11/01/2019','dd/MM/yyyy'), to_timestamp('12/08/2019','dd/MM/yyyy')), 
(2015,7528,'SERVIZIO DI MANUTENZIONE DELL''UTENZA DI ACCESSO ALLA PIATTAFORMA WEB MT-X DI MONTE TITOLI S.P.A. PER L''ANNO 2015. CIG N? Z1E074B41B. (U.I.  EURO 103,70)','32','CMTO','EA3',to_timestamp('18/03/2015','dd/MM/yyyy'), to_timestamp('03/12/2018','dd/MM/yyyy'), to_timestamp('01/04/2015','dd/MM/yyyy')), 
(2019,7609,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA DI TORINO. AGGIUDICAZIONE LOTTO 3.06. RETTIFICA DD N. 119-2697/2019.  (U/I EURO 70.234,81=)','32','CMTO','UA3',to_timestamp('11/07/2019','dd/MM/yyyy'), to_timestamp('12/11/2019','dd/MM/yyyy'), to_timestamp('02/08/2019','dd/MM/yyyy')), 
(2019,7645,'INVESTIMENTI FINALIZZATI ALL''ATTUAZIONE DEL PIANO TRIENNALE PER L''INFORMATICA NELLA PUBBLICA AMMINISTRAZIONE FINANZIATI TRAMITE AVANZO. AFFIDAMENTO A CSI PIEMONTE (COD. CRED. 380) (U.I. EURO 226.580,30)','32','CMTO','QA1',to_timestamp('11/07/2019','dd/MM/yyyy'), to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('19/08/2019','dd/MM/yyyy')), 
(2019,7653,'INVESTIMENTI FINALIZZATI AL PROCESSO DI DEMATERIALIZZAZIONE DEGLI ATTI AMMINISTRATIVI IN ATTUAZIONE DEL DPCM 13/11/2014. AFFIDAMENTO A CSI PIEMONTE (COD. CRED. 380) (U.I. EURO 104.550,00)','32','CMTO','QA1',to_timestamp('12/07/2019','dd/MM/yyyy'), to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('26/07/2019','dd/MM/yyyy')), 
(2017,7667,'MESSA IN SICUREZZA DEL TERRITORIO. LOTTO 1: REALIZZAZ DI SCOLMA- TORE (BY PASS) DEL CANALE DI RITORNO DI NOLE ALLA CONFLUENZA CON  IL CANALE DI CIRIE'' PER LA REGOLAZIONE DELLE ACQUE METEORICHE.  INDIVIDUAZIONE MODALITA'' DI AFFIDAMENTO MEDIANTE PROCEDURA APERTA E REIMPUTAZIONE MOV. CONTABILI.','32','CMTO','LC6',to_timestamp('16/05/2017','dd/MM/yyyy'), to_timestamp('23/05/2019','dd/MM/yyyy'), to_timestamp('04/07/2017','dd/MM/yyyy')), 
(2017,7967,'PRESTAZIONI SANITARIE A CARICO DELLA CITTA'' METROPOLITANA DI  TORINO PER L''ANNO 2017. ULTERIORE PRENOTAZIONE DI SPESA. (U.PR. EURO 4.900,00)','32','CMTO','DA6',to_timestamp('23/05/2017','dd/MM/yyyy'), to_timestamp('14/05/2018','dd/MM/yyyy'), to_timestamp('09/10/2017','dd/MM/yyyy')), 
(2019,8008,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA DELLA CITTA? METROPOLITANA. STAGIONI 2019 -2020 E 2020 - 2021. LOTTI 2.20A - 2.20B -2.22. APPROVAZIONE PROGETTO E INDIVIDUAZIONE MODALITA'' DI GARA. (U. PR. 441.557,31)','32','CMTO','UA4',to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('08/08/2019','dd/MM/yyyy')), 
(2019,8015,'SERVIZIO DI VIGILANZA, SORVEGLIANZA ARMATA E DI PRESIDIO CONTROL  ROOM PRESSO GLI EDIFICI DELLA CITTA'' METROPOLITANA DI TORINO -  PERIODO 36 MESI. CIG 7526388BD9 - MODIFICA MOVIMENTI CONTABILI E  INTEGRAZIONE PER SERVIZI NON PREVISTI IN SEDE DI GARA. U.I. EURO 1.081,697,48','32','CMTO','RA3',to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('11/10/2019','dd/MM/yyyy'), to_timestamp('08/08/2019','dd/MM/yyyy')), 
(2019,8062,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO A CALDO DI MEZZI OPERAT PER LA MANUTENZIONE ORDIN. DELLE S.P. DI COMPETENZA DEL SERVIZIO  VIABILITA'' 1 - PROCEDURA APERTA - APPROVAZ. OPERAZIONI DI GARA E AGGIUDICAZIONE DEFINITIVA LOTTO 3 ALL''AZIENDA AGRICOLA BIGLIA CARLO (CIG 786291176B) (U.PR. EURO 117.120,00)','32','CMTO','UA3',to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('19/08/2019','dd/MM/yyyy')), 
(2019,8102,'PIANO DI INTERV. TRIENNALE DI NOLEGGIO A CALDO DI MEZZI OPERATIVI PER LA M.O. DELLE S.P DI COMPET. DEL SERV. VIABILITA'' 1-PROCEDURA APERTA. APPROVAZIONE OPERAZ. DI GARA E AGGIUDICAZIONE DEFINITIVA  LOTTO1 U.O.1-ZONA OM. 10 (CHIVASSESE), PARTE ZONA OM. 4 (AMT NORD (CIG 78628347E0) ALLA TORO COSTRUZIONI SRL (U.PR. 117.120,00)','32','CMTO','UA3',to_timestamp('23/07/2019','dd/MM/yyyy'), to_timestamp('12/12/2019','dd/MM/yyyy'), to_timestamp('08/08/2019','dd/MM/yyyy')), 
(2019,8171,'PROGRAMMA ALCOTRA  PROGETTO RISK-FOR N.3824     AFFIDAMENTO AL CNR-IRPI DEL SERVIZIO PER LA CREAZIONE DI UNA SCUOLA SU RISCHI NATURALI E PROTEZIONE CIVILE NEI TERRITORI TRANSFRONTALIERI CIG 79882998DE  CUP J15B19000920007  CUI  S01907990012201900099 (E.A. EURO 144.416,26 / U.I. EURO 156.160,00)','32','CMTO','UA1',to_timestamp('24/07/2019','dd/MM/yyyy'), to_timestamp('28/02/2019','dd/MM/yyyy'), to_timestamp('19/08/2019','dd/MM/yyyy')), 
(2019,8455,'SERVIZIO DI COMPONENTE/PRESIDENTE DELLE COMMISSIONI TECNICHE  PARITETICHE DEL PIANO DI MONITORAGGIO E VERIFICA DELLE  PRESTAZIONI (PMVP) - TRATTATIVA DIRETTA SUL MEPA - I-TES SRL IN  PERSONA DEL DOTT. SANTOVITO. CIG Z1A2949F3D (E.A.-U.I. EURO 18.087,88)','32','CMTO','TA2',to_timestamp('31/07/2019','dd/MM/yyyy'), to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('26/09/2019','dd/MM/yyyy')), 
(2019,8632,'AFFIDAMENTO DIRETTO ALLA SOCIETA'' 5T S.R.L. PER LA PRESTAZIONE DEL SERVIZIO DI MONITORAGGIO, CONTROLLO E GESTIONE DEL TRAFFICO. ANNO 2019 (U.I. EURO 95160,00)','32','CMTO','UA3',to_timestamp('06/08/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('02/09/2019','dd/MM/yyyy')), 
(2019,8761,'PROGETTO ALCOTRA 201-2020 PITER COEUR''ALP PROGETTO N. 3926  COEUR SOLIDAIRE WP. 4.2.1 - SUPPORTO UFFICIO DI PROSSIMITA'' DI  PINEROLO - AFFIDAMENTO ALLA DITTA COESA PINEROLO SCSARL CUP J79F18000930007  CIG Z3528EAFED E/A- U/I = EURO 34.663,86','32','CMTO','SA3',to_timestamp('08/08/2019','dd/MM/yyyy'), to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('10/09/2019','dd/MM/yyyy')), 
(2019,9256,'PIANO DI INTERVENTO TRIENNALE DI MANUTENZIONE ORDINARIA DI MODEST A ENTITA'' DELLE STRADE PROVINCIALI DI COMPETENZA DEL SERVIZIO VIA 2-PROG. 3712/18. PROC. APERTA SINTEL(110930198) APPROVAZ. OPERAZ. E AGG. DEF LOTTO1(CIG791403651B)E LOTTO2(CIG7914080969) A GODINO  DI G R SRL.,LOTTO3(CIG 79141009EA)A EDILGAMMA SRL(UPR 658.800,00)','32','CMTO','UA4',to_timestamp('02/09/2019','dd/MM/yyyy'), to_timestamp('02/09/2019','dd/MM/yyyy'), to_timestamp('10/09/2019','dd/MM/yyyy')), 
(2019,9536,'PIANO DI INTERVENTO TRIENNALE DI RAPEZZATURA DELLA PAVIMENTAZIONE STRADALE PER LA MANUTENZ. ORD. DELLE S.P. DI COMPETENZA DEL SERV. VIABILITA'' 3-PROC. APERTA-APPROVAZ. OP. DI GARA E AGGIUDICAZ. PER LOTTO1 (CIG 7642195ACF) A SC EDIL DI P.R. SAS E PER LOTTO 2 (CIG  76422296DF) A AIMO BOOT SRL (PROG. 3608/18)(U.PR. 673.440,00)','32','CMTO','UA3',to_timestamp('10/09/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy'), to_timestamp('11/09/2019','dd/MM/yyyy')), 
(2019,9621,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO MEZZI OPERATIVI PER LA M.O. DELLE S.P. DI COMPETENZA DELLA DIR. COORD. VIAB.-VIABILITA 1 APPROVAZ. ELABORATI E AFFIDAMENTO SERVIZI COMPLEMENTARI ANALOGHI AI SENSI DELL''ART. 63 C. 5, D.LGS 50/2016 A TORO COSTRUZIONI SRL, MILANO LUCA, AIMO BOOT SRL. (U.PR. EURO 163.680,00)','32','CMTO','UA3',to_timestamp('11/09/2019','dd/MM/yyyy'), to_timestamp('29/10/2019','dd/MM/yyyy'), to_timestamp('27/09/2019','dd/MM/yyyy')), 
(2016,10065,'SP N 2 DI GERMAGNANO - INTERVENTO DI RIPRISTINO DELLE CONDIZIONI DI SICUREZZA DEL CAMMINAMENTO PROTETTO DAL KM 31+315 AL KM  31+370. AFFIDAMENTO ALL''IMPRESA GUGLIELMINO ING. GIOVANNI. (U.I. EURO 38.892,30 - ECO EURO 10.604,61)','32','CMTO','HE9',to_timestamp('11/04/2016','dd/MM/yyyy'), to_timestamp('27/02/2008','dd/MM/yyyy'), to_timestamp('27/05/2016','dd/MM/yyyy')), 
(2019,10078,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA. STAGIONI 2019-2020 E 2020-2021.  LOTTO 2.20B. APPROVAZIONE OPERAZIONI DI GARA E AGGIUDICAZIONE  DEFINITIVA ALL''OPERATORE ECONOMICO CHIABOTTO CARLO. (CIG 7988407200) (U.S. EURO 157.567,56 ECO EURO 78,06)','32','CMTO','UA4',to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('01/10/2019','dd/MM/yyyy')), 
(2019,10110,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA. STAGIONI 2019-2020 E 2020-2021.  LOTTO 2.22 APPROVAZIONE OPERAZIONI DI GARA E AGGIUDICAZIONE DEFI- NITIVA ALL''OPERATORE ECONOMICO AGRISERVICE S.A.S DI BIANCO DOLINO WANDA E C. (CIG 798841696B) (U.S. EU 85.851,40 ECO EU. 4.428,60)','32','CMTO','UA4',to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('25/10/2019','dd/MM/yyyy')), 
(2019,10126,'PIANO DI INTERVENTO TRIENNALE DI MANUTENZIONE ORDINARIA DELLE S.P DI COMPETENZA DELLA DIREZIONE COORD. VIAIBLITA'' - VIABILITA'' 1.  APPROVAZIONE ELABORATI E AFFIDAMENTO LAVORI COMPLEMENTARI ANALO= GHI EX ART. 63 CO.5 DLGS 50/16 A SOREMA SRL, CITRINITI MASSIMO,  AZ AGR.COOP.VALLI UNITE DEL CANAVESE,CO.E.STRA SRL PROG. 785/2019','32','CMTO','UA3',to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('06/12/2019','dd/MM/yyyy'), to_timestamp('10/10/2019','dd/MM/yyyy')), 
(2018,10197,'MESSA IN SICUREZZA DEL TERRITORIO POSTO TRA IL T. STURA DI LANZO  E IL T. BANNA.LOTTO1: REALIZ. DI SCOLMATORE (BY PASS) DEL CANALE  DI NOLE ALLA CONFLUENZA CON IL C. DI CIRIE'' PER LA REGOL. DELLE   ACQUE METEORICHE. PROC. APERTA. AGGIUD. DEFINITIVA A CFC SOC.  COOPERATIVA (U.S. EURO=209.046,94= U.PR. EURO=44.761,86=)','32','CMTO','LC6',to_timestamp('11/04/2018','dd/MM/yyyy'), to_timestamp('27/06/2019','dd/MM/yyyy'), to_timestamp('24/04/2018','dd/MM/yyyy')), 
(2019,10250,'EDIFICI SCOLASTICIDELLA ZONA A. INTERVENTI DI MANUTENZIONE ORDINA RIA DEGLI IMPIANTI ELETTRICI. AFFIDAMENTO LAVORI A BARATELLA  F.LLI S,R,L.    CIG  Z1C29A1201 (U.I. EURO 48.510,93 - U.PR. 795,26)','32','CMTO','UA5',to_timestamp('27/09/2019','dd/MM/yyyy'), to_timestamp('27/09/2019','dd/MM/yyyy'), to_timestamp('17/10/2019','dd/MM/yyyy')), 
(2019,10251,'PIANO DI INTER TRIENNALE RAPPEZZATURA DELLA PAV STRADALE PER LA  MO DELLE SP DI COMPETENZA DEL SERV. VIAB 2. PROG. 3713/18. PROC.  APERTA SINTEL (ID111048386) APP. OP. GARA E AGG. DEF. LOTTO 1(CIG 791903633D)LOTTO3(CIG 7919088E23)A SELVA MERCURIO SRL E LOTTO2 (CIG 79190552EB) A COGIBIT SRL (U.PR. EURO 549.000,00=)','32','CMTO','UA4',to_timestamp('27/09/2019','dd/MM/yyyy'), to_timestamp('27/09/2019','dd/MM/yyyy'), to_timestamp('03/10/2019','dd/MM/yyyy')), 
(2019,10364,'INTERVENTI DI MANUTENZIONE RIPARATIVA DEGLI IMPIANTI ELEVATORI IN STALLATI PRESSO GLI ISTITUTI SCOLASTICI DI COMPETENZA - ZONA A  AFFIDAMENTO ALL''IMPRESA GRUPPO SIMET S.R.L.  (U.I. EURO 47.775,20 - U.PR. EURO 783,20)','32','CMTO','UA5',to_timestamp('01/10/2019','dd/MM/yyyy'), to_timestamp('01/10/2019','dd/MM/yyyy'), to_timestamp('21/10/2019','dd/MM/yyyy')), 
(2019,10577,'PROGRAMMA ALCOTRA - PROGETTO RISKGEST N.3845        AFFIDAMENTO  SERVIZIO DI VALUTAZIONE DELLA RESILIENZA DEI SOGGETTI COINVOLTI  NEI PIANI PARTECIPATI DI PROTEZIONE CIVILE A I.S.I.G. CIG  Z162A006FA     CUP J15B19000930007 (E.A. EURO 18.544,00/U.I. EURO 18.544,00)','32','CMTO','UA1',to_timestamp('07/10/2019','dd/MM/yyyy'), to_timestamp('04/03/2019','dd/MM/yyyy'), to_timestamp('31/10/2019','dd/MM/yyyy')), 
(2019,10579,'PROGRAMMA ALCOTRA . PROGETTO RISKGEST N.3845 AFFIDAMENTO DEL SERVIZIO DI SUPPORTO ALLA REDAZIONE E DIFFUSIONE DEI PIANI DI PROTEZIONE CIVILE A CERVELLI IN AZIONE S.R.L. CIG Z2A29FCCA3   CUP J15B19000930007 (E.A. EURO 18.300,00/U.I. EURO 18.300,00)','32','CMTO','UA1',to_timestamp('07/10/2019','dd/MM/yyyy'), to_timestamp('13/03/2019','dd/MM/yyyy'), to_timestamp('31/10/2019','dd/MM/yyyy')), 
(2019,10706,'ACCORDO QUADRO PER IL SERVIZIO DI RIPARAZIONE CARROZZERIE.  AUMENTO PRESTAZIONI CONTRATTUALI ENTRO IL LIMITE DEL QUINTO EX  ART. 106, C. 12, D.LGS. 50/2016 E S.M.I. CIG 7622127A2C. (U.PR. EURO 15.000,00)','32','CMTO','UA3',to_timestamp('08/10/2019','dd/MM/yyyy'), to_timestamp('18/12/2019','dd/MM/yyyy'), to_timestamp('25/10/2019','dd/MM/yyyy')), 
(2018,10848,'CONVENZIONE 2016-2020 PER LA GESTIONE DEL SERVIZIO DI TESORERIA  DELLA CITTA'' METROPOLITANA DI TORINO. IMPUTAZIONE ONERI DI TESORERIA ANNO 2018. (U.I. EURO 8.540,00.=)  ( U.I. EURO 880,84.=)  (U.I. EURO 10.417,50.=) (U. PR. EURO 60.161,66.=)','32','CMTO','EA4',to_timestamp('26/04/2018','dd/MM/yyyy'), to_timestamp('31/10/2018','dd/MM/yyyy'), to_timestamp('10/05/2018','dd/MM/yyyy')), 
(2019,10858,'FORNITURA E POSA DI APPARECCHIATURE HARDWARE PER LE POSTAZIONI DI MONITORAGGIO DEL TRAFFICO SULLA RETE VIABILE DI COMPETENZA DELLA CITTA'' METROPOLITANA DI TORINO - APPROVAZIONE PROGETTO E INDIVIDUAZIONE MODALITA'' DI GARA. (U.PR. EURO 130.000)','32','CMTO','UA3',to_timestamp('10/10/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('04/11/2019','dd/MM/yyyy')), 
(2019,10904,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE DALL''ACCORDO STATO-REGIONE-ENTI LOCALI DEL 14/02/2002 E DALLA D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/05/2004. ULTERIORE IMPEGNO DI SPESA PER COMMISSIONI ANNO 2019. (U./PR. EURO 1.503,81)','32','CMTO','UA2',to_timestamp('11/10/2019','dd/MM/yyyy'), to_timestamp('23/05/2019','dd/MM/yyyy'), to_timestamp('21/11/2019','dd/MM/yyyy')), 
(2018,10972,'RIMBORSO SPESE DI NOTIFICA AI COMUNI - ANNO 2018. (U./PR. EURO 150,00)','32','CMTO','IA8',to_timestamp('02/05/2018','dd/MM/yyyy'), to_timestamp('05/04/2019','dd/MM/yyyy'), to_timestamp('16/05/2018','dd/MM/yyyy')), 
(2018,10987,'SERVIZIO DI GESTIONE MANUTENTIVA DEGLI IMPIANTI ASCENSORI PRESSO  EDIFICI SEDI DI UFFICI DI COMPETENZA PER IL PERIODO 2^ SEM. 2018 1^ SEM. 2022. INDIVIDUAZIONE MODALITA'' DI AFFIDAMENTO. U/PR. EURO 126.232,00)','32','CMTO','FA3',to_timestamp('02/05/2018','dd/MM/yyyy'), to_timestamp('06/12/2016','dd/MM/yyyy'), to_timestamp('15/05/2018','dd/MM/yyyy')), 
(2019,10988,'FORNITURA DI CONGLOMERATO BITUMINOSO FREDDO AD ELEVATE PRESTAZIONI PER LA MANUTENZIONE ORDINARIA DELLE STRADE DI  COMPETENZA . ANNO 2019. APPROVAZIONE PROGETTO E INDIVIDUAZIONE MODALITA'' DI GARA. (U.PR. EURO 204.960,00)','32','CMTO','UA3',to_timestamp('14/10/2019','dd/MM/yyyy'), to_timestamp('14/10/2019','dd/MM/yyyy'), to_timestamp('25/10/2019','dd/MM/yyyy')), 
(2019,11044,'MANUTENZIONE ORDINARIA DEGLI IMPIANTI ELETTRICI DELLE PALESTRE  PRESSO LE SEDI DI ISTITUTI SCOLASTICI. AFFIDAMENTO LAVORI A SIET  S.R.L.  -       CIG Z162A2FED7 (U.I. EURO 48.646,67/U.PR. EURO 797,49)','32','CMTO','UA5',to_timestamp('15/10/2019','dd/MM/yyyy'), to_timestamp('15/10/2019','dd/MM/yyyy'), to_timestamp('18/11/2019','dd/MM/yyyy')), 
(2019,11102,'PIANO DI INTERV. TRIENNALE DI NOLEGGIO MEZZI OPERATIVI PER LA M.O DELLE S.P. DI COMPETENZA DELLA DIREZIONE VIABILITA'' 2. APPROVAZ. ELABORATI E AFFIDAM. SERVIZI COMPLEMENTARI ANALOGHI EX ART. 63 C. 5, D.LGS 50/2016 A CARELLO E COGERINO SNC, PASCHETTO F.LLI SNC DI PASCHETTO ROBERTO, AZ. AGR. BIGLIA CARLO (U.PR. EURO 116.560,00)','32','CMTO','UA4',to_timestamp('16/10/2019','dd/MM/yyyy'), to_timestamp('16/10/2019','dd/MM/yyyy'), to_timestamp('30/10/2019','dd/MM/yyyy')), 
(2019,11137,'FORNITURA CUFFIE 3M PELTOR PER I DIPENDENTI DELL''UFFICIO FAUNISTICO AMBIENTALE DELLA CMTO. AFFIDAMENTO ALLA DITTA A+A MONFERRATO S.PA. CIG ZB82A1066C. (U.I. EURO 417,94).','32','CMTO','RA3',to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('06/02/2019','dd/MM/yyyy'), to_timestamp('28/10/2019','dd/MM/yyyy')), 
(2019,11161,'INCARICO DI COLLABORAZIONE COORDINATA E CONTINUATIVA PER  INGEGNERE CIVILE/TERRITORIO AMBIENTE IN POSSESSO DI ABILITAZIONE AI SENSI DEL D.LGS. 81/08 E S.M.I. ALL''ING. ALESSANDRA ANTONELLA SANGIACOMO. INTEGRAZIONE DETERMINA N. 475-7139 DEL 28/06/2019 (U.I. EURO 12,00=)','32','CMTO','UA3',to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('22/10/2019','dd/MM/yyyy')), 
(2019,11186,'AFFIDAMENTO DIRETTO DI INCARICO IN MATERIA DI ESPROPRIAZIONI  A GEOM. MASSIMO ROMERIO. CIG ZF22A3AAE4 U.I. EURO 25.629,76','32','CMTO','RA2',to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('03/06/2019','dd/MM/yyyy'), to_timestamp('13/11/2019','dd/MM/yyyy')), 
(2019,11444,'INTERVENTI DI MANUTENZIONE ORDINARIA IMPIANTI ANTINCENDIO ED EST INTORI DEGLI EDIFICI DELLA CITTA'' METROPOLITANA DI TORINO-2019/21 PROCEDURA APERTA SU SINTEL (ID111938801) APPROVAZIONE OP. DI GARA E AGGIUDICAZIONE DEF. A CO.M.I. SRL (PROGETTO N. 3484/2018- CIG  7940083BC3) (U.PR. EURO 732.000,00=)','32','CMTO','UA5',to_timestamp('23/10/2019','dd/MM/yyyy'), to_timestamp('23/10/2019','dd/MM/yyyy'), to_timestamp('29/10/2019','dd/MM/yyyy')), 
(2019,11512,'EDIFICI SCOLASTICI DELLA ZONA B. INTERVENTI DI MANUTENZIONE ORDI NARIA DEGLI IMPIANTI ELETTRICI. AFFIDAMENTO LAVORI A CHIAVAZZA  S.R.L. - CIG. ZEC2A56668 (U.I. EURO 48.349,19 - U./PR. EURO 792,60)','32','CMTO','UA5',to_timestamp('24/10/2019','dd/MM/yyyy'), to_timestamp('24/10/2019','dd/MM/yyyy'), to_timestamp('08/11/2019','dd/MM/yyyy')), 
(2019,11555,'PIANO DI INTERVENTO TRIENNALE DI RAPPEZZATURA DELLA PAVIMENTAZIO- NE STRADALE PER LA M.O. DELLE S.P. DI COMPETENZA DELLA DIREZIONE  VIABILITA'' 2. APPROVAZIONE E AFFIDAMENTO LAVORI COMPLEMENTARI ANA LOGHI EX ART. 63 CO. 5 D.LGS. 50/2016. LOTTI DA 1 A 5. PROG. N. 876/2019 (U.PR. EURO 270.000,00)','32','CMTO','UA4',to_timestamp('25/10/2019','dd/MM/yyyy'), to_timestamp('25/10/2019','dd/MM/yyyy'), to_timestamp('15/11/2019','dd/MM/yyyy')), 
(2019,11632,'PROGETTO ALCOTRA N. 4951 SOCIALAB - SERVIZI DI SUPPORTO PER  L''ATTIVITA'' DI COORDINAMENTO, GESTIONE E ANIMAZIONE DEL PROGETTO. AFFIDAMENTO ALLA DITTA CHINTANA SRL  CUP J79E19000740007  CIG ZC629B1787 E/A-U/I= EURO 10.980,37','32','CMTO','SA3',to_timestamp('28/10/2019','dd/MM/yyyy'), to_timestamp('10/12/2019','dd/MM/yyyy'), to_timestamp('27/11/2019','dd/MM/yyyy')), 
(2019,11662,'INTERVENTI DI MANUTENZIONE RIPARATIVA IMPIANTI ELEVATORI INSTAL- LATI PRESSO GLI ISTITUTI SCOLASTICI DELLA CITTA'' METROPOLITANA DI TORINO - ZONA B. AFFIDAMENTO ALL''IMPRESA GRUPPO SIMET S.R.L. CIG Z522A6D9AD (U.I. EURO 47.677,60 - U.PR. EURO 781,60)','32','CMTO','UA6',to_timestamp('29/10/2019','dd/MM/yyyy'), to_timestamp('29/10/2019','dd/MM/yyyy'), to_timestamp('07/11/2019','dd/MM/yyyy')), 
(2019,11686,'PIANO DI INTERVENTO TRIENNALE DI RAPPEZZATURA DELLA PAVIMENTAZIO- NE STRADALE PER LA M.O. DELLE S.P. DI COMPETENZA DELLA DIREZIONE  COORDINAMENTO VIABILITA''-VIABILITA'' 1. APPROVAZIONE E AFFIDAMENTO LAVORI COMPLEMENTARI ANALOGHI EX ART. 63 CO. 5 D.LGS. 50/2016.  LOTTI DA 1 A 3. PROG. N. 884/2019 (U.PR. EURO 297.000,00)','32','CMTO','UA3',to_timestamp('29/10/2019','dd/MM/yyyy'), to_timestamp('29/10/2019','dd/MM/yyyy'), to_timestamp('11/11/2019','dd/MM/yyyy')), 
(2019,11863,'PIANO DI INTERVENTO TRIENNALE DI MANUTENZIONE ORDINARIA DI MODE- STA ENTITA'' PER LA MANUTENZIONE ORDINARIA DELLE S.P. DI COMPETEN- ZA DELLA DIREZIONE VIABILITA'' 2. APPR.NE ELABORATI E AFFIDAMENTO  LAVORI COMPLEMENTARI ANALOGHI EX ART. 63 CO. 5 D.LGS. 50/2016. LOTTI DA 1 A 5. PROG. N. 897/2019 (U.PR. EURO 324.000,00)','32','CMTO','UA4',to_timestamp('04/11/2019','dd/MM/yyyy'), to_timestamp('04/11/2019','dd/MM/yyyy'), to_timestamp('15/11/2019','dd/MM/yyyy')), 
(2019,12167,'PROGETTO ALCOTRA SOCIALAB - SERVIZI DI SUPPORTO PER ELABORAZIONE  E APPLICAZIONE INDICATORI VALUTAZIONE SOSTENIBILITA'' ECONOMICA E  QUALITA'' SOCIALE. AFFIDAMENTO ALLA A.S.V.A.P.P.  CUP J79E19000740007  CIG Z7E2A4683B E/A - U/I EURO 20.740.79 BILANCIO 2020 E 2021','32','CMTO','SA3',to_timestamp('08/11/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('27/11/2019','dd/MM/yyyy')), 
(2019,12297,'MANUTENZIONE DEGLI IMPIANTI DI ILLUMINAZIONE ESTERNA DEGLI  EDIFICI SCOLASTICI DI COMPETENZA. AFFIDAMENTO LAVORI A  ELECTROTECHNICAL NEW GENERATION DI MAFFIA LUCA.  (U.I. EURO 47.796,35 - U./PR.EURO 783,55)','32','CMTO','UA5',to_timestamp('12/11/2019','dd/MM/yyyy'), to_timestamp('12/11/2019','dd/MM/yyyy'), to_timestamp('03/12/2019','dd/MM/yyyy')), 
(2019,12424,'PIANO URBANO DI MOBILITA'' SOSTENIBILE (PUMS). ISTITUZIONE COMITATO SCIENTIFICO. (U.PR EURO 35.000,00) CUP J72G19000420004','32','CMTO','UA0',to_timestamp('13/11/2019','dd/MM/yyyy'), to_timestamp('27/09/2019','dd/MM/yyyy'), to_timestamp('09/12/2019','dd/MM/yyyy')), 
(2018,12567,'INTERVENTI DI MANUTENZIONE ORDINARIA E DI ADEGUAMENTO FUNZIONALE  E NORMATIVO PRESSO EDIFICI SEDI DI UFFICI DELL''ENTE. OPERE EDILI. REVOCA AFFIDAMENTO AEL.ME.CA SRL. AFFIDAMENTO A EDIL C.R.E. DI   MARZANO FABIO. RDO N. 1761175. C.I.G. 72979781F7.  PROGETTO 31047/2017. (U/I EURO 92.354,29).','32','CMTO','FA3',to_timestamp('14/05/2018','dd/MM/yyyy'), to_timestamp('27/10/2017','dd/MM/yyyy'), to_timestamp('29/05/2018','dd/MM/yyyy')), 
(2019,12597,'CONVENZIONE CON L''ASL TO3 PER LA REALIZZAZIONE DI ATTIVITA'' DI  INTERESSE COMUNE PROGETTO ALCOTRA COEUR SOLIDAIRE RELATIVAMENTE ALL''ATTIVITA'' DELL''INFERMIERE DI FAMIGLIA E COMUNITA'' ANCHE ATTRA VERSO ATTIVAZIONE DI STRUMENTI DIGITALI - CIG. Z582AB2B4D  U/I = EURO 4.000 BIL 2019 E/A-U/I= EURO 21.000 BIL 2020','32','CMTO','SA3',to_timestamp('18/11/2019','dd/MM/yyyy'), to_timestamp('04/06/2019','dd/MM/yyyy'), to_timestamp('06/12/2019','dd/MM/yyyy')), 
(2018,12694,'AUTORIZZAZIONE ALL''INDIZIONE DI PROCEDURA DI ACQUISTO SUL MEPA   E APPROVAZIONE DEL CAPITOLATO D''ONERI PER L''AFFIDAMENTO DEL  SERVIZIO MANUTENZIONE IMPIANTI ELEVATORI INSTALLATI PRESSO GLI    ISTITUTI SCOLASTICI DELLA CITTA'' METROPOLITANA DI TORINO. (U./PR. EURO 248.620,00=)','32','CMTO','HE3',to_timestamp('16/05/2018','dd/MM/yyyy'), to_timestamp('11/10/2018','dd/MM/yyyy'), to_timestamp('22/05/2018','dd/MM/yyyy')), 
(2019,12912,'INNOMETRO: INNOVAZIONE DELLE MICROIMPRESE DEL TERRITORIO. ACCORDO  CON FINPIEMONTE S.P.A. PER GESTIONE BANDO CONCESSIONE CONTRIBUTI  - IMPEGNO DI SPESA. FONDO INNOMETRO - PARZIALE REIMPUTAZIONE CONTABILE SPESA ANNO 2019. (U/I  EURO 73.678,00).','32','CMTO','SA2',to_timestamp('22/11/2019','dd/MM/yyyy'), to_timestamp('08/10/2019','dd/MM/yyyy'), to_timestamp('13/12/2019','dd/MM/yyyy')), 
(2019,12959,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO A CALDO DI MEZZI OPERAT PER LA M.O. DELLE S.P. DI COMPETENZA DEL SERVIZIO VIABILITA'' 1. - PROCEDURA APERTA. APPROVAZIONE OPERAZIONI DI GARA E AGGIUDICAZ. DEFINITIVA LOTTO 2 U.O.2 (CIG 8060058A44) ALL''IMPRESA GS SERVICE  SRL. (U.PR. EURO 117.120,00)','32','CMTO','UA3',to_timestamp('25/11/2019','dd/MM/yyyy'), to_timestamp('25/11/2019','dd/MM/yyyy'), to_timestamp('10/12/2019','dd/MM/yyyy')), 
(2019,13012,'PROGETTO ALCOTRA N. 4591 SOCIALAB- ATTIVIT? DI SUPPORTO ALLA GE STIONE SEZIONE DECENTRATA UFFICIO PUBBLICA TUTELA PRESSO TRIBUNA LE DI IVREA E PROMOZIONE DIRITTI DELLE PERSONE. AFFIDAMENTO ALLA  DITTA ANDIRIVIENI S.C.S. EURO 34.770,00 CIG. N. Z3D2A10891 E/A-U/I= EURO 19.860 BIL, 2020 E/A-U/I= EURO 14.910 BIL 2021','32','CMTO','SA3',to_timestamp('25/11/2019','dd/MM/yyyy'), to_timestamp('27/06/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,13237,'CIG SMAT 09999901DA - CIG C.C.A.M. 1514368002. PRENOTAZIONE IMPEGNO DI SPESA PER LA FORNITURA DI ACQUA POTABILE PRESSO GLI EDIFICI DELLA CITTA'' METROPOLITANA DITORINO PER L''ANNO 2020.  (U. PR. EURO 787.000,00)','32','CMTO','RA3',to_timestamp('28/11/2019','dd/MM/yyyy'), to_timestamp('22/02/2019','dd/MM/yyyy'), to_timestamp('04/12/2019','dd/MM/yyyy')), 
(2019,13323,'PIANO INTEGRATO TERRITORIALE ALCOTRA GRAIES LAB - SERVIZIO DI COFFEE BREAK PER RIUNIONE DEL COMITATO TECNICO DEL SEGRETARIATO ALCOTRA DEL 3.12.2019 - AFFIDAMENTO DIRETTO IN ECONOMIA ALLA  DITTA PIRAMIDE SRL - CIG Z102AE3409 (E.A./U.I EURO 187,00=)','32','CMTO','QA5',to_timestamp('28/11/2019','dd/MM/yyyy'), to_timestamp('05/04/2019','dd/MM/yyyy'), to_timestamp('02/12/2019','dd/MM/yyyy')), 
(2019,13343,'SERVIZIO DI TRADUZIONE TECNICA DI DOCUMENTI RELATIVI AI PROCEDIMENTI FINALIZZATI AL RILASCIO DI AUTORIZZAZIONI ALLE SPDEDIZIONI DI RIFIUTI. AFFIDAMENTO SERVIZIO. CIG Z1A2ABF928 (U.PR  EURO 15.860,00)','32','CMTO','TA1',to_timestamp('29/11/2019','dd/MM/yyyy'), to_timestamp('02/09/2019','dd/MM/yyyy'), to_timestamp('11/12/2019','dd/MM/yyyy')), 
(2019,13371,'NUCLEO DI VALUTAZIONE (NDV) 2018/2020 - IMPEGNO DI SPESA PER GLI ANNI 2019 E 2020. (U.I. EURO 19.121,24).','32','CMTO','QA6',to_timestamp('29/11/2019','dd/MM/yyyy'), to_timestamp('12/04/2019','dd/MM/yyyy'), to_timestamp('12/12/2019','dd/MM/yyyy')), 
(2019,13391,'CONVENZIONE CON L''ASL TO4 PER LA REALIZZAZIONE DI ATTIVITA'' D''INTERESSE COMUNE NELL''AMBITO DEL PROGETTO ALCOTRA N. 4591 SOCIALAB RELATIVAMENTE ALLA FORMAZIONE DEGLI OPERATORI SOCIALI  DI COMUNITA'' ED ALLA IMPLEMENTAZIONE INFERMIERE DI COMUNITA'' CUP J79E19000740007 E/A-U/I= EURO 40.000,00 BILANCIO 2020','32','CMTO','SA3',to_timestamp('29/11/2019','dd/MM/yyyy'), to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,13407,'PRENOTAZIONE IMPEGNO DI SPESA PER LA FORNITURA DI ENERGIA  ELETTRICA FUORI CONVENZIONE PER L''ANNO 2020. (U. PR. EURO 11.400,00)','32','CMTO','RA3',to_timestamp('02/12/2019','dd/MM/yyyy'), to_timestamp('09/04/2019','dd/MM/yyyy'), to_timestamp('11/12/2019','dd/MM/yyyy')), 
(2018,13415,'AFFIDAMENTO INCARICO PROFESSIONALE PER REALIZZARE IL SUPPORTO OPERATIVO NELLA REDAZIONE DI INDICAZIONI NATURALISTICHE PER LA  TUTELA E LA VALORIZZAZIONE DEL S.I.C. IT1110064 PALUDE DI ROMANO CANAVESE AL DOTT. NATURALISTA DIEGO PIER ACHILLE MARRA. CIG ZCA23BFBA5 - U.I. EURO 2.080,00','32','CMTO','IAG',to_timestamp('28/05/2018','dd/MM/yyyy'), to_timestamp('29/11/2019','dd/MM/yyyy'), to_timestamp('20/08/2018','dd/MM/yyyy')), 
(2019,13442,'PRENOTAZIONE IMPEGNO DI SPESA PER LA FORNITURA DI GAS METANO  FUORI CONVENZIONE PER L''ANNO 2020. (U. PR. EURO 5.000,00)','32','CMTO','RA3',to_timestamp('02/12/2019','dd/MM/yyyy'), to_timestamp('16/04/2019','dd/MM/yyyy'), to_timestamp('11/12/2019','dd/MM/yyyy')), 
(2019,13592,'SERVIZIO DI MANUTENZIONE ORDINARIA E RIPARATIVA IMPIANTI ELEVATOR INSTALLATI PRESSO ISTITUTI SCOLASTICI ED EDIFICI DI EDILIZIA GENE RALE DELLA CITTA'' METROPOLITANA DI TORINO. INDIVIDUAZIONE MODA LITA'' DI GARA  E APPROVAZIONE ELABORATI ALLEGATI  (U./PR. EURO 429.999,76)','32','CMTO','UA5',to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('10/12/2019','dd/MM/yyyy')), 
(2019,13603,'CONCESSIONE A FAVORE DELLA CITTA'' METROPOLITANA DI TORINO DI  AULE PRESSO L''EDIFICIO PREFABBRICATO UBICATO IN CALUSO VIA  MONTELLO N.2, DI PROPRIETA'' DEL COMUNE DI CALUSO AD USO  DELL''I.I.S. UBERTINI. A.S. DAL 2019/2020 AL 2022/2023. APPROVAZ.SCHEMA CONTRATTO.(U.I. EURO 15.000- U.PR.EURO 5.450)','32','CMTO','QA3',to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('06/12/2019','dd/MM/yyyy'), to_timestamp('12/12/2019','dd/MM/yyyy')), 
(2019,13604,'CENTRO EUROPE DIRECT TORINO. AFFIDAMENTO IN ECONOMIA PER SERVIZIO DI STAMPA PREVIA TRATTIVA DIRETTA MEPA N. 1132876 ALLA TIPOGRAFIA SOSSO S.R.L. - CIG ZDF2A8C0BC.  (U.I. EURO 1.903,20=)','32','CMTO','QA5',to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('13/11/2019','dd/MM/yyyy'), to_timestamp('18/12/2019','dd/MM/yyyy')), 
(2019,13682,'SERVIZI IN CONVENZIONE CONSIP TELEFONIA FISSA 5. PRENOTAZIONE DI SPESA PER L''ESERCIZIO 2020. AFFIDATARIA FASTWEB SPA (COD. CRED. 110450). CIG 7999219C55. (U. PR. EURO 50.000,00)','32','CMTO','QA1',to_timestamp('04/12/2019','dd/MM/yyyy'), to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('17/12/2019','dd/MM/yyyy')), 
(2019,13708,'CIG ZCC2A84ADC. AFFIDAMENTO PER LA FORNITURA DI G.P.L. DA  RISCALDAMENTO PER IL MAGAZZINO STRADALE DI FAVRIA ALLA SOCIETA'' LIQUIGAS S.P.A. (P.IVA 03316690175). PRENOTAZIONE IMPEGNO DI SPESA PER L''ANNO 2020. (U. PR. EURO 12.000,00)','32','CMTO','RA3',to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('17/04/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy')), 
(2019,13714,'FORNITURE DI RICAMBI, MATERIALI USURA, LUBRIFICANTI E ACCESSORI PER I MEZZI MECCANICI ED ATTREZZATURE VARIE. AUTORIZZAZIONE E PRENOTAZIONE DI SPESA PER L''ANNO 2020. (U.PR. EURO 30.000,00)','32','CMTO','UA3',to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,13751,'NOLEGGIO FOTOCOPIATORI OLIVETTI D-COPIA 5000MF CONSIP 26 LOTTO 3 PRODUTTIVITA'' MEDIA - CIG DERIVATO 725470866D. REIMPUTAZIONE IMPEGNI ANNO 2022. (U.I. EURO 37.576,00).','32','CMTO','RA3',to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('27/05/2019','dd/MM/yyyy'), to_timestamp('18/12/2019','dd/MM/yyyy')), 
(2019,13752,'NOLEGGIO FOTOCOPIATORI OLIVETTI D-COPIA 5000MF PRODUTTIVITA'' BASSA CONSIP 26 LOTTO 3 - REIMPUTAZIONE IMPEGNI ANNO 2022. CIG DERIVATO 7254788871. (U.I. EURO 5.234,13).','32','CMTO','RA3',to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('29/05/2019','dd/MM/yyyy'), to_timestamp('24/12/2019','dd/MM/yyyy')), 
(2019,13787,'EDIFICI DI COMPETENZA DELLA DIREZIONE EDILIZIA SCOLASTICA 2. REDAZIONE RELAZIONI GEOLOGICHE ED ESECUZIONE PROVE SISMICHE SUL   TERRENO. AFFIDAMENTO SERVIZIO TRAMITE TRATTATIVA DIRETTA SUL MEPA AL DOTT. GEOLOGO MASSIMO TROSSERO (CIG Z322AFFD46) (U.I. EURO 38.904,04=)','32','CMTO','UA6',to_timestamp('06/12/2019','dd/MM/yyyy'), to_timestamp('06/12/2019','dd/MM/yyyy'), to_timestamp('18/12/2019','dd/MM/yyyy')), 
(2019,13812,'ASSOCIAZIONE ARCO LATINO. IMPEGNO QUOTA ASSOCIATIVA ANNO 2019. (U.I. EURO 5.500,00)','32','CMTO','SA1',to_timestamp('06/12/2019','dd/MM/yyyy'), to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('13/12/2019','dd/MM/yyyy')), 
(2019,13855,'PIANO INTEGRATO TERRITORIALE ALCOTRA GRAIES LAB - SERVIZIO DI  CATERING PER INCONTRO DI TEAM COACHING/TEAM BUILDING DEL GIORNO 11.12.2019. AFFIDAMENTO DIRETTO IN ECONOMIA ALLA DITTA PIRAMIDE S.R.L. - CUP J19F18000830005 - CIG Z1C2B14F7D (E.A./UI EURO 300,00=)','32','CMTO','QA5',to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('13/12/2019','dd/MM/yyyy'), to_timestamp('10/12/2019','dd/MM/yyyy')), 
(2019,13871,'CONVENZIONE 2016-2020 PER LA GESTIONE DEL SERVIZIO DI  TESORERIA DELLA CITTA'' METROPOLITANA DI TORINO. IMPUTAZIONE ONERI DI TESORERIA ANNO 2020. CIG 6600893D36 (U. PR. EURO 8.540,00=)  ( U. PR. EURO 91.460,00=)','32','CMTO','QA3',to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('22/11/2019','dd/MM/yyyy'), to_timestamp('15/01/2020','dd/MM/yyyy')), 
(2019,13872,'PAGO P.A. ADDENDUM ALLA CONVENZIONE DI TESORERIA  ART. 38 PARTNER TECNOLOGICO PER SCAMBIO DEI FLUSSI CON IL NODO DEI PAGAMENTI.         IMPUTAZIONE ONERI ANNO 2020. CIG 772066919D U. PR. EURO 22.899,40=','32','CMTO','QA3',to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('17/12/2019','dd/MM/yyyy'), to_timestamp('15/01/2020','dd/MM/yyyy')), 
(2019,13906,'CONVENZIONE QUADRO PER GLI AFFIDAMENTI DIRETTI ALLA SOCIETA'' 5T S.R.L. PER LA PRESTAZIONE DEL SERVIZIO DI MONITORAGGIO,  CONTROLLO E GESTIONE DEL TRAFFICO. AFFIDAMENTO ESECUZIONE  PRESTAZIONI DI MANUTENZIONE STRAORDINARIA .  (U.I. EURO 154.840,00)','32','CMTO','UA3',to_timestamp('10/12/2019','dd/MM/yyyy'), to_timestamp('10/12/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy')), 
(2019,13913,'CONTRATTO DI CONCESSIONE PRECARIA TEMPORANEA DI ALCUNI LOCALI SITI PRESSO PALAZZO CISTERNA VIA MARIA VITTORIA 12 - TORINO,  DA DESTINARSI A SEDE DEGLI UFFICI DELL''EURISPES- ISTITUTO DI  STUDI POLITICI, ECONOMICI E SOCIALI. DURATA 01/01/2020-31/12/2020 APPROVAZIONE SCH.  CONTRATTO.(EA EURO 48000 - UI EURO 30000)','32','CMTO','QA3',to_timestamp('10/12/2019','dd/MM/yyyy'), to_timestamp('06/03/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy')), 
(2019,14051,'SERVIZIO DI VERIFICA IMPIANTI AI SENSI DEL D.P.R. 462/2001 PRESSO ALCUNI EDIFICI DI COMPETENZA. AFFIDAMENTO ALL''ORGANISMO DI  ISPEZIONE EURISP ITALIA S.R.L.  (U.I. EURO 6.635,58)','32','CMTO','UA5',to_timestamp('12/12/2019','dd/MM/yyyy'), to_timestamp('12/12/2019','dd/MM/yyyy'), to_timestamp('17/12/2019','dd/MM/yyyy')), 
(2019,14065,'COMMISSIONE PROVINCIALE ESPROPRI. CONFERMA RICONOSCIMENTO GETTONI DI PRESENZA AI COMPONENTI E  COSTITUZIONE RELATIVO FONDO-PRENOTAZIONE DI SPESA PER L''ANNO 2019 (U.PR. EURO 878,85=)','32','CMTO','RA5',to_timestamp('12/12/2019','dd/MM/yyyy'), to_timestamp('11/07/2019','dd/MM/yyyy'), to_timestamp('17/12/2019','dd/MM/yyyy')), 
(2019,14153,'PROGETTO ALCOTRA N. 4171 GRAIES LAB MOBILAB AFFIDAMENTO SERVIZIO DI ASSISTENZA TECNICA E AMMINISTRATIVA ALLA  SOCIETA'' BUSINESS DEVELOPMENT MANAGEMENT. (E.A. EURO 17.083,24 -  U.I. EURO 18.283,24) T. D. N. 1155295 CIG Z102AE42BE CUP J11F18000300007','32','CMTO','UA0',to_timestamp('13/12/2019','dd/MM/yyyy'), to_timestamp('16/10/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy')), 
(2019,14372,'POR FSE 2014-2020 AZIONE 1.8I.1.2 OB. SPEC. 1 AZIONE 2 MISURA 1.  SERV. TRASV. DI SUPPORTO A REALIZZ. PROGR. MIP 2019-2022. CIG 8137368082. DETERM. A CONTRARRE E AFFID. EX 63, COMMA 5 D.LGS. 50/2016 A ATI SELENE CONSULTING SRL/CONS. SPAZIO E FORMAZIONE /TELEWORK TEAM S.C.(E/A -EPR  400.000,00 - U/I-UPR 399.916,00).','32','CMTO','SA2',to_timestamp('17/12/2019','dd/MM/yyyy'), to_timestamp('10/10/2019','dd/MM/yyyy'), to_timestamp('24/12/2019','dd/MM/yyyy')), 
(2019,14450,'INTERVENTI DI MO NEGLI EDIFICI SCOL. DI PROP. E COMP. DELLA CITTA METROPOLITANA DI TORINO.19-21. PROG. 825/2019. APPROVAZ. OP. GARA E AGGIUDICAZIONE DEF. LOTTO 1 A C.E.V.I.G. SRL (CIG 807771012B) LOTTO A A CO.GE.IM. SRLU (CIG 8077743C63)  (U.PR. EURO 1.206.336,00=)','32','CMTO','UA6',to_timestamp('18/12/2019','dd/MM/yyyy'), to_timestamp('18/12/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy')), 
(2019,14498,'SPESE PER LA RISCOSSIONE DI ENTRATE. ANNO 2020. (U/PR  EURO  500,00)','32','CMTO','QA3',to_timestamp('18/12/2019','dd/MM/yyyy'), to_timestamp('17/04/2019','dd/MM/yyyy'), to_timestamp('24/12/2019','dd/MM/yyyy')), 
(2019,14514,'FORNITURA DI CONGLOMERATO BITUMINOSO FREDDO AD ELEVATE         PRESTAZIONI PER LA MANUTENZIONE ORDINARIA DELLE STRADE DI  COMPETENZA - ANNO 2019. APPROVAZIONE OPERAZIONI DI GARA E  AFFIDAMENTO ALL''IMPRESA SABBIE DI PARMA SRL (CIG 8086971B93) (U.I. EURO 204.960,00)','32','CMTO','UA3',to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,14518,'INTERVENTI DI MANUTENZIONE ORDINARIA NEGLI EDIFICI SCOLASTICI DI PROPRIETA E COMPETENZA DELLA CITTA METROPOLITANA DI TORINO. 19/21 (PROG. 825/2019)PROC. NEG. APPROVAZIONE OP. GARA E AGGIUDICAZIONE DEF LOTTO 3 A ATI EDIL NORD SRL/GIEFFE COSTR.(CIG 8077780AEC),   LOTTO 4 A ACAM COSTRUZIONI SRL(CIG 8079080BB7) (UPR 1.206.336,00)','32','CMTO','UA6',to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,14544,'DECRETO DEL SINDACO METROPOLITANO N. 243-6754/2019 DI  AUTORIZZAZIONE ALLA PREPOSIZIONE DI APPELLO C/ ATHENAY FORMAZIONE AVVERSO LA SENTENZA DEL TRIBUNALE DI TORINO N. 1974/19 (R.G.A. N. 1458/2019). INTEGRAZIONE DI IMPEGNE DI SPESA PER RESISTE AD APPELLO INCIDENTALE. (U.I. EURO 9338,37)','32','CMTO','A51',to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('07/11/2018','dd/MM/yyyy'), to_timestamp('23/12/2019','dd/MM/yyyy')), 
(2019,14548,'INTERVENTI DI MANUTENZIONE ORDINARIA NEGLI EDIFICI SCOLASTICI DI PROPRIETA E COMPETENZA DELLA CITTA METROPOLITANA DI TORINO. 19/21 (PROG. 824/2019)PROC. NEG. APPROVAZ. OP. DI GARA E AGGIUDICAZIONE DEF. LOTTO 3 A CUDIA IMPIANTI DI C.F. (CIG 8077223F44), LOTTO 4 A EDILINVEST SRL (CIG 8078798303= (U.PR. EUR. 1.206.336,00=)','32','CMTO','UA5',to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,14598,'DETERMINAZIONE A CONTRARRE IN ESECUZIONE DEL DECRETO DELLA SINDACA METROPOLITANA N. 14590/2019. RINEGOZIAZIONE 2019 DEI PRESTITI CON TASSO DI AMMORTAMENTO STRUTTURATO STIPULATI DALLA CITTA'' METROPOLITANA DI TORINO CON LA BANCA DEXIA-CREDIOP S.P.A. (U.I.  EURO 135,24)','32','CMTO','QA3',to_timestamp('20/12/2019','dd/MM/yyyy'), to_timestamp('14/06/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,14618,'INTERVENTI DI MANUTENZIONE ORDINARIA NEGLI EDIFICI SCOLASTICI DI PROPRIETA E COMPETENZA DELLA CITTA METROPOLITANA DI TORINO. 19-21 PROC. NEG. APPROV. OP. GARA E AGGIUDICAZIONE DEF. LOTTO 1 A IDROT ERMICA MERIDIONALE DI M.L. (CIG 807715030A) E LOTTO 2 A TECNOVA  SRL (CIG 8077180BC9) (U.PR. EUR. 1.206.336,00=)','32','CMTO','UA5',to_timestamp('20/12/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy'), to_timestamp('24/12/2019','dd/MM/yyyy')), 
(2018,14880,'SERVIZIO DI GESTIONE MANUTENTIVA DEGLI IMPIANTI ASCENSORI PRESSO  EDIFICI SEDI DI UFFICI PER IL PERIODO 2^ SEM. 2018 - 1^ SEM. 2022 LOTTO 2 AFFIDAMENTO DIRETTO SUL MEPA  EX ART. 36, COMMA 2, LETT.  A D.LGS. 50/2016 E S.M.I. A GRUPPO SIMET S.R.L.-CIG. Z3823AF9A6 (U.S. EURO 10.540,95)','32','CMTO','FA3',to_timestamp('11/06/2018','dd/MM/yyyy'), to_timestamp('30/10/2017','dd/MM/yyyy'), to_timestamp('14/06/2018','dd/MM/yyyy')), 
(2018,15063,'SERVIZIO DI PULIZIA E IGIENE AMBIENTALE NEGLI EDIFICI SEDI DI  UFFICI DELL''ENTE PER UN PERIODO DI 36 MESI. AVVIO DI PROCEDURA AD EVIDENZA PUBBLICA PER L''INDIVIDUAZIONE DEL CONTRAENTE.  CIG 7466043596 U.PR EURO 1.207.328,53','32','CMTO','FAB',to_timestamp('15/06/2018','dd/MM/yyyy'), to_timestamp('05/02/2018','dd/MM/yyyy'), to_timestamp('28/06/2018','dd/MM/yyyy')), 
(2018,15203,'PIANO DI INTERVENTO TRIENNALE DI MANUTENZIONE ORDINARIA DI MODESTA ENTITA'' DELLE S.P. DI COMPETENZA DEL SERVIZIO VIABILITA''. INDIVIDUAZIONE MODALITA'' DI AFFIDAMENTO MEDIANTE PROCEDURA APERTA (PROGETTO 3317/2018) (U.PR EURO 658.800,00 + RINVIO 2021)','32','CMTO','HE9',to_timestamp('19/06/2018','dd/MM/yyyy'), to_timestamp('19/12/2016','dd/MM/yyyy'), to_timestamp('28/06/2018','dd/MM/yyyy')), 
(2018,15310,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA DELLA CITTA'' METROPOLITANA.  STAGIONI 2018- 2019, 2019- 2020, 2020- 2021. APPROVAZIONE  PROGETTO LOTTO 3.06 E INDIVIDUAZIONE DELLE MODALITA'' DI GARA (U.PR. EURO 250450,23)','32','CMTO','HE2',to_timestamp('21/06/2018','dd/MM/yyyy'), to_timestamp('07/08/2018','dd/MM/yyyy'), to_timestamp('13/07/2018','dd/MM/yyyy')), 
(2018,16216,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO MEZZI OPERATIVI PER LA MANUTENZIONE ORDINARIA DELLE S.P. DI COMPETENZA DEL SERVIZIO  VIABILITA'' 3. APPROVAZIONE PROGETTO. (U.PR. 372.000,00)','32','CMTO','HE9',to_timestamp('02/07/2018','dd/MM/yyyy'), to_timestamp('11/07/2019','dd/MM/yyyy'), to_timestamp('08/08/2018','dd/MM/yyyy')), 
(2018,16747,'SERVIZIO DI VIGILANZA, SORVEGLIANZA ARMATA E DI PRESIDIO CONTROL  ROOM PRESSO GLI EDIFICI DELLA CITTA'' METROPOLITANA DI TORINO PER  UN PERIODO DI 36 MESI. IMPEGNO DI SPESA PER GLI ANNI 2019-2020. U.PR. EURO 989.631,20','32','CMTO','FAB',to_timestamp('04/07/2018','dd/MM/yyyy'), to_timestamp('05/02/2018','dd/MM/yyyy'), to_timestamp('16/07/2018','dd/MM/yyyy')), 
(2018,17143,'RIMBORSO SPESE DI NOTIFICA 2018 - INDIVIDUAZIONE COMUNI   (U./S. EURO 21,76)','32','CMTO','IA8',to_timestamp('11/07/2018','dd/MM/yyyy'), to_timestamp('06/06/2019','dd/MM/yyyy'), to_timestamp('08/08/2018','dd/MM/yyyy')), 
(2018,17258,'INCARICIHI DI COLLABORAZIONE COORDINATA E CONTINUATIVA PER  ESPERTO TECNICO IN MERITO AD ATTIVITA'' TECNICHE RELATIVE A  PROCEDURE DI GARA DI OPERE PUBBLICHE E ADEMPIMENTI CONSEGUENTI AGLI ARCH. FINOTTO FRANCESCO E DI STEFANO MARTINA. (U.I. EURO 28.878,90)','32','CMTO','HE5',to_timestamp('13/07/2018','dd/MM/yyyy'), to_timestamp('26/07/2017','dd/MM/yyyy'), to_timestamp('19/07/2018','dd/MM/yyyy')), 
(2018,17259,'INCARICHI DI COLLABORAZIONE COORDINATA E CONTINUATIVA DI ESPERTO TECNICO IN MERITO AD ATTIVITA'' TECNICHE RELATIVE A PROCEDURE DI GARA DI OPER EPUBBLICHE E ADEMPIMENTI CONSEGUENTI AGLI ARCH. GIULIA NOTA E LETIZIA ROTA. (U.I. EURO 28.878,90)','32','CMTO','HE4',to_timestamp('13/07/2018','dd/MM/yyyy'), to_timestamp('09/11/2018','dd/MM/yyyy'), to_timestamp('19/07/2018','dd/MM/yyyy')), 
(2017,17613,'EDIFICI SCOLASTICI VARI SERVIZIO EDILIZIA SCOLASTICA 2. AFFIDA- MENTO INCARICO PROF. PER REDAZIONE DI ASSERVAZIONI E CERTIFICA- ZIONI AI FINI PRESENTAZIONE O RINNOVO PRATICHE VV.F. AI SENSI DEL DPR 151/2011 ALL''ING. VERA RAVINA (CIG Z7F1F4B193). (U.I. EURO 11.419,20=)','32','CMTO','HE5',to_timestamp('10/07/2017','dd/MM/yyyy'), to_timestamp('16/06/2014','dd/MM/yyyy'), to_timestamp('29/08/2017','dd/MM/yyyy')), 
(2017,17639,'SPESE RELATIVE AI SERVIZI TELEMATICI DI BASE ANCITEL SPA  (CIG Z501F4DCCB) PROPEDEUTICI AL SERVIZIO DI VISURA TARGHE AUTO- VEICOLI PER ATTIVITA'' DI VIGILANZA AMBIENTALE EFFETTUATO DALL''ACI -PRA (CIG Z3F1F4DD1D) (U.I. EURO 1.462,78) - (U.I. EURO 407,11).','32','CMTO','IAG',to_timestamp('10/07/2017','dd/MM/yyyy'), to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('11/09/2017','dd/MM/yyyy')), 
(2014,18423,'PIANO DI SORVEGLIANZA SANITARIA E DI CONOSCENZA DELLA VAR.  DELLO STATO DI SALUTE DELLA POPOLAZIONE RES.REL.ALL''IMP.DI TERMOVALORIZ ZAZIONE DEI RIFIUTI DELLA PROV.DI.TO PROPOSTO DA TRM SPA.APP.DEL- LO SCHEMA DI PROT. D''INTESA DEF. REL.ALL''INTERO PSS FRA PROVINCIA TO ARPA ASL TO3 ASL TO1 E ISTIT SUPER. SANITA''. US E.1443.664,38.','1','CMTO','LB7',to_timestamp('05/06/2014','dd/MM/yyyy'), to_timestamp('14/05/2019','dd/MM/yyyy'), to_timestamp('06/06/2014','dd/MM/yyyy')), 
(2017,18907,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/2002 E DALLA  D.G.R. DELLA REGIONE PIEMONTE N.30 DEL 21/05/2004.  DETERMINAZIONE COMPENSI PER COMMISSIONI ANNI 2014-2015-2016. (U./S. EURO 10.533,60)','32','CMTO','IA8',to_timestamp('26/07/2017','dd/MM/yyyy'), to_timestamp('26/02/2019','dd/MM/yyyy'), to_timestamp('30/10/2017','dd/MM/yyyy')), 
(2008,18921,'D.P.R. 290/2001 -CORSI DI FORMAZIONE PER IL RILASCIO E IL RINNOVO DELL''AUTORIZZAZIONE PER ACQUISTO ED IMPIEGO DEI PRODOTTI  FITOSANITARI MOLTO TOSSICI, TOSSICI E NOCIVI. APPROVAZIONE DEL PIANO CORSI E DELLO SCHEMA DI CONVENZIONE CON GLI ENTI  GESTORI-ANNO 2008- (E.A./U.I. EURO 76.951,95-U.S. EURO 23.548,05)','1','CMTO','MD4',to_timestamp('27/02/2008','dd/MM/yyyy'), to_timestamp('02/12/2019','dd/MM/yyyy'), to_timestamp('26/03/2008','dd/MM/yyyy')), 
(2014,20679,'INDENNITA'' DI PRESENZA AI COMPONENTI COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/2002 E DGR N.30 DEL 21/05/2004.RIDUZIONE OPERAZIONI CONTABILI E INTEGRAZIONI DI SPESA PER COMMISSIONI ANNO 2014. (U.S. EURO 2.413,00) (IRAP EURO 196,35) (RIDUZIONI DI SPESA EURO 3.171,56)','32','CMTO','IA8',to_timestamp('16/06/2014','dd/MM/yyyy'), to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('31/07/2014','dd/MM/yyyy')), 
(2017,20697,'PROGRAMMA INTERREG SPAZIO ALPINO - PROGETTI SCALE(UP)ALPS E DES ALPS E PROGRAMMA INTERREG EUROPE - PROGETTI FFWD EUROPE E ECORIS3 AUTORIZZAZIONE ALL''INDIZIONE DI UNA PROCEDURA NEGOZIATA SUL MEPA  E APPROVAZIONE DEL CAPITOLATO D''ONERI PER L''AFFIDAMENTO DEL SERVI ZIO DI CONTROLLO DI PRIMO LIVELLO CIG Z081FB8FD6','32','CMTO','MD3',to_timestamp('29/08/2017','dd/MM/yyyy'), to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('11/09/2017','dd/MM/yyyy')), 
(2017,20768,'INTERVENTI DI MANUTENZIONE ORDINARIA PER MESSA IN SICUREZZA DI  EDIFICI SEDI DI UFFICI DELL''ENTE. OPERE DA ELETTRICISTA.   AFFIDAMENTO INTERVENTI SUPPLEMENTARI A ELETTRO 2000 TLC S.R.L.  (U.I. EURO 16.218,25  - U./PR EURO 439,51)','32','CMTO','FA3',to_timestamp('30/08/2017','dd/MM/yyyy'), to_timestamp('04/07/2018','dd/MM/yyyy'), to_timestamp('21/09/2017','dd/MM/yyyy')), 
(2018,20988,'PIANO DI INTERVENTO TRIENNALE DI MANUTENZIONE ORDINARIA DI  MODESTA ENTITA'' DELLE SP DI COMPETENZA DEL SERVIZIO VIABILITA'' 1. INDIVIDUAZIONE MODALITA'' DI AFFIDAMENTO MEDIANTE PROCEDURA APERTA (PROG. LL.PP. N. 3585/2018)(U.PR. EURO 790.560,00)','32','CMTO','HE7',to_timestamp('07/08/2018','dd/MM/yyyy'), to_timestamp('28/05/2018','dd/MM/yyyy'), to_timestamp('16/08/2018','dd/MM/yyyy')), 
(2018,21115,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/2002 E DALLA DGR N.30 DEL 21/05/2004. DETERMINAZIONE COMPENSI PER COMMISSIONI ANNO 2017 E PRIMO SEMESTRE 2018. SECONDO IMPEGNO DI SPESA PER INDENNI TA'' 2018 (U.PR. EU 2.156,00 - U.I. EU 1.987,83 - U.S. EU4.596,90)','32','CMTO','IA8',to_timestamp('08/08/2018','dd/MM/yyyy'), to_timestamp('28/11/2019','dd/MM/yyyy'), to_timestamp('21/09/2018','dd/MM/yyyy')), 
(2018,21512,'PIANO DI INTERVENTO TRIENNALE DI RAPPEZZATURA PAVIMENTAZIONE STRADALE PER LA MANUTENZIONE ORDINARIA DELLE S.P. DI COMPETENZA  SERVIZIO VIABILITA'' 1. INDIVIDUAZIONE MODALITA'' DI AFFIDAMENTO MEDIANTE PROCEDURA APERTA. (PROG. LL.PP. N. 3643/2016) (U.PR. EURO 658.800,00=)','32','CMTO','HE7',to_timestamp('27/08/2018','dd/MM/yyyy'), to_timestamp('04/12/2018','dd/MM/yyyy'), to_timestamp('04/09/2018','dd/MM/yyyy')), 
(2018,21796,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA. STAGIONI 2017/18, 2018/19, 2019/20, 2020/21. AUMENTO DELLE PRESTAZ. CONTRATTUALI ENTRO IL LIMITE DI  UN QUINTO AI SENSI DELL''ART. 106. C. 12 DEL D. LGS. 50/2016 E SMI PER I LOTTI 1.08,1.10,1.21,1.21,1.25. (U.I. EURO 87748,89)','32','CMTO','HE2',to_timestamp('29/08/2018','dd/MM/yyyy'), to_timestamp('27/08/2018','dd/MM/yyyy'), to_timestamp('17/09/2018','dd/MM/yyyy')), 
(2018,23057,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO A CALDO MEZZI OPERAT. PER MANUTENZIONE ORDINARIA DELLE S.P. DI COMPETENZA DEL SERVIZIO VIABILITA'' 1. APPROVAZIONE PROGETTO E INDIVIDUAZIONE MODALITA'' DI GARA. (U. PR. EURO 401.760,00)','32','CMTO','HE7',to_timestamp('07/09/2018','dd/MM/yyyy'), to_timestamp('05/06/2014','dd/MM/yyyy'), to_timestamp('13/09/2018','dd/MM/yyyy')), 
(2018,23294,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO A CALDO DI MEZZI  OPERATIVI PER LA MANUTENZIONE ORDINARIA  DELLE S.P. DI COMPETENZA DEL SERVIZIO VIABIILITA'' 2. APPROVAZIONE PROGETTO E INDIVIDUAZIO- NE MODALITA'' DI GARA. (U.PR. EURO 279.000,00)','32','CMTO','HE8',to_timestamp('13/09/2018','dd/MM/yyyy'), to_timestamp('29/08/2017','dd/MM/yyyy'), to_timestamp('08/10/2018','dd/MM/yyyy')), 
(2018,23660,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA. STAGIONI 2017/18, 2018/19, 2019/20,  2020/21. AUMENTO DELLE PRESTAZIONI CONTRATTUALI ENTRO IL LIMITE DEL V? AI SENSI DELL''ART. 106, COMMA 12 DEL DLGS 50/2016 PER I   LOTTI 2.05, 2.15, 2.16, 2.19. (U.I. EURO 106.872,00)','32','CMTO','HE2',to_timestamp('21/09/2018','dd/MM/yyyy'), to_timestamp('07/09/2018','dd/MM/yyyy'), to_timestamp('28/09/2018','dd/MM/yyyy')), 
(2015,23735,'ESAMI PER L''ACCERTAMENTO DELL''IDONEITA'' PROFESSIONALE IN ATTUAZIO NE DELL''ART. 105, COMMA III, LETTERE C) E G) DEL D.LGS. 31 MARZO  1998 N. 112. ACCERTAMENTO E RISCOSSIONE - ANNO 2014. (E/A-U/PR EURO 10.324,26 - E/R EURO 2.423,48)','32','CMTO','IA8',to_timestamp('29/07/2015','dd/MM/yyyy'), to_timestamp('18/12/2019','dd/MM/yyyy'), to_timestamp('22/09/2015','dd/MM/yyyy')), 
(2018,24720,'IST.VITTONE-SUCCURSALE AGRARIO-STRADA PECETTO,34H CHIERI.INCARICO DI COLLAUDO STRUTTURALE RIGUARDANTI LA NUOVA SERRA DELL''ISTITUTO. PROCEDURA DI ACQUISTO,TRAMITE TRATTATIVA DIRETTA, SUL MEPA DELL'' INCARICO PROFESSIONALE ALL''ING.FIORE MALETTA.(CIG Z8424D3689) (U.I. EURO 3.470,41)','32','CMTO','HE5',to_timestamp('01/10/2018','dd/MM/yyyy'), to_timestamp('05/02/2018','dd/MM/yyyy'), to_timestamp('19/10/2018','dd/MM/yyyy')), 
(2018,24855,'PIANO DI INTERVENTO TRIENNALE DI MANUTENZIONE ORDINARIA DI MODESTA ENTITA'' DELLE S.P. DI COMPETENZA DEL SERVIZIO VIABILITA'' 3. LOTTO 1 U.O. - ZONA OMOGENEA 9 - EPOREDIESE. PROCEDURA APERTA. AGGIUDICAZIONE DEFINITIVA A SOREMA S.R.L. (PROG. LL.PP. 3317/2018 CIG 75669772F6) (U.S. EURO 197.640,00=).','32','CMTO','HE9',to_timestamp('03/10/2018','dd/MM/yyyy'), to_timestamp('12/07/2019','dd/MM/yyyy'), to_timestamp('15/10/2018','dd/MM/yyyy')), 
(2018,24867,'ACCORDO QUADRO PER IL SERVIZIO DI MANUTENZIONE TRATTORI E TRINCE AFFIDAMENTO AL CONSORZIO PARTS & SERVICES. CIG 7569458259 (U. PR. EURO 150.232,00)','32','CMTO','HE0',to_timestamp('03/10/2018','dd/MM/yyyy'), to_timestamp('11/10/2018','dd/MM/yyyy'), to_timestamp('15/10/2018','dd/MM/yyyy')), 
(2018,24868,'ACCORDO QUADRO PER IL SERVIZIO DI RIPARAZIONE MEZZI MECCANICI AFFIDAMENTO AL CONSORZIO PARTS & SERVICES. CIG 757316771B  (U. PR. EURO 75.000,00)','32','CMTO','HE0',to_timestamp('03/10/2018','dd/MM/yyyy'), to_timestamp('12/10/2018','dd/MM/yyyy'), to_timestamp('15/10/2018','dd/MM/yyyy')), 
(2017,24896,'PROGRAMMA INTERREG SPAZIO ALPINO PROGETTI SCALE(UP)ALPS E DES ALP PROGRAMMA INTERREG EUROPE PROGETTI FFWD E ECORIS3 PROGRAMMA ALCO- TRA PROGETTO VALE AFFIDAMENTO A CODEX SC DEL SERVIZIO DI ASSISTEN ZA PER LE ATTIVITA'' DI RENDICONTAZIONE TECNICA E FINANZIARIA E  SUPPORTO ALLA GESTIONE E COORDINAMENTO(EA-UI E. 47.828,88)','32','CMTO','MD3',to_timestamp('04/09/2017','dd/MM/yyyy'), to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('21/09/2017','dd/MM/yyyy')), 
(2017,25142,'MANUTENZIONE ORDINARIA E VERIFCHE IMPIANTI DI SICUREZZA NEGLI  EDIFICI DI COMPETENZA DEL SERVIZIO LOGISTICA. AFFIDAMENTO DIRETTO EX ART. 36, COMMA 2, LETTERA A) DEL D.LGS. 50/2016 E S.M.I.  ALL''IMPRESA S.E.C.A.P. S.P.A.. C.I.G. ZB91FA6A57. (U.I. EURO 25.258,88  -  U.PR. EURO 414,00).','32','CMTO','FA3',to_timestamp('11/09/2017','dd/MM/yyyy'), to_timestamp('14/11/2018','dd/MM/yyyy'), to_timestamp('28/09/2017','dd/MM/yyyy')), 
(2018,25474,'PIANO DI INTERVENTO TRIENNALE DI RAPPEZZATURA DELLA PAVIMENTAZIONE STRADALE PER LA MANUTENZIONE ORDINARIA DELLE STRADE PROVINCIALI DI COMPETENZA DEL SERVIZIO VIABILITA'' 2.  APPROVAZIONE PROGETTO DEFINITIVO E INDIVIDUAZIONE MODALITA'' DI  GARA (PROG. LL.PP. N. 3713/2018) (U./PR. EURO 558.000,00=)','32','CMTO','HE8',to_timestamp('11/10/2018','dd/MM/yyyy'), to_timestamp('04/09/2017','dd/MM/yyyy'), to_timestamp('08/11/2018','dd/MM/yyyy')), 
(2018,25526,'INTERVENTI DI MO PRESSO EDIFICI SCOLASTICI DEL SERVIZIO EDILIZIA SCOLASTICA 2. LOTTO 1-ZONE TERRITORIALI 2A E 2B. APPROV. MODIFICA CONTRATTO, AI SENSI DELL''ART. 106, COMMA 1, LETT B DEL DLGS 50/16 (PROG. N. 30944/17 CIG ORIG. 7286760892 CIG MODIFICA CONTRATTO 764948283C) (UI EURO 75.640,00 UPR EURO 1.240,00=)','32','CMTO','HE5',to_timestamp('11/10/2018','dd/MM/yyyy'), to_timestamp('02/05/2018','dd/MM/yyyy'), to_timestamp('26/10/2018','dd/MM/yyyy')), 
(2018,25547,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA. STAGIONI 2017/18, 2018/19, 2019/20, 2020/21. AUMENTO DELLE PRESTAZIONI CONTRATTUALI ENTRO IL LIMITE  DEL QUINTO AI SENSI DELL''ART. 106, COMMA 12 DEL D.LGS 50/2016 E  S.M.I. PER IL LOTTO 3.02 (U.I. EURO 50.264,00)','32','CMTO','HE2',to_timestamp('12/10/2018','dd/MM/yyyy'), to_timestamp('05/04/2017','dd/MM/yyyy'), to_timestamp('27/11/2018','dd/MM/yyyy')), 
(2018,25564,'INTERVENTI DI MO PRESSO EDIFICI SCOLASTICI DEL SERVIZIO EDILIZIA SCOLASTICA 2-LOTO 2, ZONE TERRITORIALI 3A E 3B. APPROVAZIONE  MODIFICA CONTRATTO, AI SENSI DELL''ART. 106, COMMA 1, LETT. B DEL  DLGS N. 50/2016 (PR. N. 30944/17 CIG ORIG. 728679771B, CIG MODI- FICA CONTR. 7649527D5D (UI EURO 79300,00 UPR EURO 1300,00)','32','CMTO','HE5',to_timestamp('12/10/2018','dd/MM/yyyy'), to_timestamp('11/07/2018','dd/MM/yyyy'), to_timestamp('26/10/2018','dd/MM/yyyy')), 
(2018,25838,'PIANO DI INTERVENTO TRIENNALE  MANUTENZIONE ORDINARIA DI MODESTE ENTITA'' DELLE STRADE PROVINCIALI DI COMPETENZA DEL SERVIZIO VIABILITA'' 2. APPROVAZIONE PROGETTO DEFINITIVO E INDIVIDUAZIONE MODALITA'' DI AFFIDAMENTO MEDIANTE PROCEDURA APERTA.  (PROG. LL.PP. N. 3712/2018) (U.PR. EURO 669.600,00=)','32','CMTO','HE8',to_timestamp('16/10/2018','dd/MM/yyyy'), to_timestamp('13/10/2017','dd/MM/yyyy'), to_timestamp('26/11/2018','dd/MM/yyyy')), 
(2018,26805,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA. STAGIONI 2017/2018, 2018/2019,  2019/2020 E 2020/2021.IMPEGNI DI SPESA PER ANNI 2018- 2019- 2020 E 2021. (U.PR. EURO 1.057.088,55- U.I. EURO 18.980.238,77)','32','CMTO','HE2',to_timestamp('25/10/2018','dd/MM/yyyy'), to_timestamp('18/12/2017','dd/MM/yyyy'), to_timestamp('27/11/2018','dd/MM/yyyy')), 
(2018,26829,'PIANO TERRITORIALE INTEGRATO GRAIES LAB. PROCEDURA NEGOZIATA TELEMATICA TRAMITE R.D.O. SUL MEPA. APPROVAZIONE CAPITOLATO  D''ONERI PER L''AFFIDAMENTO DEI SERVIZI DI COMUNICAZIONE PER IL  PERIODO 2019-2022. (E.A. 2019-2020 EURO. 22.000,00= U.PR. 2019-2020 EURO 22.000,00=)','32','CMTO','AAA',to_timestamp('25/10/2018','dd/MM/yyyy'), to_timestamp('22/03/2006','dd/MM/yyyy'), to_timestamp('31/10/2018','dd/MM/yyyy')), 
(2018,26832,'PIANO INTEGRATO TERRITORIALE LE ALTE VALLI-CUORE DELLE ALPI. PROCEDURA NEGOZIATA TELEMATICA TRAMITE R.D.O. SUL MEPA. APPROVA- ZIONE CAPITOLATO D''ONERI PER L''AFFIDAMENTO DEI SERVIZI DI COMUNICAZIONE PER IL PERIODO 2019-2022. (E.A. 2019-2020 EURO 30.000,00= U.PR. 2019-2020 EURO 30.000,00=)','32','CMTO','AAA',to_timestamp('25/10/2018','dd/MM/yyyy'), to_timestamp('23/12/2016','dd/MM/yyyy'), to_timestamp('31/10/2018','dd/MM/yyyy')), 
(2018,26837,'PIANO INTEGRATO TERRITORIALE LE ALTE VALLI - CUORE DELLE ALPI. PROCEDURA NEGOZIATA TELEMATICA TRAMITE R.D.O. SUL MEPA. APPROVA- ZIONE CAPITOLATO D''ONERI PER L''AFFIDAMENTO DEI SERVIZI DI  COMUNICAZIONE SOCIAL PER IL PERIODO 2019-2022. (E.A. 2019-2020 EURO 15.000,00= U.PR. 2019-2020 EURO 15.000,00=)','32','CMTO','AAA',to_timestamp('25/10/2018','dd/MM/yyyy'), to_timestamp('23/05/2017','dd/MM/yyyy'), to_timestamp('31/10/2018','dd/MM/yyyy')), 
(2018,27113,'INTERVENTI DI MANUTENZIONE ORDINARIA BISEMESTRALE IMPIANTI ANTIN- CENDIO DEGLI EDIFICI DELLA CITTA'' METROPOLITANA. APPROVAZIONE  PROGETTO DEFINITIVO E AUTORIZZAZIONE ALL''INDIZIONE DI UNA PRO- CEDURA NEGOZIATA SUL MEPA (PROG. N. 3828/2018) (U.PR. EURO 172.185,90=)','32','CMTO','HE3',to_timestamp('31/10/2018','dd/MM/yyyy'), to_timestamp('16/10/2018','dd/MM/yyyy'), to_timestamp('09/11/2018','dd/MM/yyyy')), 
(2018,27116,'CONCESSIONE A FAVORE DELLA CITTA'' METROPOLITANA DI TORINO E A  SERVIZIO DELL''I.I.S.BOBBIO DI CARIGNANO DELLA PALESTRA COMUNALE  SITA PRESSO LA SCUOLA PRIMARIA DI PRIMO GRADO DI VIA ROMA N.32 DI PROPRIETA'' DEL COMUNE DI CARIGNANO.ANNI SCOLASTICI 2018/2019- 2019/2020 -2020/2021.APPROVAZIONE SCHEMA DI CONTRATTO.','32','CMTO','FA5',to_timestamp('31/10/2018','dd/MM/yyyy'), to_timestamp('23/11/2017','dd/MM/yyyy'), to_timestamp('13/11/2018','dd/MM/yyyy')), 
(2017,27220,'PROGRAMMA INTERREG SPAZIO ALPINO PROGETTI SCALE (UP)ALPS E DES  ALPS E PROGRAMMA INTERREG EUROPE PROGETTI FFWD E ECORIS3 AFFIDA- MENTO DEL SERVIZIO DI CONTROLLO DI PRIMO LIVELLO ALLA SOCIETA''  SELENE AUDIT SRL. CIG Z081FB8FD6','32','CMTO','MD3',to_timestamp('13/10/2017','dd/MM/yyyy'), to_timestamp('28/11/2019','dd/MM/yyyy'), to_timestamp('05/12/2017','dd/MM/yyyy')), 
(2018,27356,'COMMISSIONE PROVINCIALE ESPROPRI.  GETTONI DI PRESENZA DEI COMPONENTI - COSTITUZIONE FONDO -  PRENOTAZIONE DI SPESA PER L''ANNO 2018. (U.PR. EURO 2.050,65=)','32','CMTO','BA2',to_timestamp('07/11/2018','dd/MM/yyyy'), to_timestamp('13/11/2015','dd/MM/yyyy'), to_timestamp('06/12/2018','dd/MM/yyyy')), 
(2018,27521,'PIANO DI INTERV. TRIENNALE DI MANUTENZ. ORDIN. DI MODESTA ENTITA'' DELLE SP DI COMPETENZA DEL SERV. VIABILITA'' 3. LOTTO 4. U.O. 10- ZONA OMOG. 7-CIRIACESE E VALLI DI LANZO. (PROG. 3317/2018 - CIG 7567050F30).PROC. APERTA. APPROV. OPERAZ. DI GARA E AGG. DEFIN. A SOC. COOP. AGR. VALLI UNITE DEL CANAVESE. (U.S. EURO 197.640,00)','32','CMTO','HE9',to_timestamp('09/11/2018','dd/MM/yyyy'), to_timestamp('04/12/2019','dd/MM/yyyy'), to_timestamp('21/11/2018','dd/MM/yyyy')), 
(2018,27552,'FORNITURA E INSTALLAZIONE DI N. 2 DEFIBRILLATORI PRESSO LA SEDE  SI C.SO INGHILTERRA- TORINO E MANUTENZIONE QUADRIENNALE DEGLI  STESSI. AFFIDAMENTO ALLA DITTA CARDIOSAFE SRL. CIG Z44255090D - CUP J19F18000740003. (U.I. EURO 4.029,32).','32','CMTO','FAC',to_timestamp('12/11/2018','dd/MM/yyyy'), to_timestamp('28/12/2016','dd/MM/yyyy'), to_timestamp('26/11/2018','dd/MM/yyyy')), 
(2018,27555,'ACQUISTI E FORNITURE DI DOCUMENTAZIONE TECNICO GIURIDICA PER GLI  ORGANI E GLI UFFICI METROPOLITANI.   U.L. EURO 239,99','32','CMTO','BA3',to_timestamp('12/11/2018','dd/MM/yyyy'), to_timestamp('30/08/2017','dd/MM/yyyy'), to_timestamp('23/11/2018','dd/MM/yyyy')), 
(2016,27663,'PIANO DI INTERVENTI DI MANUTENZIONE ORDINARIA DI MODESTA ENTITA'' SULLE STRADE DI COMPETENZA DEL SERVIZIO  ESERCIZIO VIABILITA''.  LAVORI COMPLEMENTARI. AGGIUDICAZIONE DEFINITIVA. LOTTI NN. 1-2-3. (UI EURO 72.834,00)','32','CMTO','HE0',to_timestamp('21/10/2016','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy'), to_timestamp('16/11/2016','dd/MM/yyyy')), 
(2018,27755,'ACCORDO QUADRO PER IL SERVIZIO DI MANUTENZIONE DEL PARCO AUTO DELL''ENTE. AGGIUDICAZIONE DEL LOTTO 3 - ZONA DI SUSA-PINEROLO - ALLA DITTA PARTS & SERVICES.  CIG 7614418084 (U/PR  EURO 43.920,00)','32','CMTO','FAB',to_timestamp('14/11/2018','dd/MM/yyyy'), to_timestamp('12/11/2018','dd/MM/yyyy'), to_timestamp('11/12/2018','dd/MM/yyyy')), 
(2017,28426,'NOLEGGIO ATTREZZATURE D''UFFICIO PRODUTTIVITA'' MEDIA PER I CENTRI PER L''IMPIEGO - ADESIONE A CONVENZIONE CONSIP. CIG CONSIP 6510969D94  - CIG DERIVATO 7254942787. (U.I. EURO 37.712,64)','32','CMTO','FAC',to_timestamp('27/10/2017','dd/MM/yyyy'), to_timestamp('27/11/2018','dd/MM/yyyy'), to_timestamp('05/12/2017','dd/MM/yyyy')), 
(2018,28491,'PRENOTAZIONE IMPEGNO DI SPESA PER LA FORNITURA DI ENERGIA  ELETTRICA FUORI CONVENZIONE PER L''ANNO 2019. (U.PR. EURO 31.400,00)','32','CMTO','FAC',to_timestamp('27/11/2018','dd/MM/yyyy'), to_timestamp('03/10/2018','dd/MM/yyyy'), to_timestamp('27/12/2018','dd/MM/yyyy')), 
(2017,28496,'FORNITURA DI GAS NATURALE SUL MERCATO LIBERO. ADESIONE ALLA CONVENZIONE FORNITURA DI GAS NATURALE 9 TRA CONSIP S.P.A. E     ENERGETIC S.P.A. AGGIUDICATARIA DEL LOTTO 1. AFFIDAMENTO A  ENERGETIC S.P.A. CIG CONSIP 6644186BBA CIG DERIVATO 72581162CD. (U.PR. EURO 220.000,00)','32','CMTO','FAC',to_timestamp('30/10/2017','dd/MM/yyyy'), to_timestamp('20/12/2018','dd/MM/yyyy'), to_timestamp('07/11/2017','dd/MM/yyyy')), 
(2018,28541,'PRENOTAZIONE IMPEGNO DI SPESA PER LA FORNITURA DI GAS METANO FUORI CONVENZIONE PER L''ANNO 2019. (U.PR. EURO 11.100,00)','32','CMTO','FAC',to_timestamp('27/11/2018','dd/MM/yyyy'), to_timestamp('03/10/2018','dd/MM/yyyy'), to_timestamp('11/12/2018','dd/MM/yyyy')), 
(2017,28579,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI DELLA ZONA TERRITORIALE 1A. AFFIDAMENTO LAVORI SUPPLEMENTARI A EDILMAR SRL. PROG. LLPP N. 27657/2017. CIG. ZCD2090E2E (U.I. EURO 40.272,07 - U.PR. EURO 928,09)','32','CMTO','HE4',to_timestamp('02/11/2017','dd/MM/yyyy'), to_timestamp('11/04/2016','dd/MM/yyyy'), to_timestamp('13/11/2017','dd/MM/yyyy')), 
(2017,28581,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI DELLA ZONA TERRITORIALE 1B. AFFIDAMENTO LAVORI SUPPLEMENTARI A IMEG SRL. PROG. LLPP N. 27656/2017. CIG. ZD62090EA5 (U.I. EURO 40.276,85 - U.PR. EURO 899,22)','32','CMTO','HE4',to_timestamp('02/11/2017','dd/MM/yyyy'), to_timestamp('19/06/2018','dd/MM/yyyy'), to_timestamp('13/11/2017','dd/MM/yyyy')), 
(2018,28652,'PIANO DI INTERV. TRIENNALE DI MANUTENZ. ORDIN. DI MODESTA ENTITA'' DELLE SP DI COMPETENZA DEL SERV. VIABILITA'' 3. LOTTO 3. U.O. 9- ZONA OMOG. 7-CIRIACESE E VALLI DI LANZO E 8- CANAVESE OCCIDENTALE (PROG. 3317/2018-CIG 7567028D09). PR. APERTA. APPR. OPER. DI GARA E AGG. DEFIN. A DITTA CITRINITI GEOM. MASSIMO.(U.S E. 197.640,00)','32','CMTO','HE9',to_timestamp('29/11/2018','dd/MM/yyyy'), to_timestamp('06/03/2019','dd/MM/yyyy'), to_timestamp('12/12/2018','dd/MM/yyyy')), 
(2018,28694,'IIS MICHELE BUNIVA SEDE DI VIA DEI ROCHIS 25, PINEROLO (TO)-LICEO PORPORATO,SEDE, DI VIA BRIGNONE 2 PINEROLO (TO).ESECUZIONE DI PROVE SUI MATERIALI STRUTTURALI FINALIZZATE ALLA VERIFICA DI  VULNERABILITA'' SISMICA.APPROVAZ.E AFFIDAMENTO LAVORI ALL''IMPRESA  P.Q.R.S. SRL  (CIG ZF52608A0B)          (U.I. EURO 28.871,06)','32','CMTO','HE4',to_timestamp('29/11/2018','dd/MM/yyyy'), to_timestamp('29/11/2018','dd/MM/yyyy'), to_timestamp('18/12/2018','dd/MM/yyyy')), 
(2018,29058,'SERV. DI MANUT. DEL VERDE A RIDOTTO IMPATTO AMBIENTALE NEGLI EDIFICI SEDI DI UFFICI DI COMPETENZA DELL''ENTE, PER IL PERIODO 2^  SEMESTRE 2018 - ANNO 2019 - ANNO 2020. AFFIDAMENTO MEDIANTE RDO SUL MEPA, EX ART. 36, COMMA 2, LETT. B) DEL D.LGS. 50/2016 E  S.M.I. A G.R.V. SRL. CIG 76690983E0. (U./PR. 71.987,83)','32','CMTO','FA3',to_timestamp('03/12/2018','dd/MM/yyyy'), to_timestamp('23/11/2017','dd/MM/yyyy'), to_timestamp('13/12/2018','dd/MM/yyyy')), 
(2018,29068,'RIMBORSO SPESE CARBURANTE DELLE GUARDIE ECOLOGICHE VOLONTARIE. I SEMESTRE 2018. (U.I. EURO 14.429,,45).','32','CMTO','IAG',to_timestamp('04/12/2018','dd/MM/yyyy'), to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('19/12/2018','dd/MM/yyyy')), 
(2018,29360,'PIANO INTEGRATO TERRITORIALE ALCOTRA LE ALTI VALLI - CUORE DELLE ALPI. AFFIDAMENTO SERVIZIO DI ASSISTENZA TECNICA PER IL PERIODO 2019-2022 PREVIA TRATTATIVA DIRETTA MEPA A BUSINESS DEVELOPMENT MANAGEMENT S.R.L. - CIG. Z7F261C458 (E.A./UI 2019-20 EURO 12.600,00/ U.I. 2021-22 EURO 10.399,44=)','32','CMTO','AAA',to_timestamp('10/12/2018','dd/MM/yyyy'), to_timestamp('22/12/2017','dd/MM/yyyy'), to_timestamp('28/12/2018','dd/MM/yyyy')), 
(2018,29545,'ACCORDO QUADRO PER IL SERVIZIO DI RIPARAZIONI MECCANICHE ELETTRI CHE ED ELETTRONICHE DI AUTOCARRI DI MASSA INF. 35 QUINTALI AFFIDAMENTO ALLA DITTA AUTORIPARAZIONI NATALE SRL CIG 7550508C4D (U.PR EURO 100.000,00)','32','CMTO','HE0',to_timestamp('12/12/2018','dd/MM/yyyy'), to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('20/12/2018','dd/MM/yyyy')), 
(2018,30874,'NOLEGGIO FOTOCOPIATORI OLIVETTI D-COPIA 5000MF CONSIP 26 LOTTO 3 PRODUTTIVITA'' MEDIA - CIG DERIVATO 725470866D. REIMPUTAZIONE IMPEGNI ANNO 2021. (U.I. EURO 40.992,00).','32','CMTO','FAC',to_timestamp('20/12/2018','dd/MM/yyyy'), to_timestamp('12/12/2018','dd/MM/yyyy'), to_timestamp('28/12/2018','dd/MM/yyyy')), 
(2018,30876,'NOLEGGIO FOTOCOPIATORI OLIVETTI D-COPIA 5000MF PRODUTTIVITA'' BASSA CONSIP 26 LOTTO 3 - REIMPUTAZIONE IMPEGNI ANNO 2021. CIG DERIVATO 7254788871. (U.I. EURO 5.709,96).','32','CMTO','FAC',to_timestamp('20/12/2018','dd/MM/yyyy'), to_timestamp('14/12/2017','dd/MM/yyyy'), to_timestamp('28/12/2018','dd/MM/yyyy')), 
(2017,30885,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI  DELLA ZONA TERRITORIALE 3A. AFFIDAMENTO LAVORI SUPPLEMENTARI ALLA IMPRESA L''ARCOBALENO DI BOFFA ANGELO.  PROG. LL.PP. N. 27651/2017 - CIG Z9020A5BC4 (U.I. EURO 41.541,00 - U.PR. EURO 912,19)','32','CMTO','HE5',to_timestamp('07/11/2017','dd/MM/yyyy'), to_timestamp('01/12/2014','dd/MM/yyyy'), to_timestamp('14/11/2017','dd/MM/yyyy')), 
(2017,30886,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI  DELLA ZONA TERRITORIALE 2B. AFFIDAMENTO LAVORI SUPPLEMENTARI A C.S.G. COSTRUZIONI S.R.L. PROG. LL.PP. N. 27652/2017 -  CIG ZDA20A38CE (U.I. EURO 39.339,78 - U.PR. 899,17)','32','CMTO','HE5',to_timestamp('07/11/2017','dd/MM/yyyy'), to_timestamp('29/07/2015','dd/MM/yyyy'), to_timestamp('14/11/2017','dd/MM/yyyy')), 
(2017,31041,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI  DELLA ZONA TERRITORIALE 3B. AFFIDAMENTO LAVORI SUPPLEMENTARI A FLORIO PIETRO S.R.L.. PROG. LL.PP. 27650/2017. CIG Z6D20B581E (U.I. EURO 39.528,00=, U.PR. EURO 909,96=)','32','CMTO','HE5',to_timestamp('10/11/2017','dd/MM/yyyy'), to_timestamp('11/12/2015','dd/MM/yyyy'), to_timestamp('16/11/2017','dd/MM/yyyy')), 
(2017,31851,'NOLEGGIO ATTREZZATURE D''UFFICIO PRODUTTIVITA'' MEDIA PER I  SERVIZI DELLA CITTA'' METROPOLITANA DI TORINO - IMPEGNI ANNI 2018  E 2019 - CIG DERIVATO 725470866D. (U.I. EURO 81.894,00).','32','CMTO','FAC',to_timestamp('23/11/2017','dd/MM/yyyy'), to_timestamp('20/12/2018','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,31852,'NOLEGGIO ATTREZZATURE D''UFFICIO PRODUTTIVITA'' BASSA PER I SERVIZI DELLA CITTA'' METROPOLITANA DI TORINO - IMPEGNI ANNI 2018 E 2019. CIG DERIVATO 7254788871. (U.I. EURO 11.419,92).','32','CMTO','FAC',to_timestamp('23/11/2017','dd/MM/yyyy'), to_timestamp('21/11/2013','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,32383,'ABBONAMENTI E SPAZI INFORMATIVI SU TESTATE GIORNALISTICHE NAZIONA LI E LOCALI.  AFFIDAMENTI VARI.   (U.I. EURO 3615,01.=)','32','CMTO','AA7',to_timestamp('30/11/2017','dd/MM/yyyy'), to_timestamp('12/11/2018','dd/MM/yyyy'), to_timestamp('27/12/2017','dd/MM/yyyy')), 
(2016,34052,'DETERMINAZIONE A CONTRARRE PER L''AFFIDAMENTO DEL  SERVIZIO DI PULIZIA, RETTIFICA E TARATURA ATTREZZATURE AD AZIMUT PIEMONTE  SRL.  CIG Z8A1C5BC12 (U.I. 707,60)','32','CMTO','HE0',to_timestamp('05/12/2016','dd/MM/yyyy'), to_timestamp('13/07/2018','dd/MM/yyyy'), to_timestamp('27/12/2016','dd/MM/yyyy')), 
(2016,34164,'PRENOTAZIONE IMPEGNO DI SPESA PER LA FORNITURA DI GAS METANO FUORI CONVENZIONE PER L''ANNO 2017. (U. PR. EURO 9.000.00)','32','CMTO','FAC',to_timestamp('06/12/2016','dd/MM/yyyy'), to_timestamp('27/11/2018','dd/MM/yyyy'), to_timestamp('31/01/2017','dd/MM/yyyy')), 
(2016,34953,'OPPOSIZIONE A DECRETO INGIUNTIVO ESECUTIVO EMESSO DAL TRIBUNALE  DI TORINO IN FAVORE DELL''AZ.FERROGLIO PAOLA, ESERCENTE ATTIVITA''  DI COLTIVAZIONI AGRICOLE NEL PARCO REGIONALE LA MANDRIA (R.G. N. 33621/14) - IMPEGNO FONDO SPESE A FAVORE DEL CTU, COME DA  ASSEGNAZIONE DEL GIUDICE (E.A./U.I. EURO 761,28)','32','CMTO','MD7',to_timestamp('19/12/2016','dd/MM/yyyy'), to_timestamp('02/12/2019','dd/MM/yyyy'), to_timestamp('29/12/2016','dd/MM/yyyy')), 
(2017,35281,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA DELLA CITTA'' METROPOLITANA. STAGIONI 2017-2018, 2018-2019,  2019-2020, 2020-2021. BANDO N. 1. LOTTI 2.04, 2.05, 2.06, 2.19,  2.20, 2.21, 3.10, 3.11, 3.22, 3.24. PROCEDURE APERTE.  AGGIUDICAZIONI DEFINITIVE (U.I. 2.202.027,45)','32','CMTO','HE2',to_timestamp('14/12/2017','dd/MM/yyyy'), to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('28/12/2017','dd/MM/yyyy')), 
(2016,35379,'FORMAZIONE OBBLIGATORIA IN MATERIA DI SALUTE E SICUREZZA NEI NEI LUOGHI DI LAVORO - CONVENZIONE CONSIP - RTI EXITONE S.P.A., STUDIO ALFA S.R.L. - AFFIDAMENTO (CIG DERIVATO 6925766AE5). IMPEGNO DI SPESA  (U.I. EURO 23.595,00).','32','CMTO','DA3',to_timestamp('23/12/2016','dd/MM/yyyy'), to_timestamp('02/05/2018','dd/MM/yyyy'), to_timestamp('30/12/2016','dd/MM/yyyy')), 
(2017,35479,'COMMISSIONE PROVINCIALE ESPROPRI. GETTONI DI PRESENZA DEI COMPONENTI - COSTITUZIONE FONDO -  PRENOTAZIONE DI SPESA PER L''ANNO 2017. (U.PR. EURO 781,20=)','32','CMTO','BA2',to_timestamp('14/12/2017','dd/MM/yyyy'), to_timestamp('26/04/2018','dd/MM/yyyy'), to_timestamp('27/12/2017','dd/MM/yyyy')), 
(2016,35545,'SERVIZI INVERNALI STAGIONE 2016- 2017 INTEGRAZIONE (U.I. EURO 717289,81) (U.PR. EURO 912769,00)','32','CMTO','HE0',to_timestamp('28/12/2016','dd/MM/yyyy'), to_timestamp('01/10/2018','dd/MM/yyyy'), to_timestamp('01/02/2017','dd/MM/yyyy')), 
(2016,35668,'PROCEDURA NEGOZIATA PER INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI DELLA ZONA TERRITORIALE 2B. PROGETTO N. 30559/2016 (CIG 68724068D5) AGGIUDICAZIONE DEFINITIVA A C.S.G. COSTRUZIONI SRL. (U.PR. EURO 78.679,56=   ECO. EURO 31.120,44=)','32','CMTO','HE5',to_timestamp('29/12/2016','dd/MM/yyyy'), to_timestamp('24/10/2008','dd/MM/yyyy'), to_timestamp('30/12/2016','dd/MM/yyyy')), 
(2016,35674,'PROCEDURA NEGOZIATA PER INTERVENTI DI MANUTENZIONE ORDINARIA  PRESSO EDIFICI SCOLASTICI DELLA ZONA TERRITORIALE 3A. PROGETTO 30560/2016 (CIG 6872470DA4) AGGIUDICAZIONE DEFINITIVA A L''ARCOBALENO DI BOFFA ANGELO. (U.PR. EURO 83.184,08=  ECO. EURO 27.561,27=)','32','CMTO','HE5',to_timestamp('29/12/2016','dd/MM/yyyy'), to_timestamp('12/10/2011','dd/MM/yyyy'), to_timestamp('30/12/2016','dd/MM/yyyy')), 
(2016,35675,'PROCEDURA NEGOZIATA PER INTERVENTI DI MANUTEZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI DELLA ZONA TERRITORIALE 3B. PROGETTO N. 30561/2016 (CIG 6872492FCB) AGGIUDICAZIONE DEFINITIVA A FLORIO PIETRO SRL. (U.PR. EURO 79.057,85=  ECO. EURO 31.962,15=)','32','CMTO','HE5',to_timestamp('29/12/2016','dd/MM/yyyy'), to_timestamp('03/12/2013','dd/MM/yyyy'), to_timestamp('30/12/2016','dd/MM/yyyy')), 
(2017,35709,'LAVORI DI MANUTENZIONE DEL GUADO SUL TORRENTE PELLICE. SP 152 DI ZUCCHEA. AFFIDAMENTO ALL''IMPRESA PASCHETTO F.LLI S.N.C. (LL.PP. N. 32140/2017 - CUP J66G17000400003 - CIG Z7A212CAB6) (U.I. EURO 29.706,23 - U.PR. EURO 409,91)','32','CMTO','HE8',to_timestamp('18/12/2017','dd/MM/yyyy'), to_timestamp('11/04/2018','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,36107,'PRESTAZIONI SANITARIE A CARICO DELLA CITTA'' METROPOLITANA DI TORINO PER L''ANNO 2018. (U.PR. EURO 4.900,00)','32','CMTO','DA6',to_timestamp('22/12/2017','dd/MM/yyyy'), to_timestamp('11/06/2018','dd/MM/yyyy'), to_timestamp('16/01/2018','dd/MM/yyyy')), 
(2017,36229,'SERVIZI FINALIZZATI ALLA MANUTENZIONE DELLE ATTREZZATURE IN  DOTAZIONE ALLA VIABILITA'' 1. ANNO 2017. (U.I. EURO 15.000,00)','32','CMTO','HE7',to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('08/08/2018','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,36232,'ACQUISTO DI BENI FINALIZZATI ALLA MANUTENZIONE ORDINARIA  DELLE STRADE. IN DOTAZIONE ALLA VIABILITA'' 1. (U.I. EURO 15.000,00)','32','CMTO','HE7',to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('10/07/2017','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,36241,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI  DEL SERVIZIO EDILIZIA SCOLASTICA 1. LOTTO 1 ZONE 1A E 1B. AGGIUDI CAZIONE DEFINIT. A SEGUITO PROC. NEG. A GI.MA SAS DI MANGIARACINA A. E C. E REIMPUT. SPESA (PROG. LL.PP. 30996/17 CIG 728480399A).  U.I. EURO 117.025,17 U. PR. EURO 7.780,51.','32','CMTO','HE4',to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('02/07/2018','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,36244,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI  DEL SERVIZIO EDILIZIA SCOLASTICA 1. LOTTO 2 ZONE 4A E 4B. AGGIUDI CAZIONE DEFINIT. A SEGUITO DI PROC. NEG. EDILMAVI TORINO SRL E  REIMPUTAZIONE DELLA SPESA (PROG. LL.PP. 30996/17 CIG 72848608A4) U.I. EURO 122.643,08 U. PR. EURO 2.683,56.','32','CMTO','HE4',to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('03/10/2018','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,36707,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI DEL SERVIZIO EDILIZIA SCOLASTICA 2. LOTTO 1. ZONE TERRITORIALI 2A E 2B. PROCEDURA APERTA. AGGIUDICAZIONE DEFINITIVA A ICEF SRL E REIMPUTAZIONE DELLA SPESA. (PROG. LL.PP. 30944/17 CIG 7286760892) U.I. EURO 154.399,95 U.PR. EURO 7.017,00 ECO. EURO 55.440,05','32','CMTO','HE5',to_timestamp('29/12/2017','dd/MM/yyyy'), to_timestamp('16/02/2016','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,36709,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI DEL SERVIZIO EDILIZIA SCOLASTICA 2. LOTTO 2. ZONE TERRITORIALI 3A E 3B. PROCEDURA APERTA. AGGIUDICAZIONE DEFINITIVA A CO.GE.CA. SRL E REIMPUTAZIONE DELLA SPESA (PROG. LL.PP.30944/17 CIG 728679771B) U.I. EURO 160.280,46 U.PR. EURO 3.497,74 ECO. EURO 53.081,80','32','CMTO','HE5',to_timestamp('29/12/2017','dd/MM/yyyy'), to_timestamp('15/02/2017','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2011,37104,'TRASFERIMENTI DALLA REGIONE PIEMONTE E DALLA PROVINCIA DI CUNEO.  ACCERTAMENTO E IMPEGNO EX ART. 183 COMMA V D.LGS. 267/00  (E/A  EURO 91.860,22 - U.I. EURO 91.860,22 - E/R  EURO 22.147,72  E.A. EU 2.442.837,00 - U.I. EU 2.442.837,00 U.S. EU 2.410.811,92)','32','CMTO','IA8',to_timestamp('12/10/2011','dd/MM/yyyy'), to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('25/11/2011','dd/MM/yyyy')), 
(2015,37530,'RIDUZIONE E REIMPUTAZIONE DI MOVIMENTI CONTABILI RELATIVI A LAVO- RI VARI DEL SERVIZIO LOGISTICA A SEGUITO DELLA QUARTA VARIAZIONE  DI BILANCIO .  - U.I   EURO 74.776,44)','32','CMTO','FA3',to_timestamp('13/11/2015','dd/MM/yyyy'), to_timestamp('15/06/2018','dd/MM/yyyy'), to_timestamp('31/12/2015','dd/MM/yyyy')), 
(2015,42566,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLA COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/2/2002 E DALLA  D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/05/20104. SECONDO  IMPEGNO DI SPESA PER L''ANNO 2015. (U./I. EURO 5.216,28)','32','CMTO','IA8',to_timestamp('11/12/2015','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy'), to_timestamp('28/12/2015','dd/MM/yyyy')), 
(2014,46183,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/2/02 E DALLA D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/5/2004. RIDUZIONE OPERAZIONI  CONTABILI ED IMPEGNI DI SPESA PER COMMISSIONI ANNO 2015. (U./S. EURO 3.087,56)','32','CMTO','IA8',to_timestamp('01/12/2014','dd/MM/yyyy'), to_timestamp('10/12/2019','dd/MM/yyyy'), to_timestamp('31/12/2014','dd/MM/yyyy')), 
(2013,47874,'CONTRATTI DI MANUTENZIONE ORDINARIA E RIPARATIVA DEGLI EDIFICI DI COMPETENZA PROVINCIALE. APPALTO QUINQUENNALE DEL SERVIZIO ENERGETICO NEGLI EDIFICI DI COMPETENZA PROVINCIALE. INDIRIZZI GENERALI. PROROGA ANNUALE. (U.I. EURO 2.659.864,17.=).','1','CMTO','HC0',to_timestamp('21/11/2013','dd/MM/yyyy'), to_timestamp('21/06/2018','dd/MM/yyyy'), to_timestamp('24/12/2013','dd/MM/yyyy')), 
(2013,49488,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/2002 E DALLA  D.G.R. DELLA REGIONE PIEMONTE N.30 DEL 21/05/2004. ANNO 2014. (U.S. EURO 4.524,00)','32','CMTO','IA8',to_timestamp('03/12/2013','dd/MM/yyyy'), to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('31/12/2013','dd/MM/yyyy')), 
(2008,53561,'ESAMI PER L''ACCERTAMENTO DELL''IDONEITA'' PROFESSIONALE IN  ATTUAZIONE DELL''ART. 105, III COMMA, LETTERE C) E G) DEL D.LGS. 31 MARZO 1998 N. 112. ( E/A EURO 10.000,00 - E/R EURO 7.039,38 - U/I EURO 10.000,00)','32','CMTO','IA8',to_timestamp('24/10/2008','dd/MM/yyyy'), to_timestamp('14/03/2019','dd/MM/yyyy'), to_timestamp('19/11/2008','dd/MM/yyyy')), 
(2006,94348,'ARGINATURA IN SINISTRA DORA BALTEA A PROTEZIONE DELL''ABITATO DI  MONTALTO DORA NEI COMUNI DI MONTALTO DORA E IVREA. CONFERMA  IMPEGNO DI SPESA E PAGAMENTI  US EURO 350.000,00.= U.L. =151.071,65= (PRAT N 24/2005)','32','CMTO','BA6',to_timestamp('22/03/2006','dd/MM/yyyy'), to_timestamp('11/09/2017','dd/MM/yyyy'), to_timestamp('04/05/2006','dd/MM/yyyy')) 

) AS tmp(anno, numero, descrizione, tipo, ENTE, settore, data_creazione, data_modifica, data_validita_inizio)
join cpass_d_provvedimento_tipo t on t.provvedimento_tipo_codice = tmp.tipo
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
join cpass.cpass_t_ente en on en.ente_codice = tmp.ente

WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_t_provvedimento p
	WHERE p.provvedimento_anno = tmp.anno
	and   p.provvedimento_numero = tmp.numero::VARCHAR
	and   p.provvedimento_tipo_id = t.provvedimento_tipo_id
	and   p.settore_id = ts.settore_id
);




delete from cpass.CPASS_T_SETTORE_INDIRIZZO;
INSERT INTO cpass.CPASS_T_SETTORE_INDIRIZZO (settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,settore_id,data_creazione,utente_creazione,data_modifica,utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'PRINCIPALE','CORSO INGHILTERRA','7','TORINO','TO','10138',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',true 
from cpass_t_settore settore
where 
ente_id = (select ente_id from cpass_t_ente where ente_codice = 'CMTO')
AND NOT EXISTS (
  SELECT 1
  FROM CPASS_T_SETTORE_INDIRIZZO 
  WHERE 
         settore.settore_id = CPASS_T_SETTORE_INDIRIZZO.settore_id
     and cpass_t_settore_indirizzo.principale = true
);

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'ABBAZIA DELLA NOVALESA','FRAZIONE SAN PIETRO','SNC','NOVALESA','TO','10050',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',true 
from cpass_t_settore where settore_codice = 'QA3';

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'MAGAZZINO DI STRAMBINO','VIA KENNEDY','14','STRAMBINO','TO','10019',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',true 
from cpass_t_settore where settore_codice = 'UA3';

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'MAGAZZINO STRADALE DI OULX','VIA ORTIGARA','27/B','OULX','TO','10056',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',true 
from cpass_t_settore where settore_codice = 'UA4';

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'MAGAZZINO STRADALE DI CERESOLE','LOCALITA'' PIAN DELLA BALMA','SNC','CERESOLE','TO','10080',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',true 
from cpass_t_settore where settore_codice = 'UA4';

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'MAGAZZINO STRADALE DI CARIGNANO','VIA SALUZZO','20 INT. F','CARIGNANO','TO','10041',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',true 
from cpass_t_settore where settore_codice = 'UA4';

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'MAGAZZINO STRADALE DI VENAUS','FRAZIONE CORNALE','1','VENAUS','TO','10050',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',true 
from cpass_t_settore where settore_codice = 'UA4';

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'MAGAZZINO STRADALE DI CARMAGNOLA','VIA OMMARIVA','51','CARMAGNOLA','TO','10022',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',true 
from cpass_t_settore where settore_codice = 'UA4';
---------------------------------

INSERT INTO cpass.cpass_d_oggetti_spesa (oggetti_spesa_codice, oggetti_spesa_descrizione, inventariabile, 
prezzo_unitario, unita_misura_id, cpv_id, aliquote_iva_id, data_validita_inizio, data_creazione, utente_creazione, data_modifica, utente_modifica, 
ente_id, quantita_max_richiedibile, generico)
SELECT tmp.oggetti_spesa_codice, tmp.oggetti_spesa_descrizione, tmp.inventariabile, 
		tmp.prezzo_unitario, dum.unita_misura_id, 
		dc.cpv_id, dai.aliquote_iva_id, now(), now(), 'SYSTEM', now(), 'SYSTEM', '0ced449c-a147-5419-802f-01acfab32807',tmp.quantita_max_richiedibile, tmp.generico
FROM (VALUES
('10101','ARMADI E CASSETTE DI SICUREZZA',true,0.00,'C62','39122000-3','22',0,false),
('10201','SCAFFALI-SCAFFALATURE',true,0.00,'C62','39120000-9','22',0,false),
('10301','CASSETTIERE',true,0.00,'C62','39143122-7','22',0,false),
('10401','TAVOLI',true,0.00,'C62','39121200-8','22',0,false),
('10501','SCRIVANIE',true,0.00,'C62','39121100-7','22',0,false),
('10601','CATTEDRE',true,0.00,'C62','39160000-1','22',0,false),
('10701','BANCHI SCOLASTICI',true,0.00,'C62','39160000-1','22',0,false),
('10801','PEDANE-RIALZI',true,0.00,'C62','39160000-1','22',0,false),
('10901','LAVAGNE',true,0.00,'C62','39292100-6','22',0,false),
('11001','BACHECHE-TABELLONI',true,0.00,'C62','30192170-3','22',0,false),
('11101','SEDIE-POLTRONE-SGABELLI',true,0.00,'C62','39110000-6','22',0,false),
('11102','SCALA 3 SCALINI IN ALLUMINIO',false,0.00,'C62','44233000-2','22',0,false),
('11201','ARREDI PER LABORATORI SCIENTIFICI',true,0.00,'C62','39180000-7','22',0,false),
('11301','ARREDI PER IMPIANTI SPORTIVI',true,0.00,'C62','39150000-8','22',0,false),
('20101','ATTREZZI E GIOCHI PER PALESTRE',false,0.00,'C62','37420000-8','22',0,false),
('30101','MACCHINE FOTOGRAFICHE',false,0.00,'C62','38651000-3','22',0,false),
('30201','OBIETTIVI',false,0.00,'C62','38651000-3','22',0,false),
('30301','FILTRI',false,0.00,'C62','38651000-3','22',0,false),
('30302','CINEROID L - CLAMP',false,0.00,'C62','38623000-8','22',0,false),
('30303','CINEROID SOFT EYE CUP ',false,0.00,'C62','38623000-8','22',0,false),
('30501','BORSE-CUSTODIE',false,0.00,'C62','18930000-7','22',0,false),
('30601','SCHEDE 32GB PROFESSIONAL 1000X SDHC',false,0.00,'C62','30233000-1','22',0,false),
('30602','SCHEDE 16 GB PROFESSIONAL 1000X SDHC',false,0.00,'C62','30233000-1','22',0,false),
('30603','SCHEDE SDHC 32 GB ',false,0.00,'C62','30233000-1','22',0,false),
('30604','SCHEDA SANDIK DA 3 GB',false,0.00,'C62','30233000-1','22',0,false),
('30605','SCHEDA SANDISK DA 64 GB',false,0.00,'C62','30233000-1','22',0,false),
('30701','CAVI CORTI HDMI',false,0.00,'C62','32351000-8','22',0,false),
('30901','VIDEOCAMERA PER AUTO',true,0.00,'C62','38651000-3','22',0,false),
('40101','ACCESSORI PER AUDIOVISIVI',false,0.00,'C62','32321300-2','22',0,false),
('50101','PILE ALCALINE STILO AA 1,5V',false,0.00,'C62','31411000-0','22',0,false),
('50102','PILE MINISTILO ALCALINE AAA 1,5V',false,0.00,'C62','31411000-0','22',0,false),
('50103','PILA TRANSISTOR 9 VOLT',false,0.00,'C62','31411000-0','22',0,false),
('50104','PILE MEZZA TORCIA DA 1,5V',false,0.00,'XPK','31411000-0','22',0,false),
('50105','CARICABATTERIE PER PILE STILO E MINISTILO',false,0.00,'C62','31681500-8','22',0,false),
('50106','BATTERIE PANASONIC DMW - BLC12E',false,0.00,'C62','31411000-0','22',0,false),
('50107','PILE 1LS14500 - JST SAFT 3,6 V ',false,0.00,'C62','31411000-0','22',0,false),
('50201','FARO RICARICABILE A LED',false,0.00,'C62','31521330-6','22',0,false),
('50202','TORCIA RICARICABILE A LED',false,0.00,'C62','31521320-3','22',0,false),
('50203','LAMPADA DA TAVOLO ',false,0.00,'C62','31521100-5','22',0,false),
('60101','RILEVAMENTI TOPOGRAFICI',false,0.00,'C62','38295000-9','22',0,false),
('60102','CAVALLETTO DENDROMETRICO',false,0.00,'C62','38340000-0','22',0,false),
('60103','ROTELLA MAETRICA',false,0.00,'C62','38330000-7','22',0,false),
('60104','IPSOMETRO',false,0.00,'C62','38340000-0','22',0,false),
('60201','DEFIBRILLATORI',true,0.00,'C62','33182100-0','22',0,false),
('60301','BINOCOLO',true,0.00,'C62','38631000-7','22',0,false),
('70101','PERSONAL COMPUTER',false,0.00,'C62','30213000-5','22',0,false),
('70201','COMPUTER PORTATILE',false,0.00,'C62','30213100-6','22',0,false),
('70301','MACCHINE FOTOGRAFICHE DIGITALI/WEBCAM',false,0.00,'C62','38651600-9','22',0,false),
('70302','FOTOTRAPPOLA',false,0.00,'C62','38651000-3','22',0,false),
('70401','BADGES MAGNETICI',false,0.00,'C62','35123400-6','22',0,false),
('70501','PEN DRIVE USB ',false,0.00,'C62','30234500-3','22',0,false),
('70601','LETTORE MICROCHIP CON BLUETOOTH',false,0.00,'C62','30216000-6','22',0,false),
('80101','BROTHER TONER PER FAX 8070 P / MCF 9030 COD. TN8000',false,0.00,'C62','30125110-5','22',0,false),
('80102','BROTHER TONER PER FAX HL 1250 / MCF 9660 COD. TN6600',false,0.00,'C62','30125110-5','22',0,false),
('80103','BROTHER TONER PER FAX HL 2030/2820 COD. TN2000',false,0.00,'C62','30125110-5','22',0,false),
('80104','BROTHER TONER PER STAMPANTE HL 5240 COD. TN3170',false,0.00,'C62','30125110-5','22',0,false),
('80105','CANON TONER PER FAX  L200',false,0.00,'C62','30125110-5','22',0,false),
('80106','DELL TONER PER STAMPANTE TM 1700 / 1700 N',false,0.00,'C62','30125110-5','22',0,false),
('80107','EPSON TONER PER STAMPANTE EPL 6200 COD. S050166',false,0.00,'C62','30125110-5','22',0,false),
('80108','HP CARTUCCIA PER STAMPANTE LASERJET 1200 COD. C7115X',false,0.00,'C62','30125100-2','22',0,false),
('80109','HP TONER PER STAMPANTE LASERJET 6 MP COD. C3903A',false,0.00,'C62','30125110-5','22',0,false),
('80110','LEXMARK CARTUCCIA PER STAMPANTE INKJET OPTRA Z 45 / Z 53 NERO COD. 15M0100 CONF DA 3',false,0.00,'C62','30125100-2','22',0,false),
('80111','LEXMARK CARTUCCIA PER STAMPANTE INKJET OPTRA Z 45 COLOR  COD. 15M0125',false,0.00,'C62','30125100-2','22',0,false),
('80112','LEXMARK CARTUCCIA PER STAMPANTE INKJET OPTRA Z 53 COD. 15M0375E CONF. TRIPLA',false,0.00,'C62','30125100-2','22',0,false),
('80113','LEXMARK TONER PER STAMPANTE  C 524 MAGENTA COD. 00C5240MH',false,0.00,'C62','30125110-5','22',0,false),
('80114','LEXMARK TONER PER STAMPANTE C 524 CIANO COD. 00C5240CH',false,0.00,'C62','30125110-5','22',0,false),
('80115','LEXMARK TONER PER STAMPANTE C 524 GIALLO COD. 00C5240YH',false,0.00,'C62','30125110-5','22',0,false),
('80116','LEXMARK TONER PER STAMPANTE C 524 NERO COD. 00C5240KH',false,0.00,'C62','30125110-5','22',0,false),
('80117','LEXMARK TONER PER STAMPANTE C 710 GIALLO 10E0042',false,0.00,'C62','30125110-5','22',0,false),
('80118','LEXMARK TONER PER STAMPANTE C 910 / 912 CIANO COD. 12N0768',false,0.00,'C62','30125110-5','22',0,false),
('80119','LEXMARK TONER PER STAMPANTE C 910 / 912 GIALLO COD. 12N0770',false,0.00,'C62','30125110-5','22',0,false),
('80120','LEXMARK TONER PER STAMPANTE C 910 / 912 MAGENTA COD. 12N0769',false,0.00,'C62','30125110-5','22',0,false),
('80121','LEXMARK TONER PER STAMPANTE C 910 / 912 NERO COD. 12N0771',false,0.00,'C62','30125110-5','22',0,false),
('80122','LEXMARK TONER PER STAMPANTE E 232 / E 330/ E 332/ E 240/ E 340/ E 342 COD. 34016HE',false,0.00,'C62','30125110-5','22',0,false),
('80123','LEXMARK TONER PER STAMPANTE E 320 / E 322 COD. 08A0478',false,0.00,'C62','30125110-5','22',0,false),
('80124','LEXMARK TONER PER STAMPANTE E 350 / 352 COD. 0E352H11E',false,0.00,'C62','30125110-5','22',0,false),
('80125','LEXMARK TONER PER STAMPANTE E 450 COD. 0E450H11E',false,0.00,'C62','30125110-5','22',0,false),
('80126','LEXMARK TONER PER STAMPANTE OPTRA C 510 CIANO COD. 20K1400',false,0.00,'C62','30125110-5','22',0,false),
('80127','LEXMARK TONER PER STAMPANTE OPTRA C 510 GIALLO COD. 20K1402',false,0.00,'C62','30125110-5','22',0,false),
('80128','LEXMARK TONER PER STAMPANTE OPTRA C 510 MAGENTA COD. 20K1401',false,0.00,'C62','30125110-5','22',0,false),
('80129','LEXMARK TONER PER STAMPANTE OPTRA C 510 NERO COD. 20K1403',false,0.00,'C62','30125110-5','22',0,false),
('80130','LEXMARK TONER PER STAMPANTE OPTRA C 710 CIANO COD. 10E0040',false,0.00,'C62','30125110-5','22',0,false),
('80131','LEXMARK TONER PER STAMPANTE OPTRA C 710 MAGENTA COD. 10E0041',false,0.00,'C62','30125110-5','22',0,false),
('80132','LEXMARK TONER PER STAMPANTE OPTRA C 710 NERO COD. 10E0043',false,0.00,'C62','30125110-5','22',0,false),
('80133','LEXMARK TONER PER STAMPANTE OPTRA C 720 CIANO COD. 15W0900',false,0.00,'C62','30125110-5','22',0,false),
('80134','LEXMARK TONER PER STAMPANTE OPTRA C 720 GIALLO COD. 15W0902',false,0.00,'C62','30125110-5','22',0,false),
('80135','LEXMARK TONER PER STAMPANTE OPTRA C 720 MAGENTA COD. 15W0901',false,0.00,'C62','30125110-5','22',0,false),
('80136','LEXMARK TONER PER STAMPANTE OPTRA C 720 NERO COD. 15W0903',false,0.00,'C62','30125110-5','22',0,false),
('80137','LEXMARK TONER PER STAMPANTE OPTRA E 310 / E 312 / E 312 L COD. 13T0101',false,0.00,'C62','30125110-5','22',0,false),
('80138','LEXMARK TONER PER STAMPANTE OPTRA M 410 / M 412  COD. 17G0154',false,0.00,'C62','30125110-5','22',0,false),
('80139','LEXMARK TONER PER STAMPANTE OPTRA N COD. 140109A',false,0.00,'C62','30125110-5','22',0,false),
('80140','LEXMARK TONER PER STAMPANTE OPTRA S  COD. 1382925',false,0.00,'C62','30125110-5','22',0,false),
('80141','LEXMARK TONER PER STAMPANTE OPTRA T 610 / 612 / 614 / 616 COD. 12A5845',false,0.00,'C62','30125110-5','22',0,false),
('80142','LEXMARK TONER PER STAMPANTE OPTRA W 810 COD. 12L0250',false,0.00,'C62','30125110-5','22',0,false),
('80143','LEXMARK TONER PER STAMPANTE T 630 / 632 / 634 COD. 12A7465',false,0.00,'C62','30125110-5','22',0,false),
('80144','LEXMARK TONER PER STAMPANTE T 644 COD. 0064416XE',false,0.00,'C62','30125110-5','22',0,false),
('80145','LEXMARK TONER PER STAMPANTE W 820 COD. 12B0090',false,0.00,'C62','30125110-5','22',0,false),
('80146','OKI TONER PER FAX 4500 / 4580 COD. 79801    22',false,0.00,'C62','30125110-5','22',0,false),
('80147','OKI TONER PER FAX 5200 / 5400 / 5650  COD. 09002395',false,0.00,'C62','30125110-5','22',0,false),
('80148','OLIVETTI CARTUCCIA PER FAX OFX 1900 / 3200 COD. 84431W',false,0.00,'C62','30125100-2','22',0,false),
('80149','OLIVETTI CARTUCCIA PER FAX OFX 800 COD. B0288Q',false,0.00,'C62','30125100-2','22',0,false),
('80150','OLIVETTI TONER PER FAX OFX 4000 / 4200 COD. B0038',false,0.00,'C62','30125110-5','22',0,false),
('80151','RICOH TONER FAX 1120L COD.FX1120',false,0.00,'C62','30125110-5','22',0,false),
('80152','RICOH TONER PER FAX 1190L COD. 1190K',false,0.00,'C62','30125110-5','22',0,false),
('80153','RICOH TONER PER FAX 1400 L COD. FK1400L',false,0.00,'C62','30125110-5','22',0,false),
('80154','RICOH TONER PER FAX 1800 L COD. FK2001L',false,0.00,'C62','30125110-5','22',0,false),
('80155','RICOH TONER PER STAMPANTE AFICIO AP 610 N  COD. K50',false,0.00,'C62','30125110-5','22',0,false),
('80156','RICOH TONER PER STAMPANTE SPC 410 DN /420/ CL 4000 DN CIANO COD. K174LD/C',false,0.00,'C62','30125110-5','22',0,false),
('80157','RICOH TONER PER STAMPANTE SPC 410 DN /420/ CL 4000 DN GIALLO COD. K174LD/G',false,0.00,'C62','30125110-5','22',0,false),
('80158','RICOH TONER PER STAMPANTE SPC 410 DN /420/ CL 4000 DN MAGENTA COD. K174LD/M',false,0.00,'C62','30125110-5','22',0,false),
('80159','RICOH TONER PER STAMPANTE SPC 410 DN /420/ CL 4000 DN NERO COD. K174LD',false,0.00,'C62','30125110-5','22',0,false),
('80160','RICOH UNITA'' DI SVILUPPO E TONER PER FAX AFICIO FX 200L  COD.K191',false,0.00,'C62','30125110-5','22',0,false),
('80161','SAMSUNG TONER PER FAX SF 560 COD. SCX4216D3',false,0.00,'C62','30125110-5','22',0,false),
('80162','SAMSUNG TONER PER FAX SF 560 RA COD. SFD560RA',false,0.00,'C62','30125110-5','22',0,false),
('80163','SAMSUNG TONER PER FAX SF 650 COD. MLT-D1052L',false,0.00,'C62','30125110-5','22',0,false),
('80164','SAMSUNG TONER PER STAMPANTE ML3471ND COD.ML-D3470B',false,0.00,'C62','30125110-5','22',0,false),
('80165','BROTHER TONER PER STAMPANTE MCF-L6800DW COD. TN-3512',false,0.00,'C62','30125110-5','22',0,false),
('80166','EPSON ACULASER C3800 NERO COD. C13S051127',false,0.00,'C62','30125110-5','22',0,false),
('80167','LEXMARK CL 7200 COLORE GIALLO COD. K185-3888447',false,0.00,'C62','30125110-5','22',0,false),
('80168','OKI C8600 COD. 44992401',false,0.00,'C62','30125100-2','22',0,false),
('80169','EPSON WF-8090DTW/E LP00599 NERO COD.  C13T754140',false,0.00,'C62','30125110-5','22',0,false),
('80170','EPSON WF-8090DTW/E LP00599 CIANO COD. C13T754240',false,0.00,'C62','30125110-5','22',0,false),
('80171','EPSON WF-8090DTW/E LP00599 MAGENTA COD. C13T754340',false,0.00,'C62','30125110-5','22',0,false),
('80172','EPSON WF-8090DTW/E LP00599 GIALLO COD. C13T754440',false,0.00,'C62','30125110-5','22',0,false),
('80201','BROTHER TAMBURO PER STAMPANTE HL 5240 COD. DR 3100',false,0.00,'C62','30124300-7','22',0,false),
('80202','DELL TAMBURO PER STAMPANTE TM 1700 / 1700 N',false,0.00,'C62','30124300-7','22',0,false),
('80203','EPSON FOTOCONDUTTORE PER STAMPANTE EPL 6200 COD. S051099',false,0.00,'C62','30124300-7','22',0,false),
('80204','LEXMARK BOTTIGLIA OLIO PER STAMPANTE C 720 COD. 15W0906',false,0.00,'C62','30125000-1','22',0,false),
('80205','LEXMARK BOTTIGLIA TONER DI SCARTO PER STAMPANTE C 510 COD. 20K0505',false,0.00,'C62','30125000-1','22',0,false),
('80206','LEXMARK CONTENITORE TONER DI SCARTO PER STAMPANTE C 720 COD. 15W0907',false,0.00,'C62','30125000-1','22',0,false),
('80207','LEXMARK CORONA DI CARICA PER STAMPANTE OPTRA C 720 COD. 15W0918',false,0.00,'C62','30125000-1','22',0,false),
('80208','LEXMARK FOTOCONDUTTORE PER STAMPANTE E 232 / E 330 / E 332 / E 240/ E 340/ E 342 COD. 12A8302',false,0.00,'C62','30124300-7','22',0,false),
('80209','LEXMARK FOTOCONDUTTORE PER STAMPANTE OPTRA W 810 COD. 12L0251',false,0.00,'C62','30124300-7','22',0,false),
('80210','LEXMARK FOTOSVILUPPATORE PER STAMPANTE C 510 COD. 20K0504',false,0.00,'C62','30124300-7','22',0,false),
('80211','LEXMARK FOTOSVILUPPATORE PER STAMPANTE C 720 COD. 15W0904',false,0.00,'C62','30124300-7','22',0,false),
('80212','LEXMARK FOTOSVILUPPATORE PER STAMPANTE C 910 / 912 (CIANO,MAGENTA,GIALLO) COD. 12N0772',false,0.00,'C62','30124300-7','22',0,false),
('80213','LEXMARK FOTOSVILUPPATORE PER STAMPANTE C 910 / 912 NERO COD. 12N0773',false,0.00,'C62','30124300-7','22',0,false),
('80214','LEXMARK KIT FOTOCONDUTTORE PER STAMPANTE E 450/350/352 COD. 0E250X22G',false,0.00,'C62','30124300-7','22',0,false),
('80215','LEXMARK RULLO OLIO COPRENTE PER STAMPANTE C 910 / 912 COD. C92035X',false,0.00,'C62','30125000-1','22',0,false),
('80216','RICOH CINGHIA DI TRASFERIMENTO PER STAMPANTE SCP 410 DN /420/ CL 4000 DN COD. RK 176',false,0.00,'C62','30125000-1','22',0,false),
('80217','RICOH KIT DI MANUTENZIONE PER STAMPANTE SPC 410 DN / CL 4000 DN COD. K 175',false,0.00,'C62','30125000-1','22',0,false),
('80218','RICOH KIT MANUTENZIONE PER STAMPANTE AFICIO AP 610 N COD. 181',false,0.00,'C62','30125000-1','22',0,false),
('80219','RICOH KIT MANUTENZIONE STAMPANTE AFICIO 420DN  COD.K197',false,0.00,'C62','30125000-1','22',0,false),
('80220','RICOH PCU PER STAMPANTE AFICIO SP C 410 DN /420/ CL 4000 DN COLORI COD. D55',false,0.00,'C62','30124300-7','22',0,false),
('80221','RICOH PCU PER STAMPANTE AFICIO SP C 410 DN /420/ CL 4000 DN NERO COD. D54',false,0.00,'C62','30124300-7','22',0,false),
('80222','RICOH VASCHETTA RECUPERO TONER DI SCARTO PER STAMPANTE SCP 410 DN /420/ CL 4000 DN COD. K177',false,0.00,'C62','30125000-1','22',0,false),
('80223','OKI C8600 TAMBURO COD. 43381724',false,0.00,'C62','30124300-7','22',0,false),
('80224','BROTHER TAMBURO/DRUM MFC L6800 DW COD. DR3400',false,0.00,'C62','30124300-7','22',0,false),
('80225','CARTUCCIA NASTRO COLORE YMCKO DA 100 STAMPE PER STAMPANTE A SUBLIMAZIONE ZEBRA COD. 800011-140',false,0.00,'C62','30125110-5','22',0,false),
('80226','KIT DI PULIZIA PER STAMPANTE A SUBLIMAZIONE ZEBRA  COD. 105999-302',false,0.00,'C62','30237251-3','22',0,false),
('80227','OKI C8600 TAMBURO PER STAMPANTE COD. 43449016',false,0.00,'C62','30124300-7','22',0,false),
('80228','EPSON WF-8090DTW/E LP00599 VASCHETTA DI RECUPERO',false,0.00,'C62','30125000-1','22',0,false),
('80301','BROTHER TAMBURO PER FAX 8070 P / MCF 9030 COD. DR8000',false,0.00,'C62','30124300-7','22',0,false),
('80302','BROTHER TAMBURO PER FAX HL 1250 / MCF 9660 COD. DR6000',false,0.00,'C62','30124300-7','22',0,false),
('80303','BROTHER TAMBURO PER FAX HL 2030/2820 COD. DR2000',false,0.00,'C62','30124300-7','22',0,false),
('80304','OKI TAMBURO PER FAX 4500 / 4580 COD. 40709902',false,0.00,'C62','30124300-7','22',0,false),
('80305','OKI TAMBURO PER FAX 5200 / 5400 / 5650 COD. 9001042',false,0.00,'C62','30124300-7','22',0,false),
('80306','OLIVETTI TAMBURO PER FAX OFX 4000 / 4200 COD. B0037',false,0.00,'C62','30124300-7','22',0,false),
('80307','RICOH TAMBURO PER FAX 1190K',false,0.00,'C62','30124300-7','22',0,false),
('80401','CD-R  COMPACT DISK',false,0.00,'C62','30234300-1','22',0,false),
('80402','CD-RW COMPACT DISK RISCRIVIBILE',false,0.00,'C62','30234300-1','22',0,false),
('80403','DVD-R',false,0.00,'C62','30234400-2','22',0,false),
('80404','DVD-RW RISCRIVIBILE',false,0.00,'C62','30234400-2','22',0,false),
('80501','HP DESIGNJET T930 MAGENTA COD. F9J77A',false,0.00,'C62','30125100-2','22',0,false),
('80502','HP DESIGNJET T930 CIANO COD. F9J76A',false,0.00,'C62','30125100-2','22',0,false),
('80503','HP DESIGNJET T930 GIALLO COD. F9J78A',false,0.00,'C62','30125100-2','22',0,false),
('80504','HP DESIGNJET T930 NERO OPACO COD. C1Q12A',false,0.00,'C62','30125100-2','22',0,false),
('80505','HP DESIGNJET T930 NERO FOTOGRAFICO COD. F9J79A',false,0.00,'C62','30125100-2','22',0,false),
('80506','HP DESIGNJET T930 GRIGIO COD. F9J80A',false,0.00,'C62','30125100-2','22',0,false),
('80507','HP DESIGNJET T930 TESTINA DI STAMPA COD. B3P06A',false,0.00,'C62','30125100-2','22',0,false),
('80508','CANON TESTINA PER PLOTTER IP 810 COD. 2251B001',false,0.00,'C62','30125100-2','22',0,false),
('80509','CANON SERBATOIO PER PLOTTER IPF 820 COD. 1320B012AA',false,0.00,'C62','30125100-2','22',0,false),
('80510','HP DESIGNJET T830 CARTUCCE PER PLOTTER NERO OPACO COD. F9J68A',false,0.00,'C62','30125100-2','22',0,false),
('80511','HP DESIGNJET T830 CARTUCCE PER PLOTTER CIANO COD. F9K17A',false,0.00,'C62','30125100-2','22',0,false),
('80512','HP DESIGNJET T830 CARTUCCE PER PLOTTER MAGENTA F9K16A',false,0.00,'C62','30125100-2','22',0,false),
('80513','HP DESIGNJET T830 CARTUCCE PER PLOTTER GIALLO F9K15A',false,0.00,'C62','30125100-2','22',0,false),
('80514','HP DESIGNJET T830 KIT SOSTITUZIONE TESTINA DI STAMPA PER PLOTTER COD. F9J81A',false,0.00,'C62','30125100-2','22',0,false),
('80515','XEROX PHASER 5550 DRUM COD. ITA113R00670',false,0.00,'C62','30124300-7','22',0,false),
('80516','RICOH TONER PER STAMPANTE AFICIO CL7200 CIANO COD. K185-1',false,0.00,'C62','30125110-5','22',0,false),
('80517','HP DESIGNJET 4000PS TESTINA DI STAMPA COLORE NERO COD. C5054A ',false,0.00,'C62','30125100-2','22',0,false),
('80518','HP DESIGNJET 4000PS TESTINA DI STAMPA COLORE CIANO COD. C5055A',false,0.00,'C62','30125100-2','22',0,false),
('80519','HP DESIGNJET 4000PS TESTINA DI STAMPA COLORE MAGENTA COD. C5056A',false,0.00,'C62','30125100-2','22',0,false),
('80520','HP DESIGNJET 4000PS TESTINA DI STAMPA COLORE GIALLO COD. C5057A',false,0.00,'C62','30125100-2','22',0,false),
('80521','CANON SERBATOIO PER PLOTTER IPF 820 NERO OPACO COD. 2962B001',false,0.00,'C62','30125100-2','22',0,false),
('80522','CANON SERBATOIO PER PLOTTER IPF 820 NERO COD. 2963B001',false,0.00,'C62','30125100-2','22',0,false),
('80523','CANON SERBATOIO PER PLOTTER IPF 820 CIANO COD. 2964B001',false,0.00,'C62','30125100-2','22',0,false),
('80524','CANON SERBATOIO PER PLOTTER IPF 820 MAGENTA COD. 2965B001',false,0.00,'C62','30125100-2','22',0,false),
('80525','CANON SERBATOIO PER PLOTTER IPF 820 GIALLO COD. 2966B001',false,0.00,'C62','30125100-2','22',0,false),
('90101','ATTREZZATURE PER SALDATURA',false,0.00,'C62','42652000-1','22',0,false),
('90301','BIDONE ASPIRATUTTO',false,0.00,'C62','39713430-6','22',0,false),
('90401','AVVIATORE ELETTRICO',true,0.00,'C62','42652000-1','22',0,false),
('90501','COLTELLO MULTIUSO',false,0.00,'C62','44512000-2','22',0,false),
('90502','COLTELLO TAGLIACAVI',false,0.00,'C62','44512000-2','22',0,false),
('90503','FALCETTO',false,0.00,'C62','44511000-5','22',0,false),
('90504','MARTELLO',false,0.00,'C62','44512300-5','22',0,false),
('90505','TENAGLIA',false,0.00,'C62','44512200-4','22',0,false),
('90506','FILO DI FERRO ZINCATO IN MATASSE',false,0.00,'C62','44333000-3','22',0,false),
('90507','TRAPANO AVVITATORE',true,0.00,'C62','42652000-1','22',0,false),
('90508','DECESPUGLIATORE',true,0.00,'C62','16160000-4','22',0,false),
('100101','ESTINTORI',false,0.00,'C62','35111300-8','22',0,false),
('100201','PROTEZIONE CAPO (ELMETTI)',false,0.00,'C62','18444200-5','22',0,false),
('100202','CASCHI DA BOSCAIOLO ',false,0.00,'C62','18444110-7','22',0,false),
('100301','PROTEZIONE VIE RESPIRATORIE (MASCHERE)',false,0.00,'C62','18143000-3','22',0,false),
('100401','PROTEZIONE UDITO (AURICOLARI CUFFIE)',false,0.00,'C62','18143000-3','22',0,false),
('100501','OCCHIALI',false,0.00,'C62','33734000-4','22',0,false),
('100502','OCCHIALI DI PROTEZIONE',false,0.00,'C62','33735100-2','22',0,false),
('100601','CALZE',false,0.00,'C62','18315000-0','22',0,false),
('100701','SCARPE',false,0.00,'C62','18813300-4','22',0,false),
('100702','SCARPONCINI RAMPONABILI',false,0.00,'C62','18823000-4','22',0,false),
('100703','SCARPONCINI TREKKING',false,0.00,'C62','18823000-4','22',0,false),
('100704','SCARPONCINI INVERNALI ANTINFORTUNISTICI',false,0.00,'C62','18831000-3','22',0,false),
('100705','SCARPONCINI ANTINFORTUNISTICI ESTIVI ALLA CAVIGLIA',false,0.00,'C62','18831000-3','22',0,false),
('100706','SCARPONCINI ANTINFORTUNISTICI ESTIVI BASSI',false,0.00,'C62','18831000-3','22',0,false),
('100801','STIVALI',false,0.00,'C62','18815000-5','22',0,false),
('100802','STIVALI IN GOMMA',false,0.00,'C62','18812200-6','22',0,false),
('100803','STIVALI TUTTACOSCIA',false,0.00,'C62','18812200-6','22',0,false),
('100804','STIVALI A PANTALONE',false,0.00,'C62','18812200-6','22',0,false),
('100901','GUANTI',false,0.00,'C62','18424000-7','22',0,false),
('100902','GUANTI IN LATTICE',false,0.00,'XPK','18424300-0','22',0,false),
('100903','GUANTI IN PELLE FIORE',false,0.00,'C62','18424000-7','22',0,false),
('100904','GUANTI IN NEOPRENE',false,0.00,'C62','18424300-0','22',0,false),
('101001','VISIERE-SCHERMI PROTETTIVI',false,0.00,'C62','18142000-6','22',0,false),
('101101','CINTURE ED IMBRAGATURE DI SICUREZZA',false,0.00,'C62','18143000-3','22',0,false),
('101201','INDUMENTI PROTETTIVI',false,0.00,'C62','35113400-3','22',0,false),
('101202','GIACCA TECNICA IN GORE-TEX',false,0.00,'C62','18213000-5','22',0,false),
('101203','PANTALONE TECNICO PROTEZIONE FREDDO',false,0.00,'C62','18234000-8','22',0,false),
('101204','PILE ',false,0.00,'C62','18235000-5','22',0,false),
('101401','ARMADI DI SICUREZZA',false,0.00,'C62','44421600-3','22',0,false),
('101502','PANTALONE INVERNALE ALTA VISIBILITA''',false,0.00,'C62','18234000-8','22',0,false),
('101503','POLO MANICA LUNGA ALTA VISIBILITA''',false,0.00,'C62','18235000-5','22',0,false),
('101504','PILE ALTA VISIBILITA''',false,0.00,'C62','18235000-5','22',0,false),
('101601','GHETTE ANTITAGLIO',false,0.00,'C62','35113400-3','22',0,false),
('110101','VITI',false,0.00,'C62','44531000-1','22',0,false),
('120101','FORBICE',false,0.00,'C62','39241200-5','22',0,false),
('120102','PERFORATORE',false,0.00,'C62','30123000-7','22',0,false),
('120103','PORTA MATITE A BICCHIERE',false,0.00,'C62','30192134-9','22',0,false),
('120105','TAGLIACARTE IN METALLO',false,0.00,'C62','30197310-2','22',0,false),
('120106','TEMPERAMATITE A DUE FORI',false,0.00,'C62','30192133-2','22',0,false),
('120109','PLASTIFICATRICE',false,0.00,'C62','30123000-7','22',0,false),
('120201','RIGHELLO IN MATERIALE PLASTICO (CM. 30)',false,0.00,'C62','30192126-0','22',0,false),
('120301','FERMAGLI ANTIRUGGINE N. 3 (SCATOLA DA 100)',false,0.00,'C62','30197110-0','22',0,false),
('120302','FERMAGLI ANTIRUGGINE N. 6 (SCATOLA DA 100)',false,0.00,'C62','30197110-0','22',0,false),
('120303','MOLLA FERMACARTE',false,0.00,'XPK','30197220-4','22',0,false),
('120404','FETTUCCIA IN METRI LINEARI',false,0.00,'MTR','39561120-9','22',0,false),
('120405','SPAGO IN GOMITOLI DIAMETRO PICCOLO',false,0.00,'C62','39541140-9','22',0,false),
('120501','CUCITRICE MEDIA',false,0.00,'C62','30197320-5','22',0,false),
('120502','CUCITRICE PER ALTI SPESSORI',false,0.00,'C62','30197320-5','22',0,false),
('120503','CUCITRICE PICCOLA',false,0.00,'C62','30197320-5','22',0,false),
('120504','LEVAPUNTI',false,0.00,'C62','30197321-2','22',0,false),
('120601','PUNTI PER PINZATRICE ALTI SPESSORI (SCATOLE DA 2000)',false,0.00,'C62','30124400-8','22',0,false),
('120602','PUNTI PER PINZATRICE MEDIA (SCATOLE DA 1000)',false,0.00,'C62','30124400-8','22',0,false),
('120603','PUNTI PER PINZATRICE PICCOLA (SCATOLE DA 1000)',false,0.00,'C62','30124400-8','22',0,false),
('120701','TIMBRO DATARIO',false,0.00,'C62','30192150-7','22',0,false),
('120702','TIMBRO IN GOMMA POLINOMI (RACCOMANDATA - STAMPE - URGENTE ECC.)',false,0.00,'C62','30192153-8','22',0,false),
('120703','TIMBRO PROTOCOLLO',false,0.00,'C62','30192153-8','22',0,false),
('120704','TIMBRO AUTOINCHIOSTRANTE',false,0.00,'C62','30192153-8','22',0,false),
('120705','TIMBRO TONDO',false,0.00,'C62','30192153-8','22',0,false),
('120706','TIMBRO LINEARE',false,0.00,'C62','30192153-8','22',0,false),
('120707','PORTA TIMBRI IN METALLO A 12 POSTI',false,0.00,'C62','30192155-2','22',0,false),
('120708','PORTA TIMBRI IN METALLO A 6 POSTI    22',false,0.00,'C62','30192155-2','22',0,false),
('120709','FELTRO PREINCHIOSTRATO PER TIMBRI AUTOINCHIOSTRANTI',false,0.00,'C62','30192154-5','22',0,false),
('120801','CUSCINETTO PER TIMBRI (GRANDE) CM. 10 X 16',false,0.00,'C62','30192154-5','22',0,false),
('120802','CUSCINETTO PER TIMBRI (PICCOLO) CM.  8 X 12',false,0.00,'C62','30192154-5','22',0,false),
('120901','DORSINO A SPIRALE MM. 10',false,0.00,'C62','39264000-0','22',0,false),
('120902','DORSINO A SPIRALE MM. 14',false,0.00,'C62','39264000-0','22',0,false),
('120903','DORSINO A SPIRALE MM. 19',false,0.00,'C62','39264000-0','22',0,false),
('120904','DORSINO A SPIRALE MM. 25',false,0.00,'C62','39264000-0','22',0,false),
('120905','DORSINO A SPIRALE MM. 6',false,0.00,'C62','39264000-0','22',0,false),
('120906','DORSINO A SPIRALE MM. 8',false,0.00,'C62','39264000-0','22',0,false),
('120907','DORSINO MM. 11',false,0.00,'C62','39264000-0','22',0,false),
('120908','DORSINO MM. 15',false,0.00,'C62','39264000-0','22',0,false),
('120909','DORSINO MM. 3/4',false,0.00,'C62','39264000-0','22',0,false),
('120910','DORSINO MM. 6',false,0.00,'C62','39264000-0','22',0,false),
('121001','NASTRO IN CARTUCCIA DRY INKJET PER CALCOLATRICE LOGOS 262 PD COD.83550',false,0.00,'C62','30192300-4','22',0,false),
('121002','NASTRO IN CARTUCCIA EASYROL PURPLE PER CALCOLATRICE LOGOS 364 / 362 COD.80624B',false,0.00,'C62','30192300-4','22',0,false),
('121003','NASTRO IN CARTUCCIA PER CALCOLATRICE CANON INK RIBBON EP 102',false,0.00,'C62','30192300-4','22',0,false),
('121004','NASTRO IN CARTUCCIA PER CALCOLATRICE OLIVETTI 662',false,0.00,'C62','30192300-4','22',0,false),
('121101','NASTRO ADESIVO MM. 19 X  M. 33',false,0.00,'XPK','30194210-0','22',0,false),
('121102','NASTRO DYMO MM. 9',false,0.00,'C62','30192300-4','22',0,false),
('121103','NASTRO PER IMBALLO MM. 50 X M. 66',false,0.00,'C62','44424200-0','22',0,false),
('121104','NASTRO TELATO MM38 X M4',false,0.00,'C62','44424200-0','22',0,false),
('121105','NASTRO IN CARTA DYMO MM 12X4',false,0.00,'C62','30192300-4','22',0,false),
('121201','INCHIOSTRO PER CUSCINETTI',false,0.00,'C62','30192113-6','22',0,false),
('121202','RULLO INCHIOSTRATO PER CALCOLATRICE  IR40T',false,0.00,'C62','30125100-2','22',0,false),
('121301','CORRETTORE LIQUIDO',false,0.00,'C62','30192920-6','22',0,false),
('121302','CANCELLINO PER LAVAGNA',false,0.00,'C62','39292110-9','22',0,false),
('121401','GOMMA',false,0.00,'C62','30192100-2','22',0,false),
('121402','GOMMA ELICA MOBY DICK PER MATITA',false,0.00,'C62','30192100-2','22',0,false),
('121501','COLLA STICK MEDIA',false,0.00,'C62','24910000-6','22',0,false),
('121502','COLLA SPRAY',false,0.00,'C62','24910000-6','22',0,false),
('121601','ETICHETTE AUTOADESIVE  (MISURA 63,5X33,9 CONF. A FOGLI DA 24) (MISURA 105X74 CONF. A FOGLI DA 8) SPECIFICARE MISURA',false,0.00,'C62','30192800-9','22',0,false),
('121602','ETICHETTE PER STAMPANTE LASER MM.  37 X 70',false,0.00,'C62','30192800-9','22',0,false),
('121603','ETICHETTE PER STAMPANTE LASER MM. 210 X 297',false,0.00,'C62','30192800-9','22',0,false),
('121701','BIRO CON PUNTA MEDIA - BLU',false,0.00,'C62','30192121-5','22',0,false),
('121702','BIRO CON PUNTA MEDIA - NERA',false,0.00,'C62','30192121-5','22',0,false),
('121703','BIRO CON PUNTA MEDIA - ROSSA',false,0.00,'C62','30192121-5','22',0,false),
('121704','PENNARELLO EVIDENZIATORE',false,0.00,'C62','30192124-6','22',0,false),
('121705','PENNARELLO INDELEBILE PER CD',false,0.00,'C62','30192124-6','22',0,false),
('121706','PENNARELLO PER LAVAGNE CON PUNTA GROSSA',false,0.00,'C62','30192124-6','22',0,false),
('121707','PENNARELLO PUNTA GROSSA INDELEBILE',false,0.00,'C62','30192124-6','22',0,false),
('121708','PENNARELLO TIPO MICROLINER PUNTA FINE',false,0.00,'C62','30192124-6','22',0,false),
('121710','PENNARELLI PANTONE DOPPIA PUNTA',false,0.00,'XPK','30192124-6','22',0,false),
('121801','MATITA COLORATA (ROSSO - BLU)',false,0.00,'XPK','30192130-1','22',0,false),
('121802','MATITA N. 2 / HB',false,0.00,'XPK','30192130-1','22',0,false),
('121901','CLASSIFICATORE PROTOCOLLO DORSO CM. 5',false,0.00,'C62','30193700-5','22',0,false),
('121902','CLASSIFICATORE PROTOCOLLO DORSO CM. 8',false,0.00,'XPK','30193700-5','22',0,false),
('121903','FALDONE IN PRESPAN A TRE LEGACCI DORSO CM. 10',false,0.00,'C62','30193700-5','22',0,false),
('121904','FALDONE IN PRESPAN A TRE LEGACCI DORSO CM. 12',false,0.00,'C62','30193700-5','22',0,false),
('121905','FALDONE IN PRESPAN A TRE LEGACCI DORSO CM. 15',false,0.00,'XPK','30193700-5','22',0,false),
('121906','FALDONE IN PRESPAN A TRE LEGACCI DORSO CM. 8',false,0.00,'C62','30193700-5','22',0,false),
('121907','SCATOLA PORTA PROGETTI CON BOTTONE DORSO CM. 10',false,0.00,'C62','30193700-5','22',0,false),
('121908','SCATOLA PORTA PROGETTI CON BOTTONE DORSO CM. 12',false,0.00,'C62','30193700-5','22',0,false),
('121909','SCATOLA PORTA PROGETTI CON BOTTONE DORSO CM. 4',false,0.00,'C62','30193700-5','22',0,false),
('121910','SCATOLA PORTA PROGETTI CON BOTTONE DORSO CM. 8',false,0.00,'C62','30193700-5','22',0,false),
('121911','REGISTRATORE A LEVA CON CUSTODIA FORMATO PROTOCOLLO DORSO 8 COLORE BLU',false,0.00,'C62','30193700-5','22',0,false),
('121912','FALDONI IN CARTONE MM.2 A DUE LEGACCI RINFORZATI IN TELA DORSO CM. 10 DIM. 25X35 COLORE BEIGE',false,0.00,'C62','22852000-7','22',0,false),
('122001','CARTELLINA MANILLA A 3 ALETTE CM. 33 X 25',false,0.00,'XPK','22992000-0','22',0,false),
('122002','CARTELLINA MANILLA INTESTATA PROVINCIA DI TORINO (VERDE), CM. 35 X 25',false,0.00,'C62','22992000-0','22',0,false),
('122003','CARTELLINA MANILLA SEMPLICE CM. 35 X 26',false,0.00,'C62','22992000-0','22',0,false),
('122004','COPERTINA PER RILEGATURA COLORATA',false,0.00,'C62','22992000-0','22',0,false),
('122005','COPERTINA PER RILEGATURA TRASPARENTE',false,0.00,'C62','22852100-8','22',0,false),
('122006','PORTA CORRISPONDENZA CM. 37 X 26',false,0.00,'C62','30193200-0','22',0,false),
('122007','PORTA ETICHETTE ADESIVE TRASPARENTE MM. 32 X 124',false,0.00,'C62','30199230-1','22',0,false),
('122008','PORTA ETICHETTE ADESIVE TRASPARENTE MM. 65 X 140',false,0.00,'C62','30199230-1','22',0,false),
('122009','BUSTA TRASPARENTE CM. 22 X 30 CON FORATURA UNIVERSALE (QUANTITA'' IN: UNITA'')',false,0.00,'XPK','30199230-1','22',0,false),
('122010','"CARTELLINA IN PLASTICA TRASPARENTE CON APERTURA A ""L"" CM. 23,2 X 32,2 (QUANTITA'' IN: UNITA'')"',false,0.00,'XPK','30199230-1','22',0,false),
('122011','CARTELLA IN PRESPAN A 2 ANELLI CM. 33 X 27 DORSO CM. 3',false,0.00,'C62','30197210-1','22',0,false),
('122012','CARTELLA IN PRESPAN A 3 ALETTE ED ELASTICO CM. 35 X 25 DORSO CM. 3',false,0.00,'C62','30197210-1','22',0,false),
('122013','CARTELLA IN PRESPAN A 4 ANELLI  CM. 22 X 30 DORSO CM. 2.5',false,0.00,'C62','30197210-1','22',0,false),
('122014','CARTELLE SOSPESE IN CSARTONCINO PER ARMADI CON PORTAETICHETTE LENTICOLARE A ''U'' CM. 3',false,0.00,'XPK','30199500-5','22',0,false),
('122015','CARTELLE SOSPESE IN CARTONCINO PER ARMADI CON PORTA ETICHETTE LENTICOLARE A ''V'' ',false,0.00,'XPK','30199500-5','22',0,false),
('122018','SEPARATORE ALFABETICO / NUMERICO',false,0.00,'XPK','22992000-0','22',0,false),
('122101','ROTOLO SCONTRINI PER SISTEMA ELIMINA CODE',false,0.00,'XPK','22992000-0','22',0,false),
('130101','BUSTA  INTESTATA PROVINCIA DI TORINO MEZZO PROTOCOLLO CM. 18 X 24 (QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199710-0','22',0,false),
('130102','BUSTA INTESTATA CONSIGLIO PROVINCIALE CON SOFFIETTO, ALETTA AUTOADESIVA, CM. 26 X 36 X 4 (QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199710-0','22',0,false),
('130103','BUSTA INTESTATA PROVINCIA  SENZA FINESTRA CM. 23 X 11 (QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199710-0','22',0,false),
('130104','BUSTA INTESTATA PROVINCIA CON FINESTRA CM. 23 X 11 (QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199710-0','22',0,false),
('130105','BUSTA INTESTATA PROVINCIA DI TORINO A SACCO CM. 26 X 36 (QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199710-0','22',0,false),
('130106','BUSTA INTESTATA PROVINCIA DI TORINO CM. 16 X 11,5 (QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199710-0','22',0,false),
('130107','BUSTA INTESTATA PROVINCIA DI TORINO CON SOFFIETTO, COLORE AVANA, ALETTA AUTOADESIVA  CM. 26 X 36 X 4 (QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199710-0','22',0,false),
('130108','BUSTA VERDE PER NOTIFICAZIONE ATTI CM. 23 X 11(QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199710-0','22',0,false),
('130109','BUSTA VERDE PER NOTIFICAZIONE ATTI GIUDIZIARI DIMENSIONI CM. 24X18',false,0.00,'C62','30199710-0','22',0,false),
('130201','LIBRO PER FIRMA',false,0.00,'C62','22810000-1','22',0,false),
('130202','REGISTRO IVA',false,0.00,'C62','22810000-1','22',0,false),
('130301','RUBRICA TELEFONICA  CON FOGLI INTERCAMBIABILI',false,0.00,'C62','22819000-4','22',0,false),
('130302','FOGLI INTERCALARI A RUBRICA CM. 21 X 29,7',false,0.00,'C62','22992000-0','22',0,false),
('130303','FOGLI INTERCALARI CM. 21 X 29,7 (CONFEZ. DA 12)',false,0.00,'C62','22992000-0','22',0,false),
('130304','RICAMBI PER RUBRICA TELEFONICA',false,0.00,'C62','22819000-4','22',0,false),
('130401','CARTOLINA VERDE PER RICEVUTA NOTIFICAZIONE ATTI GIUDIZIARI',false,0.00,'C62','22300000-3','22',0,false),
('130501','BROCHURES',false,0.00,'C62','22460000-2','22',0,false),
('130601','STAMPA DI CARTELLINE',false,0.00,'C62','79810000-5','22',0,false),
('130602','CARTELLINE PERSONALIZZATE ARCHIVIO GENERALE',false,0.00,'C62','22992000-0','22',0,false),
('130603','CARTELLINE PERSONALIZZATE RISORSE IDRICHE',false,0.00,'C62','22992000-0','22',0,false),
('130604','CARTELLINE PERSONALIZZATE CITTA METROPOLITANA DI TORINO',false,0.00,'C62','22992000-0','22',0,false),
('130701','STAMPA DI DEPLIANTS',false,0.00,'C62','79810000-5','22',0,false),
('130801','STAMPA DI ETICHETTE',false,0.00,'C62','79810000-5','22',0,false),
('130802','STAMPA DI ADESIVI',false,0.00,'C62','79810000-5','22',0,false),
('130901','CARTOLINE PRESENZE PRIMA QUINDICINA',false,0.00,'C62','30199220-8','22',0,false),
('130902','CARTOLINE PRESENZE SECONDA QUINDICINA',false,0.00,'C62','30199220-8','22',0,false),
('131001','BLOCCO VERBALE MOD. A                                                                                                                                                                 ',false,0.00,'C62','22816000-3','22',0,false),
('131002','BLOCCO VERBALE MOD. B',false,0.00,'C62','22816000-3','22',0,false),
('131003','BLOCCO VERBALE MOD. AA',false,0.00,'C62','22816000-3','22',0,false),
('131004','BLOCCO VERBALE MOD. BA',false,0.00,'C62','22816000-3','22',0,false),
('131005','BLOCCO VERBALE MOD. RS',false,0.00,'C62','22816000-3','22',0,false),
('131006','BLOCCO VERBALE MOD. GGV',false,0.00,'C62','22816000-3','22',0,false),
('131007','BLOCCO VERBALE MOD. VFA',false,0.00,'C62','22816000-3','22',0,false),
('131008','BLOCCO VERBALE MOD. BC',false,0.00,'C62','22816000-3','22',0,false),
('140101','CARTA PROTOCOLLO A QUADRETTI (QUANTITA'' IN: BLOCCHETTI DA 10 FOGLI)',false,0.00,'C62','22832000-1','22',0,false),
('140102','CARTA PROTOCOLLO USO BOLLO GR. 60 (QUANTITA'' IN: BLOCCHETTI DA 10 FOGLI)',false,0.00,'C62','22832000-1','22',0,false),
('140201','LUCIDO UNIVERSALE A 4 (QUANTITA'' IN FOGLI)',false,0.00,'C62','30194320-4','22',0,false),
('140301','CARTA PER PLOTTER COD. C6019B',false,0.00,'C62','30197630-1','22',0,false),
('140302','CARTA PER PLOTTER COD. C6568B',false,0.00,'C62','30197630-1','22',0,false),
('140303','CARTA PER PLOTTER COD. C6810A',false,0.00,'C62','30197630-1','22',0,false),
('140304','CARTA PER PLOTTER COD. Q1397A',false,0.00,'C62','30197630-1','22',0,false),
('140305','CARTA PER PLOTTER COD. Q1427B',false,0.00,'C62','30197630-1','22',0,false),
('140306','CARTA PER PLOTTER COD. C6020B',false,0.00,'C62','30197630-1','22',0,false),
('140307','CARTA PER PLOTTER COD. C3875A',false,0.00,'C62','30197630-1','22',0,false),
('140308','CARTA PER PLOTTER COD. C6029C',false,0.00,'C62','30197630-1','22',0,false),
('140401','CARTA DA PACCHI  ( QUANTITA'' IN FOGLI)',false,0.00,'C62','22993400-1','22',0,false),
('140501','ROTOLO DI CARTA PER MACCHINA CALCOLATRICE MM. 57',false,0.00,'C62','30197641-1','22',0,false),
('140502','ROTOLO DI CARTA PER MACCHINA CALCOLATRICE MM. 60',false,0.00,'C62','30197641-1','22',0,false),
('140503','ROTOLO ELIMINA CODA',false,0.00,'C62','22992000-0','22',0,false),
('140601','BUSTA IMBOTTITA A SACCO CM. 15 X 21 (QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199230-1','22',0,false),
('140602','BUSTA IMBOTTITA A SACCO CM. 18 X 26 (QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199230-1','22',0,false),
('140603','BUSTA IMBOTTITA A SACCO CM. 23 X 33 (QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199230-1','22',0,false),
('140604','BUSTA IMBOTTITA A SACCO CM. 27 X 36 (QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199230-1','22',0,false),
('140605','BUSTA IMBOTTITA A SACCO CM. 30 X 44 (QUANTITA'' IN: UNITA'')',false,0.00,'C62','30199230-1','22',0,false),
('140701','BLOCCHETTO INTESTATO CONSIGLIO PROVINCIALE DI TORINO',false,0.00,'C62','22816100-4','22',0,false),
('140702','BLOCK NOTES PER APPUNTI TELEFONICI',false,0.00,'C62','22816100-4','22',0,false),
('140703','BLOCK NOTES A QUADRETTI CM. 15 X 21',false,0.00,'C62','22816100-4','22',0,false),
('140704','BLOCK NOTES A QUADRETTI CM. 21 X 30',false,0.00,'XPK','22816100-4','22',0,false),
('140705','BLOCCO PER LAVAGNA CM. 65 X 100',false,0.00,'C62','30197621-5','22',0,false),
('140706','POST-IT MM. 38 X 51 ( BLOCCHETTO DA 100 FOGLIETTI )',false,0.00,'XPK','22816300-6','22',0,false),
('140707','POST-IT MM. 76 X 127 ( BLOCCHETTO DA 100 FOGLIETTI )',false,0.00,'XPK','22816300-6','22',0,false),
('140708','POST-IT MM. 76 X 76 ( BLOCCHETTO DA 100 FOGLIETTI )',false,0.00,'XPK','22816300-6','22',0,false),
('140801','CARTONCINO BIANCO GR. 160 CM. 21 X 29,7 (QUANTITA'' IN: RISME  DA 250 FOGLI)',false,0.00,'RM','30197645-9','22',0,false),
('140802','CARTONCINO BIANCO GR. 160 CM. 42 X 29,7 (QUANTITA'' IN: RISME DA 250 FOGLI)',false,0.00,'C62','30197645-9','22',0,false),
('140803','CARTONCINO COLORATO GR. 160 CM. 21 X 29,7 (QUANTITA'' IN: RISME  DA 250 FOGLI)',false,0.00,'RM','30197645-9','22',0,false),
('140804','CARTONCINO COLORATO GR. 160 CM. 42 X 29,7 (QUANTITA'' IN : RISME  DA 125 FOGLI)',false,0.00,'C62','30197645-9','22',0,false),
('140805','CARTONCINO A RIGHE',false,0.00,'C62','30197645-9','22',0,false),
('140806','CARTONCINO COLORATO GR. 160 CM. 21X29,7 (QUANTITA'' IN RISME DA 100 FOGLI)',false,0.00,'C62','30197645-9','22',0,false),
('140807','CARTONCINO COLORATO GR. 160 CM. 21X29,7 COLORI FORTI - (QUANTITA'' IN RISME DA 250 FOGLI)',false,0.00,'C62','30197645-9','22',0,false),
('140808','CARTONCINO COLORATO GR. 80 CM. 21X29,7 (QUANTITA'' IN RISME DA 500 FOGLI)',false,0.00,'C62','30197645-9','22',0,false),
('140809','CARTONCINO COLORATO GR. 80 CM. 42X29,7 (QUANTITA'' IN RISME DA 500 FOGLI)',false,0.00,'C62','30197645-9','22',0,false),
('140901','CARTA BIANCA PER FOTOCOPIATORI CM.  21 X 29,7 (QUANTITA'' IN: RISME DA 500 FOGLI)',false,0.00,'C62','30197643-5','22',0,false),
('140902','CARTA BIANCA PER FOTOCOPIATORI CM.  42 X 29,7 (QUANTITA'' IN: RISME DA 500 FOGLI)',false,0.00,'C62','30197643-5','22',0,false),
('140903','CARTA RICICLATA PER FOTOCOPIATORI CM 42X29,7 ( QUANTITA'' IN RISME DA 500 FOGLI)',false,0.00,'C62','30197643-5','22',0,false),
('140904','CARTA RICICLATA PER FOTOCOPIATORI CM. 21 X 29,7 (QUANTITA'' IN: RISME DA 500 FOGLI)',false,0.00,'C62','30197643-5','22',0,false),
('141001','CARTA COLORATA GR. 80 CM. 21 X 29,7 (QUANTITA'' IN :RISME DA 500 FOGLI)',false,0.00,'C62','30197643-5','22',0,false),
('141002','CARTA COLORATA GR. 80 CM. 42 X 29,7 (QUANTITA'' IN RISME DA 250 FOGLI)',false,0.00,'C62','30197643-5','22',0,false),
('141101','QUADERNO A4 ',false,0.00,'XPK','22830000-7','22',0,false),
('150101','BERRETTI',false,0.00,'C62','18440000-5','22',0,false),
('150102','COPRICAPO ESTIVO',false,0.00,'C62','18440000-5','22',0,false),
('150103','COPRICAPO INVERNALE',false,0.00,'C62','18440000-5','22',0,false),
('150201','CAPPOTTI',false,0.00,'C62','18210000-4','22',0,false),
('150301','IMPERMEABILI',false,0.00,'C62','18221000-4','22',0,false),
('150302','COMPLETO ANTIPIOGGIA H.V.',false,0.00,'C62','18221000-4','22',0,false),
('150401','GIACCONI - GIACCHE',false,0.00,'C62','18223000-8','22',0,false),
('150402','GIACCA A VENTO H.V.',false,0.00,'C62','18223000-8','22',0,false),
('150501','GIUBBOTTI',false,0.00,'C62','18223000-8','22',0,false),
('150502','GILET',false,0.00,'C62','18223000-8','22',0,false),
('150601','PANTALONI-GONNE PANTALONI',false,0.00,'C62','18234000-8','22',0,false),
('150602','PANTALONE ESTIVO H.V.',false,0.00,'C62','18234000-8','22',0,false),
('150603','PANTALONE INVERNALE H.V.',false,0.00,'C62','18234000-8','22',0,false),
('150604','PANTALONE INVERNALE',false,0.00,'C62','18234000-8','22',0,false),
('150605','PANTALONE ESTIVO',false,0.00,'C62','18234000-8','22',0,false),
('150701','CAMICIE-CAMICIOTTI',false,0.00,'C62','18332000-5','22',0,false),
('150702','CAMICIA INVERNALE',false,0.00,'C62','18332000-5','22',0,false),
('150703','CAMICIA ESTIVA',false,0.00,'C62','18332000-5','22',0,false),
('150801','MAGLIE-MAGLIETTE IN LANA',false,0.00,'C62','18331000-8','22',0,false),
('150802','MAGLIA IN LANA',false,0.00,'C62','18235000-5','22',0,false),
('150901','MAGLIE-MAGLIETTE IN COTONE',false,0.00,'C62','18331000-8','22',0,false),
('150902','POLO MANICA CORTA',false,0.00,'C62','18333000-2','22',0,false),
('150903','POLO MANICA LUNGA',false,0.00,'C62','18333000-2','22',0,false),
('150904','TSHIRT H.V.',false,0.00,'C62','18331000-8','22',0,false),
('150905','POLO M/C H.V.',false,0.00,'C62','18333000-2','22',0,false),
('150906','POLO M/L H.V.',false,0.00,'C62','18333000-2','22',0,false),
('150907','MAGLIETTA INTIMA',false,0.00,'C62','18310000-5','22',0,false),
('151001','GUANTI DA DIVISA IN PELLE',false,0.00,'C62','18424000-7','22',0,false),
('151101','GUANTI DA DIVISA IN TESSUTO',false,0.00,'C62','18424000-7','22',0,false),
('151201','CALZATURE',false,0.00,'C62','18800000-7','22',0,false),
('151301','CALZE',false,0.00,'C62','18315000-0','22',0,false),
('151302','CALZE ESTIVE',false,0.00,'C62','18315000-0','22',0,false),
('151303','CALZE INVERNALI',false,0.00,'C62','18315000-0','22',0,false),
('151401','CRAVATTE-FOULARDS-SCIARPE',false,0.00,'C62','18420000-9','22',0,false),
('151501','TUTE DA LAVORO',false,0.00,'C62','18114000-1','22',0,false),
('151502','TUTA DA LAVORO',false,0.00,'C62','18114000-1','22',0,false),
('151503','TUTA DA LAVORO H.V.',false,0.00,'C62','18114000-1','22',0,false),
('151601','PILE ',false,0.00,'C62','18235000-5','22',0,false),
('151602','PILE H.V.',false,0.00,'C62','18235000-5','22',0,false),
('151701','STEMMA RICAMATO',false,0.00,'C62','39561132-6','22',0,false),
('151801','ZAINO ',false,0.00,'C62','18931100-5','22',0,false),
('151802','BORSA',false,0.00,'C62','18930000-7','22',0,false),
('151901','CINTURA ',false,0.00,'C62','18425000-4','22',0,false),
('151902','CINTURONE',false,0.00,'C62','18425000-4','22',0,false),
('160101','BICICLETTE',false,0.00,'C62','34430000-0','22',0,false),
('160201','IMBARCAZIONI',false,0.00,'C62','34500000-2','22',0,false),
('170101','GRASSI - OLII E LUBRIFICANTI',false,0.00,'LTR','24951000-5','22',0,false),
('180101','GPL PER AUTOTRAZIONE',false,0.00,'LTR','09133000-0','22',0,false),
('180201','GASOLIO PER AUTOTRAZIONE',false,0.00,'LTR','09134100-8','22',0,false),
('180301','BENZINA PER AUTOTRAZIONE',false,0.00,'LTR','09132000-3','22',0,false),
('180401','METANO PER AUTOTRAZIONE',false,0.00,'LTR','09123000-7','22',0,false),
('180501','GPL PER RISCALDAMENTO',false,0.00,'LTR','09133000-0','22',0,false),
('180601','GASOLIO PER RISCALDAMENTO',false,0.00,'LTR','09135100-5','22',0,false),
('180701','GPL USO COTTURA',false,0.00,'LTR','09133000-0','10',0,false),
('190101','VARIE',false,0.00,'C62','39830000-9','22',0,false),
('190102','BUSTA SPAZZATURA NERA',false,0.00,'XPK','19640000-4','22',0,false),
('190103','BUSTE SPAZZATURA TRASPARENTI',false,0.00,'XPK','19640000-4','22',0,false),
('200101','BANDIERE-GONFALONI',false,0.00,'C62','35821000-5','22',0,false),
('200102','POSA BANDIERE',false,0.00,'C62','35821100-6','22',0,false),
('200201','BUFFET E BUVETTE',false,0.00,'C62','55520000-1','22',0,false),
('200301','RINFRESCHI-RICEVIMENTI',false,0.00,'C62','55520000-1','22',0,false),
('210101','MEDICINALI',false,0.00,'C62','33600000-6','22',0,false),
('210201','DISINFETTANTI GENERICI',false,0.00,'C62','33631600-8','22',0,false),
('210202','INSETTICIDA SPRAY',false,0.00,'C62','33691000-0','22',0,false),
('210301','CEROTTI DA 20 PZ. PER CASSETTE PRONTO SOCCORSO',false,0.00,'C62','33141112-8','22',0,false),
('210302','COMPRESSE GARZA DA 12 PZ. PER CASSETTE PRONTO SOCCORSO',false,0.00,'C62','33141116-6','22',0,false),
('210303','GHIACCIO A SECCO PER CASSETTE PRONTO SOCCORSO',false,0.00,'C62','33141620-2','22',0,false),
('210304','PACCHI DI REINTEGRO ALL. 1 DM. 388/2003',false,0.00,'C62','33141620-2','22',0,false),
('210305','SOLUZIONE CUTANEA IN FLACONI PER CASSETTE PRONTO SOCCORSO',false,0.00,'C62','33631600-8','22',0,false),
('210306','VALIGETTA DI PRONTO SOCCORSO COMPLETA DI PRESIDI MEDICALI A D.M. 388/2003 ALL. 2',false,0.00,'C62','33141623-3','22',0,false),
('210307','DISPOSITIVO FASTJEKT',false,0.00,'C62','33141620-2','10',0,false),
('210308','PACCHI DI REINTEGRO ALL. 2  D.M 388/2003',false,0.00,'C62','33141620-2','22',0,false),
('210309','MASCHERA CON VISIERA PARASCHIZZI',false,0.00,'C62','33141000-0','22',0,false),
('220101','INSERZIONI',false,0.00,'C62','22120000-7','22',0,false),
('220201','PUBBLICAZIONI',false,0.00,'C62','22120000-7','22',0,false),
('230101','INDICATORI PER SEGNALETICA',false,0.00,'C62','34992200-9','22',0,false),
('230201','CARTELLI STRADALI NORMALI',false,0.00,'C62','34992300-0','22',0,false),
('240101','DISINFESTAZIONE',false,0.00,'C62','90923000-3','22',0,false),
('240201','DERATTIZZAZIONE',false,0.00,'C62','90923000-3','22',0,false),
('240301','SGOMBERO NEVE',false,0.00,'C62','90620000-9','22',0,false),
('240401','MANUTENZIONE AREE VERDI',false,0.00,'C62','77310000-6','22',0,false),
('240501','INTERPRETARIATO',false,0.00,'C62','79540000-1','22',0,false),
('240601','SERVIZIO CATERING',false,0.00,'C62','55520000-1','22',0,false),
('240701','ENERGIA ELETTRICA',false,0.00,'C62','65310000-9','22',0,false),
('240702','ACQUA POTABILE',false,0.00,'C62','65110000-7','22',0,false),
('240703','GAS COTTURA',false,0.00,'C62','65210000-8','22',0,false),
('240704','GAS NATURALE',false,0.00,'C62','65210000-8','22',0,false),
('240705','IMPIANTI FOTOVOLTAICI',false,0.00,'C62','65320000-2','22',0,false),
('240706','TELEFONIA',false,0.00,'C62','64210000-1','22',0,false),
('240801','ADEGUAMENTO TAGLIE CAPI DI VESTIARIO',false,0.00,'C62','50830000-2','22',0,false),
('250101','RIPARAZIONE DI ARMADI METALLICI',false,0.00,'C62','50850000-8','22',0,false),
('250201','RIPARAZIONE DI CASSEFORTI',false,0.00,'C62','50800000-3','22',0,false),
('250301','RIPARAZIONE DI CASSETTIERE IN METALLO',false,0.00,'C62','50850000-8','22',0,false),
('250401','RIPARAZIONE DI ELETTROSCHEDARI',false,0.00,'C62','50800000-3','22',0,false),
('250501','RIPARAZIONE DI SCRIVANIE',false,0.00,'C62','50850000-8','22',0,false),
('250601','RIPARAZIONE DI SEDIE-POLTRONE',false,0.00,'C62','50850000-8','22',0,false),
('250701','MACCHINE FOTOGRAFICHE',false,0.00,'C62','50344000-8','22',0,false),
('250801','PROIETTORI',false,0.00,'C62','50344000-8','22',0,false),
('250901','VIDEOCAMERE',false,0.00,'C62','50344000-8','22',0,false),
('251001','TELEVISORI',false,0.00,'C62','50340000-0','22',0,false),
('251101','AMPLIFICATORI-DIFFUSORI',false,0.00,'C62','50800000-3','22',0,false),
('251201','MICROFONI',false,0.00,'C62','50800000-3','22',0,false),
('251301','APPARECCHIATURE PER RILEVAMENTI TOPOGRAFICI',false,0.00,'C62','50800000-3','22',0,false),
('251401','STAMPANTI',false,0.00,'C62','50313000-2','22',0,false),
('251501','PLOTTER',false,0.00,'C62','50313000-2','22',0,false),
('251601','APPARECCHIATURE PER RILEVAMENTO PRESENZE',false,0.00,'C62','50432000-2','22',0,false),
('251701','FOTOCOPIATORI',false,0.00,'C62','50313000-2','22',0,false),
('251801','MACCHINA DISTRUGGIDOCUMENTI',false,0.00,'C62','50800000-3','22',0,false),
('251901','MACCHINA PINZATRICE',false,0.00,'C62','50800000-3','22',0,false),
('252001','MACCHINA CUCITRICE',false,0.00,'C62','50800000-3','22',0,false),
('252101','MACCHINA PIEGATRICE',false,0.00,'C62','50800000-3','22',0,false),
('252201','BICICLETTE',false,0.00,'C62','50100000-6','22',0,false),
('252301','ASCENSORI',false,0.00,'C62','50750000-7','22',0,false),
('252401','RIPARAZIONE DI MONTACARICHI',false,0.00,'C62','50750000-7','22',0,false),
('260101','SISTEMI DI ARCHIVIAZIONE MANUALE ED ELETTRICI',false,0.00,'C62','50000000-5','22',0,false),
('260201','STAMPANTI',false,0.00,'C62','50313000-2','22',0,false),
('260301','APPARECCHIATURE PER RILEVAMENTO PRESENZE',false,0.00,'C62','50432000-2','22',0,false),
('260401','MACCHINE BOLLATRICI',false,0.00,'C62','50432000-2','22',0,false),
('260501','ESTINTORI',false,0.00,'C62','50413200-5','22',0,false),
('260601','ASCENSORI',false,0.00,'C62','50750000-7','22',0,false),
('260701','MONTACARICHI',false,0.00,'C62','50750000-7','22',0,false),
('260801','RIPARAZIONI PICCOLE ATTREZZATURE',false,0.00,'C62','50000000-5','22',0,false),
('260802','RIPARZIONI ATTREZZATURE',false,0.00,'C62','50000000-5','22',0,false),
('280101','RICHIESTA ATTIVAZIONE LINEA',false,0.00,'C62','64210000-1','0',0,false),
('280102','RICHIESTA VOLTURAZIONE LINEA',false,0.00,'C62','64210000-1','0',0,false),
('280103','RICHIESTA CESSAZIONE LINEA',false,0.00,'C62','64210000-1','0',0,false),
('280104','SEGNALAZIONE GUASTO',false,0.00,'C62','64210000-1','0',0,false),
('280105','RICHIESTA VARIAZIONE SPECIFICHE/PROFILO LINEA',false,0.00,'C62','64210000-1','0',0,false),
('280201','RICHIESTA ASSEGNAZIONE NUOVA UTENZA',false,0.00,'C62','64212000-5','0',0,false),
('280202','RICHIESTA CESSIONE UTENZA',false,0.00,'C62','64212000-5','0',0,false),
('280203','RICHIESTA CESSAZIONE UTENZA',false,0.00,'C62','64212000-5','0',0,false),
('280204','RICHIESTA SUBENTRO UTENZA',false,0.00,'C62','64212000-5','0',0,false),
('280205','SEGNALAZIONE GUASTO/MALFUNZIONAMENTO',false,0.00,'C62','64212000-5','0',0,false),
('280206','SEGNALAZIONE FURTO/SMARRIMENTO',false,0.00,'C62','64212000-5','0',0,false),
('280207','RICHIESTA ABILITAZIONE CHIAMATE PRIVATE (DUAL BILLING)',false,0.00,'C62','64212000-5','0',0,false),
('280208','RICHIESTA VARIAZIONE PROFILO UTENZA',false,0.00,'C62','64212000-5','0',0,false),
('280209','RICHIESTA CAMBIO CARTA SIM',false,0.00,'C62','64212000-5','0',0,false),
('280210','RICHIESTA ACCESSORI',false,0.00,'C62','64212000-5','0',0,false),
('280211','ALTRE RICHIESTE',false,0.00,'C62','64212000-5','0',0,false)
) AS tmp(oggetti_spesa_codice, oggetti_spesa_descrizione, inventariabile, prezzo_unitario, 
unita_misura_codice, cpv_codice, aliquote_iva_codice,quantita_max_richiedibile, generico)
JOIN cpass.cpass_d_unita_misura dum ON (dum.unita_misura_codice = tmp.unita_misura_codice)
JOIN cpass.cpass_d_cpv dc ON (dc.cpv_codice = tmp.cpv_codice)
JOIN cpass.cpass_d_aliquote_iva dai ON (dai.aliquote_iva_codice = tmp.aliquote_iva_codice)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_oggetti_spesa current
  WHERE current.oggetti_spesa_codice = tmp.oggetti_spesa_codice
);

delete from cpass_t_parametro;
INSERT INTO cpass.cpass_t_parametro VALUES (44, 'OAUTH2_URL', 'https://tst-api-ent.ecosis.csi.it/api/token', true, 'EXT', 'SIAC', 'Dati trasversali SIAC', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (145, 'WSDL_LOCATION', 'https://tst-api-ent.ecosis.csi.it/store/site/themes/fancy/templates/api/documentation/download.jag?tenant=carbon.super&resourceUrl=/wso020/registry/resource/_system/governance/apimgt/applicationdata/provider/bilancio-cre/BILANCIO_contabilia_ricercaService/1.0/documentation/files/RicercaService.wsdl', true, 'IMPEGNO', 'SIAC', 'ricerca impegni', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (146, 'WSDL_LOCATION', 'https://tst-api-ent.ecosis.csi.it/store/site/themes/fancy/templates/api/documentation/download.jag?tenant=carbon.super&resourceUrl=/wso020/registry/resource/_system/governance/apimgt/applicationdata/provider/bilancio-cre/BILANCIO_contabilia_ricercaService/1.0/documentation/files/RicercaService.wsdl', true, 'DOCUMENTO-SPESA', 'SIAC', 'documento spesa', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (151, 'WSDL_LOCATION', 'https://tst-api-ent.ecosis.csi.it/store/site/themes/fancy/templates/api/documentation/download.jag?tenant=null&resourceUrl=/wso007/registry/resource/_system/governance/apimgt/applicationdata/wsdls/bilancio-cre--BILANCIO_contabilia_documentiService1.0.wsdl'                                            , true, 'LEGGI-STATO-ELABORAZIONE-DOCUMENTO', 'SIAC', 'ricerca impegni', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (152, 'WSDL_LOCATION', 'https://tst-api-ent.ecosis.csi.it/store/site/themes/fancy/templates/api/documentation/download.jag?tenant=carbon.super&resourceUrl=/wso020/registry/resource/_system/governance/apimgt/applicationdata/provider/bilancio-cre/BILANCIO_contabilia_ricercaService/1.0/documentation/files/RicercaService.wsdl', true, 'FORNITORE', 'SIAC', 'ricerca impegni', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (45, 'CONSUMER_KEY', 'kWcMwvFctfRpDgcKL_2ppEnwQbYa', true, 'EXT', 'SIAC', 'Dati trasversali SIAC', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (46, 'CONSUMER_SECRET', 'I7ZAUNlapUSugn17uqOOA97wjn8a', true, 'EXT', 'SIAC', 'Dati trasversali SIAC', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (35, 'MIT_URL_WSLOGIN', 'http://131.1.220.215/WSLoginCollaudo/rest', true, '', 'MIT', 'Per trasmissione programma al MIT', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (36, 'MIT_URL_WSPROGRAMMI', 'http://131.1.220.215/WSProgrammiCollaudo/rest', true, '', 'MIT', 'Per trasmissione programma al MIT', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (41, 'MIT_PROXY_HOSTNAME', 'podto2-proxy.site02.nivolapiemonte.it', true, '', 'MIT', 'Per trasmissione programma al MIT', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (31, 'MIT_USERNAME', 'RegPiemonte', true, '', 'MIT', 'Per trasmissione programma al MIT', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (32, 'MIT_PASSWORD', 'Acquistireg1!', true, '', 'MIT', 'Per trasmissione programma al MIT', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (42, 'MIT_PROXY_PORT', '3128', true, '', 'MIT', 'Per trasmissione programma al MIT', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (33, 'MIT_CLIENT_KEY', 'A$nCot5xAuA3Gd95', true, '', 'MIT', 'Per trasmissione programma al MIT', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (34, 'MIT_CLIENT_ID', 'RegPiemonteApp', true, '', 'MIT', 'Per trasmissione programma al MIT', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (108,'PORTA_NOTIER', '8443', true, 'NSO', 'NOTIER', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (115,'KEYSTORE_PASS_NOTIER', 'ekrG$x+e3^', true, 'NSO', 'NOTIER', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (116,'KEY_PASS_NOTIER', 'ekrG$x+e3^', true, 'NSO', 'NOTIER', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (122,'PROXY_PORT_NOTIER', '3128', true, 'NSO', 'NOTIER', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (121,'PROXY_HOSTNAME_NOTIER', 'podto2-proxy.site02.nivolapiemonte.it', true, 'NSO', 'NOTIER', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (105, 'NSO_CUSTOMIZATION_ID', 'urn:fdc:peppol.eu:poacc:trns:order:3:restrictive:urn:www.agid.gov.it:trns:ordine:3.1', true, 'NSO', 'NOTIER', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (107, 'HOST_NOTIER', 'test-notier.regione.emilia-romagna.it', true, 'NSO', 'NOTIER', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (72, 'WSDL_LOCATION',              'http://coll-stilo.wsbe.cittametropolitana.torino.it/stilobusiness/soap/WSGetMetadataUd?wsdl', true, 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (133, 'WSDL_LOCATION_RICERCA_DOC', 'http://coll-stilo.wsbe.cittametropolitana.torino.it/stilobusiness/soap/WSTrovaDocFolder?wsdl', true, 'PROVVEDIMENTO', 'STILO', 'Per estrazione lista Provvediment1', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (106, 'NSO_PROFILE_ID', 'urn:fdc:peppol.eu:poacc:bis:order_only:3', true, 'NSO', 'NOTIER', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (60, 'DATA_ORDINI_FUTURI', '01/06', true, 'IMPEGNO', '', 'Per interrogazione IMPEGNO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (43, 'USE_OAUTH2', 'true', true, 'EXT', 'SIAC', 'Dati trasversali SIAC', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (48, 'CODICE_APPLICATIVO', 'CPASS', true, 'EXT', 'SIAC', 'Dati trasversali SIAC', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (49, 'IMPLEMENTOR', 'siac', true, 'FORNITORE', '', 'Per interrogazione FORNITORE', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (50, 'IMPLEMENTOR_EJB_NAME', 'java:global/cpassbe/cpassbe-lib-siac/FornitoreHelperEJBImpl', false, 'FORNITORE', 'SIAC', 'Per interrogazione FORNITORE', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (51, 'IMPLEMENTOR_CDI_NAME', 'FornitoreHelperCDIImpl-SIAC', false, 'FORNITORE', 'SIAC', 'Per interrogazione FORNITORE', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (52, 'IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.siac.FornitoreHelperImpl', true, 'FORNITORE', 'SIAC', 'Per interrogazione FORNITORE', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (58, 'IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.siac.ImpegnoHelperImpl', true, 'IMPEGNO', 'SIAC', 'Per interrogazione IMPEGNO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (83, 'IMPLEMENTOR', 'siac', true, 'DOCUMENTO-SPESA', '', 'Per interrogazione DOCUMENTO_SPESA', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (84, 'IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.siac.DocumentoSpesaHelperImpl', true, 'DOCUMENTO-SPESA', 'SIAC', 'Per interrogazione DOCUMENTO_SPESA', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (85, 'STATO_FATTURA_RIPARTIBILE', 'I', true, 'DOCUMENTO-SPESA', 'SIAC', 'Per interrogazione DOCUMENTO_SPESA', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (54, 'IMPLEMENTOR', 'siac', true, 'IMPEGNO', '', 'Per interrogazione IMPEGNO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (89, 'MODALITA_INVIO_EVASIONE', 'ASINCRONA', true, 'EVASIONE', '', 'Per salvare idOperazione del invio a contabilita nella tabella Elaborazione', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (55, 'ANNO_AVVIO_STILO', '2020', true, 'IMPEGNO', '', 'Per interrogazione IMPEGNO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (61, 'ASSOC_IMPEGNI_ORD', 'DISP_CRESC', true, 'IMPEGNO', '', 'Per interrogazione IMPEGNO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (90, 'SERVIZIO_VERIFICA_EVASIONE', 'TRUE', true, 'EVASIONE', '', 'Per aggiornamenti dopo invio contabilita', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (62, 'CTRL_CLASSE_SOGG', 'AVVISO', true, 'IMPEGNO', '', 'Per interrogazione IMPEGNO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (71, 'CODICE_APPLICATIVO', 'CPASS', true, 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (91, 'MOTIVAZIONE_NON_RIPROPOSTO_DEFAULT', 'campo su parametro da valorizzare', true, '', 'CPASS', 'motivazione per acquisti non riproposti di default in creazione acquisti da nuovo programma', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (92, 'IMPLEMENTOR', 'siac', true, 'INVIO-QUOTE-DOCUMENTO', '', 'Per interrogazione INVIO-QUOTE-DOCUMENTO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (93, 'IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.siac.InvioQuoteDocumentoHelperImpl', true, 'INVIO-QUOTE-DOCUMENTO', 'SIAC', 'Per interrogazione INVIO-QUOTE-DOCUMENTO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (94, 'WSDL_LOCATION', '', false, 'INVIO-QUOTE-DOCUMENTO', 'SIAC', 'Per interrogazione INVIO-QUOTE-DOCUMENTO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (56, 'CODICE_TIPO_PROVV_STILO', 'DD', true, 'IMPEGNO', '', 'Per interrogazione IMPEGNO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (101, 'PATH_SUBIMPEGNI_CSV', '', true, 'IMPEGNOEXT', 'IMPEGNOEXT', 'locazione del file csv per aggiornamento subimpegni', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (102, 'POLL_TIME_NOTIFICATIONS', '2.0', true, 'NOTIFICA', '', 'Minuti tra una chiamata e l''altra per il poll delle notifiche', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (47, 'CODICE_ENTE', 'CMTO', true, 'EXT', 'SIAC', 'Dati trasversali SIAC', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (87, 'VERIFICA_STORICO_FORNITORI', 'SI', true, 'DOCUMENTO-SPESA', 'SIAC', 'Per interrogazione DOCUMENTO_SPESA', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (96, 'IMPLEMENTOR', 'siac', true, 'LEGGI-STATO-ELABORAZIONE-DOCUMENTO', '', 'Per interrogazione LEGGI-STATO-ELABORAZIONE-DOCUMENTOO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (97, 'IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.siac.LeggiStatoElaborazioneDocumentoHelperImpl', true, 'LEGGI-STATO-ELABORAZIONE-DOCUMENTO', 'SIAC', 'Per interrogazione LEGGI-STATO-ELABORAZIONE-DOCUMENTO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (98, 'IMPLEMENTOR', 'stilo', true, 'PROVVEDIMENTO', '', 'Per interrogazione PROVVEDIMENTO STILO ', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (99, 'IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.stilo.ProvvedimentoHelperImpl', true, 'PROVVEDIMENTO', 'STILO', 'Per interrogazione PROVVEDIMENTO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (103, 'IMPLEMENTOR', 'notier', true, 'NSO', '', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (104, 'IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.notier.NSOHelperImpl', true, 'NSO', 'NOTIER', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (95, 'FIRMA_REFERENTE', 'SI', true, '', 'CPASS', 'Firma del referente del programma nella stampa Scheda_B', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (113, 'PROTOCOL_NOTIER', 'https', true, 'NSO', 'NOTIER', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (109, 'VERIFICA_STRUTTURA_PROVVEDIMENTO', 'A', true, 'PROVVEDIMENTO', '', '', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (100, 'PATH_IMPEGNI_CSV', '', true, 'IMPEGNOEXT', 'IMPEGNOEXT', 'locazione del file csv per aggiornamento impegni', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (70, 'CODICE_ENTE', 'CMTO', true, 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (57, 'CODICE_TIPO_PROVV_ANTE_STILO', 'AD', true, 'IMPEGNO', '', 'Per interrogazione IMPEGNO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (63, 'ORD_TOLLERANZA_IVA', '0.05', true, 'RIGA-ORDINE', '', 'Per controllo tolleranza iva', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (88, 'TOLLERANZA_EVASIONE', '0.05', true, 'EVASIONE', '', 'Per controllo tolleranza sul evasione', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (73, 'USER', 'USER-CPASS', true, 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (74, 'PW', '', true, 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (117, 'INTEGRAZIONE_NSO', 'true', true, 'NSO', 'NOTIER', 'indica se il sistema si integra con NSO', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (119, 'NSO_DOCUMENT_ID', 'urn:oasis:names:specification:ubl:schema:xsd:Order-2::Order##urn:fdc:peppol.eu:poacc:trns:order:3:restrictive:urn:www.agid.gov.it:trns:ordine:3.1::2.1', true, 'NSO', 'NOTIER', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (120, 'AMBIENTE', 'TEST', true, 'PROVVEDIMENTO', 'STILO', 'ambiente di integrazione', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (125, 'SISTEMA_DOCUMENTALE', 'NO PROTOCOLLO', true, 'PROTOCOLLO', 'ACTA', 'Aggancio al protocollo', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (126, 'STORICO_GG_FLUSSI', '1', true, 'IMPEGNOEXT', 'IMPEGNOEXT', 'giorni prima della cancellazione', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (127, 'GG_FINE_NOTIFICA', '10', true, 'NOTIFICA', 'CPASS', 'numero di giorni usati per definire la data fine della notifica', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (128, 'NSO_RECIPIENT_ID', '0201:testap', true, 'NSO', 'NOTIER', 'Per integrazione NSO, valorizzare SOLO per ambiente di test o sviluppo. Se lasciato bianco il dato viene valorizzato a runtime.', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (114, 'KEYSTORE_PATH_NOTIER', '/appserv/jboss/awf170/certs/ACSI.p12', true, 'NSO', 'NOTIER', 'Per interrogazione NSO', NULL);
INSERT INTO cpass.cpass_t_parametro VALUES (130, 'UTENTE_BATCH', 'AAAAAA00A11B000J', true, 'BATCH', 'BATCH', 'utenza identificata come batch', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (118, 'NSO_UNICO_DESTINATARIO', 'false', true, 'NSO', 'NOTIER', 'indica se il sistema si integra con NSO', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (136, 'AD', 'Atto dirigenziale', true, 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (137, 'DD', 'Determina dirigenziale', true, 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (138, 'DG', 'Delibera di giunta', true, 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', '0ced449c-a147-5419-802f-01acfab32807');


--------------------------------------------------------------------------------------------------------------------------------------
create table if not exists cpass.cpass_t_ufficio (
  ufficio_id SERIAL,
  ufficio_codice VARCHAR(50) NOT NULL,
  ufficio_descrizione VARCHAR(500) NOT NULL,
  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  optlock UUID DEFAULT uuid_generate_v4() NOT NULL,
  id_notier VARCHAR(200),
  ente_id UUID NOT NULL
); 

ALTER TABLE cpass.cpass_t_ufficio OWNER TO cpass;
CREATE SEQUENCE if not exists cpass.cpass_t_ufficio_ufficio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE cpass.cpass_t_ufficio_ufficio_id_seq OWNER TO cpass;


ALTER SEQUENCE cpass.cpass_t_ufficio_ufficio_id_seq OWNED BY cpass.cpass_t_ufficio.ufficio_id;

ALTER TABLE ONLY cpass.cpass_t_ufficio ALTER COLUMN ufficio_id SET DEFAULT nextval('cpass.cpass_t_ufficio_ufficio_id_seq'::regclass);

ALTER TABLE cpass.cpass_t_ufficio DROP CONSTRAINT  if exists fk_cpass_t_ufficio_ente;
ALTER TABLE cpass.cpass_t_ufficio   ADD CONSTRAINT  fk_cpass_t_ufficio_ente FOREIGN KEY (ente_id) REFERENCES cpass.cpass_t_ente(ente_id);


SELECT pg_catalog.setval('cpass.cpass_t_ufficio_ufficio_id_seq', 31, true);


--ALTER TABLE cpass.cpass_t_ufficio DROP CONSTRAINT if exists cpass_t_ufficio_pkey;
ALTER TABLE cpass.cpass_t_ufficio ADD CONSTRAINT cpass_t_ufficio_pkey PRIMARY KEY (ufficio_id);
GRANT ALL ON TABLE cpass.cpass_t_ufficio TO cpass_rw;



delete from cpass_t_ufficio;
INSERT INTO cpass.cpass_t_ufficio VALUES (1,'E3E4JV','Integrazione processi finanziari e contabili',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (2,'ZQ7NOL','Formazione professionale e Orientamento',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (3,'QB0TP9','Amministrazione, monitoraggio e controlli',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (4,'Q7STQD','Sistemi Naturali',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (5,'PGFMCK','Risorse idriche e tutela dell''atmosfera',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (6,'P4QH1W','Flussi Informativi',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (7,'MG3061','Dipartimento Educazione e welfare',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (8,'M4Y1O9','Azioni integrate con gli EE.LL.',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (9,'L6MO5G','Viabilità 2',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (10,'K31IU4','Valutazioni Ambientali',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (11,'JTR94E','Avvocatura',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (12,'JEV1NU','Sviluppo rurale e montano',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (13,'H80KJL','Audit - Controllo di gestione',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (14,'H0MK50','Organizzazione',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (15,'GPBI3Z','Attività produttive',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (16,'FGWKV6','Coordinamento edilizia - Edilizia scolastica 1',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (17,'0CWI00','Dipartimento Sviluppo Economico',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (18,'DJN7N5','Protezione Civile',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (19,'DC4K5T','Coordinamento viabilità - Viabilità 1',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (20,'A209G4','Polizia metropolitana',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (21,'9DEB5X','SEGRETERIA GENERALE',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (22,'912Q7N','Istruzione e sviluppo sociale',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (23,'7PS1RP','Programmazione e monitoraggio OO.PP. beni e servizi',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (24,'70CY8G','Comunicazione e rapporti con i cittadini e i territori',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (25,'5MTOEB','Centrale unica appalti e contratti',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (26,'5H8MKX','Rifiuti, bonifiche e sicurezza siti produttivi',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (27,'56IK8G','Servizio Prevenzione e protezione',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (28,'4BCSOZ','Edilizia scolastica 2',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (29,'422Z7M','Tutela flora e fauna',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_ufficio VALUES (30,'0ZIRBV','Dipartimento Territorio, edilizia e viabilità',now(),'admin',now(),'admin',NULL,NULL,uuid_generate_v4(),NULL,'0ced449c-a147-5419-802f-01acfab32807');
-------------------------------------------------------------------------------------------------

--INSERT INTO cpass.cpass_t_utente VALUES (uuid_generate_v5(tun.uuid_namespace_value::uuid, tmp.ente_denominazione), 'Demo', '21', 'AAAAAA00A11B000J', '2019-12-27 13:57:10.914347', 'admin', '2019-12-27 13:57:10.914347', 'admin', NULL, NULL, '92a9444d-13ec-41d4-aad8-31c4c23a9b3d', '0113345', 'demo20@email.csi.it', false);
delete from cpass_t_utente;
INSERT INTO cpass.cpass_t_utente VALUES ('971d1aa9-f3bb-5393-b20d-1433d9bf51ef', 'Demo', '21', 'AAAAAA00A11B000J', '2019-12-27 13:57:10.914347', 'admin', '2019-12-27 13:57:10.914347', 'admin', NULL, NULL, '92a9444d-13ec-41d4-aad8-31c4c23a9b3d', '0113345', 'demo20@email.csi.it', false);




--DA RIFARE 
delete from cpass_r_dirigente_settore;
--INSERT INTO cpass.cpass_r_dirigente_settore VALUES (1, '971d1aa9-f3bb-5393-b20d-1433d9bf51ef', '604ace0f-5f2a-5867-b38a-c9eb528e08a6', '2021-04-09 08:09:39.792303', NULL);
--+SELECT pg_catalog.setval('cpass.cpass_r_dirigente_settore_dirigente_settore_id_seq', 1, true);


------------------------------

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





---------------------------------------------------------------------------------------------------
-- NON ANCORA USATA VUOTA PER ORA
--INSERT INTO cpass.cpass_r_ord_utente_sezione VALUES (1, 1, '2906489b-87e9-5c44-9951-d2f44bcb176d', '2021-05-28 12:15:15.382465', 'admin', '2021-05-28 12:15:15.533378', 'admin', NULL, NULL, '6a197390-bbe7-4988-a82f-a43849221737');
--SELECT pg_catalog.setval('cpass.cpass_r_ord_utente_sezione_utente_sezione_id_seq', 1, true);
------------------------------------------------------------------------------------------------------------------------------

select * from cpass_t_settore;
select * from cpass_t_ufficio;
 
delete from cpass_r_ufficio_settore;
INSERT INTO cpass_r_ufficio_settore (ufficio_id, settore_id,data_validita_inizio,data_validita_fine)
SELECT dr.ufficio_id, dm.settore_id,now(),null
FROM (VALUES
  ('E3E4JV', 'RA1'),
  ('ZQ7NOL', 'VA2'),
  ('QB0TP9', 'VA1'),
  ('Q7STQD', 'TA3'),
  ('PGFMCK', 'TA2'),
  ('P4QH1W', 'RA4'),
  ('MG3061', 'VA'),
  ('M4Y1O9', 'RA5'),
  ('L6MO5G', 'UA4'),
  ('K31IU4', 'TA01'),
  ('JTR94E', 'A51'),
  ('JEV1NU', 'SA3'),
  ('H80KJL', 'A53'),
  ('H0MK50', 'QA6'),
  ('GPBI3Z', 'SA2'),
  ('FGWKV6', 'UA5'),
  ('0CWI00', 'SA'),
  ('DJN7N5', 'UA41'),
  ('DC4K5T', 'UA3'),
  ('A209G4', 'A55'),
  ('9DEB5X', 'A00'),
  ('912Q7N', 'SA3'),
  ('7PS1RP', 'RA2'),
  ('70CY8G', 'QA5'),
  ('5MTOEB', 'RA3'),
  ('5H8MKX', 'TA1'),
  ('56IK8G', 'A52'),
  ('4BCSOZ', 'UA6'),
  ('422Z7M', 'SA31'),
  ('0ZIRBV', 'UA')
) AS tmp(ufficio, settore)
JOIN cpass_t_ufficio dr ON dr.ufficio_codice = tmp.ufficio
JOIN cpass_t_settore dm ON dm.settore_codice = tmp.settore
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_r_ufficio_settore rrm
	WHERE rrm.ufficio_id = dr.ufficio_id
	AND rrm.settore_id = dm.settore_id
);

--
delete from cpass_r_utente_rup_settore;

INSERT INTO cpass.cpass_r_utente_rup_settore (utente_id,settore_id,data_validita_inizio,data_validita_fine)
SELECT tu.utente_id, ts.settore_id, to_date('01/01/2020', 'DD/MM/YYYY'), null
FROM (VALUES
  ('AAAAAA00A11B000J', 'A00', '01907990012')
) AS tmp(utente_codice_fiscale, settore_codice, ente_codice_fiscale)
JOIN cpass.cpass_t_utente tu ON (tu.utente_codice_fiscale = tmp.utente_codice_fiscale)
JOIN cpass.cpass_t_ente te ON (te.ente_codice_fiscale = tmp.ente_codice_fiscale)
JOIN cpass.cpass_t_settore ts ON (ts.settore_codice = tmp.settore_codice AND ts.ente_id = te.ente_id)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_r_utente_rup_settore rus
  WHERE rus.utente_id = tu.utente_id
  AND rus.settore_id = ts.settore_id
);


INSERT INTO cpass.cpass_r_utente_settore (utente_id, settore_id)
SELECT tu.utente_id, ts.settore_id
FROM (VALUES
  ('AAAAAA00A11B000J', 'A00', 'AAAAAA00A11B000J')
) AS tmp(utente, settore, rup)
JOIN cpass.cpass_t_utente tu ON tu.utente_codice_fiscale = tmp.utente
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_r_utente_settore rus
  WHERE rus.utente_id = tu.utente_id
  AND rus.settore_id = ts.settore_id
);
----------------------------------------------------------------------------------------------------------------------

delete from cpass.cpass_r_ruolo_utente_settore;

INSERT INTO cpass.cpass_r_ruolo_utente_settore (utente_settore_id, ruolo_id)
SELECT rus.utente_settore_id, dr.ruolo_id
FROM (VALUES
	('AAAAAA00A11B000J','A00','ADMIN')
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


INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
    ('NUMERAZIONE_ATTI_UNIVOCA', 'true', 'IMPEGNO', 'SIAC', 'Per interrogazione IMPEGNO', true,'CMTO')
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
-----------------------------------------------------------------------------------------------------------------------

SELECT pg_catalog.setval('cpass.cpass_t_parametro_parametro_id_seq', 139, true);
SELECT pg_catalog.setval('cpass.cpass_t_ufficio_ufficio_id_seq', 30, true);




INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, 
settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica, data_creazione, data_cancellazione)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, 
ts1.settore_id, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM', tmp.data_inizio, tmp.data_fine
FROM (VALUES
        ('AA','AREA RELAZIONI E COMUNICAZIONE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),        
        ('BA','AREA ISTITUZIONALE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),

        ('DA','AREA RISORSE UMANE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('EA','AREA RISORSE FINANZIARIE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FA','AREA PATRIMONIO E SERVIZI INTERNI','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE','AREA LAVORI PUBBLICI','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('IA','AREA TERRITORIO, TRASPORTI E PROTEZIONE CIVILE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        
        ('LB','AREA SVILUPPO SOSTENIBILE E PIANIFICAZIONE AMBIENTALE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('LC','AREA RISORSE IDRICHE E QUALITA'' DELL''ARIA','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03 ','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('MD','AREA ATTIVITA'' PRODUTTIVE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-3','YYYY-MM-DD')),

        ('ND','AREA NON DEFINITA','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-3','YYYY-MM-DD')),
        ('QA42','QA42','SE','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-3','YYYY-MM-DD')),
        ('SA2','SA2','SE','SA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD'))
        
)AS tmp (codice, descrizione,tipo,codice_padre,ente,data_inizio,data_fine)
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



INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, 
settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica, data_creazione, data_cancellazione)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, 
ts1.settore_id, 
te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM', tmp.data_inizio, tmp.data_fine
FROM (VALUES
        ('AA7','COMUNICAZIONE ISTITUZIONALE, INFORMAZIONE E RELAZIONI INTERNE ED ESTERNE','SE','AA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('AAA','RELAZIONI E PROGETTI EUROPEI E INTERNAZIONALI','SE','AA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('BA2','PRESIDENTE E GIUNTA','SE','BA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-3','YYYY-MM-DD')),
        ('BA3','STAFF AL SEGRETARIO GENERALE E DOCUMENTAZIONE','SE','BA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('DA3','SVILUPPO RISORSE UMANE','SE','DA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('DA6','ACQUISIZIONE E GESTIONE RISORSE UMANE, SERVIZI SOCIALI AI DIPENDENTI','SE','DA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('EA3','FINANZE, TRIBUTI E STATISTICA','SE','EA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('EA4','ECONOMATO E LIQUIDITA''','SE','EA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FA3','LOGISTICA','SE','FA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FA5','PATRIMONIO','SE','FA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FAB','SERVIZI GENERALI','SE','FA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FAC','CQUISTI E PROVVEDITORATO','SE','FA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE0','DIREZIONE AREA LAVORI PUBBLICI','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE2','CONCESSIONI E APPROVVIGIONAMENTI','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE3','IMPIANTI TECONOLOGICI E GESTIONE ENERGIA','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE4','EDILIZIA SCOLASTICA 1','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE5','EDILIZIA SCOLASTICA 2','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE7','VIABILITA'' 1','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE8','VIABILITA'' 2','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03 ','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE9','VIABILITA'' 3','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('IA8','TRASPORTI','SE','IA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('IAG','PIANIFICAZIONE E GESTIONE RETE ECOLOGICA E AREE PROTETTE, VIGILANZA AMBIENTALE','SE','IA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-3','YYYY-MM-DD')),
        ('LB7','PINAIFICAZIONE E GESTIONE RIFIUTI, BONIFICHE, SOSTENIBILITA'' AMBIENTALE','SE','LB','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('LC6','DIFESA DEL SUOLO E ATTIVITA'' ESTRATTIVA','SE','LB','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('MD3','PROGRAMMAZIONE ATTIVITA'' PRODUTTIVE E CONCERTAZIONE TERRITORIALE','SE','MD','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('MD4','AGRICOLTURA','SE','MD','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('MD7','TUTELA DELLA FAUNA E DELLA FLORA','SE','MD','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('1241','1241','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('A12','A12','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('BA6','BA6','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HC0','HC0','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HC4','HC4','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HC5','HC5','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HC6','HC6','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HC7','HC7','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HC8','HC8','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HCA','HCA','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HCB','HCB','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HD5','HD5','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HD8','HD8','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('IAA','IAA','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('LB2','LB2','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('LB3','LB3','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD'))
)AS tmp(codice, descrizione,tipo,codice_padre,ente,data_inizio,data_fine)
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


INSERT INTO cpass.cpass_t_provvedimento (provvedimento_anno,provvedimento_numero,
provvedimento_oggetto,provvedimento_tipo_id,
ente_id,settore_id,data_creazione,data_modifica,data_validita_inizio)
SELECT tmp.anno,tmp.numero,tmp.oggetto,t.provvedimento_tipo_id,
EN.ente_id,ts.settore_id,tmp.data_creazione,tmp.data_modifica,tmp.data_validita_inizio
FROM (VALUES
(2019,651,'EDIFICI SCOLASTICI ED EDIFICI PATRIMONIALI VARI. VERIFICHE PERIO- DICHE BIENNALI SUGLI IMPIANTI ASCENSORI E MONTACARICHI. AFFIDA- MENTO ALLA SOCIETA'' INSPECTA S.R.L.  -  CIG Z3426AA477 (U.I. EURO 17.513,10)','32','CMTO','UA5',to_timestamp('11/01/2019','dd/MM/yyyy'), to_timestamp('11/01/2019','dd/MM/yyyy'), to_timestamp('01/02/2019','dd/MM/yyyy')), 
(2019,1465,'SITO EX IL CAT, BORGARO T.SE. APPROVAZIONE E AFFIDAMENTO SERVIZIO DI MONITORAGGIO E PROVE BIOGAS ALLA SOCIETA'' ENVIARS S.R.L. (CIG Z26270BD85)  (U.I. EURO 21.472,00=)','32','CMTO','UA3',to_timestamp('06/02/2019','dd/MM/yyyy'), to_timestamp('11/06/2019','dd/MM/yyyy'), to_timestamp('25/03/2019','dd/MM/yyyy')), 
(2017,1845,'INDENNITA'' DI PRESENZA AI COMPNENTI DELLE COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/2002 E DALLA D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/05/2004. PRIMO IMPEGNO DI SPESA PER COMMISSIONI ANNO 2017. ACCERTAMENTO DALLE PROVINCE PER ESAMI. (U./PR. EURO 2.514,55- E./A. EURO 4.739,83)','32','CMTO','IA8',to_timestamp('15/02/2017','dd/MM/yyyy'), to_timestamp('26/02/2019','dd/MM/yyyy'), to_timestamp('20/03/2017','dd/MM/yyyy')), 
(2019,1888,'NOLEGGIO FOTOCOPIATORI OLIVETTI D-COPIA 5000MF - CONSIP 26 LOTTO 3 - PRODUTTIVITA'' MEDIA - CIG DERIVATO 725470866D. RETTIFICA PER ERRORE MATERIALE.','32','CMTO','RA3',to_timestamp('19/02/2019','dd/MM/yyyy'), to_timestamp('03/07/2019','dd/MM/yyyy'), to_timestamp('07/03/2019','dd/MM/yyyy')), 
(2019,2039,'SERVIZI FINALIZZATI ALLE RIPARAZIONI DECENTRATE DI MEZZI MECCANI CI ED ATTREZZATURE COMPRESE REVISIONI VARIE. AUTORIZZAZIONE E PRENOTAZIONE DI SPESA PER L''ANNO 2019. ( U.PR. EURO 15.000,00 )','32','CMTO','UA3',to_timestamp('22/02/2019','dd/MM/yyyy'), to_timestamp('21/06/2019','dd/MM/yyyy'), to_timestamp('11/03/2019','dd/MM/yyyy')), 
(2019,2141,'RDO 2105060 SUL MEPA - SERVIZI DI COMUNICAZIONE DEL PIANO  INTEGRATO TERRITORIALE GRAIES LAB PER IL PERIODO 2019-2022 CIG. ZB92583AEC - CUP J19F18000830005. AGGIUDICAZIONE DEFINITIVA  A LIGURIA DIGITALE SPA. (U.S. ANNI 2019-2022 EURO 38.552,00=)','32','CMTO','QA5',to_timestamp('26/02/2019','dd/MM/yyyy'), to_timestamp('08/11/2019','dd/MM/yyyy'), to_timestamp('06/03/2019','dd/MM/yyyy')), 
(2019,2142,'RDO 2106556 SUL MEPA - SERVIZI DI COMUNICAZIONE DEL PIANO  INTEGRATO TERRITORIALE LE ALTE VALLI - CUORE DELLE ALPI PER IL  PERIODO 2019-2022. CIG Z292586096 - CUP J19F18000840005. AGGIUDICAZIONE DEFINITIVA A LIGURIA DIGITALE SPA. (U.S. ANNI 2019-2022 EURO 38.942,40=)','32','CMTO','QA5',to_timestamp('26/02/2019','dd/MM/yyyy'), to_timestamp('18/11/2019','dd/MM/yyyy'), to_timestamp('06/03/2019','dd/MM/yyyy')), 
(2019,2143,'RDO 2106980 SUL MEPA - SERVIZI DI COMUNICAZIONE SOCIAL DEL PIANO  INTEGRATO TERRITORIALE LE ALTE VALLI - CUORE DELLE ALPI PER IL  PERIODO 2019-2022. CIG Z1B2586894 - CUP J19F18000840005. AGGIUDICAZIONE DEFINITIVA A LIGURIA DIGITALE SPA. (U.S. ANNI 2019-2022 EURO 21.276,80=)','32','CMTO','QA5',to_timestamp('26/02/2019','dd/MM/yyyy'), to_timestamp('25/11/2019','dd/MM/yyyy'), to_timestamp('06/03/2019','dd/MM/yyyy')), 
(2019,2245,'EDIFICI SCOLASTICI DELLA ZONA A. INTERVENTI DI MANUTENZIONE ORDI- NARIA DEGLI IMPIANTI ELETTRICI. AFFIDAMENTO LAVORI IN ECONOMIA A  SAMET S.R.L.  - CIG ZAE276FA1A (U.I. EURO 48459,96 - U.PR. EURO 794,43)','32','CMTO','UA5',to_timestamp('28/02/2019','dd/MM/yyyy'), to_timestamp('28/02/2019','dd/MM/yyyy'), to_timestamp('12/03/2019','dd/MM/yyyy')), 
(2019,2336,'PIANO TERRITORIALE INTEGRATO GRAIES LAB. PROCEDURA NEGOZIATA  TELEMATICA TRAMITE R.D.O. SUL MEPA. APPROVAZIONE CAPITOLATO  D''ONERI PER L''AFFIDAMENTO DEL SERVIZIO DI ASSISTENZA TECNICA PER  IL PERIODO 2019-2022. (E.A. 2019-2022 EURO 45.140,00= U.PR. 2019-2022 EURO 45.140,00=)','32','CMTO','QA5',to_timestamp('04/03/2019','dd/MM/yyyy'), to_timestamp('29/11/2019','dd/MM/yyyy'), to_timestamp('12/03/2019','dd/MM/yyyy')), 
(2019,2356,'EDIFICI SCOLASTICI DELLA ZONA B. INTERVENTI DI MANUTENZIONE  ORDINARIA DEGLI IMPIANTI ELETTRICI. AFFIDAMENTO LAVORI IN ECONO- MIA A SAMET S.R.L.   - CIG Z30276FA75 (U.I. EURO 48.339,94 - U/PR EURO 792,46)','32','CMTO','UA5',to_timestamp('04/03/2019','dd/MM/yyyy'), to_timestamp('04/03/2019','dd/MM/yyyy'), to_timestamp('12/03/2019','dd/MM/yyyy')), 
(2019,2402,'PROGETTO ALCOTRA 2014-2020 PITER COEUR''ALP PROGETTO N. 3926  COEUR SOLIDAIRE SERVIZI DI SUPPORTO PER L''ATTIVITA'' DI COORDINA MENTO GESTIONE E ANIMAZIONE DEL PROGETTO AUTORIZZAZIONE ALL''INDI ZIONE DI UNA PROCEDURA NEGOZIATA SU MEPA E PRENOTAZIONE IMPEGNO CUP N. J79F1800093007 CIG. N. ZCD273448A E/A-U/PR= EURO 35.014,00','32','CMTO','SA3',to_timestamp('06/03/2019','dd/MM/yyyy'), to_timestamp('14/10/2019','dd/MM/yyyy'), to_timestamp('25/03/2019','dd/MM/yyyy')), 
(2019,2403,'CONVENZIONE 2016-2020 PER LA GESTIONE DEL SERVIZIO DI TESORERIA DELLA CITTA'' METROPOLITANA DI TORINO.  IMPUTAZIONE ONERI DI TESORERIA ANNO 2019. CIG. 6600893D36 (U.PR. EURO 8.540,00.=) ( U.PR. EURO 91.460,00=)','32','CMTO','QA3',to_timestamp('06/03/2019','dd/MM/yyyy'), to_timestamp('08/04/2019','dd/MM/yyyy'), to_timestamp('13/03/2019','dd/MM/yyyy')), 
(2019,2724,'SERVIZIO DI GESTIONE MANUTENTIVA DEGLI IMPIANTI ASCENSORI PRESSO  EDIFICI SEDI DI UFFICI DI COMPETENZA PER IL PERIODO 2? SEMESTRE  2018 - 1? SEMESTRE 2022. INTEGRAZIONE DI IMPEGNI PER L''ANNO 2021. (U.I EURO 23.342,72 - U.PR.  EURO 814,40)','32','CMTO','UA5',to_timestamp('13/03/2019','dd/MM/yyyy'), to_timestamp('13/03/2019','dd/MM/yyyy'), to_timestamp('01/04/2019','dd/MM/yyyy')), 
(2019,2800,'SERVIZIO DI MANUTENZIONE DELL''UTENZA DI ACCESSO ALLA PIATTAFORMA WEB MT-X DI MONTE TITOLI S.P.A. PER L''ANNO 2019. CIG N. Z13276BF77. (U.I. - EURO 103,70)','32','CMTO','QA3',to_timestamp('14/03/2019','dd/MM/yyyy'), to_timestamp('12/12/2019','dd/MM/yyyy'), to_timestamp('21/03/2019','dd/MM/yyyy')), 
(2019,2975,'EDIFICI DI EDILIZA GENERALE.. INTERVENTI DI MANUTENZIONE  ORDINARIA DEGLI IMPIANTI ELETTRICI . AFFIDAMENTO LAVORI IN  ECONOMIA A TIELLE IMPIANTI S.R.L. - CIG Z6D279FCE1 (U.I. EURO 46.414,90 - U./PR. 760,90','32','CMTO','UA5',to_timestamp('19/03/2019','dd/MM/yyyy'), to_timestamp('19/03/2019','dd/MM/yyyy'), to_timestamp('01/04/2019','dd/MM/yyyy')), 
(2018,3199,'SERVIZIO ENERGETICO DEGLI EDIFICI DI PROPRIETA'' E DI COMPETENZA DELLA CITTA'' METROPOLITANA. RIDUZIONE E REIMPUTAZIONE IMPEGNI DI  SPESA.  (U.I.  EURO 29.713.404,60)','32','CMTO','HE3',to_timestamp('02/02/2018','dd/MM/yyyy'), to_timestamp('13/09/2018','dd/MM/yyyy'), to_timestamp('15/05/2018','dd/MM/yyyy')), 
(2018,3226,'NOLEGGIO FOTOCOPIATORI OLIVETTI 5000MF PRODUTTIVITA'' MEDIA - CONSIP 26 LOTTO 3 - IMPEGNI ANNO 2020. CIG DERIVATO 725470866D. (U.I. EURO 40.992,00).','32','CMTO','FAC',to_timestamp('05/02/2018','dd/MM/yyyy'), to_timestamp('21/10/2016','dd/MM/yyyy'), to_timestamp('24/08/2018','dd/MM/yyyy')), 
(2018,3229,'NOLEGGIO FOTOCOPIATORI OLIVETTI 5000MF PRODUTTIVITA'' BASSA CONSIP 26 LOTTO 3 - IMPEGNI ANNO 2020. CIG DERIVATO 7254788871. (U.I. EURO 5.709,96).','32','CMTO','FAC',to_timestamp('05/02/2018','dd/MM/yyyy'), to_timestamp('05/12/2016','dd/MM/yyyy'), to_timestamp('16/05/2018','dd/MM/yyyy')), 
(2018,3230,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/202 E DALLA  D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/05/2004. PRIMO IMPEGNO DI SPESA PER COMMISSIONI ANNO 2018. ACCERTAMENTO DALLE PROVINCE E VAL D''AOSTA PER ESAMI. (E./A. EURO 4.118,97-U./PR. EURO 3.963,58)','32','CMTO','IA8',to_timestamp('05/02/2018','dd/MM/yyyy'), to_timestamp('04/03/2019','dd/MM/yyyy'), to_timestamp('14/03/2018','dd/MM/yyyy')), 
(2019,3471,'SERVIZI DI PULIZIA E IGIENE AMBIENTALE AFFIDATI A MANITAL SOCIETA CONSORTILE PER I SERVIZI INTEGRATI. PROROGA TECNICA PER IL  PERIODO APRILE 2019 - MAGGIO 2019. CIG DERIVATO 348422054C U.I. EURO 92.054,25 - U. PR. EURO 6.880,00','32','CMTO','RA3',to_timestamp('27/03/2019','dd/MM/yyyy'), to_timestamp('24/07/2019','dd/MM/yyyy'), to_timestamp('29/03/2019','dd/MM/yyyy')), 
(2019,3894,'SERVIZIO MANUTENZIONE PARCHI, RISERVE NATURALI E SITI RETE NATURA 2000 (Z.S.C.) ZONA NORD DEL TERRITORIO CITTA'' METROPOLITANA. AF- FIDAMENTO ALLA DITTA HORTILUS E VIVAI S.R.L. DI COLLERETTO GIACO- SA (TO). IMPEGNO DI SPESA PER L''ANNO 2019. (CIG Z1E257E6FC) (U.I. EURO 35.815,45)','32','CMTO','TA3',to_timestamp('05/04/2019','dd/MM/yyyy'), to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('03/05/2019','dd/MM/yyyy')), 
(2019,3904,'PIANO INTEGRATO TERRITORIALE ALCOTRA GRAIES LAB - SERVIZIO DI SUPPORTO ALLA GESTIONE FINANZIARIA. AFFIDAMENTO PREVIA TRATTATIVA DIRETTA MEPA - CUP. J19F18000830005 - CIG. Z5627DD6EA  (E.A./U.I. ANNI 2019-2022 EURO 12.180,48=)','32','CMTO','QA5',to_timestamp('05/04/2019','dd/MM/yyyy'), to_timestamp('29/11/2019','dd/MM/yyyy'), to_timestamp('23/04/2019','dd/MM/yyyy')), 
(2019,3931,'PROGETTAZIONE INTERVENTI RELATIVI AL PRIMO PROGRAMMA OPERATIVO  DEL PIANO DI GESTIONE SEDIMENTI DEL TORRENTE ORCO-COMUNI VARI. ACCERTAMENTO ED IMPEGNO FONDI. APPROVAZIONE CONTRATTO DI RICERCA TRA C.M. E POLITECNICO DI TORINO-DIATI PER ATTIVITA'' DI SUPPORTO  CUP J76C18000260002-CIG 7869513F8D (EA-UI-PR EURO 232.500,00)','32','CMTO','RA5',to_timestamp('08/04/2019','dd/MM/yyyy'), to_timestamp('04/06/2019','dd/MM/yyyy'), to_timestamp('15/04/2019','dd/MM/yyyy')), 
(2019,4018,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO MEZZI OPERATIVI PER LA  M.O.  DELLE SP DI COMPETENZA DEL SERVIZIO VIABILITA'' 3. LOTTO 1 E LOTTO 2 PROCEDURA APERTA. APPROV. OPERAZ.DI GARA E AGGIUDICAZIONE DEFINITIVA A MILANO LUCA. (CIG LOTTO 1 7627715D88-CIG LOTTO 2  7627722352) (U.S. EURO 183.000,00)','32','CMTO','UA3',to_timestamp('09/04/2019','dd/MM/yyyy'), to_timestamp('01/07/2019','dd/MM/yyyy'), to_timestamp('22/07/2019','dd/MM/yyyy')), 
(2019,4296,'PIANO INTERVENTO TRIENNALE RAPPEZZATURA DELLA PAV. STRADALE PER MO DELLE SP DI COMPETENZA DEL S. VIABILITA'' 1. PROC. APERTA APPROVAZ. OPERAZIONI GARA E AGG. DEFINITIVA LOTTO 1 A SELVA MERCU RIO(CIG 76451587F5)-LOTTO2 A CITRINITI G. MASSIMO(CIG 76451777A3) LOTTO3 A CITRINITI G. M.(CIG 764519025F)US 585600,00-UI 73200,00','32','CMTO','UA3',to_timestamp('16/04/2019','dd/MM/yyyy'), to_timestamp('27/09/2019','dd/MM/yyyy'), to_timestamp('10/05/2019','dd/MM/yyyy')), 
(2019,4348,'PIANO DI INTERV.TRIENNALE DI MANUT.ORDINARIA DI MODESTA ENTITA'' DELLE SP DI COMPETENZA DEL SERVIZIO VIABILITA''1.LOTTO2-UO2-ZONA  OMOGENEA 11 PARTE DELLA ZONA OMOGENEA 3(AMT SUD).PROCEDURA APERTA APPROVAZ.OPERAZIONI DI GARA E AGGIUDICAZ DEFVA A  BUA COSTRUZIONI (PR 3585/18 CIG7639721136) (US EURO 234.240,00 UI EURO 29.280,00)','32','CMTO','UA3',to_timestamp('17/04/2019','dd/MM/yyyy'), to_timestamp('01/10/2019','dd/MM/yyyy'), to_timestamp('28/05/2019','dd/MM/yyyy')), 
(2019,4381,'PROGETTO ALCOTRA 2014-2020 PITER COEUR''ALP PROGETTO N. 3926  COEUR SOLIDAIRE. SERVIZI DI SUPPORTO PER L''ATTIVITA'' DI COORDI- NAMENTO, GESTIONE E ANIMAZIONE DEL PROGETTO. AFFIDAMENTO ALLA  DITTA QUESITE SRL VIA SANTA BARBARA 57 - BAGNOLO P.TE (CN) CIG ZCD273448A CUP J79F18000930007 U/S= EURO 27.836,13','32','CMTO','SA3',to_timestamp('17/04/2019','dd/MM/yyyy'), to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('09/05/2019','dd/MM/yyyy')), 
(2015,4968,'COMMISSIONE PROVINCIALE ESPROPRI - GETTONE DI PRESENZA DEI COMPO- NENTI.  COSTITUZIONE FONDO ECONOMALE PER L''ANNO 2015. (U/PR/2015 EURO 2.464,75 - U/PR/2015 IRAP 114,75)','32','CMTO','BA2',to_timestamp('19/02/2015','dd/MM/yyyy'), to_timestamp('18/03/2015','dd/MM/yyyy'), to_timestamp('14/09/2015','dd/MM/yyyy')), 
(2016,5154,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/2002 E DALLA  D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/05/2004. IMPEGNO DI  SPESA PER LE COMMISSIONI ANNO 2016. ACCERTAMENTO DALLA PROVINCE PER ESAMI (U./PR. EURO 7.629,93- E./A. EURO 7.650,97)','32','CMTO','IA8',to_timestamp('16/02/2016','dd/MM/yyyy'), to_timestamp('26/02/2019','dd/MM/yyyy'), to_timestamp('08/03/2016','dd/MM/yyyy')), 
(2019,5249,'SERVIZIO DI PULIZIA E IGIENE AMBIENTALE NEGLI EDIFICI SEDI DI 3 UFFICI DELL''ENTE PER UN PERIODO DI 36 MESI MEDIANTE SISTEMA  DINAMICO DI ACQUISIZIONE (SDAPA) - APPALTO SPECIFICO 1888297  CIG  7466043596 U.I. - U.S. EURO 915988,37','32','CMTO','RA3',to_timestamp('14/05/2019','dd/MM/yyyy'), to_timestamp('07/10/2019','dd/MM/yyyy'), to_timestamp('16/05/2019','dd/MM/yyyy')), 
(2019,5697,'VERIFICHE PERIODICHE DEGLI IMPIANTI DI MESSA A TERRA E PROTEZIONE SCARICHE ATMOSFERICHE EX D.P.R. 462/2001 PRESSO EDIFICI SCOLASTI CI DI COMPETENZA. AFFIDAMENTO DIRETTO A INSPECTA S.R.L.  (U.I. EURO 5.490,00) CIG  ZBB2887586','32','CMTO','UA5',to_timestamp('23/05/2019','dd/MM/yyyy'), to_timestamp('23/05/2019','dd/MM/yyyy'), to_timestamp('28/05/2019','dd/MM/yyyy')), 
(2019,5709,'AACORDO QUADRO PER LA GESTIONE DEL SERVIZIO DI PULIZIE  STRAORDINARIE, DISINFESTAZIONE, DERATTIZZAZIONE A BASSO IMPATTO  AMBIENTALE NEGLI EDIFICI SCOLASTICI DELLA CITTA'' METROPOLITANA DI TORINO. RDO 2016897. CIG 7572827E85 U.I. 63.646,00','32','CMTO','RA3',to_timestamp('23/05/2019','dd/MM/yyyy'), to_timestamp('07/10/2019','dd/MM/yyyy'), to_timestamp('28/05/2019','dd/MM/yyyy')), 
(2017,5763,'AFFIDAMENTO PER IL SERVIZIO DI ATTIVAZIONE/MODIFICA DI ALLACCIA- MENTO IDRICO IN COMUNE DI VIGONE, VIA TORINO 26 (PUNTO DI  RAGGRUPPAMENTO DEL CIRCOLO DI VIGONE) CIG Z3A1E2138C (U.I. EURO 297,00)','32','CMTO','HE8',to_timestamp('05/04/2017','dd/MM/yyyy'), to_timestamp('16/05/2017','dd/MM/yyyy'), to_timestamp('20/04/2017','dd/MM/yyyy')), 
(2019,5841,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO MEZZI OPERATIVI PER LA  MANUTENZIONE ORDINARIA DELLE SP DI COMPETENZA DEL SERVIZIO VIAB.3 PROCEDURA APERTA-APPROVAZIONE OPERAZIONI DI GARA E AGGIUDICAZIONE LOTTO 3(CIG 7627731ABD) E LOTTO 4(CIG 762773915A) A AIMO BOOT SRL (U.S. 122.000,00 - U.I. 61.000,00 - U.PR. 63.000,00)','32','CMTO','UA3',to_timestamp('27/05/2019','dd/MM/yyyy'), to_timestamp('15/10/2019','dd/MM/yyyy'), to_timestamp('05/06/2019','dd/MM/yyyy')), 
(2019,5956,'PIANO DI INTERV.TRIENNALE DI MANUT.ORD. DI MODESTA ENTITA'' DELLE  SP DI COMPETENZA DEL SERV.VIABILITA''1.LOTTO1-UO1 ZONA OMOGENEA 10 (CHIVASSESE),PARTE DELLA ZONA OMOG 4(AMT NORD).PROCEDURA APERTA APPROVAZ OPERAZ.DI GARA E AGGIUDICAZ DEFINITIVA A CO.E.STRA SRL (PR.3585/2018 CIG 76397118F3)(U.S EURO 234.240,00 UI E 29.280,00)','32','CMTO','UA3',to_timestamp('29/05/2019','dd/MM/yyyy'), to_timestamp('23/10/2019','dd/MM/yyyy'), to_timestamp('03/06/2019','dd/MM/yyyy')), 
(2019,6144,'PIANO DI INTERV.TRIENNALE DI MANUT.ORD.DI MODESTA ENTITA'' DELLE  SP DI COMPETENZA DEL SERVIZIO VIABILITA'' 1.LOTTO3.UO3 ZONA  OMOGENEA2PARTE DELLA ZONA OMOGENEA3 E 4.PROCEDURA APERTA.APPROVAZ OPERAZ.DI GARA E AGGIUDICAZ.DEFINIVA A BUILDING&DESIGN2008 SRL. (PR.3585/18 CIG 7639865809).(US EURO234.240,00 UI EURO 29.280,00)','32','CMTO','UA3',to_timestamp('04/06/2019','dd/MM/yyyy'), to_timestamp('24/10/2019','dd/MM/yyyy'), to_timestamp('17/06/2019','dd/MM/yyyy')), 
(2019,6195,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO A CALDO DI MEZZI OPERAT PER LA MANUTENZ. ORD. DELLE SP DI COMPETENZA DEL SERV. VIAB. 2 - PROCED. APERTA APPROV. OPERAZIONI DI GARA E AGGIUDICAZIONE DEFIN. LOTTO 1 (CIG77912517B7) E LOTTO 2 (CIG 77912685BF) ALLA DITTA PASCHETTO SNC DI PASCHETTO ROBERTO. (U.S. EURO 183.000,00)','32','CMTO','UA4',to_timestamp('04/06/2019','dd/MM/yyyy'), to_timestamp('04/06/2019','dd/MM/yyyy'), to_timestamp('17/06/2019','dd/MM/yyyy')), 
(2019,6299,'RDO 2248060 - SERVIZIO DI ASSISTENZA TECNICA PER IL SUPPORTO AL COORDINAMENTO DEL PIANO INTEGRATO TERRITORIALE GRAIESLAB PER IL PERIODO 2019-2022. AFFIDAMENTO ALLA DITTA QUESITE S.R.L.  CUP N. J19F18000830005 - CIG N. ZC9278C756 (U.I.  ANNI 2019-2022 EURO 36.112,00=)','32','CMTO','QA5',to_timestamp('06/06/2019','dd/MM/yyyy'), to_timestamp('31/07/2019','dd/MM/yyyy'), to_timestamp('21/06/2019','dd/MM/yyyy')), 
(2019,6511,'INTERVENTI URGENTI DI MESSA IN SICUREZZA DEGLI IMPIANTI ELETTRICI PRESSO EDIFICI SCOLASTICI. AFFIDAMENTO LAVORI ALLA DITTA SAMET  S.R.L.  - C.I.G. ZC828BF541 (U.I. EURO 46.213,60 U./PR. EURO 757,60)','32','CMTO','UA5',to_timestamp('11/06/2019','dd/MM/yyyy'), to_timestamp('11/06/2019','dd/MM/yyyy'), to_timestamp('25/06/2019','dd/MM/yyyy')), 
(2019,6654,'CONVENZIONE CON IL CONS. INTERCOMUNALE SERVIZI SOCIALI PINEROLO  PER LA REALIZZAZIONE DI ATTIVITA'' D''INTERESSE COMUNE NELL''AMBITO  DEL PROGETTO ALCOTRA PITER N 3926 COEUR SOLIDAIRE RELATIVAMENTE ALLA PROGETTAZIONE ED EROGAZIONE DI SERVIZI SPERIMENTALI E DIVUL- GAZIONE DIRITTI E SERVIZI ESISTENTI  E/A-U/I= EURO 125.000,00','32','CMTO','SA3',to_timestamp('14/06/2019','dd/MM/yyyy'), to_timestamp('29/10/2019','dd/MM/yyyy'), to_timestamp('05/08/2019','dd/MM/yyyy')), 
(2019,6655,'CONVENZIONE CON IL CONS. INTERCOMUNALE SOCIO ASSISTENZIALE SUSA   PER LA REALIZZAZIONE DI ATTIVITA'' D''INTERESSE COMUNE NELL''AMBITO  DEL PROGETTO ALCOTRA PITER N 3926 COEUR SOLIDAIRE RELATIVAMENTE ALLA PROGETTAZIONE ED EROGAZIONE DI SERVIZI SPERIMENTALI  E/A-U/I= EURO 70.000,00','32','CMTO','SA3',to_timestamp('14/06/2019','dd/MM/yyyy'), to_timestamp('25/11/2019','dd/MM/yyyy'), to_timestamp('05/08/2019','dd/MM/yyyy')), 
(2019,6934,'INTERVENTI DI MANUTENZIONE DEGLI IMPIANTI ELEVATORI INSTALLATI  PRESSO GLI ISTITUTI SCOLASTICI DELLA CITTA'' METROPOLITANA DI TO RINO. AFFIDAMENTO ALL''IMPRESA CIOCCA S.R.L. CIG Z4828EE41C (U.I. EURO 48.611,39 -U./PR. 796,91)','32','CMTO','UA5',to_timestamp('21/06/2019','dd/MM/yyyy'), to_timestamp('21/06/2019','dd/MM/yyyy'), to_timestamp('01/07/2019','dd/MM/yyyy')), 
(2019,7077,'INCARICO DI COLLABORAZIONE COORDINATA E CONTINUATIVA DI ESPERTO  GIURISTA IN MATERIA DI GESTIONE PROCEDURE DI GARA ANCHE IN  QUALITA'' DI STAZIONE UNICA APPALTANTE E SOGGETTO AGGREGATORE E  CONSEGUENTI ADEMPIMENTI AL DOTT. DANILO CASSARA'' (U.I. EURO 12.838,70=)','32','CMTO','RA3',to_timestamp('27/06/2019','dd/MM/yyyy'), to_timestamp('24/01/2019','dd/MM/yyyy'), to_timestamp('28/06/2019','dd/MM/yyyy')), 
(2019,7123,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO A CALDO DI MEZZI OPERAT PER LA MANUTENZ. ORD. DELLE SP DI COMPETENZA DEL SERV. VIAB. 2 -  PROCED. APERTA APPROV. OPERAZIONI DI GARA E AGGIUDICAZIONE DEFIN. LOTTO 3 (CIG 779128649A) ALLA CARELLO & COGERINO SNC.  (U.I. EURO 91.500,00)','32','CMTO','UA4',to_timestamp('27/06/2019','dd/MM/yyyy'), to_timestamp('27/06/2019','dd/MM/yyyy'), to_timestamp('12/07/2019','dd/MM/yyyy')), 
(2019,7197,'INTERVENTI DI MANUTENZIONE ORDINARIA E RIPARATIVA PRESSO GLI  EDIFICI SEDI DI UFFICI DELLA CITTA'' METROPOLITANA DI TORINO -  PERIODO 2019-2020-2021. RIMODULAZIONE Q.E. E INDIVIDUAZIONE MOD. DI AFFIDAMNETO MEDIANTE PROCEDURA APERTA. (PROG. 3420/18 - CUP J15H18000030003) (U.PR. EURO 63.055,19 - ECO. EURO 684,73)','32','CMTO','UA5',to_timestamp('01/07/2019','dd/MM/yyyy'), to_timestamp('01/07/2019','dd/MM/yyyy'), to_timestamp('11/07/2019','dd/MM/yyyy')), 
(2015,7528,'SERVIZIO DI MANUTENZIONE DELL''UTENZA DI ACCESSO ALLA PIATTAFORMA WEB MT-X DI MONTE TITOLI S.P.A. PER L''ANNO 2015. CIG N? Z1E074B41B. (U.I.  EURO 103,70)','32','CMTO','EA3',to_timestamp('18/03/2015','dd/MM/yyyy'), to_timestamp('03/12/2018','dd/MM/yyyy'), to_timestamp('01/04/2015','dd/MM/yyyy')), 
(2019,7609,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA DI TORINO. AGGIUDICAZIONE LOTTO 3.06. RETTIFICA DD N. 119-2697/2019.  (U/I EURO 70.234,81=)','32','CMTO','UA3',to_timestamp('11/07/2019','dd/MM/yyyy'), to_timestamp('12/11/2019','dd/MM/yyyy'), to_timestamp('02/08/2019','dd/MM/yyyy')), 
(2019,7645,'INVESTIMENTI FINALIZZATI ALL''ATTUAZIONE DEL PIANO TRIENNALE PER L''INFORMATICA NELLA PUBBLICA AMMINISTRAZIONE FINANZIATI TRAMITE AVANZO. AFFIDAMENTO A CSI PIEMONTE (COD. CRED. 380) (U.I. EURO 226.580,30)','32','CMTO','QA1',to_timestamp('11/07/2019','dd/MM/yyyy'), to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('19/08/2019','dd/MM/yyyy')), 
(2019,7653,'INVESTIMENTI FINALIZZATI AL PROCESSO DI DEMATERIALIZZAZIONE DEGLI ATTI AMMINISTRATIVI IN ATTUAZIONE DEL DPCM 13/11/2014. AFFIDAMENTO A CSI PIEMONTE (COD. CRED. 380) (U.I. EURO 104.550,00)','32','CMTO','QA1',to_timestamp('12/07/2019','dd/MM/yyyy'), to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('26/07/2019','dd/MM/yyyy')), 
(2017,7667,'MESSA IN SICUREZZA DEL TERRITORIO. LOTTO 1: REALIZZAZ DI SCOLMA- TORE (BY PASS) DEL CANALE DI RITORNO DI NOLE ALLA CONFLUENZA CON  IL CANALE DI CIRIE'' PER LA REGOLAZIONE DELLE ACQUE METEORICHE.  INDIVIDUAZIONE MODALITA'' DI AFFIDAMENTO MEDIANTE PROCEDURA APERTA E REIMPUTAZIONE MOV. CONTABILI.','32','CMTO','LC6',to_timestamp('16/05/2017','dd/MM/yyyy'), to_timestamp('23/05/2019','dd/MM/yyyy'), to_timestamp('04/07/2017','dd/MM/yyyy')), 
(2017,7967,'PRESTAZIONI SANITARIE A CARICO DELLA CITTA'' METROPOLITANA DI  TORINO PER L''ANNO 2017. ULTERIORE PRENOTAZIONE DI SPESA. (U.PR. EURO 4.900,00)','32','CMTO','DA6',to_timestamp('23/05/2017','dd/MM/yyyy'), to_timestamp('14/05/2018','dd/MM/yyyy'), to_timestamp('09/10/2017','dd/MM/yyyy')), 
(2019,8008,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA DELLA CITTA? METROPOLITANA. STAGIONI 2019 -2020 E 2020 - 2021. LOTTI 2.20A - 2.20B -2.22. APPROVAZIONE PROGETTO E INDIVIDUAZIONE MODALITA'' DI GARA. (U. PR. 441.557,31)','32','CMTO','UA4',to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('08/08/2019','dd/MM/yyyy')), 
(2019,8015,'SERVIZIO DI VIGILANZA, SORVEGLIANZA ARMATA E DI PRESIDIO CONTROL  ROOM PRESSO GLI EDIFICI DELLA CITTA'' METROPOLITANA DI TORINO -  PERIODO 36 MESI. CIG 7526388BD9 - MODIFICA MOVIMENTI CONTABILI E  INTEGRAZIONE PER SERVIZI NON PREVISTI IN SEDE DI GARA. U.I. EURO 1.081,697,48','32','CMTO','RA3',to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('11/10/2019','dd/MM/yyyy'), to_timestamp('08/08/2019','dd/MM/yyyy')), 
(2019,8062,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO A CALDO DI MEZZI OPERAT PER LA MANUTENZIONE ORDIN. DELLE S.P. DI COMPETENZA DEL SERVIZIO  VIABILITA'' 1 - PROCEDURA APERTA - APPROVAZ. OPERAZIONI DI GARA E AGGIUDICAZIONE DEFINITIVA LOTTO 3 ALL''AZIENDA AGRICOLA BIGLIA CARLO (CIG 786291176B) (U.PR. EURO 117.120,00)','32','CMTO','UA3',to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('19/08/2019','dd/MM/yyyy')), 
(2019,8102,'PIANO DI INTERV. TRIENNALE DI NOLEGGIO A CALDO DI MEZZI OPERATIVI PER LA M.O. DELLE S.P DI COMPET. DEL SERV. VIABILITA'' 1-PROCEDURA APERTA. APPROVAZIONE OPERAZ. DI GARA E AGGIUDICAZIONE DEFINITIVA  LOTTO1 U.O.1-ZONA OM. 10 (CHIVASSESE), PARTE ZONA OM. 4 (AMT NORD (CIG 78628347E0) ALLA TORO COSTRUZIONI SRL (U.PR. 117.120,00)','32','CMTO','UA3',to_timestamp('23/07/2019','dd/MM/yyyy'), to_timestamp('12/12/2019','dd/MM/yyyy'), to_timestamp('08/08/2019','dd/MM/yyyy')), 
(2019,8455,'SERVIZIO DI COMPONENTE/PRESIDENTE DELLE COMMISSIONI TECNICHE  PARITETICHE DEL PIANO DI MONITORAGGIO E VERIFICA DELLE  PRESTAZIONI (PMVP) - TRATTATIVA DIRETTA SUL MEPA - I-TES SRL IN  PERSONA DEL DOTT. SANTOVITO. CIG Z1A2949F3D (E.A.-U.I. EURO 18.087,88)','32','CMTO','TA2',to_timestamp('31/07/2019','dd/MM/yyyy'), to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('26/09/2019','dd/MM/yyyy')), 
(2019,8632,'AFFIDAMENTO DIRETTO ALLA SOCIETA'' 5T S.R.L. PER LA PRESTAZIONE DEL SERVIZIO DI MONITORAGGIO, CONTROLLO E GESTIONE DEL TRAFFICO. ANNO 2019 (U.I. EURO 95160,00)','32','CMTO','UA3',to_timestamp('06/08/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('02/09/2019','dd/MM/yyyy')), 
(2019,8761,'PROGETTO ALCOTRA 201-2020 PITER COEUR''ALP PROGETTO N. 3926  COEUR SOLIDAIRE WP. 4.2.1 - SUPPORTO UFFICIO DI PROSSIMITA'' DI  PINEROLO - AFFIDAMENTO ALLA DITTA COESA PINEROLO SCSARL CUP J79F18000930007  CIG Z3528EAFED E/A- U/I = EURO 34.663,86','32','CMTO','SA3',to_timestamp('08/08/2019','dd/MM/yyyy'), to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('10/09/2019','dd/MM/yyyy')), 
(2019,9256,'PIANO DI INTERVENTO TRIENNALE DI MANUTENZIONE ORDINARIA DI MODEST A ENTITA'' DELLE STRADE PROVINCIALI DI COMPETENZA DEL SERVIZIO VIA 2-PROG. 3712/18. PROC. APERTA SINTEL(110930198) APPROVAZ. OPERAZ. E AGG. DEF LOTTO1(CIG791403651B)E LOTTO2(CIG7914080969) A GODINO  DI G R SRL.,LOTTO3(CIG 79141009EA)A EDILGAMMA SRL(UPR 658.800,00)','32','CMTO','UA4',to_timestamp('02/09/2019','dd/MM/yyyy'), to_timestamp('02/09/2019','dd/MM/yyyy'), to_timestamp('10/09/2019','dd/MM/yyyy')), 
(2019,9536,'PIANO DI INTERVENTO TRIENNALE DI RAPEZZATURA DELLA PAVIMENTAZIONE STRADALE PER LA MANUTENZ. ORD. DELLE S.P. DI COMPETENZA DEL SERV. VIABILITA'' 3-PROC. APERTA-APPROVAZ. OP. DI GARA E AGGIUDICAZ. PER LOTTO1 (CIG 7642195ACF) A SC EDIL DI P.R. SAS E PER LOTTO 2 (CIG  76422296DF) A AIMO BOOT SRL (PROG. 3608/18)(U.PR. 673.440,00)','32','CMTO','UA3',to_timestamp('10/09/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy'), to_timestamp('11/09/2019','dd/MM/yyyy')), 
(2019,9621,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO MEZZI OPERATIVI PER LA M.O. DELLE S.P. DI COMPETENZA DELLA DIR. COORD. VIAB.-VIABILITA 1 APPROVAZ. ELABORATI E AFFIDAMENTO SERVIZI COMPLEMENTARI ANALOGHI AI SENSI DELL''ART. 63 C. 5, D.LGS 50/2016 A TORO COSTRUZIONI SRL, MILANO LUCA, AIMO BOOT SRL. (U.PR. EURO 163.680,00)','32','CMTO','UA3',to_timestamp('11/09/2019','dd/MM/yyyy'), to_timestamp('29/10/2019','dd/MM/yyyy'), to_timestamp('27/09/2019','dd/MM/yyyy')), 
(2016,10065,'SP N 2 DI GERMAGNANO - INTERVENTO DI RIPRISTINO DELLE CONDIZIONI DI SICUREZZA DEL CAMMINAMENTO PROTETTO DAL KM 31+315 AL KM  31+370. AFFIDAMENTO ALL''IMPRESA GUGLIELMINO ING. GIOVANNI. (U.I. EURO 38.892,30 - ECO EURO 10.604,61)','32','CMTO','HE9',to_timestamp('11/04/2016','dd/MM/yyyy'), to_timestamp('27/02/2008','dd/MM/yyyy'), to_timestamp('27/05/2016','dd/MM/yyyy')), 
(2019,10078,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA. STAGIONI 2019-2020 E 2020-2021.  LOTTO 2.20B. APPROVAZIONE OPERAZIONI DI GARA E AGGIUDICAZIONE  DEFINITIVA ALL''OPERATORE ECONOMICO CHIABOTTO CARLO. (CIG 7988407200) (U.S. EURO 157.567,56 ECO EURO 78,06)','32','CMTO','UA4',to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('01/10/2019','dd/MM/yyyy')), 
(2019,10110,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA. STAGIONI 2019-2020 E 2020-2021.  LOTTO 2.22 APPROVAZIONE OPERAZIONI DI GARA E AGGIUDICAZIONE DEFI- NITIVA ALL''OPERATORE ECONOMICO AGRISERVICE S.A.S DI BIANCO DOLINO WANDA E C. (CIG 798841696B) (U.S. EU 85.851,40 ECO EU. 4.428,60)','32','CMTO','UA4',to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('25/10/2019','dd/MM/yyyy')), 
(2019,10126,'PIANO DI INTERVENTO TRIENNALE DI MANUTENZIONE ORDINARIA DELLE S.P DI COMPETENZA DELLA DIREZIONE COORD. VIAIBLITA'' - VIABILITA'' 1.  APPROVAZIONE ELABORATI E AFFIDAMENTO LAVORI COMPLEMENTARI ANALO= GHI EX ART. 63 CO.5 DLGS 50/16 A SOREMA SRL, CITRINITI MASSIMO,  AZ AGR.COOP.VALLI UNITE DEL CANAVESE,CO.E.STRA SRL PROG. 785/2019','32','CMTO','UA3',to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('06/12/2019','dd/MM/yyyy'), to_timestamp('10/10/2019','dd/MM/yyyy')), 
(2018,10197,'MESSA IN SICUREZZA DEL TERRITORIO POSTO TRA IL T. STURA DI LANZO  E IL T. BANNA.LOTTO1: REALIZ. DI SCOLMATORE (BY PASS) DEL CANALE  DI NOLE ALLA CONFLUENZA CON IL C. DI CIRIE'' PER LA REGOL. DELLE   ACQUE METEORICHE. PROC. APERTA. AGGIUD. DEFINITIVA A CFC SOC.  COOPERATIVA (U.S. EURO=209.046,94= U.PR. EURO=44.761,86=)','32','CMTO','LC6',to_timestamp('11/04/2018','dd/MM/yyyy'), to_timestamp('27/06/2019','dd/MM/yyyy'), to_timestamp('24/04/2018','dd/MM/yyyy')), 
(2019,10250,'EDIFICI SCOLASTICIDELLA ZONA A. INTERVENTI DI MANUTENZIONE ORDINA RIA DEGLI IMPIANTI ELETTRICI. AFFIDAMENTO LAVORI A BARATELLA  F.LLI S,R,L.    CIG  Z1C29A1201 (U.I. EURO 48.510,93 - U.PR. 795,26)','32','CMTO','UA5',to_timestamp('27/09/2019','dd/MM/yyyy'), to_timestamp('27/09/2019','dd/MM/yyyy'), to_timestamp('17/10/2019','dd/MM/yyyy')), 
(2019,10251,'PIANO DI INTER TRIENNALE RAPPEZZATURA DELLA PAV STRADALE PER LA  MO DELLE SP DI COMPETENZA DEL SERV. VIAB 2. PROG. 3713/18. PROC.  APERTA SINTEL (ID111048386) APP. OP. GARA E AGG. DEF. LOTTO 1(CIG 791903633D)LOTTO3(CIG 7919088E23)A SELVA MERCURIO SRL E LOTTO2 (CIG 79190552EB) A COGIBIT SRL (U.PR. EURO 549.000,00=)','32','CMTO','UA4',to_timestamp('27/09/2019','dd/MM/yyyy'), to_timestamp('27/09/2019','dd/MM/yyyy'), to_timestamp('03/10/2019','dd/MM/yyyy')), 
(2019,10364,'INTERVENTI DI MANUTENZIONE RIPARATIVA DEGLI IMPIANTI ELEVATORI IN STALLATI PRESSO GLI ISTITUTI SCOLASTICI DI COMPETENZA - ZONA A  AFFIDAMENTO ALL''IMPRESA GRUPPO SIMET S.R.L.  (U.I. EURO 47.775,20 - U.PR. EURO 783,20)','32','CMTO','UA5',to_timestamp('01/10/2019','dd/MM/yyyy'), to_timestamp('01/10/2019','dd/MM/yyyy'), to_timestamp('21/10/2019','dd/MM/yyyy')), 
(2019,10706,'ACCORDO QUADRO PER IL SERVIZIO DI RIPARAZIONE CARROZZERIE.  AUMENTO PRESTAZIONI CONTRATTUALI ENTRO IL LIMITE DEL QUINTO EX  ART. 106, C. 12, D.LGS. 50/2016 E S.M.I. CIG 7622127A2C. (U.PR. EURO 15.000,00)','32','CMTO','UA3',to_timestamp('08/10/2019','dd/MM/yyyy'), to_timestamp('18/12/2019','dd/MM/yyyy'), to_timestamp('25/10/2019','dd/MM/yyyy')), 
(2018,10848,'CONVENZIONE 2016-2020 PER LA GESTIONE DEL SERVIZIO DI TESORERIA  DELLA CITTA'' METROPOLITANA DI TORINO. IMPUTAZIONE ONERI DI TESORERIA ANNO 2018. (U.I. EURO 8.540,00.=)  ( U.I. EURO 880,84.=)  (U.I. EURO 10.417,50.=) (U. PR. EURO 60.161,66.=)','32','CMTO','EA4',to_timestamp('26/04/2018','dd/MM/yyyy'), to_timestamp('31/10/2018','dd/MM/yyyy'), to_timestamp('10/05/2018','dd/MM/yyyy')), 
(2019,10858,'FORNITURA E POSA DI APPARECCHIATURE HARDWARE PER LE POSTAZIONI DI MONITORAGGIO DEL TRAFFICO SULLA RETE VIABILE DI COMPETENZA DELLA CITTA'' METROPOLITANA DI TORINO - APPROVAZIONE PROGETTO E INDIVIDUAZIONE MODALITA'' DI GARA. (U.PR. EURO 130.000)','32','CMTO','UA3',to_timestamp('10/10/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('04/11/2019','dd/MM/yyyy')), 
(2018,10972,'RIMBORSO SPESE DI NOTIFICA AI COMUNI - ANNO 2018. (U./PR. EURO 150,00)','32','CMTO','IA8',to_timestamp('02/05/2018','dd/MM/yyyy'), to_timestamp('05/04/2019','dd/MM/yyyy'), to_timestamp('16/05/2018','dd/MM/yyyy')), 
(2018,10987,'SERVIZIO DI GESTIONE MANUTENTIVA DEGLI IMPIANTI ASCENSORI PRESSO  EDIFICI SEDI DI UFFICI DI COMPETENZA PER IL PERIODO 2^ SEM. 2018 1^ SEM. 2022. INDIVIDUAZIONE MODALITA'' DI AFFIDAMENTO. U/PR. EURO 126.232,00)','32','CMTO','FA3',to_timestamp('02/05/2018','dd/MM/yyyy'), to_timestamp('06/12/2016','dd/MM/yyyy'), to_timestamp('15/05/2018','dd/MM/yyyy')), 
(2019,10988,'FORNITURA DI CONGLOMERATO BITUMINOSO FREDDO AD ELEVATE PRESTAZIONI PER LA MANUTENZIONE ORDINARIA DELLE STRADE DI  COMPETENZA . ANNO 2019. APPROVAZIONE PROGETTO E INDIVIDUAZIONE MODALITA'' DI GARA. (U.PR. EURO 204.960,00)','32','CMTO','UA3',to_timestamp('14/10/2019','dd/MM/yyyy'), to_timestamp('14/10/2019','dd/MM/yyyy'), to_timestamp('25/10/2019','dd/MM/yyyy')), 
(2019,11044,'MANUTENZIONE ORDINARIA DEGLI IMPIANTI ELETTRICI DELLE PALESTRE  PRESSO LE SEDI DI ISTITUTI SCOLASTICI. AFFIDAMENTO LAVORI A SIET  S.R.L.  -       CIG Z162A2FED7 (U.I. EURO 48.646,67/U.PR. EURO 797,49)','32','CMTO','UA5',to_timestamp('15/10/2019','dd/MM/yyyy'), to_timestamp('15/10/2019','dd/MM/yyyy'), to_timestamp('18/11/2019','dd/MM/yyyy')), 
(2019,11102,'PIANO DI INTERV. TRIENNALE DI NOLEGGIO MEZZI OPERATIVI PER LA M.O DELLE S.P. DI COMPETENZA DELLA DIREZIONE VIABILITA'' 2. APPROVAZ. ELABORATI E AFFIDAM. SERVIZI COMPLEMENTARI ANALOGHI EX ART. 63 C. 5, D.LGS 50/2016 A CARELLO E COGERINO SNC, PASCHETTO F.LLI SNC DI PASCHETTO ROBERTO, AZ. AGR. BIGLIA CARLO (U.PR. EURO 116.560,00)','32','CMTO','UA4',to_timestamp('16/10/2019','dd/MM/yyyy'), to_timestamp('16/10/2019','dd/MM/yyyy'), to_timestamp('30/10/2019','dd/MM/yyyy')), 
(2019,11137,'FORNITURA CUFFIE 3M PELTOR PER I DIPENDENTI DELL''UFFICIO FAUNISTICO AMBIENTALE DELLA CMTO. AFFIDAMENTO ALLA DITTA A+A MONFERRATO S.PA. CIG ZB82A1066C. (U.I. EURO 417,94).','32','CMTO','RA3',to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('06/02/2019','dd/MM/yyyy'), to_timestamp('28/10/2019','dd/MM/yyyy')), 
(2019,11161,'INCARICO DI COLLABORAZIONE COORDINATA E CONTINUATIVA PER  INGEGNERE CIVILE/TERRITORIO AMBIENTE IN POSSESSO DI ABILITAZIONE AI SENSI DEL D.LGS. 81/08 E S.M.I. ALL''ING. ALESSANDRA ANTONELLA SANGIACOMO. INTEGRAZIONE DETERMINA N. 475-7139 DEL 28/06/2019 (U.I. EURO 12,00=)','32','CMTO','UA3',to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('22/10/2019','dd/MM/yyyy')), 
(2019,11186,'AFFIDAMENTO DIRETTO DI INCARICO IN MATERIA DI ESPROPRIAZIONI  A GEOM. MASSIMO ROMERIO. CIG ZF22A3AAE4 U.I. EURO 25.629,76','32','CMTO','RA2',to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('03/06/2019','dd/MM/yyyy'), to_timestamp('13/11/2019','dd/MM/yyyy')), 
(2019,11444,'INTERVENTI DI MANUTENZIONE ORDINARIA IMPIANTI ANTINCENDIO ED EST INTORI DEGLI EDIFICI DELLA CITTA'' METROPOLITANA DI TORINO-2019/21 PROCEDURA APERTA SU SINTEL (ID111938801) APPROVAZIONE OP. DI GARA E AGGIUDICAZIONE DEF. A CO.M.I. SRL (PROGETTO N. 3484/2018- CIG  7940083BC3) (U.PR. EURO 732.000,00=)','32','CMTO','UA5',to_timestamp('23/10/2019','dd/MM/yyyy'), to_timestamp('23/10/2019','dd/MM/yyyy'), to_timestamp('29/10/2019','dd/MM/yyyy')), 
(2019,11512,'EDIFICI SCOLASTICI DELLA ZONA B. INTERVENTI DI MANUTENZIONE ORDI NARIA DEGLI IMPIANTI ELETTRICI. AFFIDAMENTO LAVORI A CHIAVAZZA  S.R.L. - CIG. ZEC2A56668 (U.I. EURO 48.349,19 - U./PR. EURO 792,60)','32','CMTO','UA5',to_timestamp('24/10/2019','dd/MM/yyyy'), to_timestamp('24/10/2019','dd/MM/yyyy'), to_timestamp('08/11/2019','dd/MM/yyyy')), 
(2019,11555,'PIANO DI INTERVENTO TRIENNALE DI RAPPEZZATURA DELLA PAVIMENTAZIO- NE STRADALE PER LA M.O. DELLE S.P. DI COMPETENZA DELLA DIREZIONE  VIABILITA'' 2. APPROVAZIONE E AFFIDAMENTO LAVORI COMPLEMENTARI ANA LOGHI EX ART. 63 CO. 5 D.LGS. 50/2016. LOTTI DA 1 A 5. PROG. N. 876/2019 (U.PR. EURO 270.000,00)','32','CMTO','UA4',to_timestamp('25/10/2019','dd/MM/yyyy'), to_timestamp('25/10/2019','dd/MM/yyyy'), to_timestamp('15/11/2019','dd/MM/yyyy')), 
(2019,11632,'PROGETTO ALCOTRA N. 4951 SOCIALAB - SERVIZI DI SUPPORTO PER  L''ATTIVITA'' DI COORDINAMENTO, GESTIONE E ANIMAZIONE DEL PROGETTO. AFFIDAMENTO ALLA DITTA CHINTANA SRL  CUP J79E19000740007  CIG ZC629B1787 E/A-U/I= EURO 10.980,37','32','CMTO','SA3',to_timestamp('28/10/2019','dd/MM/yyyy'), to_timestamp('10/12/2019','dd/MM/yyyy'), to_timestamp('27/11/2019','dd/MM/yyyy')), 
(2019,11662,'INTERVENTI DI MANUTENZIONE RIPARATIVA IMPIANTI ELEVATORI INSTAL- LATI PRESSO GLI ISTITUTI SCOLASTICI DELLA CITTA'' METROPOLITANA DI TORINO - ZONA B. AFFIDAMENTO ALL''IMPRESA GRUPPO SIMET S.R.L. CIG Z522A6D9AD (U.I. EURO 47.677,60 - U.PR. EURO 781,60)','32','CMTO','UA6',to_timestamp('29/10/2019','dd/MM/yyyy'), to_timestamp('29/10/2019','dd/MM/yyyy'), to_timestamp('07/11/2019','dd/MM/yyyy')), 
(2019,11686,'PIANO DI INTERVENTO TRIENNALE DI RAPPEZZATURA DELLA PAVIMENTAZIO- NE STRADALE PER LA M.O. DELLE S.P. DI COMPETENZA DELLA DIREZIONE  COORDINAMENTO VIABILITA''-VIABILITA'' 1. APPROVAZIONE E AFFIDAMENTO LAVORI COMPLEMENTARI ANALOGHI EX ART. 63 CO. 5 D.LGS. 50/2016.  LOTTI DA 1 A 3. PROG. N. 884/2019 (U.PR. EURO 297.000,00)','32','CMTO','UA3',to_timestamp('29/10/2019','dd/MM/yyyy'), to_timestamp('29/10/2019','dd/MM/yyyy'), to_timestamp('11/11/2019','dd/MM/yyyy')), 
(2019,11863,'PIANO DI INTERVENTO TRIENNALE DI MANUTENZIONE ORDINARIA DI MODE- STA ENTITA'' PER LA MANUTENZIONE ORDINARIA DELLE S.P. DI COMPETEN- ZA DELLA DIREZIONE VIABILITA'' 2. APPR.NE ELABORATI E AFFIDAMENTO  LAVORI COMPLEMENTARI ANALOGHI EX ART. 63 CO. 5 D.LGS. 50/2016. LOTTI DA 1 A 5. PROG. N. 897/2019 (U.PR. EURO 324.000,00)','32','CMTO','UA4',to_timestamp('04/11/2019','dd/MM/yyyy'), to_timestamp('04/11/2019','dd/MM/yyyy'), to_timestamp('15/11/2019','dd/MM/yyyy')), 
(2019,12167,'PROGETTO ALCOTRA SOCIALAB - SERVIZI DI SUPPORTO PER ELABORAZIONE  E APPLICAZIONE INDICATORI VALUTAZIONE SOSTENIBILITA'' ECONOMICA E  QUALITA'' SOCIALE. AFFIDAMENTO ALLA A.S.V.A.P.P.  CUP J79E19000740007  CIG Z7E2A4683B E/A - U/I EURO 20.740.79 BILANCIO 2020 E 2021','32','CMTO','SA3',to_timestamp('08/11/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('27/11/2019','dd/MM/yyyy')), 
(2019,12297,'MANUTENZIONE DEGLI IMPIANTI DI ILLUMINAZIONE ESTERNA DEGLI  EDIFICI SCOLASTICI DI COMPETENZA. AFFIDAMENTO LAVORI A  ELECTROTECHNICAL NEW GENERATION DI MAFFIA LUCA.  (U.I. EURO 47.796,35 - U./PR.EURO 783,55)','32','CMTO','UA5',to_timestamp('12/11/2019','dd/MM/yyyy'), to_timestamp('12/11/2019','dd/MM/yyyy'), to_timestamp('03/12/2019','dd/MM/yyyy')), 
(2019,12424,'PIANO URBANO DI MOBILITA'' SOSTENIBILE (PUMS). ISTITUZIONE COMITATO SCIENTIFICO. (U.PR EURO 35.000,00) CUP J72G19000420004','32','CMTO','UA0',to_timestamp('13/11/2019','dd/MM/yyyy'), to_timestamp('27/09/2019','dd/MM/yyyy'), to_timestamp('09/12/2019','dd/MM/yyyy')), 
(2018,12567,'INTERVENTI DI MANUTENZIONE ORDINARIA E DI ADEGUAMENTO FUNZIONALE  E NORMATIVO PRESSO EDIFICI SEDI DI UFFICI DELL''ENTE. OPERE EDILI. REVOCA AFFIDAMENTO AEL.ME.CA SRL. AFFIDAMENTO A EDIL C.R.E. DI   MARZANO FABIO. RDO N. 1761175. C.I.G. 72979781F7.  PROGETTO 31047/2017. (U/I EURO 92.354,29).','32','CMTO','FA3',to_timestamp('14/05/2018','dd/MM/yyyy'), to_timestamp('27/10/2017','dd/MM/yyyy'), to_timestamp('29/05/2018','dd/MM/yyyy')), 
(2019,12597,'CONVENZIONE CON L''ASL TO3 PER LA REALIZZAZIONE DI ATTIVITA'' DI  INTERESSE COMUNE PROGETTO ALCOTRA COEUR SOLIDAIRE RELATIVAMENTE ALL''ATTIVITA'' DELL''INFERMIERE DI FAMIGLIA E COMUNITA'' ANCHE ATTRA VERSO ATTIVAZIONE DI STRUMENTI DIGITALI - CIG. Z582AB2B4D  U/I = EURO 4.000 BIL 2019 E/A-U/I= EURO 21.000 BIL 2020','32','CMTO','SA3',to_timestamp('18/11/2019','dd/MM/yyyy'), to_timestamp('04/06/2019','dd/MM/yyyy'), to_timestamp('06/12/2019','dd/MM/yyyy')), 
(2018,12694,'AUTORIZZAZIONE ALL''INDIZIONE DI PROCEDURA DI ACQUISTO SUL MEPA   E APPROVAZIONE DEL CAPITOLATO D''ONERI PER L''AFFIDAMENTO DEL  SERVIZIO MANUTENZIONE IMPIANTI ELEVATORI INSTALLATI PRESSO GLI    ISTITUTI SCOLASTICI DELLA CITTA'' METROPOLITANA DI TORINO. (U./PR. EURO 248.620,00=)','32','CMTO','HE3',to_timestamp('16/05/2018','dd/MM/yyyy'), to_timestamp('11/10/2018','dd/MM/yyyy'), to_timestamp('22/05/2018','dd/MM/yyyy')), 
(2019,12912,'INNOMETRO: INNOVAZIONE DELLE MICROIMPRESE DEL TERRITORIO. ACCORDO  CON FINPIEMONTE S.P.A. PER GESTIONE BANDO CONCESSIONE CONTRIBUTI  - IMPEGNO DI SPESA. FONDO INNOMETRO - PARZIALE REIMPUTAZIONE CONTABILE SPESA ANNO 2019. (U/I  EURO 73.678,00).','32','CMTO','SA2',to_timestamp('22/11/2019','dd/MM/yyyy'), to_timestamp('08/10/2019','dd/MM/yyyy'), to_timestamp('13/12/2019','dd/MM/yyyy')), 
(2019,12959,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO A CALDO DI MEZZI OPERAT PER LA M.O. DELLE S.P. DI COMPETENZA DEL SERVIZIO VIABILITA'' 1. - PROCEDURA APERTA. APPROVAZIONE OPERAZIONI DI GARA E AGGIUDICAZ. DEFINITIVA LOTTO 2 U.O.2 (CIG 8060058A44) ALL''IMPRESA GS SERVICE  SRL. (U.PR. EURO 117.120,00)','32','CMTO','UA3',to_timestamp('25/11/2019','dd/MM/yyyy'), to_timestamp('25/11/2019','dd/MM/yyyy'), to_timestamp('10/12/2019','dd/MM/yyyy')), 
(2019,13012,'PROGETTO ALCOTRA N. 4591 SOCIALAB- ATTIVIT? DI SUPPORTO ALLA GE STIONE SEZIONE DECENTRATA UFFICIO PUBBLICA TUTELA PRESSO TRIBUNA LE DI IVREA E PROMOZIONE DIRITTI DELLE PERSONE. AFFIDAMENTO ALLA  DITTA ANDIRIVIENI S.C.S. EURO 34.770,00 CIG. N. Z3D2A10891 E/A-U/I= EURO 19.860 BIL, 2020 E/A-U/I= EURO 14.910 BIL 2021','32','CMTO','SA3',to_timestamp('25/11/2019','dd/MM/yyyy'), to_timestamp('27/06/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,13237,'CIG SMAT 09999901DA - CIG C.C.A.M. 1514368002. PRENOTAZIONE IMPEGNO DI SPESA PER LA FORNITURA DI ACQUA POTABILE PRESSO GLI EDIFICI DELLA CITTA'' METROPOLITANA DITORINO PER L''ANNO 2020.  (U. PR. EURO 787.000,00)','32','CMTO','RA3',to_timestamp('28/11/2019','dd/MM/yyyy'), to_timestamp('22/02/2019','dd/MM/yyyy'), to_timestamp('04/12/2019','dd/MM/yyyy')), 
(2019,13323,'PIANO INTEGRATO TERRITORIALE ALCOTRA GRAIES LAB - SERVIZIO DI COFFEE BREAK PER RIUNIONE DEL COMITATO TECNICO DEL SEGRETARIATO ALCOTRA DEL 3.12.2019 - AFFIDAMENTO DIRETTO IN ECONOMIA ALLA  DITTA PIRAMIDE SRL - CIG Z102AE3409 (E.A./U.I EURO 187,00=)','32','CMTO','QA5',to_timestamp('28/11/2019','dd/MM/yyyy'), to_timestamp('05/04/2019','dd/MM/yyyy'), to_timestamp('02/12/2019','dd/MM/yyyy')), 
(2019,13343,'SERVIZIO DI TRADUZIONE TECNICA DI DOCUMENTI RELATIVI AI PROCEDIMENTI FINALIZZATI AL RILASCIO DI AUTORIZZAZIONI ALLE SPDEDIZIONI DI RIFIUTI. AFFIDAMENTO SERVIZIO. CIG Z1A2ABF928 (U.PR  EURO 15.860,00)','32','CMTO','TA1',to_timestamp('29/11/2019','dd/MM/yyyy'), to_timestamp('02/09/2019','dd/MM/yyyy'), to_timestamp('11/12/2019','dd/MM/yyyy')), 
(2019,13371,'NUCLEO DI VALUTAZIONE (NDV) 2018/2020 - IMPEGNO DI SPESA PER GLI ANNI 2019 E 2020. (U.I. EURO 19.121,24).','32','CMTO','QA6',to_timestamp('29/11/2019','dd/MM/yyyy'), to_timestamp('12/04/2019','dd/MM/yyyy'), to_timestamp('12/12/2019','dd/MM/yyyy')), 
(2019,13391,'CONVENZIONE CON L''ASL TO4 PER LA REALIZZAZIONE DI ATTIVITA'' D''INTERESSE COMUNE NELL''AMBITO DEL PROGETTO ALCOTRA N. 4591 SOCIALAB RELATIVAMENTE ALLA FORMAZIONE DEGLI OPERATORI SOCIALI  DI COMUNITA'' ED ALLA IMPLEMENTAZIONE INFERMIERE DI COMUNITA'' CUP J79E19000740007 E/A-U/I= EURO 40.000,00 BILANCIO 2020','32','CMTO','SA3',to_timestamp('29/11/2019','dd/MM/yyyy'), to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,13407,'PRENOTAZIONE IMPEGNO DI SPESA PER LA FORNITURA DI ENERGIA  ELETTRICA FUORI CONVENZIONE PER L''ANNO 2020. (U. PR. EURO 11.400,00)','32','CMTO','RA3',to_timestamp('02/12/2019','dd/MM/yyyy'), to_timestamp('09/04/2019','dd/MM/yyyy'), to_timestamp('11/12/2019','dd/MM/yyyy')), 
(2018,13415,'AFFIDAMENTO INCARICO PROFESSIONALE PER REALIZZARE IL SUPPORTO OPERATIVO NELLA REDAZIONE DI INDICAZIONI NATURALISTICHE PER LA  TUTELA E LA VALORIZZAZIONE DEL S.I.C. IT1110064 PALUDE DI ROMANO CANAVESE AL DOTT. NATURALISTA DIEGO PIER ACHILLE MARRA. CIG ZCA23BFBA5 - U.I. EURO 2.080,00','32','CMTO','IAG',to_timestamp('28/05/2018','dd/MM/yyyy'), to_timestamp('29/11/2019','dd/MM/yyyy'), to_timestamp('20/08/2018','dd/MM/yyyy')), 
(2019,13442,'PRENOTAZIONE IMPEGNO DI SPESA PER LA FORNITURA DI GAS METANO  FUORI CONVENZIONE PER L''ANNO 2020. (U. PR. EURO 5.000,00)','32','CMTO','RA3',to_timestamp('02/12/2019','dd/MM/yyyy'), to_timestamp('16/04/2019','dd/MM/yyyy'), to_timestamp('11/12/2019','dd/MM/yyyy')), 
(2019,13592,'SERVIZIO DI MANUTENZIONE ORDINARIA E RIPARATIVA IMPIANTI ELEVATOR INSTALLATI PRESSO ISTITUTI SCOLASTICI ED EDIFICI DI EDILIZIA GENE RALE DELLA CITTA'' METROPOLITANA DI TORINO. INDIVIDUAZIONE MODA LITA'' DI GARA  E APPROVAZIONE ELABORATI ALLEGATI  (U./PR. EURO 429.999,76)','32','CMTO','UA5',to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('10/12/2019','dd/MM/yyyy')), 
(2019,13603,'CONCESSIONE A FAVORE DELLA CITTA'' METROPOLITANA DI TORINO DI  AULE PRESSO L''EDIFICIO PREFABBRICATO UBICATO IN CALUSO VIA  MONTELLO N.2, DI PROPRIETA'' DEL COMUNE DI CALUSO AD USO  DELL''I.I.S. UBERTINI. A.S. DAL 2019/2020 AL 2022/2023. APPROVAZ.SCHEMA CONTRATTO.(U.I. EURO 15.000- U.PR.EURO 5.450)','32','CMTO','QA3',to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('06/12/2019','dd/MM/yyyy'), to_timestamp('12/12/2019','dd/MM/yyyy')), 
(2019,13604,'CENTRO EUROPE DIRECT TORINO. AFFIDAMENTO IN ECONOMIA PER SERVIZIO DI STAMPA PREVIA TRATTIVA DIRETTA MEPA N. 1132876 ALLA TIPOGRAFIA SOSSO S.R.L. - CIG ZDF2A8C0BC.  (U.I. EURO 1.903,20=)','32','CMTO','QA5',to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('13/11/2019','dd/MM/yyyy'), to_timestamp('18/12/2019','dd/MM/yyyy')), 
(2019,13682,'SERVIZI IN CONVENZIONE CONSIP TELEFONIA FISSA 5. PRENOTAZIONE DI SPESA PER L''ESERCIZIO 2020. AFFIDATARIA FASTWEB SPA (COD. CRED. 110450). CIG 7999219C55. (U. PR. EURO 50.000,00)','32','CMTO','QA1',to_timestamp('04/12/2019','dd/MM/yyyy'), to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('17/12/2019','dd/MM/yyyy')), 
(2019,13708,'CIG ZCC2A84ADC. AFFIDAMENTO PER LA FORNITURA DI G.P.L. DA  RISCALDAMENTO PER IL MAGAZZINO STRADALE DI FAVRIA ALLA SOCIETA'' LIQUIGAS S.P.A. (P.IVA 03316690175). PRENOTAZIONE IMPEGNO DI SPESA PER L''ANNO 2020. (U. PR. EURO 12.000,00)','32','CMTO','RA3',to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('17/04/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy')), 
(2019,13714,'FORNITURE DI RICAMBI, MATERIALI USURA, LUBRIFICANTI E ACCESSORI PER I MEZZI MECCANICI ED ATTREZZATURE VARIE. AUTORIZZAZIONE E PRENOTAZIONE DI SPESA PER L''ANNO 2020. (U.PR. EURO 30.000,00)','32','CMTO','UA3',to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,13751,'NOLEGGIO FOTOCOPIATORI OLIVETTI D-COPIA 5000MF CONSIP 26 LOTTO 3 PRODUTTIVITA'' MEDIA - CIG DERIVATO 725470866D. REIMPUTAZIONE IMPEGNI ANNO 2022. (U.I. EURO 37.576,00).','32','CMTO','RA3',to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('27/05/2019','dd/MM/yyyy'), to_timestamp('18/12/2019','dd/MM/yyyy')), 
(2019,13752,'NOLEGGIO FOTOCOPIATORI OLIVETTI D-COPIA 5000MF PRODUTTIVITA'' BASSA CONSIP 26 LOTTO 3 - REIMPUTAZIONE IMPEGNI ANNO 2022. CIG DERIVATO 7254788871. (U.I. EURO 5.234,13).','32','CMTO','RA3',to_timestamp('05/12/2019','dd/MM/yyyy'), to_timestamp('29/05/2019','dd/MM/yyyy'), to_timestamp('24/12/2019','dd/MM/yyyy')), 
(2019,13787,'EDIFICI DI COMPETENZA DELLA DIREZIONE EDILIZIA SCOLASTICA 2. REDAZIONE RELAZIONI GEOLOGICHE ED ESECUZIONE PROVE SISMICHE SUL   TERRENO. AFFIDAMENTO SERVIZIO TRAMITE TRATTATIVA DIRETTA SUL MEPA AL DOTT. GEOLOGO MASSIMO TROSSERO (CIG Z322AFFD46) (U.I. EURO 38.904,04=)','32','CMTO','UA6',to_timestamp('06/12/2019','dd/MM/yyyy'), to_timestamp('06/12/2019','dd/MM/yyyy'), to_timestamp('18/12/2019','dd/MM/yyyy')), 
(2019,13812,'ASSOCIAZIONE ARCO LATINO. IMPEGNO QUOTA ASSOCIATIVA ANNO 2019. (U.I. EURO 5.500,00)','32','CMTO','SA1',to_timestamp('06/12/2019','dd/MM/yyyy'), to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('13/12/2019','dd/MM/yyyy')), 
(2019,13855,'PIANO INTEGRATO TERRITORIALE ALCOTRA GRAIES LAB - SERVIZIO DI  CATERING PER INCONTRO DI TEAM COACHING/TEAM BUILDING DEL GIORNO 11.12.2019. AFFIDAMENTO DIRETTO IN ECONOMIA ALLA DITTA PIRAMIDE S.R.L. - CUP J19F18000830005 - CIG Z1C2B14F7D (E.A./UI EURO 300,00=)','32','CMTO','QA5',to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('13/12/2019','dd/MM/yyyy'), to_timestamp('10/12/2019','dd/MM/yyyy')), 
(2019,13871,'CONVENZIONE 2016-2020 PER LA GESTIONE DEL SERVIZIO DI  TESORERIA DELLA CITTA'' METROPOLITANA DI TORINO. IMPUTAZIONE ONERI DI TESORERIA ANNO 2020. CIG 6600893D36 (U. PR. EURO 8.540,00=)  ( U. PR. EURO 91.460,00=)','32','CMTO','QA3',to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('22/11/2019','dd/MM/yyyy'), to_timestamp('15/01/2020','dd/MM/yyyy')), 
(2019,13872,'PAGO P.A. ADDENDUM ALLA CONVENZIONE DI TESORERIA  ART. 38 PARTNER TECNOLOGICO PER SCAMBIO DEI FLUSSI CON IL NODO DEI PAGAMENTI.         IMPUTAZIONE ONERI ANNO 2020. CIG 772066919D U. PR. EURO 22.899,40=','32','CMTO','QA3',to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('17/12/2019','dd/MM/yyyy'), to_timestamp('15/01/2020','dd/MM/yyyy')), 
(2019,13906,'CONVENZIONE QUADRO PER GLI AFFIDAMENTI DIRETTI ALLA SOCIETA'' 5T S.R.L. PER LA PRESTAZIONE DEL SERVIZIO DI MONITORAGGIO,  CONTROLLO E GESTIONE DEL TRAFFICO. AFFIDAMENTO ESECUZIONE  PRESTAZIONI DI MANUTENZIONE STRAORDINARIA .  (U.I. EURO 154.840,00)','32','CMTO','UA3',to_timestamp('10/12/2019','dd/MM/yyyy'), to_timestamp('10/12/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy')), 
(2019,13913,'CONTRATTO DI CONCESSIONE PRECARIA TEMPORANEA DI ALCUNI LOCALI SITI PRESSO PALAZZO CISTERNA VIA MARIA VITTORIA 12 - TORINO,  DA DESTINARSI A SEDE DEGLI UFFICI DELL''EURISPES- ISTITUTO DI  STUDI POLITICI, ECONOMICI E SOCIALI. DURATA 01/01/2020-31/12/2020 APPROVAZIONE SCH.  CONTRATTO.(EA EURO 48000 - UI EURO 30000)','32','CMTO','QA3',to_timestamp('10/12/2019','dd/MM/yyyy'), to_timestamp('06/03/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy')), 
(2019,14051,'SERVIZIO DI VERIFICA IMPIANTI AI SENSI DEL D.P.R. 462/2001 PRESSO ALCUNI EDIFICI DI COMPETENZA. AFFIDAMENTO ALL''ORGANISMO DI  ISPEZIONE EURISP ITALIA S.R.L.  (U.I. EURO 6.635,58)','32','CMTO','UA5',to_timestamp('12/12/2019','dd/MM/yyyy'), to_timestamp('12/12/2019','dd/MM/yyyy'), to_timestamp('17/12/2019','dd/MM/yyyy')), 
(2019,14065,'COMMISSIONE PROVINCIALE ESPROPRI. CONFERMA RICONOSCIMENTO GETTONI DI PRESENZA AI COMPONENTI E  COSTITUZIONE RELATIVO FONDO-PRENOTAZIONE DI SPESA PER L''ANNO 2019 (U.PR. EURO 878,85=)','32','CMTO','RA5',to_timestamp('12/12/2019','dd/MM/yyyy'), to_timestamp('11/07/2019','dd/MM/yyyy'), to_timestamp('17/12/2019','dd/MM/yyyy')), 
(2019,14153,'PROGETTO ALCOTRA N. 4171 GRAIES LAB MOBILAB AFFIDAMENTO SERVIZIO DI ASSISTENZA TECNICA E AMMINISTRATIVA ALLA  SOCIETA'' BUSINESS DEVELOPMENT MANAGEMENT. (E.A. EURO 17.083,24 -  U.I. EURO 18.283,24) T. D. N. 1155295 CIG Z102AE42BE CUP J11F18000300007','32','CMTO','UA0',to_timestamp('13/12/2019','dd/MM/yyyy'), to_timestamp('16/10/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy')), 
(2019,14372,'POR FSE 2014-2020 AZIONE 1.8I.1.2 OB. SPEC. 1 AZIONE 2 MISURA 1.  SERV. TRASV. DI SUPPORTO A REALIZZ. PROGR. MIP 2019-2022. CIG 8137368082. DETERM. A CONTRARRE E AFFID. EX 63, COMMA 5 D.LGS. 50/2016 A ATI SELENE CONSULTING SRL/CONS. SPAZIO E FORMAZIONE /TELEWORK TEAM S.C.(E/A -EPR  400.000,00 - U/I-UPR 399.916,00).','32','CMTO','SA2',to_timestamp('17/12/2019','dd/MM/yyyy'), to_timestamp('10/10/2019','dd/MM/yyyy'), to_timestamp('24/12/2019','dd/MM/yyyy')), 
(2019,14450,'INTERVENTI DI MO NEGLI EDIFICI SCOL. DI PROP. E COMP. DELLA CITTA METROPOLITANA DI TORINO.19-21. PROG. 825/2019. APPROVAZ. OP. GARA E AGGIUDICAZIONE DEF. LOTTO 1 A C.E.V.I.G. SRL (CIG 807771012B) LOTTO A A CO.GE.IM. SRLU (CIG 8077743C63)  (U.PR. EURO 1.206.336,00=)','32','CMTO','UA6',to_timestamp('18/12/2019','dd/MM/yyyy'), to_timestamp('18/12/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy')), 
(2019,14498,'SPESE PER LA RISCOSSIONE DI ENTRATE. ANNO 2020. (U/PR  EURO  500,00)','32','CMTO','QA3',to_timestamp('18/12/2019','dd/MM/yyyy'), to_timestamp('17/04/2019','dd/MM/yyyy'), to_timestamp('24/12/2019','dd/MM/yyyy')), 
(2019,14514,'FORNITURA DI CONGLOMERATO BITUMINOSO FREDDO AD ELEVATE         PRESTAZIONI PER LA MANUTENZIONE ORDINARIA DELLE STRADE DI  COMPETENZA - ANNO 2019. APPROVAZIONE OPERAZIONI DI GARA E  AFFIDAMENTO ALL''IMPRESA SABBIE DI PARMA SRL (CIG 8086971B93) (U.I. EURO 204.960,00)','32','CMTO','UA3',to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,14518,'INTERVENTI DI MANUTENZIONE ORDINARIA NEGLI EDIFICI SCOLASTICI DI PROPRIETA E COMPETENZA DELLA CITTA METROPOLITANA DI TORINO. 19/21 (PROG. 825/2019)PROC. NEG. APPROVAZIONE OP. GARA E AGGIUDICAZIONE DEF LOTTO 3 A ATI EDIL NORD SRL/GIEFFE COSTR.(CIG 8077780AEC),   LOTTO 4 A ACAM COSTRUZIONI SRL(CIG 8079080BB7) (UPR 1.206.336,00)','32','CMTO','UA6',to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,14544,'DECRETO DEL SINDACO METROPOLITANO N. 243-6754/2019 DI  AUTORIZZAZIONE ALLA PREPOSIZIONE DI APPELLO C/ ATHENAY FORMAZIONE AVVERSO LA SENTENZA DEL TRIBUNALE DI TORINO N. 1974/19 (R.G.A. N. 1458/2019). INTEGRAZIONE DI IMPEGNE DI SPESA PER RESISTE AD APPELLO INCIDENTALE. (U.I. EURO 9338,37)','32','CMTO','A51',to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('07/11/2018','dd/MM/yyyy'), to_timestamp('23/12/2019','dd/MM/yyyy')), 
(2019,14548,'INTERVENTI DI MANUTENZIONE ORDINARIA NEGLI EDIFICI SCOLASTICI DI PROPRIETA E COMPETENZA DELLA CITTA METROPOLITANA DI TORINO. 19/21 (PROG. 824/2019)PROC. NEG. APPROVAZ. OP. DI GARA E AGGIUDICAZIONE DEF. LOTTO 3 A CUDIA IMPIANTI DI C.F. (CIG 8077223F44), LOTTO 4 A EDILINVEST SRL (CIG 8078798303= (U.PR. EUR. 1.206.336,00=)','32','CMTO','UA5',to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,14598,'DETERMINAZIONE A CONTRARRE IN ESECUZIONE DEL DECRETO DELLA SINDACA METROPOLITANA N. 14590/2019. RINEGOZIAZIONE 2019 DEI PRESTITI CON TASSO DI AMMORTAMENTO STRUTTURATO STIPULATI DALLA CITTA'' METROPOLITANA DI TORINO CON LA BANCA DEXIA-CREDIOP S.P.A. (U.I.  EURO 135,24)','32','CMTO','QA3',to_timestamp('20/12/2019','dd/MM/yyyy'), to_timestamp('14/06/2019','dd/MM/yyyy'), to_timestamp('30/12/2019','dd/MM/yyyy')), 
(2019,14618,'INTERVENTI DI MANUTENZIONE ORDINARIA NEGLI EDIFICI SCOLASTICI DI PROPRIETA E COMPETENZA DELLA CITTA METROPOLITANA DI TORINO. 19-21 PROC. NEG. APPROV. OP. GARA E AGGIUDICAZIONE DEF. LOTTO 1 A IDROT ERMICA MERIDIONALE DI M.L. (CIG 807715030A) E LOTTO 2 A TECNOVA  SRL (CIG 8077180BC9) (U.PR. EUR. 1.206.336,00=)','32','CMTO','UA5',to_timestamp('20/12/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy'), to_timestamp('24/12/2019','dd/MM/yyyy')), 
(2018,14880,'SERVIZIO DI GESTIONE MANUTENTIVA DEGLI IMPIANTI ASCENSORI PRESSO  EDIFICI SEDI DI UFFICI PER IL PERIODO 2^ SEM. 2018 - 1^ SEM. 2022 LOTTO 2 AFFIDAMENTO DIRETTO SUL MEPA  EX ART. 36, COMMA 2, LETT.  A D.LGS. 50/2016 E S.M.I. A GRUPPO SIMET S.R.L.-CIG. Z3823AF9A6 (U.S. EURO 10.540,95)','32','CMTO','FA3',to_timestamp('11/06/2018','dd/MM/yyyy'), to_timestamp('30/10/2017','dd/MM/yyyy'), to_timestamp('14/06/2018','dd/MM/yyyy')), 
(2018,15063,'SERVIZIO DI PULIZIA E IGIENE AMBIENTALE NEGLI EDIFICI SEDI DI  UFFICI DELL''ENTE PER UN PERIODO DI 36 MESI. AVVIO DI PROCEDURA AD EVIDENZA PUBBLICA PER L''INDIVIDUAZIONE DEL CONTRAENTE.  CIG 7466043596 U.PR EURO 1.207.328,53','32','CMTO','FAB',to_timestamp('15/06/2018','dd/MM/yyyy'), to_timestamp('05/02/2018','dd/MM/yyyy'), to_timestamp('28/06/2018','dd/MM/yyyy')), 
(2018,15203,'PIANO DI INTERVENTO TRIENNALE DI MANUTENZIONE ORDINARIA DI MODESTA ENTITA'' DELLE S.P. DI COMPETENZA DEL SERVIZIO VIABILITA''. INDIVIDUAZIONE MODALITA'' DI AFFIDAMENTO MEDIANTE PROCEDURA APERTA (PROGETTO 3317/2018) (U.PR EURO 658.800,00 + RINVIO 2021)','32','CMTO','HE9',to_timestamp('19/06/2018','dd/MM/yyyy'), to_timestamp('19/12/2016','dd/MM/yyyy'), to_timestamp('28/06/2018','dd/MM/yyyy')), 
(2018,15310,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA DELLA CITTA'' METROPOLITANA.  STAGIONI 2018- 2019, 2019- 2020, 2020- 2021. APPROVAZIONE  PROGETTO LOTTO 3.06 E INDIVIDUAZIONE DELLE MODALITA'' DI GARA (U.PR. EURO 250450,23)','32','CMTO','HE2',to_timestamp('21/06/2018','dd/MM/yyyy'), to_timestamp('07/08/2018','dd/MM/yyyy'), to_timestamp('13/07/2018','dd/MM/yyyy')), 
(2018,16216,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO MEZZI OPERATIVI PER LA MANUTENZIONE ORDINARIA DELLE S.P. DI COMPETENZA DEL SERVIZIO  VIABILITA'' 3. APPROVAZIONE PROGETTO. (U.PR. 372.000,00)','32','CMTO','HE9',to_timestamp('02/07/2018','dd/MM/yyyy'), to_timestamp('11/07/2019','dd/MM/yyyy'), to_timestamp('08/08/2018','dd/MM/yyyy')), 
(2018,16747,'SERVIZIO DI VIGILANZA, SORVEGLIANZA ARMATA E DI PRESIDIO CONTROL  ROOM PRESSO GLI EDIFICI DELLA CITTA'' METROPOLITANA DI TORINO PER  UN PERIODO DI 36 MESI. IMPEGNO DI SPESA PER GLI ANNI 2019-2020. U.PR. EURO 989.631,20','32','CMTO','FAB',to_timestamp('04/07/2018','dd/MM/yyyy'), to_timestamp('05/02/2018','dd/MM/yyyy'), to_timestamp('16/07/2018','dd/MM/yyyy')), 
(2018,17143,'RIMBORSO SPESE DI NOTIFICA 2018 - INDIVIDUAZIONE COMUNI   (U./S. EURO 21,76)','32','CMTO','IA8',to_timestamp('11/07/2018','dd/MM/yyyy'), to_timestamp('06/06/2019','dd/MM/yyyy'), to_timestamp('08/08/2018','dd/MM/yyyy')), 
(2018,17258,'INCARICIHI DI COLLABORAZIONE COORDINATA E CONTINUATIVA PER  ESPERTO TECNICO IN MERITO AD ATTIVITA'' TECNICHE RELATIVE A  PROCEDURE DI GARA DI OPERE PUBBLICHE E ADEMPIMENTI CONSEGUENTI AGLI ARCH. FINOTTO FRANCESCO E DI STEFANO MARTINA. (U.I. EURO 28.878,90)','32','CMTO','HE5',to_timestamp('13/07/2018','dd/MM/yyyy'), to_timestamp('26/07/2017','dd/MM/yyyy'), to_timestamp('19/07/2018','dd/MM/yyyy')), 
(2018,17259,'INCARICHI DI COLLABORAZIONE COORDINATA E CONTINUATIVA DI ESPERTO TECNICO IN MERITO AD ATTIVITA'' TECNICHE RELATIVE A PROCEDURE DI GARA DI OPER EPUBBLICHE E ADEMPIMENTI CONSEGUENTI AGLI ARCH. GIULIA NOTA E LETIZIA ROTA. (U.I. EURO 28.878,90)','32','CMTO','HE4',to_timestamp('13/07/2018','dd/MM/yyyy'), to_timestamp('09/11/2018','dd/MM/yyyy'), to_timestamp('19/07/2018','dd/MM/yyyy')), 
(2017,17613,'EDIFICI SCOLASTICI VARI SERVIZIO EDILIZIA SCOLASTICA 2. AFFIDA- MENTO INCARICO PROF. PER REDAZIONE DI ASSERVAZIONI E CERTIFICA- ZIONI AI FINI PRESENTAZIONE O RINNOVO PRATICHE VV.F. AI SENSI DEL DPR 151/2011 ALL''ING. VERA RAVINA (CIG Z7F1F4B193). (U.I. EURO 11.419,20=)','32','CMTO','HE5',to_timestamp('10/07/2017','dd/MM/yyyy'), to_timestamp('16/06/2014','dd/MM/yyyy'), to_timestamp('29/08/2017','dd/MM/yyyy')), 
(2017,17639,'SPESE RELATIVE AI SERVIZI TELEMATICI DI BASE ANCITEL SPA  (CIG Z501F4DCCB) PROPEDEUTICI AL SERVIZIO DI VISURA TARGHE AUTO- VEICOLI PER ATTIVITA'' DI VIGILANZA AMBIENTALE EFFETTUATO DALL''ACI -PRA (CIG Z3F1F4DD1D) (U.I. EURO 1.462,78) - (U.I. EURO 407,11).','32','CMTO','IAG',to_timestamp('10/07/2017','dd/MM/yyyy'), to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('11/09/2017','dd/MM/yyyy')), 
(2014,18423,'PIANO DI SORVEGLIANZA SANITARIA E DI CONOSCENZA DELLA VAR.  DELLO STATO DI SALUTE DELLA POPOLAZIONE RES.REL.ALL''IMP.DI TERMOVALORIZ ZAZIONE DEI RIFIUTI DELLA PROV.DI.TO PROPOSTO DA TRM SPA.APP.DEL- LO SCHEMA DI PROT. D''INTESA DEF. REL.ALL''INTERO PSS FRA PROVINCIA TO ARPA ASL TO3 ASL TO1 E ISTIT SUPER. SANITA''. US E.1443.664,38.','1','CMTO','LB7',to_timestamp('05/06/2014','dd/MM/yyyy'), to_timestamp('14/05/2019','dd/MM/yyyy'), to_timestamp('06/06/2014','dd/MM/yyyy')), 
(2017,18907,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/2002 E DALLA  D.G.R. DELLA REGIONE PIEMONTE N.30 DEL 21/05/2004.  DETERMINAZIONE COMPENSI PER COMMISSIONI ANNI 2014-2015-2016. (U./S. EURO 10.533,60)','32','CMTO','IA8',to_timestamp('26/07/2017','dd/MM/yyyy'), to_timestamp('26/02/2019','dd/MM/yyyy'), to_timestamp('30/10/2017','dd/MM/yyyy')), 
(2008,18921,'D.P.R. 290/2001 -CORSI DI FORMAZIONE PER IL RILASCIO E IL RINNOVO DELL''AUTORIZZAZIONE PER ACQUISTO ED IMPIEGO DEI PRODOTTI  FITOSANITARI MOLTO TOSSICI, TOSSICI E NOCIVI. APPROVAZIONE DEL PIANO CORSI E DELLO SCHEMA DI CONVENZIONE CON GLI ENTI  GESTORI-ANNO 2008- (E.A./U.I. EURO 76.951,95-U.S. EURO 23.548,05)','1','CMTO','MD4',to_timestamp('27/02/2008','dd/MM/yyyy'), to_timestamp('02/12/2019','dd/MM/yyyy'), to_timestamp('26/03/2008','dd/MM/yyyy')), 
(2014,20679,'INDENNITA'' DI PRESENZA AI COMPONENTI COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/2002 E DGR N.30 DEL 21/05/2004.RIDUZIONE OPERAZIONI CONTABILI E INTEGRAZIONI DI SPESA PER COMMISSIONI ANNO 2014. (U.S. EURO 2.413,00) (IRAP EURO 196,35) (RIDUZIONI DI SPESA EURO 3.171,56)','32','CMTO','IA8',to_timestamp('16/06/2014','dd/MM/yyyy'), to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('31/07/2014','dd/MM/yyyy')), 
(2017,20697,'PROGRAMMA INTERREG SPAZIO ALPINO - PROGETTI SCALE(UP)ALPS E DES ALPS E PROGRAMMA INTERREG EUROPE - PROGETTI FFWD EUROPE E ECORIS3 AUTORIZZAZIONE ALL''INDIZIONE DI UNA PROCEDURA NEGOZIATA SUL MEPA  E APPROVAZIONE DEL CAPITOLATO D''ONERI PER L''AFFIDAMENTO DEL SERVI ZIO DI CONTROLLO DI PRIMO LIVELLO CIG Z081FB8FD6','32','CMTO','MD3',to_timestamp('29/08/2017','dd/MM/yyyy'), to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('11/09/2017','dd/MM/yyyy')), 
(2017,20768,'INTERVENTI DI MANUTENZIONE ORDINARIA PER MESSA IN SICUREZZA DI  EDIFICI SEDI DI UFFICI DELL''ENTE. OPERE DA ELETTRICISTA.   AFFIDAMENTO INTERVENTI SUPPLEMENTARI A ELETTRO 2000 TLC S.R.L.  (U.I. EURO 16.218,25  - U./PR EURO 439,51)','32','CMTO','FA3',to_timestamp('30/08/2017','dd/MM/yyyy'), to_timestamp('04/07/2018','dd/MM/yyyy'), to_timestamp('21/09/2017','dd/MM/yyyy')), 
(2018,20988,'PIANO DI INTERVENTO TRIENNALE DI MANUTENZIONE ORDINARIA DI  MODESTA ENTITA'' DELLE SP DI COMPETENZA DEL SERVIZIO VIABILITA'' 1. INDIVIDUAZIONE MODALITA'' DI AFFIDAMENTO MEDIANTE PROCEDURA APERTA (PROG. LL.PP. N. 3585/2018)(U.PR. EURO 790.560,00)','32','CMTO','HE7',to_timestamp('07/08/2018','dd/MM/yyyy'), to_timestamp('28/05/2018','dd/MM/yyyy'), to_timestamp('16/08/2018','dd/MM/yyyy')), 
(2018,21115,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/2002 E DALLA DGR N.30 DEL 21/05/2004. DETERMINAZIONE COMPENSI PER COMMISSIONI ANNO 2017 E PRIMO SEMESTRE 2018. SECONDO IMPEGNO DI SPESA PER INDENNI TA'' 2018 (U.PR. EU 2.156,00 - U.I. EU 1.987,83 - U.S. EU4.596,90)','32','CMTO','IA8',to_timestamp('08/08/2018','dd/MM/yyyy'), to_timestamp('28/11/2019','dd/MM/yyyy'), to_timestamp('21/09/2018','dd/MM/yyyy')), 
(2018,21512,'PIANO DI INTERVENTO TRIENNALE DI RAPPEZZATURA PAVIMENTAZIONE STRADALE PER LA MANUTENZIONE ORDINARIA DELLE S.P. DI COMPETENZA  SERVIZIO VIABILITA'' 1. INDIVIDUAZIONE MODALITA'' DI AFFIDAMENTO MEDIANTE PROCEDURA APERTA. (PROG. LL.PP. N. 3643/2016) (U.PR. EURO 658.800,00=)','32','CMTO','HE7',to_timestamp('27/08/2018','dd/MM/yyyy'), to_timestamp('04/12/2018','dd/MM/yyyy'), to_timestamp('04/09/2018','dd/MM/yyyy')), 
(2018,21796,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA. STAGIONI 2017/18, 2018/19, 2019/20, 2020/21. AUMENTO DELLE PRESTAZ. CONTRATTUALI ENTRO IL LIMITE DI  UN QUINTO AI SENSI DELL''ART. 106. C. 12 DEL D. LGS. 50/2016 E SMI PER I LOTTI 1.08,1.10,1.21,1.21,1.25. (U.I. EURO 87748,89)','32','CMTO','HE2',to_timestamp('29/08/2018','dd/MM/yyyy'), to_timestamp('27/08/2018','dd/MM/yyyy'), to_timestamp('17/09/2018','dd/MM/yyyy')), 
(2018,23057,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO A CALDO MEZZI OPERAT. PER MANUTENZIONE ORDINARIA DELLE S.P. DI COMPETENZA DEL SERVIZIO VIABILITA'' 1. APPROVAZIONE PROGETTO E INDIVIDUAZIONE MODALITA'' DI GARA. (U. PR. EURO 401.760,00)','32','CMTO','HE7',to_timestamp('07/09/2018','dd/MM/yyyy'), to_timestamp('05/06/2014','dd/MM/yyyy'), to_timestamp('13/09/2018','dd/MM/yyyy')), 
(2018,23294,'PIANO DI INTERVENTO TRIENNALE DI NOLEGGIO A CALDO DI MEZZI  OPERATIVI PER LA MANUTENZIONE ORDINARIA  DELLE S.P. DI COMPETENZA DEL SERVIZIO VIABIILITA'' 2. APPROVAZIONE PROGETTO E INDIVIDUAZIO- NE MODALITA'' DI GARA. (U.PR. EURO 279.000,00)','32','CMTO','HE8',to_timestamp('13/09/2018','dd/MM/yyyy'), to_timestamp('29/08/2017','dd/MM/yyyy'), to_timestamp('08/10/2018','dd/MM/yyyy')), 
(2018,23660,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA. STAGIONI 2017/18, 2018/19, 2019/20,  2020/21. AUMENTO DELLE PRESTAZIONI CONTRATTUALI ENTRO IL LIMITE DEL V? AI SENSI DELL''ART. 106, COMMA 12 DEL DLGS 50/2016 PER I   LOTTI 2.05, 2.15, 2.16, 2.19. (U.I. EURO 106.872,00)','32','CMTO','HE2',to_timestamp('21/09/2018','dd/MM/yyyy'), to_timestamp('07/09/2018','dd/MM/yyyy'), to_timestamp('28/09/2018','dd/MM/yyyy')), 
(2015,23735,'ESAMI PER L''ACCERTAMENTO DELL''IDONEITA'' PROFESSIONALE IN ATTUAZIO NE DELL''ART. 105, COMMA III, LETTERE C) E G) DEL D.LGS. 31 MARZO  1998 N. 112. ACCERTAMENTO E RISCOSSIONE - ANNO 2014. (E/A-U/PR EURO 10.324,26 - E/R EURO 2.423,48)','32','CMTO','IA8',to_timestamp('29/07/2015','dd/MM/yyyy'), to_timestamp('18/12/2019','dd/MM/yyyy'), to_timestamp('22/09/2015','dd/MM/yyyy')), 
(2018,24720,'IST.VITTONE-SUCCURSALE AGRARIO-STRADA PECETTO,34H CHIERI.INCARICO DI COLLAUDO STRUTTURALE RIGUARDANTI LA NUOVA SERRA DELL''ISTITUTO. PROCEDURA DI ACQUISTO,TRAMITE TRATTATIVA DIRETTA, SUL MEPA DELL'' INCARICO PROFESSIONALE ALL''ING.FIORE MALETTA.(CIG Z8424D3689) (U.I. EURO 3.470,41)','32','CMTO','HE5',to_timestamp('01/10/2018','dd/MM/yyyy'), to_timestamp('05/02/2018','dd/MM/yyyy'), to_timestamp('19/10/2018','dd/MM/yyyy')), 
(2018,24855,'PIANO DI INTERVENTO TRIENNALE DI MANUTENZIONE ORDINARIA DI MODESTA ENTITA'' DELLE S.P. DI COMPETENZA DEL SERVIZIO VIABILITA'' 3. LOTTO 1 U.O. - ZONA OMOGENEA 9 - EPOREDIESE. PROCEDURA APERTA. AGGIUDICAZIONE DEFINITIVA A SOREMA S.R.L. (PROG. LL.PP. 3317/2018 CIG 75669772F6) (U.S. EURO 197.640,00=).','32','CMTO','HE9',to_timestamp('03/10/2018','dd/MM/yyyy'), to_timestamp('12/07/2019','dd/MM/yyyy'), to_timestamp('15/10/2018','dd/MM/yyyy')), 
(2018,24867,'ACCORDO QUADRO PER IL SERVIZIO DI MANUTENZIONE TRATTORI E TRINCE AFFIDAMENTO AL CONSORZIO PARTS & SERVICES. CIG 7569458259 (U. PR. EURO 150.232,00)','32','CMTO','HE0',to_timestamp('03/10/2018','dd/MM/yyyy'), to_timestamp('11/10/2018','dd/MM/yyyy'), to_timestamp('15/10/2018','dd/MM/yyyy')), 
(2018,24868,'ACCORDO QUADRO PER IL SERVIZIO DI RIPARAZIONE MEZZI MECCANICI AFFIDAMENTO AL CONSORZIO PARTS & SERVICES. CIG 757316771B  (U. PR. EURO 75.000,00)','32','CMTO','HE0',to_timestamp('03/10/2018','dd/MM/yyyy'), to_timestamp('12/10/2018','dd/MM/yyyy'), to_timestamp('15/10/2018','dd/MM/yyyy')), 
(2017,24896,'PROGRAMMA INTERREG SPAZIO ALPINO PROGETTI SCALE(UP)ALPS E DES ALP PROGRAMMA INTERREG EUROPE PROGETTI FFWD E ECORIS3 PROGRAMMA ALCO- TRA PROGETTO VALE AFFIDAMENTO A CODEX SC DEL SERVIZIO DI ASSISTEN ZA PER LE ATTIVITA'' DI RENDICONTAZIONE TECNICA E FINANZIARIA E  SUPPORTO ALLA GESTIONE E COORDINAMENTO(EA-UI E. 47.828,88)','32','CMTO','MD3',to_timestamp('04/09/2017','dd/MM/yyyy'), to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('21/09/2017','dd/MM/yyyy')), 
(2017,25142,'MANUTENZIONE ORDINARIA E VERIFCHE IMPIANTI DI SICUREZZA NEGLI  EDIFICI DI COMPETENZA DEL SERVIZIO LOGISTICA. AFFIDAMENTO DIRETTO EX ART. 36, COMMA 2, LETTERA A) DEL D.LGS. 50/2016 E S.M.I.  ALL''IMPRESA S.E.C.A.P. S.P.A.. C.I.G. ZB91FA6A57. (U.I. EURO 25.258,88  -  U.PR. EURO 414,00).','32','CMTO','FA3',to_timestamp('11/09/2017','dd/MM/yyyy'), to_timestamp('14/11/2018','dd/MM/yyyy'), to_timestamp('28/09/2017','dd/MM/yyyy')), 
(2018,25474,'PIANO DI INTERVENTO TRIENNALE DI RAPPEZZATURA DELLA PAVIMENTAZIONE STRADALE PER LA MANUTENZIONE ORDINARIA DELLE STRADE PROVINCIALI DI COMPETENZA DEL SERVIZIO VIABILITA'' 2.  APPROVAZIONE PROGETTO DEFINITIVO E INDIVIDUAZIONE MODALITA'' DI  GARA (PROG. LL.PP. N. 3713/2018) (U./PR. EURO 558.000,00=)','32','CMTO','HE8',to_timestamp('11/10/2018','dd/MM/yyyy'), to_timestamp('04/09/2017','dd/MM/yyyy'), to_timestamp('08/11/2018','dd/MM/yyyy')), 
(2018,25526,'INTERVENTI DI MO PRESSO EDIFICI SCOLASTICI DEL SERVIZIO EDILIZIA SCOLASTICA 2. LOTTO 1-ZONE TERRITORIALI 2A E 2B. APPROV. MODIFICA CONTRATTO, AI SENSI DELL''ART. 106, COMMA 1, LETT B DEL DLGS 50/16 (PROG. N. 30944/17 CIG ORIG. 7286760892 CIG MODIFICA CONTRATTO 764948283C) (UI EURO 75.640,00 UPR EURO 1.240,00=)','32','CMTO','HE5',to_timestamp('11/10/2018','dd/MM/yyyy'), to_timestamp('02/05/2018','dd/MM/yyyy'), to_timestamp('26/10/2018','dd/MM/yyyy')), 
(2018,25547,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA. STAGIONI 2017/18, 2018/19, 2019/20, 2020/21. AUMENTO DELLE PRESTAZIONI CONTRATTUALI ENTRO IL LIMITE  DEL QUINTO AI SENSI DELL''ART. 106, COMMA 12 DEL D.LGS 50/2016 E  S.M.I. PER IL LOTTO 3.02 (U.I. EURO 50.264,00)','32','CMTO','HE2',to_timestamp('12/10/2018','dd/MM/yyyy'), to_timestamp('05/04/2017','dd/MM/yyyy'), to_timestamp('27/11/2018','dd/MM/yyyy')), 
(2018,25564,'INTERVENTI DI MO PRESSO EDIFICI SCOLASTICI DEL SERVIZIO EDILIZIA SCOLASTICA 2-LOTO 2, ZONE TERRITORIALI 3A E 3B. APPROVAZIONE  MODIFICA CONTRATTO, AI SENSI DELL''ART. 106, COMMA 1, LETT. B DEL  DLGS N. 50/2016 (PR. N. 30944/17 CIG ORIG. 728679771B, CIG MODI- FICA CONTR. 7649527D5D (UI EURO 79300,00 UPR EURO 1300,00)','32','CMTO','HE5',to_timestamp('12/10/2018','dd/MM/yyyy'), to_timestamp('11/07/2018','dd/MM/yyyy'), to_timestamp('26/10/2018','dd/MM/yyyy')), 
(2018,25838,'PIANO DI INTERVENTO TRIENNALE  MANUTENZIONE ORDINARIA DI MODESTE ENTITA'' DELLE STRADE PROVINCIALI DI COMPETENZA DEL SERVIZIO VIABILITA'' 2. APPROVAZIONE PROGETTO DEFINITIVO E INDIVIDUAZIONE MODALITA'' DI AFFIDAMENTO MEDIANTE PROCEDURA APERTA.  (PROG. LL.PP. N. 3712/2018) (U.PR. EURO 669.600,00=)','32','CMTO','HE8',to_timestamp('16/10/2018','dd/MM/yyyy'), to_timestamp('13/10/2017','dd/MM/yyyy'), to_timestamp('26/11/2018','dd/MM/yyyy')), 
(2018,26805,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA  DELLA CITTA'' METROPOLITANA. STAGIONI 2017/2018, 2018/2019,  2019/2020 E 2020/2021.IMPEGNI DI SPESA PER ANNI 2018- 2019- 2020 E 2021. (U.PR. EURO 1.057.088,55- U.I. EURO 18.980.238,77)','32','CMTO','HE2',to_timestamp('25/10/2018','dd/MM/yyyy'), to_timestamp('18/12/2017','dd/MM/yyyy'), to_timestamp('27/11/2018','dd/MM/yyyy')), 
(2018,26829,'PIANO TERRITORIALE INTEGRATO GRAIES LAB. PROCEDURA NEGOZIATA TELEMATICA TRAMITE R.D.O. SUL MEPA. APPROVAZIONE CAPITOLATO  D''ONERI PER L''AFFIDAMENTO DEI SERVIZI DI COMUNICAZIONE PER IL  PERIODO 2019-2022. (E.A. 2019-2020 EURO. 22.000,00= U.PR. 2019-2020 EURO 22.000,00=)','32','CMTO','AAA',to_timestamp('25/10/2018','dd/MM/yyyy'), to_timestamp('22/03/2006','dd/MM/yyyy'), to_timestamp('31/10/2018','dd/MM/yyyy')), 
(2018,26832,'PIANO INTEGRATO TERRITORIALE LE ALTE VALLI-CUORE DELLE ALPI. PROCEDURA NEGOZIATA TELEMATICA TRAMITE R.D.O. SUL MEPA. APPROVA- ZIONE CAPITOLATO D''ONERI PER L''AFFIDAMENTO DEI SERVIZI DI COMUNICAZIONE PER IL PERIODO 2019-2022. (E.A. 2019-2020 EURO 30.000,00= U.PR. 2019-2020 EURO 30.000,00=)','32','CMTO','AAA',to_timestamp('25/10/2018','dd/MM/yyyy'), to_timestamp('23/12/2016','dd/MM/yyyy'), to_timestamp('31/10/2018','dd/MM/yyyy')), 
(2018,26837,'PIANO INTEGRATO TERRITORIALE LE ALTE VALLI - CUORE DELLE ALPI. PROCEDURA NEGOZIATA TELEMATICA TRAMITE R.D.O. SUL MEPA. APPROVA- ZIONE CAPITOLATO D''ONERI PER L''AFFIDAMENTO DEI SERVIZI DI  COMUNICAZIONE SOCIAL PER IL PERIODO 2019-2022. (E.A. 2019-2020 EURO 15.000,00= U.PR. 2019-2020 EURO 15.000,00=)','32','CMTO','AAA',to_timestamp('25/10/2018','dd/MM/yyyy'), to_timestamp('23/05/2017','dd/MM/yyyy'), to_timestamp('31/10/2018','dd/MM/yyyy')), 
(2018,27113,'INTERVENTI DI MANUTENZIONE ORDINARIA BISEMESTRALE IMPIANTI ANTIN- CENDIO DEGLI EDIFICI DELLA CITTA'' METROPOLITANA. APPROVAZIONE  PROGETTO DEFINITIVO E AUTORIZZAZIONE ALL''INDIZIONE DI UNA PRO- CEDURA NEGOZIATA SUL MEPA (PROG. N. 3828/2018) (U.PR. EURO 172.185,90=)','32','CMTO','HE3',to_timestamp('31/10/2018','dd/MM/yyyy'), to_timestamp('16/10/2018','dd/MM/yyyy'), to_timestamp('09/11/2018','dd/MM/yyyy')), 
(2018,27116,'CONCESSIONE A FAVORE DELLA CITTA'' METROPOLITANA DI TORINO E A  SERVIZIO DELL''I.I.S.BOBBIO DI CARIGNANO DELLA PALESTRA COMUNALE  SITA PRESSO LA SCUOLA PRIMARIA DI PRIMO GRADO DI VIA ROMA N.32 DI PROPRIETA'' DEL COMUNE DI CARIGNANO.ANNI SCOLASTICI 2018/2019- 2019/2020 -2020/2021.APPROVAZIONE SCHEMA DI CONTRATTO.','32','CMTO','FA5',to_timestamp('31/10/2018','dd/MM/yyyy'), to_timestamp('23/11/2017','dd/MM/yyyy'), to_timestamp('13/11/2018','dd/MM/yyyy')), 
(2017,27220,'PROGRAMMA INTERREG SPAZIO ALPINO PROGETTI SCALE (UP)ALPS E DES  ALPS E PROGRAMMA INTERREG EUROPE PROGETTI FFWD E ECORIS3 AFFIDA- MENTO DEL SERVIZIO DI CONTROLLO DI PRIMO LIVELLO ALLA SOCIETA''  SELENE AUDIT SRL. CIG Z081FB8FD6','32','CMTO','MD3',to_timestamp('13/10/2017','dd/MM/yyyy'), to_timestamp('28/11/2019','dd/MM/yyyy'), to_timestamp('05/12/2017','dd/MM/yyyy')), 
(2018,27356,'COMMISSIONE PROVINCIALE ESPROPRI.  GETTONI DI PRESENZA DEI COMPONENTI - COSTITUZIONE FONDO -  PRENOTAZIONE DI SPESA PER L''ANNO 2018. (U.PR. EURO 2.050,65=)','32','CMTO','BA2',to_timestamp('07/11/2018','dd/MM/yyyy'), to_timestamp('13/11/2015','dd/MM/yyyy'), to_timestamp('06/12/2018','dd/MM/yyyy')), 
(2018,27521,'PIANO DI INTERV. TRIENNALE DI MANUTENZ. ORDIN. DI MODESTA ENTITA'' DELLE SP DI COMPETENZA DEL SERV. VIABILITA'' 3. LOTTO 4. U.O. 10- ZONA OMOG. 7-CIRIACESE E VALLI DI LANZO. (PROG. 3317/2018 - CIG 7567050F30).PROC. APERTA. APPROV. OPERAZ. DI GARA E AGG. DEFIN. A SOC. COOP. AGR. VALLI UNITE DEL CANAVESE. (U.S. EURO 197.640,00)','32','CMTO','HE9',to_timestamp('09/11/2018','dd/MM/yyyy'), to_timestamp('04/12/2019','dd/MM/yyyy'), to_timestamp('21/11/2018','dd/MM/yyyy')), 
(2018,27552,'FORNITURA E INSTALLAZIONE DI N. 2 DEFIBRILLATORI PRESSO LA SEDE  SI C.SO INGHILTERRA- TORINO E MANUTENZIONE QUADRIENNALE DEGLI  STESSI. AFFIDAMENTO ALLA DITTA CARDIOSAFE SRL. CIG Z44255090D - CUP J19F18000740003. (U.I. EURO 4.029,32).','32','CMTO','FAC',to_timestamp('12/11/2018','dd/MM/yyyy'), to_timestamp('28/12/2016','dd/MM/yyyy'), to_timestamp('26/11/2018','dd/MM/yyyy')), 
(2018,27555,'ACQUISTI E FORNITURE DI DOCUMENTAZIONE TECNICO GIURIDICA PER GLI  ORGANI E GLI UFFICI METROPOLITANI.   U.L. EURO 239,99','32','CMTO','BA3',to_timestamp('12/11/2018','dd/MM/yyyy'), to_timestamp('30/08/2017','dd/MM/yyyy'), to_timestamp('23/11/2018','dd/MM/yyyy')), 
(2016,27663,'PIANO DI INTERVENTI DI MANUTENZIONE ORDINARIA DI MODESTA ENTITA'' SULLE STRADE DI COMPETENZA DEL SERVIZIO  ESERCIZIO VIABILITA''.  LAVORI COMPLEMENTARI. AGGIUDICAZIONE DEFINITIVA. LOTTI NN. 1-2-3. (UI EURO 72.834,00)','32','CMTO','HE0',to_timestamp('21/10/2016','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy'), to_timestamp('16/11/2016','dd/MM/yyyy')), 
(2018,27755,'ACCORDO QUADRO PER IL SERVIZIO DI MANUTENZIONE DEL PARCO AUTO DELL''ENTE. AGGIUDICAZIONE DEL LOTTO 3 - ZONA DI SUSA-PINEROLO - ALLA DITTA PARTS & SERVICES.  CIG 7614418084 (U/PR  EURO 43.920,00)','32','CMTO','FAB',to_timestamp('14/11/2018','dd/MM/yyyy'), to_timestamp('12/11/2018','dd/MM/yyyy'), to_timestamp('11/12/2018','dd/MM/yyyy')), 
(2017,28426,'NOLEGGIO ATTREZZATURE D''UFFICIO PRODUTTIVITA'' MEDIA PER I CENTRI PER L''IMPIEGO - ADESIONE A CONVENZIONE CONSIP. CIG CONSIP 6510969D94  - CIG DERIVATO 7254942787. (U.I. EURO 37.712,64)','32','CMTO','FAC',to_timestamp('27/10/2017','dd/MM/yyyy'), to_timestamp('27/11/2018','dd/MM/yyyy'), to_timestamp('05/12/2017','dd/MM/yyyy')), 
(2018,28491,'PRENOTAZIONE IMPEGNO DI SPESA PER LA FORNITURA DI ENERGIA  ELETTRICA FUORI CONVENZIONE PER L''ANNO 2019. (U.PR. EURO 31.400,00)','32','CMTO','FAC',to_timestamp('27/11/2018','dd/MM/yyyy'), to_timestamp('03/10/2018','dd/MM/yyyy'), to_timestamp('27/12/2018','dd/MM/yyyy')), 
(2017,28496,'FORNITURA DI GAS NATURALE SUL MERCATO LIBERO. ADESIONE ALLA CONVENZIONE FORNITURA DI GAS NATURALE 9 TRA CONSIP S.P.A. E     ENERGETIC S.P.A. AGGIUDICATARIA DEL LOTTO 1. AFFIDAMENTO A  ENERGETIC S.P.A. CIG CONSIP 6644186BBA CIG DERIVATO 72581162CD. (U.PR. EURO 220.000,00)','32','CMTO','FAC',to_timestamp('30/10/2017','dd/MM/yyyy'), to_timestamp('20/12/2018','dd/MM/yyyy'), to_timestamp('07/11/2017','dd/MM/yyyy')), 
(2018,28541,'PRENOTAZIONE IMPEGNO DI SPESA PER LA FORNITURA DI GAS METANO FUORI CONVENZIONE PER L''ANNO 2019. (U.PR. EURO 11.100,00)','32','CMTO','FAC',to_timestamp('27/11/2018','dd/MM/yyyy'), to_timestamp('03/10/2018','dd/MM/yyyy'), to_timestamp('11/12/2018','dd/MM/yyyy')), 
(2017,28579,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI DELLA ZONA TERRITORIALE 1A. AFFIDAMENTO LAVORI SUPPLEMENTARI A EDILMAR SRL. PROG. LLPP N. 27657/2017. CIG. ZCD2090E2E (U.I. EURO 40.272,07 - U.PR. EURO 928,09)','32','CMTO','HE4',to_timestamp('02/11/2017','dd/MM/yyyy'), to_timestamp('11/04/2016','dd/MM/yyyy'), to_timestamp('13/11/2017','dd/MM/yyyy')), 
(2017,28581,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI DELLA ZONA TERRITORIALE 1B. AFFIDAMENTO LAVORI SUPPLEMENTARI A IMEG SRL. PROG. LLPP N. 27656/2017. CIG. ZD62090EA5 (U.I. EURO 40.276,85 - U.PR. EURO 899,22)','32','CMTO','HE4',to_timestamp('02/11/2017','dd/MM/yyyy'), to_timestamp('19/06/2018','dd/MM/yyyy'), to_timestamp('13/11/2017','dd/MM/yyyy')), 
(2018,28652,'PIANO DI INTERV. TRIENNALE DI MANUTENZ. ORDIN. DI MODESTA ENTITA'' DELLE SP DI COMPETENZA DEL SERV. VIABILITA'' 3. LOTTO 3. U.O. 9- ZONA OMOG. 7-CIRIACESE E VALLI DI LANZO E 8- CANAVESE OCCIDENTALE (PROG. 3317/2018-CIG 7567028D09). PR. APERTA. APPR. OPER. DI GARA E AGG. DEFIN. A DITTA CITRINITI GEOM. MASSIMO.(U.S E. 197.640,00)','32','CMTO','HE9',to_timestamp('29/11/2018','dd/MM/yyyy'), to_timestamp('06/03/2019','dd/MM/yyyy'), to_timestamp('12/12/2018','dd/MM/yyyy')), 
(2018,28694,'IIS MICHELE BUNIVA SEDE DI VIA DEI ROCHIS 25, PINEROLO (TO)-LICEO PORPORATO,SEDE, DI VIA BRIGNONE 2 PINEROLO (TO).ESECUZIONE DI PROVE SUI MATERIALI STRUTTURALI FINALIZZATE ALLA VERIFICA DI  VULNERABILITA'' SISMICA.APPROVAZ.E AFFIDAMENTO LAVORI ALL''IMPRESA  P.Q.R.S. SRL  (CIG ZF52608A0B)          (U.I. EURO 28.871,06)','32','CMTO','HE4',to_timestamp('29/11/2018','dd/MM/yyyy'), to_timestamp('29/11/2018','dd/MM/yyyy'), to_timestamp('18/12/2018','dd/MM/yyyy')), 
(2018,29058,'SERV. DI MANUT. DEL VERDE A RIDOTTO IMPATTO AMBIENTALE NEGLI EDIFICI SEDI DI UFFICI DI COMPETENZA DELL''ENTE, PER IL PERIODO 2^  SEMESTRE 2018 - ANNO 2019 - ANNO 2020. AFFIDAMENTO MEDIANTE RDO SUL MEPA, EX ART. 36, COMMA 2, LETT. B) DEL D.LGS. 50/2016 E  S.M.I. A G.R.V. SRL. CIG 76690983E0. (U./PR. 71.987,83)','32','CMTO','FA3',to_timestamp('03/12/2018','dd/MM/yyyy'), to_timestamp('23/11/2017','dd/MM/yyyy'), to_timestamp('13/12/2018','dd/MM/yyyy')), 
(2018,29068,'RIMBORSO SPESE CARBURANTE DELLE GUARDIE ECOLOGICHE VOLONTARIE. I SEMESTRE 2018. (U.I. EURO 14.429,,45).','32','CMTO','IAG',to_timestamp('04/12/2018','dd/MM/yyyy'), to_timestamp('17/10/2019','dd/MM/yyyy'), to_timestamp('19/12/2018','dd/MM/yyyy')), 
(2018,29360,'PIANO INTEGRATO TERRITORIALE ALCOTRA LE ALTI VALLI - CUORE DELLE ALPI. AFFIDAMENTO SERVIZIO DI ASSISTENZA TECNICA PER IL PERIODO 2019-2022 PREVIA TRATTATIVA DIRETTA MEPA A BUSINESS DEVELOPMENT MANAGEMENT S.R.L. - CIG. Z7F261C458 (E.A./UI 2019-20 EURO 12.600,00/ U.I. 2021-22 EURO 10.399,44=)','32','CMTO','AAA',to_timestamp('10/12/2018','dd/MM/yyyy'), to_timestamp('22/12/2017','dd/MM/yyyy'), to_timestamp('28/12/2018','dd/MM/yyyy')), 
(2018,29545,'ACCORDO QUADRO PER IL SERVIZIO DI RIPARAZIONI MECCANICHE ELETTRI CHE ED ELETTRONICHE DI AUTOCARRI DI MASSA INF. 35 QUINTALI AFFIDAMENTO ALLA DITTA AUTORIPARAZIONI NATALE SRL CIG 7550508C4D (U.PR EURO 100.000,00)','32','CMTO','HE0',to_timestamp('12/12/2018','dd/MM/yyyy'), to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('20/12/2018','dd/MM/yyyy')), 
(2018,30874,'NOLEGGIO FOTOCOPIATORI OLIVETTI D-COPIA 5000MF CONSIP 26 LOTTO 3 PRODUTTIVITA'' MEDIA - CIG DERIVATO 725470866D. REIMPUTAZIONE IMPEGNI ANNO 2021. (U.I. EURO 40.992,00).','32','CMTO','FAC',to_timestamp('20/12/2018','dd/MM/yyyy'), to_timestamp('12/12/2018','dd/MM/yyyy'), to_timestamp('28/12/2018','dd/MM/yyyy')), 
(2018,30876,'NOLEGGIO FOTOCOPIATORI OLIVETTI D-COPIA 5000MF PRODUTTIVITA'' BASSA CONSIP 26 LOTTO 3 - REIMPUTAZIONE IMPEGNI ANNO 2021. CIG DERIVATO 7254788871. (U.I. EURO 5.709,96).','32','CMTO','FAC',to_timestamp('20/12/2018','dd/MM/yyyy'), to_timestamp('14/12/2017','dd/MM/yyyy'), to_timestamp('28/12/2018','dd/MM/yyyy')), 
(2017,30885,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI  DELLA ZONA TERRITORIALE 3A. AFFIDAMENTO LAVORI SUPPLEMENTARI ALLA IMPRESA L''ARCOBALENO DI BOFFA ANGELO.  PROG. LL.PP. N. 27651/2017 - CIG Z9020A5BC4 (U.I. EURO 41.541,00 - U.PR. EURO 912,19)','32','CMTO','HE5',to_timestamp('07/11/2017','dd/MM/yyyy'), to_timestamp('01/12/2014','dd/MM/yyyy'), to_timestamp('14/11/2017','dd/MM/yyyy')), 
(2017,30886,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI  DELLA ZONA TERRITORIALE 2B. AFFIDAMENTO LAVORI SUPPLEMENTARI A C.S.G. COSTRUZIONI S.R.L. PROG. LL.PP. N. 27652/2017 -  CIG ZDA20A38CE (U.I. EURO 39.339,78 - U.PR. 899,17)','32','CMTO','HE5',to_timestamp('07/11/2017','dd/MM/yyyy'), to_timestamp('29/07/2015','dd/MM/yyyy'), to_timestamp('14/11/2017','dd/MM/yyyy')), 
(2017,31041,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI  DELLA ZONA TERRITORIALE 3B. AFFIDAMENTO LAVORI SUPPLEMENTARI A FLORIO PIETRO S.R.L.. PROG. LL.PP. 27650/2017. CIG Z6D20B581E (U.I. EURO 39.528,00=, U.PR. EURO 909,96=)','32','CMTO','HE5',to_timestamp('10/11/2017','dd/MM/yyyy'), to_timestamp('11/12/2015','dd/MM/yyyy'), to_timestamp('16/11/2017','dd/MM/yyyy')), 
(2017,31851,'NOLEGGIO ATTREZZATURE D''UFFICIO PRODUTTIVITA'' MEDIA PER I  SERVIZI DELLA CITTA'' METROPOLITANA DI TORINO - IMPEGNI ANNI 2018  E 2019 - CIG DERIVATO 725470866D. (U.I. EURO 81.894,00).','32','CMTO','FAC',to_timestamp('23/11/2017','dd/MM/yyyy'), to_timestamp('20/12/2018','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,31852,'NOLEGGIO ATTREZZATURE D''UFFICIO PRODUTTIVITA'' BASSA PER I SERVIZI DELLA CITTA'' METROPOLITANA DI TORINO - IMPEGNI ANNI 2018 E 2019. CIG DERIVATO 7254788871. (U.I. EURO 11.419,92).','32','CMTO','FAC',to_timestamp('23/11/2017','dd/MM/yyyy'), to_timestamp('21/11/2013','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,32383,'ABBONAMENTI E SPAZI INFORMATIVI SU TESTATE GIORNALISTICHE NAZIONA LI E LOCALI.  AFFIDAMENTI VARI.   (U.I. EURO 3615,01.=)','32','CMTO','AA7',to_timestamp('30/11/2017','dd/MM/yyyy'), to_timestamp('12/11/2018','dd/MM/yyyy'), to_timestamp('27/12/2017','dd/MM/yyyy')), 
(2016,34052,'DETERMINAZIONE A CONTRARRE PER L''AFFIDAMENTO DEL  SERVIZIO DI PULIZIA, RETTIFICA E TARATURA ATTREZZATURE AD AZIMUT PIEMONTE  SRL.  CIG Z8A1C5BC12 (U.I. 707,60)','32','CMTO','HE0',to_timestamp('05/12/2016','dd/MM/yyyy'), to_timestamp('13/07/2018','dd/MM/yyyy'), to_timestamp('27/12/2016','dd/MM/yyyy')), 
(2016,34164,'PRENOTAZIONE IMPEGNO DI SPESA PER LA FORNITURA DI GAS METANO FUORI CONVENZIONE PER L''ANNO 2017. (U. PR. EURO 9.000.00)','32','CMTO','FAC',to_timestamp('06/12/2016','dd/MM/yyyy'), to_timestamp('27/11/2018','dd/MM/yyyy'), to_timestamp('31/01/2017','dd/MM/yyyy')), 
(2016,34953,'OPPOSIZIONE A DECRETO INGIUNTIVO ESECUTIVO EMESSO DAL TRIBUNALE  DI TORINO IN FAVORE DELL''AZ.FERROGLIO PAOLA, ESERCENTE ATTIVITA''  DI COLTIVAZIONI AGRICOLE NEL PARCO REGIONALE LA MANDRIA (R.G. N. 33621/14) - IMPEGNO FONDO SPESE A FAVORE DEL CTU, COME DA  ASSEGNAZIONE DEL GIUDICE (E.A./U.I. EURO 761,28)','32','CMTO','MD7',to_timestamp('19/12/2016','dd/MM/yyyy'), to_timestamp('02/12/2019','dd/MM/yyyy'), to_timestamp('29/12/2016','dd/MM/yyyy')), 
(2017,35281,'SERVIZI INVERNALI ED ESTIVI SULLA RETE STRADALE DI COMPETENZA DELLA CITTA'' METROPOLITANA. STAGIONI 2017-2018, 2018-2019,  2019-2020, 2020-2021. BANDO N. 1. LOTTI 2.04, 2.05, 2.06, 2.19,  2.20, 2.21, 3.10, 3.11, 3.22, 3.24. PROCEDURE APERTE.  AGGIUDICAZIONI DEFINITIVE (U.I. 2.202.027,45)','32','CMTO','HE2',to_timestamp('14/12/2017','dd/MM/yyyy'), to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('28/12/2017','dd/MM/yyyy')), 
(2016,35379,'FORMAZIONE OBBLIGATORIA IN MATERIA DI SALUTE E SICUREZZA NEI NEI LUOGHI DI LAVORO - CONVENZIONE CONSIP - RTI EXITONE S.P.A., STUDIO ALFA S.R.L. - AFFIDAMENTO (CIG DERIVATO 6925766AE5). IMPEGNO DI SPESA  (U.I. EURO 23.595,00).','32','CMTO','DA3',to_timestamp('23/12/2016','dd/MM/yyyy'), to_timestamp('02/05/2018','dd/MM/yyyy'), to_timestamp('30/12/2016','dd/MM/yyyy')), 
(2017,35479,'COMMISSIONE PROVINCIALE ESPROPRI. GETTONI DI PRESENZA DEI COMPONENTI - COSTITUZIONE FONDO -  PRENOTAZIONE DI SPESA PER L''ANNO 2017. (U.PR. EURO 781,20=)','32','CMTO','BA2',to_timestamp('14/12/2017','dd/MM/yyyy'), to_timestamp('26/04/2018','dd/MM/yyyy'), to_timestamp('27/12/2017','dd/MM/yyyy')), 
(2016,35545,'SERVIZI INVERNALI STAGIONE 2016- 2017 INTEGRAZIONE (U.I. EURO 717289,81) (U.PR. EURO 912769,00)','32','CMTO','HE0',to_timestamp('28/12/2016','dd/MM/yyyy'), to_timestamp('01/10/2018','dd/MM/yyyy'), to_timestamp('01/02/2017','dd/MM/yyyy')), 
(2016,35668,'PROCEDURA NEGOZIATA PER INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI DELLA ZONA TERRITORIALE 2B. PROGETTO N. 30559/2016 (CIG 68724068D5) AGGIUDICAZIONE DEFINITIVA A C.S.G. COSTRUZIONI SRL. (U.PR. EURO 78.679,56=   ECO. EURO 31.120,44=)','32','CMTO','HE5',to_timestamp('29/12/2016','dd/MM/yyyy'), to_timestamp('24/10/2008','dd/MM/yyyy'), to_timestamp('30/12/2016','dd/MM/yyyy')), 
(2016,35674,'PROCEDURA NEGOZIATA PER INTERVENTI DI MANUTENZIONE ORDINARIA  PRESSO EDIFICI SCOLASTICI DELLA ZONA TERRITORIALE 3A. PROGETTO 30560/2016 (CIG 6872470DA4) AGGIUDICAZIONE DEFINITIVA A L''ARCOBALENO DI BOFFA ANGELO. (U.PR. EURO 83.184,08=  ECO. EURO 27.561,27=)','32','CMTO','HE5',to_timestamp('29/12/2016','dd/MM/yyyy'), to_timestamp('12/10/2011','dd/MM/yyyy'), to_timestamp('30/12/2016','dd/MM/yyyy')), 
(2016,35675,'PROCEDURA NEGOZIATA PER INTERVENTI DI MANUTEZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI DELLA ZONA TERRITORIALE 3B. PROGETTO N. 30561/2016 (CIG 6872492FCB) AGGIUDICAZIONE DEFINITIVA A FLORIO PIETRO SRL. (U.PR. EURO 79.057,85=  ECO. EURO 31.962,15=)','32','CMTO','HE5',to_timestamp('29/12/2016','dd/MM/yyyy'), to_timestamp('03/12/2013','dd/MM/yyyy'), to_timestamp('30/12/2016','dd/MM/yyyy')), 
(2017,35709,'LAVORI DI MANUTENZIONE DEL GUADO SUL TORRENTE PELLICE. SP 152 DI ZUCCHEA. AFFIDAMENTO ALL''IMPRESA PASCHETTO F.LLI S.N.C. (LL.PP. N. 32140/2017 - CUP J66G17000400003 - CIG Z7A212CAB6) (U.I. EURO 29.706,23 - U.PR. EURO 409,91)','32','CMTO','HE8',to_timestamp('18/12/2017','dd/MM/yyyy'), to_timestamp('11/04/2018','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,36107,'PRESTAZIONI SANITARIE A CARICO DELLA CITTA'' METROPOLITANA DI TORINO PER L''ANNO 2018. (U.PR. EURO 4.900,00)','32','CMTO','DA6',to_timestamp('22/12/2017','dd/MM/yyyy'), to_timestamp('11/06/2018','dd/MM/yyyy'), to_timestamp('16/01/2018','dd/MM/yyyy')), 
(2017,36229,'SERVIZI FINALIZZATI ALLA MANUTENZIONE DELLE ATTREZZATURE IN  DOTAZIONE ALLA VIABILITA'' 1. ANNO 2017. (U.I. EURO 15.000,00)','32','CMTO','HE7',to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('08/08/2018','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,36232,'ACQUISTO DI BENI FINALIZZATI ALLA MANUTENZIONE ORDINARIA  DELLE STRADE. IN DOTAZIONE ALLA VIABILITA'' 1. (U.I. EURO 15.000,00)','32','CMTO','HE7',to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('10/07/2017','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,36241,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI  DEL SERVIZIO EDILIZIA SCOLASTICA 1. LOTTO 1 ZONE 1A E 1B. AGGIUDI CAZIONE DEFINIT. A SEGUITO PROC. NEG. A GI.MA SAS DI MANGIARACINA A. E C. E REIMPUT. SPESA (PROG. LL.PP. 30996/17 CIG 728480399A).  U.I. EURO 117.025,17 U. PR. EURO 7.780,51.','32','CMTO','HE4',to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('02/07/2018','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,36244,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI  DEL SERVIZIO EDILIZIA SCOLASTICA 1. LOTTO 2 ZONE 4A E 4B. AGGIUDI CAZIONE DEFINIT. A SEGUITO DI PROC. NEG. EDILMAVI TORINO SRL E  REIMPUTAZIONE DELLA SPESA (PROG. LL.PP. 30996/17 CIG 72848608A4) U.I. EURO 122.643,08 U. PR. EURO 2.683,56.','32','CMTO','HE4',to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('03/10/2018','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,36707,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI DEL SERVIZIO EDILIZIA SCOLASTICA 2. LOTTO 1. ZONE TERRITORIALI 2A E 2B. PROCEDURA APERTA. AGGIUDICAZIONE DEFINITIVA A ICEF SRL E REIMPUTAZIONE DELLA SPESA. (PROG. LL.PP. 30944/17 CIG 7286760892) U.I. EURO 154.399,95 U.PR. EURO 7.017,00 ECO. EURO 55.440,05','32','CMTO','HE5',to_timestamp('29/12/2017','dd/MM/yyyy'), to_timestamp('16/02/2016','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2017,36709,'INTERVENTI DI MANUTENZIONE ORDINARIA PRESSO EDIFICI SCOLASTICI DEL SERVIZIO EDILIZIA SCOLASTICA 2. LOTTO 2. ZONE TERRITORIALI 3A E 3B. PROCEDURA APERTA. AGGIUDICAZIONE DEFINITIVA A CO.GE.CA. SRL E REIMPUTAZIONE DELLA SPESA (PROG. LL.PP.30944/17 CIG 728679771B) U.I. EURO 160.280,46 U.PR. EURO 3.497,74 ECO. EURO 53.081,80','32','CMTO','HE5',to_timestamp('29/12/2017','dd/MM/yyyy'), to_timestamp('15/02/2017','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy')), 
(2011,37104,'TRASFERIMENTI DALLA REGIONE PIEMONTE E DALLA PROVINCIA DI CUNEO.  ACCERTAMENTO E IMPEGNO EX ART. 183 COMMA V D.LGS. 267/00  (E/A  EURO 91.860,22 - U.I. EURO 91.860,22 - E/R  EURO 22.147,72  E.A. EU 2.442.837,00 - U.I. EU 2.442.837,00 U.S. EU 2.410.811,92)','32','CMTO','IA8',to_timestamp('12/10/2011','dd/MM/yyyy'), to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('25/11/2011','dd/MM/yyyy')), 
(2015,37530,'RIDUZIONE E REIMPUTAZIONE DI MOVIMENTI CONTABILI RELATIVI A LAVO- RI VARI DEL SERVIZIO LOGISTICA A SEGUITO DELLA QUARTA VARIAZIONE  DI BILANCIO .  - U.I   EURO 74.776,44)','32','CMTO','FA3',to_timestamp('13/11/2015','dd/MM/yyyy'), to_timestamp('15/06/2018','dd/MM/yyyy'), to_timestamp('31/12/2015','dd/MM/yyyy')), 
(2015,42566,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLA COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/2/2002 E DALLA  D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/05/20104. SECONDO  IMPEGNO DI SPESA PER L''ANNO 2015. (U./I. EURO 5.216,28)','32','CMTO','IA8',to_timestamp('11/12/2015','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy'), to_timestamp('28/12/2015','dd/MM/yyyy')), 
(2014,46183,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE  DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/2/02 E DALLA D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/5/2004. RIDUZIONE OPERAZIONI  CONTABILI ED IMPEGNI DI SPESA PER COMMISSIONI ANNO 2015. (U./S. EURO 3.087,56)','32','CMTO','IA8',to_timestamp('01/12/2014','dd/MM/yyyy'), to_timestamp('10/12/2019','dd/MM/yyyy'), to_timestamp('31/12/2014','dd/MM/yyyy')), 
(2013,49488,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/02/2002 E DALLA  D.G.R. DELLA REGIONE PIEMONTE N.30 DEL 21/05/2004. ANNO 2014. (U.S. EURO 4.524,00)','32','CMTO','IA8',to_timestamp('03/12/2013','dd/MM/yyyy'), to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('31/12/2013','dd/MM/yyyy')), 
(2008,53561,'ESAMI PER L''ACCERTAMENTO DELL''IDONEITA'' PROFESSIONALE IN  ATTUAZIONE DELL''ART. 105, III COMMA, LETTERE C) E G) DEL D.LGS. 31 MARZO 1998 N. 112. ( E/A EURO 10.000,00 - E/R EURO 7.039,38 - U/I EURO 10.000,00)','32','CMTO','IA8',to_timestamp('24/10/2008','dd/MM/yyyy'), to_timestamp('14/03/2019','dd/MM/yyyy'), to_timestamp('19/11/2008','dd/MM/yyyy')),
(2019,2501,'PRESTAZIONI SANITARIE A CARICO DELLA CITTA'' METROPOLITANA DI  TORINO PER L''ANNO 2019. PRENOTAZIONE DI SPESA. (U.PR. EURO 4.900,00)','32','CMTO','QA42',to_timestamp('07/03/2019','dd/MM/yyyy'), to_timestamp('14/06/2019','dd/MM/yyyy'), to_timestamp('19/03/2019','dd/MM/yyyy')),
(2019,11255,'AFFIDAMENTO TRIENNALE DEL SERVIZIO DI MEDICO COMPETENTE DELLA CITTA'' METROPOLITANA DI TORINO AI SENSI DEL D. LGS. 81/08 E  S.M.I.. INDIVIDUAZIONE MODALITA'' DI GARA.APPROVAZIONE ELABORATI  ALLEGATI  E PRENOTAZIONE SPESA ANNI 2021-2022. (U. PR 210.432.50)','32','CMTO','QA42',to_timestamp('18/10/2019','dd/MM/yyyy'), to_timestamp('08/08/2019','dd/MM/yyyy'), to_timestamp('22/10/2019','dd/MM/yyyy')),
(2019,13995,'AFFIDAM. TRIEN. SERV DI MEDICO COMPET DELLA CITTA'' METROP. DI TO  EX D.LGS. 81/08 E S.M.I. E CONT. PR. TEC. ALL''A.O.U. CITTA'' DELLA SALUTE E DELLA SCIENZA DI TO (PER.  1/1-31/3/20220). INDIV. MOD.  GARA, AP. EL. ALL,, RID, IMP. E PRENOT. SPESA PER. 1/1/20-31/3/23 (U.I. EURO 17.536.00) (U.PR. EURO 210.432,50)','32','CMTO','QA42',to_timestamp('11/12/2019','dd/MM/yyyy'), to_timestamp('28/10/2019','dd/MM/yyyy'), to_timestamp('24/12/2019','dd/MM/yyyy')),
(2019,3299,'ACCERTAMENTO RISORSE TRASFERITE DALLA REGIONE PIEMONTE PER  L''INDENNIZZO DEI DANNI ARRECATI DALLA FAUNA SELVATICA ALLE  COLTURE AGRICOLE NELLE AREE PROTETTE REGIONALI (E.A./U.PR EURO 21.152,00)','32','CMTO','SA02',to_timestamp('25/03/2019','dd/MM/yyyy'), to_timestamp('22/07/2019','dd/MM/yyyy'), to_timestamp('12/04/2019','dd/MM/yyyy')),
(2019,10137,'COMMISSIONE ESAMINATRICE PER IL RILASCIO DELL''AUTORIZZAZIONE ALL''ALLEVAMENTO DI FAUNA SELVATICA A SCOPO ORNAMENTALE E  AMATORIALE PER FINI ANCHE RIPRODUTTIVI. PRENOTAZIONE DI SPESA PER LA CORRESPONSIONE DEL GETTONE DI PRESENZA AI COMPONENTI ESTERNI - ANNO 2019  (U. PR. EURO 97,65)','32','CMTO','SA02',to_timestamp('25/09/2019','dd/MM/yyyy'), to_timestamp('23/07/2019','dd/MM/yyyy'), to_timestamp('14/10/2019','dd/MM/yyyy')),
(2019,13773,'VERIFICHE PERITALI PER L''ACCERTAMENTO E VALUTAZIONE DEI  DANNI ARRECATI DALLA FAUNA SELVATICA ALLE COLTURE AGRICOLE E AI PASCOLI NELLE ZONE SOTTOPOSTE A TUTELA FAUNISTICA DEL TERRITORIO METRO- POLITANO (U.I. EURO 22.399,20)- E.A./E.R. EURO 3324,69','32','CMTO','SA02',to_timestamp('06/12/2019','dd/MM/yyyy'), to_timestamp('06/08/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy')),
(2019,13851,'RICONOSCIMENTO GETTONE DI PRESENZA AI COMPONENTI ESTERNI DELLA  COMMISSIONE D''ESAME PER IL RILASCIO DELL''AUTORIZZAZIONE ALL''ALLE- VAMENTO DI FAUNA SELVATICA A SCOPO ORNAMENTALE E AMATORIALE PER FINI ANCHE RIPRODUTTIVI (U.S-UI   EURO 65,10)','32','CMTO','SA02',to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('10/09/2019','dd/MM/yyyy'), to_timestamp('17/12/2019','dd/MM/yyyy')),
(2019,13881,'SERVIZIO DI RECUPERO DI CAPI DI FAUNA SELVATICA RINVENUTI FERITI  O IN STATO DI DIFFICOLTA'' SUL TERRITORIO METROPOLITANO. APPROVA- ZIONE SCHEMA DI INTESA CON IL DIPARTIMENTO DI SCIENZE VETERI- NARIE DELL''UNIVERSITA'' DEGLI STUDI DI TORINO (U.I.  EURO 43.554,00)','32','CMTO','SA02',to_timestamp('09/12/2019','dd/MM/yyyy'), to_timestamp('11/09/2019','dd/MM/yyyy'), to_timestamp('20/12/2019','dd/MM/yyyy')),
(2006,94348,'ARGINATURA IN SINISTRA DORA BALTEA A PROTEZIONE DELL''ABITATO DI  MONTALTO DORA NEI COMUNI DI MONTALTO DORA E IVREA. CONFERMA  IMPEGNO DI SPESA E PAGAMENTI  US EURO 350.000,00.= U.L. =151.071,65= (PRAT N 24/2005)','32','CMTO','BA6',to_timestamp('22/03/2006','dd/MM/yyyy'), to_timestamp('11/09/2017','dd/MM/yyyy'), to_timestamp('04/05/2006','dd/MM/yyyy')),
(2013,47874,'CONTRATTI DI MANUTENZIONE ORDINARIA E RIPARATIVA DEGLI EDIFICI DI COMPETENZA PROVINCIALE. APPALTO QUINQUENNALE DEL SERVIZIO ENERGETICO NEGLI EDIFICI DI COMPETENZA PROVINCIALE. INDIRIZZI GENERALI. PROROGA ANNUALE. (U.I. EURO 2.659.864,17.=).','1','CMTO','HC0',to_timestamp('21/11/2013','dd/MM/yyyy'), to_timestamp('21/06/2018','dd/MM/yyyy'), to_timestamp('24/12/2013','dd/MM/yyyy')),
(2019,4154,'PROGRAMMA ALCOTRA 2014-2020.  SERVIZIO DI SUPPORTO ALLA GESTIONE  E RENDICONTAZIONE DEI PROGETTI RISKFOR (N.3824) E RISKGEST  (N. 3845) ALLA DOTT.SSA SUSANNE NILSSON    -    CIG  Z0227E292F (E.A. EURO 15.225,60/U.I. EURO 23.853,44)','32','CMTO','UA1',to_timestamp('12/04/2019','dd/MM/yyyy'), to_timestamp('25/10/2019','dd/MM/yyyy'), to_timestamp('10/05/2019','dd/MM/yyyy')), 
(2019,6125,'PROGRAMMA ALCOTRA 2014-2020  PROGETTO RISK-GEST N. 3845 AFFIDAMENDO DEL SERVIZIO RELATIVO ALLA COSTRUZIONE DI UN PORTALE ON-LINE SULLE INFORMAZIONI STORICHE DI EVENTI IDROGEOLOGICI AL  C.N.R. I.R.P.I.      CIG  ZD028ADE04 (E.A. EURO 38.927,70/U.I. EURO 47.580,00)','32','CMTO','UA1',to_timestamp('03/06/2019','dd/MM/yyyy'), to_timestamp('04/11/2019','dd/MM/yyyy'), to_timestamp('12/06/2019','dd/MM/yyyy')), 
(2019,7307,'PROGRAMMA ALCOTRA-PROGETTORISKGEST N 3845    AFFIDAMENTO DEL SERVIZIO DI SUPPORTO ALLA REDAZIONEDI PIANI DI PROTEZIONE CIVILE PARTECIPATI SU COMUNI PILOTA ALL''ARCH. GIANFRANCO MESSINA CIG Z8928CAB4F    CUP J15B19000930007 (E.A. EURO 49.483,20/U.I. 49.483,20)','32','CMTO','UA1',to_timestamp('03/07/2019','dd/MM/yyyy'), to_timestamp('11/01/2019','dd/MM/yyyy'), to_timestamp('12/08/2019','dd/MM/yyyy')), 
(2019,8171,'PROGRAMMA ALCOTRA  PROGETTO RISK-FOR N.3824     AFFIDAMENTO AL CNR-IRPI DEL SERVIZIO PER LA CREAZIONE DI UNA SCUOLA SU RISCHI NATURALI E PROTEZIONE CIVILE NEI TERRITORI TRANSFRONTALIERI CIG 79882998DE  CUP J15B19000920007  CUI  S01907990012201900099 (E.A. EURO 144.416,26 / U.I. EURO 156.160,00)','32','CMTO','UA1',to_timestamp('24/07/2019','dd/MM/yyyy'), to_timestamp('28/02/2019','dd/MM/yyyy'), to_timestamp('19/08/2019','dd/MM/yyyy')), 
(2019,10577,'PROGRAMMA ALCOTRA - PROGETTO RISKGEST N.3845        AFFIDAMENTO  SERVIZIO DI VALUTAZIONE DELLA RESILIENZA DEI SOGGETTI COINVOLTI  NEI PIANI PARTECIPATI DI PROTEZIONE CIVILE A I.S.I.G. CIG  Z162A006FA     CUP J15B19000930007 (E.A. EURO 18.544,00/U.I. EURO 18.544,00)','32','CMTO','UA1',to_timestamp('07/10/2019','dd/MM/yyyy'), to_timestamp('04/03/2019','dd/MM/yyyy'), to_timestamp('31/10/2019','dd/MM/yyyy')), 
(2019,10579,'PROGRAMMA ALCOTRA . PROGETTO RISKGEST N.3845 AFFIDAMENTO DEL SERVIZIO DI SUPPORTO ALLA REDAZIONE E DIFFUSIONE DEI PIANI DI PROTEZIONE CIVILE A CERVELLI IN AZIONE S.R.L. CIG Z2A29FCCA3   CUP J15B19000930007 (E.A. EURO 18.300,00/U.I. EURO 18.300,00)','32','CMTO','UA1',to_timestamp('07/10/2019','dd/MM/yyyy'), to_timestamp('13/03/2019','dd/MM/yyyy'), to_timestamp('31/10/2019','dd/MM/yyyy')), 
(2019,972,'INDENNITA'' DI PERSENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE DALL''ACCORDO STATO-REGIONI-ENTI LOCALI DEL 14/2/2002 E DALLA D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/5/2004. PRIMO IMPEGNO  DI SPESA PER COMMISSIONI ANNO 2019. ACCERTAMENTO DALLE PROVINCE E VAL D''AOSTA PER ESAMI.(E/A EURO 5.968,82 - U/PR EURO 2.614,54)','32','CMTO','UA2',to_timestamp('24/01/2019','dd/MM/yyyy'), to_timestamp('19/03/2019','dd/MM/yyyy'), to_timestamp('13/03/2019','dd/MM/yyyy')), 
(2019,10904,'INDENNITA'' DI PRESENZA AI COMPONENTI DELLE COMMISSIONI PREVISTE DALL''ACCORDO STATO-REGIONE-ENTI LOCALI DEL 14/02/2002 E DALLA D.G.R. DELLA REGIONE PIEMONTE N. 30 DEL 21/05/2004. ULTERIORE IMPEGNO DI SPESA PER COMMISSIONI ANNO 2019. (U./PR. EURO 1.503,81)','32','CMTO','UA2',to_timestamp('11/10/2019','dd/MM/yyyy'), to_timestamp('23/05/2019','dd/MM/yyyy'), to_timestamp('21/11/2019','dd/MM/yyyy')), 
(2000,85571,'ALLUVIONE NOVEMBRE 1994. NODO IDRAULICO DI IVREA.  OPERE DI SISTEMAZIONE GENERALE IDRAULICA RIO RIBES. ARGINE DI PAVONE, BORGATA MARCHETTI. INTEGRAZIONE ONERI DI ESPROPRIO A SEGUITO DI UTILIZZO DEL RIBASSO D''ASTA, U.S. L. 55.868.213= EURO 28853.52 MUTUO CASSA DD.PP. 4297367','32','CMTO','1241',to_timestamp('10/04/2000','dd/MM/yyyy'), to_timestamp('19/12/2019','dd/MM/yyyy'), to_timestamp('18/04/2000','dd/MM/yyyy')),
(2012,42726,'APPELLO AL CONSIGLIO DI STATO DELLA SIG.RA SILVIA GROSSO AVVERSO LA SENTENZA DEL T.A.R. PIEMONTE N. 323/2012 IN MATERIA DI PROCE- DURA SELETTIVA PER PROGRESSIONE VERTICALE. AUTORIZZAZIONE A RESI- STERE IN GIUDIZIO. AFFIDAMENTO DEL PATROCINIO ALL''AVV. MASSIMO  COLARIZI DEL FORO DI ROMA. (U.I. EURO 5.500,00)','1','CMTO','A12',to_timestamp('06/11/2012','dd/MM/yyyy'), to_timestamp('30/11/2017','dd/MM/yyyy'), to_timestamp('12/11/2012','dd/MM/yyyy')),
(2013,11896,'PROC. PEN. N. 20110/10 R.G. P.M.  - N. 3873/11 R.G. GIP TRIBUNALE DI TORINO PER IPOTESI DI REATO DI CORRUZIONE IN DANNO DELLA  PROVINCIA. AUTORIZZAZIONE ALLA COSTITUZIONE DI PARTE CIVILE. CONFERMA DI AFFIDAMENTO DI PATROCINIO ALL''AVV. ALBERTO MITTONE. (U.I. EURO 27.412,11)','1','CMTO','A12',to_timestamp('02/04/2013','dd/MM/yyyy'), to_timestamp('25/10/2018','dd/MM/yyyy'), to_timestamp('09/04/2013','dd/MM/yyyy')),
(2016,12691,'PRESTAZIONI PROFESSIONALI DI PATROCINIO LEGALE AFFIDATE NEL CORSO DELL''ANNO 2015. IMPEGNO DI SPESA SULL''ESERCIZIO 2016. (U.I. EURO 347.292,26)','32','CMTO','A12',to_timestamp('18/05/2016','dd/MM/yyyy'), to_timestamp('25/10/2018','dd/MM/yyyy'), to_timestamp('07/06/2016','dd/MM/yyyy')),
(2016,24488,'SENTENZA DEL TRIBUNALE DI TORINO N. 5659/09 DEL 21/7/09. PROCEDU- RA ESECUTIVA PER RILASCIO DI ALLOGGIO DI CUSTODIA DELLA CITTA''  METROP. DI TORINO UBICATO PRESSO L''ISTITUTO ALBE STEINER DI TORI- NO. DECRETO DEL SINDACO METROPOLITANO N. 134-7759/16 DEL 14/4/16 INTEGRAZIONE IMPEGNO DI SPESA. (U.I. EURO 550,00)','32','CMTO','A12',to_timestamp('07/09/2016','dd/MM/yyyy'), to_timestamp('25/10/2018','dd/MM/yyyy'), to_timestamp('08/09/2016','dd/MM/yyyy')),
(2016,31042,'AUTORIZZAZIONE ALLA COSTITUZIONE IN GIUDIZIO DELLA CITTA'' METROPOLITANA NELL''APPELLO AL CONSIGLIO DI STATO PROPOSTO DA ATIVA SPA + ALTRI AVVERSO LA SENTENZA DEL TAR PIEMONTE N. 1155/15 (RG 9653/15). MODIFICA IMPEGNO SPESA RELATIVO AI COM- PENSI PROF.LI PER IL LEGALE DOMICILIATARIO. (U.I. EURO 7.295,60)','32','CMTO','A12',to_timestamp('04/11/2016','dd/MM/yyyy'), to_timestamp('10/12/2018','dd/MM/yyyy'), to_timestamp('28/12/2016','dd/MM/yyyy')),
(2016,32699,'RICORSO EX ART. 112 CPA AL CONSIGLIO DI STATO DI ATIVA SPA +  ALTRI PER L''OTTEMPERANZA ALLA SENTENZA N. 2425/16 RELATIVA A PROCEDURA DI DISMISSIONE DELLA QUOTA AZIONARIA DETENUTA DALLA PROVINCIA IN SITAF SPA (RG N. 6801/16). MODIFICA DELL''IM- PEGNO DI SPESA PER IL LEGALE DOMICILIATARIO. (U.I. E. 4.377,36)','32','CMTO','A12',to_timestamp('24/11/2016','dd/MM/yyyy'), to_timestamp('19/02/2015','dd/MM/yyyy'), to_timestamp('28/12/2016','dd/MM/yyyy')),
(2016,33167,'APPELLO AL CONSIGLIO DI STATO NEI CONFRONTI DEI SIG. ALVAZZI DEL FRATE CESARE + ALTRI AVVERSO LA SENTENZA DEL TAR PIEMONTE N. 1640/15 IN RELAZIONE A PROCEDURA ESPROPRIATIVA. ATTO DI LIQUIDAZIONE N. 16-13850/16 DEL 13/6/2016. RE-IMPEGNO DELLA RITENUTA D''ACCONTO. (U.I. EURO 920,00)','32','CMTO','A12',to_timestamp('01/12/2016','dd/MM/yyyy'), to_timestamp('14/12/2017','dd/MM/yyyy'), to_timestamp('28/12/2016','dd/MM/yyyy')),
(2011,3668,'CONTRATTO DI MANUTENZIONE DEGLI EDIFICI SCOLASTICI. PERIODO 01/04/2011-31/12/2013. MOVIMENTI CONTABILI (PROG. 28979/2010, CUP J75D10000090003)','32','CMTO','HC4',to_timestamp('04/02/2011','dd/MM/yyyy'), to_timestamp('29/08/2018','dd/MM/yyyy'), to_timestamp('18/02/2011','dd/MM/yyyy')),
(2007,1441853,'M.O. E M.R. EDIF. PATRIMONIALI DI PROPRIETA''/COMPETENZA PROV.LE- PERIODO 1/1/08-31/12/2010-IMPEGNO DI SPESA FONDO DESTINATO AGLI INCENTIVI SULLA PROG. AI SENSI DELL''ART.18 L.109/94-SERV.PROG. ED ESEC. INTERV. EDILIZIA GENERALE - PROG. 630241/07 - INT. 6 U.I. ESERCIZIO 2008 EURO 3.504,32, ESERCIZIO 2009 EURO 3.504,32','32','CMTO','HC5',to_timestamp('07/12/2007','dd/MM/yyyy'), to_timestamp('21/09/2018','dd/MM/yyyy'), to_timestamp('09/01/2008','dd/MM/yyyy')),
(2008,48153,'M.O. M.R. DEGLI EDIF. PATRIM. DI PROPR/COMP. PROV. PERIODO 1/1/08 -31/12/10-IMPEGNO DI SPESA E FONDO DESTINATO AGLI INCENTIVI SULLA PROGET. AI SENSI DELL''ART. 18 L. 109/94-ANNO 2010 DEL SERV.PROG.  ED ESEC.INTERV.EDILIZIA GENERALE. PROG. 630241/07-INT.1-2-3-4-5-6 U.I. EURO 252.954,40, U.I. EURO 3.504,32','32','CMTO','HC5',to_timestamp('17/09/2008','dd/MM/yyyy'), to_timestamp('12/10/2018','dd/MM/yyyy'), to_timestamp('01/10/2008','dd/MM/yyyy')),
(2011,42916,'CONTRATTO DI MANUNEZIONE DEGLI EDIFICI PATRIMONIALI NON DESTINATI AD UFFICI DELLA PROVINCIA DI PROPRIETA'' E DI COMPETENZA PROV.LE. PERIODO 01/04/2011-31/03/2014. INCENTIVO DI PROGETTAZIONE (PR. 31379/2010, CUP J75D10000070003) (U.I. EURO 588,08   //   U.S. EURO 8.557,92)','32','CMTO','HC5',to_timestamp('23/11/2011','dd/MM/yyyy'), to_timestamp('25/10/2018','dd/MM/yyyy'), to_timestamp('29/12/2011','dd/MM/yyyy')),
(2011,42914,'CONTRATTO DI MANUTENZIONE DEGLI EDIFICI SCOL.CI DI PROPRIETA'' E  COMPETENZA PROV.LE. PERIODO 01/04/2011-30/03/2014. LOTTI 1-4 INCENTIVO DI PROGETTAZIONE (PR. 12653/2011, CUP J75D10000040003)  (U.I. EURO 2.143,20 // U.S. EURO 31.188,00)','32','CMTO','HC7',to_timestamp('23/11/2011','dd/MM/yyyy'), to_timestamp('02/02/2018','dd/MM/yyyy'), to_timestamp('28/12/2011','dd/MM/yyyy')),
(2011,42915,'CONTRATTO DI MANUTENZIONE DEGLI EDIFICI SCOL.CI DI PROPRIETA'' E  COMPETENZA PROV.LE. PERIODO 01/04/2011-30/03/2014, LOTTI 2-3-5. INCENTIVO DI PROGETTAZIONE. (PR. 12655/2011, CUP J75D10000090003)  (UI. EURO 3.941,19   //   U.S. EURO 50.803,89)','32','CMTO','HC8',to_timestamp('23/11/2011','dd/MM/yyyy'), to_timestamp('16/05/2018','dd/MM/yyyy'), to_timestamp('28/12/2011','dd/MM/yyyy')),
(2012,51777,'ISTITUTI SCOLASTICI VARI. AFFIDAMENTO DELL''INCARICO DI PRESTAZIO- NI PROFESSIONALI DI TIPO STRUTTURALE ALL''ING. MARCO GORIA (CIG ZCC0780BE4)  (U.I. EURO 12835,68=)','32','CMTO','HCA',to_timestamp('11/12/2012','dd/MM/yyyy'), to_timestamp('31/10/2018','dd/MM/yyyy'), to_timestamp('28/12/2012','dd/MM/yyyy')),
(2012,51922,'EDIFICI SCOLASTICI VARI. INTERVENTI DI ADEGUAMENTO NORMATIVO A SEGUITO DI PRESCRIZIONI DELL''A.S.L. - LOTTO 1. APPROVAZIONE  PROGETTO DEFINITIVO-ESECUTIVO. (COD. OSS. LL.PP. 46794/2012 PROG. 51895/12-INT. 1-3, CUP J18G12000230003). (U.S. EURO 155.000,00.=).','1','CMTO','HCA',to_timestamp('11/12/2012','dd/MM/yyyy'), to_timestamp('02/11/2017','dd/MM/yyyy'), to_timestamp('21/12/2012','dd/MM/yyyy')),
(2012,51984,'EDIFICI SCOLASTICI VARI. INTERVENTI DI ADEG. NORM. A SEGUITO PRESCR. ASL LOTTO 4. APPROVAZIONE PROGETTO DEFINITIVO-ESECUTIVO (COD. OSS. LL.PP. 46794/2012, PROG. 51941/2012-INT. 1-3, CUP J18G12000230003). (U.S. EURO 150.000,00.=).','1','CMTO','HCA',to_timestamp('12/12/2012','dd/MM/yyyy'), to_timestamp('02/11/2017','dd/MM/yyyy'), to_timestamp('21/12/2012','dd/MM/yyyy')),
(2013,29156,'I.T.A. DALMASSO DI PIANEZZA. APPROVAZIONE E AFFIDAMENTO IN  ECONOMIA ALL''ARPA PIEMONTE - DIPARTIMENTO PROVINCIALE DI  TORINO - CIG Z7E0ABFF84 ( U.S. EURO 3.096,39 )','32','CMTO','HCA',to_timestamp('12/07/2013','dd/MM/yyyy'), to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('23/09/2013','dd/MM/yyyy')),
(2013,37221,'COMPLESSO SCOLASTICO DEL BARROCCHIO, GRUGLIASCO. RIQUALIFICAZIONE ENERGETICA- INTERVENTI DI MESSA IN SICUREZZA SUPERFICI VETRATE ESTERNE. APPROVAZIONE PROGETTO DEFINITIVO ESECUTIVO (PROG. 11148/2013, CUP J28G12000050009) (U.I. EURO 149.353,85  // E.A. EURO 149.836,45)','1','CMTO','HCA',to_timestamp('26/09/2013','dd/MM/yyyy'), to_timestamp('27/12/2017','dd/MM/yyyy'), to_timestamp('30/09/2013','dd/MM/yyyy')),
(2013,42955,'INTERVENTI VARI PRESSO EDIFICI SCOLASTICI DI COMPETENZA. INCENTIVI PER LA PROGETTAZIONE. IMPEGNO DI SPESA RELATIVO AGLI ONERI PREVIDENZIALI E I.R.A.P.  (U.I. EURO 6.373,65)','32','CMTO','HCA',to_timestamp('29/10/2013','dd/MM/yyyy'), to_timestamp('13/07/2018','dd/MM/yyyy'), to_timestamp('18/12/2013','dd/MM/yyyy')),
(2015,7045	,'COMPLESSO SCOLASTICO DEL BAROCCHIO, GRUGLIASCO. RIQUALIFICAZIO-   NE. INTERVENTI DI MESSA IN SICUREZZA SUPERFICI VETRATE. AFFIDA-   MENTO LAVORI IN VARIANTE ALL''IMPRESA TEKSOL DI BARTOLETTI ENZO. (PROG. N. 11148/13 - INT. 1, CUP J28G12000050009, CIG 5540044CEC) (U,S. EURO 18.490,94=)','32','CMTO','HCA',to_timestamp('11/03/2015','dd/MM/yyyy'), to_timestamp('29/11/2018','dd/MM/yyyy'), to_timestamp('20/03/2015','dd/MM/yyyy')),
(2015,37730,'EDIFICI SCOLASTICI VARI. AFFIDAMENTO INCARICO PROF.LE RELATIVAMEN TE ALLA SICUREZZA ANTINCENDIO E PREVENZIONE INCENDI ALLA GAE ENGINEERING SRL IN PERSONA DELL''ING.AMARO. RIDUZIONE E  CONTESTUALE REIMPUTAZIONE DELLA SPESA. (U.PR. EURO 24.868,00)','32','CMTO','HCA',to_timestamp('16/11/2015','dd/MM/yyyy'), to_timestamp('29/12/2016','dd/MM/yyyy'), to_timestamp('22/12/2015','dd/MM/yyyy')),
(2012,52207,'IPSIA COLOMBATTO, TORINO. INTERVENTI DI MANUT. PER CONTROSOFFITTI IMPIANTO DI ILLUMINAZIONE. APPROV. PROGETTO DEFINITIVO-ESECUTIVO (COD. OSS. LL.PP. 46795/2012, PROG. 52204/12-INT.1-4, CUP J15D12000560003). (U.S. EURO 132.000.00.=).','1','CMTO','HCB',to_timestamp('13/12/2012','dd/MM/yyyy'), to_timestamp('29/12/2016','dd/MM/yyyy'), to_timestamp('21/12/2012','dd/MM/yyyy')),
(2014,48015,'SP 197 DEL COLLE DEL LYS. INTERVENTO IN SOMMA URGENZA PER IL RIPRISTINO DELLE CONDIZIONI DI SICUREZZA AL KM 6+800 NEI PRESSI  DELLA FRAZIONE TETTI. (U.I. EURO 45.000,00 - U.S. EURO 44.553,33)','1','CMTO','HD5',to_timestamp('16/12/2014','dd/MM/yyyy'), to_timestamp('29/12/2016','dd/MM/yyyy'), to_timestamp('30/12/2014','dd/MM/yyyy')),
(2013,46541,'INCENTIVO DI PROGETTAZIONE LL.PP. DELIBERAZIONE G.P. N. 506-26969.   (U/I EURO 2.444,72= U/S EURO 7.577,60=)','32','CMTO','HD8',to_timestamp('20/11/2013','dd/MM/yyyy'), to_timestamp('10/07/2017','dd/MM/yyyy'), to_timestamp('24/12/2013','dd/MM/yyyy')),
(2015,3854	,'SERVIZIO DI GESTIONE DEGLI IMPIANTI TECNOLOGICI E DI SICUREZZA  DELLE GALLERIE "CRAVIALE", "TURINA" E "FENESTRELLE" SULLA SP 23  DEL COLLE DEL SESTRIERE. AFFIDAMENTO ALL''ATI TECNOSITAF SPA/ OK GOL SRL. ( CIG Z401322B41) (U/S EURO 46.360,00=)','32','CMTO','HD8',to_timestamp('10/02/2015','dd/MM/yyyy'), to_timestamp('07/11/2017','dd/MM/yyyy'), to_timestamp('19/02/2015','dd/MM/yyyy')),
(2015,12801,'SERVIZIO DI GESTIONE DEGLI IMPIANTI TECNOLOGICI E DI SICUREZZA A  SERVIZIO DELLA GALLERIA DI PINO TORINESE SULLA S.P. N. 10. AFFIDAMENTO ALL''ATI TECNOSITAF SPA/OK GOL SRL. (CIG 6244426758) (U/I EURO 121.390,00=)','32','CMTO','HD8',to_timestamp('05/05/2015','dd/MM/yyyy'), to_timestamp('07/11/2017','dd/MM/yyyy'), to_timestamp('09/06/2015','dd/MM/yyyy')),
(2015,12803,'SERVIZIO DI GESTIONE DEGLI IMPIANTI TECNOLOGICI E DI SICUREZZA  DELLE GALLERIE "CRAVIALE", "TURINA" E "FENESTRELLE" SULLA SP 23 DEL COLLE DEL SESTRIERE. AFFIDAMENTO ALL''ATI TECNOSITAF SPA/ OK  GOL SRL. (CIG 6244208373). (U/I EURO 95.160,00=)','32','CMTO','HD8',to_timestamp('05/05/2015','dd/MM/yyyy'), to_timestamp('10/11/2017','dd/MM/yyyy'), to_timestamp('09/06/2015','dd/MM/yyyy')),
(2015,30230,'SERVIZI INVERNALI STAGIONE 2015- 2016. SERVIZIO A MISURA SGOMBERO NEVE E TRATTAMENTO PREVENTIVO ANTIGELO SULLE STRADE PROVINCIALI. AFFIDAMENTO N. 137 LOTTI. U.PR EURO 494.410,53 ANNO 2015 U.PR EURO 1.665.969,74 ANNO 2016','32','CMTO','HD8',to_timestamp('13/10/2015','dd/MM/yyyy'), to_timestamp('29/12/2017','dd/MM/yyyy'), to_timestamp('16/10/2015','dd/MM/yyyy')),
(2004,288723,'ARGINATURA IN SX DORA B. A PROTEZ. DELL''ABITATO DI MONTALTO DORA  NEI COMUNI DI MONTALTO DORA E IVREA. AFFIDAM. INCARICO PROFESSIO- NALE DI PROGETTAZIONE PRELIMINARE, DEFINITIVA ED ESECUTIVA DELLE  CHIAVICHE E RELAZIONE IDRAULICA E IDROLOGICA GENERALE DEL RIO  BALDANZONE (E.A./U.I. EURO 2.500.000,00= - U.S. EURO 34.365,50=)','1','CMTO','IAA',to_timestamp('12/10/2004','dd/MM/yyyy'), to_timestamp('03/12/2019','dd/MM/yyyy'), to_timestamp('26/10/2004','dd/MM/yyyy')),
(2011,44226,'TERMOVALORIZZATORE DEL GERBIDO.    AGGIORNAMENTO  E COMPLETAMENTO DELLE  CAMPAGNE  DI CARATTERIZZAZIONE  ANTE OPERAM  DELL''AMBIENTE CIRCOSTANTE. CONTRIBUTO AD ARPA PIEMONTE. (U.S. EURO 30.000,00.=).','1','CMTO','LB2',	to_timestamp('30/11/2011','dd/MM/yyyy'), to_timestamp('19/02/2019','dd/MM/yyyy'), to_timestamp('14/12/2011','dd/MM/yyyy')),
(2012,18186,'VALUTAZIONE DI IMPIANTI DI TRATTAMENTO RIFIUTI A TECNOLOGIA  COM- PLESSA ED INNOVATIVA. INTESA CON IL POLITECNICO DI TORINO, DIPARTIMENTO DI SCIENZA  AP- PLICATA E TECNOLOGIA. (U.S. EURO 7.500,00.=).','1','CMTO','LB3',	to_timestamp('04/05/2012','dd/MM/yyyy'), to_timestamp('27/03/2019','dd/MM/yyyy'), to_timestamp('27/11/2012','dd/MM/yyyy'))
) AS tmp(anno, numero, oggetto, tipo, ENTE, settore, data_creazione, data_modifica, data_validita_inizio)
join cpass_d_provvedimento_tipo t on t.provvedimento_tipo_codice = tmp.tipo
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
join cpass.cpass_t_ente en on en.ente_codice = tmp.ente
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_t_provvedimento p
	WHERE p.provvedimento_anno = tmp.anno
	and   p.provvedimento_numero = tmp.numero::VARCHAR
	and   p.provvedimento_tipo_id = t.provvedimento_tipo_id
	and   p.settore_id = ts.settore_id
);



INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, 
settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica, data_creazione, data_cancellazione)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, 
ts1.settore_id, te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM', tmp.data_inizio, tmp.data_fine
FROM (VALUES
('AA','AREA RELAZIONI E COMUNICAZIONE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('BA','AREA ISTITUZIONALE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('DA','AREA RISORSE UMANE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('EA','AREA RISORSE FINANZIARIE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('FA','AREA PATRIMONIO E SERVIZI INTERNI','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('HE','AREA LAVORI PUBBLICI','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('IA','AREA TERRITORIO, TRASPORTI E PROTEZIONE CIVILE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('LB','AREA SVILUPPO SOSTENIBILE E PIANIFICAZIONE AMBIENTALE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('LC','AREA RISORSE IDRICHE E QUALITA'' DELL''ARIA','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03 ','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
('MD','AREA ATTIVITA'' PRODUTTIVE','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-3','YYYY-MM-DD')),
('ND','AREA NON DEFINITA','AR','A50','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-3','YYYY-MM-DD')),
('QA42','QA42','SE','QA','CMTO',TO_TIMESTAMP('2017-02-03 09:14:11','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31 16:11:25''YYYY-MM-DD')),
('SA2','SA2','SE','SA','CMTO',TO_TIMESTAMP('2017-02-03 09:14:11','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31 16:11:25','YYYY-MM-DD')),
('NC','AREA LAVORO E SOLIDARIETA''','DI','A50','CMTO',TO_TIMESTAMP('2017-02-03 ','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD'))
)AS tmp(codice, descrizione,tipo,codice_padre,ente,data_inizio,data_fine)
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

INSERT INTO cpass.cpass_t_settore (settore_id, settore_codice, settore_descrizione, 
settore_padre_id, ente_id, tipo_settore_id, utente_creazione, utente_modifica, data_creazione, data_cancellazione)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.codice), tmp.codice, tmp.descrizione, 
ts1.settore_id, 
te.ente_id, dts.tipo_settore_id, 'SYSTEM', 'SYSTEM', tmp.data_inizio, tmp.data_fine
FROM (VALUES
        ('AA7','COMUNICAZIONE ISTITUZIONALE, INFORMAZIONE E RELAZIONI INTERNE ED ESTERNE','SE','AA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('AAA','RELAZIONI E PROGETTI EUROPEI E INTERNAZIONALI','SE','AA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('BA2','PRESIDENTE E GIUNTA','SE','BA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-3','YYYY-MM-DD')),
        ('BA3','STAFF AL SEGRETARIO GENERALE E DOCUMENTAZIONE','SE','BA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('DA3','SVILUPPO RISORSE UMANE','SE','DA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('DA6','ACQUISIZIONE E GESTIONE RISORSE UMANE, SERVIZI SOCIALI AI DIPENDENTI','SE','DA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('EA3','FINANZE, TRIBUTI E STATISTICA','SE','EA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('EA4','ECONOMATO E LIQUIDITA''','SE','EA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FA3','LOGISTICA','SE','FA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FA5','PATRIMONIO','SE','FA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FAB','SERVIZI GENERALI','SE','FA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('FAC','CQUISTI E PROVVEDITORATO','SE','FA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE0','DIREZIONE AREA LAVORI PUBBLICI','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE2','CONCESSIONI E APPROVVIGIONAMENTI','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE3','IMPIANTI TECONOLOGICI E GESTIONE ENERGIA','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE4','EDILIZIA SCOLASTICA 1','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE5','EDILIZIA SCOLASTICA 2','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE7','VIABILITA'' 1','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE8','VIABILITA'' 2','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03 ','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('HE9','VIABILITA'' 3','SE','HE','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('IA8','TRASPORTI','SE','IA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('IAG','PIANIFICAZIONE E GESTIONE RETE ECOLOGICA E AREE PROTETTE, VIGILANZA AMBIENTALE','SE','IA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-3','YYYY-MM-DD')),
        ('LB7','PINAIFICAZIONE E GESTIONE RIFIUTI, BONIFICHE, SOSTENIBILITA'' AMBIENTALE','SE','LB','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('LC6','DIFESA DEL SUOLO E ATTIVITA'' ESTRATTIVA','SE','LB','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('MD3','PROGRAMMAZIONE ATTIVITA'' PRODUTTIVE E CONCERTAZIONE TERRITORIALE','SE','MD','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('MD4','AGRICOLTURA','SE','MD','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
        ('MD7','TUTELA DELLA FAUNA E DELLA FLORA','SE','MD','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('1241','1241','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('A12','A12','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('BA6','BA6','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HC0','HC0','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HC4','HC4','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HC5','HC5','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HC6','HC6','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HC7','HC7','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HC8','HC8','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HCA','HCA','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HCB','HCB','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HD5','HD5','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('HD8','HD8','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('IAA','IAA','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('LB2','LB2','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('LB3','LB3','SE','ND','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('BA4','ARCHIVIO E PROTOCOLLO GENERALI','SE','BA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('NC0','DIREZIONE AREA LAVORO E SOLIDARIETA'' SOCIALE','SE','NC','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD')),
		('IA9','PROTEZIONE CIVILE','SE','IA','CMTO',TO_TIMESTAMP('2017-02-03','YYYY-MM-DD'),TO_TIMESTAMP('2019-01-31','YYYY-MM-DD'))
)AS tmp(codice, descrizione,tipo,codice_padre,ente,data_inizio,data_fine)
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
