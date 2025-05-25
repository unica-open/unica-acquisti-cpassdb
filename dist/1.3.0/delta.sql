---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
ALTER TABLE IF EXISTS cpass.cpass_d_oggetti_spesa ADD COLUMN IF NOT EXISTS ente_id UUID;
ALTER TABLE IF EXISTS cpass.cpass_d_oggetti_spesa DROP CONSTRAINT IF EXISTS fk_cpass_d_oggetti_spesa_ente;
ALTER TABLE IF EXISTS cpass.cpass_d_oggetti_spesa ADD CONSTRAINT fk_cpass_d_oggetti_spesa_ente FOREIGN KEY (ente_id)
REFERENCES cpass.cpass_t_ente(ente_id);

ALTER TABLE IF EXISTS cpass.cpass_t_progressivo ADD COLUMN IF NOT EXISTS ente_id UUID;
ALTER TABLE IF EXISTS cpass.cpass_t_progressivo DROP CONSTRAINT IF EXISTS fk_cpass_t_progressivo_ente;
ALTER TABLE IF EXISTS cpass.cpass_t_progressivo ADD CONSTRAINT fk_cpass_t_progressivo_ente FOREIGN KEY (ente_id)
REFERENCES cpass.cpass_t_ente(ente_id);


CREATE TABLE if not exists cpass.cpass_t_mag_magazzino (
	magazzino_id SERIAL,
	magazzino_codice VARCHAR(50),
	magazzino_descrizione VARCHAR(100),
  CONSTRAINT cpass_t_mag_magazzino_pkey PRIMARY KEY(magazzino_id)
);

CREATE TABLE  if not exists cpass.cpass_t_rms_testata_rms (
	testata_rms_id uuid NOT NULL,
	rms_anno INTEGER NOT NULL,
	rms_numero INTEGER NOT NULL,
	rms_descrizione varchar(200),
	stato_id INTEGER not NULL,
	utente_richiedente_id uuid NOT null,
	note_richiedente varchar(4000) NULL,
	settore_emittente_id uuid NOT NULL,
	data_autorizzazione timestamp null,
	data_conferma timestamp null,
	richiesta_magazzino bool NULL,
	settore_destinatario_id uuid NOT NULL,
	destinatario_indirizzo varchar(200) NULL,
	destinatario_num_civico varchar(20) NULL,
	destinatario_localita varchar(200) NULL,
	destinatario_cap varchar(5) NULL,
	destinatario_provincia varchar(200) NULL,
	destinatario_contatto varchar(200) NULL,
	destinatario_email varchar(50) NULL,
	destinatario_telefono varchar(50) NULL,
    note varchar(4000) NULL,
    ente_id uuid NOT NULL,
	data_creazione timestamp NOT NULL DEFAULT now(),
	utente_creazione varchar(250) NOT NULL,
	data_modifica timestamp NOT NULL DEFAULT now(),
	utente_modifica varchar(250) NOT NULL,
	data_cancellazione timestamp NULL,
	utente_cancellazione varchar(250) NULL,
	optlock uuid NOT NULL DEFAULT uuid_generate_v4(),
	CONSTRAINT cpass_t_rms_testata_rms_pkey PRIMARY KEY (testata_rms_id),
	CONSTRAINT fk_cpass_t_rms_testata_rms_d_stato FOREIGN KEY (stato_id) REFERENCES cpass_d_stato(stato_id),
	CONSTRAINT fk_cpass_t_rms_testata_rms_t_settore_emittente FOREIGN KEY (settore_emittente_id) REFERENCES cpass_t_settore(settore_id),
	CONSTRAINT fk_cpass_t_rms_testata_rms_t_ente FOREIGN KEY (ente_id) REFERENCES cpass_t_ente(ente_id),
	CONSTRAINT fk_cpass_t_rms_testata_rms_t_settore_destinatario FOREIGN KEY (settore_destinatario_id) REFERENCES cpass_t_settore(settore_id),
    CONSTRAINT fk_cpass_t_rms_testata_rms_t_utente FOREIGN KEY (utente_richiedente_id) REFERENCES cpass_t_utente(utente_id)
);

ALTER TABLE IF EXISTS cpass.cpass_t_rms_testata_rms drop constraint if exists cpass_t_rms_testata_rms_codice_unique;
ALTER TABLE if exists cpass.cpass_t_rms_testata_rms ADD constraint  cpass_t_rms_testata_rms_codice_unique UNIQUE (rms_anno,rms_numero,ente_id);

ALTER TABLE if exists cpass.cpass_t_rms_testata_rms ADD COLUMN IF NOT EXISTS motivo_rifiuto varchar(255);


CREATE TABLE if not exists cpass.cpass_t_rms_riga_rms (
	riga_rms_id uuid NOT NULL,
	testata_rms_id uuid NOT NULL,
	progressivo_riga INTEGER NOT null,
	consegna_parziale boolean default false, -- il boolean in genere è associato ad un checkbox a fe
	data_inizio_consegna timestamp ,
	data_fine_consegna timestamp ,
	stato_id INTEGER not NULL, -- fk su cpass_d_stato o spostiamo su altra tabella (gli elementi degli ordini sono su tabella cpass_d_stato_el_ordine)
	motivo_rifiuto varchar(500) , -- troppo poco ?
	cui varchar(50) , -- fk su pba_intervento ?
	magazzino_id INTEGER , -- fk su nuova tabella da creare
	settore_acquisto_id uuid NOT NULL, -- fk sulla cpass_t_settore se censiti qui i centri di acquisto
	oggetti_spesa_id INTEGER NOT NULL,
	quantita NUMERIC (8,2),
    note varchar(4000),
    ente_id uuid NOT NULL,
	data_creazione timestamp NOT NULL DEFAULT now(),
	utente_creazione varchar(250) NOT NULL,
	data_modifica timestamp NOT NULL DEFAULT now(),
	utente_modifica varchar(250) NOT NULL,
	data_cancellazione timestamp NULL,
	utente_cancellazione varchar(250) NULL,
	optlock uuid NOT NULL DEFAULT uuid_generate_v4(),
	CONSTRAINT cpass_t_rms_riga_rms_pkey PRIMARY KEY (riga_rms_id),
	CONSTRAINT fk_cpass_t_rms_riga_rms_testata_rms FOREIGN KEY (testata_rms_id) REFERENCES cpass_t_rms_testata_rms(testata_rms_id),
	CONSTRAINT fk_cpass_t_rms_riga_rms_d_stato FOREIGN KEY (stato_id) REFERENCES cpass_d_stato(stato_id),
	CONSTRAINT fk_cpass_t_rms_riga_rms_t_settore_acquisto FOREIGN KEY (settore_acquisto_id) REFERENCES cpass_t_settore(settore_id),
	CONSTRAINT fk_cpass_t_rms_riga_rms_oggetti_spesa FOREIGN KEY (oggetti_spesa_id) REFERENCES cpass_d_oggetti_spesa(oggetti_spesa_id),
	CONSTRAINT fk_cpass_t_rms_riga_rms_ente FOREIGN KEY (ente_id) REFERENCES cpass_t_ente(ente_id),
	CONSTRAINT fk_cpass_t_rms_riga_rms_t_magazzino FOREIGN KEY (magazzino_id) REFERENCES cpass_t_mag_magazzino(magazzino_id)

);

ALTER TABLE IF EXISTS cpass.cpass_t_rms_riga_rms drop constraint if exists cpass_t_rms_riga_rms_codice_unique;
ALTER TABLE if exists cpass.cpass_t_rms_riga_rms ADD constraint  cpass_t_rms_riga_rms_codice_unique UNIQUE (testata_rms_id,progressivo_riga);

alter table if exists cpass.cpass_d_oggetti_spesa add column if not exists quantita_max_richiedibile int4;

ALTER TABLE IF EXISTS cpass.cpass_d_oggetti_spesa ADD COLUMN IF NOT EXISTS generico boolean DEFAULT false;

ALTER TABLE IF EXISTS cpass.cpass_t_rms_riga_rms ALTER COLUMN settore_acquisto_id DROP NOT NULL;

DROP TABLE  IF EXISTS cpass.cpass_t_ord_riga_rda CASCADE;
DROP TABLE  IF EXISTS cpass.cpass_t_ord_testata_rda CASCADE;

CREATE TABLE  if not exists cpass.cpass_t_ord_testata_rda (
	testata_rda_id uuid NOT NULL,
	rda_anno INTEGER NOT NULL,
	rda_numero INTEGER NOT NULL,
	rda_descrizione varchar(200),
	stato_id INTEGER not NULL,
	utente_compilatore_id uuid NOT null,
	note varchar(4000) NULL,
	settore_emittente_id uuid NOT NULL,
	data_autorizzazione timestamp null,
	ente_id uuid NOT NULL,
	ufficio_id INTEGER NOT NULL,
	data_creazione timestamp NOT NULL DEFAULT now(),
	utente_creazione varchar(250) NOT NULL,
	data_modifica timestamp NOT NULL DEFAULT now(),
	utente_modifica varchar(250) NOT NULL,
	data_cancellazione timestamp NULL,
	utente_cancellazione varchar(250) NULL,
	optlock uuid NOT NULL DEFAULT uuid_generate_v4(),
    CONSTRAINT cpass_t_ord_testata_rda_pkey PRIMARY KEY (testata_rda_id),
	CONSTRAINT fk_cpass_t_ord_testata_rda_d_stato FOREIGN KEY (stato_id) REFERENCES cpass_d_stato(stato_id),
	CONSTRAINT fk_cpass_t_ord_testata_rda_t_settore_emittente FOREIGN KEY (settore_emittente_id) REFERENCES cpass_t_settore(settore_id),
	CONSTRAINT fk_cpass_t_ord_testata_rda_t_ente FOREIGN KEY (ente_id) REFERENCES cpass_t_ente(ente_id),
    CONSTRAINT fk_cpass_t_ord_testata_rda_t_utente FOREIGN KEY (utente_compilatore_id) REFERENCES cpass_t_utente(utente_id),
    CONSTRAINT fk_cpass_t_ord_testata_rda_t_ufficio FOREIGN KEY (ufficio_id) REFERENCES cpass_t_ufficio(ufficio_id)
);

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_rda drop constraint if exists cpass_t_ord_testata_rda_codice_unique;
ALTER TABLE if exists cpass.cpass_t_ord_testata_rda ADD constraint cpass_t_ord_testata_rda_codice_unique UNIQUE (rda_anno,rda_numero,ente_id);



CREATE TABLE  if not exists cpass.CPASS_T_ORD_RIGA_RDA (
riga_rda_id uuid NOT NULL,
testata_rda_id uuid NOT NULL,
progressivo_riga INTEGER NOT null,
quantita NUMERIC (8,2),
note varchar(4000),
stato_id INTEGER not NULL,
oggetti_spesa_id INTEGER NOT NULL,
unita_misura_id INTEGER NOT NULL,
ente_id uuid NOT NULL,
data_creazione timestamp NOT NULL DEFAULT now(),
utente_creazione varchar(250) NOT NULL,
data_modifica timestamp NOT NULL DEFAULT now(),
utente_modifica varchar(250) NOT NULL,
data_cancellazione timestamp NULL,
utente_cancellazione varchar(250) NULL,
optlock uuid NOT NULL DEFAULT uuid_generate_v4(),
CONSTRAINT cpass_t_ord_riga_rda_pkey PRIMARY KEY (riga_rda_id),
CONSTRAINT fk_cpass_t_ord_riga_rda_testata_rda FOREIGN KEY (testata_rda_id) REFERENCES cpass_t_ord_testata_rda(testata_rda_id),
CONSTRAINT fk_cpass_t_ord_riga_rda_d_stato FOREIGN KEY (stato_id) REFERENCES cpass_d_stato(stato_id),
CONSTRAINT fk_cpass_t_ord_riga_rda_oggetti_spesa FOREIGN KEY (oggetti_spesa_id) REFERENCES cpass_d_oggetti_spesa(oggetti_spesa_id),
CONSTRAINT fk_cpass_t_ord_riga_rda_ente FOREIGN KEY (ente_id) REFERENCES cpass_t_ente(ente_id),
CONSTRAINT fk_cpass_t_ord_riga_rda__d_unita_misura FOREIGN KEY (unita_misura_id) REFERENCES cpass_d_unita_misura(unita_misura_id)
);

ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_rda drop constraint if exists cpass_t_ord_riga_rda_codice_unique;
ALTER TABLE if exists cpass.cpass_t_ord_riga_rda ADD constraint  cpass_t_ord_riga_rda_codice_unique UNIQUE (testata_rda_id,progressivo_riga);




alter table cpass.cpass_t_ord_destinatario_invio_nso_xml add column if not exists metadati_xml text;
alter table cpass.cpass_t_ord_destinatario_invio_nso_xml add column if not exists data_ricezione varchar(10);

