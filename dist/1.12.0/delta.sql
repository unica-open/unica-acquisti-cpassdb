---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
delete from cpass.cpass_t_parametro where chiave ='CODICE_TIPO_PROVV_ANTE_STILO';

drop table if exists cpass_t_mag_indirizzo_locale;

alter table if exists cpass.cpass_t_ord_testata_evasione add column if not exists fattura_codice_ext VARCHAR(200);
select * from rename_column_if_exists('cpass_t_ord_testata_evasione', 'fattura_codice','fattura_codice_fornitore','cpass');

DROP table if  exists  CPASS_T_SETTORE_SERIE_ACTA;   
DROP table if  exists  CPASS_T_SETTORE_SERIE;  



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

v_valoresoglia numeric(9,2);

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
v_valoresoglia numeric(9,2);

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