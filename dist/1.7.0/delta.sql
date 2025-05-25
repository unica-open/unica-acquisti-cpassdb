---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
alter table cpass_t_ufficio add column if not exists ente_id uuid;

ALTER TABLE IF EXISTS cpass_t_ufficio   drop constraint  if exists  fk_cpass_t_ufficio_ente;

ALTER TABLE IF EXISTS cpass_t_ufficio   add constraint  fk_cpass_t_ufficio_ente FOREIGN KEY (ente_id)
REFERENCES cpass.cpass_t_ente (ente_id);

ALTER TABLE IF EXISTS cpass.CPASS_T_SETTORE_INDIRIZZO ADD COLUMN IF NOT EXISTS MAGAZZINO_ID INTEGER;
ALTER TABLE IF EXISTS cpass.CPASS_T_SETTORE_INDIRIZZO ADD COLUMN IF NOT EXISTS ESTERNO_ENTE BOOLEAN DEFAULT false NOT NULL;

ALTER TABLE CPASS_T_SETTORE_INDIRIZZO
DROP CONSTRAINT if exists fk_CPASS_T_SETTORE_INDIRIZZO_t_magazzino; 
ALTER TABLE IF EXISTS CPASS_T_SETTORE_INDIRIZZO  add constraint  fk_CPASS_T_SETTORE_INDIRIZZO_t_magazzino FOREIGN KEY (magazzino_id)
REFERENCES cpass.cpass_t_mag_magazzino(magazzino_id);


CREATE TABLE if not exists cpass.CPASS_T_AGGIORNAMENTO_STRUTTURA (
     AGGIORNAMENTO_STRUTTURA_id SERIAL
    ,settore_vecchio varchar(50) not null	
    ,settore_nuovo varchar(50) not null		
    ,tipo_settore varchar(50) not null		
    ,descrizione_settore varchar(500) not null		
    ,settore_padre varchar(50) not null		
    ,azione varchar(50) not null	
    ,ente_code varchar(10) not null
    ,CONSTRAINT AGGIORNAMENTO_STRUTTURA_pkey PRIMARY KEY(AGGIORNAMENTO_STRUTTURA_id)
);

ALTER TABLE IF EXISTS cpass.CPASS_T_AGGIORNAMENTO_STRUTTURA DROP CONSTRAINT IF EXISTS azione_check;

ALTER TABLE cpass.CPASS_T_AGGIORNAMENTO_STRUTTURA ADD CONSTRAINT azione_check 
CHECK (azione = 'SOSTITUZIONE' 
      OR azione = 'CHIUSURA'
      OR azione = 'APERTURA'
      OR azione = 'SCORPORO'
      OR azione = 'ACCORPAMENTO'
);

CREATE TABLE if not exists cpass.CPASS_T_AGGIORNAMENTO_STRUTTURA (
     AGGIORNAMENTO_STRUTTURA_id SERIAL
    ,settore_vecchio varchar(50) 
    ,settore_nuovo varchar(50) 	
    ,tipo_settore varchar(50) 	
    ,descrizione_settore varchar(50) 	
    ,settore_padre varchar(50) 
    ,azione varchar(50) not null	
    ,ente_code varchar(10) not null
    ,CONSTRAINT AGGIORNAMENTO_STRUTTURA_pkey PRIMARY KEY(AGGIORNAMENTO_STRUTTURA_id)
);

ALTER TABLE cpass.cpass_t_aggiornamento_struttura
  ALTER COLUMN settore_vecchio DROP NOT NULL;

alter table if exists cpass_t_aggiornamento_struttura add column if not exists esito varchar(250);

ALTER TABLE cpass_t_aggiornamento_struttura
DROP CONSTRAINT if exists cpass_t_aggiornamento_struttura_unique; 

ALTER TABLE cpass_t_aggiornamento_struttura
ADD CONSTRAINT cpass_t_aggiornamento_struttura_unique UNIQUE (settore_vecchio,settore_nuovo,ente_code);

ALTER TABLE cpass_t_settore
DROP CONSTRAINT if exists cpass_t_settore_unique; 
ALTER TABLE cpass_t_settore
ADD CONSTRAINT cpass_t_settore_unique UNIQUE (settore_codice,ente_id);

alter table CPASS_D_TIPO_SETTORE add column if not exists posizione integer default 0 not null;

ALTER TABLE cpass.cpass_t_provvedimento
  ALTER COLUMN provvedimento_descrizione TYPE VARCHAR(2000);
  
ALTER TABLE cpass.cpass_t_provvedimento
  ALTER COLUMN provvedimento_oggetto TYPE VARCHAR(2000) ;  
  
ALTER TABLE cpass.cpass_t_ord_testata_ordine
  ALTER COLUMN provvedimento_descrizione TYPE VARCHAR(2000) COLLATE pg_catalog."default";
  
--select * from cpass_d_stato order by stato_tipo ,stato_codice, stato_id
--delete from cpass_d_stato where stato_id >= 65

