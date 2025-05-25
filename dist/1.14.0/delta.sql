---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================

-- NUOVO SVILUPPO STILO

alter table IF EXISTS  appoggio_testata_ordine add column if not exists id serial;
alter table IF EXISTS  appoggio_testata_ordine add column if not exists esito VARCHAR(2);

alter table IF EXISTS  appoggio_ordine_righe_dest add column if not exists esito VARCHAR(2);
alter table IF EXISTS  appoggio_ordine_righe_dest add column if not exists  esito_righe VARCHAR(2);
alter table IF EXISTS  appoggio_ordine_righe_dest add column if not exists id serial;

alter table IF EXISTS  appoggio_ord_impegno_subimpegno add column if not exists id serial;
alter table IF EXISTS  appoggio_ord_impegno_subimpegno add column if not exists esito VARCHAR(2);
alter table IF EXISTS  appoggio_ord_impegno_subimpegno add column if not exists esito_sub VARCHAR(2);

alter table IF EXISTS appoggio_impegno add column if not exists id serial;
alter table IF EXISTS  appoggio_impegno add column if not exists esito VARCHAR(2);

alter table IF EXISTS  appoggio_subimpegno add column if not exists id serial;
alter table IF EXISTS  appoggio_subimpegno add column if not exists esito VARCHAR(2);

alter table IF EXISTS  appoggio_testata_evasione add column if not exists id serial;
alter table IF EXISTS  appoggio_testata_evasione add column if not exists esito VARCHAR(2);

alter table IF EXISTS  appoggio_righe_dest_evasione add column if not exists esito VARCHAR(2);
alter table IF EXISTS  appoggio_righe_dest_evasione add column if not exists  esito_righe VARCHAR(2);
alter table IF EXISTS  appoggio_righe_dest_evasione add column if not exists id serial;

alter table IF EXISTS  appoggio_impegni_evasione add column if not exists esito VARCHAR(2);
alter table IF EXISTS  appoggio_impegni_evasione add column if not exists id serial;

alter table IF EXISTS  appoggio_submpegni_evasione add column if not exists esito VARCHAR(2);
alter table IF EXISTS  appoggio_submpegni_evasione add column if not exists id serial;

ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati add column if not exists motivi_esclusione_id INTEGER;		
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati DROP CONSTRAINT IF EXISTS fk_cpass_t_pba_intervento_altri_dati_motivi_esclusione_cig;
ALTER TABLE IF EXISTS cpass.cpass_t_pba_intervento_altri_dati ADD CONSTRAINT fk_cpass_t_pba_intervento_altri_dati_motivi_esclusione_cig FOREIGN KEY (motivi_esclusione_id)
REFERENCES cpass.cpass_d_motivi_esclusione_cig(motivi_esclusione_id);

INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box, permesso_voce_menu, permesso_tipo, disattivabile, attivo)
SELECT tmp.permesso_codice, tmp.permesso_descrizione, tmp.permesso_titolo_box, tmp.permesso_voce_menu, tmp.permesso_tipo, tmp.disattivabile, tmp.attivo
FROM (VALUES
  ('CARICA_INTERVENTI_ANNI_PREC_V2','voce di menu carica interventi anni precedenti v.2','INTERVENTI',true,'V', true, true)
) AS tmp(permesso_codice, permesso_descrizione, permesso_titolo_box, permesso_voce_menu, permesso_tipo,disattivabile, attivo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_permesso current
  WHERE current.permesso_codice = tmp.permesso_codice
);

ALTER TABLE IF EXISTS cpass.cpass_d_aoo_acta add column if not exists AOO_CODICE varchar(50);

ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_PROTOCOLLO_ORDINE add column if not exists STRUTTURA_AGGREGATIVA_OBJECT_ID varchar(500);

ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_PROTOCOLLO_ORDINE add column if not exists INDICE_CLASSIFICAZIONE_ESTESO varchar(500);

ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_PROTOCOLLO_ORDINE add column if not exists VOCE_TITOLARIO varchar(500);
ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_PROTOCOLLO_ORDINE add column if not exists NUMERO_FASCICOLO_DOSSIER varchar(500);

ALTER TABLE IF EXISTS cpass.cpass_d_aoo_acta add column if not exists AOO_CODICE varchar(50);
ALTER TABLE IF EXISTS cpass.CPASS_T_ORD_PROTOCOLLO_ORDINE add column if not exists AOO_DOSSIER varchar(50);


