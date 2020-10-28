---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2020 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2020 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
---
--rename table
ALTER TABLE cpass.cpass_d_ausa	 RENAME TO cpass_d_pba_ausa ;
ALTER TABLE cpass.cpass_t_intervento_importi RENAME TO 	cpass_t_pba_intervento_importi ;
ALTER TABLE cpass.cpass_t_intervento RENAME TO 	cpass_t_pba_intervento ;
ALTER TABLE cpass.cpass_t_programma	 RENAME TO cpass_t_pba_programma ;
ALTER TABLE cpass.cpass_d_settore_interventi RENAME TO 	cpass_d_pba_settore_interventi ;
ALTER TABLE cpass.cpass_d_mod_affidamento RENAME TO 	cpass_d_pba_mod_affidamento ;
ALTER TABLE cpass.cpass_d_priorita	 RENAME TO cpass_d_pba_priorita ;
ALTER TABLE cpass.cpass_d_nuts	 RENAME TO cpass_d_pba_nuts ;
ALTER TABLE cpass.cpass_d_risorsa RENAME TO cpass_d_pba_risorsa ;
ALTER TABLE cpass.cpass_d_ricompreso_tipo RENAME TO cpass_d_pba_ricompreso_tipo ;
ALTER TABLE cpass.cpass_d_acquisto_variato	 RENAME TO cpass_d_pba_acquisto_variato;
-- add column
alter table cpass.cpass_t_pba_programma add column numero_provvedimento integer ;
alter table cpass.cpass_t_pba_programma add column descrizione_provvedimento varchar(500) ;
alter table cpass.cpass_t_pba_programma add column data_provvedimento Timestamp ;
alter table cpass.cpass_t_pba_programma add column data_pubblicazione Timestamp ;
alter table cpass.cpass_t_pba_programma add column url varchar(500) ;
ALTER TABLE cpass.cpass_t_pba_programma add column utente_referente_id UUID NOT NULL;
ALTER TABLE cpass.cpass_t_pba_programma add column programma_descrizione varchar(200);
alter table cpass.cpass_t_pba_programma add column programma_versione integer Default 1 NOT NULL;
alter table cpass.cpass_t_pba_programma add column programma_codice_mit varchar(20) Default '00000000000000000000' NOT NULL;
alter table cpass.cpass_t_pba_programma  add column id_ricevuto_mit Integer;
alter table cpass.cpass_t_pba_programma  add column data_approvazione Timestamp;


alter table cpass.cpass_t_pba_intervento add column flag_cui_non_generato boolean Default false ;
alter table cpass.cpass_t_pba_intervento add column motivazione_non_riproposto varchar(500);
alter table cpass.cpass_t_pba_intervento add column intervento_copia_id UUID;
alter table cpass.cpass_t_pba_intervento add column intervento_copia_tipo varchar(50);
alter table cpass.cpass_t_pba_intervento add column intervento_importi_copia_tipo varchar(50);
alter table cpass.cpass_d_pba_risorsa    add column risorsa_tag_trasmissione varchar(200)  ;
alter table cpass.cpass_d_pba_risorsa    add column risorsa_ordinamento INTEGER;

alter table cpass_t_ente add column codice_ipa_amministrazione	varchar(200);
alter table cpass_t_ente add column dipartimento	varchar(200);	
alter table cpass_t_ente add column ufficio	varchar(200);	
alter table cpass_t_ente add column regione	varchar(200);	
alter table cpass_t_ente add column provincia	varchar(200);	
alter table cpass_t_ente add column indirizzo	varchar(200);	
alter table cpass_t_ente add column telefono	varchar(200);	
alter table cpass_t_ente add column email	varchar(200);	
alter table cpass_t_ente add column emailPEC	varchar(200);

alter table cpass_t_ente add column ente_codice	varchar(50);

alter table cpass_t_utente add column telefono	varchar(200);
alter table cpass_t_utente add column email	varchar(200);