ALTER TABLE cpass_d_stato DROP CONSTRAINT if  exists cpass_d_stato_unique;
ALTER TABLE cpass_d_stato ADD CONSTRAINT cpass_d_stato_unique UNIQUE (stato_codice,stato_tipo);
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO cpass.cpass_d_ruolo(ruolo_codice, ruolo_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
	('GESTORE_STRUTTURA', 'UTENTE ABILITATO AD INSERIRE E MODIFICARE LA STRUTTURA ORGANIZZATIVA')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_ruolo dr
	WHERE dr.ruolo_codice = tmp.codice
);
INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo, disattivabile, attivo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo, tmp.disattivabile, tmp.attivo
FROM (VALUES
	('INS_STRUTTURA','Inserisce un nuovo elemento nella struttura organizzativa dell''ente','BO',false,'B', 'SI', true),
	('MOD_STRUTTURA','Modifica un elemento nella struttura organizzativa dell''ente','BO',false,'B', 'SI', true)
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo, disattivabile, attivo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('GESTORE_STRUTTURA','INS_STRUTTURA'),
	('GESTORE_STRUTTURA','MOD_STRUTTURA'),
	('ADMIN','INS_STRUTTURA'),
	('ADMIN','MOD_STRUTTURA')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);
  
  INSERT INTO cpass.cpass_d_elaborazione_tipo (elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
SELECT tmp.elaborazione_tipo_codice, tmp.elaborazione_tipo_descrizione, tmp.modulo_codice
FROM (VALUES
   ('AGG_STRUTTURA','AGG_STRUTTURA','BO')
) AS tmp(elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo current
  WHERE current.elaborazione_tipo_codice = tmp.elaborazione_tipo_codice
);
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('ORDINSEMPLICE','CONTROLLA_ORDINE')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);


update cpass_d_tipo_settore set posizione = 0
where tipo_settore_codice in ('R1-003');

update cpass_d_tipo_settore set posizione = 1
where tipo_settore_codice in ('R1-003');

update cpass_d_tipo_settore set posizione = 10
where tipo_settore_codice in ('R1-002');

update cpass_d_tipo_settore set posizione = 20
where tipo_settore_codice in ('R1-005');

update cpass_d_tipo_settore set posizione = 30
where tipo_settore_codice in ('R1-006');

update cpass_d_tipo_settore set posizione = 40
where tipo_settore_codice in ('R1-007');

update cpass_d_tipo_settore set posizione = 100 
where tipo_settore_codice in ('R1-010');

update cpass_d_tipo_settore set posizione = 200 
where tipo_settore_codice in (
 'R1-001'
,'R1-004'
,'R1-012'
,'R1-013'
,'R1-014'
,'R1-016'
,'R1-024'
);

update cpass_d_tipo_settore set posizione = 300 
where tipo_settore_codice in (
'R1-008'
,'R1-009'
,'R1-011'
,'R1-015'
,'R1-020'
,'R1-021'
,'R1-022'
,'R1-023'
);

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Cancellazione di acquisto già previsto nell''elenco annuale'
where acquisto_variato_codice is null;

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Aggiunta acquisto in conseguenza di atto amministrativo'
where acquisto_variato_codice = '1';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Aggiunta acquisto per sopravvenuta disponibilita'' di finanziamenti, comprese risorse disponibili anche a seguito di ribassi d''asta o economie'
where acquisto_variato_codice = '2';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Anticipazione prima annualita'' di acquisizione della fornitura o servizio'
where acquisto_variato_codice = '3';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Modifica quadro economico dell''acquisto previsto nell''elenco annuale in caso di nuove risorse'
where acquisto_variato_codice = '4';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Acquisto reso necessario da eventi imprevedibili o calamitosi o da sopravvenute disposizioni di legge o regolamentari o non previsto nell''elenco annuale realizzabile con un autonomo piano finanziario'
where acquisto_variato_codice = '5';



delete from cpass_t_schedulazione_batch;
INSERT INTO cpass.cpass_t_schedulazione_batch VALUES (1, '0ced449c-a147-5419-802f-01acfab32807', 'CMTO', 'VERIFICA_INVIO_CONTABILITA', true, '');
INSERT INTO cpass.cpass_t_schedulazione_batch VALUES (2, '0ced449c-a147-5419-802f-01acfab32807', 'CMTO', 'AGGIORNAMENTO_IMPEGNI', true, '');
INSERT INTO cpass.cpass_t_schedulazione_batch VALUES (3, '0ced449c-a147-5419-802f-01acfab32807', 'CMTO', 'DDT', false, '');
INSERT INTO cpass.cpass_t_schedulazione_batch VALUES (4, '0ced449c-a147-5419-802f-01acfab32807', 'CMTO', 'RECUPERO_NOTIFICA_NSO', false, '');
INSERT INTO cpass.cpass_t_schedulazione_batch VALUES (5, '0ced449c-a147-5419-802f-01acfab32807', 'CMTO', 'SMISTATORE', true, '');
INSERT INTO cpass.cpass_t_schedulazione_batch VALUES (6, '0ced449c-a147-5419-802f-01acfab32807', 'CMTO', 'STORICO_FILE_DDT', false, 'batch storico file ddt');
INSERT INTO cpass.cpass_t_schedulazione_batch VALUES (7, '0ced449c-a147-5419-802f-01acfab32807', 'CMTO', 'STORICO_FILE_NSO', false, 'batch storico file nso');
INSERT INTO cpass.cpass_t_schedulazione_batch VALUES (8, '0ced449c-a147-5419-802f-01acfab32807', 'CMTO', 'AGG_STRUTTURA', true, 'batch aggiornamento struttura organizzativa');


