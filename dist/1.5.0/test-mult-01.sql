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

INSERT INTO cpass.CPASS_T_SCHEDULAZIONE_BATCH (ente_id ,ente_codice,nome_job,attivazione,note)
SELECT te.ente_id, tmp.ente_codice, tmp.nome_job, tmp.attivazione, tmp.note
FROM (VALUES
   ('CSI','CSI','STORICO_FILE_DDT',FALSE,'batch storico file ddt')
  ,('CSI','CSI','STORICO_FILE_NSO',FALSE,'batch storico file nso')
) AS tmp (ente ,ente_codice,nome_job,attivazione,note)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.CPASS_T_SCHEDULAZIONE_BATCH current
  WHERE current.ente_codice = tmp.ente_codice
  AND current.nome_job = tmp.nome_job
);

-- pulizia REL errate
-- RUP / MODULO<>PBA
delete from cpass.cpass_r_ruolo_modulo where 
ruolo_id = (select ruolo_id from cpass_d_ruolo where ruolo_codice = 'RUP')
and modulo_id != (select modulo_id from cpass_d_modulo where modulo_codice ='PBA');

-- RUOLO / MODULO MAG
delete from cpass.cpass_r_ruolo_modulo where 
modulo_id = (select modulo_id from cpass_d_modulo where modulo_codice ='MAG');

update cpass.cpass_r_ruolo_modulo set ente_id = (select ente_id from cpass_t_ente where ente_codice = 'CSI') where ente_id is null;

delete from cpass.cpass_r_ruolo_modulo where 
ente_id = (select ente_id from cpass_t_ente where ente_codice = 'CSI')
and modulo_id != (select modulo_id from cpass_d_modulo where modulo_codice ='PBA');

-- refactoring settore
INSERT INTO cpass.cpass_t_settore_indirizzo 
(descrizione,indirizzo ,num_civico,	localita,provincia,cap,contatto,email,telefono,settore_id,data_creazione,utente_creazione,data_modifica,utente_modifica,settore_indirizzo_codice, principale)
SELECT 'SEDE PRINCIPALE',tmp.indirizzo, tmp.num_civico, tmp.localita, tmp.provincia, tmp.cap,tmp.contatto, tmp.email, tmp.telefono,tmp.settore_id::UUID,current_date,'SYSTEM',current_date,'SYSTEM', tmp.settore_indirizzo_codice, true
FROM (VALUES
('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','1784c7d0-3d83-505e-9139-d91b0f927c1c',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','37134f77-61b4-51cd-9d03-ae5b8dc83693',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','3b1b41c0-3204-5a75-86ab-e088de88f3e1',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','426fd6f2-2a0b-5db3-91b0-7de086077a4d',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','45071746-52ca-545e-9e99-f86d0bb9d368',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','65738a46-3772-5d50-918b-5ef22d0fe1ad',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','74a333bd-1a2d-5b27-86bc-ec455bc45c93',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','94ee0796-b9a9-5afc-b7bb-d84825163233',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','ad83e3af-78ee-5834-b002-3d57cd4533d4',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','d1628aaf-e8e0-576f-8bc3-54540f1e14ae',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','e5633485-461c-524d-b753-659810bd1263',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','e8492298-7f03-5b60-a042-7b0e8d937389',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','ee60da54-7f86-5643-b689-b5b9eeab11e4',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','f5e815f6-8033-582c-aab5-ef8b3d4c1539',NULL)
,('corso Unione Sovietica','216','Torino','TO','10100',NULL,NULL,'011168','fd076306-f514-5d4b-b90e-98204109eda4',NULL)
,('Piazza Solferino','22','Torino','TO','10121',NULL,NULL,'0115757111','4d5f6b50-4323-5c23-af1d-a66ab54b9b8d',NULL)
,('Piazza Solferino','22','Torino','TO','10121',NULL,NULL,'0115757111','8a57cef8-2ddb-5a8a-b317-ef27eab38e1e',NULL)
,('Piazza Solferino','22','Torino','TO','10121',NULL,NULL,'0115757111','95fc407e-7f54-5b1b-9ead-67cac3cf5c84',NULL)
,('Piazza Solferino','22','Torino','TO','10121',NULL,NULL,'0115757111','a7315b23-a1c3-5085-a0db-2c9805121839',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0114321111','ca3819cc-5fc3-54fa-9fb3-ec2b528bd19b',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','270bf986-2c63-5673-b3e5-d2662fc6c14c',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','3debb0c4-7628-54dd-acb5-3985271f37b3',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','3e2b2556-79e5-54ed-9fed-6e46e702c4dd',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','69599ba0-d372-54a4-8094-5dcb31efcb42',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','6c5e7caa-b3ae-504b-bd4d-21ea0df88486',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','9d46df41-4ba7-574c-a24d-32818a53a304',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','aa04683c-25fe-5173-a183-7a576cf09051',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','be5b3a81-752f-58a7-82ef-fb9f3ee34105',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','c12b9ab1-9747-5c75-a695-a9c7defc1dd5',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','d608e0fe-27cc-5ffe-98d4-289c44fe6270',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','dcf92a9a-e9ba-58a7-8012-fe0d77f530ca',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','e583ad95-3a20-57c3-bb9c-aa7da11b367f',NULL)
,('Via Alfieri','15','Torino','TO','10121',NULL,NULL,'0115757111','fe2883c7-1107-520b-b938-1fee0ef77854',NULL)
) AS tmp 
(indirizzo ,num_civico,	localita,provincia,cap,contatto,email,telefono,settore_id,settore_indirizzo_codice)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore_indirizzo current
  WHERE current.settore_id = tmp.settore_id::UUID
  AND current.principale = true
);
