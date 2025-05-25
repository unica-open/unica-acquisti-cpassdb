---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
--DROP VIEW cpass.cpass_v_ordine_evasione; 
DROP VIEW if exists cpass.cpass_v_ordine_evasione; 
CREATE OR REPLACE VIEW cpass.cpass_v_ordine_evasione AS
SELECT row_number() OVER () AS ordine_id,
    cpass_t_ord_testata_ordine.testata_ordine_id,
    cpass_t_ord_testata_ordine.tipo_ordine_id,
    cpass_t_ord_testata_ordine.ordine_anno,
    cpass_t_ord_testata_ordine.ordine_numero,
    cpass_t_ord_testata_ordine.fornitore_id,
    cpass_t_ord_testata_ordine.tipo_procedura_id,
    cpass_t_ord_testata_ordine.numero_procedura,
    cpass_t_ord_testata_ordine.data_emissione,
    cpass_t_ord_testata_ordine.data_conferma,
    cpass_t_ord_testata_ordine.data_autorizzazione,
    cpass_t_ord_testata_ordine.totale_no_iva,
    cpass_t_ord_testata_ordine.totale_con_iva,
    cpass_t_ord_testata_ordine.descrizione_acquisto,
    cpass_t_ord_testata_ordine.consegna_riferimento,
    cpass_t_ord_testata_ordine.consegna_data_da,
    cpass_t_ord_testata_ordine.consegna_data_a,
    cpass_t_ord_testata_ordine.consegna_indirizzo,
    cpass_t_ord_testata_ordine.consegna_cap,
    cpass_t_ord_testata_ordine.consegna_localita,
    cpass_t_ord_testata_ordine.provvedimento_anno,
    cpass_t_ord_testata_ordine.provvedimento_numero,
    cpass_t_ord_testata_ordine.lotto_anno,
    cpass_t_ord_testata_ordine.lotto_numero,
    cpass_t_ord_testata_ordine.utente_compilatore_id,
    cpass_t_ord_testata_ordine.settore_emittente_id,
    cpass_t_ord_testata_ordine.ufficio_id,
    cpass_t_ord_testata_ordine.stato_id,
    cpass_t_ord_testata_ordine.note,
    cpass_t_ord_testata_ordine.data_cancellazione AS data_cancellazione_testata,
    cpass_t_ord_destinatario_ordine.destinatario_id,
    cpass_t_ord_destinatario_ordine.indirizzo,
    cpass_t_ord_destinatario_ordine.num_civico,
    cpass_t_ord_destinatario_ordine.localita,
    cpass_t_ord_destinatario_ordine.provincia,
    cpass_t_ord_destinatario_ordine.cap,
    cpass_t_ord_destinatario_ordine.contatto,
    cpass_t_ord_destinatario_ordine.email,
    cpass_t_ord_destinatario_ordine.telefono,
    cpass_t_ord_destinatario_ordine.data_invio_nso,
    cpass_t_ord_destinatario_ordine.settore_destinatario_id,
    cpass_t_ord_destinatario_ordine.stato_id AS stato_destinatario_id,
    cpass_t_ord_destinatario_ordine.progressivo AS progressivo_destinatario,
    cpass_t_ord_destinatario_ordine.data_cancellazione AS  data_cancellazione_destinatario,
    cpass_t_ord_riga_ordine.riga_ordine_id,
    cpass_t_ord_riga_ordine.consegna_parziale,
    cpass_t_ord_riga_ordine.progressivo AS progressivo_riga,
    cpass_t_ord_riga_ordine.prezzo_unitario,
    cpass_t_ord_riga_ordine.quantita,
    cpass_t_ord_riga_ordine.percentuale_sconto,
    cpass_t_ord_riga_ordine.importo_sconto,
    cpass_t_ord_riga_ordine.percentuale_sconto2,
    cpass_t_ord_riga_ordine.importo_sconto2,
    cpass_t_ord_riga_ordine.importo_netto,
    cpass_t_ord_riga_ordine.importo_iva,
    cpass_t_ord_riga_ordine.importo_totale,
    cpass_t_ord_riga_ordine.note AS note_riga,
    cpass_t_ord_riga_ordine.stato_id AS stato_riga_ordine_id,
    cpass_t_ord_riga_ordine.oggetti_spesa_id,
    cpass_t_ord_riga_ordine.unita_misura_id,
    cpass_t_ord_riga_ordine.aliquote_iva_id,
    cpass_t_ord_riga_ordine.data_cancellazione AS data_cancellazione_riga,
    cpass_t_ord_testata_evasione.testata_evasione_id,
    cpass_t_ord_testata_evasione.evasione_anno,
    cpass_t_ord_testata_evasione.evasione_numero,
    cpass_t_ord_testata_evasione.fornitore_id AS evasione_fornitore_id,
    cpass_t_ord_testata_evasione.stato_id AS evasione_stato_id,
    cpass_t_ord_testata_evasione.totale_con_iva AS evasione_totale_con_iva,
    cpass_t_ord_testata_evasione.descrizione,
    cpass_t_ord_testata_evasione.fattura_anno,
    cpass_t_ord_testata_evasione.fattura_numero,
    cpass_t_ord_testata_evasione.fattura_tipo,
    cpass_t_ord_testata_evasione.fattura_codice,
    cpass_d_stato.stato_codice AS evasione_stato_codice,
    cpass_d_stato.stato_descrizione AS evasione_stato_descrizione,
    cpass_t_fornitore.codice AS evasione_fornitore_codice,
    cpass_t_fornitore.ragione_sociale AS evasione_fornitore_ragione_sociale
FROM cpass_t_ord_testata_ordine
     JOIN cpass_t_ord_destinatario_ordine ON cpass_t_ord_testata_ordine.testata_ordine_id = cpass_t_ord_destinatario_ordine.testata_ordine_id
     JOIN cpass_t_ord_riga_ordine ON cpass_t_ord_destinatario_ordine.destinatario_id = cpass_t_ord_riga_ordine.destinatario_id
     JOIN cpass_t_ord_riga_evasione ON cpass_t_ord_riga_ordine.riga_ordine_id = cpass_t_ord_riga_evasione.riga_ordine_id
     JOIN cpass_t_ord_destinatario_evasione ON cpass_t_ord_riga_evasione.destinatario_evasione_id = cpass_t_ord_destinatario_evasione.destinatario_evasione_id
     JOIN cpass_t_ord_testata_evasione ON cpass_t_ord_destinatario_evasione.testata_evasione_id = cpass_t_ord_testata_evasione.testata_evasione_id
     JOIN cpass_t_fornitore ON cpass_t_ord_testata_evasione.fornitore_id =cpass_t_fornitore.fornitore_id
     JOIN cpass_d_stato ON cpass_t_ord_testata_evasione.stato_id = cpass_d_stato.stato_id;


     
     
