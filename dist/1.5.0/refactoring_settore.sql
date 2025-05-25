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
alter table if exists cpass.cpass_t_settore_indirizzo add column if not exists principale boolean default false;

-- ATTENZIONE NON VA BENE far girare solo una sola volta per non duplicare i dati
/*insert into cpass_t_settore_indirizzo 
(descrizione,indirizzo ,num_civico,	localita,provincia,cap,contatto,email,telefono,settore_id,data_creazione,utente_creazione,data_modifica,utente_modifica,settore_indirizzo_codice, principale)
-- per il popolamento della tabella, non è idempotente poiche le colonne della cpass_t_settore saranno eliminate quindi andrebbe in errore.
select distinct 
'SEDE PRINCIPALE',cts.settore_indirizzo , cts.settore_num_civico , cts.settore_localita , cts.settore_provincia , cts.settore_cap,cts.settore_contatto, cts.settore_email, cts.settore_telefono,
settore_id, current_date,'SYSTEM', current_date, 'SYSTEM', cts.settore_indirizzo_codice,true
from cpass_t_settore cts
order by cts.settore_indirizzo*/



-- le colonne dell'indirrizo sul settore possono essere cancellate 
-- la colonna settore_indirizzo_codice sul destinatario ordine potrebbe essere cancellata
-- il settore_indirizzo_id sul destinatario ordine deve essere popolata anche quando indirizzo principale, bonifichiao i dati ?
-- CpassTSettoreIndirizzoDaoImpl findBySettore ordinare prima la principale poi il resto


