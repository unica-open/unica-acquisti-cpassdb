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
-- PROD-CMTO-01
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

INSERT INTO cpass.cpass_t_ente_logo VALUES (1, 'Logo', './image001.png');        



--DA FARE
INSERT INTO cpass.cpass_t_ord_sezione VALUES (2, '100', 'SEZIONE ACQUISTI E PROVVEDITORATO', '0ced449c-a147-5419-802f-01acfab32807', '2021-05-27 00:00:00', 'admin', '2021-05-27 00:00:00', 'admin', NULL, NULL, '9e27ef73-c31e-49e9-89e0-4b46a84ac593', 'bfaa1bf7-c1cb-53dd-80c7-cd4b8d8859aa');

--TODO DA FARE
INSERT INTO cpass.cpass_d_provvedimento_tipo VALUES (1, 'AD', 'Atto Dirigenziale', '0ced449c-a147-5419-802f-01acfab32807');
SELECT pg_catalog.setval('cpass.cpass_d_provvedimento_tipo_provvedimento_tipo_id_seq', 1, true);


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


delete from cpass_t_settore;

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
    ('RA5-1','TUTELA DEL TERRITORIO','FS','RA5','CMTO'),
    ('SA0' ,'DIREZIONE DIPARTIMENTO SVILUPPO ECONOMICO','DL','SA','CMTO'),
    ('SA0-1','PROGETTI E PROGRAMMI EUROPEI ED INTERNAZIONALI','FS','SA0','CMTO'),
    ('SA1','SERVIZI ALLE IMPRESE, SPL E PARTECIPAZIONI','DL','SA','CMTO'),
    ('SA2','ATTIVITA'' PRODUTTIVE','DL','SA','CMTO'),
    ('SA3','SVILUPPO RURALE E MONTANO','DL','SA','CMTO'),
    ('SA3-1','TUTELA FLORA E FAUNA','FS','SA3','CMTO'),
    ('TA0','DIREZIONE DIPARTIMENTO AMBIENTE E VIGILANZA AMBIENTALE','DL','TA','CMTO'),
    ('TA0-1','VALUTAZIONI AMBIENTALI','FS','TA0','CMTO'),     --????
    ('TA1','RIFIUTI, BONIFICHE E SICUREZZA SITI PRODUTTIVI','DL','TA','CMTO'),
    ('TA2','RISORSE IDRICHE E TUTELA DELL''ATMOSFERA','DL','TA','CMTO'),
    ('TA3','SISTEMI NATURALI','DL','TA','CMTO'),
    ('UA0','DIREZIONE DIPARTIMENTO TERRITORIO, EDILIZIA E VIABILITA''','DL','UA','CMTO'),
    ('UA0-1','URBANISTICA E COPIANIFICAZIONE','FS','UA0','CMTO'),
    ('UA3','COORDINAMENTO VIABILITA''-VIABILITA'' 1','DL','UA','CMTO'),
    ('UA4','VIABILITA'' 2','DL','UA','CMTO'),
    ('UA4-1','PROTEZIONE CIVILE','FS','UA4','CMTO'),
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