CREATE TABLE if not exists cpass.cpass_d_motivi_esclusione_cig (
	 motivi_esclusione_id SERIAL NOT NULL
	,codice_nso VARCHAR(5)
    ,codice_siope VARCHAR(200)
    ,descrizione VARCHAR(200)
    ,CONSTRAINT cpass_d_motivi_esclusione_cig_pkey PRIMARY KEY (motivi_esclusione_id)
);

CREATE TABLE if not exists cpass.cpass_t_ord_protocollo_ordine (
 protocollo_ordine_id SERIAL
,testata_ordine_id UUID
,anno_protocollo   INTEGER
,numero_protocollo varchar (20)
,aoo               varchar (50)
,CONSTRAINT cpass_t_ord_protocollo_ordine_pkey PRIMARY KEY (protocollo_ordine_id)
,CONSTRAINT fk_cpass_t_ord_protocollo_ordine_testata_ordine FOREIGN KEY (testata_ordine_id) REFERENCES cpass_t_ord_testata_ordine(testata_ordine_id)
);

ALTER TABLE if exists cpass.cpass_t_ord_testata_ordine add COLUMN if not exists  cig varchar(10)   ;
ALTER TABLE if exists cpass.cpass_t_ord_testata_ordine add COLUMN if not exists  motivi_esclusione_id integer   ;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_testata_ordine_motivi_esclusione_cig;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD CONSTRAINT fk_cpass_t_ord_testata_ordine_motivi_esclusione_cig FOREIGN KEY (motivi_esclusione_id)
REFERENCES cpass.cpass_d_motivi_esclusione_cig(motivi_esclusione_id);

CREATE OR REPLACE VIEW cpass.cpass_v_utente
AS 
select u.utente_cognome, u.utente_nome, rus.ruolo_utente_settore_id,u.utente_codice_fiscale, s.settore_codice, r.ruolo_codice
, rus.data_validita_inizio ruolo_utentesettore_inizio, rus.data_validita_fine ruolo_utentesettore_fine
, us.data_validita_inizio utente_settore_inizio, us.data_validita_fine utente_settore_fine
from cpass_t_utente u
join cpass_r_utente_settore us on (us.utente_id = u.utente_id)
join cpass_t_settore s on (us.settore_id = s.settore_id)
join cpass_r_ruolo_utente_settore rus on (rus.utente_settore_id = us.utente_settore_id) 
join cpass_d_ruolo r on (r.ruolo_id = rus.ruolo_id)
order by u.utente_codice_fiscale ;