-- query preparazione stringhe per il popolamento cpass_t_settore_indirizzo
select distinct 
--cts.settore_indirizzo , cts.settore_num_civico , cts.settore_localita , cts.settore_provincia , cts.settore_cap,cts.settore_contatto, cts.settore_email, cts.settore_telefono,settore_id, cts.settore_indirizzo_codice,
',('''||cts.settore_indirizzo||''','''||cts.settore_num_civico||''','''||cts.settore_localita||''','''||cts.settore_provincia||''','''||cts.settore_cap||''','||
COALESCE(''''||cts.settore_contatto||''',', 'NULL,')||
COALESCE(''''||cts.settore_email||''',', 'NULL,')||
COALESCE(''''||cts.settore_telefono||''',', 'NULL,')||
''''||cts.settore_id||''','||
COALESCE(''''||cts.settore_indirizzo_codice||''')', 'NULL)')
from cpass_t_settore cts
--order by cts.settore_indirizzo


-- spostare su dev-rp.sql
INSERT INTO cpass.cpass_t_settore_indirizzo 
(descrizione,indirizzo ,num_civico,	localita,provincia,cap,contatto,email,telefono,settore_id,data_creazione,utente_creazione,data_modifica,utente_modifica,settore_indirizzo_codice, principale)
SELECT 'SEDE PRINCIPALE',tmp.indirizzo, tmp.num_civico, tmp.localita, tmp.provincia, tmp.cap,tmp.contatto, tmp.email, tmp.telefono,tmp.settore_id::UUID,current_date,'SYSTEM',current_date,'SYSTEM', tmp.settore_indirizzo_codice, true
FROM (VALUES
('Corso Bolzano','44','Torino','TO','10121',NULL,NULL,'24206','a2f1eaa7-17dd-59db-ad27-d57db6dc0175','SA001')
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
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','11bc6cb4-ebfc-5207-a3bb-f35f3d963437',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','1424b2ea-3f66-50d0-9cba-df306d5abd0a',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','17668540-6d8a-5e20-83ef-7ec6b298f9e5',NULL)
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
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','781e0589-43f5-5274-be11-babd0ebff9ea',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','7e460b0b-4400-53a7-966f-2b121e12361d',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','7f8c4960-4a61-502f-973d-9f73670c1171',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','80a4da07-16c0-562d-a723-0a26efc1c6bd',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','81502451-4360-51a8-b53e-90e5aafd5152',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','85043865-0222-5200-8bf1-f93f05e579fa',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','859fe3c6-35aa-5887-bfca-ae0e25319a0c',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','8a5f5261-57a9-5f56-83ab-96e3057e7ac3',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','8c55a046-c6ac-5dfe-9383-9881db253ab2',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','93ec20b8-1663-5b2b-819e-8312681f0ca1',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','95dab272-5d9f-51e0-a004-6317e84a774c',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','9ad6bc53-dec9-530c-bc11-b9cef5548bba',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','9cb877dc-45c2-5887-95e8-d7396732e348',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','a09afc69-87f7-5313-b8f6-9f5ad4649541',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','a1170084-7d14-5ee3-a968-f769bab21d93',NULL)
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
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','d256f0e5-fbd6-5f08-a6d9-f14b93c7dc3b','A1902A')
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
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','fe506533-aed3-557e-9740-af2ef0314f26',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'0','ffdd00ba-ca2b-598f-b010-8c9c585aec56',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'12345','8a239b3b-ed15-5bd0-a806-e72eca31fcbf',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'24206','accd9a40-a077-5eab-9dc5-6d4cdfbc0014',NULL)
,('Piazza Castello','165','Torino','TO','10121','sig. X','email@email.it','0','17c88c6a-3735-5f9a-b20b-d508d73aec69',NULL)
,('Piazza Castello','165','Torino','TO','10121','sig. X','email@email.it','0','76983574-3cbe-5b8b-8123-c75de2226a64',NULL)
,('Piazza Castello','165','Torino','TO','10121','sig. X','email@email.it','0','891955c9-91ff-5879-8ce7-c5895067ec81','A1503B')
,('Piazza Castello','165','Torino','TO','10121','sig. X','email@email.it','0','8c2027dc-8850-56bd-a08a-61077feb96ef',NULL)
,('Piazza Castello','165','Torino','TO','10121','sig. X','email@email.it','0','a2472ed7-205b-5c82-b497-a90b51d4c60d',NULL)
,('Piazza Castello','165','Torino','TO','10121','sig. X','email@email.it','0','a2e674b8-35ca-54a1-9c68-c0f51bed3e3e',NULL)
,('Piazza Castello','165','Torino','TO','10121','sig. X','email@email.it','0','fdd8ec34-a4fa-5111-ac1f-a24467d92ed4',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','00f609ef-8d16-50dd-83ac-3402bf5e15e0',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','03f15217-216f-56e0-8a13-ecd8cd05b00e',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','04750401-39e1-515b-9fb7-d34818fdfd55',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','047aac72-40da-544b-a91b-70a525b99519',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','05601e7e-951f-5bb6-96af-a8a516157f95',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','0571c0b3-70b8-5719-bb49-b2f855afa1bf',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','057ab4e1-8fda-5515-8eba-5e7ccfb030eb',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','057e37f1-5928-5520-b8b9-a892e459657d',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','0d4c3945-f115-50cf-b097-f77f7ac789bf',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','15a3b5d3-de73-5a1e-9fdf-e356f908db76',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','16e3a049-6b5d-5019-935f-bed71a1217c0',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','1773f7f7-82a3-5527-8bfb-dd409f5e50c1',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','18a3f956-f0e0-5e56-a7cc-6a13b84d345e',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','1fc79c0e-3af5-5d2a-9b40-57b36ac17698',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','21164105-1592-58c2-940e-cc8cb7d0b314',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','218c4e40-cb5d-554b-815e-a2a5e159daf0',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','23bd0f4d-85da-57ab-ac4c-6bce741be7a9',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','24587bd3-cd78-52db-a821-b4906d6c73fa',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','28d75523-75c4-5e2d-8702-1633f03d7139',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','28dc6c21-1ad0-52bc-8eb1-4a2d651e7563',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','33574de4-caa3-5f3b-8489-7b4b0148d891',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','3764edc7-d4db-5967-af50-a2b12b08d927',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','39cd4e5a-cb80-5a05-88be-f047b4f5fbcc',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','3cf41393-1ab8-58f1-8516-d66375e5113b',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','3d840e00-0477-5164-aa9f-81e48fed8cf7',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','3e059861-8859-55d2-aa69-159d972ad41f',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','3f818d0e-e971-54b9-a938-21b098e85ae1',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','41e9d8ae-6638-59e2-81f7-37ba3cb9ca01',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','459f1df0-6525-5d7e-8e22-0f155697d244',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','47f5de5f-2c14-5726-8aee-27fb2aadeaef',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','558b73e8-e68b-5879-86d6-0dba9db65153',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','577e5123-2aa0-52e0-928e-9b06b404a1df',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','5b363f4f-b6a5-5a6c-b207-bfaed604c785',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','5beb327c-e15d-58c0-8894-6744985d900e',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','6339c0a4-15eb-5ea3-a14f-9daa9d3f9956',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','63c39fad-2a02-5a68-b384-3eb06ecb6479',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','68dea07c-c439-55e1-a10f-2935ed73ac50',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','6bd07fa4-8ee6-52ca-b7a2-3e5538aded53',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','6e7c6eba-d640-566e-b52d-b5f0ccb25f5a',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','6e9fb889-08d1-5fcf-a172-8b4324028065',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','7019c616-155a-5e6a-a6cc-f432587d2ff7',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','71511e09-baf9-57d6-8a4d-0e7ab04610b2',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','7643e02b-9fc3-5440-82f9-5ebea4743a2e',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','77c89b1f-b2b3-53ab-a00a-501a20716d91',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','78184f16-5a52-5015-9f63-ca589895e51d',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','7b82aee1-cff6-5e28-8fed-5acc20194f36',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','7bf2dc46-4950-5830-8d65-7481954186b1',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','7d8fba82-9f92-53ef-a76d-58cf02257e94',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','7ea67596-1b4d-513f-8928-e7b7bdba3e79',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','7f9b96de-fd05-5420-843a-480b31ca2703',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','7fe41f18-8e84-51b7-b553-a81a895acdef',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','8030ce0a-caa8-568a-a260-47d5744b0b4e',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','820b5063-33ac-52e0-b557-d27f44baa31d',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','828787bc-21e5-51c0-8b06-0e83224e440d',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','82cfb732-7696-577f-b52e-bccfaa009958',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','833a40b4-ea9d-5464-95b4-2b7ce47cb288',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','84e027e8-fdde-5c84-8b1c-f5f19195050f',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','86d9a904-9c53-504e-869d-73f8841f8555',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','8a7b4b9d-c334-5965-9638-dc2ecfdc3bb3',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','8eb015fb-ceda-5e5c-b0ab-1410b31aab2c',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','8f9ffcbb-b850-529e-879a-0babf29422ff',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','8fe9be6b-12a4-5511-b146-7852aaa41451',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','94907ce5-875d-51ef-9efb-dbeeb2089307',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','988ad6e9-1b5b-5f72-a1a6-346613d2f394',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','9cacccdc-3afa-524d-8347-41b467ab787a',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','9cf68d0e-2411-58a7-a6d2-04bb5fbaed51',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','a6deab98-6c61-5b69-82ea-31807d9278b0',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','b330644a-4dfc-5bb0-a908-07307b753921',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','b5c85fda-75e8-5fbb-91e4-4b7d81d12a32',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','c0dab432-20eb-5d2e-94a5-fc568e72ef17',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','c3cbf5f8-6ce3-5c12-b9a9-9e8ec025c4d9',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','c3e091f4-70b3-5fcd-a5ac-4113cfd99eb1',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','c69c8b72-a0c5-5715-b5bd-d43a5683a265',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','c843acc5-1d45-5f25-bdac-d3c9084ae9a6',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','cad026d1-d326-5854-80a0-5823e436b490',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','d2d9959c-0514-510f-8750-b825f430537f',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','d35934a1-7474-5b3d-93cb-39d0e28bedfb',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','d3fea3d5-7229-5a1b-ac6d-ee46c26a0469',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','dbf457d9-5093-55c1-a483-49acbbda3392',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','ddb0a274-6344-5103-889f-f4f5eaf4ac3a',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','de0aaa85-b358-52dd-81ea-03fc23efa7f7',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','e0f13695-792b-5e34-9546-c48c10e36420',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','e54a52ff-2d3c-51fd-a91e-5a0a5843732b',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','eec78522-1f8f-5434-99e0-1b01c1799b3b',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','f0a77d71-3205-54cf-bef0-82c428f5f1f2',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','f1713abb-05cb-5235-a518-b9c38145fff2',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','f1790664-7b69-5579-95b9-6852c4c55d89',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','f42a5345-28a6-51d8-9350-202b476c262c',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','f7db6b8f-998d-5b5d-967c-e4c4dd7728db',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','fb322737-54a5-529c-8b66-b6aa8af0a6e9',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','fd6ad389-c030-5bf5-843c-f90b26c04713',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','fe100cce-0b46-547b-ae8d-cc08eca91e36',NULL)
,('piazza Castello','1','Torino','TO','10100',NULL,NULL,'011432','ff77022f-c21a-5aed-a0b1-b6cc2b2a770e',NULL)
,('piazza Castello','1','Torino','TO','10100','sig. X','email@email.it','011432','1e7f13a0-7312-5ced-99ff-b6b25abf4553',NULL)
,('piazza Castello','1','Torino','TO','10100','sig. X','email@email.it','011432','1e82058e-d3b1-5348-ad83-1dd207cbed78',NULL)
,('piazza Castello','1','Torino','TO','10100','sig. X','email@email.it','011432','261aca71-f1e8-5d78-b370-67ae1f1d5c12',NULL)
,('piazza Castello','1','Torino','TO','10100','sig. X','email@email.it','011432','682dd2ac-9337-5b47-9e63-0295fa0bdf15',NULL)
,('piazza Castello','1','Torino','TO','10100','sig. X','email@email.it','011432','a0f0cb5b-c9de-5df4-a2d2-2d8fa4ec25b5',NULL)
,('piazza Castello','1','Torino','TO','10100','sig. X','email@email.it','011432','d2e0f002-c3fe-52fe-8ff0-0cefcfe148e3',NULL)
,('piazza Castello','1','Torino','TO','10100','sig. X','email@email.it','011432','d9238af7-c70a-5a6f-8872-8695428b6194',NULL)
,('piazza Castello','1','Torino','TO','10100','sig. X','email@email.it','011432','e9b0a995-6806-576c-9b0b-3c1092914d80',NULL)
,('piazza Castello','1','Torino','TO','10100','sig. X','email@email.it','011432','f1449f54-6389-5ca8-b9e5-09b4ba843b46',NULL)
,('piazza Castello','1','Torino','TO','10100','sig. X','email@email.it','011432','f17d60ef-ff76-556e-a47c-e9e9caf8bdc9',NULL)
,('piazza Castello','1','Torino','TO','10100','sig. X','email@email.it','011432','f9e5737c-5a5c-59a3-b023-52f52c56ffe4',NULL)
,('Piazza Castello','','Torino','TO','10125',NULL,NULL,'0','3702c730-b1cb-556b-9fe1-7f31dd78c2e9',NULL)
,('Piazza Castello','','Torino','TO','10125',NULL,NULL,'0','fe51850b-1f69-57fa-97b9-d3177d026730',NULL)
,('Via Magenta','12','Torino','TO','10121','sig. X','email@email.it','24206','09ce7d4a-1c97-52de-9893-8eb23821df3d',NULL)
,('Via Magenta','12','Torino','TO','10122',NULL,NULL,'0','0bb1cc54-81a5-530b-b7ef-8d9a0438ec29','')
,('Via Maria Vittoria','15','Torino','TO','10121',NULL,NULL,'24300','bc6f2dc0-4498-50d8-8015-5ba6c4e86edb',NULL)
,('Via Viotti','8','Torino','TO','10121',NULL,NULL,'24206','bfaa1bf7-c1cb-53dd-80c7-cd4b8d8859aa',NULL)
,('Via Viotti','8','Torino','TO','10124',NULL,NULL,'0','a734e5d5-b33e-5c79-b618-8b7f6adb9b7a',NULL)
,('Via Viotti','8','Torino','TO','10124',NULL,NULL,'0','ab7f8a61-279a-5b37-8103-d11e06ee1d7b',NULL)
,('Via Viotti','8','Torino','TO','10124',NULL,NULL,'0','b9407628-5837-5ae4-aeb2-58e89d2eebca',NULL)
,('Via Viotti','8','Torino','TO','10124',NULL,NULL,'0','de272f2f-eedd-5777-b587-ea2f4381bc4f',NULL)
) AS tmp 
(indirizzo ,num_civico,	localita,provincia,cap,contatto,email,telefono,settore_id,settore_indirizzo_codice)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore_indirizzo current
  WHERE current.settore_id = tmp.settore_id::UUID
  AND current.principale = true
);
-- spostare su dev-mult.sql
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
--JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore_indirizzo current
  WHERE current.settore_id = tmp.settore_id::UUID
  AND current.principale = true
);

