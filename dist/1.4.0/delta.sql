---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================


CREATE TABLE if not exists cpass.CPASS_T_ORD_SEZIONE (
	 sezione_id SERIAL
	,sezione_codice VARCHAR(50)
	,sezione_descrizione VARCHAR(100)
    ,ente_id UUID not null
    ,CONSTRAINT CPASS_T_ORD_SEZIONE_pkey PRIMARY KEY(sezione_id)
  	,CONSTRAINT fk_CPASS_T_ORD_SEZIONE_t_ente FOREIGN KEY (ente_id) REFERENCES cpass_t_ente(ente_id)
);

CREATE TABLE if not exists cpass.CPASS_R_ORD_UTENTE_SEZIONE (
	 utente_sezione_id SERIAL
    ,sezione_id INTEGER NOT NULL
    ,utente_id UUID NOT NULL
    ,CONSTRAINT CPASS_R_ORD_UTENTE_SEZIONE_pkey PRIMARY KEY(utente_sezione_id)
  	,CONSTRAINT fk_R_ORD_UTENTE_SEZIONE_t_sezione FOREIGN KEY (sezione_id) REFERENCES CPASS_T_ORD_SEZIONE(sezione_id)
  	,CONSTRAINT fk_R_ORD_UTENTE_SEZIONE_t_utente  FOREIGN KEY (utente_id)  REFERENCES cpass_t_utente(utente_id)
);

