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
   ('REGP','REGP','STORICO_FILE_DDT',FALSE,'batch storico file ddt')
  ,('REGP','REGP','STORICO_FILE_NSO',FALSE,'batch storico file nso')
  
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

update cpass.cpass_r_ruolo_modulo set ente_id = (select ente_id from cpass_t_ente where ente_codice = 'REGP') where ente_id is null;

INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
    ('WSDL_LOCATION_RICERCA_DOC', @value@, 'PROVVEDIMENTO', 'STILO', 'Per estrazione lista Provvediment1', true)

) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);
--refactoring settore
INSERT INTO cpass.cpass_t_settore_indirizzo 
(descrizione,indirizzo ,num_civico,	localita,provincia,cap,contatto,email,telefono,settore_id,data_creazione,utente_creazione,data_modifica,utente_modifica,settore_indirizzo_codice, principale)
SELECT 'SEDE PRINCIPALE',tmp.indirizzo, tmp.num_civico, tmp.localita, tmp.provincia, tmp.cap,tmp.contatto, tmp.email, tmp.telefono,tmp.settore_id::UUID,current_date,'SYSTEM',current_date,'SYSTEM', tmp.settore_indirizzo_codice, true
FROM (VALUES
('Corso Bolzano','44','Torino','TO','10121',NULL,NULL,'24206','a2f1eaa7-17dd-59db-ad27-d57db6dc0175',NULL)
,('Corso Bolzano','44','Torino','TO','10121',NULL,NULL,'24206','ea0478e8-9634-5a9c-96f1-4a6aadc5a4a8',NULL)
,('CORSO INGHILTERRA','7','Torino','TO','10138',NULL,NULL,'011861','d288bb06-1c8f-5e49-8012-06a774c61626',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','037de602-4788-5698-8f07-3d3cd2c897ad',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','15b861c0-3603-557b-83df-ca0c9462ac81',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','29013793-9e7e-5d58-b580-f84e7e66d231',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','4d741790-947f-520d-97ff-6a29d7b40b03',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','4dbe6d70-ab8b-5d71-ae45-626829869b89',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','5cc7988d-bab7-5d31-bb6a-4759f5cafaee',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','5e9ca03e-fe83-570a-85b1-cd54af0f06a6',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','6a541f2a-1e15-5cf3-9a37-dedb0f480f0b',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','8b4ce7e2-cd13-55fe-912b-9f4ac0968ee6',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','8c04f600-60a2-5077-90f0-5dc96f350a28',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','adc1b760-c632-58e1-a084-bee2a427698d',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','c57feec8-46e6-5ce8-9656-d6aff1aed348',NULL)
,('Corso Regina Margherita','153 bis','Torino','TO','10138',NULL,NULL,'0','c913f5b9-3d4f-5354-8c61-dc6d91c1d748',NULL)
,('Corso Regina Margherita','174','Torino','TO','10138',NULL,NULL,'0','20657b0a-0edc-5dc1-ac60-f813a274ae1f',NULL)
,('Corso Regina Margherita','174','Torino','TO','10138',NULL,NULL,'0','c3b2286d-d29d-5c9a-a83a-2014015df267',NULL)
,('Corso Regina Margherita','174','Torino','TO','10138',NULL,NULL,'0','ee3f44f5-38f5-5ce3-a6a9-66222abc6145',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','01bb7893-bc15-5aa2-a3a8-0a488967cd8c',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','03cb7c5a-e5ce-515a-9a60-72b4d173644d',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','0511ec7c-4c74-5e81-9f02-e39d18fa0bcf',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','054a3075-4c8f-50c4-a07d-098b30cf89cf',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','09669c29-7041-5e0a-bacb-3f6cb3243352',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','0cae2924-08a8-5cf5-87d1-2386c900e3ff',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','0cf96cbd-2ba1-584c-ac55-486dd182b03e',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','0d5e015c-d296-5f77-bf94-b146a52e51a7',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','110ad85a-c0ec-5628-ae51-b09f9af10107',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','2cce5eea-e541-5082-954f-dd143f084d4f',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','42e1e75e-0aa5-5431-bf6d-1c917cf2dda5',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','48b1cd62-163a-54a0-a956-e54bda506c46',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','4e66ed28-a3fb-5a56-9f55-03821172f3e3',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','62c9582e-add2-52aa-8fec-7e1fd075156e',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','6d4a6805-d1be-5b9e-bd87-02d624f46e2b',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','872df0f3-de2d-5dc9-b5df-a48412b4e73d',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','89646b4f-940e-5d27-b062-060671fe62e5',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','8acf3ec2-294e-5836-ad11-4c0925cd44d1',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','b19475a6-fb50-5021-8a35-b549536e0c42',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','b80767f0-6f27-55ca-b536-9ea6ea31baeb',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','11bc6cb4-ebfc-5207-a3bb-f35f3d963437',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','bcdb1859-2a19-5ad8-9506-8b9b6d78f0e3',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','bfdcf2dc-2fe6-565e-8890-b2656ff0eedf',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','d389c3ea-adb1-5e3e-839a-c96075b51cee',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','e5b6f3d6-8d53-5bc0-b035-e8892c6ea3db',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','ee89c114-8118-5f56-976a-e8c49345d852',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','1424b2ea-3f66-50d0-9cba-df306d5abd0a',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','17668540-6d8a-5e20-83ef-7ec6b298f9e5',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','17c88c6a-3735-5f9a-b20b-d508d73aec69',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','1811468d-9ebf-5c97-884c-828dbf2c8459',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','1a5eed94-9b0d-57da-b43d-a04c80c6d7fb',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','1fc33980-d066-543b-9492-c4611f78f035',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','200fdcde-9fce-5d30-8799-9d5ca88d25e1',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','2077a832-6534-511a-aa26-66fb60ba8b21',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','2081872e-af74-557a-b4a1-e6b0dd7d1a47',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','240c164a-1ea8-5f96-91ea-5bafb7367df0',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','270907ed-6421-5d33-92e8-c044bc981fe5',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','2bb4dd33-74e3-533c-afbd-3f17c178fdbc',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','31fc7735-aa42-57c2-952a-da36ec6a9e79',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','34103f59-63ff-546e-88ca-07cd382c7415',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','350f681f-9db7-534a-908b-4fc38b521ebe',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','3583e960-17bd-51a7-a516-f7871455db2d',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','375dce55-2972-575d-aadb-400b089c6d04',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','37c25a1a-7ed3-5ce8-b329-0520bdfbd8b9',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','3b87c9b8-6185-54ad-8198-0463233d8b82',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','450f3893-0e5b-564d-ba25-453f1938d394',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','4747f346-65e2-5ad0-bfbf-01cec8ebbd67',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','4ab2b1ac-b99c-5180-85af-a6f628ffe1c5',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','4e09d73b-0f37-53f7-9711-94c61f9dac5b',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','4e1ab433-360b-5dfc-b8ea-d66bf4050ff1',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','543112b3-46ed-5efe-86dd-948f80dcd742',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','548dd7a3-5798-5e39-aa68-250fb81cccb7',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','55866aa6-77db-54b6-8393-e8d0f3b4b98b',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','58e5ba26-2110-5c77-8ea0-2083625becad',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','5b0afd2c-7089-5681-9a0d-1124662914e7',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','5c3a820a-9562-5bdb-a5b2-e03407691acf',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','602a5d76-28be-5354-9ad5-cd642ca16cdd',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','602d7289-c91f-599e-98c3-0a6e8eb9f4fc',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','618116f6-6ced-57ba-afce-d5b2b81c2e6c',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','62063d16-2572-58ba-bbc3-4f4baf63ffbe',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','626c67fa-07e3-5591-b7a9-25c92b4a8a75',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','63a488a7-32e0-50ab-ad2f-a13c40f9b57e',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','65721609-5714-528f-b403-9672d1b6ac85',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','65f29bb2-b213-582d-ac27-cc9d37b20937',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','6b239f91-9e8b-5e7e-b8c9-ea3ddadf0bdf',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','6e6e6294-c256-5365-bc54-b03144c2e7f3',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','7110b9e2-2f19-5ee4-be32-cd1850e7b308',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','73c29432-6b53-54f9-9472-78bfd114a8b6',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','73fdd1ae-2a3c-56ee-91bc-96858222ea2a',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','746c092e-135a-5915-b94e-8292b325b798',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','75f5e92b-afaa-5fec-bc99-01a93891728b',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','76983574-3cbe-5b8b-8123-c75de2226a64',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','781e0589-43f5-5274-be11-babd0ebff9ea',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','7e460b0b-4400-53a7-966f-2b121e12361d',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','7f8c4960-4a61-502f-973d-9f73670c1171',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','80a4da07-16c0-562d-a723-0a26efc1c6bd',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','81502451-4360-51a8-b53e-90e5aafd5152',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','85043865-0222-5200-8bf1-f93f05e579fa',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','859fe3c6-35aa-5887-bfca-ae0e25319a0c',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','891955c9-91ff-5879-8ce7-c5895067ec81',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','8a5f5261-57a9-5f56-83ab-96e3057e7ac3',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','8c2027dc-8850-56bd-a08a-61077feb96ef',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','8c55a046-c6ac-5dfe-9383-9881db253ab2',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','93ec20b8-1663-5b2b-819e-8312681f0ca1',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','95dab272-5d9f-51e0-a004-6317e84a774c',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','9ad6bc53-dec9-530c-bc11-b9cef5548bba',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','9cb877dc-45c2-5887-95e8-d7396732e348',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','a09afc69-87f7-5313-b8f6-9f5ad4649541',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','a1170084-7d14-5ee3-a968-f769bab21d93',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','a2472ed7-205b-5c82-b497-a90b51d4c60d',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','a2e674b8-35ca-54a1-9c68-c0f51bed3e3e',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','a59c90ba-28bb-5ba4-875c-f8e27035ad58',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','a634b350-747b-5dcf-83d0-d5779f5cfcda',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','a6edeae8-6265-5e68-99fd-86d0f295916d',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','a8310697-a568-5e6c-86e8-7e8d7c4186ba',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','aa74dc12-8e3d-5c11-b9ae-ff1db6ef36c0',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','ae3af64b-82ed-5954-ae8d-f6e7e6829a14',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','ae7c15f8-225c-5caa-bee3-e818bd45609d',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','af54b787-626a-5bc2-a672-272a3546f6f8',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','b1b78f02-a10e-5fe2-8a25-0fe7d50682be',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','b5c19f80-b4c1-5a17-968c-773b0ac1de79',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','b781a89e-764b-5f1b-b990-5ad2b642933d',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','b89245ee-881d-5759-b7cc-bc23adbf4c52',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','b99a400a-3e2d-531a-89ab-e2306409f8c0',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','bbd00409-627c-5a8f-bdbe-1043e905613f',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','bc769fd9-843b-5afb-bd32-c8168e8c399a',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','bfc5b3ca-aa0c-5131-b844-dcbfee285afe',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','c1323ab3-61ce-5d1e-b2bf-9547ef9eb0f9',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','c7d63ead-392a-51cd-a90c-5373ae9d6dcb',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','c90d73b9-2cdc-52a3-ace7-095321d8aee7',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','c9c80586-7948-50e6-b418-91e884daf5c4',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','ca897166-7b63-577e-b289-5f0e54ba898e',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','d1611bfe-228c-5763-81a2-aa5565fff6d0',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','d1f7b706-ed27-5213-abb4-135856e5d0f6',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','d23732c0-f53c-542b-b525-cd6cd1bbd35d',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','d256f0e5-fbd6-5f08-a6d9-f14b93c7dc3b',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','d35f9c1b-b6a0-5cde-ada1-e02bd4c2d0f4',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','d42adc0d-4c80-5160-9f40-5e14c5345e6e',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','d4f730ae-c46b-5654-b5b6-d878f414e812',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','d5fd56aa-a844-58ae-b8d9-aa1f3850233b',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','d7481b8d-a51a-5572-a94f-cc06821a1018',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','d9805aea-d7d6-54f0-8994-d4028eadb8f6',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','da1d6215-742a-54ef-b93f-10c97cca980a',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','da5bf89e-ec24-5d54-93ef-d4c1868eeea2',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','dd908607-350b-5a0b-ae69-4c8784ccf8bf',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','e5c14f20-93f0-55ce-b4d0-788b04477548',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','e6c29f69-4122-5d9c-9806-0d21d9138a44',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','e9dceb94-9b85-5008-a3d8-b35194d0c3d6',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','ea29e965-8309-5156-897b-72b041ffd75e',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','eaaafebe-7345-5689-82f6-a82b16c22614',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','eeb50163-649c-551a-95f7-2cd5ca23ef61',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','ef40c617-5658-591f-a93e-731312db5e3d',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','f04717f5-8a68-59da-bf9f-af6955d166f3',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','f259fc7e-aecf-5150-b833-9eee2f61990e',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','f42412b9-95c7-5f8b-81f3-8faf7875bb4e',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','f7d87319-7831-55c7-895e-6f32d2e06db8',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','f8724813-9940-5a92-89d0-d0bfc0ea5fac',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','fc1785a9-b516-53ce-9e63-6f16f626214b',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','fc7bf5d7-c68c-5b9b-ae0c-af74495311d2',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','fd7a31f4-30aa-53d0-a0e5-7c2bef4c41fc',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','fdd8ec34-a4fa-5111-ac1f-a24467d92ed4',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','fe506533-aed3-557e-9740-af2ef0314f26',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','ffdd00ba-ca2b-598f-b010-8c9c585aec56',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'12345','8a239b3b-ed15-5bd0-a806-e72eca31fcbf',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'24206','accd9a40-a077-5eab-9dc5-6d4cdfbc0014',NULL)
,('Piazza Castello','','Torino','TO','10125',NULL,NULL,'0','3702c730-b1cb-556b-9fe1-7f31dd78c2e9',NULL)
,('Piazza Castello','','Torino','TO','10125',NULL,NULL,'0','fe51850b-1f69-57fa-97b9-d3177d026730',NULL)
,('Via Magenta','12','Torino','TO','10121',NULL,NULL,'24206','09ce7d4a-1c97-52de-9893-8eb23821df3d',NULL)
,('Via Magenta','12','Torino','TO','10122',NULL,NULL,'0','0bb1cc54-81a5-530b-b7ef-8d9a0438ec29',NULL)
,('Via Maria Vittoria','15','Torino','TO','10121',NULL,NULL,'24300','bc6f2dc0-4498-50d8-8015-5ba6c4e86edb',NULL)
,('Via Viotti','8','Torino','TO','10121',NULL,NULL,'24206','bfaa1bf7-c1cb-53dd-80c7-cd4b8d8859aa',NULL)
,('Via Viotti','8','Torino','TO','10124',NULL,NULL,'0','a734e5d5-b33e-5c79-b618-8b7f6adb9b7a',NULL)
,('Via Viotti','8','Torino','TO','10124',NULL,NULL,'0','ab7f8a61-279a-5b37-8103-d11e06ee1d7b',NULL)
,('Via Viotti','8','Torino','TO','10124',NULL,NULL,'0','b9407628-5837-5ae4-aeb2-58e89d2eebca',NULL)
,('Via Viotti','8','Torino','TO','10124',NULL,NULL,'0','de272f2f-eedd-5777-b587-ea2f4381bc4f',NULL)
) AS tmp 
(indirizzo ,num_civico,	localita,provincia,cap,contatto,email,telefono,settore_id,settore_indirizzo_codice)
--JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore_indirizzo current
  WHERE current.settore_id = tmp.settore_id::UUID
  AND current.principale = true
);