DROP VIEW if exists cpass.cpass_v_ordine;
CREATE OR REPLACE VIEW cpass.cpass_v_ordine
AS
SELECT row_number() OVER () AS ordine_id,
    cpass_t_ord_testata_ordine.testata_ordine_id,
    cpass_t_ord_testata_ordine.tipo_ordine_id,
    cpass_t_ord_testata_ordine.ordine_anno,
    cpass_t_ord_testata_ordine.ordine_numero,
    cpass_t_ord_testata_ordine.fornitore_id,
    cpass_t_ord_testata_ordine.tipo_procedura_id,
    cpass_t_ord_testata_ordine.numero_procedura,
    cpass_t_ord_testata_ordine.data_emissione,
    cpass_t_ord_testata_ordine.data_conferma,
    cpass_t_ord_testata_ordine.data_autorizzazione,
    cpass_t_ord_testata_ordine.totale_no_iva,
    cpass_t_ord_testata_ordine.totale_con_iva,
    cpass_t_ord_testata_ordine.descrizione_acquisto,
    cpass_t_ord_testata_ordine.consegna_riferimento,
    cpass_t_ord_testata_ordine.consegna_data_da,
    cpass_t_ord_testata_ordine.consegna_data_a,
    cpass_t_ord_testata_ordine.consegna_indirizzo,
    cpass_t_ord_testata_ordine.consegna_cap,
    cpass_t_ord_testata_ordine.consegna_localita,
    cpass_t_ord_testata_ordine.provvedimento_anno,
    cpass_t_ord_testata_ordine.provvedimento_numero,
    cpass_t_ord_testata_ordine.provvedimento_tipo,    
    cpass_t_ord_testata_ordine.provvedimento_settore,
    cpass_t_ord_testata_ordine.lotto_anno,
    cpass_t_ord_testata_ordine.lotto_numero,
    cpass_t_ord_testata_ordine.utente_compilatore_id,
    cpass_t_ord_testata_ordine.settore_emittente_id,
    cpass_t_ord_testata_ordine.ufficio_id,
    cpass_t_ord_testata_ordine.stato_id,
    cpass_t_ord_testata_ordine.note,
    cpass_t_ord_testata_ordine.data_cancellazione AS data_cancellazione_testata,
    cpass_t_ord_destinatario_ordine.destinatario_id,
    cpass_t_ord_destinatario_ordine.indirizzo,
    cpass_t_ord_destinatario_ordine.num_civico,
    cpass_t_ord_destinatario_ordine.localita,
    cpass_t_ord_destinatario_ordine.provincia,
    cpass_t_ord_destinatario_ordine.cap,
    cpass_t_ord_destinatario_ordine.contatto,
    cpass_t_ord_destinatario_ordine.email,
    cpass_t_ord_destinatario_ordine.telefono,
    cpass_t_ord_destinatario_ordine.data_invio_nso,
    cpass_t_ord_destinatario_ordine.settore_destinatario_id,
    cpass_t_ord_destinatario_ordine.stato_id AS stato_destinatario_id,
    cpass_t_ord_destinatario_ordine.progressivo AS progressivo_destinatario,
    cpass_t_ord_destinatario_ordine.data_cancellazione AS data_cancellazione_destinatario,
    cpass_t_ord_riga_ordine.riga_ordine_id,
    cpass_t_ord_riga_ordine.consegna_parziale,
    cpass_t_ord_riga_ordine.progressivo AS progressivo_riga,
    cpass_t_ord_riga_ordine.prezzo_unitario,
    cpass_t_ord_riga_ordine.quantita,
    cpass_t_ord_riga_ordine.percentuale_sconto,
    cpass_t_ord_riga_ordine.importo_sconto,
    cpass_t_ord_riga_ordine.percentuale_sconto2,
    cpass_t_ord_riga_ordine.importo_sconto2,
    cpass_t_ord_riga_ordine.importo_netto,
    cpass_t_ord_riga_ordine.importo_iva,
    cpass_t_ord_riga_ordine.importo_totale,
    cpass_t_ord_riga_ordine.note AS note_riga,
    cpass_t_ord_riga_ordine.stato_id AS stato_riga_ordine_id,
    cpass_t_ord_riga_ordine.oggetti_spesa_id,
    cpass_t_ord_riga_ordine.unita_misura_id,
    cpass_t_ord_riga_ordine.aliquote_iva_id,
    cpass_t_ord_riga_ordine.data_cancellazione AS data_cancellazione_riga,
    cpass_t_ord_impegno_ordine.impegno_ordine_id,
    cpass_t_ord_impegno_ordine.impegno_id,
    cpass_t_ord_impegno_ordine.impegno_progressivo,
    cpass_t_ord_impegno_ordine.impegno_anno_esercizio,
    cpass_t_ord_impegno_ordine.impegno_anno,
    cpass_t_ord_impegno_ordine.impegno_numero,
    cpass_t_ord_impegno_ordine.importo AS importo_impegno,
    cpass_t_ord_impegno_ordine.data_cancellazione AS data_cancellazione_impegno,
    cpass_t_impegno.numero_capitolo,
    cpass_t_impegno.numero_articolo,
    cpass_t_ord_subimpegno_ordine.subimpegno_ordine_id,
    cpass_t_ord_subimpegno_ordine.subimpegno_id,
    cpass_t_ord_subimpegno_ordine.subimpegno_anno,
    cpass_t_ord_subimpegno_ordine.subimpegno_numero,
    cpass_t_ord_subimpegno_ordine.subimpegno_importo,
    cpass_t_ord_subimpegno_ordine.data_cancellazione AS data_cancellazione_subimpegno,
    ord_stato_nso_testata_ordine.stato_nso_descrizione AS stato_invio_nso_testata,
    ord_stato_nso_testata_ordine.stato_nso_descrizione AS stato_invio_nso_destinatario
FROM cpass_t_ord_testata_ordine
     LEFT JOIN cpass_t_ord_destinatario_ordine ON
         cpass_t_ord_testata_ordine.testata_ordine_id = cpass_t_ord_destinatario_ordine.testata_ordine_id
     LEFT JOIN cpass_t_ord_riga_ordine ON
         cpass_t_ord_destinatario_ordine.destinatario_id = cpass_t_ord_riga_ordine.destinatario_id
     LEFT JOIN cpass_t_ord_impegno_ordine ON
         cpass_t_ord_riga_ordine.riga_ordine_id = cpass_t_ord_impegno_ordine.riga_ordine_id
     LEFT JOIN cpass_t_impegno ON cpass_t_impegno.impegno_id =
         cpass_t_ord_impegno_ordine.impegno_id
     LEFT JOIN cpass_t_ord_subimpegno_ordine ON
         cpass_t_ord_impegno_ordine.impegno_ordine_id = cpass_t_ord_subimpegno_ordine.impegno_ordine_id
     LEFT JOIN cpass_d_ord_stato_nso ord_stato_nso_testata_ordine ON
         cpass_t_ord_testata_ordine.stato_nso_id = ord_stato_nso_testata_ordine.stato_nso_id
     LEFT JOIN cpass_d_ord_stato_nso ord_stato_nso_destinatario ON
         cpass_t_ord_destinatario_ordine.stato_nso_id = ord_stato_nso_destinatario.stato_nso_id;

ALTER TABLE if exists cpass.cpass_t_provvedimento ALTER COLUMN provvedimento_numero  TYPE VARCHAR;
ALTER TABLE if exists cpass_t_impegno       ALTER COLUMN provvedimento_numero  TYPE VARCHAR;
ALTER TABLE if exists cpass_t_subimpegno    ALTER COLUMN provvedimento_numero  TYPE VARCHAR;