ALTER TABLE  cpass.cpass_t_pba_intervento 
ADD CONSTRAINT fk_cpass_t_intervento_t_intervento_copia FOREIGN KEY (intervento_copia_id) 
REFERENCES cpass.cpass_t_pba_intervento (intervento_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--drop column    
ALTER TABLE cpass.cpass_t_pba_programma  DROP COLUMN programma_referente;

ALTER TABLE cpass_t_pba_programma
ADD CONSTRAINT cpass_t_pba_programma_anno_versione_unique UNIQUE (programma_anno,programma_versione);

ALTER TABLE cpass_t_pba_intervento
ADD CONSTRAINT cpass_t_pba_intervento_cui_programma_unique UNIQUE (programma_id,intervento_cui);


drop table IF EXISTS cpass.cpass_t_elaborazione_messaggio;
drop table IF EXISTS cpass.cpass_t_elaborazione_parametro;
drop table IF EXISTS cpass.cpass_t_elaborazione;
drop table IF EXISTS cpass.cpass_d_elaborazione_tipo;

DROP TABLE IF EXISTS cpass.cpass_d_elaborazione_tipo CASCADE;
CREATE TABLE cpass.cpass_d_elaborazione_tipo (
	elaborazione_tipo_id SERIAL PRIMARY KEY,
	elaborazione_tipo_codice VARCHAR(50) NOT NULL,
	elaborazione_tipo_descrizione VARCHAR(500) NOT NULL,
	modulo_codice VARCHAR(50) NOT NULL
);

create table cpass.cpass_t_elaborazione (
   elaborazione_id SERIAL PRIMARY KEY
  ,entita_id  VARCHAR(200) NOT NULL
  ,elaborazione_utente  VARCHAR(50) NOT NULL
  ,elaborazione_stato  VARCHAR(50) NOT NULL
  ,elaborazione_data timestamp
  ,elaborazione_esito VARCHAR(50)
  ,elaborazione_tipo_id INTEGER
);

ALTER TABLE cpass.cpass_t_elaborazione ADD CONSTRAINT fk_cpass_d_elaborazione_tipo_t_elaborazione FOREIGN KEY (elaborazione_tipo_id) REFERENCES cpass_d_elaborazione_tipo (elaborazione_tipo_id);


create table cpass.cpass_t_elaborazione_messaggio (
   elaborazione_messaggio_id SERIAL  PRIMARY KEY
  ,elaborazione_id INTEGER  NOT NULL
  ,elaborazione_messaggio_tipo  VARCHAR(50) NOT NULL
  ,elaborazione_messaggio_code  VARCHAR(100) 
  ,elaborazione_messaggio_descrizione  VARCHAR(4000) 
);

ALTER TABLE cpass.cpass_t_elaborazione_messaggio ADD CONSTRAINT fk_cpass_t_elaborazione_messaggio_t_elaborazione FOREIGN KEY (elaborazione_id) REFERENCES cpass_t_elaborazione (elaborazione_id);


create table cpass.cpass_t_elaborazione_parametro (
   elaborazione_parametro_id SERIAL  PRIMARY KEY
  ,elaborazione_id INTEGER  NOT NULL
  ,elaborazione_parametro_chiave  VARCHAR(50) NOT NULL
  ,elaborazione_parametro_valore  VARCHAR(4000) 
);

ALTER TABLE cpass.cpass_t_elaborazione_parametro 
ADD CONSTRAINT fk_cpass_t_elaborazione_parametro_t_elaborazione 
FOREIGN KEY (elaborazione_id) REFERENCES cpass_t_elaborazione (elaborazione_id)
;



-- nuova tabella cpass_t_parametro - inizio
drop table IF EXISTS cpass.cpass_t_parametro;
create table cpass.cpass_t_parametro (
   parametro_id SERIAL  PRIMARY KEY
  ,chiave VARCHAR(64) NOT NULL
  ,valore  VARCHAR(256) NOT NULL
  ,abilitata BOOL NULL DEFAULT true
  ,riferimento VARCHAR(64) NOT NULL
  ,ambiente VARCHAR(64) NOT NULL
  ,note VARCHAR(256) NOT NULL
);

ALTER TABLE cpass.cpass_t_parametro
ADD CONSTRAINT cpass_t_parametro_unique UNIQUE (chiave, riferimento, ambiente);
-- nuova tabella cpass_t_parametro - fine

DROP TABLE IF EXISTS cpass.cpass_t_parametro_stampa CASCADE;
create table cpass_t_parametro_stampa (
   parametro_stampa_id SERIAL
  ,modulo varchar(200)
  ,nome_stampa varchar(200) not null
  ,file_name_template varchar(200) not null
  ,parametro varchar(500) 
  --,parametro_tipo varchar(200)
  ,procedure_utilizzate varchar(4000)
  ,note   varchar(4000)
  ,ordinamento Integer
);



--drop view
DROP VIEW if EXISTS cpass.cpass_v_allegato_scheda_b;


DROP VIEW IF EXISTS cpass.cpass_v_cpv ;
CREATE OR REPLACE VIEW cpass.cpass_v_cpv (
    id_v_cpv,
    livello,
    cpv_id_padre,
    cpv_id,
    cpv_codice,
    cpv_descrizione,
    cpv_codice_padre,
    cpv_tipologia,
    cpv_divisione,
    cpv_gruppo,
    cpv_classe,
    cpv_categoria,
    settore_interventi_id,
    settore_interventi_codice,
    settore_interventi_descrizione)
AS
 WITH RECURSIVE alberocpv(livello, cpv_id_padre, cpv_id, cpv_codice,
     cpv_descrizione, cpv_codice_padre, cpv_tipologia, cpv_divisione, cpv_gruppo, cpv_classe, cpv_categoria, settore_interventi_id, settore_interventi_codice, settore_interventi_descrizione) AS (
SELECT 1 AS livello,
            NULL::integer AS cpv_id_padre,
            cpv.cpv_id,
            cpv.cpv_codice,
            cpv.cpv_descrizione,
            cpv.cpv_codice_padre,
            cpv.cpv_tipologia,
            cpv.cpv_divisione,
            cpv.cpv_gruppo,
            cpv.cpv_classe,
            cpv.cpv_categoria,
            cpv.settore_interventi_id,
            si.settore_interventi_codice,
            si.settore_interventi_descrizione
FROM cpass_d_cpv cpv,
            cpass_d_pba_settore_interventi si
WHERE cpv.settore_interventi_id = si.settore_interventi_id AND
    cpv.cpv_codice_padre IS NULL
UNION ALL
SELECT mtree.livello + 1,
            mtree.cpv_id AS cpv_id_padre,
            cpv_figlio.cpv_id,
            cpv_figlio.cpv_codice,
            cpv_figlio.cpv_descrizione,
            cpv_figlio.cpv_codice_padre,
            cpv_figlio.cpv_tipologia,
            cpv_figlio.cpv_divisione,
            cpv_figlio.cpv_gruppo,
            cpv_figlio.cpv_classe,
            cpv_figlio.cpv_categoria,
            cpv_figlio.settore_interventi_id,
            si_figio.settore_interventi_codice,
            si_figio.settore_interventi_descrizione
FROM cpass_d_cpv cpv_figlio,
            cpass_d_pba_settore_interventi si_figio,
            alberocpv mtree
WHERE cpv_figlio.settore_interventi_id = si_figio.settore_interventi_id AND
    mtree.cpv_codice::text = cpv_figlio.cpv_codice_padre::text
        )
    SELECT row_number() OVER () AS id_v_cpv,
    alberocpv.livello,
    alberocpv.cpv_id_padre,
    alberocpv.cpv_id,
    alberocpv.cpv_codice,
    alberocpv.cpv_descrizione,
    alberocpv.cpv_codice_padre,
    alberocpv.cpv_tipologia,
    alberocpv.cpv_divisione,
    alberocpv.cpv_gruppo,
    alberocpv.cpv_classe,
    alberocpv.cpv_categoria,
    alberocpv.settore_interventi_id,
    alberocpv.settore_interventi_codice,
    alberocpv.settore_interventi_descrizione
    FROM alberocpv
    ORDER BY alberocpv.livello DESC, alberocpv.cpv_id;


INSERT INTO cpass.cpass_t_utente (utente_id, utente_nome, utente_cognome, utente_codice_fiscale, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value::uuid, tmp.cf), tmp.nome, tmp.cognome, tmp.cf, 'admin', 'admin'
FROM (VALUES
	('Pablo', 'Picasso', 'BNDNNN0000000003')
) AS tmp(nome, cognome, cf)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_utente')
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_utente tu
	WHERE tu.utente_codice_fiscale = tmp.cf
);