INSERT INTO cpass.CPASS_T_SETTORE_INDIRIZZO (settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,settore_id,data_creazione,utente_creazione,data_modifica,utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'PRINCIPALE','CORSO INGHILTERRA','7','TORINO','TO','10138',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',true 
from cpass_t_settore where ente_id = (select ente_id from cpass_t_ente where ente_codice = 'CMTO');

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'ABBAZIA DELLA NOVALESA','FRAZIONE SAN PIETRO','SNC','NOVALESA','TO','10050',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',false 
from cpass_t_settore where settore_codice = 'QA3';

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'MAGAZZINO DI STRAMBINO','VIA KENNEDY','14','STRAMBINO','TO','10019',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',false 
from cpass_t_settore where settore_codice = 'UA3';

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'MAGAZZINO STRADALE DI OULX','VIA ORTIGARA','27/B','OULX','TO','10056',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',false 
from cpass_t_settore where settore_codice = 'UA4';

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'MAGAZZINO STRADALE DI CERESOLE','LOCALITA'' PIAN DELLA BALMA','SNC','CERESOLE','TO','10080',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',false 
from cpass_t_settore where settore_codice = 'UA4';

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'MAGAZZINO STRADALE DI CARIGNANO','VIA SALUZZO','20 INT. F','CARIGNANO','TO','10041',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',false 
from cpass_t_settore where settore_codice = 'UA4';

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'MAGAZZINO STRADALE DI VENAUS','FRAZIONE CORNALE','1','VENAUS','TO','10050',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',false 
from cpass_t_settore where settore_codice = 'UA4';

INSERT INTO CPASS_T_SETTORE_INDIRIZZO
(settore_indirizzo_id,descrizione,indirizzo,num_civico,localita,provincia,cap,
settore_id,data_creazione,utente_creazione,data_modifica,
utente_modifica,principale)
SELECT nextval('cpass_t_settore_indirizzo_settore_indirizzo_id_seq'),
'MAGAZZINO STRADALE DI CARMAGNOLA','VIA OMMARIVA','51','CARMAGNOLA','TO','10022',settore_id,
now(), 'SYSTEM',now(), 'SYSTEM',false 
from cpass_t_settore where settore_codice = 'UA4';
---------------------------------


INSERT INTO cpass.cpass_d_oggetti_spesa (oggetti_spesa_codice, oggetti_spesa_descrizione, inventariabile, 
prezzo_unitario, unita_misura_id, cpv_id, aliquote_iva_id, data_validita_inizio, data_creazione, utente_creazione, data_modifica, utente_modifica, 
ente_id, quantita_max_richiedibile, generico)
SELECT tmp.oggetti_spesa_codice, tmp.oggetti_spesa_descrizione, tmp.inventariabile, 
		tmp.prezzo_unitario, dum.unita_misura_id, 
		dc.cpv_id, dai.aliquote_iva_id, now(), now(), 'SYSTEM', now(), 'SYSTEM', '0104678f-99ca-5d99-bb78-7de2605d1aae',tmp.quantita_max_richiedibile, tmp.generico
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


--da capire con cosa sostituire
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
INSERT INTO cpass.cpass_t_parametro VALUES (72, 'WSDL_LOCATION',              'http://stilo.wsbe.comune.torino.it/stilobusiness/soap/WSGetMetadataUd?wsdl', true, 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', '0ced449c-a147-5419-802f-01acfab32807');
INSERT INTO cpass.cpass_t_parametro VALUES (133, 'WSDL_LOCATION_RICERCA_DOC', 'http://stilo.wsbe.comune.torino.it/stilobusiness/soap/WSTrovaDocFolder?wsdl', true, 'PROVVEDIMENTO', 'STILO', 'Per estrazione lista Provvediment1', NULL);
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

cpass_t_ufficio (
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
) 



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
--delete from cpass_t_utente;

INSERT INTO cpass.cpass_t_utente (utente_id, utente_nome, utente_cognome, utente_codice_fiscale, telefono, email, rup, data_creazione, utente_creazione, data_modifica, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.utente_codice_fiscale), tmp.utente_nome, tmp.utente_cognome, tmp.utente_codice_fiscale, tmp.telefono, NULL, tmp.rup, now(), 'SYSTEM', now(), 'SYSTEM'
FROM (VALUES
	('BNDNNN74M19L219J', 'Antonino', 'Benedetto', null,false)
	,('CPNCLD71M25L219I', 'CLAUDIO' , 'CAPONE'   ,null ,false)
	,('TRTSLV63L42L219B', 'SILVIA'  , 'TORTA'    ,null ,false) 
	,('TLLNRT69E56D122C', 'ANNA RITA'  , 'TALLARICO'    ,null ,false) 
) AS tmp(utente_codice_fiscale,utente_cognome,utente_nome, telefono, rup)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_utente')
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_utente current
  WHERE current.utente_codice_fiscale = tmp.utente_codice_fiscale
);

INSERT INTO cpass.cpass_r_utente_settore (utente_id, settore_id)
SELECT tu.utente_id, ts.settore_id
FROM (VALUES
	 ('BNDNNN74M19L219J','QA3')
	,('CPNCLD71M25L219I','QA3')
	,('TRTSLV63L42L219B','QA3') 
	,('TLLNRT69E56D122C','QA3') 
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
	('BNDNNN74M19L219J','QA3','ADMIN_ENTE'),
	('BNDNNN74M19L219J','QA3','ADMIN'),
	('BNDNNN74M19L219J','QA3','GESTORE_STRUTTURA'),
	('BNDNNN74M19L219J','QA3','SMISTATORE_RMS'),
	
	('CPNCLD71M25L219I','QA3','ADMIN_ENTE'),
	('CPNCLD71M25L219I','QA3','ADMIN'),
	('CPNCLD71M25L219I','QA3','GESTORE_STRUTTURA'),
	('CPNCLD71M25L219I','QA3','SMISTATORE_RMS'),
	  
	('TRTSLV63L42L219B','QA3','ADMIN_ENTE'),
	('TRTSLV63L42L219B','QA3','ADMIN'),
	('TRTSLV63L42L219B','QA3','GESTORE_STRUTTURA'),
	('TRTSLV63L42L219B','QA3','SMISTATORE_RMS'),  
	  
	('TLLNRT69E56D122C','QA3','ADMIN_ENTE'),
	('TLLNRT69E56D122C','QA3','ADMIN'),
	('TLLNRT69E56D122C','QA3','GESTORE_STRUTTURA'),
	('TLLNRT69E56D122C','QA3','SMISTATORE_RMS')  
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






INSERT INTO cpass.cpass_r_dirigente_settore VALUES (1, '971d1aa9-f3bb-5393-b20d-1433d9bf51ef', '375dce55-2972-575d-aadb-400b089c6d04', '2021-04-09 08:09:39.792303', NULL);
SELECT pg_catalog.setval('cpass.cpass_r_dirigente_settore_dirigente_settore_id_seq', 1, true);


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
  ('K31IU4', 'TA0-1'),
  ('JTR94E', 'A51'),
  ('JEV1NU', 'SA3'),
  ('H80KJL', 'A53'),
  ('H0MK50', 'QA6'),
  ('GPBI3Z', 'SA2'),
  ('FGWKV6', 'UA5'),
  ('0CWI00', 'SA'),
  ('DJN7N5', 'UA4-1'),
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
  ('422Z7M', 'SA3-1'),
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
	('AAAAAA00A11B000J','A00','ADMIN_ENTE')
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
);-----------------------------------------------------------------------------------------------------------------------

SELECT pg_catalog.setval('cpass.cpass_t_parametro_parametro_id_seq', 139, true);
SELECT pg_catalog.setval('cpass.cpass_t_ufficio_ufficio_id_seq', 30, true);

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

