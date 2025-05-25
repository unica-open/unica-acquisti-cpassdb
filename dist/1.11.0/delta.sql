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

--DROP table if  exists  CPASS_T_ORD_PROTOCOLLO_ORDINE;      
--DROP table if  exists  CPASS_T_ORD_DOCUMENTI_ORDINE;       
--DROP table if  exists  CPASS_R_SETTORE_AOO_ACTA;		    
--DROP table if  exists  CPASS_T_SETTORE_SERIE_ACTA;         
--DROP table if  exists  CPASS_R_UFFICIO_SERIE;         
--DROP table if  exists  CPASS_R_ODS_DATI_CONTABILI;
--DROP table if  exists  CPASS_D_AOO_ACTA ;                   

--select * from cpass_t_parametro_stampa where nome_stampa ='STAMPA_INTERVENTI'
--order by ordinamento;


create table if not exists  CPASS_D_AOO_ACTA (	
     aoo_acta_id			SERIAL PRIMARY KEY
    ,aoo_acta_orig_id		INTEGER      not null 
    ,ente_id                UUID         not null
	,aoo_descrizione 		varchar(200) not NULL	
	,data_fine_validita		TIMESTAMP
  );		

create table if not exists  CPASS_T_SETTORE_SERIE_ACTA	(
	 SETTORE_SERIE_ACTA_ID 	SERIAL PRIMARY KEY
    ,settore_id				UUID
	,serie_id				VARCHAR(200)
	,data_fine_validita		TIMESTAMP
);
ALTER TABLE IF EXISTS cpass.CPASS_T_SETTORE_SERIE_ACTA DROP CONSTRAINT IF EXISTS fk_CPASS_T_SETTORE_SERIE_ACTA;
ALTER TABLE cpass.CPASS_T_SETTORE_SERIE_ACTA ADD CONSTRAINT fk_CPASS_T_SETTORE_SERIE_ACTA FOREIGN KEY (settore_id) REFERENCES cpass_t_settore (settore_id);
-------------------------
-------------------------
create table if not exists  CPASS_R_UFFICIO_SERIE	(
	 UFFICIO_SERIE_ID 	    SERIAL PRIMARY KEY
    ,ufficio_id				INTEGER
	,uuid_serie_acta		VARCHAR(200)
	--,data_fine_validita		TIMESTAMP
);
ALTER TABLE IF EXISTS cpass.CPASS_R_UFFICIO_SERIE DROP CONSTRAINT IF EXISTS fk_CPASS_R_UFFICIO_SERIE;
ALTER TABLE cpass.CPASS_R_UFFICIO_SERIE ADD CONSTRAINT fk_CPASS_R_UFFICIO_SERIE FOREIGN KEY (ufficio_id) REFERENCES cpass_t_ufficio (ufficio_id);

drop table if exists  CPASS_T_ORD_PROTOCOLLO_ORDINE;
create table if not exists  CPASS_T_ORD_PROTOCOLLO_ORDINE(
     PROTOCOLLO_ORDINE_ID   SERIAL PRIMARY KEY
    ,TESTATA_ORDINE_ID      UUID

    ,anno_protocollo 		INTEGER
    ,numero_protocollo 		VARCHAR(20)
    ,aoo 					VARCHAR(50)
    ,data_protocollo        TIMESTAMP
    ,descrizione_protocollo VARCHAR(2000)

    ,anno_protocollo_ORIG   INTEGER
    ,numero_protocollo_ORIG VARCHAR(20)
    ,aoo_ORIG    VARCHAR(50)
    ,data_protocollo_orig   TIMESTAMP
    ,descrizione_protocollo_orig  VARCHAR(2000)

    ,aoo_acta_id 			INTEGER

    ,UUID_DOCUMENTO_ORIG    VARCHAR(50)
    ,UUID_REG_PROTOCOLLO_ORIG     VARCHAR(50)
    ,UUID_DOCUMENTO_ORDINE  VARCHAR(50)
    ,UUID_REG_PROTOCOLLO_ORDINE   VARCHAR(50)
    ,data_creazione timestamp without time zone DEFAULT now() NOT NULL
    ,utente_creazione character varying(250) NOT NULL
    ,data_modifica timestamp without time zone DEFAULT now() NOT NULL
    ,utente_modifica character varying(250) NOT NULL
    ,data_cancellazione timestamp without time zone
    ,utente_cancellazione character varying(250)
    ,optlock uuid DEFAULT public.uuid_generate_v4() NOT NULL
);
ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_PROTOCOLLO_ORDINE DROP CONSTRAINT IF EXISTS fk_cpass_t_ORD_PROTOCOLLO_ORDINE_t_testata;
ALTER TABLE cpass.CPASS_T_ORD_PROTOCOLLO_ORDINE ADD CONSTRAINT fk_cpass_t_ORD_PROTOCOLLO_ORDINE_t_testata FOREIGN KEY (TESTATA_ORDINE_ID) REFERENCES cpass_t_ord_testata_ordine (TESTATA_ORDINE_ID);
ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_PROTOCOLLO_ORDINE DROP CONSTRAINT IF EXISTS fk_cpass_t_ORD_PROTOCOLLO_ORDINE_AOO;
ALTER TABLE cpass.CPASS_T_ORD_PROTOCOLLO_ORDINE ADD CONSTRAINT fk_cpass_t_ORD_PROTOCOLLO_ORDINE_AOO FOREIGN KEY (aoo_acta_id) REFERENCES CPASS_D_AOO_ACTA (aoo_acta_id);

create table if not exists  CPASS_T_ORD_DOCUMENTI_ORDINE (
    documenti_ORDINE_ID 	SERIAL PRIMARY KEY
    ,TESTATA_ORDINE_ID      UUID
    ,progressivo         	INTEGER		
    ,descrizione			VARCHAR(2000)
    ,file               	bytea NULL
    ,nomeFile				VARCHAR(50)
	,ext					VARCHAR(50)
    ,data_creazione 		timestamp without time zone DEFAULT now() NOT NULL
    ,utente_creazione 		character varying(250) NOT NULL
    ,data_modifica 			timestamp without time zone DEFAULT now() NOT NULL
    ,utente_modifica 		character varying(250) NOT NULL
    ,data_cancellazione 	timestamp without time zone
    ,utente_cancellazione 	character varying(250)
    ,optlock 				uuid DEFAULT public.uuid_generate_v4() NOT NULL
);
ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_DOCUMENTI_ORDINE DROP CONSTRAINT IF EXISTS fk_cpass_t_ORD_DOCUMENTI_ORDINE_t_testata;
ALTER TABLE cpass.CPASS_T_ORD_DOCUMENTI_ORDINE ADD CONSTRAINT fk_cpass_t_ORD_DOCUMENTI_ORDINE_t_testata FOREIGN KEY (TESTATA_ORDINE_ID) REFERENCES cpass_t_ord_testata_ordine (TESTATA_ORDINE_ID);