alter table if exists cpass.cpass_t_pba_programma add column if not exists data_trasmissione_mit timestamp;

alter table cpass.cpass_t_parametro_stampa drop constraint if exists cpass_t_parametro_stampa_pkey;
alter table cpass.cpass_t_parametro_stampa add constraint cpass_t_parametro_stampa_pkey PRIMARY KEY (parametro_stampa_id);
alter table cpass.cpass_t_parametro_stampa drop constraint if exists cpass_t_parametro_stampa_unique;
alter table cpass.cpass_t_parametro_stampa add constraint cpass_t_parametro_stampa_unique UNIQUE (nome_stampa, parametro);

DROP FUNCTION if exists cpass.pck_cpass_pba_rep_interventi_risorse(p_programma_id character varying, p_cup character varying, p_settore_interventi character varying, p_struttura_id character varying, p_cpv_id character varying, p_cognome character varying, p_descri character varying, p_order character varying);
DROP FUNCTION if exists cpass.pck_cpass_pba_rep_interventi_risorse(p_programma_id character varying, p_cup character varying, p_settore_interventi character varying, p_struttura_id character varying, p_cpv_id character varying, p_cognome character varying, p_descri character varying, p_order character varying, p_acq_non_rip character varying);
CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_interventi_risorse(p_programma_id character varying, p_cup character varying, p_settore_interventi character varying, p_struttura_id character varying, p_cpv_id character varying, p_cognome character varying, p_descri character varying, p_acq_non_rip character varying, p_order character varying)
 RETURNS TABLE(id_allegato_scheda integer, intervento_cui character varying, intervento_anno_avvio integer, intervento_cup character varying, intervento_stato character varying, ricompreso_tipo_codice character varying, ricompreso_tipo_descrizione character varying, intervento_lotto_funzionale boolean, nuts_codice character varying, nuts_descrizione character varying, settore_interventi_codice character varying, settore_interventi_descrizione character varying, cpv_codice character varying, cpv_descrizione character varying, intervento_descrizione_acquisto character varying, priorita_codice character varying, priorita_descrizione character varying, utente_nome character varying, utente_cognome character varying, utente_codice_fiscale character varying, intervento_durata_mesi integer, intervento_nuovo_affid boolean, ausa character varying, ausa_descrizione character varying, acquisto_variato_codice character varying, acquisto_variato_descrizione character varying, programma_id uuid, programma_anno integer, ente_id uuid, ente_codice_fiscale character varying, ente_denominazione character varying, importo_anno_primo numeric, importo_anno_secondo numeric, importo_anni_successivi numeric, totale_importi numeric, risorsa character varying, tipologia character varying, settore_codice character varying, settore_descrizione character varying, motivazione_non_riproposto character varying)
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
    
	 if p_acq_non_rip <> 'null' and p_acq_non_rip <> '' and p_acq_non_rip is not null and upper(p_acq_non_rip) = 'ACQ_NON_RIP' then 
       stringa_sql := stringa_sql || ' and intervento.motivazione_non_riproposto IS NOT NULL ';         
	 end if;
	
	 if p_acq_non_rip <> 'null' and p_acq_non_rip <> '' and p_acq_non_rip is not null and upper(p_acq_non_rip) = 'ACQ_ATTIVI' then 
       stringa_sql := stringa_sql || ' and intervento.motivazione_non_riproposto IS NULL ';         
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
$function$
;

CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_rep_consult_sintetico(p_provv_anno character varying, p_provv_numero character varying, p_provv_tipo character varying, p_tipo_procedura character varying, p_procedura_numero character varying)
 RETURNS TABLE(testata_ordine_id uuid, provvedimento_anno integer, provvedimento_numero character varying, provvedimento_tipo character varying, tipo_procedura_id integer, tipo_procedura_desc character varying, numero_procedura character varying, ordine_anno integer, ordine_numero integer, data_emissione timestamp without time zone, data_autorizzazione timestamp without time zone, stato_descrizione character varying, stato_invio_nso_testata character varying, codice character varying, ragione_sociale character varying, totale_no_iva numeric, totale_con_iva numeric, tot_impegnato numeric, tot_evaso numeric, tot_evaso_cont numeric, descrizione_acquisto character varying)
 LANGUAGE plpgsql
AS $function$
DECLARE

RTN_MESSAGGIO text;

begin
	
  if p_provv_anno =  'null' OR p_provv_anno = ''  then
   p_provv_anno := NULL;  
  end if; 
  if p_provv_numero =  'null' OR p_provv_numero = ''  then
   p_provv_numero := NULL;  
  end if; 
  if p_provv_tipo =  'null' OR p_provv_tipo = ''  then
   p_provv_tipo := NULL;  
  end if; 
  if p_tipo_procedura =  'null' OR p_tipo_procedura = ''  then
   p_tipo_procedura := NULL;  
  end if;
  if p_procedura_numero =  'null' OR p_procedura_numero = ''  then
   p_procedura_numero := NULL;  
  end if; 
 