INSERT INTO cpass.cpass_t_utente (utente_id, utente_nome, utente_cognome, utente_codice_fiscale, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value::uuid, tmp.cf), tmp.nome, tmp.cognome, tmp.cf, 'admin', 'admin'
FROM (VALUES
	('Salvator', 'Dalì', 'BNDNNN0000000002')
) AS tmp(nome, cognome, cf)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_utente')
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_utente tu
	WHERE tu.utente_codice_fiscale = tmp.cf
);

INSERT INTO cpass.cpass_t_utente (utente_id, utente_nome, utente_cognome, utente_codice_fiscale, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value::uuid, tmp.cf), tmp.nome, tmp.cognome, tmp.cf, 'admin', 'admin'
FROM (VALUES
	('Francisco', 'Goya', 'BNDNNN0000000001')
) AS tmp(nome, cognome, cf)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_utente')
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_utente tu
	WHERE tu.utente_codice_fiscale = tmp.cf
);

INSERT INTO cpass.cpass_r_utente_settore (utente_id, settore_id, utente_rup_id)
SELECT tu.utente_id, ts.settore_id, tur.utente_id
FROM (VALUES
	('BNDNNN0000000001', 'A11000', 'AAAAAA00A11B000J'),
	('BNDNNN0000000002', 'A11000', 'AAAAAA00A11B000J'),
	('BNDNNN0000000003', 'A11000', 'AAAAAA00A11B000J')
    
) AS tmp(utente, settore, rup)
JOIN cpass.cpass_t_utente tu ON tu.utente_codice_fiscale = tmp.utente
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
JOIN cpass.cpass_t_utente tur ON tur.utente_codice_fiscale = tmp.rup
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_utente_settore rus
	WHERE rus.utente_id = tu.utente_id
	AND rus.settore_id = ts.settore_id
);

