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
----------------------------------------------------------------------------------------------------------------------------------
------------------------------------------DDL-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--1
--da fare dopo aver capito gli impatti
ALTER TABLE cpass.cpass_r_utente_settore DROP COLUMN if EXISTS utente_rup_id;
--2
ALTER TABLE IF EXISTS cpass.cpass_t_utente ADD COLUMN IF NOT EXISTS rup boolean not null default false;
--3
--DROP TABLE IF EXISTS cpass.cpass_r_utente_rup_settore CASCADE;
CREATE TABLE IF NOT EXISTS cpass.cpass_r_utente_rup_settore (
  utente_rup_settore_id SERIAL,
  utente_id UUID NOT NULL,
  settore_id UUID NOT NULL,
  data_validita_inizio TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  data_validita_fine TIMESTAMP WITHOUT TIME ZONE,
  CONSTRAINT cpass_r_utente_rup_settore_pkey PRIMARY KEY(utente_rup_settore_id),
  CONSTRAINT fk_cpass_r_utente_rup_settore_t_settore FOREIGN KEY (settore_id)
    REFERENCES cpass.cpass_t_settore(settore_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_cpass_r_utente_rup_settore_t_utente FOREIGN KEY (utente_id)
    REFERENCES cpass.cpass_t_utente(utente_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE)
WITH (oids = false);

--4
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD COLUMN      IF NOT EXISTS settore_id UUID;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento DROP CONSTRAINT IF EXISTS fk_cpass_t_pba_intervento_t_settore;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD CONSTRAINT fk_cpass_t_pba_intervento_t_settore FOREIGN KEY (settore_id) REFERENCES cpass.cpass_t_settore (settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD COLUMN     IF NOT EXISTS esente_cup boolean default false;


--5
--6
--DROP TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati CASCADE;
CREATE TABLE IF NOT EXISTS cpass.cpass_t_pba_intervento_altri_dati (
  intervento_altri_dati_id UUID NOT NULL
  ,codice_interno      varchar(50)
  ,spese_sostenute     NUMERIC(13,5)
  ,iva_primo_anno      NUMERIC(8,5)
  ,iva_secondo_anno    NUMERIC(8,5)
  ,iva_anni_successivi NUMERIC(8,5)
  ,note                varchar(4000)
  ,intervento_id        UUID NOT NULL
  /*
  tipo_acquisto_verdi_id (FK verso cpass_d_pba_tipo_Acquisto)
  normativaRiferimento (varchar 200)
  oggettoVerdi (varchar 500)
  cpvVerdi_id (FK verso cpass_d_cpv)
  importoNettoIvaVerdi (numeric)
  importoIvaVerdi  (numeric)
  importoTotVerdi  (numeric)
  tipo_acquisto_mat_riciclati_id (FK verso cpass_d_pba_tipo_Acquisto)
  oggettoMatRic  (varchar 500)
  cpvMatRic_id (FK verso cpass_d_cpv)
  importoNettoIvaMatRic  (numeric)
  importoIvaMatRic  (numeric)
  importoTotMatRic  (numeric)
  */
  ,CONSTRAINT cpass_t_intervento_altri_dati_pkey PRIMARY KEY(intervento_altri_dati_id)
  ,CONSTRAINT fk_cpass_t_intervento_t_intervento_altri_dati FOREIGN KEY (intervento_id)
    REFERENCES cpass.cpass_t_pba_intervento(intervento_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
);
--7
ALTER TABLE cpass.cpass_t_pba_intervento_importi ADD COLUMN IF NOT EXISTS richiesta_motivazione boolean not null default false;
ALTER TABLE cpass.cpass_t_pba_intervento_importi ADD COLUMN IF NOT EXISTS motivazione varchar(200);
--8
--DROP TABLE IF EXISTS cpass.cpass_r_intervento_cpv CASCADE;
CREATE TABLE IF NOT EXISTS cpass.cpass_r_intervento_cpv (
  intervento_cpv_id SERIAL
  ,intervento_id UUID NOT NULL
  ,cpv_id INTEGER NOT NULL
  --,data_validita_inizio TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  --,data_validita_fine TIMESTAMP WITHOUT TIME ZONE,
  ,CONSTRAINT cpass_r_intervento_cpv_pkey PRIMARY KEY(intervento_cpv_id)
  ,CONSTRAINT fk_cpass_r_intervento_cpv_t_intervento FOREIGN KEY (intervento_id)
    REFERENCES cpass.cpass_t_pba_intervento(intervento_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
  ,CONSTRAINT fk_cpass_r_intervento_cpv_d_cpv FOREIGN KEY (cpv_id)
    REFERENCES cpass.cpass_d_cpv(cpv_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE)
WITH (oids = false);

--9
ALTER TABLE cpass.cpass_d_pba_ricompreso_tipo ADD COLUMN IF NOT EXISTS ricompreso_tipo_conteggio_importi boolean default false;
--10
ALTER TABLE cpass.cpass_d_pba_acquisto_variato ADD COLUMN IF NOT EXISTS acquisto_variato_descrizione_estesa VARCHAR(200);



DROP TABLE IF EXISTS cpass.cpass_r_pba_storico_intervento_rup ;

CREATE TABLE IF NOT EXISTS cpass.cpass_r_pba_storico_intervento_rup (
   intervento_rup_id SERIAL
  ,intervento_id     UUID NOT NULL
  ,utente_rup_id     UUID NOT NULL
  ,utente_id         UUID NOT NULL
  ,data_storicizzazione  timestamp  NOT NULL default now()
  ,CONSTRAINT cpass_r_intervento_rup_pkey PRIMARY KEY(intervento_rup_id)

  ,CONSTRAINT fk_cpass_r_pba_intervento_rup_t_utente FOREIGN KEY (utente_id)
    REFERENCES cpass.cpass_t_utente(utente_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE


  ,CONSTRAINT fk_cpass_r_pba_intervento_rup_t_rup_utente FOREIGN KEY (utente_rup_id)
    REFERENCES cpass.cpass_t_utente(utente_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE

  ,CONSTRAINT fk_cpass_r_pba_intervento_rup_t_intervento FOREIGN KEY (intervento_id)
    REFERENCES cpass.cpass_t_pba_intervento(intervento_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE

  );



DROP TABLE IF EXISTS cpass.cpass_t_metadati_funzione ;
CREATE TABLE IF NOT EXISTS cpass.cpass_t_metadati_funzione (
   metadati_funzione_id SERIAL
  ,modulo varchar(50) NOT NULL
  ,funzione varchar(250) NOT NULL
  ,chiave_colonna varchar(250) NOT NULL
  ,descrizione_colonna varchar(250) NOT NULL
  ,stringa_sql varchar(250)
  ,jpql varchar(250)
  ,CONSTRAINT cpass_t_ordinamento_ricerca_pkey PRIMARY KEY(metadati_funzione_id)

  );

  CREATE TABLE IF NOT EXISTS cpass.cpass_t_utente_rup_deleghe (
  utente_rup_deleghe_id SERIAL,
  utente_rup_id UUID NOT NULL,
  utente_rup_delegato_id UUID NOT NULL,
  data_validita_inizio TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  data_validita_fine TIMESTAMP WITHOUT TIME ZONE,
  CONSTRAINT cpass_t_utente_rup_deleghe_pkey PRIMARY KEY(utente_rup_deleghe_id),
  CONSTRAINT fk_cpass_t_utente_rup_deleghe_t_utente_rup FOREIGN KEY (utente_rup_id)
    REFERENCES cpass.cpass_t_utente(utente_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
  ,CONSTRAINT fk_cpass_t_utente_rup_deleghe_t_utente_rup_delegato FOREIGN KEY (utente_rup_delegato_id)
    REFERENCES cpass.cpass_t_utente(utente_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE)
WITH (oids = false);

ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD COLUMN IF NOT EXISTS data_visto timestamp;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD COLUMN IF NOT EXISTS utente_visto_id UUID;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD COLUMN IF NOT EXISTS data_validazione timestamp;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD COLUMN IF NOT EXISTS utente_validazione_id UUID;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD COLUMN IF NOT EXISTS data_rifiuto timestamp;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD COLUMN IF NOT EXISTS utente_rifiuto_id UUID;

ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento DROP CONSTRAINT IF EXISTS fk_cpass_t_pba_intervento_utente_visto;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento DROP CONSTRAINT IF EXISTS fk_cpass_t_pba_intervento_utente_validazione;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento DROP CONSTRAINT IF EXISTS fk_cpass_t_pba_intervento_utente_rifiuto;


ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD CONSTRAINT   fk_cpass_t_pba_intervento_utente_visto FOREIGN KEY (utente_visto_id) REFERENCES cpass.cpass_t_utente (utente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD CONSTRAINT   fk_cpass_t_pba_intervento_utente_validazione FOREIGN KEY (utente_validazione_id) REFERENCES cpass.cpass_t_utente (utente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD CONSTRAINT   fk_cpass_t_pba_intervento_utente_rifiuto FOREIGN KEY (utente_rifiuto_id) REFERENCES cpass.cpass_t_utente (utente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

  /*
  DROP TABLE IF EXISTS cpass.cpass_t_preferenze_utente CASCADE;

CREATE TABLE IF NOT EXISTS cpass.cpass_t_preferenze_utente (
   cpass_t_preferenze_utente_id SERIAL
  ,utente_id UUID NOT NULL
  ,pref_json TEXT NOT NULL
  ,CONSTRAINT cpass_t_preferenze_utente_pkey PRIMARY KEY(cpass_t_preferenze_utente_id)
  ,CONSTRAINT fk_cpass_t_preferenze_utente_t_utente FOREIGN KEY (utente_id)
    REFERENCES cpass.cpass_t_utente(utente_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE)
WITH (oids = false);
*/

ALTER TABLE IF EXISTS cpass.cpass_r_utente_settore DROP CONSTRAINT IF EXISTS idx_utente_settore;


ALTER TABLE cpass_r_utente_settore
ADD CONSTRAINT  idx_utente_settore
UNIQUE  (utente_id,settore_id);



CREATE TABLE IF NOT EXISTS cpass.cpass_d_pba_tipo_acquisto (
   tipo_acquisto_id SERIAL
  ,tipo_acquisto_codice varchar(50) NOT NULL
  ,tipo_acquisto_descrizione  varchar(250) NOT NULL
  ,tipo_acquisto_default  boolean NOT NULL DEFAULT FALSE
  ,CONSTRAINT cpass_d_pba_tipo_acquisto_pkey PRIMARY KEY(tipo_acquisto_id)
);


ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS tipo_acquisto_verdi_id Integer; --(FK verso cpass_d_pba_tipo_Acquisto)

ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS normativa_riferimento varchar (200);

ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS oggettoVerdi varchar (500);

ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS cpv_verdi_id Integer;-- (FK verso cpass_d_cpv)

ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS importo_netto_iva_verdi numeric;

ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS importo_iva_verdi  numeric;

ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS importo_tot_verdi  numeric;

ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS tipo_acquisto_mat_riciclati_id Integer; --(FK verso cpass_d_pba_tipo_Acquisto)

ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS oggetto_mat_ric  varchar(500);

ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS cpv_mat_ric_id Integer; --(FK verso cpass_d_cpv)

ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS importo_netto_iva_mat_ric  numeric;

ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS importo_iva_mat_ric  numeric;

ALTER TABLE cpass.cpass_t_pba_intervento_altri_dati ADD COLUMN IF NOT EXISTS importo_tot_mat_ric  numeric;

ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati DROP CONSTRAINT IF EXISTS fk_cpass_t_pba_intervento_altri_dati_tipo_acquisto_verdi;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati          ADD CONSTRAINT   fk_cpass_t_pba_intervento_altri_dati_tipo_acquisto_verdi FOREIGN KEY (tipo_acquisto_verdi_id) REFERENCES cpass.cpass_d_pba_tipo_acquisto (tipo_acquisto_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati DROP CONSTRAINT IF EXISTS fk_cpass_t_pba_intervento_altri_dati_tipo_acq_mat_riciclati;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati          ADD CONSTRAINT   fk_cpass_t_pba_intervento_altri_dati_tipo_acq_mat_riciclati FOREIGN KEY (tipo_acquisto_mat_riciclati_id) REFERENCES cpass.cpass_d_pba_tipo_acquisto (tipo_acquisto_id) ON DELETE NO ACTION ON UPDATE NO ACTION;


ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati DROP CONSTRAINT IF EXISTS fk_cpass_t_pba_intervento_altri_dati_cpv_verdi;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati          ADD CONSTRAINT   fk_cpass_t_pba_intervento_altri_dati_cpv_verdi FOREIGN KEY (cpv_verdi_id) REFERENCES cpass.cpass_d_cpv (cpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati DROP CONSTRAINT IF EXISTS fk_cpass_t_pba_intervento_altri_dati_cpv_met_ric;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati          ADD CONSTRAINT   fk_cpass_t_pba_intervento_altri_dati_cpv_met_ric FOREIGN KEY (cpv_mat_ric_id) REFERENCES cpass.cpass_d_cpv (cpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE cpass.cpass_t_ord_subimpegno_evasione ADD COLUMN IF NOT EXISTS data_sospensione TIMESTAMP WITHOUT TIME ZONE;
ALTER TABLE cpass.cpass_t_ord_subimpegno_evasione ADD COLUMN IF NOT EXISTS causale_sospensione_id INTEGER;


ALTER TABLE IF EXISTS cpass.cpass_t_ord_subimpegno_evasione DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_subimpegno_evasione_causale_sospensione;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_subimpegno_evasione          ADD CONSTRAINT   fk_cpass_t_ord_subimpegno_evasione_causale_sospensione
FOREIGN KEY (causale_sospensione_id) REFERENCES cpass.cpass_d_ord_causale_sospensione_evasione (causale_sospensione_id) ON DELETE NO ACTION ON UPDATE NO ACTION;


ALTER TABLE cpass.cpass_t_pba_intervento  DROP COLUMN if exists intervento_ricompreso_id;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento ADD COLUMN IF NOT EXISTS intervento_ricompreso_cui varchar(21);

ALTER TABLE IF EXISTS cpass.cpass_t_metadati_funzione ADD COLUMN IF NOT EXISTS ordinamento_layout INTEGER;
delete from cpass_t_metadati_funzione;
ALTER SEQUENCE cpass_t_metadati_funzione_metadati_funzione_id_seq RESTART WITH 1;

update cpass_t_pba_intervento set settore_id = 'a2f1eaa7-17dd-59db-ad27-d57db6dc0175' where settore_id is null;
ALTER TABLE cpass.cpass_t_pba_intervento  ALTER COLUMN settore_id SET NOT NULL;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento DROP CONSTRAINT IF EXISTS fk_cpass_t_pba_intervento_settore;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento          ADD CONSTRAINT   fk_cpass_t_pba_intervento_settore FOREIGN KEY (settore_id) REFERENCES cpass.cpass_t_settore(settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD COLUMN IF NOT EXISTS data_annullamento  TIMESTAMP WITHOUT TIME ZONE;

ALTER TABLE cpass.cpass_d_permesso DROP COLUMN if EXISTS permesso_trasversale;


--------------------------Procedure

DROP FUNCTION if exists cpass.pck_cpass_pba_rep_interventi_risorse(p_programma_id varchar, p_cup varchar, p_settore_interventi varchar, p_struttura_id varchar, p_cpv_id varchar, p_cognome varchar, p_descri varchar, p_order varchar);

DROP FUNCTION if exists cpass.pck_cpass_pba_rep_interventi_risorse(p_programma_id varchar, p_cup varchar, p_settore_interventi varchar, p_struttura_id varchar, p_cpv_id varchar, p_cognome varchar, p_descri varchar, p_order varchar);

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_interventi_risorse (
  p_programma_id varchar,
  p_cup varchar,
  p_settore_interventi varchar,
  p_struttura_id varchar,
  p_cpv_id varchar,
  p_cognome varchar,
  p_descri varchar,
  p_order varchar
)
RETURNS TABLE (
  id_allegato_scheda integer,
  intervento_cui varchar,
  intervento_anno_avvio integer,
  intervento_cup varchar,
  intervento_stato varchar,
  ricompreso_tipo_codice varchar,
  ricompreso_tipo_descrizione varchar,
  intervento_lotto_funzionale boolean,
  nuts_codice varchar,
  nuts_descrizione varchar,
  settore_interventi_codice varchar,
  settore_interventi_descrizione varchar,
  cpv_codice varchar,
  cpv_descrizione varchar,
  intervento_descrizione_acquisto varchar,
  priorita_codice varchar,
  priorita_descrizione varchar,
  utente_nome varchar,
  utente_cognome varchar,
  utente_codice_fiscale varchar,
  intervento_durata_mesi integer,
  intervento_nuovo_affid boolean,
  ausa varchar,
  ausa_descrizione varchar,
  acquisto_variato_codice varchar,
  acquisto_variato_descrizione varchar,
  programma_id uuid,
  programma_anno integer,
  ente_id uuid,
  ente_codice_fiscale varchar,
  ente_denominazione varchar,
  importo_anno_primo numeric,
  importo_anno_secondo numeric,
  importo_anni_successivi numeric,
  totale_importi numeric,
  risorsa varchar,
  tipologia varchar,
  settore_codice varchar,
  settore_descrizione varchar
) AS
$body$
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;




--select * from pck_cpass_pba_rep_interventi_risorse('7698a757-64ae-5596-bf48-883b8706cbcf','123456789789997','1','a2f1eaa7-17dd-59db-ad27-d57db6dc0175','1687','null','null','null');

----------------------------------------------------------------------------------------------------------------------------------
------------------------------------------DML-------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
UPDATE cpass.cpass_d_pba_risorsa
SET risorsa_descrizione = 'altro*'
WHERE risorsa_codice = '7' AND risorsa_tipo = 'BILANCIO'
;

UPDATE cpass.cpass_d_stato
SET stato_codice = 'CONFERMATO',
stato_descrizione = 'CONFERMATO'
WHERE stato_tipo = 'PROGRAMMA'
AND stato_codice = 'APPROVATO'
;


INSERT INTO cpass.cpass_t_metadati_funzione (modulo,funzione,chiave_colonna,descrizione_colonna,stringa_sql,jpql,ordinamento_layout)
SELECT tmp.modulo,tmp.funzione,tmp.chiave_colonna,tmp.descrizione_colonna,tmp.stringa_sql,tmp.jpql,tmp.ordinamento_layout
FROM (VALUES
('PBA','RICERCA_INTERVENTO','PBA.INTERVENTION.FIELD.PROGRAM.TYPE','Programma','programma.programma_anno ',' int.cpassTPbaProgramma.programmaAnno, int.cpassTPbaProgramma.programmaVersione ',1),
('PBA','RICERCA_INTERVENTO','PBA.INTERVENTION.FIELD.START_YEAR','Prima annualità','intervento.intervento_anno_avvio ','int.interventoAnnoAvvio',2),
('PBA','RICERCA_INTERVENTO','PBA.INTERVENTION.FIELD.STATE.SHORT','Stato','stato.stato_codice','int.cpassDStato.statoDescrizione',3),
('PBA','RICERCA_INTERVENTO','PBA.INTERVENTION.FIELD.PRIORITY','Priorità','priorita.priorita_descrizione','int.cpassDPbaPriorita.prioritaDescrizione',4),
('PBA','RICERCA_INTERVENTO','PBA.INTERVENTION.FIELD.CUI.SHORT','CUI','intervento.intervento_cui','int.interventoCui',5),
('PBA','RICERCA_INTERVENTO','PBA.INTERVENTION.FIELD.SECTOR','Settore','si.settore_interventi_descrizione','int.cpassDPbaSettoreInterventi.settoreInterventiDescrizione',6),
('PBA','RICERCA_INTERVENTO','PBA.INTERVENTION.FIELD.CUP','CUP','intervento.intervento_cup','int.interventoCup',7),
('PBA','RICERCA_INTERVENTO','PBA.INTERVENTION.FIELD.STRUCTURE.TITLE','Struttura','','int.cpassTSettore.settoreCodice',8),
('PBA','RICERCA_INTERVENTO','PBA.INTERVENTION.FIELD.RUP.SHORT','RUP','ute.utente_cognome','int.cpassTUtenteRup.utenteCognome',9),
('PBA','RICERCA_INTERVENTO','PBA.INTERVENTION.FIELD.DESCRIPTION','Descrizione acquisto','intervento.intervento_descrizione_acquisto','int.interventoDescrizioneAcquisto',10),
('PBA','RICERCA_INTERVENTO','PBA.INTERVENTION.FIELD.CPV.SHORT','CPV','cpv.cpv_descrizione','int.cpassDCpv.cpvDescrizione',11)

) AS tmp(modulo,funzione,chiave_colonna,descrizione_colonna,stringa_sql,jpql,ordinamento_layout)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_metadati_funzione ds
  WHERE
  ds.modulo = tmp.modulo
  and ds.funzione = tmp.funzione
  and ds.chiave_colonna = tmp.chiave_colonna
);


update cpass_d_ruolo set
ruolo_codice = 'COMPILATORE'
,ruolo_descrizione = 'COMPILATORE'
WHERE
ruolo_codice = 'OPPROC';

update cpass_d_ruolo set
ruolo_codice = 'DELEGATO_REFP'
,ruolo_descrizione = 'DELEGATO REFERENTE PROGRAMMA'
WHERE
ruolo_codice = 'OPPROG';

INSERT INTO cpass.cpass_d_ruolo (ruolo_codice,ruolo_descrizione)
SELECT tmp.ruolo_codice,tmp.ruolo_descrizione
FROM (VALUES
  ('RUO','RESPONSABILE UNITA'' ORGANIZZATIVA'),
  ('DELEGATO_RUP','DELEGATO DEL RUP')
) AS tmp(ruolo_codice,ruolo_descrizione)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_ruolo ds
  WHERE
  ds.ruolo_codice = tmp.ruolo_codice
);

INSERT INTO cpass_r_ruolo_modulo (ruolo_id, modulo_id)
SELECT dr.ruolo_id, dm.modulo_id
FROM (VALUES
	('RUO', 'PBA')
	,('DELEGATO_RUP', 'PBA')
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
    ('VISTA_INTERVENTO','Funzione vista intervento', 'INTERVENTI', false, 'B')
	,('RIFIUTA_INTERVENTO','Funzione rifiuta intervento', 'INTERVENTI', false, 'B')
	,('PRENDI_IN_CARICO_INTERVENTO','Funzione prendi in carico intervento', 'INTERVENTI', false, 'B')
	,('VOLTURA_INTERVENTO','Funzione voltura intervento', 'INTERVENTI', false, 'B')
	,('COPIA_PROGRAMMA','Funzione copia programma', 'PROGRAMMA', false, 'B')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );

--select *from cpass_d_ruolo







update cpass_d_permesso SET
permesso_codice = 'VALIDA_INTERVENTO'
,permesso_descrizione = 'funzione validazione intervento'
where
permesso_codice = 'APP_INTERVENTO';

update cpass_d_permesso SET
permesso_codice = 'CONF_PROGRAMMA'
,permesso_descrizione = 'funzione di conferma programma'
where
permesso_codice = 'APP_PROGRAMMA';

INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo
FROM (VALUES
     ('VISTA_INTERVENTO','Funzione vista intervento', 'INTERVENTI', false, 'B')
	,('RIFIUTA_INTERVENTO','Funzione rifiuta intervento', 'INTERVENTI', false, 'B')
	,('PRENDI_IN_CARICO_INTERVENTO','Funzione prendi in carico intervento', 'INTERVENTI', false, 'B')
	,('VOLTURA_INTERVENTO','Funzione voltura intervento', 'INTERVENTI', false, 'B')
	,('COPIA_PROGRAMMA','Funzione copia programma', 'INTERVENTI', false, 'B')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('REFP','VISTA_INTERVENTO'),
('REFP','RIFIUTA_INTERVENTO'),
('REFP','PRENDI_IN_CARICO_INTERVENTO'),
('REFP','VOLTURA_INTERVENTO'),
('REFP','COPIA_PROGRAMMA')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);


INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('DELEGATO_REFP','VISTA_INTERVENTO'),
('DELEGATO_REFP','RIFIUTA_INTERVENTO'),
('DELEGATO_REFP','COPIA_PROGRAMMA')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('RUO','VALIDA_INTERVENTO')
,('RUO','RIFIUTA_INTERVENTO')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);


INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('RUP','VISTA_INTERVENTO'),
('RUP','PRENDI_IN_CARICO_INTERVENTO')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);


INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('DELEGATO_RUP','CARICA_INTERVENTI_ANNI_PREC'),
('DELEGATO_RUP','STAMPA_INTERVENTO'),
('DELEGATO_RUP','ANN_INTERVENTO_APPROV'),
('DELEGATO_RUP','ANN_INTERVENTO_BOZZA'),
('DELEGATO_RUP','INS_INTERVENTO'),
('DELEGATO_RUP','MOD_INTERVENTO'),
('DELEGATO_RUP','VISTA_INTERVENTO'),
('DELEGATO_RUP','PRENDI_IN_CARICO_INTERVENTO')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('ADMIN','VISTA_INTERVENTO'),
('ADMIN','RIFIUTA_INTERVENTO'),
('ADMIN','PRENDI_IN_CARICO_INTERVENTO'),
('ADMIN','VOLTURA_INTERVENTO'),
('ADMIN','COPIA_PROGRAMMA')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);


update CPASS_D_STATO set
stato_codice      = 'VALIDATO'
,stato_descrizione = 'VALIDATO'
where
stato_codice = 'APPROVATO'
AND stato_tipo = 'INTERVENTO';

update CPASS_D_STATO set
stato_codice      = 'CONFERMATO'
,stato_descrizione = 'CONFERMATO'
where
stato_codice = 'APPROVATO'
AND stato_tipo = 'PROGRAMMA';

update CPASS_D_STATO set
stato_codice      = 'CANCELLATO'
,stato_descrizione = 'CANCELLATO'
where
stato_codice = 'ANNULLATO'
AND stato_tipo = 'PROGRAMMA';

update CPASS_D_STATO set
stato_codice      = 'CANCELLATO'
,stato_descrizione = 'CANCELLATO'
where
stato_codice = 'ANNULLATO'
AND stato_tipo = 'INTERVENTO';

update CPASS_D_STATO set
stato_codice      = 'VALIDATO'
,stato_descrizione = 'VALIDATO'
where
stato_codice = 'APPROVATO'
AND stato_tipo = 'INTERVENTO';

update CPASS_D_STATO set
stato_codice      = 'CONFERMATO'
,stato_descrizione = 'CONFERMATO'
where
stato_codice = 'APPROVATO'
AND stato_tipo = 'PROGRAMMA';

update CPASS_D_STATO set
stato_codice      = 'CANCELLATO'
,stato_descrizione = 'CANCELLATO'
where
stato_codice = 'ANNULLATO'
AND stato_tipo = 'PROGRAMMA';

update CPASS_D_STATO set
stato_codice      = 'CANCELLATO'
,stato_descrizione = 'CANCELLATO'
where
stato_codice = 'ANNULLATO'
AND stato_tipo = 'INTERVENTO';

INSERT INTO cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.tipo
FROM (VALUES
  ('VISTO' , 'VISTO', 'INTERVENTO')
) AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato ds
  WHERE ds.stato_codice = tmp.codice
);


INSERT INTO cpass.cpass_d_pba_tipo_acquisto (tipo_acquisto_codice, tipo_acquisto_descrizione, tipo_acquisto_default)
SELECT tmp.tipo_acquisto_codice, tmp.tipo_acquisto_descrizione, tmp.tipo_acquisto_default
FROM (VALUES
  ('1', 'no', true)
  ,('2', 'interamente', false)
  ,('3', 'in parte', false)
) AS tmp(tipo_acquisto_codice, tipo_acquisto_descrizione, tipo_acquisto_default)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_pba_tipo_acquisto ds
  WHERE ds.tipo_acquisto_codice = tmp.tipo_acquisto_codice
);

update CPASS_D_ORD_TIPO_ORDINE set flag_trasm_nso = true where tipologia_documento_codice in ('SEM');
update CPASS_D_ORD_TIPO_ORDINE set flag_trasm_nso = false where tipologia_documento_codice in ('INT');

-- parametro "tolleranza evasione"
INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('TOLLERANZA_EVASIONE', '0.05', 'EVASIONE', '', 'Per controllo tolleranza sul evasione', true)
) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass.cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);
-- parametro "MOTIVAZIONE_NON_RIPROPOSTO_DEFAULT"
INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('MOTIVAZIONE_NON_RIPROPOSTO_DEFAULT', 'campo su parametro da valorizzare', true, '', 'CPASS','motivazione per acquisti non riproposti di default in creazione acquisti da nuovo programma')
) AS tmp(chiave, valore, abilitata, riferimento, ambiente, note)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass.cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);

INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo
FROM (VALUES
	('ANN_INTERVENTO_VISTO', 'funzione annullamento intervento visto', 'INTERVENTI', false, 'B')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('RUP','ANN_INTERVENTO_VISTO'),
('DELEGATO_RUP','ANN_INTERVENTO_VISTO'),
('ADMIN', 'ANN_INTERVENTO_VISTO')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

-- fix CPASS-187 - ORD19 Ricercare ordini da evadere: admin non ha la voce di menu
-- associati all'ADMIN tutti i permessi relativi all'evasione
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (
	select permesso_codice as permesso
	from cpass_d_permesso p
	where permesso_titolo_box = 'EVASIONE'
) AS tmp
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = 'ADMIN'
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

update  cpass_t_parametro_stampa set procedure_utilizzate = 'pck_cpass_pba_rep_allegato_ii'
where nome_stampa = 'ALLEGATO_II';

update  cpass_t_parametro_stampa set procedure_utilizzate = 'pck_cpass_pba_rep_ordini'
where nome_stampa = 'PRT_T_ORD';

delete from cpass_t_parametro_stampa where nome_stampa = 'STAMPA_INTERVENTI';
INSERT INTO cpass_t_parametro_stampa (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
SELECT tmp.modulo, tmp.nome_stampa, tmp.file_name_template, tmp.parametro, tmp.parametro_tipo, tmp.ordinamento, tmp.procedure_utilizzate, tmp.note, tmp.formato_stampa
FROM (VALUES
     ('PBA', 'STAMPA_INTERVENTI', 'Stampa_acquisti.rptdesign', 'p_programma_id', 	'varchar', 1, 'pck_cpass_pba_rep_interventi_risorse', NULL, 'xlsx')
    ,('PBA', 'STAMPA_INTERVENTI', 'Stampa_acquisti.rptdesign', 'p_cup', 			'varchar', 2, 'pck_cpass_pba_rep_interventi_risorse', NULL, 'xlsx')
    ,('PBA', 'STAMPA_INTERVENTI', 'Stampa_acquisti.rptdesign', 'p_settore_interventi', 'varchar', 3, 'pck_cpass_pba_rep_interventi_risorse', NULL, 'xlsx')
    ,('PBA', 'STAMPA_INTERVENTI', 'Stampa_acquisti.rptdesign', 'p_struttura_id', 'varchar', 4, 'pck_cpass_pba_rep_interventi_risorse', NULL, 'xlsx')
    ,('PBA', 'STAMPA_INTERVENTI', 'Stampa_acquisti.rptdesign', 'p_cpv_id', 		'varchar', 5, 'pck_cpass_pba_rep_interventi_risorse', NULL, 'xlsx')
    ,('PBA', 'STAMPA_INTERVENTI', 'Stampa_acquisti.rptdesign', 'p_cognome', 		'varchar', 6, 'pck_cpass_pba_rep_interventi_risorse', NULL, 'xlsx')
    ,('PBA', 'STAMPA_INTERVENTI', 'Stampa_acquisti.rptdesign', 'p_descri', 		'varchar', 7, 'pck_cpass_pba_rep_interventi_risorse', NULL, 'xlsx')
    ,('PBA', 'STAMPA_INTERVENTI', 'Stampa_acquisti.rptdesign', 'p_order', 		'varchar', 8, 'pck_cpass_pba_rep_interventi_risorse', NULL, 'xlsx')
) AS tmp (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
WHERE NOT EXISTS (
    SELECT 1
    FROM cpass_t_parametro_stampa tps
    WHERE tps.modulo = tmp.modulo
    AND tps.nome_stampa = tmp.nome_stampa
    AND tps.parametro = tmp.parametro
    AND tps.ordinamento = tmp.ordinamento
);

INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo
FROM (VALUES
('ANN_INTERVENTO_BOZZA_ALL','funzione annullamento intervento in bozza trasversale a tutti i settori', 'INTERVENTI', false, 'B')
,('ANN_INTERVENTO_APPROV_ALL','funzione annullamento intervento approvato trasversale a tutti i settori', 'INTERVENTI', false, 'B')
,('MOD_INTERVENTO_ALL','funzione modifica intervento trasversale a tutti i settori', 'INTERVENTI', false, 'B')
,('VISTA_INTERVENTO_ALL','Funzione vista intervento trasversale a tutti i settori', 'INTERVENTI', false, 'B')
,('RIFIUTA_INTERVENTO_ALL','Funzione rifiuta intervento trasversale a tutti i settori', 'INTERVENTI', false, 'B')
,('VOLTURA_INTERVENTO_ALL','Funzione voltura intervento trasversale a tutti i settori', 'INTERVENTI', false, 'B')
,('VALIDA_INTERVENTO_ALL','funzione validazione intervento trasversale a tutti i settori', 'INTERVENTI', false, 'B')
,('ANN_INTERVENTO_VISTO_ALL','funzione annullamento intervento visto trasversale a tutti i settori', 'INTERVENTI', false, 'B')
,('VALIDA_INTERVENTO_SU_GERARCHIA','funzione validazione intervento verticale ai settori figli', 'INTERVENTI', false, 'B')
,('RIFIUTA_INTERVENTO_SU_GERARCHIA','funzione rifiuta intervento verticale ai settori figli', 'INTERVENTI', false, 'B')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );

delete from cpass_r_ruolo_permesso where permesso_id in (select permesso_id from cpass_d_permesso cdp where permesso_titolo_box ='INTERVENTI');
delete from cpass_d_permesso where permesso_codice in ('VALIDA_INTERVENTO', 'RIFIUTA_INTERVENTO', 'VOLTURA_INTERVENTO');

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (values
('REFP','INS_INTERVENTO')
,('REFP','MOD_INTERVENTO_ALL')
,('REFP','VALIDA_INTERVENTO_ALL')
,('REFP','ANN_INTERVENTO_BOZZA_ALL')
,('REFP','ANN_INTERVENTO_APPROV_ALL')
,('REFP','STAMPA_INTERVENTO')
,('REFP','CARICA_INTERVENTI_ANNI_PREC')
,('REFP','VISTA_INTERVENTO_ALL')
,('REFP','RIFIUTA_INTERVENTO_ALL')
,('REFP','VOLTURA_INTERVENTO_ALL')
,('REFP','ANN_INTERVENTO_VISTO_ALL')
,('DELEGATO_REFP','INS_INTERVENTO')
,('DELEGATO_REFP','MOD_INTERVENTO_ALL')
,('DELEGATO_REFP','VALIDA_INTERVENTO_ALL')
,('DELEGATO_REFP','ANN_INTERVENTO_BOZZA_ALL')
,('DELEGATO_REFP','ANN_INTERVENTO_APPROV_ALL')
,('DELEGATO_REFP','STAMPA_INTERVENTO')
,('DELEGATO_REFP','CARICA_INTERVENTI_ANNI_PREC')
,('DELEGATO_REFP','VISTA_INTERVENTO_ALL')
,('DELEGATO_REFP','RIFIUTA_INTERVENTO_ALL')
,('DELEGATO_REFP','ANN_INTERVENTO_VISTO_ALL')
,('ADMIN','INS_INTERVENTO')
,('ADMIN','MOD_INTERVENTO_ALL')
,('ADMIN','VALIDA_INTERVENTO_ALL')
,('ADMIN','ANN_INTERVENTO_BOZZA_ALL')
,('ADMIN','ANN_INTERVENTO_APPROV_ALL')
,('ADMIN','STAMPA_INTERVENTO')
,('ADMIN','CARICA_INTERVENTI_ANNI_PREC')
,('ADMIN','VISTA_INTERVENTO_ALL')
,('ADMIN','RIFIUTA_INTERVENTO_ALL')
,('ADMIN','PRENDI_IN_CARICO_INTERVENTO')
,('ADMIN','VOLTURA_INTERVENTO_ALL')
,('ADMIN','ANN_INTERVENTO_VISTO_ALL')
,('RUP','INS_INTERVENTO')
,('RUP','MOD_INTERVENTO')
,('RUP','ANN_INTERVENTO_BOZZA')
,('RUP','ANN_INTERVENTO_APPROV')
,('RUP','STAMPA_INTERVENTO')
,('RUP','CARICA_INTERVENTI_ANNI_PREC')
,('RUP','PRENDI_IN_CARICO_INTERVENTO')
,('RUP','ANN_INTERVENTO_VISTO')
,('RUP','VISTA_INTERVENTO')
,('DELEGATO_RUP','INS_INTERVENTO')
,('DELEGATO_RUP','MOD_INTERVENTO')
,('DELEGATO_RUP','ANN_INTERVENTO_BOZZA')
,('DELEGATO_RUP','ANN_INTERVENTO_APPROV')
,('DELEGATO_RUP','STAMPA_INTERVENTO')
,('DELEGATO_RUP','CARICA_INTERVENTI_ANNI_PREC')
,('DELEGATO_RUP','PRENDI_IN_CARICO_INTERVENTO')
,('DELEGATO_RUP','ANN_INTERVENTO_VISTO')
,('DELEGATO_RUP','VISTA_INTERVENTO')
,('RUO','VALIDA_INTERVENTO_SU_GERARCHIA')
,('RUO','STAMPA_INTERVENTO')
,('RUO','RIFIUTA_INTERVENTO_SU_GERARCHIA')
,('COMPILATORE','INS_INTERVENTO')
,('COMPILATORE','MOD_INTERVENTO')
,('COMPILATORE','ANN_INTERVENTO_BOZZA')
,('COMPILATORE','STAMPA_INTERVENTO')
,('OSS','STAMPA_INTERVENTO')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);


delete from cpass_r_ruolo_permesso where permesso_id in (select permesso_id from cpass_d_permesso cdp where permesso_titolo_box ='PROGRAMMA');
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (values
('REFP','INS_PROGRAMMA')
,('REFP','MOD_PROGRAMMA')
,('REFP','CONF_PROGRAMMA')
,('REFP','ANN_PROGRAMMA_BOZZA')
,('REFP','ANN_PROGRAMMA_APPROV')
,('REFP','ALIMENTAZIONE_DA_FONTE_ESTERNA')
,('REFP','TRASMETTI_PROGRAMMA')
,('REFP','COPIA_PROGRAMMA')
,('DELEGATO_REFP','INS_PROGRAMMA')
,('DELEGATO_REFP','MOD_PROGRAMMA')
,('DELEGATO_REFP','ANN_PROGRAMMA_APPROV')
,('DELEGATO_REFP','ALIMENTAZIONE_DA_FONTE_ESTERNA')
,('DELEGATO_REFP','COPIA_PROGRAMMA')
,('ADMIN','INS_PROGRAMMA')
,('ADMIN','MOD_PROGRAMMA')
,('ADMIN','CONF_PROGRAMMA')
,('ADMIN','ANN_PROGRAMMA_BOZZA')
,('ADMIN','ANN_PROGRAMMA_APPROV')
,('ADMIN','ALIMENTAZIONE_DA_FONTE_ESTERNA')
,('ADMIN','TRASMETTI_PROGRAMMA')
,('ADMIN','COPIA_PROGRAMMA')
,('RUP','ALIMENTAZIONE_DA_FONTE_ESTERNA')
,('DELEGATO_RUP','ALIMENTAZIONE_DA_FONTE_ESTERNA')
,('COMPILATORE','ALIMENTAZIONE_DA_FONTE_ESTERNA')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

INSERT INTO cpass.cpass_d_ruolo(ruolo_codice, ruolo_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
	('CHIUSURA_ORDINI', 'UTENTE CHE CHIUDE ORDINI')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_ruolo dr
	WHERE dr.ruolo_codice = tmp.codice
);
INSERT INTO cpass_r_ruolo_modulo (ruolo_id, modulo_id)
SELECT dr.ruolo_id, dm.modulo_id
FROM (VALUES
	('CHIUSURA_ORDINI', 'ORD')
) AS tmp(ruolo, modulo)
JOIN cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass_d_modulo dm ON dm.modulo_codice = tmp.modulo
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_r_ruolo_modulo rrm
	WHERE rrm.ruolo_id = dr.ruolo_id
	AND rrm.modulo_id = dm.modulo_id
);

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('CHIUSURA_ORDINI', 'CHIUDI_ORDINE')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);