return query
WITH impegnato AS (
SELECT cpass_t_ord_testata_ordine.testata_ordine_id,
    cpass_t_ord_testata_ordine.provvedimento_anno,
    cpass_t_ord_testata_ordine.provvedimento_numero,
    cpass_t_ord_testata_ordine.provvedimento_tipo,
    cpass_t_ord_testata_ordine.tipo_procedura_id,
    procedura.tipo_procedura_descrizione as tipo_procedura_desc,
    cpass_t_ord_testata_ordine.numero_procedura,
    cpass_t_ord_testata_ordine.ordine_anno,
    cpass_t_ord_testata_ordine.ordine_numero,
    cpass_t_ord_testata_ordine.data_emissione,
    cpass_t_ord_testata_ordine.data_autorizzazione,
    cpass_d_stato.stato_descrizione,
    ord_stato_nso_testata_ordine.stato_nso_descrizione AS stato_invio_nso_testata,
    fornitore.codice,
    fornitore.ragione_sociale,
    cpass_t_ord_testata_ordine.descrizione_acquisto,
    cpass_t_ord_testata_ordine.totale_no_iva,
    cpass_t_ord_testata_ordine.totale_con_iva,
    sum(COALESCE(cpass_t_ord_impegno_ordine.importo, 0::numeric)) AS tot_impegnato
  FROM cpass_t_ord_testata_ordine
     JOIN cpass_d_stato ON cpass_t_ord_testata_ordine.stato_id = cpass_d_stato.stato_id
     JOIN cpass_t_fornitore fornitore ON cpass_t_ord_testata_ordine.fornitore_id = fornitore.fornitore_id
     JOIN cpass_t_ord_destinatario_ordine ON cpass_t_ord_testata_ordine.testata_ordine_id = cpass_t_ord_destinatario_ordine.testata_ordine_id
     left join cpass_d_ord_tipo_procedura procedura ON cpass_t_ord_testata_ordine.tipo_procedura_id = procedura.tipo_procedura_id 
     LEFT JOIN cpass_t_ord_riga_ordine ON cpass_t_ord_destinatario_ordine.destinatario_id = cpass_t_ord_riga_ordine.destinatario_id
     LEFT JOIN cpass_t_ord_impegno_ordine ON cpass_t_ord_riga_ordine.riga_ordine_id = cpass_t_ord_impegno_ordine.riga_ordine_id
     LEFT JOIN cpass_t_impegno ON cpass_t_impegno.impegno_id = cpass_t_ord_impegno_ordine.impegno_id
     LEFT JOIN cpass_d_ord_stato_nso ord_stato_nso_testata_ordine ON cpass_t_ord_testata_ordine.stato_nso_id = ord_stato_nso_testata_ordine.stato_nso_id
GROUP BY cpass_t_ord_testata_ordine.testata_ordine_id, 
         cpass_t_ord_testata_ordine.provvedimento_anno, 
         cpass_t_ord_testata_ordine.provvedimento_numero, 
         cpass_t_ord_testata_ordine.provvedimento_tipo, 
         cpass_t_ord_testata_ordine.tipo_procedura_id,
         procedura.tipo_procedura_descrizione,
         cpass_t_ord_testata_ordine.numero_procedura,
         cpass_t_ord_testata_ordine.ordine_anno, 
         cpass_t_ord_testata_ordine.ordine_numero, 
         cpass_t_ord_testata_ordine.data_emissione, 
         cpass_t_ord_testata_ordine.data_autorizzazione, 
         cpass_d_stato.stato_descrizione, 
         ord_stato_nso_testata_ordine.stato_nso_descrizione, 
         fornitore.codice, 
         fornitore.ragione_sociale, 
         cpass_t_ord_testata_ordine.descrizione_acquisto,
         cpass_t_ord_testata_ordine.totale_no_iva, 
         cpass_t_ord_testata_ordine.totale_con_iva 
),
importi_evasi AS (
     SELECT  cpass_t_ord_testata_ordine.testata_ordine_id,
--             sum(COALESCE(cpass_t_ord_riga_evasione.importo_totale, 0::numeric)) AS tot_evaso
             sum(COALESCE(testa_evas.totale_con_iva , 0::numeric)) AS tot_evaso
FROM cpass_t_ord_testata_ordine
     left JOIN cpass_t_ord_destinatario_ordine ON cpass_t_ord_testata_ordine.testata_ordine_id = cpass_t_ord_destinatario_ordine.testata_ordine_id            
     LEFT JOIN cpass_t_ord_riga_ordine ON cpass_t_ord_destinatario_ordine.destinatario_id = cpass_t_ord_riga_ordine.destinatario_id
     LEFT JOIN cpass_t_ord_riga_evasione evaso ON cpass_t_ord_riga_ordine.riga_ordine_id = evaso.riga_ordine_id AND evaso.stato_id <> 59
     LEFT JOIN cpass_t_ord_destinatario_evasione dest_evas ON evaso.destinatario_evasione_id = dest_evas.destinatario_evasione_id
     LEFT JOIN cpass_t_ord_testata_evasione testa_evas ON dest_evas.testata_evasione_id = testa_evas.testata_evasione_id 
     group by cpass_t_ord_testata_ordine.testata_ordine_id
     ),
importi_evasi_cont AS (
     SELECT  cpass_t_ord_testata_ordine.testata_ordine_id,
--             sum(COALESCE(evaso_con.importo_totale, 0::numeric)) AS tot_evaso_cont
             sum(COALESCE(testa_evas.totale_con_iva , 0::numeric)) AS tot_evaso_cont
FROM cpass_t_ord_testata_ordine
     left JOIN cpass_t_ord_destinatario_ordine ON cpass_t_ord_testata_ordine.testata_ordine_id = cpass_t_ord_destinatario_ordine.testata_ordine_id            
     LEFT JOIN cpass_t_ord_riga_ordine ON cpass_t_ord_destinatario_ordine.destinatario_id = cpass_t_ord_riga_ordine.destinatario_id
     LEFT JOIN cpass_t_ord_riga_evasione evaso_con ON cpass_t_ord_riga_ordine.riga_ordine_id = evaso_con.riga_ordine_id AND evaso_con.stato_id <> 59
     LEFT JOIN cpass_t_ord_destinatario_evasione dest_evas ON evaso_con.destinatario_evasione_id = dest_evas.destinatario_evasione_id
     LEFT JOIN cpass_t_ord_testata_evasione testa_evas ON dest_evas.testata_evasione_id = testa_evas.testata_evasione_id AND testa_evas.stato_id = (( SELECT cpass_d_stato_1.stato_id
           FROM cpass_d_stato cpass_d_stato_1
          WHERE cpass_d_stato_1.stato_codice::text = 'IN_CONTABILITA'::text))
     group by cpass_t_ord_testata_ordine.testata_ordine_id
     )
    select distinct
    impegnato.testata_ordine_id,
    impegnato.provvedimento_anno,
    impegnato.provvedimento_numero,
    impegnato.provvedimento_tipo,
    impegnato.tipo_procedura_id,
    impegnato.tipo_procedura_desc,
    impegnato.numero_procedura,
    impegnato.ordine_anno,
    impegnato.ordine_numero,
    impegnato.data_emissione,
    impegnato.data_autorizzazione,
    impegnato.stato_descrizione,
    impegnato.stato_invio_nso_testata,
    impegnato.codice,
    impegnato.ragione_sociale,
    impegnato.totale_no_iva,
    impegnato.totale_con_iva,
    impegnato.tot_impegnato,
    importi_evasi.tot_evaso,
    importi_evasi_cont.tot_evaso_cont,
    impegnato.descrizione_acquisto
    FROM impegnato 
     -- JOIN impegnato  ON cpass_t_ord_testata_ordine.testata_ordine_id = impegnato.testata_ordine_id 
    left JOIN importi_evasi  ON impegnato.testata_ordine_id = importi_evasi.testata_ordine_id 
    left JOIN importi_evasi_cont  ON impegnato.testata_ordine_id = importi_evasi_cont.testata_ordine_id 
    where 
     	((impegnato.provvedimento_anno = p_provv_anno::integer and p_provv_anno is not null) or p_provv_anno is null )
    and ((impegnato.provvedimento_numero = p_provv_numero and p_provv_numero is not null) or p_provv_numero is null)
    and ((impegnato.provvedimento_tipo = p_provv_tipo and p_provv_tipo is not null) or p_provv_tipo is null)
    and ((impegnato.tipo_procedura_id = p_tipo_procedura::integer and p_tipo_procedura is not null) or p_tipo_procedura is null)
    and ((impegnato.numero_procedura = p_procedura_numero and p_procedura_numero is not null) or p_procedura_numero is null )
;

exception
	when no_data_found THEN
		raise notice 'Nessun dato trovato';
		return;
	when others  THEN
		RAISE EXCEPTION '% Errore : %-%.',RTN_MESSAGGIO,SQLSTATE,substring(SQLERRM from 1 for 500);
		return;

END;
$function$
;



DROP FUNCTION IF EXISTS cpass.pck_cpass_pba_rep_ordini( character varying);
DROP FUNCTION IF EXISTS cpass.pck_cpass_ord_rep_ordini( character varying);

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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;

alter table cpass_t_parametro_stampa add column if not exists multiplo boolean default false;
alter table cpass_t_parametro_stampa add column if not exists file_name varchar(200) ;

DROP FUNCTION if exists    cpass.pck_cpass_ord_rep_consult_dett( character varying,  character varying,  character varying,  character varying,  character varying);
                                
CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_rep_consult_dett (
  p_provv_anno varchar,
  p_provv_numero varchar,
  p_provv_tipo varchar,
  p_tipo_procedura varchar,
  p_procedura_numero varchar
)
RETURNS TABLE (
  testata_ordine_id uuid,
  provvedimento_anno integer,
  provvedimento_numero varchar,
  provvedimento_tipo varchar,
  ordine_anno integer,
  ordine_numero integer,
  descrizione_acquisto varchar,
  data_emissione timestamp,
  data_autorizzazione timestamp,
  stato_descrizione varchar,
  stato_invio_nso_testata varchar,
  fornitore_codice varchar,
  fornitore_ragione_sociale varchar,
  fornitore_codice_fiscale varchar,
  fornitore_partita_iva varchar,
  totale_no_iva numeric,
  totale_con_iva numeric,
  utente_cognome varchar,
  utente_nome varchar,
  rda_anno integer,
  rda_numero integer,
  lotto_anno integer,
  lotto_numero integer,
  settore_interventi_codice varchar,
  tipo_acquisto varchar,
  tipo_ordine varchar,
  codice_univoco_ufficio varchar,
  codice_struttura_emittente varchar,
  descrizione_struttura_emittente varchar,
  anno_protocollo integer,
  numero_protocollo varchar,
  aoo_protocollo varchar,
  procedura_tipo varchar,
  destinatario_settore_codice varchar,
  destinatario_settore_descrizione varchar,
  procedura_numero varchar,
  stato_destinatario varchar,
  ods_codice varchar,
  ods_descrizione varchar,
  cpv_codice varchar,
  listino_fornitore_codice_ods varchar,
  unita_misura_descrizione varchar,
  quantita numeric,
  prezzo_unitario numeric,
  importo_netto numeric,
  importo_totale numeric,
  stato_riga_ordine varchar,
  impegno_anno_esercizio integer,
  nro_capitolo integer,
  nro_articolo integer,
  impegno_anno integer,
  impegno_numero integer,
  subimpegno_anno integer,
  subimpegno_numero integer,
  importo_impegnato numeric,
  impegno_descrizione varchar,
  evasione_anno integer,
  evasione_numero integer,
  stato_evasione varchar
) AS
$body$
DECLARE

RTN_MESSAGGIO text;

begin
	
  if p_provv_anno =  'null' OR p_provv_anno = ''  then
   p_provv_anno := NULL;  
  end if; 
  if p_provv_numero =  'null' OR p_provv_numero = ''  then
   p_provv_numero := NULL;  
  end if; 
  if p_provv_tipo =  'null' OR p_provv_tipo = ''  then
   p_provv_tipo := NULL;  
  end if; 
  if p_tipo_procedura =  'null' OR p_tipo_procedura = ''  then
   p_tipo_procedura := NULL;  
  end if;
  if p_procedura_numero =  'null' OR p_procedura_numero = ''  then
   p_procedura_numero := NULL;  
  end if; 
 