-- spostare su test-rp.sql
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

-- spostare su test-mult.sql
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
--JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore_indirizzo current
  WHERE current.settore_id = tmp.settore_id::UUID
  AND current.principale = true
);

-- spostare su prod-rp.sql
INSERT INTO cpass.cpass_t_settore_indirizzo 
(descrizione,indirizzo ,num_civico,	localita,provincia,cap,contatto,email,telefono,settore_id,data_creazione,utente_creazione,data_modifica,utente_modifica,settore_indirizzo_codice, principale)
SELECT 'SEDE PRINCIPALE',tmp.indirizzo, tmp.num_civico, tmp.localita, tmp.provincia, tmp.cap,tmp.contatto, tmp.email, tmp.telefono,tmp.settore_id::UUID,current_date,'SYSTEM',current_date,'SYSTEM', tmp.settore_indirizzo_codice, true
FROM (VALUES
('corso Bolzano','44','Torino','TO','10121',NULL,NULL,'0114321111','110ad85a-c0ec-5628-ae51-b09f9af10107',NULL)
,('corso Bolzano','44','Torino','TO','10121',NULL,NULL,'0114321111','17668540-6d8a-5e20-83ef-7ec6b298f9e5',NULL)
,('corso Bolzano','44','Torino','TO','10121',NULL,NULL,'0114321111','31fc7735-aa42-57c2-952a-da36ec6a9e79',NULL)
,('corso Bolzano','44','Torino','TO','10121',NULL,NULL,'0114321111','602d7289-c91f-599e-98c3-0a6e8eb9f4fc',NULL)
,('corso Bolzano','44','Torino','TO','10121',NULL,NULL,'0114321111','65f29bb2-b213-582d-ac27-cc9d37b20937',NULL)
,('corso Bolzano','44','Torino','TO','10121',NULL,NULL,'0114321111','6e6e6294-c256-5365-bc54-b03144c2e7f3',NULL)
,('corso Bolzano','44','Torino','TO','10121',NULL,NULL,'0114321111','af54b787-626a-5bc2-a672-272a3546f6f8',NULL)
,('corso Bolzano','44','Torino','TO','10121',NULL,NULL,'0114321111','b89245ee-881d-5759-b7cc-bc23adbf4c52',NULL)
,('corso Bolzano','44','Torino','TO','10121',NULL,NULL,'0114321111','c90d73b9-2cdc-52a3-ace7-095321d8aee7',NULL)
,('corso Bolzano','44','Torino','TO','10121',NULL,NULL,'0114321111','d7481b8d-a51a-5572-a94f-cc06821a1018',NULL)
,('corso Bolzano','44','Torino','TO','10121',NULL,NULL,'0114321111','ea0478e8-9634-5a9c-96f1-4a6aadc5a4a8',NULL)
,('corso Bolzano','44','Torino','TO','10121',NULL,NULL,'0114321111','f7d87319-7831-55c7-895e-6f32d2e06db8',NULL)
,('corso Dante','163','Asti','AT','14100',NULL,NULL,'0114321111','f04717f5-8a68-59da-bf9f-af6955d166f3',NULL)
,('corso Dante','165','Asti','AT','14100',NULL,NULL,'0114321111','9cb877dc-45c2-5887-95e8-d7396732e348',NULL)
,('corso De Gasperi','40','Cuneo','CN','12100',NULL,NULL,'0114321111','fc1785a9-b516-53ce-9e63-6f16f626214b',NULL)
,('corso Kennedy','7/bis','Cuneo','CN','12100',NULL,NULL,'0114321111','3b87c9b8-6185-54ad-8198-0463233d8b82',NULL)
,('corso Marche','79','Torino','TO','10146',NULL,NULL,'0114321111','2081872e-af74-557a-b4a1-e6b0dd7d1a47',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','037de602-4788-5698-8f07-3d3cd2c897ad',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','0cf96cbd-2ba1-584c-ac55-486dd182b03e',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','15b861c0-3603-557b-83df-ca0c9462ac81',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','29013793-9e7e-5d58-b580-f84e7e66d231',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','4d741790-947f-520d-97ff-6a29d7b40b03',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','4dbe6d70-ab8b-5d71-ae45-626829869b89',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','5cc7988d-bab7-5d31-bb6a-4759f5cafaee',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','5e9ca03e-fe83-570a-85b1-cd54af0f06a6',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','8b4ce7e2-cd13-55fe-912b-9f4ac0968ee6',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','8c04f600-60a2-5077-90f0-5dc96f350a28',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','adc1b760-c632-58e1-a084-bee2a427698d',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','b22adae2-9b8c-50b2-ae86-445a73792344',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','c57feec8-46e6-5ce8-9656-d6aff1aed348',NULL)
,('corso Regina Margherita','153 bis','Torino','TO','10122',NULL,NULL,'0114321111','c913f5b9-3d4f-5354-8c61-dc6d91c1d748',NULL)
,('Corso regina Margherita','174','Torino','TO','10121',NULL,NULL,'011','bc1024de-4893-5723-941e-30860f9d7eac',NULL)
,('corso Regina Margherita','174','Torino','TO','10152',NULL,NULL,'0114321111','20657b0a-0edc-5dc1-ac60-f813a274ae1f',NULL)
,('corso Regina Margherita','174','Torino','TO','10152',NULL,NULL,'0114321111','ae3af64b-82ed-5954-ae8d-f6e7e6829a14',NULL)
,('corso Regina Margherita','174','Torino','TO','10152',NULL,NULL,'0114321111','c3b2286d-d29d-5c9a-a83a-2014015df267',NULL)
,('corso Regina Margherita','174','Torino','TO','10152',NULL,NULL,'0114321111','ea29e965-8309-5156-897b-72b041ffd75e',NULL)
,('corso Regina Margherita','174','Torino','TO','10152',NULL,NULL,'0114321111','ee3f44f5-38f5-5ce3-a6a9-66222abc6145',NULL)
,('corso Regina Margherita','174','Torino','TO','10152',NULL,NULL,'0114321111','ffdd00ba-ca2b-598f-b010-8c9c585aec56',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','09669c29-7041-5e0a-bacb-3f6cb3243352',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','11bc6cb4-ebfc-5207-a3bb-f35f3d963437',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','1811468d-9ebf-5c97-884c-828dbf2c8459',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','1fc33980-d066-543b-9492-c4611f78f035',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','3583e960-17bd-51a7-a516-f7871455db2d',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','450f3893-0e5b-564d-ba25-453f1938d394',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','4e09d73b-0f37-53f7-9711-94c61f9dac5b',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','a59c90ba-28bb-5ba4-875c-f8e27035ad58',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','a8310697-a568-5e6c-86e8-7e8d7c4186ba',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','aa74dc12-8e3d-5c11-b9ae-ff1db6ef36c0',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','bfc5b3ca-aa0c-5131-b844-dcbfee285afe',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','c7d63ead-392a-51cd-a90c-5373ae9d6dcb',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','da1d6215-742a-54ef-b93f-10c97cca980a',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','e9dceb94-9b85-5008-a3d8-b35194d0c3d6',NULL)
,('corso Stati Uniti','21','Torino','TO','10128',NULL,NULL,'0114321111','f42412b9-95c7-5f8b-81f3-8faf7875bb4e',NULL)
,('Piazza Alfieri','33','Asti','AT','14100',NULL,NULL,'0114321111','c9c80586-7948-50e6-b418-91e884daf5c4',NULL)
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
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','bcdb1859-2a19-5ad8-9506-8b9b6d78f0e3',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','bfdcf2dc-2fe6-565e-8890-b2656ff0eedf',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','d389c3ea-adb1-5e3e-839a-c96075b51cee',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','e5b6f3d6-8d53-5bc0-b035-e8892c6ea3db',NULL)
,('Piazza Castello','165','Torino','TO','10121',NULL,NULL,'011','ee89c114-8118-5f56-976a-e8c49345d852',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','03cb7c5a-e5ce-515a-9a60-72b4d173644d',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','054a3075-4c8f-50c4-a07d-098b30cf89cf',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','0bc1976a-3d17-5869-836d-09556b59a356',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','0d5e015c-d296-5f77-bf94-b146a52e51a7',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','240c164a-1ea8-5f96-91ea-5bafb7367df0',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','270907ed-6421-5d33-92e8-c044bc981fe5',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','2bb4dd33-74e3-533c-afbd-3f17c178fdbc',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','34103f59-63ff-546e-88ca-07cd382c7415',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','4e1ab433-360b-5dfc-b8ea-d66bf4050ff1',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','543112b3-46ed-5efe-86dd-948f80dcd742',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','548dd7a3-5798-5e39-aa68-250fb81cccb7',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','55866aa6-77db-54b6-8393-e8d0f3b4b98b',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','65721609-5714-528f-b403-9672d1b6ac85',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','7110b9e2-2f19-5ee4-be32-cd1850e7b308',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','75f5e92b-afaa-5fec-bc99-01a93891728b',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','7f8c4960-4a61-502f-973d-9f73670c1171',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','80a4da07-16c0-562d-a723-0a26efc1c6bd',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','8a239b3b-ed15-5bd0-a806-e72eca31fcbf',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','8a5f5261-57a9-5f56-83ab-96e3057e7ac3',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','93ec20b8-1663-5b2b-819e-8312681f0ca1',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','a2f1eaa7-17dd-59db-ad27-d57db6dc0175',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','a634b350-747b-5dcf-83d0-d5779f5cfcda',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','accd9a40-a077-5eab-9dc5-6d4cdfbc0014',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','b781a89e-764b-5f1b-b990-5ad2b642933d',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','bbd00409-627c-5a8f-bdbe-1043e905613f',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','bc6f2dc0-4498-50d8-8015-5ba6c4e86edb',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','bc769fd9-843b-5afb-bd32-c8168e8c399a',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','d1611bfe-228c-5763-81a2-aa5565fff6d0',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','d4f730ae-c46b-5654-b5b6-d878f414e812',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','dd908607-350b-5a0b-ae69-4c8784ccf8bf',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','e6c29f69-4122-5d9c-9806-0d21d9138a44',NULL)
,('piazza Castello','165','Torino','TO','10122',NULL,NULL,'0114321111','f8724813-9940-5a92-89d0-d0bfc0ea5fac',NULL)
,('piazza Turati','4','Alessandria','AL','15121',NULL,NULL,'0114321111','d35f9c1b-b6a0-5cde-ada1-e02bd4c2d0f4',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','3702c730-b1cb-556b-9fe1-7f31dd78c2e9',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','602a5d76-28be-5354-9ad5-cd642ca16cdd',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','618116f6-6ced-57ba-afce-d5b2b81c2e6c',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','62063d16-2572-58ba-bbc3-4f4baf63ffbe',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','6a541f2a-1e15-5cf3-9a37-dedb0f480f0b',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','6b239f91-9e8b-5e7e-b8c9-ea3ddadf0bdf',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','85043865-0222-5200-8bf1-f93f05e579fa',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','a09afc69-87f7-5313-b8f6-9f5ad4649541',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','a6edeae8-6265-5e68-99fd-86d0f295916d',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','ae7c15f8-225c-5caa-bee3-e818bd45609d',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','c1323ab3-61ce-5d1e-b2bf-9547ef9eb0f9',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','ca897166-7b63-577e-b289-5f0e54ba898e',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','d1f7b706-ed27-5213-abb4-135856e5d0f6',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','eaaafebe-7345-5689-82f6-a82b16c22614',NULL)
,('via Bertola','34','Torino','TO','10122',NULL,NULL,'0114321111','fe51850b-1f69-57fa-97b9-d3177d026730',NULL)
,('via F.lli Ponti','24','Vercelli','VC','13100',NULL,NULL,'0114321111','d9805aea-d7d6-54f0-8994-d4028eadb8f6',NULL)
,('via Livorno','60','Torino','TO','10144',NULL,NULL,'0114321111','fc7bf5d7-c68c-5b9b-ae0c-af74495311d2',NULL)
,('via Magenta','12','Torino','TO','10128',NULL,NULL,'0114321111','09ce7d4a-1c97-52de-9893-8eb23821df3d',NULL)
,('via Magenta','12','Torino','TO','10128',NULL,NULL,'0114321111','0bb1cc54-81a5-530b-b7ef-8d9a0438ec29',NULL)
,('via Magenta','12','Torino','TO','10128',NULL,NULL,'0114321111','0cae2924-08a8-5cf5-87d1-2386c900e3ff',NULL)
,('via Magenta','12','Torino','TO','10128',NULL,NULL,'0114321111','17c88c6a-3735-5f9a-b20b-d508d73aec69',NULL)
,('via Magenta','12','Torino','TO','10128',NULL,NULL,'0114321111','76983574-3cbe-5b8b-8123-c75de2226a64',NULL)
,('via Magenta','12','Torino','TO','10128',NULL,NULL,'0114321111','891955c9-91ff-5879-8ce7-c5895067ec81',NULL)
,('via Magenta','12','Torino','TO','10128',NULL,NULL,'0114321111','8c2027dc-8850-56bd-a08a-61077feb96ef',NULL)
,('via Magenta','12','Torino','TO','10128',NULL,NULL,'0114321111','a2472ed7-205b-5c82-b497-a90b51d4c60d',NULL)
,('via Magenta','12','Torino','TO','10128',NULL,NULL,'0114321111','a2e674b8-35ca-54a1-9c68-c0f51bed3e3e',NULL)
,('via Magenta','12','Torino','TO','10128',NULL,NULL,'0114321111','fdd8ec34-a4fa-5111-ac1f-a24467d92ed4',NULL)
,('via Mora e Gibin','4','Novara','NO','28100',NULL,NULL,'0114321111','58e5ba26-2110-5c77-8ea0-2083625becad',NULL)
,('via Mora e Gibin','4','Novara','NO','28100',NULL,NULL,'0114321111','b99a400a-3e2d-531a-89ab-e2306409f8c0',NULL)
,('via Passo Buole','22','Torino','TO','10127',NULL,NULL,'0114321111','01bb7893-bc15-5aa2-a3a8-0a488967cd8c',NULL)
,('via Pisano','6','Torino','TO','10152',NULL,NULL,'0114321111','1424b2ea-3f66-50d0-9cba-df306d5abd0a',NULL)
,('via Pisano','6','Torino','TO','10152',NULL,NULL,'0114321111','1a5eed94-9b0d-57da-b43d-a04c80c6d7fb',NULL)
,('via Pisano','6','Torino','TO','10152',NULL,NULL,'0114321111','2077a832-6534-511a-aa26-66fb60ba8b21',NULL)
,('via Pisano','6','Torino','TO','10152',NULL,NULL,'0114321111','37c25a1a-7ed3-5ce8-b329-0520bdfbd8b9',NULL)
,('via Pisano','6','Torino','TO','10152',NULL,NULL,'0114321111','746c092e-135a-5915-b94e-8292b325b798',NULL)
,('via Pisano','6','Torino','TO','10152',NULL,NULL,'0114321111','95dab272-5d9f-51e0-a004-6317e84a774c',NULL)
,('via Pisano','6','Torino','TO','10152',NULL,NULL,'0114321111','b1b78f02-a10e-5fe2-8a25-0fe7d50682be',NULL)
,('via Pisano','6','Torino','TO','10152',NULL,NULL,'0114321111','d23732c0-f53c-542b-b525-cd6cd1bbd35d',NULL)
,('via Pisano','6','Torino','TO','10152',NULL,NULL,'0114321111','d256f0e5-fbd6-5f08-a6d9-f14b93c7dc3b',NULL)
,('via Pisano','6','Torino','TO','10152',NULL,NULL,'0114321111','d5fd56aa-a844-58ae-b8d9-aa1f3850233b',NULL)
,('via Principe Amedeo','17','Torino','TO','10123',NULL,NULL,'0114321111','0511ec7c-4c74-5e81-9f02-e39d18fa0bcf',NULL)
,('via Principe Amedeo','17','Torino','TO','10123',NULL,NULL,'0114321111','350f681f-9db7-534a-908b-4fc38b521ebe',NULL)
,('via Principe Amedeo','17','Torino','TO','10123',NULL,NULL,'0114321111','375dce55-2972-575d-aadb-400b089c6d04',NULL)
,('via Principe Amedeo','17','Torino','TO','10123',NULL,NULL,'0114321111','5b0afd2c-7089-5681-9a0d-1124662914e7',NULL)
,('via Principe Amedeo','17','Torino','TO','10123',NULL,NULL,'0114321111','5c3a820a-9562-5bdb-a5b2-e03407691acf',NULL)
,('via Principe Amedeo','17','Torino','TO','10123',NULL,NULL,'0114321111','626c67fa-07e3-5591-b7a9-25c92b4a8a75',NULL)
,('via Principe Amedeo','17','Torino','TO','10123',NULL,NULL,'0114321111','9ad6bc53-dec9-530c-bc11-b9cef5548bba',NULL)
,('via Principe Amedeo','17','Torino','TO','10123',NULL,NULL,'0114321111','a1170084-7d14-5ee3-a968-f769bab21d93',NULL)
,('via Principe Amedeo','17','Torino','TO','10123',NULL,NULL,'0114321111','b5c19f80-b4c1-5a17-968c-773b0ac1de79',NULL)
,('via Principe Amedeo','17','Torino','TO','10123',NULL,NULL,'0114321111','e5c14f20-93f0-55ce-b4d0-788b04477548',NULL)
,('via Principe Amedeo','17','Torino','TO','10123',NULL,NULL,'0114321111','ef40c617-5658-591f-a93e-731312db5e3d',NULL)
,('via San Giuseppe','39','Pinerolo','TO','10064',NULL,NULL,'0114321111','81502451-4360-51a8-b53e-90e5aafd5152',NULL)
,('via Viotti','8','Torino','TO','10121',NULL,NULL,'0114321111','63a488a7-32e0-50ab-ad2f-a13c40f9b57e',NULL)
,('via Viotti','8','Torino','TO','10121',NULL,NULL,'0114321111','8c55a046-c6ac-5dfe-9383-9881db253ab2',NULL)
,('via Viotti','8','Torino','TO','10121',NULL,NULL,'0114321111','a734e5d5-b33e-5c79-b618-8b7f6adb9b7a',NULL)
,('via Viotti','8','Torino','TO','10121',NULL,NULL,'0114321111','ab7f8a61-279a-5b37-8103-d11e06ee1d7b',NULL)
,('via Viotti','8','Torino','TO','10121',NULL,NULL,'0114321111','b9407628-5837-5ae4-aeb2-58e89d2eebca',NULL)
,('via Viotti','8','Torino','TO','10121',NULL,NULL,'0114321111','bfaa1bf7-c1cb-53dd-80c7-cd4b8d8859aa',NULL)
,('via Viotti','8','Torino','TO','10121',NULL,NULL,'0114321111','de272f2f-eedd-5777-b587-ea2f4381bc4f',NULL)
,('via Viotti','8','Torino','TO','10121',NULL,NULL,'0114321111','f259fc7e-aecf-5150-b833-9eee2f61990e',NULL)
) AS tmp 
(indirizzo ,num_civico,	localita,provincia,cap,contatto,email,telefono,settore_id,settore_indirizzo_codice)
--JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore_indirizzo current
  WHERE current.settore_id = tmp.settore_id::UUID
  AND current.principale = true
);
-- spostare su prod-mult.sql
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
) AS tmp 
(indirizzo ,num_civico,	localita,provincia,cap,contatto,email,telefono,settore_id,settore_indirizzo_codice)
--JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_settore_indirizzo current
  WHERE current.settore_id = tmp.settore_id::UUID
  AND current.principale = true
);