create table if not exists  CPASS_R_SETTORE_AOO_ACTA	(
	 SETTORE_AOO_id 	SERIAL PRIMARY KEY
    ,settore_id	   		UUID
	,aoo_acta_id		INTEGER	
	,data_fine_validita	TIMESTAMP	
);
ALTER TABLE IF EXISTS cpass.CPASS_R_SETTORE_AOO_ACTA DROP CONSTRAINT IF EXISTS fk_CPASS_R_SETTORE_AOO_ACTA_SETTORE;
ALTER TABLE cpass.CPASS_R_SETTORE_AOO_ACTA ADD CONSTRAINT fk_CPASS_R_SETTORE_AOO_ACTA_SETTORE FOREIGN KEY (settore_id) REFERENCES cpass_t_settore (settore_id);
ALTER TABLE IF EXISTS cpass.CPASS_R_SETTORE_AOO_ACTA DROP CONSTRAINT IF EXISTS fk_CPASS_R_SETTORE_AOO_ACTA_AOO;
ALTER TABLE cpass.CPASS_R_SETTORE_AOO_ACTA ADD CONSTRAINT fk_CPASS_R_SETTORE_AOO_ACTA_AOO FOREIGN KEY (aoo_acta_id) REFERENCES CPASS_D_AOO_ACTA (aoo_acta_id);

create table if not exists  CPASS_T_SETTORE_SERIE (
    SETTORE_SERIE_ID  	SERIAL PRIMARY KEY
    ,serie_tipologica_uuid     uuid not null
    ,settore_emittente_id uuid not null
);
ALTER TABLE cpass.CPASS_T_SETTORE_SERIE DROP CONSTRAINT if exists fk_CPASS_T_SETTORE_SERIE_SETTORE;
ALTER TABLE cpass.CPASS_T_SETTORE_SERIE ADD CONSTRAINT  fk_CPASS_T_SETTORE_SERIE_SETTORE FOREIGN KEY (settore_emittente_id) REFERENCES cpass_t_settore (settore_id);

create table if not exists  CPASS_R_ODS_DATI_CONTABILI (
    dati_contabili_ID  	SERIAL PRIMARY KEY
    ,oggetti_spesa_id    INTEGER
    ,prezzo_minimo	NUMERIC
    ,prezzo_massimo  NUMERIC
    ,ultimo_prezzo   NUMERIC
    ,data_creazione timestamp without time zone DEFAULT now() NOT NULL
    ,utente_creazione character varying(250) NOT NULL
    ,data_modifica timestamp without time zone DEFAULT now() NOT NULL
    ,utente_modifica character varying(250) NOT NULL
    ,data_cancellazione timestamp without time zone
    ,utente_cancellazione character varying(250)
    ,optlock uuid DEFAULT public.uuid_generate_v4() NOT NULL
);
ALTER TABLE cpass.CPASS_R_ODS_DATI_CONTABILI DROP CONSTRAINT if exists fk_CPASS_R_ODS_DATI_CONTABILI_ODS;
ALTER TABLE cpass.CPASS_R_ODS_DATI_CONTABILI ADD CONSTRAINT fk_CPASS_R_ODS_DATI_CONTABILI_ODS FOREIGN KEY (oggetti_spesa_id) REFERENCES cpass_d_oggetti_spesa (oggetti_spesa_id);
ALTER TABLE cpass.CPASS_R_ODS_DATI_CONTABILI DROP CONSTRAINT if exists unique_CPASS_R_ODS_DATI_CONTABILI_ODS;
ALTER TABLE cpass.CPASS_R_ODS_DATI_CONTABILI ADD CONSTRAINT unique_CPASS_R_ODS_DATI_CONTABILI_ODS UNIQUE (oggetti_spesa_id);

ALTER TABLE cpass.cpass_t_settore add column if not exists firma VARCHAR(50);

INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
    ('IMPLEMENTOR', 'acta', 'DOCUMENTALE', '', 'Per interrogazione PROTOCOLLO ACTA', true)
    
) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);



INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo, disattivabile, attivo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo, tmp.disattivabile, tmp.attivo
FROM (VALUES
	('INVIA_IN_FIRMA','Invia in firma','ORDINE',false,'B', 'SI', true)
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo, disattivabile, attivo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('ORDINATORE','INVIA_IN_FIRMA'),
	('ADMIN_ENTE','INVIA_IN_FIRMA'),
	('ADMIN','INVIA_IN_FIRMA')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);



CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_rep_ordini (
  p_ordine_id varchar
)
RETURNS TABLE (
  ordine_anno integer,
  ordine_numero integer,
  ordine_data_emis timestamp,
  ordine_consegna_da timestamp,
  ordine_consegna_a timestamp,
  ordine_num_procedura varchar,
  ordine_note varchar,
  ordine_provv_numero varchar,
  ordine_provv_anno integer,
  ordine_cons_rif varchar,
  ordine_consegna_indirizzo varchar,
  ordine_consegna_cap varchar,
  ordine_consegna_localita varchar,
  ordine_tipo_doc varchar,
  ordine_tipo_proc varchar,
  ufficio_codice varchar,
  settore_codice varchar,
  settore_descrizione varchar,
  settore_indirizzo varchar,
  settore_num_civico varchar,
  settore_cap varchar,
  settore_localita varchar,
  settore_provincia varchar,
  rda_anno integer,
  rda_numero integer,
  ente_codice_fiscale varchar,
  forn_ragione_sociale varchar,
  forn_indirizzo varchar,
  forn_numero_civico varchar,
  forn_cap varchar,
  forn_comune varchar,
  forn_provincia varchar,
  forn_codice varchar,
  settdest_codice varchar,
  settdest_descrizione varchar,
  dest_indirizzo varchar,
  dest_num_civico varchar,
  dest_cap varchar,
  dest_localita varchar,
  dest_provincia varchar,
  dest_contatto varchar,
  dest_email varchar,
  dest_telefono varchar,
  ogg_descrizione varchar,
  ogg_codice varchar,
  codifica_listino_fornitore varchar,
  unita varchar,
  ordine_quantita numeric,
  ordine_percent_sconto numeric,
  ordine_percent_sconto2 numeric,
  aliquota_iva varchar,
  ordine_prezzo_unitario numeric,
  ordine_importo_totale numeric,
  ordine_importo_sconto numeric,
  ordine_importo_sconto2 numeric,
  ordine_importo_netto numeric,
  ordine_importo_iva numeric,
  rigaordine_note varchar,
  ordine_consegna_parziale boolean,
  utente_nome varchar,
  utente_cognome varchar,
  utente_telefono varchar,
  dirigente_nome varchar,
  dirigente_cognome varchar
) AS
$body$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query
select tord.ordine_anno,
       tord.ordine_numero,
       tord.data_emissione,
       tord.consegna_data_da,
       tord.consegna_data_a,
       tord.numero_procedura,        
       tord.note ,
       tord.provvedimento_numero ,
       tord.provvedimento_anno ,
       tord.consegna_riferimento ,
       tord.consegna_indirizzo  ,
       tord.consegna_cap   ,
       tord.consegna_localita ,
       tipoOrd.tipologia_documento_descrizione ,
       tipoProc.tipo_procedura_descrizione ,
       uff.ufficio_codice , 
       sett.settore_codice ,
       sett.settore_descrizione , 
       indirizzo_sett.indirizzo ,
       indirizzo_sett.num_civico ,
       indirizzo_sett.cap ,
       indirizzo_sett.localita ,
       indirizzo_sett.provincia ,
       rda.rda_anno,
       rda.rda_numero, 
       ente.ente_codice_fiscale ,
       forn.ragione_sociale ,
       forn.indirizzo ,
       forn.numero_civico ,
       forn.cap ,
       forn.comune ,
       forn.provincia ,
       forn.codice ,
       settDest.settore_codice ,
       sett_dest_indir.descrizione, 
       dest.indirizzo ,
       dest.num_civico ,
       dest.cap ,
       dest.localita ,
       dest.provincia ,
       dest.contatto ,
       dest.email ,
       dest.telefono ,
       oggSp.oggetti_spesa_descrizione ,
       oggSp.oggetti_spesa_codice ,
       lisForn.listino_fornitore_codice_ods ,
       unita.unita_misura_descrizione ,
       rigaOrd.quantita ,
       rigaOrd.percentuale_sconto ,
       rigaOrd.percentuale_sconto2 ,
       iva.aliquote_iva_codice ,
       rigaOrd.prezzo_unitario ,
       rigaOrd.importo_totale ,
       rigaOrd.importo_sconto , 
       rigaOrd.importo_sconto2 ,
       rigaOrd.importo_netto ,
       rigaOrd.importo_iva  , 
       rigaOrd.note ,
       rigaOrd.consegna_parziale ,
       utente.utente_nome ,
       utente.utente_cognome ,
       utente.telefono ,
       utenteDir.utente_nome,
       utenteDir.utente_cognome
from   CPASS_T_ORD_TESTATA_ORDINE tord
 join  CPASS_D_ORD_TIPO_ORDINE tipoOrd on tord.tipo_ordine_id = tipoOrd.tipo_ordine_id
 join  CPASS_D_ORD_TIPO_PROCEDURA tipoProc on tord.tipo_procedura_id = tipoProc.tipo_procedura_id
 join  CPASS_T_UFFICIO uff on tord.ufficio_id = uff.ufficio_id
 join  CPASS_T_SETTORE sett on tord.settore_emittente_id = sett.settore_id
 join   cpass_t_settore_indirizzo indirizzo_sett on sett.settore_id = indirizzo_sett.settore_id and indirizzo_sett.principale = true
 join  CPASS_T_ENTE ente on ente.ente_id = sett.ente_id
 join  CPASS_T_FORNITORE forn on tord.fornitore_id = forn.fornitore_id
 join  cpass_t_ord_destinatario_ordine dest on  tord.testata_ordine_id = dest.testata_ordine_id
 join  CPASS_T_SETTORE settDest on dest.settore_destinatario_id = settDest.settore_id
 join  CPASS_T_ORD_RIGA_ORDINE rigaOrd on dest.destinatario_id = rigaOrd.destinatario_id
 join  CPASS_D_OGGETTI_SPESA oggSp on rigaOrd.oggetti_spesa_id = oggSp.oggetti_spesa_id
 LEFT JOIN CPASS_T_LISTINO_FORNITORE lisForn on  rigaOrd.oggetti_spesa_id = lisForn.oggetti_spesa_id and tord.fornitore_id = lisForn.fornitore_id 
 join CPASS_D_UNITA_MISURA unita on  unita.unita_misura_id = rigaOrd.unita_misura_id
 join CPASS_T_UTENTE utente on tord.utente_compilatore_id = utente.utente_id
 left join CPASS_R_DIRIGENTE_SETTORE dirigente on sett.settore_id = dirigente.settore_id and dirigente.data_validita_fine is null
 left join CPASS_T_UTENTE utenteDir on dirigente.utente_id = utenteDir.utente_id
 join CPASS_D_ALIQUOTE_IVA iva on rigaOrd.aliquote_iva_id = iva.aliquote_iva_id
 left join cpass_r_ord_rda_ordine rordrda on tord.testata_ordine_id  = rordrda.testata_ordine_id
 left join cpass_t_ord_testata_rda rda on rordrda.testata_rda_id  = rda.testata_rda_id 
 join cpass_t_settore_indirizzo sett_dest_indir on  sett_dest_indir.settore_indirizzo_id = dest.settore_indirizzo_id
 where
     	 tord.testata_ordine_id = p_ordine_id::UUID
     ;
        
exception
	when no_data_found THEN
		raise notice 'Nessun dato trovato per l''ordine';
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

CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_rep_ordini_dest (
  p_destinatario_id varchar
)
RETURNS TABLE (
  ordine_anno integer,
  ordine_numero integer,
  ordine_data_emis timestamp,
  ordine_consegna_da timestamp,
  ordine_consegna_a timestamp,
  ordine_num_procedura varchar,
  ordine_note varchar,
  ordine_provv_numero varchar,
  ordine_provv_anno integer,
  ordine_cons_rif varchar,
  ordine_consegna_indirizzo varchar,
  ordine_consegna_cap varchar,
  ordine_consegna_localita varchar,
  ordine_tipo_doc varchar,
  ordine_tipo_proc varchar,
  ufficio_codice varchar,
  settore_codice varchar,
  settore_descrizione varchar,
  settore_indirizzo varchar,
  settore_num_civico varchar,
  settore_cap varchar,
  settore_localita varchar,
  settore_provincia varchar,
  rda_anno integer,
  rda_numero integer,
  ente_codice_fiscale varchar,
  forn_ragione_sociale varchar,
  forn_indirizzo varchar,
  forn_numero_civico varchar,
  forn_cap varchar,
  forn_comune varchar,
  forn_provincia varchar,
  forn_codice varchar,
  settdest_codice varchar,
  settdest_descrizione varchar,
  dest_indirizzo varchar,
  dest_num_civico varchar,
  dest_cap varchar,
  dest_localita varchar,
  dest_provincia varchar,
  dest_contatto varchar,
  dest_email varchar,
  dest_telefono varchar,
  ogg_descrizione varchar,
  ogg_codice varchar,
  codifica_listino_fornitore varchar,
  unita varchar,
  ordine_quantita numeric,
  ordine_percent_sconto numeric,
  ordine_percent_sconto2 numeric,
  aliquota_iva varchar,
  ordine_prezzo_unitario numeric,
  ordine_importo_totale numeric,
  ordine_importo_sconto numeric,
  ordine_importo_sconto2 numeric,
  ordine_importo_netto numeric,
  ordine_importo_iva numeric,
  rigaordine_note varchar,
  ordine_consegna_parziale boolean,
  utente_nome varchar,
  utente_cognome varchar,
  utente_telefono varchar,
  dirigente_nome varchar,
  dirigente_cognome varchar,
  anno_protocollo integer,
  numero_protocollo varchar
) AS
$body$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query
select tord.ordine_anno,
       tord.ordine_numero,
       tord.data_emissione,
       tord.consegna_data_da,
       tord.consegna_data_a,
       tord.numero_procedura,        
       tord.note ,
       tord.provvedimento_numero ,
       tord.provvedimento_anno ,
       tord.consegna_riferimento ,
       tord.consegna_indirizzo  ,
       tord.consegna_cap   ,
       tord.consegna_localita ,
       tipoOrd.tipologia_documento_descrizione ,
       tipoProc.tipo_procedura_descrizione ,
       uff.ufficio_codice , 
       sett.settore_codice ,
       sett.settore_descrizione , 
       indirizzo_sett.indirizzo ,
       indirizzo_sett.num_civico ,
       indirizzo_sett.cap ,
       indirizzo_sett.localita ,
       indirizzo_sett.provincia ,
       testata_rms.rms_anno rda_anno,
       testata_rms.rms_numero rda_numero, 
       ente.ente_codice_fiscale ,
       forn.ragione_sociale ,
       forn.indirizzo ,
       forn.numero_civico ,
       forn.cap ,
       forn.comune ,
       forn.provincia ,
       forn.codice ,
       settDest.settore_codice ,
       sett_dest_indir.descrizione , 
       destinatario_ordine.indirizzo ,
       destinatario_ordine.num_civico ,
       destinatario_ordine.cap ,
       destinatario_ordine.localita ,
       destinatario_ordine.provincia ,
       destinatario_ordine.contatto ,
       destinatario_ordine.email ,
       destinatario_ordine.telefono ,
       oggSp.oggetti_spesa_descrizione ,
       oggSp.oggetti_spesa_codice ,
       lisForn.listino_fornitore_codice_ods ,
       unita.unita_misura_descrizione ,
       rigaOrd.quantita ,
       rigaOrd.percentuale_sconto ,
       rigaOrd.percentuale_sconto2 ,
       iva.aliquote_iva_codice ,
       rigaOrd.prezzo_unitario ,
       rigaOrd.importo_totale ,
       rigaOrd.importo_sconto , 
       rigaOrd.importo_sconto2 ,
       rigaOrd.importo_netto ,
       rigaOrd.importo_iva  , 
       rigaOrd.note ,
       rigaOrd.consegna_parziale ,
       utente.utente_nome ,
       utente.utente_cognome ,
       utente.telefono ,
       utenteDir.utente_nome,
       utenteDir.utente_cognome,
       protocollo.anno_protocollo ,
       protocollo.numero_protocollo
from   CPASS_T_ORD_TESTATA_ORDINE tord
 join  CPASS_D_ORD_TIPO_ORDINE tipoOrd on tord.tipo_ordine_id = tipoOrd.tipo_ordine_id
 join  CPASS_D_ORD_TIPO_PROCEDURA tipoProc on tord.tipo_procedura_id = tipoProc.tipo_procedura_id
 join  CPASS_T_UFFICIO uff on tord.ufficio_id = uff.ufficio_id
 join  CPASS_T_SETTORE sett on tord.settore_emittente_id = sett.settore_id
 join  cpass_t_settore_indirizzo indirizzo_sett on sett.settore_id = indirizzo_sett.settore_id and indirizzo_sett.principale = true
 join  CPASS_T_ENTE ente on ente.ente_id = sett.ente_id
 join  CPASS_T_FORNITORE forn on tord.fornitore_id = forn.fornitore_id
 left join  cpass_t_ord_destinatario_ordine destinatario_ordine on  tord.testata_ordine_id = destinatario_ordine.testata_ordine_id
 left join  cpass_t_settore settDest on destinatario_ordine.settore_destinatario_id = settDest.settore_id
 left join  cpass_t_ord_riga_ordine rigaOrd on destinatario_ordine.destinatario_id = rigaOrd.destinatario_id
 left join  cpass_d_oggetti_spesa oggSp on rigaOrd.oggetti_spesa_id = oggSp.oggetti_spesa_id
 LEFT JOIN cpass_t_listino_fornitore lisForn on  rigaOrd.oggetti_spesa_id = lisForn.oggetti_spesa_id and tord.fornitore_id = lisForn.fornitore_id 
 left join cpass_d_unita_misura unita on  unita.unita_misura_id = rigaOrd.unita_misura_id
 left join cpass_t_utente utente on tord.utente_compilatore_id = utente.utente_id
 left join cpass_r_dirigente_settore dirigente on sett.settore_id = dirigente.settore_id and dirigente.data_validita_fine is null
 left join cpass_t_utente utenteDir on dirigente.utente_id = utenteDir.utente_id
 left join cpass_d_aliquote_iva iva on rigaOrd.aliquote_iva_id = iva.aliquote_iva_id
 left join cpass_r_ord_rda_ordine rordrda on destinatario_ordine.testata_ordine_id = rordrda.testata_ordine_id                                               
 left join cpass_t_ord_testata_rda rda on rordrda.testata_rda_id = rda.testata_rda_id
 left join cpass_t_ord_riga_rda riga_rda on rda.testata_rda_id = riga_rda.testata_rda_id 
 left join cpass_t_rms_riga_rms riga_rms on riga_rda.riga_rda_id = riga_rms.riga_rda_id
 left join cpass_t_rms_testata_rms testata_rms on riga_rms.testata_rms_id = testata_rms.testata_rms_id                                                                                                    
 left join cpass_t_rms_testata_rms testata_rms2 on destinatario_ordine.settore_destinatario_id = testata_rms2.settore_destinatario_id                                                                                                 
 left join cpass_t_ord_protocollo_ordine protocollo on tord.testata_ordine_id = protocollo.testata_ordine_id 
 join cpass_t_settore_indirizzo sett_dest_indir on  sett_dest_indir.settore_indirizzo_id = destinatario_ordine.settore_indirizzo_id
 where
    	 destinatario_ordine.destinatario_id= p_destinatario_id::UUID
       and ((testata_rms.testata_rms_id = testata_rms2.testata_rms_id and  testata_rms.testata_rms_id is not null )  or testata_rms.testata_rms_id is  null)    
                  ;
        
