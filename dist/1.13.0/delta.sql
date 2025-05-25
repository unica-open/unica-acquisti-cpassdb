---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================

alter table cpass.cpass_d_ord_tipo_procedura add column if not exists ente_id UUID;
ALTER TABLE IF EXISTS cpass.cpass_d_ord_tipo_procedura DROP CONSTRAINT IF EXISTS fk_cpass_d_ord_tipo_procedura_ente;
ALTER TABLE cpass.cpass_d_ord_tipo_procedura ADD CONSTRAINT fk_cpass_d_ord_tipo_procedura_ente FOREIGN KEY (ente_id) REFERENCES cpass_t_ente (ente_id);
ALTER TABLE cpass_d_ord_tipo_procedura DROP CONSTRAINT if exists cpass_d_ord_tipo_procedura_unique; 
ALTER TABLE cpass_d_ord_tipo_procedura ADD CONSTRAINT cpass_d_ord_tipo_procedura_unique UNIQUE (tipo_procedura_codice,ente_id);

CREATE TABLE if not exists cpass.cpass_d_pba_tipo_procedura (
  tipo_procedura_id SERIAL,
  tipo_procedura_codice VARCHAR(50) NOT NULL,
  tipo_procedura_descrizione VARCHAR(500) NOT NULL,
  ente_id UUID not NULL,
  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  optlock UUID DEFAULT uuid_generate_v4() NOT NULL,
  CONSTRAINT cpass_d_pba_tipo_procedura_pkey PRIMARY KEY(tipo_procedura_id)
); 

ALTER TABLE IF EXISTS cpass.cpass_d_pba_tipo_procedura DROP CONSTRAINT IF EXISTS fk_cpass_d_pba_tipo_procedura_ente;
ALTER TABLE cpass.cpass_d_pba_tipo_procedura ADD CONSTRAINT fk_cpass_d_pba_tipo_procedura_ente FOREIGN KEY (ente_id) REFERENCES cpass_t_ente (ente_id);

ALTER TABLE cpass.cpass_d_pba_tipo_procedura DROP CONSTRAINT if exists cpass_d_pba_tipo_procedura_unique; 
ALTER TABLE cpass.cpass_d_pba_tipo_procedura ADD CONSTRAINT cpass_d_pba_tipo_procedura_unique UNIQUE (tipo_procedura_codice,ente_id);

CREATE TABLE if not exists cpass.cpass_t_gestione_campo (
     gestione_campo_id      SERIAL
    ,nome_campo             varchar(200)
    ,visibile               BOOLEAN
    ,obbligatorio_ins       BOOLEAN
    ,obbligatorio_upd       BOOLEAN    
    ,editabile         		BOOLEAN
    ,note 			        varchar(2000)
    ,ente_id                UUID
);

ALTER TABLE IF EXISTS cpass.cpass_t_gestione_campo DROP CONSTRAINT IF EXISTS fk_cpass_t_gestione_campo_ente;
ALTER TABLE cpass.cpass_t_gestione_campo ADD CONSTRAINT fk_cpass_t_gestione_campo_ente FOREIGN KEY (ente_id) REFERENCES cpass_t_ente (ente_id);

ALTER TABLE cpass.cpass_t_pba_intervento add column if not exists tipo_procedura_id INTEGER;		
ALTER TABLE IF EXISTS cpass.CPASS_T_PBA_INTERVENTO DROP CONSTRAINT IF EXISTS fk_CPASS_T_PBA_INTERVENTO_tipo_procedura;
ALTER TABLE IF EXISTS cpass.CPASS_T_PBA_INTERVENTO ADD CONSTRAINT fk_CPASS_T_PBA_INTERVENTO_tipo_procedura FOREIGN KEY (tipo_procedura_id)
REFERENCES cpass.cpass_d_pba_tipo_procedura(tipo_procedura_id);
	

	INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo, disattivabile, attivo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo, tmp.disattivabile, tmp.attivo