-- vista cpass_v_cpv --
CREATE OR REPLACE VIEW cpass.cpass_v_cpv
AS WITH RECURSIVE alberocpv(livello, cpv_id_padre, cpv_id, cpv_codice, cpv_descrizione, cpv_codice_padre, cpv_tipologia, cpv_divisione, cpv_gruppo, cpv_classe, cpv_categoria, settore_interventi_id, settore_interventi_codice, settore_interventi_descrizione) AS (
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
           FROM cpass_d_cpv cpv
           left join cpass_d_pba_settore_interventi si on (si.settore_interventi_id = cpv.settore_interventi_id )
          WHERE cpv.cpv_codice_padre IS NULL
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
           FROM cpass_d_cpv cpv_figlio
            left join cpass_d_pba_settore_interventi si_figio on (si_figio.settore_interventi_id = cpv_figlio.settore_interventi_id),
            alberocpv mtree
          WHERE  mtree.cpv_codice::text = cpv_figlio.cpv_codice_padre::text
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
  ORDER BY alberocpv.livello DESC, alberocpv.cpv_codice;

--------------------------------------------------------------------------------------------------------------------------------------------
update cpass_d_pba_ausa
set ausa_descrizione = 'SOCIETA'' DI COMMITTENZA REGIONE PIEMONTE S.P.A. (S.C.R.)'
where
ausa_codice = '0000236482';

-- pulizia di eventuale modulo RIC presente
delete from cpass.cpass_r_ruolo_modulo where modulo_id = (select modulo_id from cpass.cpass_d_modulo where modulo_codice = 'RIC');

update cpass.cpass_d_modulo set modulo_codice = 'RMS', modulo_descrizione = 'Richieste Materiale e Servizi'
  where modulo_codice = 'RIC';

---- avvio modulo RMS / ruoli / permessi ----
INSERT INTO cpass.cpass_d_modulo (modulo_codice, modulo_descrizione)
SELECT tmp.modulo_codice, tmp.modulo_descrizione
FROM (VALUES
  ('RMS','Richieste Materiale e Servizi')
) AS tmp(modulo_codice, modulo_descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_modulo current
  WHERE current.modulo_codice = tmp.modulo_codice
);

INSERT INTO cpass.cpass_d_ruolo (ruolo_codice, ruolo_descrizione)
SELECT tmp.ruolo_codice, tmp.ruolo_descrizione
FROM(VALUES
  ('RICHIEDENTE_RMS','UTENTE ABILITATO A FARE RICHIESTE DI CANCELLERIA'),
  ('VALIDATORE_RMS','UTENTE ABILITATO A VALIDARE/RIFIUTARE  LE RICHIESTE DI CANCELLERIA')
) AS tmp(ruolo_codice, ruolo_descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_ruolo current
  WHERE current.ruolo_codice = tmp.ruolo_codice
);

INSERT INTO cpass_r_ruolo_modulo (ruolo_id, modulo_id)
SELECT dr.ruolo_id, dm.modulo_id
FROM (VALUES
('RICHIEDENTE_RMS', 'RMS'),
('VALIDATORE_RMS', 'RMS'),
('ADMIN', 'RMS')
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
	('INS_RICHIESTA','Inserisce la richiesta','RMS',true,'V'),
	('INS_DETT_RICHIESTA','Inserisce le righe della richiesta','RMS',false,'B'),
	('MOD_RICHIESTA','Modifica la richiesta','RMS',false,'B'),
	('MOD_DETT_RICHIESTA','Modifica le righe della richiesta','RMS',false,'B'),
	('CANC_RICHIESTA','Cancella la richiesta','RMS',false,'B'),
	('CANC_DETT_RICHIESTA','Cancella le righe della richiesta','RMS',false,'B'),
	('ANN_RICHIESTA','Annulla la richiesta','RMS',false,'B'),
	('CONFERMA_RICHIESTA','Conferma la richiesta','RMS',false,'B'),
	('AUTORIZZA_RICHIESTA','Autorizza la richiesta','RMS',false,'B'),
	('CONSULTA_RICHIESTA','Consulta la richiesta','RMS',true,'V'),
	('RIFIUTA_RICHIESTA','Riporta la richiesta in bozza','RMS',false,'B')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('RICHIEDENTE_RMS','INS_RICHIESTA'),
('RICHIEDENTE_RMS','INS_DETT_RICHIESTA'),
('RICHIEDENTE_RMS','MOD_RICHIESTA'),
('RICHIEDENTE_RMS','MOD_DETT_RICHIESTA'),
('RICHIEDENTE_RMS','CANC_RICHIESTA'),
('RICHIEDENTE_RMS','CANC_DETT_RICHIESTA'),
('RICHIEDENTE_RMS','ANN_RICHIESTA'),
('RICHIEDENTE_RMS','CONFERMA_RICHIESTA'),
('RICHIEDENTE_RMS','CONSULTA_RICHIESTA'),
('VALIDATORE_RMS','ANN_RICHIESTA'),
('VALIDATORE_RMS','AUTORIZZA_RICHIESTA'),
('VALIDATORE_RMS','CONSULTA_RICHIESTA'),
('VALIDATORE_RMS','RIFIUTA_RICHIESTA'),
('ADMIN','INS_RICHIESTA'),
('ADMIN','INS_DETT_RICHIESTA'),
('ADMIN','MOD_RICHIESTA'),
('ADMIN','MOD_DETT_RICHIESTA'),
('ADMIN','CANC_RICHIESTA'),
('ADMIN','CANC_DETT_RICHIESTA'),
('ADMIN','ANN_RICHIESTA'),
('ADMIN','CONFERMA_RICHIESTA'),
('ADMIN','AUTORIZZA_RICHIESTA'),
('ADMIN','CONSULTA_RICHIESTA'),
('ADMIN','RIFIUTA_RICHIESTA')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

insert into cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
select tmp.codice, tmp.descrizione, tmp.tipo
from ( values
	('BOZZA','BOZZA','RMS'),
	('CONFERMATA','CONFERMATA','RMS'),
	('AUTORIZZATA','AUTORIZZATA','RMS'),
	('ANNULLATA','ANNULLATA','RMS'),
	('NEW','DA SMISTARE','RIGA_RMS'),
	('DAE','DA EVADERE','RIGA_RMS'),
	('EVT','EVASA TOTALMENTE','RIGA_RMS'),
	('EVP','EVASA PARZIALMENTE','RIGA_RMS'),
	('WIP','IN LAVORAZIONE','RIGA_RMS'),
	('RIF','RIFIUTATA','RIGA_RMS'),
	('CEP','CHIUSA EV.PARZIALMENTE','RIGA_RMS'),
	('CDE','CHIUSA DA EVADERE','RIGA_RMS'),
	('ADE','ANNULLATA DA EVADERE','RIGA_RMS')
)AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato ts
  WHERE ts.stato_codice = tmp.codice
  AND ts.stato_tipo = tmp.tipo
);


INSERT INTO cpass.cpass_d_motivi_esclusione_cig (codice_nso, codice_siope,descrizione)
SELECT tmp.codice_nso, tmp.codice_siope,tmp.descrizione
FROM (VALUES
('ES11','ACCORDO_AMM_AGGIUDICATRICI','Accordo Amm. Aggiudicatrici')
,('ES01','ACQUISTO_LOCAZIONE','Acquisto locazione')
,('ES12','AFFIDAMENTI_IN_HOUSE','Affidamenti in house')
,('ES16','AMMINISTRAZIONE DIRETTA','Amministrazione diretta')
,('ES08','APPALTI_ENERGIA_ACQUA','Appalti energia acqua')
,('ES02','ARBITRATO','Arbitrato')
,('ES15','ATTIVITA_CONCORRENZA','Attivita'' concorrenza')
,('ES09','CONCESSIONI_PAESI_TERZI','Concessioni paesi terzi')
,('ES21','CONTRATTI_ASSOCIAZIONE','Contratti associazione')
,('ES22','CONTRATTI_AUTORITA_GIUDIZIARIA','Contratti autorita'' giudiziaria')
,('ES05','CONTRATTI_DIFESA','Contratti difesa')
,('ES17','CONTRATTI_ESTERO','Contratti estero')
,('ES04','CONTRATTI_LAVORO','Contratti lavoro')
,('ES07','DIRITTO_ESCLUSIVO','Diritto esclusivo')
,('ES20','EROGAZIONI_LIBERALITA','Erogazioni liberalita''')
,('ES14','IMPRESA_COLLEGATA','Impresa collegata')
,('ES19','INCARICHI_COLLABORAZIONE','Incarichi collaborazione')
,('ES13','JOINT_VENTURE','Joint venture')
,('ES25','PRESTAZIONI','Prestazioni')
,('ES26','RIASSICURAZIONE','Riassicurazione')
,('ES23','RISARCIMENTI_INDENNIZZI','Risarcimenti indennizzi')
,('ES03','SERVIZI_BANCHE_CENTRALI_EFSF','Servizi banche centrali EFSF')
,('ES06','SERVIZI_CAMPAGNE_POLITICHE','Servizi campagne politiche')
,('ES24','SPESE_ECONOMALI','Spese economali')
,('ES10','SPONSORIZZAZIONE_PURA','Sponsorizzazione pura')
,('ES27','TRASFERIMENTO_FONDI','Trasferimento fondi')
,('ES18','TRASPORTO_AEREO','Trasporto aereo')
) AS tmp(codice_nso, codice_siope,descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_motivi_esclusione_cig current
  WHERE current.codice_nso = tmp.codice_nso
);

INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo
FROM (VALUES
	('INS_INTERVENTO_FIELD','Permesso di editare campi altrimenti non modificabili','INTERVENTI',false,'F')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('ADMIN','INS_INTERVENTO_FIELD'),
('REFP','INS_INTERVENTO_FIELD'),
('DELEGATO_REFP','INS_INTERVENTO_FIELD')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

DROP FUNCTION if exists cpass.pck_cpass_pba_rep_interventi_risorse(p_programma_id varchar, p_cup varchar, p_settore_interventi varchar, p_struttura_id varchar, p_cpv_id varchar, p_cognome varchar, p_descri varchar, p_order varchar);

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_interventi_risorse(p_programma_id character varying, p_cup character varying, p_settore_interventi character varying, p_struttura_id character varying, p_cpv_id character varying, p_cognome character varying, p_descri character varying, p_order character varying)
 RETURNS TABLE(id_allegato_scheda integer, intervento_cui character varying, intervento_anno_avvio integer,
  intervento_cup character varying, intervento_stato character varying, ricompreso_tipo_codice character varying,
   ricompreso_tipo_descrizione character varying, intervento_lotto_funzionale boolean, nuts_codice character varying,
    nuts_descrizione character varying, settore_interventi_codice character varying, settore_interventi_descrizione character varying,
     cpv_codice character varying, cpv_descrizione character varying, intervento_descrizione_acquisto character varying,
      priorita_codice character varying, priorita_descrizione character varying, utente_nome character varying,
       utente_cognome character varying, utente_codice_fiscale character varying, intervento_durata_mesi integer,
        intervento_nuovo_affid boolean, ausa character varying, ausa_descrizione character varying,
         acquisto_variato_codice character varying, acquisto_variato_descrizione character varying,
          programma_id uuid, programma_anno integer, ente_id uuid, ente_codice_fiscale character varying,
           ente_denominazione character varying, importo_anno_primo numeric, importo_anno_secondo numeric,
            importo_anni_successivi numeric, totale_importi numeric, risorsa character varying, tipologia character varying,
             settore_codice character varying, settore_descrizione character varying, motivazione_non_riproposto character varying)
 LANGUAGE plpgsql
AS $function$
DECLARE

RTN_MESSAGGIO text;
stringa_sql varchar(8000);
BEGIN
  

  if p_cognome <>  'null' AND p_cognome <> '' and p_cognome IS NOT NULL  then
   p_cognome := upper(p_cognome);  
  end if; 
  
  if p_descri <>  'null' AND p_descri <> '' and p_descri IS NOT NULL then 
  	p_descri := upper(p_descri);  
  end if; 

  
  if p_order IS  NULL OR  p_order =  'null' OR p_order = '' then 
  	p_order := 'id_allegato_scheda';
  end if;  

--return query
stringa_sql :='
WITH  importi_cap_privati AS (
    SELECT int_1.intervento_id, 
           programma_1.programma_id,
           risorsa.risorsa_id,  
           intimp.intervento_importi_importo_anno_primo as   cap_privati_importo_anno_primo,
           intimp.intervento_importi_importo_anno_secondo AS cap_privati_importo_anno_secondo,
           intimp.intervento_importi_importo_anni_successivi AS  cap_privati_importo_anni_successivi,
           intimp.intervento_importi_importo_anno_primo +
           intimp.intervento_importi_importo_anno_secondo + 
           intimp.intervento_importi_importo_anni_successivi AS cap_privati_totale_importi
    FROM cpass_t_pba_intervento int_1
             JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id =  intimp.intervento_id
             JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id =   programma_1.programma_id
             JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id =  risorsa.risorsa_id AND risorsa.risorsa_tipo = ''BILANCIO''
    )
    SELECT distinct
    	row_number() OVER ()::INTEGER AS id_allegato_scheda
        ,intervento.intervento_cui
        ,intervento.intervento_anno_avvio
        ,intervento.intervento_cup
        , stato.stato_codice
        ,rt.ricompreso_tipo_codice
        ,rt.ricompreso_tipo_descrizione
        ,intervento.intervento_lotto_funzionale
        ,nuts.nuts_codice
        ,nuts.nuts_descrizione
        ,si.settore_interventi_codice
        ,si.settore_interventi_descrizione
        ,cpv.cpv_codice
        ,cpv.cpv_descrizione
        ,intervento.intervento_descrizione_acquisto
        ,priorita.priorita_codice
        ,priorita.priorita_descrizione
        ,ute.utente_nome
        ,ute.utente_cognome
        ,ute.utente_codice_fiscale
        ,intervento.intervento_durata_mesi
        ,intervento.intervento_nuovo_affid
        ,ausa.ausa_codice AS ausa
        ,ausa.ausa_descrizione
        ,av.acquisto_variato_codice
        ,av.acquisto_variato_descrizione
        ,programma.programma_id
        ,programma.programma_anno
        ,ente.ente_id       
        ,ente.ente_codice_fiscale
        ,ente.ente_denominazione
        ,importi_cap_privati.cap_privati_importo_anno_primo importo_anno_primo
        ,importi_cap_privati.cap_privati_importo_anno_secondo importo_anno_secondo
        ,importi_cap_privati.cap_privati_importo_anni_successivi importo_anni_successivi
        ,importi_cap_privati.cap_privati_totale_importi totale_importi
        ,risorsa.risorsa_descrizione 
        ,risorsa.risorsa_tipo            
        ,settore.settore_codice
        ,settore.settore_descrizione
        ,intervento.motivazione_non_riproposto
    FROM cpass_t_pba_intervento intervento
       JOIN cpass_d_stato stato ON intervento.stato_id = stato.stato_id and stato.stato_tipo = ''INTERVENTO''
       JOIN cpass_d_pba_nuts nuts ON intervento.nuts_id = nuts.nuts_id
       JOIN cpass_d_pba_priorita priorita ON intervento.priorita_id = priorita.priorita_id
       JOIN cpass_d_pba_settore_interventi si ON intervento.settore_interventi_id = si.settore_interventi_id
       JOIN cpass_d_cpv cpv ON intervento.cpv_id = cpv.cpv_id
       JOIN cpass_t_utente ute ON intervento.utente_rup_id = ute.utente_id       
       JOIN cpass_t_settore settore ON intervento.settore_id = settore.settore_id       
       LEFT JOIN cpass_d_pba_acquisto_variato av ON intervento.acquisto_variato_id =av.acquisto_variato_id
       LEFT JOIN cpass_d_pba_ricompreso_tipo rt ON intervento.ricompreso_tipo_id = rt.ricompreso_tipo_id
       LEFT JOIN cpass_d_pba_ausa ausa ON intervento.ausa_id = ausa.ausa_id
       JOIN cpass_t_pba_programma programma ON intervento.programma_id = programma.programma_id
       JOIN cpass_t_ente ente ON ente.ente_id = programma.ente_id
       LEFT JOIN importi_cap_privati ON intervento.programma_id = importi_cap_privati.programma_id AND intervento.intervento_id = importi_cap_privati.intervento_id 
       LEFT JOIN cpass_d_pba_risorsa risorsa ON risorsa.risorsa_id =  importi_cap_privati.risorsa_id
     where 1 = 1';
     if p_programma_id <> 'null' AND p_programma_id <> '' and p_programma_id IS NOT NULL then
           stringa_sql := stringa_sql || ' and programma.programma_id = $1::UUID ';             
     end if;
   
     if p_cup <>  'null' and p_cup <>  '' and p_cup IS NOT NULL then  
        stringa_sql := stringa_sql || ' and intervento.intervento_cup = $2  ';
     end if;
     if p_settore_interventi <>  'null' and p_settore_interventi <>  '' and p_settore_interventi IS NOT NULL then 
       stringa_sql := stringa_sql || ' and intervento.settore_interventi_id = $3::INTEGER ';   
     end if;

    if p_struttura_id <>  'null' AND p_struttura_id <> '' and p_struttura_id IS NOT NULL  then      
       stringa_sql := stringa_sql || ' and intervento.settore_id = $4::UUID '; 
     end if;
     
     if p_cpv_id <>  'null' AND p_cpv_id <> '' and p_cpv_id IS NOT NULL  then     
       stringa_sql := stringa_sql || ' and cpv.cpv_id = $5::integer ';  
     end if;
     
     if p_cognome <>  'null' AND p_cognome <> '' and p_cognome IS NOT NULL  then      
       stringa_sql := stringa_sql || ' and upper(ute.utente_cognome) like ''%''|| $6 || ''%'' '; 
     end if;
     
     if p_descri <>  'null' AND p_descri <> '' and p_descri IS NOT NULL then 
       stringa_sql := stringa_sql || ' and upper(intervento.intervento_descrizione_acquisto) like ''%''|| $7 || ''%'' ';         
	 end if;
     
       stringa_sql := stringa_sql || ' and importi_cap_privati.cap_privati_totale_importi >0 ';     
     
       stringa_sql := stringa_sql || ' ORDER  BY ' || p_order;
       
raise notice 'sql % ', stringa_sql;

       
RETURN QUERY EXECUTE stringa_sql
USING p_programma_id ,
  p_cup ,
  p_settore_interventi ,
  p_struttura_id ,
  p_cpv_id ,
  p_cognome ,
  p_descri ,
  p_order ;




exception
	when no_data_found THEN
		raise notice 'Nessun dato trovato per il quadro economico';
		return;
	when others  THEN
		RAISE EXCEPTION '% Errore : %-%.',RTN_MESSAGGIO,SQLSTATE,substring(SQLERRM from 1 for 500);
		return;

END;
$function$;

-- nuove cpv --
INSERT INTO cpass.cpass_d_cpv (cpv_descrizione, cpv_codice, cpv_codice_padre, cpv_tipologia, 
cpv_divisione,cpv_gruppo,cpv_classe,cpv_categoria)
SELECT tmp.cpv_descrizione, tmp.cpv_codice, tmp.cpv_codice_padre, tmp.cpv_tipologia,
tmp.cpv_divisione, tmp.cpv_gruppo, tmp.cpv_classe,tmp.cpv_categoria
FROM (VALUES
('Lavori di costruzione','45000000-7',null,'Divisione','45','450','4500','45000'),
('Lavori di preparazione del cantiere edile','45100000-8','45000000-7','Gruppo','45','451','4510','45100'),
('Lavori di demolizione di edifici e lavori di movimento terra','45110000-1','45100000-8','Classi','45','451','4511','45110'),
('Lavori di demolizione, di preparazione del sito e sgombero','45111000-8','45110000-1','Categoria','45','451','4511','45111'),
('Lavori di demolizione','45111100-9','45111000-8','Articolo','45','451','4511','45111'),
('Lavori di preparazione del sito e sgombero','45111200-0','45111000-8','Articolo','45','451','4511','45111'),
('Brillamento e rimozione di materiale roccioso','45111210-3','45111000-8','Articolo','45','451','4511','45111'),
('Brillamento','45111211-0','45111000-8','Articolo','45','451','4511','45111'),
('Rimozione di materiale roccioso','45111212-7','45111000-8','Articolo','45','451','4511','45111'),
('Lavori di sgombero','45111213-4','45111000-8','Articolo','45','451','4511','45111'),
('Lavori di rimozione di macerie','45111214-1','45111000-8','Articolo','45','451','4511','45111'),
('Lavori di disboscamento','45111220-6','45111000-8','Articolo','45','451','4511','45111'),
('Lavori di stabilizzazione del terreno','45111230-9','45111000-8','Articolo','45','451','4511','45111'),
('Lavori di drenaggio terreni','45111240-2','45111000-8','Articolo','45','451','4511','45111'),
('Lavori di indagine dei terreni','45111250-5','45111000-8','Articolo','45','451','4511','45111'),
('Preparazione del terreno per l''estrazione mineraria','45111260-8','45111000-8','Articolo','45','451','4511','45111'),
('Lavori primari per servizi','45111290-7','45111000-8','Articolo','45','451','4511','45111'),
('Lavori di sviluppo di siti','45111291-4','45111000-8','Articolo','45','451','4511','45111'),
('Lavori di smantellamento','45111300-1','45111000-8','Articolo','45','451','4511','45111'),
('Lavori di demolizione per impianti militari','45111310-4','45111000-8','Articolo','45','451','4511','45111'),
('Lavori di demolizione per impianti di sicurezza','45111320-7','45111000-8','Articolo','45','451','4511','45111'),
('Lavori di scavo e movimento terra','45112000-5','45110000-1','Categoria','45','451','4511','45112'),
('Lavori di scavo di fossi','45112100-6','45112000-5','Articolo','45','451','4511','45112'),
('Rimozione di terra','45112200-7','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di sterro','45112210-0','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di riporto e bonifica del terreno','45112300-8','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di riporto','45112310-1','45112000-5','Articolo','45','451','4511','45112'),
('Bonifica del terreno','45112320-4','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di dissodamento di siti','45112330-7','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di decontaminazione di terreni','45112340-0','45112000-5','Articolo','45','451','4511','45112'),
('Bonifica di terre incolte','45112350-3','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di bonifica di terreni','45112360-6','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di scavo','45112400-9','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di scavo di fosse','45112410-2','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di scavo di fondamenta','45112420-5','45112000-5','Articolo','45','451','4511','45112'),
('Terrazzamento di pendii collinari','45112440-1','45112000-5','Articolo','45','451','4511','45112'),
('Terrazzamento','45112441-8','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di scavo di siti archeologici','45112450-4','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di movimento terra','45112500-0','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di scavo e riporto','45112600-1','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di architettura paesaggistica','45112700-2','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di architettura paesaggistica per aree verdi','45112710-5','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di architettura paesaggistica per parchi','45112711-2','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di architettura paesaggistica per giardini','45112712-9','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di architettura paesaggistica per giardini pensili','45112713-6','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di architettura paesaggistica per cimiteri','45112714-3','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di architettura paesaggistica per aree ricreative e sportive','45112720-8','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di architettura paesaggistica per campi di golf','45112721-5','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di architettura paesaggistica per centri di equitazione','45112722-2','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di architettura paesaggistica per campi gioco','45112723-9','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di architettura paesaggistica per strade e autostrade','45112730-1','45112000-5','Articolo','45','451','4511','45112'),
('Lavori di architettura paesaggistica per aeroporti','45112740-4','45112000-5','Articolo','45','451','4511','45112'),
('Preparazione di siti','45113000-2','45110000-1','Categoria','45','451','4511','45113'),
('Trivellazioni e perforazioni di sondaggio','45120000-4','45100000-8','Classi','45','451','4512','45120'),
('Trivellazioni di sondaggio','45121000-1','45120000-4','Categoria','45','451','4512','45121'),
('Perforazioni di sondaggio','45122000-8','45120000-4','Categoria','45','451','4512','45122'),
('Lavori per la costruzione completa o parziale e ingegneria civile','45200000-9','45000000-7','Gruppo','45','452','4520','45200'),
('Lavori generali di costruzione di edifici','45210000-2','45200000-9','Classi','45','452','4521','45210'),
('Lavori di costruzione di condomini e case unifamiliari','45211000-9','45210000-2','Categoria','45','452','4521','45211'),
('Lavori di costruzione per case','45211100-0','45211000-9','Articolo','45','452','4521','45211'),
('Lavori di costruzione di centri assistenziali','45211200-1','45211000-9','Articolo','45','452','4521','45211'),
('Lavori di costruzione di case','45211300-2','45211000-9','Articolo','45','452','4521','45211'),
('Lavori di costruzione di bagni','45211310-5','45211000-9','Articolo','45','452','4521','45211'),
('Lavori di costruzione di portici','45211320-8','45211000-9','Articolo','45','452','4521','45211'),
('Lavori di costruzione di condomini','45211340-4','45211000-9','Articolo','45','452','4521','45211'),
('Lavori di costruzione di appartamenti','45211341-1','45211000-9','Articolo','45','452','4521','45211'),
('Lavori di costruzione di edifici multifunzionali','45211350-7','45211000-9','Articolo','45','452','4521','45211'),
('Lavori di costruzione di sviluppo urbano','45211360-0','45211000-9','Articolo','45','452','4521','45211'),
('Lavori di costruzione di saune','45211370-3','45211000-9','Articolo','45','452','4521','45211'),
('Lavori di costruzione di centri ricreativi, sportivi, culturali, alberghi e ristoranti','45212000-6','45210000-2','Categoria','45','452','4521','45212'),
('Impianti per il tempo libero','45212100-7','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di centri per il tempo libero','45212110-0','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di parchi tematici','45212120-3','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di parchi di divertimenti','45212130-6','45212000-6','Articolo','45','452','4521','45212'),
('Impianto ricreativo','45212140-9','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di cinema','45212150-2','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di casinò','45212160-5','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di edifici per attività ricreative','45212170-8','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di centri per attività ricreative','45212171-5','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di centri ricreativi','45212172-2','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di biglietterie','45212180-1','45212000-6','Articolo','45','452','4521','45212'),
('Lavori parasole','45212190-4','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di impianti sportivi','45212200-8','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di impianti sportivi specializzati','45212210-1','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di piste di pattinaggio','45212211-8','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione per piscine','45212212-5','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di applicazione di segnaletiche sportive','45212213-2','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione per impianti sportivi polivalenti','45212220-4','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di strutture per terreni sportivi','45212221-1','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di palestre','45212222-8','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di attrezzature per sport invernali','45212223-5','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di stadi','45212224-2','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di palazzi dello sport','45212225-9','45212000-6','Articolo','45','452','4521','45212'),
('Installazione di spogliatoi','45212230-7','45212000-6','Articolo','45','452','4521','45212'),
('Riparazione e manutenzione di impianti sportivi','45212290-5','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di edifici per l''arte e la cultura','45212300-9','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di centri espositivi','45212310-2','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di gallerie d''arte','45212311-9','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di centri per esposizioni','45212312-6','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di musei','45212313-3','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di monumenti storici o commemorativi','45212314-0','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di edifici destinati ad attività artistiche','45212320-5','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di auditori','45212321-2','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di teatri','45212322-9','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di biblioteche','45212330-8','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di biblioteche multimediali','45212331-5','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di sale per conferenze','45212340-1','45212000-6','Articolo','45','452','4521','45212'),
('Edifici di particolare interesse storico o architettonico','45212350-4','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di monumenti preistorici','45212351-1','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di monumenti industriali','45212352-8','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di palazzi','45212353-5','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di castelli','45212354-2','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di edifici religiosi','45212360-7','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di chiese','45212361-4','45212000-6','Articolo','45','452','4521','45212'),
('Alberghi e ristoranti','45212400-0','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di strutture alberghiere','45212410-3','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di alberghi','45212411-0','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di ostelli','45212412-7','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di alloggi per soggiorni di breve durata','45212413-4','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di ristoranti ed edifici simili','45212420-6','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di ristoranti','45212421-3','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di mense','45212422-0','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di caffetterie','45212423-7','45212000-6','Articolo','45','452','4521','45212'),
('Conversioni di cucine o ristoranti','45212500-1','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di padiglioni','45212600-2','45212000-6','Articolo','45','452','4521','45212'),
('Lavori di costruzione di edifici commerciali, magazzini ed edifici industriali, edifici per i trasporti','45213000-3','45210000-2','Categoria','45','452','4521','45213'),
('Lavori di costruzione di edifici commerciali','45213100-4','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici per negozi','45213110-7','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di centri commerciali','45213111-4','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di negozi','45213112-1','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di uffici postali','45213120-0','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di banche','45213130-3','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di mercati','45213140-6','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di mercati coperti','45213141-3','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di mercati all''aperto','45213142-0','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di complessi di uffici','45213150-9','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di magazzini e edifici industriali','45213200-5','45213000-3','Articolo','45','452','4521','45213'),
('Impianti frigoriferi','45213210-8','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione per depositi','45213220-1','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di magazzini','45213221-8','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di mattatoi','45213230-4','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici agricoli','45213240-7','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di fienili','45213241-4','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di stalle','45213242-1','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici industriali','45213250-0','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di unità industriali','45213251-7','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di officine','45213252-4','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di depositi di stoccaggio','45213260-3','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di impianti di riciclo','45213270-6','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di strutture di compostaggio','45213280-9','45213000-3','Articolo','45','452','4521','45213'),
('Edifici connessi ai trasporti','45213300-6','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici per i trasporti su strada','45213310-9','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di stazioni degli autobus','45213311-6','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici per il parcheggio di veicoli','45213312-3','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione per edifici per aree di servizio','45213313-0','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di garage per autobus','45213314-7','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di gabbiotti per le fermate dell''autobus','45213315-4','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di installazione di passerelle','45213316-1','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici per i trasporti ferroviari','45213320-2','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di stazioni ferroviarie','45213321-9','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici per capolinea ferroviario','45213322-6','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici per i trasporti aerei','45213330-5','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici aeroportuali','45213331-2','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di torri di controllo aeroportuali','45213332-9','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di installazione di banchi per la registrazione negli aeroporti','45213333-6','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici per la navigazione interna','45213340-8','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici per i terminal di traghetti','45213341-5','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di terminal per traghetti RO-RO','45213342-2','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici per mezzi di trasporto vari','45213350-1','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di hangar per la manutenzione','45213351-8','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di depositi di servizio','45213352-5','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di installazione di ponti di accesso per i passeggeri','45213353-2','45213000-3','Articolo','45','452','4521','45213'),
('Installazione di stanze per il personale','45213400-7','45213000-3','Articolo','45','452','4521','45213'),
('Lavori di costruzione di edifici per l''istruzione e la ricerca','45214000-0','45210000-2','Categoria','45','452','4521','45214'),
('Lavori di costruzione di scuole per l''infanzia','45214100-1','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di edifici scolastici','45214200-2','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di scuole elementari','45214210-5','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di scuole superiori','45214220-8','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di scuole speciali','45214230-1','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di istituti superiori','45214300-3','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di istituti professionali','45214310-6','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di istituti tecnici','45214320-9','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di edifici universitari','45214400-4','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di politecnici','45214410-7','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di aule universitarie','45214420-0','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di laboratori linguistici','45214430-3','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di edifici per l''istruzione post-scolastica','45214500-5','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di edifici di ricerca','45214600-6','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di laboratori','45214610-9','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di dispositivi di ricerca e collaudo','45214620-2','45214000-0','Articolo','45','452','4521','45214'),
('Impianti scientifici','45214630-5','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di installazione di locali senza polvere','45214631-2','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di stazioni meteorologiche','45214640-8','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di case dello studente','45214700-7','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di atrii','45214710-0','45214000-0','Articolo','45','452','4521','45214'),
('Edificio con strutture di formazione','45214800-8','45214000-0','Articolo','45','452','4521','45214'),
('Lavori di costruzione di edifici per servizi sociali e sanitari, crematori e gabinetti pubblici','45215000-7','45210000-2','Categoria','45','452','4521','45215'),
('Lavori di costruzione di edifici per servizi sanitari','45215100-8','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di stazioni termali','45215110-1','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di edifici medici speciali','45215120-4','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di cliniche','45215130-7','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di strutture ospedaliere','45215140-0','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di sale operatorie','45215141-7','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di unità per cure intensive','45215142-4','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di sale per screening diagnostico','45215143-1','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di sale per screening','45215144-8','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di sale per fluoroscopia','45215145-5','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di sale per patologia','45215146-2','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di sale per medicina legale','45215147-9','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di sale cateteri','45215148-6','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di edifici per servizi sociali','45215200-9','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di centri di accoglienza','45215210-2','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di case di riposo per anziani','45215212-6','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di case di cura','45215213-3','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di case residenziali','45215214-0','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di convitti','45215215-7','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di strutture sociali, esclusi i centri di accoglienza','45215220-5','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di centri di assistenza diurna','45215221-2','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di centri civici','45215222-9','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di crematori','45215300-0','45215000-7','Articolo','45','452','4521','45215'),
('Cimitero','45215400-1','45215000-7','Articolo','45','452','4521','45215'),
('Gabinetti pubblici','45215500-2','45215000-7','Articolo','45','452','4521','45215'),
('Lavori di costruzione di edifici destinati a servizi di ordine pubblico o di emergenza e di edifici militari','45216000-4','45210000-2','Categoria','45','452','4521','45216'),
('Lavori di costruzione di edifici destinati a servizi di ordine pubblico o di emergenza','45216100-5','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di edifici destinati a servizi di ordine pubblico','45216110-8','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di commissariati di polizia','45216111-5','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di tribunali','45216112-2','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di carceri','45216113-9','45216000-4','Articolo','45','452','4521','45216'),
('Edifici destinati al Parlamento e centri di riunione','45216114-6','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di edifici destinati a servizi di emergenza','45216120-1','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di caserme dei pompieri','45216121-8','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di centrali per ambulanze','45216122-5','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di edifici per soccorso alpino','45216123-2','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di stazioni di salvataggio in mare','45216124-9','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di edifici per servizi di emergenza','45216125-6','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di edifici per la guardia costiera','45216126-3','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di stazioni per servizi di salvataggio','45216127-0','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di fari','45216128-7','45216000-4','Articolo','45','452','4521','45216'),
('Ripari','45216129-4','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di edifici ed impianti militari','45216200-6','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di bunker militari','45216220-2','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di ripari militari','45216230-5','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di trincee','45216250-1','45216000-4','Articolo','45','452','4521','45216'),
('Lavori di costruzione di edifici gonfiabili','45217000-1','45210000-2','Categoria','45','452','4521','45217'),
('Opere d''arte e strutture','45220000-5','45200000-9','Classi','45','452','4522','45220'),
('Lavori di costruzione di ponti e gallerie, pozzi e sottopassaggi','45221000-2','45220000-5','Categoria','45','452','4522','45221'),
('Lavori di costruzione per ponti','45221100-3','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di ponti','45221110-6','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di ponti stradali','45221111-3','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di ponti ferroviari','45221112-0','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di passerelle','45221113-7','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di ponti in ferro','45221114-4','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di ponti in acciaio','45221115-1','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di pese a ponte','45221117-5','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di ponti per condutture','45221118-2','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione per rinnovo di ponti','45221119-9','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di viadotti','45221120-9','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di viadotti stradali','45221121-6','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di viadotti ferroviari','45221122-3','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di gallerie, pozzi e sottopassaggi','45221200-4','45221000-2','Articolo','45','452','4522','45221'),
('Escavazioni coperte o parzialmente coperte','45221210-7','45221000-2','Articolo','45','452','4522','45221'),
('Sottovia','45221211-4','45221000-2','Articolo','45','452','4522','45221'),
('Escavazioni ferroviarie coperte o parzialmente coperte','45221213-8','45221000-2','Articolo','45','452','4522','45221'),
('Escavazioni stradali coperte o parzialmente coperte','45221214-5','45221000-2','Articolo','45','452','4522','45221'),
('Tombini','45221220-0','45221000-2','Articolo','45','452','4522','45221'),
('Pozzetti','45221230-3','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di gallerie','45221240-6','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di gallerie stradali','45221241-3','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di gallerie ferroviarie','45221242-0','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di sottopassi pedonali','45221243-7','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di tunnel per canali','45221244-4','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di gallerie subalvee','45221245-1','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di gallerie sottomarine','45221246-8','45221000-2','Articolo','45','452','4522','45221'),
('Scavo di galleria','45221247-5','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di rivestimenti di gallerie','45221248-2','45221000-2','Articolo','45','452','4522','45221'),
('Lavori in sotterraneo, esclusi gallerie,pozzi e sottopassaggi','45221250-9','45221000-2','Articolo','45','452','4522','45221'),
('Lavori di costruzione di opere d''arte, esclusi ponti, gallerie, pozzi e sottopassaggi','45222000-9','45220000-5','Categoria','45','452','4522','45222'),
('Lavori di costruzione di impianti di trattamento dei rifiuti','45222100-0','45222000-9','Articolo','45','452','4522','45222'),
('Lavori di costruzione di discariche per rifiuti','45222110-3','45222000-9','Articolo','45','452','4522','45222'),
('Lavori di ingegneria per impianti militari','45222200-1','45222000-9','Articolo','45','452','4522','45222'),
('Lavori di ingegneria per impianti di sicurezza','45222300-2','45222000-9','Articolo','45','452','4522','45222'),
('Lavori di costruzione di strutture edili','45223000-6','45220000-5','Categoria','45','452','4522','45223'),
('Assemblaggio di strutture metalliche','45223100-7','45223000-6','Articolo','45','452','4522','45223'),
('Installazione di strutture metalliche','45223110-0','45223000-6','Articolo','45','452','4522','45223'),
('Lavori strutturali','45223200-8','45223000-6','Articolo','45','452','4522','45223'),
('Lavori di costruzione di strutture metalliche','45223210-1','45223000-6','Articolo','45','452','4522','45223'),
('Lavori di rustico','45223220-4','45223000-6','Articolo','45','452','4522','45223'),
('Lavori di costruzione di parcheggi','45223300-9','45223000-6','Articolo','45','452','4522','45223'),
('Lavori di costruzione di parcheggi sotterranei','45223310-2','45223000-6','Articolo','45','452','4522','45223'),
('Lavori di costruzione di parcheggi di interscambio','45223320-5','45223000-6','Articolo','45','452','4522','45223'),
('Lavori di costruzione di stazioni radar','45223400-0','45223000-6','Articolo','45','452','4522','45223'),
('Strutture in cemento armato','45223500-1','45223000-6','Articolo','45','452','4522','45223'),
('Lavori di costruzione di canili','45223600-2','45223000-6','Articolo','45','452','4522','45223'),
('Lavori di costruzione di aree di servizio','45223700-3','45223000-6','Articolo','45','452','4522','45223'),
('Lavori di costruzione di aree di servizio autostradali','45223710-6','45223000-6','Articolo','45','452','4522','45223'),
('Lavori di costruzione di stazioni di rifornimento','45223720-9','45223000-6','Articolo','45','452','4522','45223'),
('Assemblaggio ed installazione di strutture prefabbricate','45223800-4','45223000-6','Articolo','45','452','4522','45223'),
('Costruzioni prefabbricate','45223810-7','45223000-6','Articolo','45','452','4522','45223'),
('Elementi e componenti prefabbricati','45223820-0','45223000-6','Articolo','45','452','4522','45223'),
('Unità prefabbricate','45223821-7','45223000-6','Articolo','45','452','4522','45223'),
('Componenti prefabbricati','45223822-4','45223000-6','Articolo','45','452','4522','45223'),
('Lavori di costruzione di condutture, linee di comunicazione e linee elettriche, autostrade, strade, campi di aviazione e ferrovie, lavori di livellamento','45230000-8','45200000-9','Classi','45','452','4523','45230'),
('Lavori di costruzione di condutture, linee di comunicazione e linee elettriche','45231000-5','45230000-8','Categoria','45','452','4523','45231'),
('Lavori generali di costruzione di condutture','45231100-6','45231000-5','Articolo','45','452','4523','45231'),
('Lavori di posa di tubature','45231110-9','45231000-5','Articolo','45','452','4523','45231'),
('Smontaggio e sostituzione di condutture','45231111-6','45231000-5','Articolo','45','452','4523','45231'),
('Installazione di un sistema di condutture','45231112-3','45231000-5','Articolo','45','452','4523','45231'),
('Sostituzione di condutture','45231113-0','45231000-5','Articolo','45','452','4523','45231'),
('Lavori di costruzione di oleodotti e di gasdotti','45231200-7','45231000-5','Articolo','45','452','4523','45231'),
('Lavori di costruzione di oleodotti','45231210-0','45231000-5','Articolo','45','452','4523','45231'),
('Lavori di costruzione di gasdotti','45231220-3','45231000-5','Articolo','45','452','4523','45231'),
('Lavori di costruzione di condotte di distribuzione del gas','45231221-0','45231000-5','Articolo','45','452','4523','45231'),
('Gasometro','45231222-7','45231000-5','Articolo','45','452','4523','45231'),
('Lavori sussidiari di distribuzione del gas','45231223-4','45231000-5','Articolo','45','452','4523','45231'),
('Lavori di costruzione di condotte idriche e fognarie','45231300-8','45231000-5','Articolo','45','452','4523','45231'),
('Lavori generali di costruzione di linee elettriche','45231400-9','45231000-5','Articolo','45','452','4523','45231'),
('Condotte d''aria compressa','45231500-0','45231000-5','Articolo','45','452','4523','45231'),
('Circuito pneumatico di consegna postale','45231510-3','45231000-5','Articolo','45','452','4523','45231'),
('Lavori di costruzione di linee di comunicazione','45231600-1','45231000-5','Articolo','45','452','4523','45231'),
('Lavori di costruzione e sussidiari per posa tubazioni e cavi','45232000-2','45230000-8','Categoria','45','452','4523','45232'),
('Lavori sussidiari per condotte idriche','45232100-3','45232000-2','Articolo','45','452','4523','45232'),
('Impianto di irrigazione','45232120-9','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di condutture per irrigazione','45232121-6','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di tubature per la conduzione di acqua piovana','45232130-2','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di condotte per teleriscaldamento','45232140-5','45232000-2','Articolo','45','452','4523','45232'),
('Centrale termica','45232141-2','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di impianti di trasferimento di calore','45232142-9','45232000-2','Articolo','45','452','4523','45232'),
('Impianti associati a reti di distribuzione idrica','45232150-8','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di rinnovamento di condotte idriche','45232151-5','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di stazioni di pompaggio','45232152-2','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di torri piezometriche','45232153-9','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di torri cisterna per acqua potabile','45232154-6','45232000-2','Articolo','45','452','4523','45232'),
('Lavori ausiliari per linee elettriche','45232200-4','45232000-2','Articolo','45','452','4523','45232'),
('Costruzione di linee aeree','45232210-7','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di sottostazioni','45232220-0','45232000-2','Articolo','45','452','4523','45232'),
('Sottostazione di trasformazione','45232221-7','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di linee telefoniche e linee di comunicazione e lavori ausiliari','45232300-5','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di linee telefoniche','45232310-8','45232000-2','Articolo','45','452','4523','45232'),
('Linee telefoniche di soccorso stradale','45232311-5','45232000-2','Articolo','45','452','4523','45232'),
('Linee di trasmissione di telecomunicazioni','45232320-1','45232000-2','Articolo','45','452','4523','45232'),
('Installazione di antenne','45232330-4','45232000-2','Articolo','45','452','4523','45232'),
('Lavori sussidiari per telediffusione','45232331-1','45232000-2','Articolo','45','452','4523','45232'),
('Lavori sussidiari per telecomunicazioni','45232332-8','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di stazioni di base per la telefonia mobile','45232340-7','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di condotte fognarie','45232400-6','45232000-2','Articolo','45','452','4523','45232'),
('Lavori su reti fognarie','45232410-9','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di condotte per acque reflue','45232411-6','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di impianti di depurazione delle acque residue','45232420-2','45232000-2','Articolo','45','452','4523','45232'),
('Impianto di trattamento delle acque fognarie','45232421-9','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di trattamento di fanghi','45232422-6','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di impianti di pompaggio delle acque di scarico','45232423-3','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione degli sbocchi di acque di rifiuto','45232424-0','45232000-2','Articolo','45','452','4523','45232'),
('Lavori in impianti per il trattamento dell''acqua','45232430-5','45232000-2','Articolo','45','452','4523','45232'),
('Impianto di pompaggio di acque reflue','45232431-2','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione per tubazioni di scarico','45232440-8','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di scarichi','45232450-1','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di drenaggio e di superficie','45232451-8','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di drenaggio','45232452-5','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di scoli','45232453-2','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione di bacini dell''acqua piovana','45232454-9','45232000-2','Articolo','45','452','4523','45232'),
('Lavori sanitari','45232460-4','45232000-2','Articolo','45','452','4523','45232'),
('Impianto di trasferimento di rifiuti','45232470-7','45232000-2','Articolo','45','452','4523','45232'),
('Lavori di costruzione,di fondazione e di superficie per autostrade e strade','45233000-9','45230000-8','Categoria','45','452','4523','45233'),
('Lavori di costruzione di strade e autostrade','45233100-0','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di autostrade','45233110-3','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di strade','45233120-6','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di strade principali','45233121-3','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di circonvallazioni','45233122-0','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di strade secondarie','45233123-7','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di strade di grande comunicazione','45233124-4','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di nodi stradali','45233125-1','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di nodi stradali a livelli sfalsati','45233126-8','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di nodi stradali a T','45233127-5','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di rotatorie','45233128-2','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di strade trasversali','45233129-9','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di strade nazionali','45233130-9','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di strade sopraelevate','45233131-6','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di manutenzione di strade nazionali','45233139-3','45233000-9','Articolo','45','452','4523','45233'),
('Lavori stradali','45233140-2','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di manutenzione stradale','45233141-9','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di riparazione stradale','45233142-6','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di cavalcavia','45233144-0','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di regolazione del traffico','45233150-5','45233000-9','Articolo','45','452','4523','45233'),
('Sentieri e altre strade imbrecciate','45233160-8','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di marciapiedi','45233161-5','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di piste ciclabili','45233162-2','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di superficie vari','45233200-1','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di superficie per autostrade','45233210-4','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di superficie per strade','45233220-7','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di verniciatura della segnaletica orizzontale','45233221-4','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di lastricatura e asfaltatura','45233222-1','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di rifacimento di manto stradale','45233223-8','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di strade a doppia carreggiata','45233224-5','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione a carreggiata unica','45233225-2','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di strade di accesso','45233226-9','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di strade di raccordo','45233227-6','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di rivestimenti di superficie','45233228-3','45233000-9','Articolo','45','452','4523','45233'),
('Manutenzione banchine laterali','45233229-0','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di rivestimento, strade escluse','45233250-6','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di rifacimento di manto','45233251-3','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di superficie per vie','45233252-0','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di superficie per strade pedonali','45233253-7','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di vie pedonali','45233260-9','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di cavalcavia pedonali','45233261-6','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione di isole pedonali','45233262-3','45233000-9','Articolo','45','452','4523','45233'),
('Verniciatura di superfici di parcheggio','45233270-2','45233000-9','Articolo','45','452','4523','45233'),
('Costruzione di barriere di protezione','45233280-5','45233000-9','Articolo','45','452','4523','45233'),
('Installazione di cartelli stradali','45233290-8','45233000-9','Articolo','45','452','4523','45233'),
('Installazione di delimitatori di corsia','45233291-5','45233000-9','Articolo','45','452','4523','45233'),
('Installazione di dispositivi di sicurezza','45233292-2','45233000-9','Articolo','45','452','4523','45233'),
('Installazione di arredo stradale','45233293-9','45233000-9','Articolo','45','452','4523','45233'),
('Installazione di segnali stradali','45233294-6','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di fondazione per autostrade,strade, vie e passaggi pedonali','45233300-2','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di fondazione per autostrade','45233310-5','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di fondazione per strade','45233320-8','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di fondazione per vie','45233330-1','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di fondazione per passaggi pedonali','45233340-4','45233000-9','Articolo','45','452','4523','45233'),
('Lavori di costruzione ferroviari e sistemi di trasporto a fune','45234000-6','45230000-8','Categoria','45','452','4523','45234'),
('Lavori di costruzione ferroviari','45234100-7','45234000-6','Articolo','45','452','4523','45234'),
('Ferrovie interurbane','45234110-0','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di ferrovie leggere','45234111-7','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di depositi ferroviari','45234112-4','45234000-6','Articolo','45','452','4523','45234'),
('Smantellamento di binari','45234113-1','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di terrapieni ferroviari','45234114-8','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di segnaletica ferroviaria','45234115-5','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di posa di binari','45234116-2','45234000-6','Articolo','45','452','4523','45234'),
('Lavori ferroviari urbani','45234120-3','45234000-6','Articolo','45','452','4523','45234'),
('Lavori tranviari','45234121-0','45234000-6','Articolo','45','452','4523','45234'),
('Lavori per metropolitana','45234122-7','45234000-6','Articolo','45','452','4523','45234'),
('Metropolitana parzialmente sotterranea','45234123-4','45234000-6','Articolo','45','452','4523','45234'),
('Metropolitana per trasporto passeggeri','45234124-1','45234000-6','Articolo','45','452','4523','45234'),
('Stazione della metropolitana','45234125-8','45234000-6','Articolo','45','452','4523','45234'),
('Costruzione di una linea tranviaria','45234126-5','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di depositi tranviari','45234127-2','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di piattaforme tranviarie','45234128-9','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di ferrovie urbane','45234129-6','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di massicciate','45234130-6','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di passaggi a livello','45234140-9','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di catenarie','45234160-5','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di sottostazioni di alimentazione per locomotive','45234170-8','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di officine ferroviarie','45234180-1','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di officine per il sezionamento dei binari','45234181-8','45234000-6','Articolo','45','452','4523','45234'),
('Sistemi di trasporto a fune','45234200-8','45234000-6','Articolo','45','452','4523','45234'),
('Sistemi di trasporto a fune con cabine','45234210-1','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di sciovie','45234220-4','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di seggiovie','45234230-7','45234000-6','Articolo','45','452','4523','45234'),
('Sistema ferroviario funicolare','45234240-0','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione di teleferiche','45234250-3','45234000-6','Articolo','45','452','4523','45234'),
('Lavori di costruzione per aerodromi, piste e superfici di manovra di campi d''aviazione','45235000-3','45230000-8','Categoria','45','452','4523','45235'),
('Costruzione di aeroporti','45235100-4','45235000-3','Articolo','45','452','4523','45235'),
('Costruzione di aerodromi','45235110-7','45235000-3','Articolo','45','452','4523','45235'),
('Lavori di costruzione di pavimentazione per campi di aviazione','45235111-4','45235000-3','Articolo','45','452','4523','45235'),
('Costruzione di piste di aviazione','45235200-5','45235000-3','Articolo','45','452','4523','45235'),
('Rifacimento manto di piste di aviazione','45235210-8','45235000-3','Articolo','45','452','4523','45235'),
('Lavori di costruzione di superfici di manovra per aerei','45235300-6','45235000-3','Articolo','45','452','4523','45235'),
('Lavori di costruzione di piste di rullaggio','45235310-9','45235000-3','Articolo','45','452','4523','45235'),
('Lavori di costruzione di pavimentazioni di piste di rullaggio','45235311-6','45235000-3','Articolo','45','452','4523','45235'),
('Lavori di costruzione di aree di stazionamento per aerei','45235320-2','45235000-3','Articolo','45','452','4523','45235'),
('Lavori di superficie','45236000-0','45230000-8','Categoria','45','452','4523','45236'),
('Lavori di superficie per impianti sportivi vari','45236100-1','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di superficie per campi sportivi','45236110-4','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di superficie per campi da golf','45236111-1','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di superficie per campi da tennis','45236112-8','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di superficie per piste di competizione','45236113-5','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di superficie per piste atletiche','45236114-2','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di riparazione di campi sportivi','45236119-7','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di superficie per impianti ricreativi','45236200-2','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di superficie per aree da gioco','45236210-5','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di superficie per giardini zoologici','45236220-8','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di superficie per giardini','45236230-1','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di superficie per parchi','45236250-7','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di riparazione di zone ricreative','45236290-9','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di superficie per cimiteri','45236300-3','45236000-0','Articolo','45','452','4523','45236'),
('Lavori di costruzione di palcoscenici','45237000-7','45230000-8','Categoria','45','452','4523','45237'),
('Lavori di costruzione per opere idrauliche','45240000-1','45200000-9','Classi','45','452','4524','45240'),
('Lavori di costruzione di porti','45241000-8','45240000-1','Categoria','45','452','4524','45241'),
('Lavori di costruzione di banchine','45241100-9','45241000-8','Articolo','45','452','4524','45241'),
('Lavori di costruzione sul luogo di terminali offshore','45241200-0','45241000-8','Articolo','45','452','4524','45241'),
('Lavori di costruzione di moli','45241300-1','45241000-8','Articolo','45','452','4524','45241'),
('Lavori di costruzione di darsene','45241400-2','45241000-8','Articolo','45','452','4524','45241'),
('Lavori di costruzione di pontili','45241500-3','45241000-8','Articolo','45','452','4524','45241'),
('Installazione di dispositivi di illuminazione portuale','45241600-4','45241000-8','Articolo','45','452','4524','45241'),
('Lavori di costruzioni di impianti di svago a riva','45242000-5','45240000-1','Categoria','45','452','4524','45242'),
('Lavori di costruzione di impianti per sport acquatici','45242100-6','45242000-5','Articolo','45','452','4524','45242'),
('Lavori di costruzione per rampa di messa a mare','45242110-9','45242000-5','Articolo','45','452','4524','45242'),
('Lavori di costruzione di porti da diporto','45242200-7','45242000-5','Articolo','45','452','4524','45242'),
('Lavori di costruzione di porti per panfili','45242210-0','45242000-5','Articolo','45','452','4524','45242'),
('Lavori di protezione costiera','45243000-2','45240000-1','Categoria','45','452','4524','45243'),
('Lavori di protezione delle scogliere','45243100-3','45243000-2','Articolo','45','452','4524','45243'),
('Lavori di consolidamento delle scogliere','45243110-6','45243000-2','Articolo','45','452','4524','45243'),
('Lavori di costruzione di frangiflutti','45243200-4','45243000-2','Articolo','45','452','4524','45243'),
('Lavori di costruzione di frangionde','45243300-5','45243000-2','Articolo','45','452','4524','45243'),
('Lavori di consolidamento di spiagge','45243400-6','45243000-2','Articolo','45','452','4524','45243'),
('Lavori di costruzione di difese marittime','45243500-7','45243000-2','Articolo','45','452','4524','45243'),
('Lavori di costruzione di argini e terrapieni','45243510-0','45243000-2','Articolo','45','452','4524','45243'),
('Lavori di costruzione di muri di sponda','45243600-8','45243000-2','Articolo','45','452','4524','45243'),
('Lavori di costruzione marina','45244000-9','45240000-1','Categoria','45','452','4524','45244'),
('Impianti marini','45244100-0','45244000-9','Articolo','45','452','4524','45244'),
('Banchine','45244200-1','45244000-9','Articolo','45','452','4524','45244'),
('Lavori di dragaggio e pompaggio per gli impianti di trattamento delle acque','45245000-6','45240000-1','Categoria','45','452','4524','45245'),
('Lavori di regolazione di corsi d''acqua e di controllo delle piene','45246000-3','45240000-1','Categoria','45','452','4524','45246'),
('Costruzione di argini fluviali','45246100-4','45246000-3','Articolo','45','452','4524','45246'),
('Lavori di protezione delle sponde','45246200-5','45246000-3','Articolo','45','452','4524','45246'),
('Lavori di difesa dalle piene','45246400-7','45246000-3','Articolo','45','452','4524','45246'),
('Manutenzione di impianti di difesa dalle piene','45246410-0','45246000-3','Articolo','45','452','4524','45246'),
('Lavori di costruzione di passeggiate','45246500-8','45246000-3','Articolo','45','452','4524','45246'),
('Lavori di costruzione di passerelle di legno','45246510-1','45246000-3','Articolo','45','452','4524','45246'),
('Lavori di costruzione per dighe,canali,reti di irrigazione e acquedotti','45247000-0','45240000-1','Categoria','45','452','4524','45247'),
('Lavori di costruzione per vie di navigazione','45247100-1','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di costruzione per canali','45247110-4','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di costruzione di canali di irrigazione','45247111-1','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di costruzione di canali di drenaggio','45247112-8','45247000-0','Articolo','45','452','4524','45247'),
('Vie d''acqua,canali esclusi','45247120-7','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di costruzione di acquedotti','45247130-0','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di costruzione per dighe e strutture simili fisse','45247200-2','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di costruzione di dighe','45247210-5','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di costruzione di muri di argini','45247211-2','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di rinforzo dighe','45247212-9','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di costruzione di briglie di trattenuta','45247220-8','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di costruzione di dighe di ritenuta','45247230-1','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di costruzione di sbarramenti statici','45247240-4','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di costruzione di serbatoi','45247270-3','45247000-0','Articolo','45','452','4524','45247'),
('Lavori di costruzione di impianti idromeccanici','45248000-7','45240000-1','Categoria','45','452','4524','45248'),
('Lavori di costruzione di chiuse su canale','45248100-8','45248000-7','Articolo','45','452','4524','45248'),
('Lavori di costruzione di bacini di carenaggio','45248200-9','45248000-7','Articolo','45','452','4524','45248'),
('Lavori di costruzione di bacini galleggianti','45248300-0','45248000-7','Articolo','45','452','4524','45248'),
('Lavori di costruzione di pontili di approdo','45248400-1','45248000-7','Articolo','45','452','4524','45248'),
('Lavori di costruzione di sbarramenti mobili','45248500-2','45248000-7','Articolo','45','452','4524','45248'),
('Lavori di costruzione per centrali elettriche,attività estrattive e manifatturiere, l''industria del gas e del petrolio','45250000-4','45200000-9','Classi','45','452','4525','45250'),
('Lavori di costruzione di centrali elettriche e impianti di riscaldamento','45251000-1','45250000-4','Categoria','45','452','4525','45251'),
('Lavori di costruzione di centrali elettriche','45251100-2','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di centrali atomiche','45251110-5','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di reattori nucleari','45251111-2','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di centrali idroelettriche','45251120-8','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di centrali termoelettriche','45251140-4','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di centrali geotermiche','45251141-1','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di centrali elettriche alimentate a legna','45251142-8','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di impianti per la produzione di aria compressa','45251143-5','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di torri di raffreddamento','45251150-7','45251000-1','Articolo','45','452','4525','45251'),
('Impianti eolici','45251160-0','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di centrali termiche','45251200-3','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di impianti di cogenerazione','45251220-9','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di impianti generatori di vapore','45251230-2','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di impianti di produzione di elettricità alimentati con gas di scarico','45251240-5','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di impianti di teleriscaldamento urbano','45251250-8','45251000-1','Articolo','45','452','4525','45251'),
('Lavori di costruzione di impianti di trattamento delle acque fognarie,impianti di depurazione e impianti di incenerimento di rifiuti','45252000-8','45250000-4','Categoria','45','452','4525','45252'),
('Lavori di costruzione di impianti di depurazione delle acque di scarico','45252100-9','45252000-8','Articolo','45','452','4525','45252'),
('Lavori di costruzione di impianti mobili','45252110-2','45252000-8','Articolo','45','452','4525','45252'),
('Lavori di costruzione di impianti di trattamento delle acque','45252120-5','45252000-8','Articolo','45','452','4525','45252'),
('Impianti di sedimentazione','45252121-2','45252000-8','Articolo','45','452','4525','45252'),
('Digestori di fognature','45252122-9','45252000-8','Articolo','45','452','4525','45252'),
('Sgrigliatori','45252123-6','45252000-8','Articolo','45','452','4525','45252'),
('Lavori di dragaggio e di pompaggio','45252124-3','45252000-8','Articolo','45','452','4525','45252'),
('Lavori di scarico di pietrame','45252125-0','45252000-8','Articolo','45','452','4525','45252'),
('Lavori di costruzione di impianti per il trattamento dell''acqua potabile','45252126-7','45252000-8','Articolo','45','452','4525','45252'),
('Lavori di costruzione di impianti per il trattamento delle acque luride','45252127-4','45252000-8','Articolo','45','452','4525','45252'),
('Apparecchiature per impianti fognari','45252130-8','45252000-8','Articolo','45','452','4525','45252'),
('Lavori di costruzione di impianti di disidratazione dei fanghi','45252140-1','45252000-8','Articolo','45','452','4525','45252'),
('Lavori di costruzione di impianti di movimentazione del carbone','45252150-4','45252000-8','Articolo','45','452','4525','45252'),
('Apparecchiature per impianti di depurazione','45252200-0','45252000-8','Articolo','45','452','4525','45252'),
('Lavori di costruzione di impianti di depurazione dell''acqua','45252210-3','45252000-8','Articolo','45','452','4525','45252'),
('Lavori di costruzione di impianti di incenerimento di rifiuti','45252300-1','45252000-8','Articolo','45','452','4525','45252'),
('Lavori di costruzione per impianti chimici','45253000-5','45250000-4','Categoria','45','452','4525','45253'),
('Lavori di costruzione di impianti di demineralizzazione','45253100-6','45253000-5','Articolo','45','452','4525','45253'),
('Lavori di costruzione di impianti di desolforazione','45253200-7','45253000-5','Articolo','45','452','4525','45253'),
('Lavori di costruzione di impianti di distillazione o rettificazione','45253300-8','45253000-5','Articolo','45','452','4525','45253'),
('Lavori di costruzione di impianti di distillazione dell''acqua','45253310-1','45253000-5','Articolo','45','452','4525','45253'),
('Lavori di costruzione di impianti di distillazione di alcol','45253320-4','45253000-5','Articolo','45','452','4525','45253'),
('Lavori di costruzione per impianti petrolchimici','45253400-9','45253000-5','Articolo','45','452','4525','45253'),
('Lavori di costruzione per impianti farmaceutici','45253500-0','45253000-5','Articolo','45','452','4525','45253'),
('Lavori di costruzione di impianti di deionizzazione','45253600-1','45253000-5','Articolo','45','452','4525','45253'),
('Lavori di costruzione di impianti di digestione','45253700-2','45253000-5','Articolo','45','452','4525','45253'),
('Lavori di costruzione di impianti di compostaggio','45253800-3','45253000-5','Articolo','45','452','4525','45253'),
('Lavori di costruzione per attività estrattive e manifatturiere','45254000-2','45250000-4','Categoria','45','452','4525','45254'),
('Lavori di costruzione per attività estrattive','45254100-3','45254000-2','Articolo','45','452','4525','45254'),
('Lavori di costruzione di bocche di pozzo','45254110-6','45254000-2','Articolo','45','452','4525','45254'),
('Lavori di costruzione per impianti manifatturieri','45254200-4','45254000-2','Articolo','45','452','4525','45254'),
('Lavori di costruzione per l''industria del petrolio e del gas','45255000-9','45250000-4','Categoria','45','452','4525','45255'),
('Lavori di costruzione di piattaforme di produzione','45255100-0','45255000-9','Articolo','45','452','4525','45255'),
('Lavori di costruzione di pozzi','45255110-3','45255000-9','Articolo','45','452','4525','45255'),
('Lavori di costruzione di impianti per piattaforme','45255120-6','45255000-9','Articolo','45','452','4525','45255'),
('Lavori di costruzione di impianti di superficie','45255121-3','45255000-9','Articolo','45','452','4525','45255'),
('Lavori di costruzione di raffinerie di petrolio','45255200-1','45255000-9','Articolo','45','452','4525','45255'),
('Lavori di costruzione di terminal petroliferi','45255210-4','45255000-9','Articolo','45','452','4525','45255'),
('Lavori di costruzione di terminal del gas','45255300-2','45255000-9','Articolo','45','452','4525','45255'),
('Lavori di fabbricazione','45255400-3','45255000-9','Articolo','45','452','4525','45255'),
('Lavori di fabbricazione offshore','45255410-6','45255000-9','Articolo','45','452','4525','45255'),
('Lavori di fabbricazione onshore','45255420-9','45255000-9','Articolo','45','452','4525','45255'),
('Demolizione di piattaforme','45255430-2','45255000-9','Articolo','45','452','4525','45255'),
('Lavori di trivellazione e di esplorazione','45255500-4','45255000-9','Articolo','45','452','4525','45255'),
('Tubi a spirale per pozzi','45255600-5','45255000-9','Articolo','45','452','4525','45255'),
('Lavori di costruzione di impianti di gassificazione del carbone','45255700-6','45255000-9','Articolo','45','452','4525','45255'),
('Lavori di costruzione di impianti di produzione del gas','45255800-7','45255000-9','Articolo','45','452','4525','45255'),
('Riparazione e manutenzione di impianti','45259000-7','45250000-4','Categoria','45','452','4525','45259'),
('Riparazione e manutenzione di impianti per il trattamento acque reflue','45259100-8','45259000-7','Articolo','45','452','4525','45259'),
('Riparazione e manutenzione di impianti di depurazione','45259200-9','45259000-7','Articolo','45','452','4525','45259'),
('Riparazione e manutenzione di centrali termiche','45259300-0','45259000-7','Articolo','45','452','4525','45259'),
('Potenziamento di impianti','45259900-6','45259000-7','Articolo','45','452','4525','45259'),
('Lavori di copertura ed altri lavori speciali di costruzione','45260000-7','45200000-9','Classi','45','452','4526','45260'),
('Costruzione e lavori connessi di ossature e coperture','45261000-4','45260000-7','Categoria','45','452','4526','45261'),
('Costruzione di ossature per tetti','45261100-5','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di copertura e tinteggiatura di tetti','45261200-6','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di copertura di tetti','45261210-9','45261000-4','Articolo','45','452','4526','45261'),
('Copertura di tetti con tegole','45261211-6','45261000-4','Articolo','45','452','4526','45261'),
('Copertura di tetti con ardesia','45261212-3','45261000-4','Articolo','45','452','4526','45261'),
('Copertura di tetti metallici','45261213-0','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di copertura di tetti con fogli incatramati','45261214-7','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di copertura di tetti con pannelli solari','45261215-4','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di tinteggiatura e rivestimento di tetti','45261220-2','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di tinteggiatura di tetti','45261221-9','45261000-4','Articolo','45','452','4526','45261'),
('Copertura di tetti in cemento','45261222-6','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di lattoneria e posa di grondaie','45261300-7','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di lattoneria','45261310-0','45261000-4','Articolo','45','452','4526','45261'),
('Posa di grondaie','45261320-3','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di rivestimento','45261400-8','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di isolamento tetti','45261410-1','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di impermeabilizzazione','45261420-4','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di riparazione e manutenzione di tetti','45261900-3','45261000-4','Articolo','45','452','4526','45261'),
('Riparazione di tetti','45261910-6','45261000-4','Articolo','45','452','4526','45261'),
('Lavori di manutenzione di tetti','45261920-9','45261000-4','Articolo','45','452','4526','45261'),
('Lavori speciali di costruzione,esclusi i lavori di copertura','45262000-1','45260000-7','Categoria','45','452','4526','45262'),
('Lavori di ponteggio','45262100-2','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di smantellamento ponteggi','45262110-5','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di montaggio di ponteggi','45262120-8','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di fondazione e trivellamento di pozzi d''acqua','45262200-3','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di fondazione','45262210-6','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di infissione di pali','45262211-3','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di consolidamento di scavi','45262212-0','45262000-1','Articolo','45','452','4526','45262'),
('Pareti colate in trincea','45262213-7','45262000-1','Articolo','45','452','4526','45262'),
('Trivellamento di pozzi d''acqua','45262220-9','45262000-1','Articolo','45','452','4526','45262'),
('Strutture in calcestruzzo','45262300-4','45262000-1','Articolo','45','452','4526','45262'),
('Lavori in cemento armato','45262310-7','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di ossatura in calcestruzzo','45262311-4','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di costruzione solette','45262320-0','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di pavimentazione','45262321-7','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di riparazione in calcestruzzo','45262330-3','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di iniezione di cemento','45262340-6','45262000-1','Articolo','45','452','4526','45262'),
('Lavori in calcestruzzo non rinforzato','45262350-9','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di cementazione','45262360-2','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di rivestimento in cemento','45262370-5','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di erezione di strutture in acciaio','45262400-5','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di erezione di strutture in acciaio per edifici','45262410-8','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di erezione di strutture in acciaio per altri fabbricati','45262420-1','45262000-1','Articolo','45','452','4526','45262'),
('Lavori per l''ormeggio a mare','45262421-8','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di trivellazione sottomarina','45262422-5','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di costruzione di pontoni','45262423-2','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di costruzione di moduli a mare','45262424-9','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di incamiciatura','45262425-6','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di costruzione di palafitte','45262426-3','45262000-1','Articolo','45','452','4526','45262'),
('Lavori edili e di muratura','45262500-6','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di muratura in pietra','45262510-9','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di intaglio su pietra','45262511-6','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di muratura in pietra da taglio','45262512-3','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di muratura','45262520-2','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di muratura a vista','45262521-9','45262000-1','Articolo','45','452','4526','45262'),
('Lavori edili','45262522-6','45262000-1','Articolo','45','452','4526','45262'),
('Lavori specializzati di costruzione vari','45262600-7','45262000-1','Articolo','45','452','4526','45262'),
('Ciminiere industriali','45262610-0','45262000-1','Articolo','45','452','4526','45262'),
('Muri di ritenuta','45262620-3','45262000-1','Articolo','45','452','4526','45262'),
('Costruzione di forni','45262630-6','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di miglioramento ambientale','45262640-9','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di rivestimento esterno','45262650-2','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di rimozione dell''amianto','45262660-5','45262000-1','Articolo','45','452','4526','45262'),
('Lavorazione del metallo','45262670-8','45262000-1','Articolo','45','452','4526','45262'),
('Saldatura','45262680-1','45262000-1','Articolo','45','452','4526','45262'),
('Ristrutturazione di edifici in rovina','45262690-4','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di modifica di edifici','45262700-8','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di manutenzione di affreschi','45262710-1','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di ampliamento di edifici','45262800-9','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di balconi e terrazze','45262900-0','45262000-1','Articolo','45','452','4526','45262'),
('Lavori di installazione di impianti in edifici','45300000-0','45000000-7','Gruppo','45','453','4530','45300'),
('Lavori di installazione di cablaggi','45310000-3','45300000-0','Classi','45','453','4531','45310'),
('Lavori di cablaggio e di connessione elettrici','45311000-0','45310000-3','Categoria','45','453','4531','45311'),
('Lavori di cablaggio elettrico','45311100-1','45311000-0','Articolo','45','453','4531','45311'),
('Lavori di connessione elettrici','45311200-2','45311000-0','Articolo','45','453','4531','45311'),
('Lavori di installazione di sistemi di allarme e di antenne','45312000-7','45310000-3','Categoria','45','453','4531','45312'),
('Lavori di installazione di sistemi d''allarme antincendio','45312100-8','45312000-7','Articolo','45','453','4531','45312'),
('Lavori di installazione di sistemi d''allarme antifurto','45312200-9','45312000-7','Articolo','45','453','4531','45312'),
('Lavori di installazione di antenne','45312300-0','45312000-7','Articolo','45','453','4531','45312'),
('Lavori di protezione da fulmini','45312310-3','45312000-7','Articolo','45','453','4531','45312'),
('Lavori di installazione di parafulmini','45312311-0','45312000-7','Articolo','45','453','4531','45312'),
('Lavori di installazione di antenne televisive','45312320-6','45312000-7','Articolo','45','453','4531','45312'),
('Lavori di installazione di antenne riceventi per radio','45312330-9','45312000-7','Articolo','45','453','4531','45312'),
('Lavori di installazione di ascensori e scale mobili','45313000-4','45310000-3','Categoria','45','453','4531','45313'),
('Lavori di installazione di ascensori','45313100-5','45313000-4','Articolo','45','453','4531','45313'),
('Lavori di installazione di scale mobili','45313200-6','45313000-4','Articolo','45','453','4531','45313'),
('Lavori di installazione di marciapiedi mobili','45313210-9','45313000-4','Articolo','45','453','4531','45313'),
('Installazione di dispositivi di telecomunicazione','45314000-1','45310000-3','Categoria','45','453','4531','45314'),
('Installazione di centralini telefonici','45314100-2','45314000-1','Articolo','45','453','4531','45314'),
('Installazione di standard telefonici','45314120-8','45314000-1','Articolo','45','453','4531','45314'),
('Installazione di linee telefoniche','45314200-3','45314000-1','Articolo','45','453','4531','45314'),
('Installazione di infrastrutture per cavi','45314300-4','45314000-1','Articolo','45','453','4531','45314'),
('Posa di cavi','45314310-7','45314000-1','Articolo','45','453','4531','45314'),
('Installazione di cavi per reti computerizzate','45314320-0','45314000-1','Articolo','45','453','4531','45314'),
('Lavori di installazione di impianti di riscaldamento e di altri impianti elettrici per edifici','45315000-8','45310000-3','Categoria','45','453','4531','45315'),
('Lavori di installazione di ingegneria elettrica','45315100-9','45315000-8','Articolo','45','453','4531','45315'),
('Lavori su turbine','45315200-0','45315000-8','Articolo','45','453','4531','45315'),
('Impianti di alimentazione di corrente','45315300-1','45315000-8','Articolo','45','453','4531','45315'),
('Impianti ad alta tensione','45315400-2','45315000-8','Articolo','45','453','4531','45315'),
('Impianti a media tensione','45315500-3','45315000-8','Articolo','45','453','4531','45315'),
('Impianti a bassa tensione','45315600-4','45315000-8','Articolo','45','453','4531','45315'),
('Lavori di installazione di stazioni di sezionamento','45315700-5','45315000-8','Articolo','45','453','4531','45315'),
('Lavori di installazione di sistemi di illuminazione e di segnalazione','45316000-5','45310000-3','Categoria','45','453','4531','45316'),
('Installazione di dispositivi di illuminazione esterna','45316100-6','45316000-5','Articolo','45','453','4531','45316'),
('Installazione di impianti di illuminazione stradale','45316110-9','45316000-5','Articolo','45','453','4531','45316'),
('Installazione di dispositivi di segnalazione','45316200-7','45316000-5','Articolo','45','453','4531','45316'),
('Installazione di mezzi di controllo del traffico','45316210-0','45316000-5','Articolo','45','453','4531','45316'),
('Installazione di cartelli stradali luminosi','45316211-7','45316000-5','Articolo','45','453','4531','45316'),
('Installazione di semafori stradali','45316212-4','45316000-5','Articolo','45','453','4531','45316'),
('Installazione di dispositivi di guida del traffico','45316213-1','45316000-5','Articolo','45','453','4531','45316'),
('Installazione di dispositivi di segnalazione aeroportuale','45316220-3','45316000-5','Articolo','45','453','4531','45316'),
('Installazione di segnaletica per porti','45316230-6','45316000-5','Articolo','45','453','4531','45316'),
('Altri lavori di installazione elettrica','45317000-2','45310000-3','Categoria','45','453','4531','45317'),
('Lavori di installazione elettrica di impianti di pompaggio','45317100-3','45317000-2','Articolo','45','453','4531','45317'),
('Lavori di installazione elettrica di trasformatori','45317200-4','45317000-2','Articolo','45','453','4531','45317'),
('Lavori di installazione elettrica di apparecchi di distribuzione di elettricità','45317300-5','45317000-2','Articolo','45','453','4531','45317'),
('Lavori di installazione elettrica di dispositivi di filtraggio','45317400-6','45317000-2','Articolo','45','453','4531','45317'),
('Lavori di isolamento','45320000-6','45300000-0','Classi','45','453','4532','45320'),
('Lavori di isolamento termico','45321000-3','45320000-6','Categoria','45','453','4532','45321'),
('Lavori di isolamento acustico','45323000-7','45320000-6','Categoria','45','453','4532','45323'),
('Opere in cartongesso','45324000-4','45320000-6','Categoria','45','453','4532','45324'),
('Lavori di idraulica','45330000-9','45300000-0','Classi','45','453','4533','45330'),
('Lavori di installazione di impianti di riscaldamento,ventilazione e climatizzazione','45331000-6','45330000-9','Categoria','45','453','4533','45331'),
('Lavori di installazione di impianti di riscaldamento centrale','45331100-7','45331000-6','Articolo','45','453','4533','45331'),
('Lavori di installazione di caldaie','45331110-0','45331000-6','Articolo','45','453','4533','45331'),
('Lavori di installazione di impianti di ventilazione e climatizzazione','45331200-8','45331000-6','Articolo','45','453','4533','45331'),
('Lavori di installazione di impianti di ventilazione','45331210-1','45331000-6','Articolo','45','453','4533','45331'),
('Lavori di installazione di impianti di ventilazione in strutture esterne','45331211-8','45331000-6','Articolo','45','453','4533','45331'),
('Lavori di installazione di impianti di climatizzazione','45331220-4','45331000-6','Articolo','45','453','4533','45331'),
('Lavori di installazione di impianti parziali di climatizzazione','45331221-1','45331000-6','Articolo','45','453','4533','45331'),
('Lavori di installazione di attrezzature di raffreddamento','45331230-7','45331000-6','Articolo','45','453','4533','45331'),
('Lavori di installazione di impianti di refrigerazione','45331231-4','45331000-6','Articolo','45','453','4533','45331'),
('Lavori di installazione di impianti idraulici e di evacuazione delle acque residue','45332000-3','45330000-9','Categoria','45','453','4533','45332'),
('Lavori idraulici','45332200-5','45332000-3','Articolo','45','453','4533','45332'),
('Lavori di posa di drenaggi','45332300-6','45332000-3','Articolo','45','453','4533','45332'),
('Lavori di installazione di apparecchiature idrosanitarie','45332400-7','45332000-3','Articolo','45','453','4533','45332'),
('Lavori di installazione di raccorderia gas','45333000-0','45330000-9','Categoria','45','453','4533','45333'),
('Lavori di installazione di impianti per la regolazione del gas','45333100-1','45333000-0','Articolo','45','453','4533','45333'),
('Lavori di installazione di contatori per il gas','45333200-2','45333000-0','Articolo','45','453','4533','45333'),
('Lavori di installazione di recinzioni,ringhiere e dispositivi di sicurezza','45340000-2','45300000-0','Classi','45','453','4534','45340'),
('Installazione di ringhiere','45341000-9','45340000-2','Categoria','45','453','4534','45341'),
('Installazione di recinzioni','45342000-6','45340000-2','Categoria','45','453','4534','45342'),
('Lavori di installazione di dispositivi antincendio','45343000-3','45340000-2','Categoria','45','453','4534','45343'),
('Lavori di ignifugazione','45343100-4','45343000-3','Articolo','45','453','4534','45343'),
('Lavori di installazione di impianti di estinzione','45343200-5','45343000-3','Articolo','45','453','4534','45343'),
('Lavori di installazione di impianti di estinzione del fuoco ad anidride carbonica','45343210-8','45343000-3','Articolo','45','453','4534','45343'),
('Lavori di installazione di estintori','45343220-1','45343000-3','Articolo','45','453','4534','45343'),
('Lavori di installazione di impianti di estinzione a spruzzo','45343230-4','45343000-3','Articolo','45','453','4534','45343'),
('Impianti meccanici','45350000-5','45300000-0','Classi','45','453','4535','45350'),
('Lavori di installazione di ingegneria meccanica','45351000-2','45350000-5','Categoria','45','453','4535','45351'),
('Lavori di completamento degli edifici','45400000-1','45000000-7','Gruppo','45','454','4540','45400'),
('Lavori di intonacatura','45410000-4','45400000-1','Classi','45','454','4541','45410'),
('Lavori di installazione di opere da falegname','45420000-7','45400000-1','Classi','45','454','4542','45420'),
('Lavori di falegnameria','45421000-4','45420000-7','Categoria','45','454','4542','45421'),
('Installazione di porte,finestre e componenti connesse','45421100-5','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di telai per porte e finestre','45421110-8','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di telai per porte','45421111-5','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di telai per finestre','45421112-2','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di soglie','45421120-1','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di porte e finestre','45421130-4','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di porte','45421131-1','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di finestre','45421132-8','45421000-4','Articolo','45','454','4542','45421'),
('Lavori di installazione di carpenteria metallica,porte e finestre escluse','45421140-7','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di tramezzi','45421141-4','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di imposte','45421142-1','45421000-4','Articolo','45','454','4542','45421'),
('Lavori di installazione di persiane','45421143-8','45421000-4','Articolo','45','454','4542','45421'),
('Lavori di installazione di tende','45421144-5','45421000-4','Articolo','45','454','4542','45421'),
('Lavori di installazione di stoini avvolgibili','45421145-2','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di controsoffitti','45421146-9','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di griglie','45421147-6','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di cancelli','45421148-3','45421000-4','Articolo','45','454','4542','45421'),
('Lavori di installazione di carpenteria non metallica','45421150-0','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di cucine componibili','45421151-7','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di pareti divisorie','45421152-4','45421000-4','Articolo','45','454','4542','45421'),
('Installazione di mobili ad incastro','45421153-1','45421000-4','Articolo','45','454','4542','45421'),
('Lavori di ferramenta','45421160-3','45421000-4','Articolo','45','454','4542','45421'),
('Carpenteria e falegnameria','45422000-1','45420000-7','Categoria','45','454','4542','45422'),
('Lavori in legno','45422100-2','45422000-1','Articolo','45','454','4542','45422'),
('Lavori di rivestimento di pavimenti e muri','45430000-0','45400000-1','Classi','45','454','4543','45430'),
('Lavori di rivestimento con piastrelle','45431000-7','45430000-0','Categoria','45','454','4543','45431'),
('Lavori di rivestimento con piastrelle di pavimenti','45431100-8','45431000-7','Articolo','45','454','4543','45431'),
('Lavori di rivestimento con piastrelle di muri','45431200-9','45431000-7','Articolo','45','454','4543','45431'),
('Posa e rivestimento di pavimenti,muri e tappezzeria','45432000-4','45430000-0','Categoria','45','454','4543','45432'),
('Lavori di rivestimento di pavimenti','45432100-5','45432000-4','Articolo','45','454','4543','45432'),
('Posa di pavimenti','45432110-8','45432000-4','Articolo','45','454','4543','45432'),
('Posa di rivestimenti flessibili per pavimenti','45432111-5','45432000-4','Articolo','45','454','4543','45432'),
('Posa di pavimentazione','45432112-2','45432000-4','Articolo','45','454','4543','45432'),
('Pavimentazioni a parchetto','45432113-9','45432000-4','Articolo','45','454','4543','45432'),
('Posa di rivestimenti per pavimento in legno','45432114-6','45432000-4','Articolo','45','454','4543','45432'),
('Lavori di installazione di contropavimenti','45432120-1','45432000-4','Articolo','45','454','4543','45432'),
('Pavimenti per sale informatiche','45432121-8','45432000-4','Articolo','45','454','4543','45432'),
('Lavori di rivestimento suoli','45432130-4','45432000-4','Articolo','45','454','4543','45432'),
('Lavori di rivestimento di muri e tappezzeria','45432200-6','45432000-4','Articolo','45','454','4543','45432'),
('Lavori di rivestimento murale','45432210-9','45432000-4','Articolo','45','454','4543','45432'),
('Lavori di tappezzeria','45432220-2','45432000-4','Articolo','45','454','4543','45432'),
('Lavori di tinteggiatura e posa in opera di vetrate','45440000-3','45400000-1','Classi','45','454','4544','45440'),
('Posa in opera di vetrate','45441000-0','45440000-3','Categoria','45','454','4544','45441'),
('Lavori di applicazione di rivestimenti protettivi','45442000-7','45440000-3','Categoria','45','454','4544','45442'),
('Lavori di tinteggiatura','45442100-8','45442000-7','Articolo','45','454','4544','45442'),
('Lavori di tinteggiatura per edifici','45442110-1','45442000-7','Articolo','45','454','4544','45442'),
('Lavori di tinteggiatura e di rivestimento protettivo di strutture','45442120-4','45442000-7','Articolo','45','454','4544','45442'),
('Lavori di tinteggiatura di strutture','45442121-1','45442000-7','Articolo','45','454','4544','45442'),
('Lavori di ritinteggiatura','45442180-2','45442000-7','Articolo','45','454','4544','45442'),
('Lavori di decapaggio','45442190-5','45442000-7','Articolo','45','454','4544','45442'),
('Lavori di applicazione di rivestimenti anticorrosivi','45442200-9','45442000-7','Articolo','45','454','4544','45442'),
('Lavori di galvanizzazione','45442210-2','45442000-7','Articolo','45','454','4544','45442'),
('Lavori di protezione delle superfici','45442300-0','45442000-7','Articolo','45','454','4544','45442'),
('Lavori di facciata','45443000-4','45440000-3','Categoria','45','454','4544','45443'),
('Altri lavori di completamento di edifici','45450000-6','45400000-1','Classi','45','454','4545','45450'),
('Lavori di decorazione','45451000-3','45450000-6','Categoria','45','454','4545','45451'),
('Posa in opera di elementi ornamentali','45451100-4','45451000-3','Articolo','45','454','4545','45451'),
('Lavori di rivestimento a pannelli','45451200-5','45451000-3','Articolo','45','454','4545','45451'),
('Giardini interni','45451300-6','45451000-3','Articolo','45','454','4545','45451'),
('Lavori di pulitura esterna di edifici','45452000-0','45450000-6','Categoria','45','454','4545','45452'),
('Pulitura esterna di edifici mediante sabbiatura','45452100-1','45452000-0','Articolo','45','454','4545','45452'),
('Lavori di riparazione e ripristino','45453000-7','45450000-6','Categoria','45','454','4545','45453'),
('Lavori di riparazione','45453100-8','45453000-7','Articolo','45','454','4545','45453'),
('Lavori di ristrutturazione','45454000-4','45450000-6','Categoria','45','454','4545','45454'),
('Lavori di restauro','45454100-5','45454000-4','Articolo','45','454','4545','45454'),
('Noleggio di macchinari e attrezzature per lavori edili e di genio civile con operatore','45500000-2','45000000-7','Gruppo','45','455','4550','45500'),
('Noleggio di gru con operatore','45510000-5','45500000-2','Classi','45','455','4551','45510'),
('Noleggio di macchine per movimento terra con operatore','45520000-8','45500000-2','Classi','45','455','4552','45520')
) AS tmp(cpv_descrizione, cpv_codice, cpv_codice_padre,cpv_tipologia, cpv_divisione, 
cpv_gruppo, cpv_classe, cpv_categoria)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_cpv cpv
  WHERE cpv.cpv_codice = tmp.cpv_codice
);

insert into cpass.cpass_t_testi_notifiche (codice, it_testo)
SELECT tmp.codice, tmp.it_testo
FROM (VALUES
('N0003','La RMS {{anno}}/{{numero}} e'' stata rifiutata dal validatore. Per i dettagli, consultare la RMS (icona I sullo stato).')
) AS tmp(codice, it_testo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_t_testi_notifiche tn
	WHERE tn.codice = tmp.codice
);