-- recreate vista per poter cancellare le colonne dalla cpass_t_settore
drop view cpass.cpass_v_settore;
CREATE OR REPLACE VIEW cpass.cpass_v_settore
AS WITH RECURSIVE alberosettore AS (
         SELECT 1 AS livello,
            NULL::uuid AS settore_id_padre,
            s.settore_id,
            s.settore_codice,
            s.settore_descrizione,
 --           s.settore_indirizzo,
 --           s.settore_localita,
 --           s.settore_cap,
 --           s.settore_provincia,
 --           s.settore_telefono,
 --           s.settore_num_civico,
 --           s.settore_contatto,
 --           s.settore_email,
            s.ente_id,
            ts.tipo_settore_id,
            ts.flag_utilizzabile
 --           s.settore_indirizzo_codice
           FROM cpass_t_settore s,
            cpass_d_tipo_settore ts
          WHERE s.settore_padre_id IS NULL AND (s.data_cancellazione IS NULL OR s.data_cancellazione IS NOT NULL AND date_trunc('day'::text, s.data_cancellazione) > date_trunc('day'::text, now())) AND s.tipo_settore_id = ts.tipo_settore_id
        UNION ALL
         SELECT mtree.livello + 1,
            mtree.settore_id AS settore_id_padre,
            s_figlio.settore_id,
            s_figlio.settore_codice,
            s_figlio.settore_descrizione,
  --          s_figlio.settore_indirizzo,
  --         s_figlio.settore_localita,
  --          s_figlio.settore_cap,
  --          s_figlio.settore_provincia,
  --          s_figlio.settore_telefono,
  --          s_figlio.settore_num_civico,
  --         s_figlio.settore_contatto,
  --          s_figlio.settore_email,
            s_figlio.ente_id,
            ts.tipo_settore_id,
            ts.flag_utilizzabile
  --          s_figlio.settore_indirizzo_codice
           FROM cpass_t_settore s_figlio
             JOIN alberosettore mtree ON mtree.settore_id = s_figlio.settore_padre_id
             JOIN cpass_d_tipo_settore ts ON s_figlio.tipo_settore_id = ts.tipo_settore_id
          WHERE s_figlio.data_cancellazione IS NULL OR s_figlio.data_cancellazione IS NOT NULL AND date_trunc('day'::text, s_figlio.data_cancellazione) > date_trunc('day'::text, now())
        )
 SELECT row_number() OVER () AS id_v_settore,
    alberosettore.livello,
    alberosettore.settore_id_padre,
    alberosettore.settore_id,
    alberosettore.settore_codice,
    alberosettore.settore_descrizione,