INSERT INTO cpass.cpass_r_ruolo_utente_settore (utente_settore_id, ruolo_id)
SELECT rus.utente_settore_id, dr.ruolo_id
FROM (VALUES
	('BNDNNN0000000001', 'A11000', 'REFP'),
	('BNDNNN0000000002', 'A11000', 'OPPROC'),
	('BNDNNN0000000003', 'A11000', 'OPPROC')
    
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
INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo
FROM (VALUES
	('INS_PROGRAMMA', 'voce di menu inserisci programma', 'PROGRAMMA', true, 'V'),
	('APP_PROGRAMMA', 'funzione approvazione programma', 'PROGRAMMA', false, 'B'),
	('ANN_PROGRAMMA_BOZZA', 'funzione annullamento programma in bozza', 'PROGRAMMA', false, 'B'),
	('ANN_PROGRAMMA_APPROV', 'funzione annullamento programma approvato', 'PROGRAMMA', false, 'B')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
);
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('REFP', 'INS_PROGRAMMA'),
	('REFP', 'ANN_PROGRAMMA_APPROV'),
	('REFP', 'ANN_PROGRAMMA_BOZZA'),
	('REFP', 'APP_PROGRAMMA'),
	('OPPROG', 'INS_PROGRAMMA'),
	('OPPROG', 'ANN_PROGRAMMA_BOZZA')
	
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);