return query
WITH impegnato AS (
SELECT 
    cpass_t_ord_testata_ordine.testata_ordine_id,
    cpass_t_ord_riga_ordine.destinatario_id,
    cpass_t_ord_riga_ordine.riga_ordine_id,
    impegno_ordine.impegno_ordine_id,
    subimpegno_ordine.subimpegno_id,
    impegnoEvasione.impegno_evasione_id,
    impegnoEvasione.impegno_id,
    testa_evas.testata_evasione_id,
    cpass_t_ord_testata_ordine.provvedimento_anno,
    cpass_t_ord_testata_ordine.provvedimento_numero,
    cpass_t_ord_testata_ordine.provvedimento_tipo,
    cpass_t_ord_testata_ordine.tipo_procedura_id,
    cpass_t_ord_testata_ordine.ordine_anno,
    cpass_t_ord_testata_ordine.ordine_numero,
    cpass_t_ord_testata_ordine.data_emissione,
    cpass_t_ord_testata_ordine.data_autorizzazione,
    stato_ordine.stato_descrizione,
    ord_stato_nso_testata_ordine.stato_nso_descrizione AS stato_invio_nso_testata,
    fornitore.codice fornitore_codice,
    fornitore.ragione_sociale fornitore_ragione_sociale,
    fornitore.codice_fiscale fornitore_codice_fiscale,
    fornitore.partita_iva fornitore_partita_iva,
    cpass_t_ord_testata_ordine.descrizione_acquisto,
    cpass_t_ord_testata_ordine.totale_no_iva,
    cpass_t_ord_testata_ordine.totale_con_iva,
    utente.utente_cognome, 
    utente.utente_nome, 
    rda.rda_anno,
    rda.rda_numero,
    cpass_t_ord_testata_ordine.lotto_anno, 
    cpass_t_ord_testata_ordine.lotto_numero, 
    settore.settore_interventi_codice,
    settore.settore_interventi_descrizione, 
    tipoOrdine.tipologia_documento_descrizione,
    ufficio.ufficio_codice,
    struttura.settore_codice,
    struttura.settore_descrizione,
    protocollo.anno_protocollo ,
    protocollo.numero_protocollo,
    protocollo.aoo aoo_protocollo,
    procedura.tipo_procedura_descrizione procedura_tipo,
    settore_destinatario.settore_codice destinatario_settore_codice,
    settore_destinatario.settore_descrizione destinatario_settore_descrizione,
    cpass_t_ord_testata_ordine.numero_procedura,
    stato_destinario.stato_descrizione stato_destinatario,
    oggetto.oggetti_spesa_codice Ods_Codice,
    oggetto.oggetti_spesa_descrizione Ods_Descrizione,
    cpv.cpv_codice, 
    listino.listino_fornitore_codice_ods, 
    misura.unita_misura_descrizione, 
    cpass_t_ord_riga_ordine.quantita,
    cpass_t_ord_riga_ordine.prezzo_unitario,
    cpass_t_ord_riga_ordine.importo_netto,
    cpass_t_ord_riga_ordine.importo_totale,
    stato_riga_ordine.stato_descrizione stato_riga_ordine,
    impegno_ordine.impegno_anno_esercizio,
    impegno.numero_capitolo,
    impegno.numero_articolo,
    impegno_ordine.impegno_anno,
    impegno_ordine.impegno_numero,
    subimpegno_ordine.subimpegno_anno ,
    subimpegno_ordine.subimpegno_numero,
    impegno_ordine.importo AS importo_impegnato,
    impegno.impegno_descrizione ,
    testa_evas.evasione_anno ,
    testa_evas.evasione_numero, 
    stato_evasione.stato_descrizione stato_evasione
--    sett_evas.settore_codice  codice_dest_evasione,
--    sett_evas.settore_descrizione  descri_dest_evasione,
--    cpass_t_ord_riga_evasione.quantita_evasa,
--    cpass_t_ord_riga_evasione.importo_totale importo_evaso
    --sum(COALESCE(cpass_t_ord_impegno_ordine.importo, 0::numeric)) AS tot_impegnato
  FROM cpass_t_ord_testata_ordine
     JOIN cpass_d_stato stato_ordine ON cpass_t_ord_testata_ordine.stato_id = stato_ordine.stato_id and stato_ordine.stato_tipo = 'ORDINE'
     left join cpass_t_utente utente on cpass_t_ord_testata_ordine.utente_compilatore_id = utente.utente_id 
     left join cpass_r_ord_rda_ordine rord on cpass_t_ord_testata_ordine.testata_ordine_id = rord.testata_ordine_id 
     left join cpass_t_ord_testata_rda rda on rord.testata_rda_id = rda.testata_rda_id
     left join cpass_d_pba_settore_interventi settore on cpass_t_ord_testata_ordine.settore_interventi_id = settore.settore_interventi_id 
     left join cpass_d_ord_tipo_ordine tipoOrdine on cpass_t_ord_testata_ordine.tipo_ordine_id = tipoOrdine.tipo_ordine_id 
     left join cpass_t_ufficio ufficio on cpass_t_ord_testata_ordine.ufficio_id = ufficio.ufficio_id 
     left join cpass_t_settore struttura on cpass_t_ord_testata_ordine.settore_emittente_id = struttura.settore_id 
     left join cpass_t_ord_protocollo_ordine protocollo on cpass_t_ord_testata_ordine.testata_ordine_id = protocollo.testata_ordine_id 
     left join cpass_d_ord_tipo_procedura procedura ON cpass_t_ord_testata_ordine.tipo_procedura_id = procedura.tipo_procedura_id 
     left JOIN cpass_t_fornitore fornitore ON cpass_t_ord_testata_ordine.fornitore_id = fornitore.fornitore_id
     left JOIN cpass_t_ord_destinatario_ordine ON cpass_t_ord_testata_ordine.testata_ordine_id = cpass_t_ord_destinatario_ordine.testata_ordine_id
     left JOIN cpass_t_settore settore_destinatario ON cpass_t_ord_destinatario_ordine.settore_destinatario_id = settore_destinatario.settore_id
     left JOIN cpass_d_stato stato_destinario ON cpass_t_ord_destinatario_ordine.stato_id = stato_destinario.stato_id and stato_destinario.stato_tipo = 'DEST_ORDINE'
     LEFT JOIN cpass_t_ord_riga_ordine ON cpass_t_ord_destinatario_ordine.destinatario_id = cpass_t_ord_riga_ordine.destinatario_id
     left JOIN cpass_d_stato stato_riga_ordine ON cpass_t_ord_riga_ordine.stato_id = stato_riga_ordine.stato_id and stato_riga_ordine.stato_tipo = 'RIGA_ORDINE'
     LEFT JOIN cpass_t_ord_impegno_ordine impegno_ordine ON cpass_t_ord_riga_ordine.riga_ordine_id = impegno_ordine.riga_ordine_id
     LEFT JOIN cpass_t_impegno impegno ON  impegno_ordine.impegno_id = impegno.impegno_id
     LEFT JOIN cpass_t_ord_subimpegno_ordine subimpegno_ordine on impegno_ordine.impegno_ordine_id = subimpegno_ordine.impegno_ordine_id      
     LEFT JOIN cpass_d_ord_stato_nso ord_stato_nso_testata_ordine ON cpass_t_ord_testata_ordine.stato_nso_id = ord_stato_nso_testata_ordine.stato_nso_id
     left join cpass_d_oggetti_spesa oggetto on CPASS_T_ORD_RIGA_ORDINE.oggetti_spesa_id = oggetto.oggetti_spesa_id
     left join cpass_d_cpv cpv on oggetto.cpv_id = cpv.cpv_id
     left join cpass_t_listino_fornitore listino on cpass_t_ord_riga_ordine.listino_fornitore_id = listino.listino_fornitore_id 
     left join cpass_d_unita_misura misura on cpass_t_ord_riga_ordine.unita_misura_id = misura.unita_misura_id 
     LEFT JOIN cpass_t_ord_riga_evasione ON cpass_t_ord_riga_ordine.riga_ordine_id = cpass_t_ord_riga_evasione.riga_ordine_id AND cpass_t_ord_riga_evasione.stato_id <> 59
     LEFT JOIN cpass_t_ord_destinatario_evasione dest_evas ON cpass_t_ord_riga_evasione.destinatario_evasione_id = dest_evas.destinatario_evasione_id
     LEFT JOIN cpass_t_ord_testata_evasione testa_evas ON dest_evas.testata_evasione_id = testa_evas.testata_evasione_id 
     left join cpass_t_ord_impegno_evasione impegnoEvasione on cpass_t_ord_riga_evasione.riga_evasione_id = impegnoEvasione.riga_evasione_id
     left join cpass_d_stato stato_evasione on testa_evas.stato_id = stato_evasione.stato_id and stato_evasione.stato_tipo = 'EVASIONE'
     --left join cpass_t_settore sett_evas on dest_evas.settore_destinatario_id = sett_evas.settore_id
)/*,
importo_impegno_ripartito AS ( 
    select impegnoEvasione.impegno_evasione_id,
           impegnoEvasione.impegno_id,
           SubimpegnoEvasione.subimpegno_id,
           ctote.testata_evasione_id,
           sum(COALESCE(impegnoEvasione.importo_ripartito, 0::numeric)) AS importo_ripartito
     FROM cpass_t_ord_testata_evasione ctote 
     left JOIN cpass_t_ord_destinatario_evasione ON ctote.testata_evasione_id  = cpass_t_ord_destinatario_evasione.testata_evasione_id            
     left join cpass_t_ord_riga_evasione on cpass_t_ord_destinatario_evasione.destinatario_evasione_id = cpass_t_ord_riga_evasione.destinatario_evasione_id   
     left join cpass_t_ord_impegno_evasione impegnoEvasione on cpass_t_ord_riga_evasione.riga_evasione_id = impegnoEvasione.riga_evasione_id
     left join cpass_t_impgn
     left join cpass_t_ord_subimpegno_evasione SubimpegnoEvasione on impegnoEvasione.impegno_evasione_id = SubimpegnoEvasione.impegno_evasione_id 
    -- where ctote.testata_evasione_id = '4ca8a985-ee08-5e80-9851-598e95962722'
     group by impegnoEvasione.impegno_evasione_id,
              impegnoEvasione.impegno_id ,
              SubimpegnoEvasione.subimpegno_id,
              ctote.testata_evasione_id  
     )*/
    select distinct
    impegnato.testata_ordine_id,
    impegnato.provvedimento_anno,
    impegnato.provvedimento_numero,
    impegnato.provvedimento_tipo,
    impegnato.ordine_anno,
    impegnato.ordine_numero,
    impegnato.descrizione_acquisto,
    impegnato.data_emissione,
    impegnato.data_autorizzazione,
    impegnato.stato_descrizione,
    impegnato.stato_invio_nso_testata,
    impegnato.fornitore_codice,
    impegnato.fornitore_ragione_sociale,
    impegnato.fornitore_codice_fiscale,
    impegnato.fornitore_partita_iva,    
    impegnato.totale_no_iva,
    impegnato.totale_con_iva,
    impegnato.utente_cognome, 
    impegnato.utente_nome, 
    impegnato.rda_anno,
    impegnato.rda_numero,
    impegnato.lotto_anno, 
    impegnato.lotto_numero, 
    impegnato.settore_interventi_codice,
    impegnato.settore_interventi_descrizione Tipo_Acquisto,
    impegnato.tipologia_documento_descrizione  Tipo_Ordine,
    impegnato.ufficio_codice codice_univoco_ufficio,
    impegnato.settore_codice codice_struttura_emittente,
    impegnato.settore_descrizione descrizione_struttura_emittente,    
    impegnato.anno_protocollo,
    impegnato.numero_protocollo,
    impegnato.aoo_protocollo,
    impegnato.procedura_tipo,
    impegnato.destinatario_settore_codice,
    impegnato.destinatario_settore_descrizione,
    impegnato.numero_procedura procedura_numero,
    impegnato.stato_destinatario,
    impegnato.Ods_Codice,
    impegnato.Ods_Descrizione,
    impegnato.cpv_codice, 
    impegnato.listino_fornitore_codice_ods,
    impegnato.unita_misura_descrizione,
    impegnato.quantita,
    impegnato.prezzo_unitario,
    impegnato.importo_netto,
    impegnato.importo_totale,   
    impegnato.stato_riga_ordine,
    impegnato.impegno_anno_esercizio,
    impegnato.numero_capitolo,
    impegnato.numero_articolo,
    impegnato.impegno_anno,
    impegnato.impegno_numero,
    impegnato.subimpegno_anno ,
    impegnato.subimpegno_numero,
    impegnato.importo_impegnato,
    impegnato.impegno_descrizione ,
    impegnato.evasione_anno ,
    impegnato.evasione_numero, 
    impegnato.stato_evasione