--    alberosettore.settore_indirizzo,
--    alberosettore.settore_localita,
--    alberosettore.settore_cap,
--    alberosettore.settore_provincia,
--    alberosettore.settore_telefono,
--    alberosettore.settore_num_civico,
--    alberosettore.settore_contatto,
--    alberosettore.settore_email,
    alberosettore.ente_id,
    alberosettore.tipo_settore_id,
    alberosettore.flag_utilizzabile
--    alberosettore.settore_indirizzo_codice
   FROM alberosettore
  ORDER BY alberosettore.livello DESC, alberosettore.settore_codice;

-- Permissions

ALTER TABLE cpass.cpass_v_settore OWNER TO cpass;
GRANT ALL ON TABLE cpass.cpass_v_settore TO cpass;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE cpass.cpass_v_settore TO cpass_rw;

alter table if exists cpass.cpass_t_settore drop column if exists settore_indirizzo;
alter table if exists cpass.cpass_t_settore drop column if exists settore_num_civico;
alter table if exists cpass.cpass_t_settore drop column if exists settore_localita;
alter table if exists cpass.cpass_t_settore drop column if exists settore_provincia;
alter table if exists cpass.cpass_t_settore drop column if exists settore_cap;
alter table if exists cpass.cpass_t_settore drop column if exists settore_contatto;
alter table if exists cpass.cpass_t_settore drop column if exists settore_email;
alter table if exists cpass.cpass_t_settore drop column if exists settore_telefono;
alter table if exists cpass.cpass_t_settore drop column if exists settore_indirizzo_codice;

