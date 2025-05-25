---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================

ALTER TABLE IF EXISTS cpass.cpass_t_ord_testata_ordine ADD COLUMN IF NOT EXISTS data_invio_firma  TIMESTAMP WITHOUT TIME ZONE;

alter table cpass_t_rms_riga_rms add column if not exists motivo_evasione_manuale varchar(500);

ALTER TABLE cpass_t_scarico_mepa_testata
ALTER COLUMN note TYPE varchar(2000);

ALTER TABLE cpass_t_scarico_mepa_testata ALTER COLUMN note DROP NOT NULL;

ALTER TABLE cpass_t_scarico_mepa_riga
ALTER COLUMN orderline_note TYPE varchar(2000);

INSERT INTO cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.tipo
FROM (VALUES
  ('EVM' , 'EVASA MANUALMENTE', 'RIGA_RMS')
) AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato ds
  WHERE ds.stato_codice = tmp.codice
);

INSERT INTO cpass.cpass_d_elaborazione_tipo (elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
SELECT tmp.codice, tmp.descrizione, tmp.modulo
FROM (VALUES
  ('RIATTIVAZIONE_FUNZIONI_GESTIONE' , 'RIATTIVAZIONE_FUNZIONI_GESTIONE', 'BO')
) AS tmp(codice, descrizione, modulo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo ds
  WHERE ds.elaborazione_tipo_codice = tmp.codice
);

INSERT INTO cpass.cpass_d_elaborazione_tipo (elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
SELECT tmp.codice, tmp.descrizione, tmp.modulo
FROM (VALUES
  ('ANNULLA_ORDINI_CONFERMATI' , 'ANNULLA_ORDINI_CONFERMATI', 'BO')
) AS tmp(codice, descrizione, modulo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo ds
  WHERE ds.elaborazione_tipo_codice = tmp.codice
);

INSERT INTO cpass.cpass_d_elaborazione_tipo (elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
SELECT tmp.codice, tmp.descrizione, tmp.modulo
FROM (VALUES
  ('CANCELLA_ORDINI_BOZZA' , 'CANCELLA_ORDINI_BOZZA', 'BO')
) AS tmp(codice, descrizione, modulo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo ds
  WHERE ds.elaborazione_tipo_codice = tmp.codice
);

INSERT INTO cpass.cpass_d_elaborazione_tipo (elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
SELECT tmp.codice, tmp.descrizione, tmp.modulo
FROM (VALUES
  ('DISATTIVAZIONE_FUNZIONI_GESTIONE' , 'DISATTIVAZIONE_FUNZIONI_GESTIONE', 'BO')
) AS tmp(codice, descrizione, modulo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo ds
  WHERE ds.elaborazione_tipo_codice = tmp.codice
);

INSERT INTO cpass.cpass_d_elaborazione_tipo (elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
SELECT tmp.codice, tmp.descrizione, tmp.modulo
FROM (VALUES
  ('AGGIORNAMENTO_ODS' , 'AGGIORNAMENTO_ODS', 'BO')
) AS tmp(codice, descrizione, modulo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo ds
  WHERE ds.elaborazione_tipo_codice = tmp.codice
);


alter table cpass_t_scarico_mepa_testata alter column note DROP NOT NULL;

update cpass_t_ord_testata_ordine 
set data_invio_firma = data_modifica 
where stato_id = 93;


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
select 
		DISTINCT
		tord.ordine_anno,
       tord.ordine_numero,
       tord.data_emissione,
       tord.consegna_data_da,
       tord.consegna_data_a,
       tord.numero_procedura,        
       tord.note ,
       tord.provvedimento_numero ,
       tord.provvedimento_anno ,
       coalesce(tord.consegna_riferimento,'') ,
       coalesce(tord.consegna_indirizzo,'') ,
       coalesce(tord.consegna_cap,'')   ,
       coalesce(tord.consegna_localita,'') ,
       tipoOrd.tipologia_documento_descrizione ,
       tipoProc.tipo_procedura_descrizione ,
       coalesce(uff.ufficio_codice,'') , 
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
       coalesce(settDest.settore_codice ,''),
       coalesce(sett_dest_indir.descrizione,''), 
       coalesce(dest.indirizzo ,''),
       coalesce(dest.num_civico,'') ,
       coalesce(dest.cap ,''),
       coalesce(dest.localita ,''),
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
       coalesce(utente.telefono,'') ,
       utenteDir.utente_nome,
       utenteDir.utente_cognome
from   CPASS_T_ORD_TESTATA_ORDINE tord
 join  CPASS_D_ORD_TIPO_ORDINE tipoOrd on tord.tipo_ordine_id = tipoOrd.tipo_ordine_id
 join  CPASS_D_ORD_TIPO_PROCEDURA tipoProc on tord.tipo_procedura_id = tipoProc.tipo_procedura_id
 left join  CPASS_T_UFFICIO uff on tord.ufficio_id = uff.ufficio_id
 join  CPASS_T_SETTORE sett on tord.settore_emittente_id = sett.settore_id
 left join   cpass_t_settore_indirizzo indirizzo_sett on sett.settore_id = indirizzo_sett.settore_id and indirizzo_sett.principale = true
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
 left join cpass_t_settore_indirizzo sett_dest_indir on  sett_dest_indir.settore_indirizzo_id = dest.settore_indirizzo_id
 where
     	 tord.testata_ordine_id = p_ordine_id::UUID
and (
		(date_trunc('day',tord.data_creazione) 
		>= 
		date_trunc('day',indirizzo_sett.data_creazione) 
		and 
		date_trunc('day',tord.data_creazione)  < date_trunc('day',indirizzo_sett.data_cancellazione) 
		)
		or  
		(date_trunc('day',tord.data_creazione) >= 
		 date_trunc('day',indirizzo_sett.data_creazione) 
		 and indirizzo_sett.data_cancellazione is null 
		 )
		)    ;
        
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