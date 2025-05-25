---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================


--drop table if exists cpass_r_modulo_ruolo_permesso;


create table if not EXISTS cpass_r_modulo_ruolo_permesso (
modulo_ruolo_permesso_id serial 
,modulo_id integer    not null
,ruolo_id integer    not null
,permesso_id integer    not null
,note varchar(1000)

	,CONSTRAINT pk_cpass_r_modulo_ruolo_permesso_pkey PRIMARY KEY (modulo_ruolo_permesso_id)
 
	,CONSTRAINT fk_modulo_id FOREIGN KEY (modulo_id)
        REFERENCES cpass.cpass_d_modulo (modulo_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION	
	
 ,CONSTRAINT fk_ruolo_id FOREIGN KEY (ruolo_id)
        REFERENCES cpass.cpass_d_ruolo (ruolo_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION	
 ,CONSTRAINT fk_permesso_id FOREIGN KEY (permesso_id)
        REFERENCES cpass.cpass_d_permesso (permesso_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION	
	
	
);

/*
select modulo_id, ruolo_id, permesso_id ,count(*) from cpass_r_modulo_ruolo_permesso
group by modulo_id, ruolo_id, permesso_id order by 1,2,3
;

select * from cpass_r_modulo_ruolo_permesso;
delete from cpass_r_modulo_ruolo_permesso  
where MODULO_RUOLO_PERMESSO_ID > 155;
*/

ALTER TABLE  cpass.cpass_r_modulo_ruolo_permesso
    DRoP CONSTRAINT if exists idx_modulo_ruolo_permesso_unique;
   
ALTER TABLE  cpass.cpass_r_modulo_ruolo_permesso
    ADD CONSTRAINT  idx_modulo_ruolo_permesso_unique UNIQUE (modulo_id, ruolo_id, permesso_id);

    INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo
FROM (VALUES
  ('AGG_ODS', 'Aggiornamento massvo ODS', 'BO', true, 'V')
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_permesso ds
  WHERE ds.permesso_codice = tmp.codice
);

/*
delete  from  cpass_r_modulo_ruolo_permesso;
insert into cpass_r_modulo_ruolo_permesso
(modulo_id, ruolo_id, permesso_id)
(select 
distinct
cdm.modulo_id  ,
cdr.ruolo_id ,
cdp.permesso_id  
from cpass_d_ruolo cdr  
join cpass_r_ruolo_permesso crrp on crrp.ruolo_id = cdr.ruolo_id 
join cpass_d_permesso cdp on cdp.permesso_id = crrp.permesso_id 
join cpass_r_ruolo_modulo crrm on crrm.ruolo_id = cdr.ruolo_id 
join cpass_d_modulo cdm on cdm.modulo_id = crrm.modulo_id 
where cdr.selezionabile_da_procedura = 'SI'
order by 1,2,3
);

*/
   
 





INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
('ADMIN_ENTE','AGG_ODS'),
('ADMIN', 'AGG_ODS')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

INSERT INTO cpass.cpass_r_modulo_ruolo_permesso (modulo_id, ruolo_id, permesso_id)
SELECT dm.modulo_id, dr.ruolo_id, dp.permesso_id
FROM (VALUES
('BO', 'ADMIN_ENTE','AGG_ODS'),
('BO','ADMIN', 'AGG_ODS')
) AS tmp(modulo,ruolo, permesso)
JOIN cpass.cpass_d_modulo dm ON dm.modulo_codice = tmp.modulo
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_modulo_ruolo_permesso rmrp
	WHERE rmrp.modulo_id = dm.modulo_id
	AND rmrp.ruolo_id = dr.ruolo_id
	AND rmrp.permesso_id = dp.permesso_id
);

BEGIN;
DELETE FROM cpass_r_ruolo_modulo
WHERE ruolo_id = (SELECT ruolo_id FROM cpass_d_ruolo WHERE ruolo_codice = 'GESTORE_BUDGET');
DELETE FROM cpass_d_ruolo
WHERE ruolo_codice = 'GESTORE_BUDGET';
COMMIT;


     ALTER TABLE cpass.cpass_t_settore_indirizzo ALTER COLUMN indirizzo SET NOT NULL;     
     ALTER TABLE cpass.cpass_t_settore_indirizzo ALTER COLUMN num_civico SET NOT NULL;
     ALTER TABLE cpass.cpass_t_settore_indirizzo ALTER COLUMN provincia SET NOT NULL;
     ALTER TABLE cpass.cpass_t_settore_indirizzo ALTER COLUMN cap SET NOT NULL;
     ALTER TABLE cpass.cpass_t_settore_indirizzo ALTER COLUMN localita SET NOT NULL;     
   --update cpass_t_settore_indirizzo set provincia = 'TO' where provincia is null;

-- DROP FUNCTION cpass.pck_cpass_pba_rep_interventi_risorse(varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar);

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_interventi_risorse(p_programma_id character varying, p_cup character varying, p_settore_interventi character varying, p_struttura_id character varying, p_cpv_id character varying, p_cognome character varying, p_descri character varying, p_acq_non_rip character varying, p_vers_defin character varying, p_visto_rag character varying, p_elem_dipend character varying, p_order character varying)
 RETURNS TABLE(id_allegato_scheda integer, intervento_cui character varying, intervento_anno_avvio integer, intervento_cup character varying, intervento_ricompreso_cui character varying, intervento_stato character varying, ricompreso_tipo_codice character varying, ricompreso_tipo_descrizione character varying, intervento_lotto_funzionale boolean, nuts_codice character varying, nuts_descrizione character varying, settore_interventi_codice character varying, settore_interventi_descrizione character varying, cpv_codice character varying, cpv_descrizione character varying, intervento_descrizione_acquisto character varying, priorita_codice character varying, priorita_descrizione character varying, utente_nome character varying, utente_cognome character varying, utente_codice_fiscale character varying, intervento_durata_mesi integer, intervento_nuovo_affid boolean, ausa character varying, ausa_descrizione character varying, acquisto_variato_codice character varying, acquisto_variato_descrizione character varying, programma_id uuid, programma_anno integer, ente_id uuid, ente_codice_fiscale character varying, ente_denominazione character varying, importo_anno_primo numeric, importo_anno_secondo numeric, importo_anno_terzo numeric, importo_anni_successivi numeric, totale_importi numeric, risorsa character varying, tipologia character varying, settore_codice character varying, settore_descrizione character varying, motivazione_non_riproposto character varying, codice_interno character varying, note character varying, fondi_pnrr boolean, avviato boolean, data_avvio timestamp without time zone, utente_avvio_nome character varying, utente_avvio_cognome character varying, versione_definitiva boolean, visto_ragioneria boolean, data_visto_ragioneria timestamp without time zone, utente_visto_nome character varying, utente_visto_cognome character varying, cui_lotto_riferimento character varying, tipo_procedura character varying)
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
  	p_order := 'intervento.intervento_cui';
  end if;  



 

--return query
stringa_sql :='
WITH  importi_cap_privati AS (
    SELECT int_1.intervento_id, 
           programma_1.programma_id,
           risorsa.risorsa_id,  
           intimp.intervento_importi_importo_anno_primo as   cap_privati_importo_anno_primo,
           intimp.intervento_importi_importo_anno_secondo AS cap_privati_importo_anno_secondo,
           intimp.intervento_importi_importo_anno_terzo AS cap_privati_importo_anno_terzo,
           intimp.intervento_importi_importo_anni_successivi AS  cap_privati_importo_anni_successivi,
           intimp.intervento_importi_importo_anno_primo +
           intimp.intervento_importi_importo_anno_secondo + 
           intimp.intervento_importi_importo_anno_terzo + 
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
        ,importi_cap_privati.cap_privati_importo_anno_terzo importo_anno_terzo
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

alter table cpass_t_elaborazione add column if not exists num_elaborazione_di_giornata integer default 0;
alter table cpass_t_elaborazione add column  if not exists  data_elaborazione_di_giornata varchar(50);


delete from cpass_t_parametro where chiave ='report.endpoint'; 
delete from cpass_t_parametro where chiave ='report.multi.endpoint'; 

update cpass_t_parametro set valore = '/appserv/jboss/awf230/certs/ACSI.p12' where chiave = 'KEYSTORE_PATH_NOTIER';
update cpass_t_parametro set valore = 'podvc-proxy.site03.nivolapiemonte.it' where chiave = 'PROXY_HOSTNAME_NOTIER';


 




CREATE OR REPLACE VIEW cpass.cpass_v_dba_all_functions
AS SELECT n.nspname AS f_schema,
    format('%I'::text, p.proname) AS f_name,
    pg_get_function_result(p.oid) AS f_result_data_type,
    pg_get_function_arguments(p.oid) AS f_argument_data_type,
        CASE
            WHEN p.prorettype = 'trigger'::regtype::oid THEN 'trigger'::text
            ELSE 'normal'::text
        END AS f_type,
    p.prosrc AS f_source_code
   FROM pg_proc p
     LEFT JOIN pg_namespace n ON n.oid = p.pronamespace
  WHERE pg_function_is_visible(p.oid) AND n.nspname <> 'pg_catalog'::name AND n.nspname <> 'information_schema'::name
  ORDER BY n.nspname, (format('%I'::text, p.proname)), (pg_get_function_arguments(p.oid));

 
-- cpass.cpass_v_dba_queries_lente source

CREATE OR REPLACE VIEW cpass.cpass_v_dba_queries_lente
AS SELECT a.query,
    round(a.total_exec_time::numeric, 2) AS tot_millisecondi,
    round(round(round(a.total_exec_time::numeric, 2) / 1000::numeric, 2) / 60::numeric, 2) AS tot_minuti,
    round(round(a.total_exec_time::numeric, 2) / 1000::numeric, 2) AS tot_secondi,
    round(round(round(a.total_exec_time::numeric, 2) / 1000::numeric, 2) / a.calls::numeric, 2) AS secondi_per_esecuzione,
    a.calls AS esecuzioni
   FROM pg_stat_statements a
  WHERE (a.total_exec_time / 1000::double precision) > 1::double precision
  ORDER BY (round(round(round(a.total_exec_time::numeric, 2) / 1000::numeric, 2) / a.calls::numeric, 2)) DESC;