FROM (VALUES
	('EDIT_INT_TIPO_PROCEDURA','Possibilita'' di gestire il campo tipo procedura dell''intervento','INTERVENTI',false,'F', 'SI', true),
	('EDIT_INT_ACQ_AGGIUNTO_O_VARIATO','Possibilita'' di gestire il campo tipo procedura dell''intervento','INTERVENTI',false,'F', 'SI', true),
	('SVINCOLA_INT_ACQ_AGGIUNTO_O_VARIATO','Toglie l''obbligatorieta'' dal campo tipo procedura dell''intervento','INTERVENTI',false,'F', 'SI', true)
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo, disattivabile, attivo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );
    
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('COMPILATORE','EDIT_INT_TIPO_PROCEDURA'),
	('DELEGATO_RUP','EDIT_INT_TIPO_PROCEDURA'),
	('RUP','EDIT_INT_TIPO_PROCEDURA'),
	('ADMIN','EDIT_INT_TIPO_PROCEDURA'),
	('DELEGATO_REFP','EDIT_INT_TIPO_PROCEDURA'),
	('REFP','EDIT_INT_TIPO_PROCEDURA'),
	('COMPILATORE','EDIT_INT_ACQ_AGGIUNTO_O_VARIATO'),
	('DELEGATO_RUP','EDIT_INT_ACQ_AGGIUNTO_O_VARIATO'),
	('RUP','EDIT_INT_ACQ_AGGIUNTO_O_VARIATO'),
	('ADMIN','EDIT_INT_ACQ_AGGIUNTO_O_VARIATO'),
	('DELEGATO_REFP','EDIT_INT_ACQ_AGGIUNTO_O_VARIATO'),
	('REFP','EDIT_INT_ACQ_AGGIUNTO_O_VARIATO'),	
	('REFP','SVINCOLA_INT_ACQ_AGGIUNTO_O_VARIATO'),
	('DELEGATO_REFP','SVINCOLA_INT_ACQ_AGGIUNTO_O_VARIATO'),
	('ADMIN','SVINCOLA_INT_ACQ_AGGIUNTO_O_VARIATO')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);


ALTER TABLE cpass_t_fornitore DROP CONSTRAINT if exists cpass_t_fornitore_unique; 
ALTER TABLE cpass_t_fornitore ADD CONSTRAINT cpass_t_fornitore_unique UNIQUE (codice,ente_id);

drop function if exists cpass.pck_cpass_pba_rep_interventi_risorse(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
drop function if exists cpass.pck_cpass_pba_rep_interventi_risorse(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_interventi_risorse(p_programma_id character varying, p_cup character varying, p_settore_interventi character varying, p_struttura_id character varying, p_cpv_id character varying, p_cognome character varying, p_descri character varying, p_acq_non_rip character varying, p_vers_defin character varying, p_visto_rag character varying, p_elem_dipend character varying, p_order character varying)
 RETURNS TABLE(id_allegato_scheda integer, intervento_cui character varying, intervento_anno_avvio integer, intervento_cup character varying, intervento_ricompreso_cui character varying, intervento_stato character varying, ricompreso_tipo_codice character varying, ricompreso_tipo_descrizione character varying, intervento_lotto_funzionale boolean, nuts_codice character varying, nuts_descrizione character varying, settore_interventi_codice character varying, settore_interventi_descrizione character varying, cpv_codice character varying, cpv_descrizione character varying, intervento_descrizione_acquisto character varying, priorita_codice character varying, priorita_descrizione character varying, utente_nome character varying, utente_cognome character varying, utente_codice_fiscale character varying, intervento_durata_mesi integer, intervento_nuovo_affid boolean, ausa character varying, ausa_descrizione character varying, acquisto_variato_codice character varying, acquisto_variato_descrizione character varying, programma_id uuid, programma_anno integer, ente_id uuid, ente_codice_fiscale character varying, ente_denominazione character varying, importo_anno_primo numeric, importo_anno_secondo numeric, importo_anni_successivi numeric, totale_importi numeric, risorsa character varying, tipologia character varying, settore_codice character varying, settore_descrizione character varying, motivazione_non_riproposto character varying, codice_interno character varying, note character varying, fondi_pnrr boolean, avviato boolean, data_avvio timestamp without time zone, utente_avvio_nome character varying, utente_avvio_cognome character varying, versione_definitiva boolean, visto_ragioneria boolean, data_visto_ragioneria timestamp without time zone, utente_visto_nome character varying, utente_visto_cognome character varying, cui_lotto_riferimento character varying, tipo_procedura character varying)
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
		,tp.tipo_procedura_descrizione
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
       LEFT JOIN cpass_d_pba_tipo_procedura tp on intervento.tipo_procedura_id = tp.tipo_procedura_id
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
$function$
;

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
 left join  CPASS_T_UFFICIO uff on tord.ufficio_id = uff.ufficio_id
 left join  CPASS_T_SETTORE sett on tord.settore_emittente_id = sett.settore_id
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
 left join  CPASS_T_UFFICIO uff on tord.ufficio_id = uff.ufficio_id
 left join  CPASS_T_SETTORE sett on tord.settore_emittente_id = sett.settore_id
 left join  cpass_t_settore_indirizzo indirizzo_sett on sett.settore_id = indirizzo_sett.settore_id and indirizzo_sett.principale = true
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
 left join cpass_t_settore_indirizzo sett_dest_indir on  sett_dest_indir.settore_indirizzo_id = destinatario_ordine.settore_indirizzo_id
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