-- cpass_t_parametro per MIT inizio
INSERT INTO cpass.cpass_t_parametro (parametro_id, chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.parametro_id, tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM (VALUES
	( (select nextval('cpass.cpass_t_parametro_parametro_id_seq')), 'MIT_USERNAME', 'Piemonte', true, '', 'MIT', 'Per trasmissione programma al MIT'),
	( (select nextval('cpass.cpass_t_parametro_parametro_id_seq')), 'MIT_PASSWORD', 'Pem735nte1', true, '', 'MIT', 'Per trasmissione programma al MIT'),
	( (select nextval('cpass.cpass_t_parametro_parametro_id_seq')), 'MIT_CLIENT_KEY', 'Pem735nte1', true, '', 'MIT', 'Per trasmissione programma al MIT'),
	( (select nextval('cpass.cpass_t_parametro_parametro_id_seq')), 'MIT_CLIENT_ID', 'PiemonteApp', true, '', 'MIT', 'Per trasmissione programma al MIT'),
	( (select nextval('cpass.cpass_t_parametro_parametro_id_seq')), 'MIT_URL_WSLOGIN', 'http://185.80.93.77/WSLoginCollaudo/rest', true, '', 'MIT', 'Per trasmissione programma al MIT'),
	( (select nextval('cpass.cpass_t_parametro_parametro_id_seq')), 'MIT_URL_WSPROGRAMMI', 'http://185.80.93.77/WSProgrammiCollaudo/rest', true, '', 'MIT', 'Per trasmissione programma al MIT')
) AS tmp(parametro_id, chiave, valore, abilitata, riferimento, ambiente, note)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND tp.riferimento = tmp.riferimento
	AND tp.ambiente = tmp.ambiente
);
-- cpass_t_parametro per MIT fine


-- nuovi permessi inizio 
INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box, permesso_voce_menu, permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box, tmp.voce_menu, tmp.tipo
FROM (VALUES
	('ALIMENTAZIONE_DA_FONTE_ESTERNA', 'voce di menu alimentazione da fonte esterna', 'PROGRAMMA', true, 'V'),
	('TRASMETTI_PROGRAMMA', 'voce di menu trasmetti programma', 'PROGRAMMA', true, 'V')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
);

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('REFP', 'ALIMENTAZIONE_DA_FONTE_ESTERNA'),
	('REFP', 'TRASMETTI_PROGRAMMA')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);
-- nuovi permessi fine