--    impegnato.codice_dest_evasione,
--    impegnato.descri_dest_evasione,
--    impegnato.quantita_evasa,
--    impegnato.importo_evaso,
--    impegnato.importo_evaso importo_ripartito
--    importo_impegno_ripartito.importo_ripartito importo_ripartito
    FROM impegnato 
     /* left JOIN importo_impegno_ripartito  ON impegnato.impegno_evasione_id = importo_impegno_ripartito.impegno_evasione_id and 
                                              impegnato.impegno_id = importo_impegno_ripartito.impegno_id and
                                              impegnato.testata_evasione_id =  importo_impegno_ripartito.testata_evasione_id and
                                            ((impegnato.subimpegno_id = importo_impegno_ripartito.subimpegno_id and impegnato.subimpegno_id  is not null) or impegnato.subimpegno_id is null)*/
where 
     	((impegnato.provvedimento_anno = p_provv_anno::integer and p_provv_anno is not null) or p_provv_anno is null )
    and ((impegnato.provvedimento_numero = p_provv_numero and p_provv_numero is not null) or p_provv_numero is null)
    and ((impegnato.provvedimento_tipo = p_provv_tipo and p_provv_tipo is not null) or p_provv_tipo is null)
    and ((impegnato.tipo_procedura_id = p_tipo_procedura::integer and p_tipo_procedura is not null) or p_tipo_procedura is null)
    and ((impegnato.numero_procedura = p_procedura_numero and p_procedura_numero is not null) or p_procedura_numero is null )
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

drop function if exists pck_cpass_ord_rep_ordini_dest(character varying);
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
       settDest.settore_descrizione , 
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
     --where tord.destinatario_id = '87654aed-9fb7-5c97-b8d5-a1dd5cba33ce'
where
    	 destinatario_ordine.destinatario_id= p_destinatario_id::UUID
--         destinatario_ordine.destinatario_id  = '27bd1221-8111-5e7a-95d3-4448bf8b608e' 
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

alter table if exists cpass.cpass_d_permesso add column if not exists disattivabile varchar(50) not null default 'SI';
alter table if exists cpass.cpass_d_permesso add column if not exists attivo boolean not null default true;
alter table if exists cpass.cpass_d_pba_acquisto_variato add column if not exists acquisti_non_riproposti boolean default false;

alter table cpass.cpass_t_parametro drop constraint if exists cpass_t_parametro_unique;
ALTER TABLE cpass.cpass_t_parametro ADD CONSTRAINT cpass_t_parametro_unique UNIQUE (chiave, riferimento, ambiente,ente_id);

alter table cpass_d_provvedimento_tipo add column if not exists ente_id uuid;

ALTER TABLE IF EXISTS cpass_d_provvedimento_tipo   drop constraint  if exists  fk_cpass_d_provvedimento_tipo_ente;

ALTER TABLE IF EXISTS cpass_d_provvedimento_tipo   add constraint  fk_cpass_d_provvedimento_tipo_ente FOREIGN KEY (ente_id)
REFERENCES cpass.cpass_t_ente (ente_id);










----------------------------------------------------------------------------------
update cpass_d_pba_acquisto_variato set acquisti_non_riproposti = true where acquisto_variato_codice ='';

update cpass.cpass_d_permesso set disattivabile = 'NO'
where permesso_codice IN(
 'STAMPA_INTERVENTO'
,'CONSULTA_ORDINE'
,'CONSULTA_EVASIONE'
,'CONSULTA_RICHIESTA'
,'CONSULTA_INDIRIZZI'
,'CONSULTA_SCHEDE_MAG'
,'CONSULTA_CARICO'
,'CONSULTA_SCARICO'
,'RICERCA_MOVIMENTI'
);


update cpass_t_parametro_stampa set file_name = file_name_template;

update cpass.cpass_t_metadati_funzione set chiave_colonna = 'PBA.INTERVENTION.FIELD.DESCRIPTION.TITLE' 
where modulo = 'PBA' and funzione= 'RICERCA_INTERVENTO' and chiave_colonna= 'PBA.INTERVENTION.FIELD.DESCRIPTION';

insert into cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
select tmp.codice, tmp.descrizione, tmp.tipo
from ( values
	('TRASMESSO','TRASMESSO','PROGRAMMA')
)AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato ts
  WHERE ts.stato_codice = tmp.codice
  AND ts.stato_tipo = tmp.tipo
);