-- SOLO SE VOGLIO RIPRISTINARE IL DB A PRIMA DEL REFACTORING


alter table if exists cpass.cpass_t_settore add column if not exists settore_indirizzo varchar(500);
alter table if exists cpass.cpass_t_settore add column if not exists settore_num_civico varchar(20);
alter table if exists cpass.cpass_t_settore add column if not exists settore_localita varchar(500);
alter table if exists cpass.cpass_t_settore add column if not exists settore_provincia varchar(2) ;
alter table if exists cpass.cpass_t_settore add column if not exists settore_cap varchar(5);
alter table if exists cpass.cpass_t_settore add column if not exists settore_contatto varchar(200);
alter table if exists cpass.cpass_t_settore add column if not exists settore_email varchar(50);
alter table if exists cpass.cpass_t_settore add column if not exists settore_telefono varchar(50) ;
alter table if exists cpass.cpass_t_settore add column if not exists settore_indirizzo_codice varchar(50);

drop view cpass.cpass_v_settore;
CREATE OR REPLACE VIEW cpass.cpass_v_settore
AS WITH RECURSIVE alberosettore AS (
         SELECT 1 AS livello,
            NULL::uuid AS settore_id_padre,
            s.settore_id,
            s.settore_codice,
            s.settore_descrizione,
            s.settore_indirizzo,
            s.settore_localita,
            s.settore_cap,
            s.settore_provincia,
            s.settore_telefono,
            s.settore_num_civico,
            s.settore_contatto,
            s.settore_email,
            s.ente_id,
            ts.tipo_settore_id,
            ts.flag_utilizzabile,
            s.settore_indirizzo_codice
           FROM cpass_t_settore s,
            cpass_d_tipo_settore ts
          WHERE s.settore_padre_id IS NULL AND (s.data_cancellazione IS NULL OR s.data_cancellazione IS NOT NULL AND date_trunc('day'::text, s.data_cancellazione) > date_trunc('day'::text, now())) AND s.tipo_settore_id = ts.tipo_settore_id
        UNION ALL
         SELECT mtree.livello + 1,
            mtree.settore_id AS settore_id_padre,
            s_figlio.settore_id,
            s_figlio.settore_codice,
            s_figlio.settore_descrizione,
            s_figlio.settore_indirizzo,
           s_figlio.settore_localita,
           s_figlio.settore_cap,
            s_figlio.settore_provincia,
            s_figlio.settore_telefono,
            s_figlio.settore_num_civico,
           s_figlio.settore_contatto,
            s_figlio.settore_email,
            s_figlio.ente_id,
            ts.tipo_settore_id,
            ts.flag_utilizzabile,
            s_figlio.settore_indirizzo_codice
           FROM cpass_t_settore s_figlio
             JOIN alberosettore mtree ON mtree.settore_id = s_figlio.settore_padre_id
             JOIN cpass_d_tipo_settore ts ON s_figlio.tipo_settore_id = ts.tipo_settore_id
          WHERE s_figlio.data_cancellazione IS NULL OR s_figlio.data_cancellazione IS NOT NULL AND date_trunc('day'::text, s_figlio.data_cancellazione) > date_trunc('day'::text, now())
        )
 SELECT row_number() OVER () AS id_v_settore,
    alberosettore.livello,
    alberosettore.settore_id_padre,
    alberosettore.settore_id,
    alberosettore.settore_codice,
    alberosettore.settore_descrizione,
    alberosettore.settore_indirizzo,
    alberosettore.settore_localita,
    alberosettore.settore_cap,
    alberosettore.settore_provincia,
    alberosettore.settore_telefono,
    alberosettore.settore_num_civico,
    alberosettore.settore_contatto,
    alberosettore.settore_email,
    alberosettore.ente_id,
    alberosettore.tipo_settore_id,
    alberosettore.flag_utilizzabile,
    alberosettore.settore_indirizzo_codice
   FROM alberosettore
  ORDER BY alberosettore.livello DESC, alberosettore.settore_codice;

-- Permissions

ALTER TABLE cpass.cpass_v_settore OWNER TO cpass;
GRANT ALL ON TABLE cpass.cpass_v_settore TO cpass;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE cpass.cpass_v_settore TO cpass_rw;


update cpass_t_settore 
set settore_indirizzo = 'corso Bolzano'
, settore_num_civico = '44'
, settore_localita = 'Torino'
, settore_provincia = 'TO'
, settore_cap = '10121'
, settore_telefono = '10121';