INSERT INTO cpass.cpass_d_ruolo(ruolo_codice, ruolo_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
	('GESTORE_UTENTI', 'GESTORE UTENTI')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_ruolo dr
	WHERE dr.ruolo_codice = tmp.codice
);

alter table cpass.CPASS_T_UTENTE drop column if exists rup;

INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo, disattivabile, attivo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo, tmp.disattivabile, tmp.attivo
FROM (VALUES
	('RICERCA_UTENTI','Ricerca e consulta l''utente','BO',true,'V', 'SI', true),
	('INS_UTENTE','Inserisce l''utente','BO',true,'V', 'SI', true)
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo, disattivabile, attivo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('GESTORE_UTENTI','RICERCA_UTENTI'),
	('GESTORE_UTENTI','INS_UTENTE'),
	('ADMIN','RICERCA_UTENTI'),
	('ADMIN','INS_UTENTE')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);


alter table IF EXISTS  cpass_d_ruolo  drop column if exists selezionabile_d_procedura ;

alter table IF EXISTS  cpass_d_ruolo  add column if not exists selezionabile_da_procedura VARCHAR(2) DEFAULT 'SI';


ALTER TABLE cpass.cpass_d_ruolo DROP CONSTRAINT if exists selezionabile_da_procedura_check ;
ALTER TABLE cpass.cpass_d_ruolo ADD CONSTRAINT selezionabile_da_procedura_check 
CHECK (selezionabile_da_procedura = 'SI' 
      OR selezionabile_da_procedura = 'NO'
);

update cpass_t_utente set utente_nome = upper(utente_nome),  utente_cognome = upper(utente_cognome);

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
       coalesce(tord.consegna_riferimento,'') ,
       coalesce(tord.consegna_indirizzo,'')  ,
	   coalesce(tord.consegna_cap,'')   ,
       coalesce(tord.consegna_localita,'') ,
       tipoOrd.tipologia_documento_descrizione ,
       tipoProc.tipo_procedura_descrizione ,
       uff.ufficio_codice , 
       sett.settore_codice ,
       sett.settore_descrizione , 
       coalesce(indirizzo_sett.indirizzo,'') ,
       coalesce(indirizzo_sett.num_civico,'') ,
       coalesce(indirizzo_sett.cap,'') ,
       coalesce(indirizzo_sett.localita,'') ,
       coalesce(indirizzo_sett.provincia,'') ,
       testata_rms.rms_anno rda_anno,
       testata_rms.rms_numero rda_numero, 
       ente.ente_codice_fiscale ,
       forn.ragione_sociale ,
       coalesce(forn.indirizzo ,''),
       coalesce(forn.numero_civico,'') ,
       coalesce(forn.cap,'') ,
       coalesce(forn.comune ,''),
       coalesce(forn.provincia,'') ,
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
       coalesce(tord.consegna_cap,'')   ,
       tord.consegna_localita ,
       tipoOrd.tipologia_documento_descrizione ,
       tipoProc.tipo_procedura_descrizione ,
       uff.ufficio_codice , 
       sett.settore_codice ,
       sett.settore_descrizione , 
       coalesce(indirizzo_sett.indirizzo,'') ,
       coalesce(indirizzo_sett.num_civico,'') ,
       coalesce(indirizzo_sett.cap,'') ,
       coalesce(indirizzo_sett.localita,'') ,
       coalesce(indirizzo_sett.provincia, '') ,
       rda.rda_anno,
       rda.rda_numero, 
       ente.ente_codice_fiscale ,
       forn.ragione_sociale ,
       coalesce(forn.indirizzo ,''),
       coalesce(forn.numero_civico ,''),
       coalesce(forn.cap,'') ,
       coalesce(forn.comune ,''),
       coalesce(forn.provincia, '') ,
       forn.codice ,
       settDest.settore_codice ,
       sett_dest_indir.descrizione, 
       dest.indirizzo ,
       dest.num_civico ,
       dest.cap ,
       dest.localita ,
       coalesce(dest.provincia,'') ,
       coalesce(dest.contatto,'') ,
       coalesce(dest.email,'') ,
       coalesce(dest.telefono,'') ,
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


UPDATE cpass.cpass_d_ruolo set selezionabile_da_procedura = 'NO' where ruolo_codice in ('ADMIN', 'ADMIN_ENTE');