INSERT INTO cpass.cpass_t_parametro_stampa (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
SELECT tmp.modulo, tmp.nome_stampa, tmp.file_name_template, tmp.parametro, tmp.parametro_tipo, tmp.ordinamento, tmp.procedure_utilizzate, NULL, tmp.formato_stampa
FROM (VALUES
  ('ORD','CONSULTAZIONI_REPORT_SINTETICO','Consultazioni_report_sintetico.rptdesign','p_provv_anno','varchar',1,'pck_cpass_ord_rep_consult_sintetico','xls'),
  ('ORD','CONSULTAZIONI_REPORT_SINTETICO','Consultazioni_report_sintetico.rptdesign','p_provv_numero','varchar',2,'pck_cpass_ord_rep_consult_sintetico','xls'),
  ('ORD','CONSULTAZIONI_REPORT_SINTETICO','Consultazioni_report_sintetico.rptdesign','p_provv_tipo','varchar',3,'pck_cpass_ord_rep_consult_sintetico','xls'),
  ('ORD','CONSULTAZIONI_REPORT_SINTETICO','Consultazioni_report_sintetico.rptdesign','p_tipo_procedura','varchar',4,'pck_cpass_ord_rep_consult_sintetico','xls'),
  ('ORD','CONSULTAZIONI_REPORT_SINTETICO','Consultazioni_report_sintetico.rptdesign','p_procedura_numero','varchar',5,'pck_cpass_ord_rep_consult_sintetico','xls'),
  ('ORD','CONSULTAZIONI_REPORT_DETTAGLIATO','Consultazioni_report_Dettagliato.rptdesign','p_provv_anno','varchar',1,'pck_cpass_ord_rep_consult_dett','xls'),
  ('ORD','CONSULTAZIONI_REPORT_DETTAGLIATO','Consultazioni_report_Dettagliato.rptdesign','p_provv_numero','varchar',2,'pck_cpass_ord_rep_consult_dett','xls'),
  ('ORD','CONSULTAZIONI_REPORT_DETTAGLIATO','Consultazioni_report_Dettagliato.rptdesign','p_provv_tipo','varchar',3,'pck_cpass_ord_rep_consult_dett','xls'),
  ('ORD','CONSULTAZIONI_REPORT_DETTAGLIATO','Consultazioni_report_Dettagliato.rptdesign','p_tipo_procedura','varchar',4,'pck_cpass_ord_rep_consult_dett','xls'),
  ('ORD','CONSULTAZIONI_REPORT_DETTAGLIATO','Consultazioni_report_Dettagliato.rptdesign','p_procedura_numero','varchar',5,'pck_cpass_ord_rep_consult_dett','xls'),
  ('PBA','STAMPA_INTERVENTI','Stampa_acquisti.rptdesign','p_acq_non_rip','varchar',8,'pck_cpass_pba_rep_interventi_risorse','xls')
  ) AS tmp (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, formato_stampa)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro_stampa current
  WHERE current.nome_stampa = tmp.nome_stampa
  AND current.parametro = tmp.parametro
);
update cpass.cpass_t_parametro_stampa set ordinamento = 8 where modulo = 'PBA' and nome_stampa= 'STAMPA_INTERVENTI' and parametro= 'p_acq_non_rip';
update cpass.cpass_t_parametro_stampa set ordinamento = 9 where modulo = 'PBA' and nome_stampa= 'STAMPA_INTERVENTI' and parametro= 'p_order';
update cpass.cpass_t_parametro_stampa set procedure_utilizzate = 'pck_cpass_ord_rep_ordini' where procedure_utilizzate = 'pck_cpass_pba_rep_ordini';

INSERT INTO cpass.cpass_t_parametro_stampa (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
SELECT tmp.modulo, tmp.nome_stampa, tmp.file_name_template, tmp.parametro, tmp.parametro_tipo, tmp.ordinamento, tmp.procedure_utilizzate, NULL, tmp.formato_stampa
FROM (VALUES
  ('ORD','VERBALE_CONSEGNA','Stampa_Copia_Destinatario.rptdesign','p_destinatario_id','varchar',1,'pck_cpass_ord_rep_ordini_dest','pdf')
  ) AS tmp (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, formato_stampa)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro_stampa current
  WHERE current.nome_stampa = tmp.nome_stampa
  AND current.parametro = tmp.parametro
);

update cpass_t_parametro_stampa set file_name = 'soggettiAggregatori' 	       where nome_stampa = 'REPORT_SOGGETTI_AGGREGATORI';
update cpass_t_parametro_stampa set file_name = 'stampaInterventi' 			   where nome_stampa = 'STAMPA_INTERVENTI';
update cpass_t_parametro_stampa set file_name = 'regolesmistamentoRms' 		   where nome_stampa = 'REGOLE_SMISTAMENTO_RMS';
update cpass_t_parametro_stampa set file_name = 'reportSintetico'              where nome_stampa = 'CONSULTAZIONI_REPORT_SINTETICO';
update cpass_t_parametro_stampa set file_name = 'reportDettaglio' where nome_stampa = 'CONSULTAZIONI_REPORT_DETTAGLIATO';
update cpass_t_parametro_stampa set file_name = 'stampaInterventi' 			where nome_stampa = 'STAMPA_INTERVENTI';
update cpass_t_parametro_stampa set file_name = 'copiafornitore' 					where nome_stampa = 'PRT_T_ORD';
update cpass_t_parametro_stampa set file_name = 'verbaleConsegna' 				where nome_stampa = 'VERBALE_CONSEGNA';
update cpass_t_parametro_stampa set file_name = 'allegatoII' 				where nome_stampa = 'ALLEGATO_II';
update cpass_t_parametro_stampa set multiplo = true 				where nome_stampa ='VERBALE_CONSEGNA';
update cpass_t_parametro_stampa set multiplo = false 				where nome_stampa !='VERBALE_CONSEGNA';

INSERT INTO cpass.cpass_d_ruolo(ruolo_codice, ruolo_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
	('ADMIN_ENTE', 'AMMINISTRATORE ENTE')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_ruolo dr
	WHERE dr.ruolo_codice = tmp.codice
);
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('ADMIN_ENTE','INS_ORDINE'),
	('ADMIN_ENTE','INS_DETT_ORDINE'),
	('ADMIN_ENTE','MOD_ORDINE'),
	('ADMIN_ENTE','MOD_DETT_ORDINE'),
	('ADMIN_ENTE','CANC_ORDINE'),
	('ADMIN_ENTE','CANC_DETT_ORDINE'),
	('ADMIN_ENTE','ANN_ORDINE'),
	('ADMIN_ENTE','CONTROLLA_ORDINE'),
	('ADMIN_ENTE','CONFERMA_ORDINE'),
	('ADMIN_ENTE','AUTORIZZA_ORDINE'),
	('ADMIN_ENTE','INVIA_ORDINE_A_NSO'),
	('ADMIN_ENTE','CHIUDI_ORDINE'),
	('ADMIN_ENTE','INS_EVASIONE'),
	('ADMIN_ENTE','MOD_EVASIONE'),
	('ADMIN_ENTE','CANC_EVASIONE'),
	('ADMIN_ENTE','CANC_DETT_EVASIONE'),
	('ADMIN_ENTE','AUTORIZZA_EVASIONE'),
	('ADMIN_ENTE','ANN_EVASIONE'),
	('ADMIN_ENTE','INVIA_EVASIONE_CONTABILITA'),
	('ADMIN_ENTE','INS_DETT_EVASIONE'),
	('ADMIN_ENTE','MOD_DETT_EVASIONE'),
	('ADMIN_ENTE','CONSULTA_ORDINE'),
	('ADMIN_ENTE','CONSULTA_EVASIONE')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

delete from cpass_r_ruolo_permesso where 
ruolo_id = (select ruolo_id from cpass_d_ruolo where ruolo_codice = 'ORDINSEMPLICE')
and permesso_id in (select permesso_id from cpass_d_permesso where permesso_codice in 
					('CANC_DETT_EVASIONE', 'CANC_EVASIONE', 'CONSULTA_EVASIONE', 'INS_DETT_EVASIONE','INS_EVASIONE','MOD_DETT_EVASIONE','MOD_EVASIONE')
					);
					
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('ORDIN_SEMPLICE','CONFERMA_ORDINE')    
    ,('ORDINSEMPLICE','INS_EVASIONE')
    ,('ORDINSEMPLICE','INS_DETT_EVASIONE')
    ,('ORDINSEMPLICE','MOD_EVASIONE')
    ,('ORDINSEMPLICE','MOD_DETT_EVASIONE')
    ,('ORDINSEMPLICE','CANC_EVASIONE')
    ,('ORDINSEMPLICE','CANC_DETT_EVASIONE')
    ,('ORDINSEMPLICE','CONSULTA_EVASIONE')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);