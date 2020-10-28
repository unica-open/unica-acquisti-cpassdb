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
INSERT INTO cpass_r_ruolo_modulo (ruolo_id, modulo_id)
SELECT dr.ruolo_id, dm.modulo_id
FROM (VALUES
	('INTERRORD', 'ORD'),
	('ORDINATORE', 'ORD'),
	('ORDINSEMPLICE', 'ORD'),
	('RUP', 'ORD'),
	('TRASM_NSO', 'ORD')
) AS tmp(ruolo, modulo)
JOIN cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass_d_modulo dm ON dm.modulo_codice = tmp.modulo
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_r_ruolo_modulo rrm
	WHERE rrm.ruolo_id = dr.ruolo_id
	AND rrm.modulo_id = dm.modulo_id
);


CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_ordini(p_ordine_id character varying)
 RETURNS TABLE(ordine_anno integer, 
               ordine_numero integer, 
               ordine_consegna_da timestamp, 
               ordine_consegna_a timestamp, 
               ordine_num_procedura character varying, 
               ordine_note character varying,
               ordine_provv_numero character varying,
               ordine_provv_anno integer,
               ordine_cons_rif character varying,
               ordine_consegna_indirizzo character varying,
               ordine_consegna_cap character varying,
               ordine_consegna_localita character varying,
               ordine_tipo_doc character varying,
               ordine_tipo_proc character varying,
               ufficio_codice character varying ,
               settore_codice character varying,
               settore_descrizione character varying,
               settore_indirizzo character varying,
               settore_num_civico character varying,
               settore_cap character varying,
               settore_localita character varying,
               settore_provincia character varying,
               ente_codice_fiscale character varying,
               forn_ragione_sociale character varying,
               forn_indirizzo character varying,
               forn_numero_civico character varying,
               forn_cap character varying,
               forn_comune character varying,
               forn_provincia character varying,
               forn_codice character varying,
               SettDest_codice character varying,
               SettDest_descrizione character varying,
               dest_indirizzo character varying,
               dest_num_civico character varying,
               dest_cap character varying,
               dest_localita character varying,
               dest_provincia character varying,
               dest_contatto character varying,
               dest_email character varying,
               dest_telefono character varying,
               ogg_descrizione character varying,
               ogg_codice character varying,
               Codifica_Listino_Fornitore character varying,
               unità  character varying,
               ordine_quantita numeric,
               ordine_percent_sconto numeric,
               ordine_percent_sconto2 numeric,
               aliquota_iva  character varying,
               ordine_prezzo_unitario numeric,
               ordine_importo_totale numeric,
               ordine_importo_sconto numeric,
               ordine_importo_sconto2 numeric,
               ordine_importo_netto numeric,
               ordine_importo_iva numeric,
               rigaOrdine_note character varying ,
               ordine_consegna_parziale bool ,
               utente_nome character varying,
               utente_cognome character varying,
               utente_telefono character varying,
               Dirigente_nome character varying,         
               Dirigente_cognome character varying         
               )
 LANGUAGE plpgsql
AS $function$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query
select tord.ordine_anno,
       tord.ordine_numero,
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
       sett.settore_indirizzo ,
       sett.settore_num_civico ,
       sett.settore_cap ,
       sett.settore_localita ,
       sett.settore_provincia ,
       ente.ente_codice_fiscale ,
       forn.ragione_sociale ,
       forn.indirizzo ,
       forn.numero_civico ,
       forn.cap ,
       forn.comune ,
       forn.provincia ,
       forn.codice ,
       settDest.settore_codice ,
       settDest.settore_descrizione , 
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
 join  CPASS_T_ENTE ente on ente.ente_id = sett.ente_id
 join  CPASS_T_FORNITORE forn on tord.fornitore_id = forn.fornitore_id
 join  cpass_t_ord_destinatario_ordine dest on  tord.testata_ordine_id = dest.testata_ordine_id
 join  CPASS_T_SETTORE settDest on dest.settore_destinatario_id = settDest.settore_id
 join  CPASS_T_ORD_RIGA_ORDINE rigaOrd on dest.destinatario_id = rigaOrd.destinatario_id
 join  CPASS_D_OGGETTI_SPESA oggSp on rigaOrd.oggetti_spesa_id = oggSp.oggetti_spesa_id
 LEFT JOIN CPASS_T_LISTINO_FORNITORE lisForn on  rigaOrd.oggetti_spesa_id = lisForn.oggetti_spesa_id and tord.fornitore_id = lisForn.fornitore_id 
 join CPASS_D_UNITA_MISURA unita on  unita.unita_misura_id = rigaOrd.unita_misura_id
 join CPASS_T_UTENTE utente on tord.utente_compilatore_id = utente.utente_id
 left join CPASS_R_DIRIGENTE_SETTORE dirigente on sett.settore_id = dirigente.settore_id
 left join CPASS_T_UTENTE utenteDir on dirigente.utente_id = utenteDir.utente_id
 join CPASS_D_ALIQUOTE_IVA iva on rigaOrd.aliquote_iva_id = iva.aliquote_iva_id
--where tord.testata_ordine_id = '87654aed-9fb7-5c97-b8d5-a1dd5cba33ce'
 
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
$function$