--DROP TABLE if exists cpass.cpass_t_regole_smistamento_rms;
CREATE TABLE if not exists cpass.cpass_t_regole_smistamento_rms (
  regole_smistamento_rms_id SERIAL,
  oggetti_spesa_codice VARCHAR(50),
  cpv_codice VARCHAR(50),
  settore_codice VARCHAR(50),
  livello_cpv INTEGER,
  regola_cpv VARCHAR(10),
  tutta_la_struttura BOOLEAN DEFAULT false NOT NULL,
  centro_acquisto_id UUID,
  centro_acquisto_codice VARCHAR(50),
  sezione_acquisto_id INTEGER,
  sezione_acquisto_codice VARCHAR(50),
  magazzino_id INTEGER,
  magazzino_codice VARCHAR(50),
  ente_id UUID NOT NULL,
  CONSTRAINT cpass_t_regole_smistamento_rms_pkey PRIMARY KEY(regole_smistamento_rms_id),
  CONSTRAINT fk_cpass_t_ord_sezione_t_ente FOREIGN KEY (ente_id)
    REFERENCES cpass.cpass_t_ente(ente_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_t_ord_sezione_t_magazzino FOREIGN KEY (magazzino_id)
    REFERENCES cpass.cpass_t_mag_magazzino(magazzino_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_t_ord_sezione_t_settore FOREIGN KEY (centro_acquisto_id)
    REFERENCES cpass.cpass_t_settore(settore_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_t_ord_sezione_t_sezione FOREIGN KEY (sezione_acquisto_id)
    REFERENCES cpass.cpass_t_ord_sezione(sezione_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) 
WITH (oids = false);

CREATE TABLE if not exists cpass.CPASS_R_ORD_rda_ordine (
	 rda_ordine_id SERIAL
    ,testata_rda_id UUID NOT NULL
    ,testata_ordine_id UUID NOT NULL
    ,CONSTRAINT CPASS_R_ORD_rda_ordine_pkey PRIMARY KEY(rda_ordine_id)
  	,CONSTRAINT fk_R_ORD_rda_ordine_t_rda FOREIGN KEY (testata_rda_id) REFERENCES cpass_t_ord_testata_rda(testata_rda_id)
  	,CONSTRAINT fk_R_ORD_rda_ordine_t_ordine  FOREIGN KEY (testata_ordine_id)  REFERENCES cpass_t_ord_testata_ordine(testata_ordine_id)
);

ALTER TABLE IF EXISTS cpass.cpass_r_ord_riga_rda_riga_rms DROP CONSTRAINT IF EXISTS fk_cpass_r_ord_riga_rda_riga_rms_rda;
ALTER TABLE IF EXISTS cpass.cpass_r_ord_riga_rda_riga_rms ADD CONSTRAINT fk_cpass_r_ord_riga_rda_riga_rms_rda FOREIGN KEY (riga_rda_id)
REFERENCES cpass.cpass_t_ord_riga_rda(riga_rda_id);

CREATE TABLE if not exists cpass.CPASS_T_SCHEDULAZIONE_BATCH (
    schedulazione_batch_id SERIAL
    ,ente_id UUID NOT NULL
    ,ente_codice varchar(50) NOT NULL
    ,nome_job    varchar(50) NOT NULL
    ,attivazione boolean  NOT NULL default false
    ,parametri   varchar(4000)
    ,note        varchar(4000)
    ,CONSTRAINT CPASS_T_SCHEDULAZIONE_BATCH_pkey PRIMARY KEY(schedulazione_batch_id)
    ,CONSTRAINT fk_CPASS_T_SCHEDULAZIONE_BATCH_ente FOREIGN KEY (ente_id) REFERENCES cpass_t_ente(ente_id)
);

DROP VIEW if exists cpass.cpass_v_rms_da_smistare ;
CREATE or replace VIEW cpass.cpass_v_rms_da_smistare 
AS
SELECT
             row_number() OVER () AS rms_da_smistare_id
            ,testata.testata_rms_id
            ,testata.rms_anno 
            ,testata.rms_numero
            ,riga.progressivo_riga             
            ,testata.richiesta_magazzino 
            ,riga.riga_rms_id
            ,oggetti_spesa.oggetti_spesa_id
            ,oggetti_spesa.oggetti_spesa_codice as codice_ods
            ,cpv.cpv_id
            ,cpv.cpv_codice 				as codice_cpv 
            ,settore_padre.settore_id 		as struttura_richiedente_id
            ,settore.settore_codice 		as struttura_richiedente   
            ,settore_padre.settore_id 		as struttura_padre_id
            ,settore_padre.settore_codice 	as struttura_padre   
            ,riga.ente_id           
        FROM
        	 CPASS_T_RMS_TESTATA_RMS testata
        	,CPASS_T_RMS_RIGA_RMS    riga 
            ,CPASS_D_OGGETTI_SPESA   oggetti_spesa
            ,CPASS_D_CPV             cpv 
            ,CPASS_T_SETTORE         settore 
            ,CPASS_T_SETTORE         settore_padre 
            ,cpass_d_stato           stato_testata
            ,cpass_d_stato           stato_riga
        WHERE          
        	    testata.testata_rms_id = riga.testata_rms_id
            --AND riga.ente_id = v_ente_id
            AND oggetti_spesa.cpv_id         = cpv.cpv_id
            AND testata.stato_id             = stato_testata.stato_id 
            AND riga.oggetti_spesa_id        = oggetti_spesa.oggetti_spesa_id
            AND testata.settore_emittente_id = settore.settore_id
            AND settore.settore_padre_id     = settore_padre.settore_id
            AND stato_testata.stato_tipo     = 'RMS'        
            AND stato_testata.stato_codice   = 'AUTORIZZATA'                    
            AND stato_riga.stato_id          = riga.stato_id 
            AND stato_riga.stato_tipo        = 'RIGA_RMS'
            AND stato_riga.stato_codice      = 'NEW';
            
            
drop table if exists cpass.cpass_r_ord_riga_rda_riga_rms;
alter table cpass.cpass_t_rms_riga_rms add column if not exists riga_rda_id UUID;
ALTER TABLE IF EXISTS cpass.cpass_t_rms_riga_rms DROP CONSTRAINT IF EXISTS fk_cpass_t_rms_riga_rms_riga_rda;
ALTER TABLE IF EXISTS cpass.cpass_t_rms_riga_rms ADD CONSTRAINT fk_cpass_t_rms_riga_rms_riga_rda FOREIGN KEY (riga_rda_id)
REFERENCES cpass.cpass_t_ord_riga_rda(riga_rda_id);

alter table cpass.cpass_t_rms_riga_rms add column if not exists sezione_id int4 NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_rms_riga_rms DROP CONSTRAINT IF EXISTS fk_cpass_t_rms_riga_rms_sezione;
ALTER TABLE IF EXISTS cpass.cpass_t_rms_riga_rms ADD CONSTRAINT fk_cpass_t_rms_riga_rms_sezione FOREIGN KEY (sezione_id)
REFERENCES cpass_t_ord_sezione(sezione_id);

ALTER TABLE IF EXISTS cpass.cpass_t_mag_magazzino ADD COLUMN IF NOT EXISTS ente_id UUID;
ALTER TABLE IF EXISTS cpass.cpass_t_mag_magazzino DROP CONSTRAINT IF EXISTS fk_cpass_t_mag_magazzino_ente;
ALTER TABLE IF EXISTS cpass.cpass_t_mag_magazzino ADD CONSTRAINT fk_cpass_t_mag_magazzino_ente FOREIGN KEY (ente_id)
REFERENCES cpass.CPASS_t_ente(ente_id);


ALTER TABLE  cpass.cpass_t_pba_programma DROP CONSTRAINT if exists  idx_anno_versione_unique;
    ALTER TABLE ONLY cpass.cpass_t_pba_programma
    ADD CONSTRAINT idx_anno_versione_unique UNIQUE (programma_anno, programma_versione, ente_id);


CREATE OR REPLACE VIEW cpass.cpass_v_utente
AS SELECT u.utente_cognome,
    u.utente_nome,
    rus.ruolo_utente_settore_id,
    u.utente_codice_fiscale,
    s.settore_codice,
    r.ruolo_codice,
    rus.data_validita_inizio AS ruolo_utentesettore_inizio,
    rus.data_validita_fine AS ruolo_utentesettore_fine,
    us.data_validita_inizio AS utente_settore_inizio,
    us.data_validita_fine AS utente_settore_fine,
    e.ente_id ,
    e.ente_codice 
   FROM cpass_t_utente u
     JOIN cpass_r_utente_settore us ON us.utente_id = u.utente_id
     JOIN cpass_t_settore s ON us.settore_id = s.settore_id
     JOIN cpass_r_ruolo_utente_settore rus ON rus.utente_settore_id = us.utente_settore_id
     JOIN cpass_d_ruolo r ON r.ruolo_id = rus.ruolo_id
     join cpass_t_ente e on e.ente_id = s.ente_id 
  ORDER BY u.utente_codice_fiscale;
  
alter table if exists cpass.cpass_t_rms_testata_rms add column if not exists settore_indirizzo_id INTEGER NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_rms_testata_rms DROP CONSTRAINT IF EXISTS fk_cpass_t_rms_testata_settore_indirizzo;
ALTER TABLE IF EXISTS cpass.cpass_t_rms_testata_rms ADD CONSTRAINT fk_cpass_t_rms_testata_settore_indirizzo FOREIGN KEY (settore_indirizzo_id)
REFERENCES cpass.cpass_t_settore_indirizzo(settore_indirizzo_id);



ALTER TABLE IF EXISTS cpass.cpass_t_mag_magazzino ADD COLUMN IF NOT EXISTS data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_mag_magazzino ADD COLUMN IF NOT EXISTS utente_creazione VARCHAR(250) NOT NULL default 'admin';
ALTER TABLE IF EXISTS cpass.cpass_t_mag_magazzino ADD COLUMN IF NOT EXISTS data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_mag_magazzino ADD COLUMN IF NOT EXISTS utente_modifica VARCHAR(250) NOT NULL default 'admin';
ALTER TABLE IF EXISTS cpass.cpass_t_mag_magazzino ADD COLUMN IF NOT EXISTS data_cancellazione TIMESTAMP WITHOUT TIME ZONE;
ALTER TABLE IF EXISTS cpass.cpass_t_mag_magazzino ADD COLUMN IF NOT EXISTS utente_cancellazione VARCHAR(250);
ALTER TABLE IF EXISTS cpass.cpass_t_mag_magazzino ADD COLUMN IF NOT EXISTS optlock UUID DEFAULT uuid_generate_v4() NOT NULL;


ALTER TABLE IF EXISTS cpass.cpass_t_ord_sezione ADD COLUMN IF NOT EXISTS data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_sezione ADD COLUMN IF NOT EXISTS utente_creazione VARCHAR(250) NOT NULL default 'admin';
ALTER TABLE IF EXISTS cpass.cpass_t_ord_sezione ADD COLUMN IF NOT EXISTS data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_sezione ADD COLUMN IF NOT EXISTS utente_modifica VARCHAR(250) NOT NULL default 'admin';
ALTER TABLE IF EXISTS cpass.cpass_t_ord_sezione ADD COLUMN IF NOT EXISTS data_cancellazione TIMESTAMP WITHOUT TIME ZONE;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_sezione ADD COLUMN IF NOT EXISTS utente_cancellazione VARCHAR(250);
ALTER TABLE IF EXISTS cpass.cpass_t_ord_sezione ADD COLUMN IF NOT EXISTS optlock UUID DEFAULT uuid_generate_v4() NOT NULL;

ALTER TABLE IF EXISTS cpass.cpass_R_Ord_Utente_Sezione ADD COLUMN IF NOT EXISTS data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_R_Ord_Utente_Sezione ADD COLUMN IF NOT EXISTS utente_creazione VARCHAR(250) NOT NULL default 'admin';
ALTER TABLE IF EXISTS cpass.cpass_R_Ord_Utente_Sezione ADD COLUMN IF NOT EXISTS data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_R_Ord_Utente_Sezione ADD COLUMN IF NOT EXISTS utente_modifica VARCHAR(250) NOT NULL default 'admin';
ALTER TABLE IF EXISTS cpass.cpass_R_Ord_Utente_Sezione ADD COLUMN IF NOT EXISTS data_cancellazione TIMESTAMP WITHOUT TIME ZONE;
ALTER TABLE IF EXISTS cpass.cpass_R_Ord_Utente_Sezione ADD COLUMN IF NOT EXISTS utente_cancellazione VARCHAR(250);
ALTER TABLE IF EXISTS cpass.cpass_R_Ord_Utente_Sezione ADD COLUMN IF NOT EXISTS optlock UUID DEFAULT uuid_generate_v4() NOT NULL;

alter table IF EXISTS cpass_t_ord_sezione add column IF NOT EXISTS settore_id UUID;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_sezione DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_sezione_settore;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_sezione ADD CONSTRAINT fk_cpass_t_ord_sezione_settore FOREIGN KEY (settore_id)
REFERENCES cpass.cpass_t_settore(settore_id);

alter table cpass.cpass_t_rms_riga_rms add column if not exists quantita_su_rda numeric(8,2);

ALTER TABLE IF EXISTS cpass.cpass_t_elaborazione ADD COLUMN IF NOT EXISTS ente_id UUID;
ALTER TABLE IF EXISTS cpass.cpass_t_elaborazione DROP CONSTRAINT IF EXISTS fk_cpass_t_elaborazione_ente;
ALTER TABLE IF EXISTS cpass.cpass_t_elaborazione ADD CONSTRAINT fk_cpass_t_elaborazione_ente FOREIGN KEY (ente_id)
REFERENCES cpass.CPASS_t_ente(ente_id);


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
          WHERE s.settore_padre_id IS NULL AND (s.data_cancellazione IS NULL OR s.data_cancellazione IS NOT NULL AND s.data_cancellazione >= date_trunc('day'::text, now())) AND s.tipo_settore_id = ts.tipo_settore_id
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
          WHERE s_figlio.data_cancellazione IS NULL OR s_figlio.data_cancellazione IS NOT NULL AND s_figlio.data_cancellazione >= date_trunc('day'::text, now())
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

-----------------------------------------------------------------------------------------------------------------
------------------------------------------------ DATI -----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

INSERT INTO cpass.cpass_d_elaborazione_tipo (elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
SELECT tmp.elaborazione_tipo_codice, tmp.elaborazione_tipo_descrizione, tmp.modulo_codice
FROM (VALUES
  ('SMISTAMENTO_RMS','SMISTAMENTO_RMS','RMS')
  ,('ALIMENTAZIONE_REGOLE_SMISTAMENTO','ALIMENTAZIONE_REGOLE_SMISTAMENTO','RMS')
) AS tmp(elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo current
  WHERE current.elaborazione_tipo_codice = tmp.elaborazione_tipo_codice
);


INSERT INTO cpass.cpass_t_testi_notifiche (codice, it_testo, en_testo)
SELECT tmp.codice, tmp.it_testo, tmp.en_testo
FROM ( VALUES
    ('N0004','Alcune righe RMS non sono state smistate','Some RMS lines were not sorted')
	) AS tmp(codice, it_testo, en_testo)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_testi_notifiche tp
	WHERE tp.codice = tmp.codice
);

insert into cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
select tmp.codice, tmp.descrizione, tmp.tipo
from ( values
	('BOZZA','BOZZA','RDA'),
	('AUTORIZZATA','AUTORIZZATA','RDA'),
	('ANNULLATA','ANNULLATA','RDA'),
	('DAE','DA EVADERE','RIGA_RDA'),
	('EVT','EVASA TOTALMENTE','RIGA_RDA'),
	('ADE','ANNULLATA DA EVADERE','RIGA_RDA')	
)AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato ts
  WHERE ts.stato_codice = tmp.codice
  AND ts.stato_tipo = tmp.tipo
);

INSERT INTO cpass.cpass_t_parametro_stampa (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
SELECT tmp.modulo, tmp.nome_stampa, tmp.file_name_template, tmp.parametro, tmp.parametro_tipo, tmp.ordinamento, tmp.procedure_utilizzate, tmp.note, tmp.formato_stampa
FROM (VALUES
     ('RMS', 'REGOLE_SMISTAMENTO_RMS', 'Estrazione_Regole_Smistamento.rptdesign', 'p_ente_id','varchar', 1, null, NULL, 'xls')
) AS tmp (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
WHERE NOT EXISTS (
    SELECT 1
    FROM cpass_t_parametro_stampa tps
    WHERE tps.modulo = tmp.modulo
    AND tps.nome_stampa = tmp.nome_stampa
    AND tps.parametro = tmp.parametro
    AND tps.ordinamento = tmp.ordinamento
);
            
-- MODULO BACKOFFICE
INSERT INTO cpass.cpass_d_modulo (modulo_codice, modulo_descrizione)
SELECT tmp.modulo_codice, tmp.modulo_descrizione
FROM (VALUES
  ('BO','Back Office')
) AS tmp(modulo_codice, modulo_descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_modulo current
  WHERE current.modulo_codice = tmp.modulo_codice
);

INSERT INTO cpass.cpass_d_ruolo (ruolo_codice, ruolo_descrizione)
SELECT tmp.ruolo_codice, tmp.ruolo_descrizione
FROM(VALUES
  ('SMISTATORE_RMS','UTENTE ABILITATO ALLO SMISTAMENTO MANUALE DELLE RMS')
) AS tmp(ruolo_codice, ruolo_descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_ruolo current
  WHERE current.ruolo_codice = tmp.ruolo_codice
);

INSERT INTO cpass_r_ruolo_modulo (ruolo_id, modulo_id)
SELECT dr.ruolo_id, dm.modulo_id
FROM (VALUES
('SMISTATORE_RMS', 'BO')
) AS tmp(ruolo, modulo)
JOIN cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass_d_modulo dm ON dm.modulo_codice = tmp.modulo
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_r_ruolo_modulo rrm
	WHERE rrm.ruolo_id = dr.ruolo_id
	AND rrm.modulo_id = dm.modulo_id
);

INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo
FROM (VALUES
	('SMISTA_RMS','Smista la richiesta','BO',true,'V'),
	('ALIMENTA_RMS','Alimenta la tabella delle regole di smistamento','BO',true,'V')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('ADMIN','SMISTA_RMS'),
('ADMIN','ALIMENTA_RMS'),
('SMISTATORE_RMS','SMISTA_RMS'),
('SMISTATORE_RMS','ALIMENTA_RMS')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati ALTER COLUMN iva_primo_anno TYPE numeric USING iva_primo_anno::numeric;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati ALTER COLUMN iva_secondo_anno TYPE numeric USING iva_secondo_anno::numeric;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati ALTER COLUMN iva_anni_successivi TYPE numeric USING iva_anni_successivi::numeric;

/*
INSERT INTO cpass.cpass_d_pba_acquisto_variato(acquisto_variato_codice, acquisto_variato_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
  ('1', 'modifica ex art.7 comma 8 lettera b)'),
  ('2', 'modifica ex art.7 comma 8 lettera c)'),
  ('3', 'modifica ex art.7 comma 8 lettera d)'),
  ('4', 'modifica ex art.7 comma 8 lettera e)'),
  ('5', 'modifica ex art.7 comma 9'),
  ('', 'modifica ex art.7 comma 8 lettera a') 
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_pba_acquisto_variato dav
  WHERE dav.acquisto_variato_codice = tmp.codice
);*/

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('ADMIN', 'CHIUDI_ORDINE')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);
-- inserimento associazioni ruoli / permessi mancanti
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('ADMIN','ALIMENTA_RMS'),
('ADMIN','ALIMENTAZIONE_DA_FONTE_ESTERNA'),
('ADMIN','ANN_EVASIONE'),
('ADMIN','ANN_INTERVENTO_APPROV_ALL'),
('ADMIN','ANN_INTERVENTO_BOZZA_ALL'),
('ADMIN','ANN_INTERVENTO_VISTO_ALL'),
('ADMIN','ANN_ORDINE'),
('ADMIN','ANN_PROGRAMMA_APPROV'),
('ADMIN','ANN_PROGRAMMA_BOZZA'),
('ADMIN','ANN_RICHIESTA'),
('ADMIN','AUTORIZZA_EVASIONE'),
('ADMIN','AUTORIZZA_ORDINE'),
('ADMIN','AUTORIZZA_RICHIESTA'),
('ADMIN','CANC_DETT_EVASIONE'),
('ADMIN','CANC_DETT_ORDINE'),
('ADMIN','CANC_DETT_RICHIESTA'),
('ADMIN','CANC_EVASIONE'),
('ADMIN','CANC_ORDINE'),
('ADMIN','CANC_RICHIESTA'),
('ADMIN','CARICA_INTERVENTI_ANNI_PREC'),
('ADMIN','CHIUDI_ORDINE'),
('ADMIN','CONFERMA_ORDINE'),
('ADMIN','CONFERMA_RICHIESTA'),
('ADMIN','CONF_PROGRAMMA'),
('ADMIN','CONSULTA_EVASIONE'),
('ADMIN','CONSULTA_ORDINE'),
('ADMIN','CONSULTA_RICHIESTA'),
('ADMIN','CONTROLLA_ORDINE'),
('ADMIN','COPIA_PROGRAMMA'),
('ADMIN','INS_DETT_EVASIONE'),
('ADMIN','INS_DETT_ORDINE'),
('ADMIN','INS_DETT_RICHIESTA'),
('ADMIN','INS_EVASIONE'),
('ADMIN','INS_INTERVENTO'),
('ADMIN','INS_INTERVENTO_FIELD'),
('ADMIN','INS_ORDINE'),
('ADMIN','INS_PROGRAMMA'),
('ADMIN','INS_RICHIESTA'),
('ADMIN','INVIA_EVASIONE_CONTABILITA'),
('ADMIN','INVIA_ORDINE_A_NSO'),
('ADMIN','MOD_DETT_EVASIONE'),
('ADMIN','MOD_DETT_ORDINE'),
('ADMIN','MOD_DETT_RICHIESTA'),
('ADMIN','MOD_EVASIONE'),
('ADMIN','MOD_INTERVENTO_ALL'),
('ADMIN','MOD_ORDINE'),
('ADMIN','MOD_PROGRAMMA'),
('ADMIN','MOD_RICHIESTA'),
('ADMIN','PRENDI_IN_CARICO_INTERVENTO'),
('ADMIN','RIFIUTA_INTERVENTO_ALL'),
('ADMIN','RIFIUTA_RICHIESTA'),
('ADMIN','SMISTA_RMS'),
('ADMIN','STAMPA_INTERVENTO'),
('ADMIN','TRASMETTI_PROGRAMMA'),
('ADMIN','VALIDA_INTERVENTO_ALL'),
('ADMIN','VISTA_INTERVENTO_ALL'),
('ADMIN','VOLTURA_INTERVENTO_ALL'),
('CHIUSURA_ORDINI','CHIUDI_ORDINE'),
('COMPILATORE','ALIMENTAZIONE_DA_FONTE_ESTERNA'),
('COMPILATORE','ANN_INTERVENTO_BOZZA'),
('COMPILATORE','INS_INTERVENTO'),
('COMPILATORE','MOD_INTERVENTO'),
('COMPILATORE','STAMPA_INTERVENTO'),
('DELEGATO_REFP','ALIMENTAZIONE_DA_FONTE_ESTERNA'),
('DELEGATO_REFP','ANN_INTERVENTO_APPROV_ALL'),
('DELEGATO_REFP','ANN_INTERVENTO_BOZZA_ALL'),
('DELEGATO_REFP','ANN_INTERVENTO_VISTO_ALL'),
('DELEGATO_REFP','ANN_PROGRAMMA_APPROV'),
('DELEGATO_REFP','CARICA_INTERVENTI_ANNI_PREC'),
('DELEGATO_REFP','COPIA_PROGRAMMA'),
('DELEGATO_REFP','INS_INTERVENTO'),
('DELEGATO_REFP','INS_INTERVENTO_FIELD'),
('DELEGATO_REFP','INS_PROGRAMMA'),
('DELEGATO_REFP','MOD_INTERVENTO_ALL'),
('DELEGATO_REFP','MOD_PROGRAMMA'),
('DELEGATO_REFP','RIFIUTA_INTERVENTO_ALL'),
('DELEGATO_REFP','STAMPA_INTERVENTO'),
('DELEGATO_REFP','VALIDA_INTERVENTO_ALL'),
('DELEGATO_REFP','VISTA_INTERVENTO_ALL'),
('DELEGATO_RUP','ALIMENTAZIONE_DA_FONTE_ESTERNA'),
('DELEGATO_RUP','ANN_INTERVENTO_APPROV'),
('DELEGATO_RUP','ANN_INTERVENTO_BOZZA'),
('DELEGATO_RUP','ANN_INTERVENTO_VISTO'),
('DELEGATO_RUP','CARICA_INTERVENTI_ANNI_PREC'),
('DELEGATO_RUP','INS_INTERVENTO'),
('DELEGATO_RUP','MOD_INTERVENTO'),
('DELEGATO_RUP','PRENDI_IN_CARICO_INTERVENTO'),
('DELEGATO_RUP','STAMPA_INTERVENTO'),
('DELEGATO_RUP','VISTA_INTERVENTO'),
('INTERRORD','CONSULTA_ORDINE'),
('ORDINATORE','ANN_EVASIONE'),
('ORDINATORE','ANN_ORDINE'),
('ORDINATORE','AUTORIZZA_EVASIONE'),
('ORDINATORE','AUTORIZZA_ORDINE'),
('ORDINATORE','CANC_DETT_EVASIONE'),
('ORDINATORE','CANC_DETT_ORDINE'),
('ORDINATORE','CANC_EVASIONE'),
('ORDINATORE','CANC_ORDINE'),
('ORDINATORE','CONFERMA_ORDINE'),
('ORDINATORE','CONSULTA_EVASIONE'),
('ORDINATORE','CONSULTA_ORDINE'),
('ORDINATORE','CONTROLLA_ORDINE'),
('ORDINATORE','INS_DETT_EVASIONE'),
('ORDINATORE','INS_DETT_ORDINE'),
('ORDINATORE','INS_EVASIONE'),
('ORDINATORE','INS_ORDINE'),
('ORDINATORE','INVIA_EVASIONE_CONTABILITA'),
('ORDINATORE','MOD_DETT_EVASIONE'),
('ORDINATORE','MOD_DETT_ORDINE'),
('ORDINATORE','MOD_EVASIONE'),
('ORDINATORE','MOD_ORDINE'),
('ORDINSEMPLICE','CANC_DETT_EVASIONE'),
('ORDINSEMPLICE','CANC_DETT_ORDINE'),
('ORDINSEMPLICE','CANC_EVASIONE'),
('ORDINSEMPLICE','CANC_ORDINE'),
('ORDINSEMPLICE','CONSULTA_EVASIONE'),
('ORDINSEMPLICE','CONSULTA_ORDINE'),
('ORDINSEMPLICE','INS_DETT_EVASIONE'),
('ORDINSEMPLICE','INS_DETT_ORDINE'),
('ORDINSEMPLICE','INS_EVASIONE'),
('ORDINSEMPLICE','INS_ORDINE'),
('ORDINSEMPLICE','MOD_DETT_EVASIONE'),
('ORDINSEMPLICE','MOD_DETT_ORDINE'),
('ORDINSEMPLICE','MOD_EVASIONE'),
('ORDINSEMPLICE','MOD_ORDINE'),
('OSS','STAMPA_INTERVENTO'),
('REFP','ALIMENTAZIONE_DA_FONTE_ESTERNA'),
('REFP','ANN_INTERVENTO_APPROV_ALL'),
('REFP','ANN_INTERVENTO_BOZZA_ALL'),
('REFP','ANN_INTERVENTO_VISTO_ALL'),
('REFP','ANN_PROGRAMMA_APPROV'),
('REFP','ANN_PROGRAMMA_BOZZA'),
('REFP','CARICA_INTERVENTI_ANNI_PREC'),
('REFP','CONF_PROGRAMMA'),
('REFP','COPIA_PROGRAMMA'),
('REFP','INS_INTERVENTO'),
('REFP','INS_INTERVENTO_FIELD'),
('REFP','INS_PROGRAMMA'),
('REFP','MOD_INTERVENTO_ALL'),
('REFP','MOD_PROGRAMMA'),
('REFP','RIFIUTA_INTERVENTO_ALL'),
('REFP','STAMPA_INTERVENTO'),
('REFP','TRASMETTI_PROGRAMMA'),
('REFP','VALIDA_INTERVENTO_ALL'),
('REFP','VISTA_INTERVENTO_ALL'),
('REFP','VOLTURA_INTERVENTO_ALL'),
('RICHIEDENTE_RMS','ANN_RICHIESTA'),
('RICHIEDENTE_RMS','CANC_DETT_RICHIESTA'),
('RICHIEDENTE_RMS','CANC_RICHIESTA'),
('RICHIEDENTE_RMS','CONFERMA_RICHIESTA'),
('RICHIEDENTE_RMS','CONSULTA_RICHIESTA'),
('RICHIEDENTE_RMS','INS_DETT_RICHIESTA'),
('RICHIEDENTE_RMS','INS_RICHIESTA'),
('RICHIEDENTE_RMS','MOD_DETT_RICHIESTA'),
('RICHIEDENTE_RMS','MOD_RICHIESTA'),
('RUO','RIFIUTA_INTERVENTO_SU_GERARCHIA'),
('RUO','STAMPA_INTERVENTO'),
('RUO','VALIDA_INTERVENTO_SU_GERARCHIA'),
('RUP','ALIMENTAZIONE_DA_FONTE_ESTERNA'),
('RUP','ANN_INTERVENTO_APPROV'),
('RUP','ANN_INTERVENTO_BOZZA'),
('RUP','ANN_INTERVENTO_VISTO'),
('RUP','CARICA_INTERVENTI_ANNI_PREC'),
('RUP','INS_INTERVENTO'),
('RUP','MOD_INTERVENTO'),
('RUP','PRENDI_IN_CARICO_INTERVENTO'),
('RUP','STAMPA_INTERVENTO'),
('RUP','VISTA_INTERVENTO'),
('SMISTATORE_RMS','ALIMENTA_RMS'),
('SMISTATORE_RMS','SMISTA_RMS'),
('TRASM_NSO','CONSULTA_ORDINE'),
('TRASM_NSO','INVIA_ORDINE_A_NSO'),
('VALIDATORE_RMS','ANN_RICHIESTA'),
('VALIDATORE_RMS','AUTORIZZA_RICHIESTA'),
('VALIDATORE_RMS','CONSULTA_RICHIESTA'),
('VALIDATORE_RMS','RIFIUTA_RICHIESTA')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);