exception
	when no_data_found THEN
		raise notice 'Nessun dato trovato per l''ordine';
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

INSERT INTO cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.tipo
FROM (VALUES
  ('IN_FIRMA' , 'IN_FIRMA', 'ORDINE')
) AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato ds
  WHERE ds.stato_codice = tmp.codice
);

delete from cpass_r_ruolo_permesso
where permesso_id in (select permesso_id from cpass_d_permesso where permesso_codice='PRENDI_IN_CARICO_INTERVENTO')
and ruolo_id not in (select ruolo_id from cpass_d_ruolo where ruolo_codice in ('ADMIN','RUP'));

delete from cpass_r_ruolo_permesso
where permesso_id in (select permesso_id from cpass_d_permesso where permesso_codice='ALIMENTAZIONE_DA_FONTE_ESTERNA')
and ruolo_id not in (select ruolo_id from cpass_d_ruolo where ruolo_codice in ('ADMIN','REFP','DELEGATO_REFP'));

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('ADMIN','PRENDI_IN_CARICO_INTERVENTO'),
	('RUP','PRENDI_IN_CARICO_INTERVENTO'),
	('ADMIN','ALIMENTAZIONE_DA_FONTE_ESTERNA'),
	('REFP','ALIMENTAZIONE_DA_FONTE_ESTERNA'),
	('DELEGATO_REFP','ALIMENTAZIONE_DA_FONTE_ESTERNA')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_PROTOCOLLO_ORDINE add column if not exists id_classificazione_value varchar(500);

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_interventi_risorse (
  p_programma_id varchar,
  p_cup varchar,
  p_settore_interventi varchar,
  p_struttura_id varchar,
  p_cpv_id varchar,
  p_cognome varchar,
  p_descri varchar,
  p_acq_non_rip varchar,
  p_vers_defin varchar,
  p_visto_rag varchar,
  p_elem_dipend varchar,
  p_order varchar
)
RETURNS TABLE (
  id_allegato_scheda integer,
  intervento_cui varchar,
  intervento_anno_avvio integer,
  intervento_cup varchar,
  intervento_ricompreso_cui varchar,
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
  settore_descrizione varchar,
  motivazione_non_riproposto varchar,
  codice_interno varchar,
  note varchar,
  fondi_pnrr boolean,
  avviato boolean,
  data_avvio timestamp,
  utente_avvio_nome varchar,
  utente_avvio_cognome varchar,
  versione_definitiva boolean,
  visto_ragioneria boolean,
  data_visto_ragioneria timestamp,
  utente_visto_nome varchar,
  utente_visto_cognome varchar,
  cui_lotto_riferimento varchar
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
        ,intervento.intervento_ricompreso_cui
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
        ,altri_dati.codice_interno
        ,altri_dati.note
        ,altri_dati.fondi_pnrr
        ,intervento.avviato 
        ,intervento.data_avviato
        ,utente_avvio.utente_nome
        ,utente_avvio.utente_cognome
        ,intervento.versione_definitiva
        ,intervento.visto_ragioneria
        ,intervento.data_visto_ragioneria
        ,utente_visto.utente_nome
        ,utente_visto.utente_cognome
        ,interv_capo_fila.intervento_cui
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
       LEFT JOIN CPASS_T_PBA_INTERVENTO_ALTRI_DATI ALTRI_DATI ON intervento.intervento_id = ALTRI_DATI.intervento_id
       LEFT JOIN cpass_t_utente utente_avvio ON intervento.utente_avviato_id = utente_avvio.utente_id       
       LEFT JOIN cpass_t_utente utente_visto ON intervento.utente_visto_ragioneria_id = utente_visto.utente_id       
       LEFT JOIN cpass_t_pba_intervento interv_capo_fila on intervento.intervento_capofila_id = interv_capo_fila.intervento_id
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

    /*ANNA 23/09/2022 Modificata la condizione sulla struttura*/
    if p_struttura_id <>  'null' AND p_struttura_id <> '' and p_struttura_id IS NOT NULL  
    and (p_elem_dipend = 'false' or p_elem_dipend is null or p_elem_dipend = '' or p_elem_dipend ='null')
    then      
       stringa_sql := stringa_sql || ' and intervento.settore_id = $4::UUID '; 
     end if;
     
	 /*ANNA-ANTONINO 04/10/2022 gestiamo gli elementi dipendenti*/
	 if p_struttura_id <>  'null' AND p_struttura_id <> '' and p_struttura_id IS NOT NULL  and p_elem_dipend is NOT null then      
       stringa_sql := stringa_sql || ' and intervento.settore_id in
			(WITH RECURSIVE elementiDipendenti AS (
         SELECT 1 AS livello,
            NULL::uuid AS settore_id_padre,'' '' as cod_precedente,
            s.settore_id,
            s.settore_codice,
            s.settore_descrizione,
            s.ente_id,
            ts.tipo_settore_id,
            ts.posizione ,
            ts.flag_utilizzabile
           FROM cpass_t_settore s,
            cpass_d_tipo_settore ts
          WHERE s.settore_padre_id =$4::UUID 
		  --AND (s.data_cancellazione IS NULL OR s.data_cancellazione IS NOT --NULL AND date_trunc(''day''::text, s.data_cancellazione) > --date_trunc(''day''::text, now())) 
		  AND s.tipo_settore_id = ts.tipo_settore_id
		UNION ALL
         SELECT mtree.livello + 1,
            mtree.settore_id AS settore_id_padre,            
            mtree.cod_precedente||''.''||s_figlio.settore_codice cod_precedente ,
            s_figlio.settore_id,
            s_figlio.settore_codice,
            s_figlio.settore_descrizione,
            s_figlio.ente_id,
            ts.tipo_settore_id,
            ts.posizione,
            ts.flag_utilizzabile
           FROM cpass_t_settore s_figlio
             inner JOIN elementiDipendenti mtree ON mtree.settore_id = s_figlio.settore_padre_id
             JOIN cpass_d_tipo_settore ts ON s_figlio.tipo_settore_id = ts.tipo_settore_id
          --WHERE s_figlio.data_cancellazione IS NULL OR --s_figlio.data_cancellazione IS NOT NULL AND --date_trunc(''day''::text, s_figlio.data_cancellazione) > --date_trunc(''day''::text, now())
        )
 SELECT 
    elementiDipendenti.settore_id
   FROM elementiDipendenti
    left JOIN cpass_t_settore dec_padre ON elementiDipendenti.settore_id_padre = dec_padre.settore_id
	union
	SELECT 
        s.settore_id
    FROM cpass_t_settore s          
    WHERE s.settore_id =$4::UUID)'; 
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
    
	 if p_acq_non_rip <> 'null' and p_acq_non_rip <> '' and p_acq_non_rip is not null and upper(p_acq_non_rip) = 'ACQ_NON_RIP' then 
       stringa_sql := stringa_sql || ' and intervento.motivazione_non_riproposto IS NOT NULL ';         
	 end if;
	
	 if p_acq_non_rip <> 'null' and p_acq_non_rip <> '' and p_acq_non_rip is not null and upper(p_acq_non_rip) = 'ACQ_ATTIVI' then 
       stringa_sql := stringa_sql || ' and intervento.motivazione_non_riproposto IS NULL ';         
	 end if;
	
	/*ANNA 23/09/2022 aggiunti questi parametri*/
    
	 if p_vers_defin <> 'null' and p_vers_defin <> '' and p_vers_defin is not null 
	 and (upper(p_vers_defin) = 'NO' or p_vers_defin = 'false') then 
       stringa_sql := stringa_sql || ' and intervento.versione_definitiva = false';         
	 end if;
	
	 if p_vers_defin <> 'null' and p_vers_defin <> '' and p_vers_defin is not null and 
	 (upper(p_vers_defin) = 'SI' or p_vers_defin = 'true') then 
       stringa_sql := stringa_sql || ' and intervento.versione_definitiva = true';         
	 end if;
	
	if p_visto_rag <> 'null' and p_visto_rag <> '' and p_visto_rag is not null 
	and (upper(p_visto_rag) = 'NO' or p_visto_rag = 'false') then 
       stringa_sql := stringa_sql || ' and intervento.visto_ragioneria = false';         
	 end if;
	
	 if p_visto_rag <> 'null' and p_visto_rag <> '' and p_visto_rag is not null and 
	 (upper(p_visto_rag) = 'SI' or p_visto_rag = 'true') then 
       stringa_sql := stringa_sql || ' and intervento.visto_ragioneria = true';         
	 end if;
     
     /*ANNA 23/09/2022*/
	
	
	
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
  p_order,
  p_acq_non_rip
 ;

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
---------------------------------------------------------
select * from cpass_t_parametro_stampa
where nome_stampa = 'STAMPA_INTERVENTI'
order by ordinamento;

delete from cpass_t_parametro_stampa
where nome_stampa = 'STAMPA_INTERVENTI'
and ordinamento >= 9;


INSERT INTO cpass.cpass_t_parametro_stampa (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
SELECT tmp.modulo, tmp.nome_stampa, tmp.file_name_template, tmp.parametro, tmp.parametro_tipo, tmp.ordinamento, tmp.procedure_utilizzate, NULL, tmp.formato_stampa
FROM (VALUES
  ('PBA','STAMPA_INTERVENTI','Stampa_acquisti.rptdesign','p_vers_defin','varchar', 9,'pck_cpass_pba_rep_interventi_risorse','xlsx'),
  ('PBA','STAMPA_INTERVENTI','Stampa_acquisti.rptdesign','p_visto_rag' ,'varchar',10,'pck_cpass_pba_rep_interventi_risorse','xlsx'),
  ('PBA','STAMPA_INTERVENTI','Stampa_acquisti.rptdesign','p_elem_dipend','varchar',11,'pck_cpass_pba_rep_interventi_risorse','xlsx'),
  ('PBA','STAMPA_INTERVENTI','Stampa_acquisti.rptdesign','p_order','varchar',12,'pck_cpass_pba_rep_interventi_risorse','xlsx')

) AS tmp (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, formato_stampa)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro_stampa current
  WHERE current.nome_stampa = tmp.nome_stampa
  AND current.parametro = tmp.parametro
);

ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_PROTOCOLLO_ORDINE add column if not exists id_classificazione_value varchar(500);

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_allegato_ii (
  p_programma_id varchar
)
RETURNS TABLE (
  id_allegato_scheda integer,
  intervento_cui varchar,
  intervento_anno_avvio integer,
  intervento_cup varchar,
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
  intervento_copia_tipo varchar,
  motivazione_non_riproposto varchar,
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
  cap_privati_importo_anno_primo numeric,
  cap_privati_importo_anno_secondo numeric,
  cap_privati_importo_anni_successivi numeric,
  cap_privati_totale_importi numeric,
  descrizione_risorsa varchar,
  tipologia varchar,
  importo_tutta_fila numeric,
  intervento_capofila_id varchar
) AS
$body$
DECLARE

v_valoresoglia integer;
RTN_MESSAGGIO text; 

BEGIN

	select t.valore 
into v_valoresoglia 
from  cpass_t_parametro t , 
      cpass_t_pba_programma p
where t.ente_id = p.ente_id 
and   p.programma_id = p_programma_id::UUID
and   t.chiave = 'SOGLIA_DI_NON_INVIO_MIT';

return query
WITH importi_capofila AS (
SELECT      --coalesce(int_1.intervento_capofila_id,null,int_1.intervento_id) intervento_capofila_id,
            int_1.intervento_capofila_id,
            programma_1.programma_id,
            sum(intimp.intervento_importi_importo_anno_primo + intimp.intervento_importi_importo_anno_secondo + intimp.intervento_importi_importo_anni_successivi) as totale_importi_fila
FROM cpass_t_pba_intervento int_1
  JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id = intimp.intervento_id
  left JOIN cpass_t_pba_intervento_altri_dati importiva ON int_1.intervento_id = importiva.intervento_id     
  JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
  JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id = risorsa.risorsa_id  AND risorsa.risorsa_tipo::text != 'CAPITALE PRIVATO'::text
--where int_1.intervento_lotto_funzionale = true
   --  and int_1.capofila = true
  GROUP BY int_1.intervento_capofila_id, programma_1.programma_id),
importi AS (
SELECT      int_1.intervento_id,
            programma_1.programma_id,
            sum(intimp.intervento_importi_importo_anno_primo)      AS importo_anno_primo,
            sum(intimp.intervento_importi_importo_anno_secondo)    AS importo_anno_secondo,
            sum(intimp.intervento_importi_importo_anni_successivi) AS importo_anni_successivi,
            sum(intimp.intervento_importi_importo_anno_primo +
                intimp.intervento_importi_importo_anno_secondo +
                intimp.intervento_importi_importo_anni_successivi) AS totale_importi
FROM cpass_t_pba_intervento int_1
             JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id =  intimp.intervento_id
             JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id =  programma_1.programma_id
            JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id =  risorsa.risorsa_id AND risorsa.risorsa_tipo::text = 'BILANCIO'::text
 GROUP BY int_1.intervento_id, programma_1.programma_id),
importi_cap_privati AS (
     SELECT int_1.intervento_id,
            programma_1.programma_id,
            risorsa.risorsa_id,
            sum(intimp.intervento_importi_importo_anno_primo)      AS cap_privati_importo_anno_primo,
            sum(intimp.intervento_importi_importo_anno_secondo)    AS cap_privati_importo_anno_secondo,
            sum(intimp.intervento_importi_importo_anni_successivi) AS cap_privati_importo_anni_successivi,
            sum(intimp.intervento_importi_importo_anno_primo +
                intimp.intervento_importi_importo_anno_secondo +
                intimp.intervento_importi_importo_anni_successivi) AS cap_privati_totale_importi
    FROM cpass_t_pba_intervento int_1
             JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id =   intimp.intervento_id
             JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id =     programma_1.programma_id
             JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id =  risorsa.risorsa_id AND risorsa.risorsa_tipo::text = 'CAPITALE PRIVATO'::text
    GROUP BY int_1.intervento_id, programma_1.programma_id, risorsa.risorsa_id
    )
    select distinct
    	--row_number() OVER ()::INTEGER AS id_allegato_scheda
        0 AS id_allegato_scheda
        ,"int".intervento_cui
        ,"int".intervento_anno_avvio
        ,"int".intervento_cup
        ,rt.ricompreso_tipo_codice
        ,"int".intervento_ricompreso_cui    --rt.ricompreso_tipo_descrizione
        ,"int".intervento_lotto_funzionale
        ,nuts.nuts_codice
        ,nuts.nuts_descrizione
        ,si.settore_interventi_codice
        ,si.settore_interventi_descrizione
        ,cpv.cpv_codice
        ,cpv.cpv_descrizione
        ,"int".intervento_descrizione_acquisto
        ,priorita.priorita_codice
        ,priorita.priorita_descrizione
        ,ute.utente_nome
        ,ute.utente_cognome
        ,ute.utente_codice_fiscale
        ,"int".intervento_durata_mesi
        ,"int".intervento_nuovo_affid
        ,"int".intervento_copia_tipo
        ,"int".motivazione_non_riproposto
        ,ausa.ausa_codice AS ausa
        ,ausa.ausa_descrizione
        ,av.acquisto_variato_codice
        ,av.acquisto_variato_descrizione
        ,programma.programma_id
        ,programma.programma_anno
        --,programma.programma_referente
        ,ente.ente_id
        ,ente.ente_codice_fiscale
        ,ente.ente_denominazione
        ,importi.importo_anno_primo importo_anno_primo
        ,importi.importo_anno_secondo importo_anno_secondo
        ,importi.importo_anni_successivi  importo_anni_successivi
        ,importi.totale_importi totale_importi
        ,importi_cap_privati.cap_privati_importo_anno_primo cap_privati_importo_anno_primo
        ,importi_cap_privati.cap_privati_importo_anno_secondo cap_privati_importo_anno_secondo
        ,importi_cap_privati.cap_privati_importo_anni_successivi cap_privati_importo_anni_successivi
        ,importi_cap_privati.cap_privati_totale_importi cap_privati_totale_importi
        --,risorsa.risorsa_descrizione descrizione_risorsa
        ,''::character varying descrizione_risorsa
        ,risorsa.risorsa_tipo tipologia --        ,'CAPITALE PRIVATO'::character varying AS tipologia
        ,importi_capofila.totale_importi_fila totale_importi_fila
        ,"int".intervento_capofila_id::varchar
    FROM cpass_t_pba_intervento "int"
       JOIN cpass_d_stato stato ON "int".stato_id = stato.stato_id and stato.stato_tipo = 'INTERVENTO' AND stato.stato_codice <>'CANCELLATO'
       JOIN cpass_d_pba_nuts nuts ON "int".nuts_id = nuts.nuts_id
       JOIN cpass_d_pba_priorita priorita ON "int".priorita_id = priorita.priorita_id
       JOIN cpass_d_pba_settore_interventi si ON "int".settore_interventi_id = si.settore_interventi_id
       JOIN cpass_d_cpv cpv ON "int".cpv_id = cpv.cpv_id
       JOIN cpass_t_utente ute ON "int".utente_rup_id = ute.utente_id
       LEFT JOIN cpass_d_pba_acquisto_variato av ON "int".acquisto_variato_id =av.acquisto_variato_id
       LEFT JOIN cpass_d_pba_ricompreso_tipo rt ON "int".ricompreso_tipo_id = rt.ricompreso_tipo_id
       LEFT JOIN cpass_d_pba_ausa ausa ON "int".ausa_id = ausa.ausa_id
       JOIN cpass_t_pba_programma programma ON "int".programma_id = programma.programma_id
       JOIN cpass_t_ente ente ON ente.ente_id = programma.ente_id
       JOIN importi ON "int".programma_id = importi.programma_id AND "int".intervento_id = importi.intervento_id
       LEFT JOIN importi_cap_privati ON "int".programma_id = importi_cap_privati.programma_id AND "int".intervento_id = importi_cap_privati.intervento_id
       LEFT JOIN cpass_d_pba_risorsa risorsa ON risorsa.risorsa_id =  importi_cap_privati.risorsa_id and importi_cap_privati.cap_privati_totale_importi > 0
       left JOIN importi_capofila  ON "int".programma_id = importi_capofila.programma_id AND "int".intervento_capofila_id = importi_capofila.intervento_capofila_id 
     where
     	programma.programma_id = p_programma_id::UUID
     	--and ("int".intervento_copia_tipo != 'ACQ_NON_RIPROPOSTO' or "int".intervento_copia_tipo is null)
     and (("int".intervento_capofila_id is null and ((importi.totale_importi) >= v_valoresoglia)) or
          ("int".intervento_capofila_id is not null and (importi_capofila.totale_importi_fila >= v_valoresoglia))
         )	 
        	 
     ;


exception
	when no_data_found THEN
		raise notice 'Nessun dato trovato';
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


CREATE OR REPLACE FUNCTION cpass.pck_pass_pba_rep_allegato_ii_schedaa (
  p_programma_id varchar
)
RETURNS TABLE (
  risorsa varchar,
  tipologia varchar,
  denominazione varchar,
  programma_anno integer,
  referente varchar,
  importo_primo_anno numeric,
  importo_secondo_anno numeric,
  importo_totale_anni numeric
) AS
$body$
DECLARE

RTN_MESSAGGIO text; 
v_valoresoglia integer;

BEGIN

select t.valore 
into v_valoresoglia 
from  cpass_t_parametro t , 
      cpass_t_pba_programma p
where t.ente_id = p.ente_id 
and   p.programma_id = p_programma_id::UUID
and   t.chiave = 'SOGLIA_DI_NON_INVIO_MIT';
		
	
return query


with risorse as (select int.intervento_id, 
						int.intervento_cui, 
                  r.risorsa_codice risorsa,
                      REPLACE (r.risorsa_descrizione,'*',' ')::character varying tipologia,
                      ente.ente_denominazione denominazione,
                      p.programma_anno programma_anno,
                      CAST(ut.utente_cognome || ' '  || ut.utente_nome as Varchar )  referente,
                         sum(imp.intervento_importi_importo_anno_primo) Importo_Primo_Anno,  
                         sum(imp.intervento_importi_importo_anno_secondo) Importo_Secondo_Anno,
                         sum(imp.intervento_importi_importo_anno_primo) +  
                         sum(imp.intervento_importi_importo_anno_secondo) Importo_Totale_Anni
                  from cpass_d_pba_risorsa r, 
                       cpass_t_pba_intervento int, 
                       cpass_t_pba_intervento_importi imp, 
                       cpass_t_pba_programma p,  
                       cpass_t_ente ente,
                       cpass_t_utente ut,
                       cpass_d_pba_ricompreso_tipo dr,
                       cpass_d_stato stato
                  where p.programma_id = p_programma_id::UUID
                   and  ente.ente_id = p.ente_id
                   and  r.risorsa_id = imp.risorsa_id
                   and  r.risorsa_tipo = 'BILANCIO'
                   and  p.programma_id = int.programma_id
                   and  imp.intervento_id = int.intervento_id
                   and  imp.risorsa_id = r.risorsa_id
                   and  p.utente_referente_id = ut.utente_id
                   and  dr.ricompreso_tipo_conteggio_importi = 'true'
                   and  dr.ricompreso_tipo_id= int.ricompreso_tipo_id
                   and int.motivazione_non_riproposto is null
                   and int.stato_id = stato.stato_id 
                   and stato.stato_tipo = 'INTERVENTO' 
                   AND stato.stato_codice <>'CANCELLATO'
                   --and int.intervento_lotto_funzionale = false
                   and int.intervento_capofila_id is null 
                   group by 
                   int.intervento_id,
                   int.intervento_cui,
                   r.risorsa_codice,
                   ente.ente_denominazione,r.risorsa_descrizione,
                   p.programma_anno,
                   ut.utente_cognome, ut.utente_nome
                  union
                  select  int.intervento_id,
                  int.intervento_cui,r.risorsa_codice risorsa,
                      REPLACE (r.risorsa_descrizione,'*',' ')::character varying tipologia,
                      ente.ente_denominazione denominazione,
                      p.programma_anno programma_anno,
                      CAST(ut.utente_cognome || ' '  || ut.utente_nome as Varchar )  referente,
                         sum(imp.intervento_importi_importo_anno_primo) Importo_Primo_Anno,  
                         sum(imp.intervento_importi_importo_anno_secondo) Importo_Secondo_Anno,
                         sum(imp.intervento_importi_importo_anno_primo) +  
                         sum(imp.intervento_importi_importo_anno_secondo) Importo_Totale_Anni
                  from cpass_d_pba_risorsa r, 
                       cpass_t_pba_intervento int, 
                       cpass_t_pba_intervento_importi imp, 
                       cpass_t_pba_programma p,  
                       cpass_t_ente ente,
                       cpass_t_utente ut,
                       cpass_d_pba_ricompreso_tipo dr,
                       cpass_d_stato stato
                  where p.programma_id = p_programma_id::UUID
                   and  ente.ente_id = p.ente_id
                   and  r.risorsa_id = imp.risorsa_id
                   and  r.risorsa_tipo = 'BILANCIO'
                   and  p.programma_id = int.programma_id
                   and  imp.intervento_id = int.intervento_id
                   and  imp.risorsa_id = r.risorsa_id
                   and  p.utente_referente_id = ut.utente_id
                   and  dr.ricompreso_tipo_conteggio_importi = 'true'
                   and  dr.ricompreso_tipo_id= int.ricompreso_tipo_id
                   and int.motivazione_non_riproposto is null
                   and int.stato_id = stato.stato_id 
                   and stato.stato_tipo = 'INTERVENTO' 
                   AND stato.stato_codice <>'CANCELLATO'
                   --and int.intervento_lotto_funzionale = true  
                   and int.intervento_capofila_id is not null
                   group by int.intervento_id,
                   int.intervento_cui,r.risorsa_codice , 
                         r.risorsa_descrizione , 
                         ente.ente_denominazione,
                         p.programma_anno,
                         ut.utente_cognome,
                         ut.utente_nome
),
 controllo_importo_nocap as 
(select  importi.intervento_id,
       sum(importi.intervento_importi_importo_anno_primo) +
       sum(importi.intervento_importi_importo_anno_secondo) +
       sum(importi.intervento_importi_importo_anni_successivi) 
from cpass_t_pba_intervento_importi importi,
     cpass_t_pba_intervento int3
where  importi.intervento_id = int3.intervento_id
and    int3.programma_id = p_programma_id::UUID
group by importi.intervento_id
having    sum(importi.intervento_importi_importo_anno_primo) +
       sum(importi.intervento_importi_importo_anno_secondo) +
       sum(importi.intervento_importi_importo_anni_successivi) >= v_valoresoglia
),
 controllo_importo_cap as 
(select  importi.intervento_id,
       sum(importi.intervento_importi_importo_anno_primo) +
       sum(importi.intervento_importi_importo_anno_secondo) +
       sum(importi.intervento_importi_importo_anni_successivi) 
from cpass_t_pba_intervento_importi importi,
     cpass_t_pba_intervento int4,
	 cpass_t_pba_intervento int5
where  importi.intervento_id = int4.intervento_id
and   int4.intervento_capofila_id = int5.intervento_id
and   int5.programma_id = p_programma_id::UUID
group by importi.intervento_id
having    sum(importi.intervento_importi_importo_anno_primo) +
       sum(importi.intervento_importi_importo_anno_secondo) +
       sum(importi.intervento_importi_importo_anni_successivi) >=v_valoresoglia
)
select 
  risorse.risorsa,
  risorse.tipologia,
  risorse.denominazione,
  risorse.programma_anno,
  risorse.referente,
  sum(risorse.Importo_Primo_Anno),
  sum(risorse.Importo_Secondo_Anno),
  sum(risorse.Importo_Totale_Anni)
from risorse
join controllo_importo_nocap on (risorse.intervento_id = controllo_importo_nocap.intervento_id)
left join controllo_importo_cap on (risorse.intervento_id = controllo_importo_cap.intervento_id)
group by 
  risorse.risorsa,
  risorse.tipologia,
  risorse.denominazione,
  risorse.programma_anno,
  risorse.referente	   
order by 1

;


exception
	when no_data_found THEN
		raise notice 'Nessun dato trovato';
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