-- Parametro stampa insert
INSERT INTO cpass_t_parametro_stampa (parametro_stampa_id, modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
VALUES (2, 'PBA', 'STAMPA_INTERVENTI', 'StampaInterventi.rptdesign', 'Programma_id', 'UUID', 1, NULL, NULL, 'xlsx');

INSERT INTO cpass_t_parametro_stampa (parametro_stampa_id, modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
VALUES (1, 'PBA', 'ALLEGATO_II', 'Allegato_II.rptdesign', 'Programma_id', 'UUID', 1, 'pck_cpass_pba_rep_allegato_scheda_b', NULL, 'pdf');

INSERT INTO cpass_t_parametro_stampa (parametro_stampa_id, modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
VALUES (5, 'PBA', 'REPORT_SOGGETTI_AGGREGATORI', 'ReportSoggettiAggregatori.rptdesign', 'Programma_id', 'UUID', 1, NULL, NULL, 'xlsx');

insert into cpass_d_elaborazione_tipo (
  elaborazione_tipo_codice
  ,elaborazione_tipo_descrizione
  ,modulo_codice
)
values(
'CARICAMENTO_FONTE_ESTERNA'
,'CARICAMENTO_FONTE_ESTERNA'
,'PBA'
);

insert into cpass_d_elaborazione_tipo (
  elaborazione_tipo_codice
  ,elaborazione_tipo_descrizione
  ,modulo_codice
)
values(
'TRASMISSIONE_PROGRAMMA_MIT'
,'TRASMISSIONE_PROGRAMMA_MIT'
,'PBA'
);

INSERT INTO cpass.cpass_d_ruolo(ruolo_codice, ruolo_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
    ('OSS', 'OSSERVATORE')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
    SELECT 1
    FROM cpass.cpass_d_ruolo dr
    WHERE dr.ruolo_codice = tmp.codice
);


INSERT INTO cpass.cpass_d_ruolo(ruolo_codice, ruolo_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
    ('ADMIN', 'AMMINISTRATORE')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
    SELECT 1
    FROM cpass.cpass_d_ruolo dr
    WHERE dr.ruolo_codice = tmp.codice
);

INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo
FROM (VALUES
	('MOD_INTERVENTO', 'funzione modifica intervento', 'INTERVENTI', false, 'B'),
	('MOD_PROGRAMMA', 'funzione modifica programma', 'PROGRAMMA', false, 'B')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
);

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('OPPROC', 'MOD_INTERVENTO'),
	('OPPROG', 'MOD_PROGRAMMA'),
	('RUP', 'MOD_INTERVENTO'),
	('REFP', 'MOD_PROGRAMMA')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);


-- RISORSE AGGIORNATE con tag_trasmissione - INIZIO
UPDATE cpass.cpass_d_pba_risorsa
SET risorsa_tag_trasmissione = 'risorseVincolatePerLegge',
risorsa_ordinamento = 1
WHERE risorsa_codice = '1' AND risorsa_tipo = 'BILANCIO'
;

UPDATE cpass.cpass_d_pba_risorsa
SET risorsa_tag_trasmissione = 'risorseMutuo',
risorsa_ordinamento = 2
WHERE risorsa_codice = '2' AND risorsa_tipo = 'BILANCIO'
;

UPDATE cpass.cpass_d_pba_risorsa
SET risorsa_tag_trasmissione = 'risorsePrivati',
risorsa_ordinamento = 7
WHERE risorsa_codice = '3' AND risorsa_tipo = 'BILANCIO'
;

UPDATE cpass.cpass_d_pba_risorsa
SET risorsa_tag_trasmissione = 'risorseBilancio',
risorsa_ordinamento = 3
WHERE risorsa_codice = '4' AND risorsa_tipo = 'BILANCIO'
;

UPDATE cpass.cpass_d_pba_risorsa
SET risorsa_tag_trasmissione = 'risorseArt3_',
risorsa_ordinamento = 4
WHERE risorsa_codice = '5' AND risorsa_tipo = 'BILANCIO'
;

UPDATE cpass.cpass_d_pba_risorsa
SET risorsa_tag_trasmissione = 'risorseImmobili',
risorsa_ordinamento = 5
WHERE risorsa_codice = '6' AND risorsa_tipo = 'BILANCIO'
;

UPDATE cpass.cpass_d_pba_risorsa
SET risorsa_tag_trasmissione = 'risorseAltro',
risorsa_ordinamento = 6
WHERE risorsa_codice = '7' AND risorsa_tipo = 'BILANCIO'
;
-- RISORSE AGGIORNATE con tag_trasmissione - FINE

-- utente sistema - INIZIO
INSERT INTO cpass.cpass_t_utente (utente_id, utente_nome, utente_cognome, utente_codice_fiscale, utente_creazione, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value::uuid, tmp.cf), tmp.nome, tmp.cognome, tmp.cf, 'admin', 'admin'
FROM (VALUES
	('UTENTE', 'SISTEMA', 'SSTTNT20A01L219Q')
) AS tmp(nome, cognome, cf)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_utente')
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_utente tu
	WHERE tu.utente_codice_fiscale = tmp.cf
);
-- utente sistema - FINE
