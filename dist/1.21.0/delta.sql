---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
ALTER TABLE cpass.cpass_t_rms_testata_rms
  ALTER COLUMN destinatario_telefono TYPE VARCHAR(200) COLLATE pg_catalog."default";
ALTER TABLE cpass.cpass_t_rms_testata_rms
  ALTER COLUMN destinatario_email TYPE VARCHAR(200) COLLATE pg_catalog."default";

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_allegato_ii(
	p_programma_id character varying)
    RETURNS TABLE(id_allegato_scheda integer, intervento_cui character varying, intervento_anno_avvio integer, intervento_cup character varying, ricompreso_tipo_codice character varying, ricompreso_tipo_descrizione character varying, intervento_lotto_funzionale boolean, nuts_codice character varying, nuts_descrizione character varying, settore_interventi_codice character varying, settore_interventi_descrizione character varying, cpv_codice character varying, cpv_descrizione character varying, intervento_descrizione_acquisto character varying, priorita_codice character varying, priorita_descrizione character varying, utente_nome character varying, utente_cognome character varying, utente_codice_fiscale character varying, intervento_durata_mesi integer, intervento_nuovo_affid boolean, intervento_copia_tipo character varying, motivazione_non_riproposto character varying, ausa character varying, ausa_descrizione character varying, acquisto_variato_codice character varying, acquisto_variato_descrizione character varying, programma_id uuid, programma_anno integer, ente_id uuid, ente_codice_fiscale character varying, ente_denominazione character varying, importo_anno_primo numeric, importo_anno_secondo numeric, importo_anni_successivi numeric, totale_importi numeric, cap_privati_importo_anno_primo numeric, cap_privati_importo_anno_secondo numeric, cap_privati_importo_anni_successivi numeric, cap_privati_totale_importi numeric, descrizione_risorsa character varying, tipologia character varying, importo_tutta_fila numeric, intervento_capofila_id character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
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

with iva_capofila as (
SELECT    int_1.intervento_capofila_id intervento_id,
            programma_1.programma_id,
            sum(coalesce(importiva.iva_primo_anno + importiva.iva_secondo_anno + 
            importiva.iva_terzo_anno +
			importiva.iva_anni_successivi,0)) totale_iva_fila
FROM cpass_t_pba_intervento int_1
  left JOIN cpass_t_pba_intervento_altri_dati importiva ON int_1.intervento_id = importiva.intervento_id     
  JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
  GROUP BY int_1.intervento_capofila_id, programma_1.programma_id),
importi_capofila AS (
SELECT      --coalesce(int_1.intervento_capofila_id,null,int_1.intervento_id) intervento_capofila_id,
            int_1.intervento_capofila_id,
            programma_1.programma_id,
            sum(intimp.intervento_importi_importo_anno_primo + 
			intimp.intervento_importi_importo_anno_secondo + 
			intimp.intervento_importi_importo_anni_successivi) as totale_importi_fila
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
                intimp.intervento_importi_importo_anni_successivi) AS totale_importi,
			coalesce(iva.iva_primo_anno + iva.iva_secondo_anno + iva.iva_anni_successivi,0) totale_iva
FROM cpass_t_pba_intervento int_1
             JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id =  intimp.intervento_id
             JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id =  programma_1.programma_id
            JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id =  risorsa.risorsa_id AND risorsa.risorsa_tipo::text = 'BILANCIO'::text
			left join cpass_t_pba_intervento_altri_dati iva on iva.intervento_id = int_1.intervento_id
 GROUP BY int_1.intervento_id, programma_1.programma_id,
 iva.iva_primo_anno ,iva.iva_secondo_anno , iva.iva_anni_successivi),
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
        --,''::character varying descrizione_risorsa CPASS-1013 Haitham 01/03/2023
        ,risorsa.risorsa_codice descrizione_risorsa --CPASS-1013 Haitham 01/03/2023
        ,risorsa.risorsa_tipo tipologia --        ,'CAPITALE PRIVATO'::character varying AS tipologia
        --,importi_capofila.totale_importi_fila totale_importi_fila
        ,0.00
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
     left JOIN iva_capofila  ON "int".programma_id = iva_capofila.programma_id AND "int".intervento_capofila_id = iva_capofila.intervento_id       
     where
     	programma.programma_id = p_programma_id::UUID
		--programma.programma_id = '738256f6-c02f-5578-b86c-7616d403b3b6'
     and (("int".intervento_capofila_id is null and ((importi.totale_importi - totale_iva) >= v_valoresoglia)) or
          ("int".intervento_capofila_id is not null and (importi_capofila.totale_importi_fila - iva_capofila.totale_iva_fila >= v_valoresoglia))
         );

exception
	when no_data_found THEN
		raise notice 'Nessun dato trovato';
		return;
	when others  THEN
		RAISE EXCEPTION '% Errore : %-%.',RTN_MESSAGGIO,SQLSTATE,substring(SQLERRM from 1 for 500);
		return;

END;
$BODY$;


CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_allegato_ii_triennale(
	p_programma_id character varying)
    RETURNS TABLE(id_allegato_scheda integer, intervento_cui character varying, intervento_anno_avvio integer, intervento_cup character varying, ricompreso_tipo_codice character varying, ricompreso_tipo_descrizione character varying, intervento_lotto_funzionale boolean, nuts_codice character varying, nuts_descrizione character varying, settore_interventi_codice character varying, settore_interventi_descrizione character varying, cpv_codice character varying, cpv_descrizione character varying, intervento_descrizione_acquisto character varying, priorita_codice character varying, priorita_descrizione character varying, utente_nome character varying, utente_cognome character varying, utente_codice_fiscale character varying, intervento_durata_mesi integer, intervento_nuovo_affid boolean, intervento_copia_tipo character varying, motivazione_non_riproposto character varying, ausa character varying, ausa_descrizione character varying, acquisto_variato_codice character varying, acquisto_variato_descrizione character varying, programma_id uuid, programma_anno integer, anno_fine_programma integer, ente_id uuid, ente_codice_fiscale character varying, ente_denominazione character varying, importo_anno_primo numeric, importo_anno_secondo numeric, importo_anno_terzo numeric, importo_anni_successivi numeric, totale_importi numeric, cap_privati_importo_anno_primo numeric, cap_privati_importo_anno_secondo numeric, cap_privati_importo_anno_terzo numeric, cap_privati_importo_anni_successivi numeric, cap_privati_totale_importi numeric, descrizione_risorsa character varying, tipologia character varying, importo_tutta_fila numeric, intervento_capofila_id character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
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
with iva_capofila as (
SELECT    int_1.intervento_capofila_id intervento_id,
            programma_1.programma_id,
            sum(coalesce(importiva.iva_primo_anno + importiva.iva_secondo_anno + 
            importiva.iva_terzo_anno +
			importiva.iva_anni_successivi,0)) totale_iva_fila
FROM cpass_t_pba_intervento int_1
  left JOIN cpass_t_pba_intervento_altri_dati importiva ON int_1.intervento_id = importiva.intervento_id     
  JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
  GROUP BY int_1.intervento_capofila_id, programma_1.programma_id),
importi_capofila AS (
SELECT      int_1.intervento_capofila_id,
            programma_1.programma_id,
            sum(intimp.intervento_importi_importo_anno_primo + 
			    intimp.intervento_importi_importo_anno_secondo + 
				intimp.intervento_importi_importo_anno_terzo + 
				intimp.intervento_importi_importo_anni_successivi) as totale_importi_fila
FROM cpass_t_pba_intervento int_1
  JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id = intimp.intervento_id
  JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
  JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id = risorsa.risorsa_id  AND risorsa.risorsa_tipo::text != 'CAPITALE PRIVATO'::text
  GROUP BY int_1.intervento_capofila_id, programma_1.programma_id),
importi AS (
SELECT      int_1.intervento_id,
            programma_1.programma_id,
            sum(intimp.intervento_importi_importo_anno_primo)      AS importo_anno_primo,
            sum(intimp.intervento_importi_importo_anno_secondo)    AS importo_anno_secondo,
            sum(intimp.intervento_importi_importo_anno_terzo)    AS importo_anno_terzo,
            sum(intimp.intervento_importi_importo_anni_successivi) AS importo_anni_successivi,
            sum(intimp.intervento_importi_importo_anno_primo +
                intimp.intervento_importi_importo_anno_secondo +
                intimp.intervento_importi_importo_anno_terzo  +
                intimp.intervento_importi_importo_anni_successivi) AS totale_importi,
			coalesce(iva.iva_primo_anno + iva.iva_secondo_anno + iva.iva_terzo_anno + iva.iva_anni_successivi,0) totale_iva	
FROM cpass_t_pba_intervento int_1
             JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id =  intimp.intervento_id
             JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id =  programma_1.programma_id
             JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id =  risorsa.risorsa_id AND risorsa.risorsa_tipo::text = 'BILANCIO'::text
             left join cpass_t_pba_intervento_altri_Dati iva on (iva.intervento_id = int_1.intervento_id)
 GROUP BY int_1.intervento_id, programma_1.programma_id,iva.iva_primo_anno,iva.iva_secondo_anno,iva.iva_terzo_anno,iva.iva_anni_successivi),
importi_cap_privati AS (
     SELECT int_1.intervento_id,
            programma_1.programma_id,
            risorsa.risorsa_id,
            sum(intimp.intervento_importi_importo_anno_primo)      AS cap_privati_importo_anno_primo,
            sum(intimp.intervento_importi_importo_anno_secondo)    AS cap_privati_importo_anno_secondo,
            sum(intimp.intervento_importi_importo_anno_terzo)    AS cap_privati_importo_anno_terzo,
            sum(intimp.intervento_importi_importo_anni_successivi) AS cap_privati_importo_anni_successivi,
            sum(intimp.intervento_importi_importo_anno_primo +
                intimp.intervento_importi_importo_anno_secondo +
                intimp.intervento_importi_importo_anno_terzo  +
                intimp.intervento_importi_importo_anni_successivi) AS cap_privati_totale_importi
    FROM cpass_t_pba_intervento int_1
             JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id =   intimp.intervento_id
             JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id =     programma_1.programma_id
             JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id =  risorsa.risorsa_id AND risorsa.risorsa_tipo::text = 'CAPITALE PRIVATO'::text
			 LEFT JOIN cpass_t_pba_intervento_altri_dati iva on iva.intervento_id = int_1.intervento_id
			 left join iva_capofila on (iva_capofila.intervento_id = int_1.intervento_id)
    GROUP BY int_1.intervento_id, programma_1.programma_id, risorsa.risorsa_id
    )
    select distinct
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
        ,programma.anno_fine_programma 
        ,ente.ente_id
        ,ente.ente_codice_fiscale
        ,ente.ente_denominazione
        ,importi.importo_anno_primo importo_anno_primo
        ,importi.importo_anno_secondo importo_anno_secondo
        ,importi.importo_anno_terzo importo_anno_terzo
        ,importi.importo_anni_successivi  importo_anni_successivi
        ,importi.totale_importi totale_importi
        ,importi_cap_privati.cap_privati_importo_anno_primo cap_privati_importo_anno_primo
        ,importi_cap_privati.cap_privati_importo_anno_secondo cap_privati_importo_anno_secondo
        ,importi_cap_privati.cap_privati_importo_anno_terzo cap_privati_importo_anno_terzo
        ,importi_cap_privati.cap_privati_importo_anni_successivi cap_privati_importo_anni_successivi
        ,importi_cap_privati.cap_privati_totale_importi cap_privati_totale_importi
        ,risorsa.risorsa_codice descrizione_risorsa --CPASS-1013 Haitham 01/03/2023
        ,risorsa.risorsa_tipo tipologia --        ,'CAPITALE PRIVATO'::character varying AS tipologia
        ,0.00
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
       left JOIN iva_capofila  ON "int".programma_id = iva_capofila.programma_id AND "int".intervento_capofila_id = iva_capofila.intervento_id       
     where
     	programma.programma_id = p_programma_id::UUID
     and (("int".intervento_capofila_id is null and ((importi.totale_importi - totale_iva) >= v_valoresoglia)) or
          ("int".intervento_capofila_id is not null and (importi_capofila.totale_importi_fila - iva_capofila.totale_iva_fila >= v_valoresoglia))
         );

exception
	when no_data_found THEN
		raise notice 'Nessun dato trovato';
		return;
	when others  THEN
		RAISE EXCEPTION '% Errore : %-%.',RTN_MESSAGGIO,SQLSTATE,substring(SQLERRM from 1 for 500);
		return;

END;
$BODY$;


CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_soggetti_aggregatori(
	p_programma_id character varying)
    RETURNS TABLE(id_allegato_scheda integer, intervento_cui character varying, intervento_anno_avvio integer, intervento_cup character varying, ricompreso_tipo_codice character varying, ricompreso_tipo_descrizione character varying, intervento_lotto_funzionale boolean, nuts_codice character varying, nuts_descrizione character varying, settore_interventi_codice character varying, settore_interventi_descrizione character varying, cpv_codice character varying, cpv_descrizione character varying, intervento_descrizione_acquisto character varying, priorita_codice character varying, priorita_descrizione character varying, utente_nome character varying, utente_cognome character varying, utente_codice_fiscale character varying, intervento_durata_mesi integer, intervento_nuovo_affid boolean, ausa character varying, ausa_descrizione character varying, acquisto_variato_codice character varying, acquisto_variato_descrizione character varying, programma_id uuid, programma_anno integer, ente_id uuid, ente_codice_fiscale character varying, ente_denominazione character varying, importo_anno_primo numeric, importo_anno_secondo numeric, importo_anni_successivi numeric, totale_importi numeric, cap_privati_importo_anno_primo numeric, cap_privati_importo_anno_secondo numeric, cap_privati_importo_anni_successivi numeric, cap_privati_totale_importi numeric, tipologia character varying, importo_tutta_fila numeric, intervento_capofila_id character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE

RTN_MESSAGGIO text;

BEGIN

	
return query
WITH importi_capofila AS (
select inter.intervento_capofila_id,
       inter.programma_id,
sum (imp1.intervento_importi_importo_anno_primo +
     imp1.intervento_importi_importo_anno_secondo +
	 imp1.intervento_importi_importo_anni_successivi) as lordo_totale_importi_fila
from  cpass_t_pba_intervento inter
join  cpass_t_pba_intervento_importi imp1 on imp1.intervento_id = inter.intervento_id
where inter.intervento_lotto_funzionale = true
and   inter.programma_id = p_programma_id::UUID
group by inter.intervento_capofila_id, inter.programma_id),
 importi_capofila_iva AS (
select inter.intervento_capofila_id ,
       inter.programma_id,
sum (coalesce(importiva.iva_primo_anno,null,0) + 
     coalesce(importiva.iva_secondo_anno,null,0) + 
     coalesce(importiva.iva_anni_successivi,null,0)) AS iva_totale_importi_fila
from  cpass_t_pba_intervento inter
left JOIN cpass_t_pba_intervento_altri_dati importiva ON inter.intervento_id = importiva.intervento_id     
where inter.intervento_lotto_funzionale = true
and   inter.programma_id = p_programma_id::UUID
group by inter.intervento_capofila_id, inter.programma_id),
importi AS (
SELECT      int_1.intervento_id,
            programma_1.programma_id,
            sum(intimp.intervento_importi_importo_anno_primo)  AS lordo_anno_primo,
            sum(intimp.intervento_importi_importo_anno_secondo) as lordo_anno_secondo,
            sum(intimp.intervento_importi_importo_anni_successivi) as lordo_anni_successivi,
            sum(intimp.intervento_importi_importo_anno_primo + intimp.intervento_importi_importo_anno_secondo + intimp.intervento_importi_importo_anni_successivi) as lordo_totale_importi,
            coalesce(importiva.iva_primo_anno,null,0) as iva_anno_primo,
            coalesce(importiva.iva_secondo_anno,null,0) as iva_anno_secondo,
            coalesce(importiva.iva_anni_successivi,null,0) as iva_anni_successivi,
            (coalesce(importiva.iva_primo_anno,null,0) + coalesce(importiva.iva_secondo_anno,null,0) + coalesce(importiva.iva_anni_successivi,null,0)) AS iva_totale_importi
FROM cpass_t_pba_intervento int_1
  JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id = intimp.intervento_id
  left JOIN cpass_t_pba_intervento_altri_dati importiva ON int_1.intervento_id = importiva.intervento_id     
  JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
  JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id = risorsa.risorsa_id
   AND risorsa.risorsa_tipo::text != 'CAPITALE PRIVATO'::text
GROUP BY int_1.intervento_id, programma_1.programma_id,  importiva.iva_primo_anno, importiva.iva_secondo_anno, importiva.iva_anni_successivi),
importi_cap_privati AS (
    SELECT int_1.intervento_id,
           programma_1.programma_id,
		   risorsa.risorsa_codice,
           sum(intimp.intervento_importi_importo_anno_primo) AS cap_privati_importo_anno_primo,
           sum(intimp.intervento_importi_importo_anno_secondo) AS cap_privati_importo_anno_secondo,
           sum(intimp.intervento_importi_importo_anni_successivi) AS cap_privati_importo_anni_successivi,
           sum(intimp.intervento_importi_importo_anno_primo +
               intimp.intervento_importi_importo_anno_secondo +
               intimp.intervento_importi_importo_anni_successivi) AS cap_privati_totale_importi
    FROM cpass_t_pba_intervento int_1
    JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id = intimp.intervento_id
    JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
    JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id = risorsa.risorsa_id
									AND risorsa.risorsa_tipo::text = 'CAPITALE PRIVATO'::text
    and (
	(intimp.intervento_importi_importo_anno_primo != 0 ) or
    (intimp.intervento_importi_importo_anno_secondo !=0 ) or  
	(intimp.intervento_importi_importo_anni_successivi != 0)
    )	
    GROUP BY int_1.intervento_id, programma_1.programma_id,risorsa.risorsa_codice
    )
    select 
    	row_number() OVER ()::INTEGER AS id_allegato_scheda
        ,"int".intervento_cui
        ,"int".intervento_anno_avvio
        ,"int".intervento_cup
        ,rt.ricompreso_tipo_codice
        ,rt.ricompreso_tipo_descrizione
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
        ,ausa.ausa_codice AS ausa
        ,ausa.ausa_descrizione
        ,av.acquisto_variato_codice
        ,av.acquisto_variato_descrizione
        ,programma.programma_id
        ,programma.programma_anno
        ,ente.ente_id
        ,ente.ente_codice_fiscale
        ,ente.ente_denominazione
        ,(importi.lordo_anno_primo - importi.iva_anno_primo) importo_anno_primo
        ,(importi.lordo_anno_secondo - importi.iva_anno_secondo) importo_anno_secondo
        ,(importi.lordo_anni_successivi - importi.iva_anni_successivi) importo_anni_successivi
        ,(importi.lordo_totale_importi - importi.iva_totale_importi) totale_importi
        ,importi_cap_privati.cap_privati_importo_anno_primo
        ,importi_cap_privati.cap_privati_importo_anno_secondo
        ,importi_cap_privati.cap_privati_importo_anni_successivi
        ,importi_cap_privati.cap_privati_totale_importi  
        ,importi_cap_privati.risorsa_codice::character varying AS tipologia
        ,(importi_capofila.lordo_totale_importi_fila - importi_capofila_iva.iva_totale_importi_fila)  totale_importi_fila
        ,coalesce("int".intervento_capofila_id,null,"int".intervento_id)::varchar intervento_capofila_id
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
       left JOIN importi_capofila  ON "int".programma_id = importi_capofila.programma_id
                                    AND "int".intervento_capofila_id = importi_capofila.intervento_capofila_id
       left JOIN importi_capofila_iva  ON "int".programma_id = importi_capofila_iva.programma_id
                                    AND "int".intervento_capofila_id  = importi_capofila_iva.intervento_capofila_id
     LEFT JOIN importi_cap_privati ON "int".programma_id = importi_cap_privati.programma_id AND "int".intervento_id = importi_cap_privati.intervento_id
     where
     	 programma.programma_id = p_programma_id::UUID
     and (("int".intervento_capofila_id is null and ((importi.lordo_totale_importi - importi.iva_totale_importi) > 1000000)) or
          ("int".intervento_capofila_id is not null and "int".intervento_capofila_id = importi_capofila.intervento_capofila_id
		    and ((importi_capofila.lordo_totale_importi_fila - importi_capofila_iva.iva_totale_importi_fila) > 1000000)
         ))	 	
  --   and 	((importi.lordo_totale_importi - importi.iva_totale_importi) > 1000000 or (importi_capofila.lordo_totale_importi_fila - importi_capofila_iva.iva_totale_importi_fila)>1000000) 
     and "int".motivazione_non_riproposto is null
     ;

exception
	when no_data_found THEN
		raise notice 'Nessun dato trovato per il quadro economico';
		return;
	when others  THEN
		RAISE EXCEPTION '% Errore : %-%.',RTN_MESSAGGIO,SQLSTATE,substring(SQLERRM from 1 for 500);
		return;

END;
$BODY$;


CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_soggetti_aggregatori_triennale(
	p_programma_id character varying)
    RETURNS TABLE(id_allegato_scheda integer, intervento_cui character varying, intervento_anno_avvio integer, intervento_cup character varying, ricompreso_tipo_codice character varying, ricompreso_tipo_descrizione character varying, intervento_lotto_funzionale boolean, nuts_codice character varying, nuts_descrizione character varying, settore_interventi_codice character varying, settore_interventi_descrizione character varying, cpv_codice character varying, cpv_descrizione character varying, intervento_descrizione_acquisto character varying, priorita_codice character varying, priorita_descrizione character varying, utente_nome character varying, utente_cognome character varying, utente_codice_fiscale character varying, intervento_durata_mesi integer, intervento_nuovo_affid boolean, ausa character varying, ausa_descrizione character varying, acquisto_variato_codice character varying, acquisto_variato_descrizione character varying, programma_id uuid, programma_anno integer, ente_id uuid, ente_codice_fiscale character varying, ente_denominazione character varying, importo_anno_primo numeric, importo_anno_secondo numeric, importo_anno_terzo numeric, importo_anni_successivi numeric, totale_importi numeric, cap_privati_importo_anno_primo numeric, cap_privati_importo_anno_secondo numeric, cap_privati_importo_anno_terzo numeric, cap_privati_importo_anni_successivi numeric, cap_privati_totale_importi numeric, tipologia character varying, importo_tutta_fila numeric, intervento_capofila_id character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE

RTN_MESSAGGIO text;

BEGIN

	
return query
WITH importi_capofila AS (
select inter.intervento_capofila_id,
       inter.programma_id,
sum (imp1.intervento_importi_importo_anno_primo +
     imp1.intervento_importi_importo_anno_secondo +
     imp1.intervento_importi_importo_anno_terzo +
	 imp1.intervento_importi_importo_anni_successivi) as lordo_totale_importi_fila
from  cpass_t_pba_intervento inter
join  cpass_t_pba_intervento_importi imp1 on imp1.intervento_id = inter.intervento_id
where inter.intervento_lotto_funzionale = true
and   inter.programma_id = p_programma_id::UUID
group by inter.intervento_capofila_id, inter.programma_id),
 importi_capofila_iva AS (
select inter.intervento_capofila_id ,
       inter.programma_id,
sum (coalesce(importiva.iva_primo_anno,null,0) + 
     coalesce(importiva.iva_secondo_anno,null,0) + 
     coalesce(importiva.iva_terzo_anno,null,0)+ 
     coalesce(importiva.iva_anni_successivi,null,0)) AS iva_totale_importi_fila
from  cpass_t_pba_intervento inter
left JOIN cpass_t_pba_intervento_altri_dati importiva ON inter.intervento_id = importiva.intervento_id     
where inter.intervento_lotto_funzionale = true
and   inter.programma_id = p_programma_id::UUID
group by inter.intervento_capofila_id, inter.programma_id),
importi AS (
SELECT      int_1.intervento_id,
            programma_1.programma_id,
            sum(intimp.intervento_importi_importo_anno_primo)  AS lordo_anno_primo,
            sum(intimp.intervento_importi_importo_anno_secondo) as lordo_anno_secondo,
            sum(intimp.intervento_importi_importo_anno_terzo) as lordo_anno_terzo,
            sum(intimp.intervento_importi_importo_anni_successivi) as lordo_anni_successivi,
            sum(intimp.intervento_importi_importo_anno_primo + intimp.intervento_importi_importo_anno_secondo + intimp.intervento_importi_importo_anno_terzo + intimp.intervento_importi_importo_anni_successivi) as lordo_totale_importi,
            coalesce(importiva.iva_primo_anno,null,0) as iva_anno_primo,
            coalesce(importiva.iva_secondo_anno,null,0) as iva_anno_secondo,
            coalesce(importiva.iva_terzo_anno,null,0) as iva_anno_terzo,
            coalesce(importiva.iva_anni_successivi,null,0) as iva_anni_successivi,
            (coalesce(importiva.iva_primo_anno,null,0) + coalesce(importiva.iva_secondo_anno,null,0) + coalesce(importiva.iva_terzo_anno,null,0) + coalesce(importiva.iva_anni_successivi,null,0)) AS iva_totale_importi
FROM cpass_t_pba_intervento int_1
  JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id = intimp.intervento_id
  left JOIN cpass_t_pba_intervento_altri_dati importiva ON int_1.intervento_id = importiva.intervento_id     
  JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
  JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id = risorsa.risorsa_id
   AND risorsa.risorsa_tipo::text != 'CAPITALE PRIVATO'::text
GROUP BY int_1.intervento_id, programma_1.programma_id,  importiva.iva_primo_anno, importiva.iva_secondo_anno, importiva.iva_terzo_anno, importiva.iva_anni_successivi),
importi_cap_privati AS (
    SELECT int_1.intervento_id,
           programma_1.programma_id,
		   risorsa.risorsa_codice,
           sum(intimp.intervento_importi_importo_anno_primo) AS cap_privati_importo_anno_primo,
           sum(intimp.intervento_importi_importo_anno_secondo) AS cap_privati_importo_anno_secondo,
           sum(intimp.intervento_importi_importo_anno_terzo) AS cap_privati_importo_anno_terzo,
           sum(intimp.intervento_importi_importo_anni_successivi) AS cap_privati_importo_anni_successivi,
           sum(intimp.intervento_importi_importo_anno_primo +
               intimp.intervento_importi_importo_anno_secondo +
               intimp.intervento_importi_importo_anno_terzo +
               intimp.intervento_importi_importo_anni_successivi) AS cap_privati_totale_importi
    FROM cpass_t_pba_intervento int_1
    JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id = intimp.intervento_id
    JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
    JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id = risorsa.risorsa_id
									AND risorsa.risorsa_tipo::text = 'CAPITALE PRIVATO'::text
    and (
	(intimp.intervento_importi_importo_anno_primo != 0 ) or
    (intimp.intervento_importi_importo_anno_secondo !=0 ) or  
    (intimp.intervento_importi_importo_anno_terzo !=0 ) or  
	(intimp.intervento_importi_importo_anni_successivi != 0)
    )	
    GROUP BY int_1.intervento_id, programma_1.programma_id,risorsa.risorsa_codice
    )
    select 
    	row_number() OVER ()::INTEGER AS id_allegato_scheda
        ,"int".intervento_cui
        ,"int".intervento_anno_avvio
        ,"int".intervento_cup
        ,rt.ricompreso_tipo_codice
        ,rt.ricompreso_tipo_descrizione
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
        ,ausa.ausa_codice AS ausa
        ,ausa.ausa_descrizione
        ,av.acquisto_variato_codice
        ,av.acquisto_variato_descrizione
        ,programma.programma_id
        ,programma.programma_anno
        ,ente.ente_id
        ,ente.ente_codice_fiscale
        ,ente.ente_denominazione
        ,(importi.lordo_anno_primo - importi.iva_anno_primo) importo_anno_primo
        ,(importi.lordo_anno_secondo - importi.iva_anno_secondo) importo_anno_secondo
        ,(importi.lordo_anno_terzo - importi.iva_anno_terzo) importo_anno_terzo
        ,(importi.lordo_anni_successivi - importi.iva_anni_successivi) importo_anni_successivi
        ,(importi.lordo_totale_importi - importi.iva_totale_importi) totale_importi
        ,importi_cap_privati.cap_privati_importo_anno_primo
        ,importi_cap_privati.cap_privati_importo_anno_secondo
        ,importi_cap_privati.cap_privati_importo_anno_terzo
        ,importi_cap_privati.cap_privati_importo_anni_successivi
        ,importi_cap_privati.cap_privati_totale_importi  
        ,importi_cap_privati.risorsa_codice::character varying AS tipologia
        ,(importi_capofila.lordo_totale_importi_fila - importi_capofila_iva.iva_totale_importi_fila)  totale_importi_fila
        ,coalesce("int".intervento_capofila_id,null,"int".intervento_id)::varchar intervento_capofila_id
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
       left JOIN importi_capofila  ON "int".programma_id = importi_capofila.programma_id
                                    AND "int".intervento_capofila_id = importi_capofila.intervento_capofila_id
       left JOIN importi_capofila_iva  ON "int".programma_id = importi_capofila_iva.programma_id
                                    AND "int".intervento_capofila_id  = importi_capofila_iva.intervento_capofila_id
     LEFT JOIN importi_cap_privati ON "int".programma_id = importi_cap_privati.programma_id AND "int".intervento_id = importi_cap_privati.intervento_id
     where
     	 programma.programma_id = p_programma_id::UUID
     and (("int".intervento_capofila_id is null and ((importi.lordo_totale_importi - importi.iva_totale_importi) > 1000000)) or
          ("int".intervento_capofila_id is not null and "int".intervento_capofila_id = importi_capofila.intervento_capofila_id
		    and ((importi_capofila.lordo_totale_importi_fila - importi_capofila_iva.iva_totale_importi_fila) > 1000000)
         ))	 	
  --   and 	((importi.lordo_totale_importi - importi.iva_totale_importi) > 1000000 or (importi_capofila.lordo_totale_importi_fila - importi_capofila_iva.iva_totale_importi_fila)>1000000) 
     and "int".motivazione_non_riproposto is null
     ;

exception
	when no_data_found THEN
		raise notice 'Nessun dato trovato per il quadro economico';
		return;
	when others  THEN
		RAISE EXCEPTION '% Errore : %-%.',RTN_MESSAGGIO,SQLSTATE,substring(SQLERRM from 1 for 500);
		return;

END;
$BODY$;
-- FUNCTION: cpass.pck_cpass_ord_rep_ordini(character varying)

-- DROP FUNCTION cpass.pck_cpass_ord_rep_ordini(character varying);

CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_rep_ordini(
	p_ordine_id character varying)
    RETURNS TABLE(ordine_anno integer, ordine_numero integer, ordine_data_emis timestamp without time zone, ordine_consegna_da timestamp without time zone, ordine_consegna_a timestamp without time zone, ordine_num_procedura character varying, ordine_note character varying, ordine_provv_numero character varying, ordine_provv_anno integer, ordine_cons_rif character varying, ordine_consegna_indirizzo character varying, ordine_consegna_cap character varying, ordine_consegna_localita character varying, ordine_tipo_doc character varying, ordine_tipo_proc character varying, ufficio_codice character varying, settore_codice character varying, settore_descrizione character varying, settore_indirizzo character varying, settore_num_civico character varying, settore_cap character varying, settore_localita character varying, settore_provincia character varying, rda_anno integer, rda_numero integer, ente_codice_fiscale character varying, forn_ragione_sociale character varying, forn_indirizzo character varying, forn_numero_civico character varying, forn_cap character varying, forn_comune character varying, forn_provincia character varying, forn_codice character varying, settdest_codice character varying, settdest_descrizione character varying, dest_indirizzo character varying, dest_num_civico character varying, dest_cap character varying, dest_localita character varying, dest_provincia character varying, dest_contatto character varying, dest_email character varying, dest_telefono character varying, ogg_descrizione character varying, ogg_codice character varying, codifica_listino_fornitore character varying, unita character varying, ordine_quantita numeric, ordine_percent_sconto numeric, ordine_percent_sconto2 numeric, aliquota_iva character varying, ordine_prezzo_unitario numeric, ordine_importo_totale numeric, ordine_importo_sconto numeric, ordine_importo_sconto2 numeric, ordine_importo_netto numeric, ordine_importo_iva numeric, rigaordine_note character varying, ordine_consegna_parziale boolean, utente_nome character varying, utente_cognome character varying, utente_telefono character varying, dirigente_nome character varying, dirigente_cognome character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
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
$BODY$;


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
-- FUNCTION: cpass.pck_cpass_ord_rep_ordini_dest(character varying)

<<<<<<< HEAD
-- DROP FUNCTION cpass.pck_cpass_ord_rep_ordini_dest(character varying);

drop FUNCTION cpass.pck_cpass_ord_rep_ordini_dest(character varying);

CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_rep_ordini_dest(p_destinatario_id character varying)
 RETURNS TABLE(ordine_anno integer, ordine_numero integer, ordine_data_emis timestamp without time zone, ordine_consegna_da timestamp without time zone, ordine_consegna_a timestamp without time zone, ordine_num_procedura character varying, ordine_note character varying, ordine_provv_numero character varying, ordine_provv_anno integer, ordine_cons_rif character varying, ordine_consegna_indirizzo character varying, ordine_consegna_cap character varying, ordine_consegna_localita character varying, ordine_tipo_doc character varying, ordine_tipo_proc character varying, ufficio_codice character varying, settore_codice character varying, settore_descrizione character varying, settore_indirizzo character varying, settore_num_civico character varying, settore_cap character varying, settore_localita character varying, settore_provincia character varying, rda_anno integer, rda_numero integer, ente_codice_fiscale character varying, forn_ragione_sociale character varying, forn_indirizzo character varying, forn_numero_civico character varying, forn_cap character varying, forn_comune character varying, forn_provincia character varying, forn_codice character varying, settdest_codice character varying, settdest_descrizione character varying, dest_indirizzo character varying, dest_num_civico character varying, dest_cap character varying, dest_localita character varying, dest_provincia character varying, dest_contatto character varying, dest_email character varying, dest_telefono character varying, ogg_descrizione character varying, ogg_codice character varying, codifica_listino_fornitore character varying, unita character varying, ordine_quantita numeric, ordine_percent_sconto numeric, ordine_percent_sconto2 numeric, aliquota_iva character varying, ordine_prezzo_unitario numeric, ordine_importo_totale numeric, ordine_importo_sconto numeric, ordine_importo_sconto2 numeric, ordine_importo_netto numeric, ordine_importo_iva numeric, rigaordine_note character varying, ordine_consegna_parziale boolean, utente_nome character varying, utente_cognome character varying, utente_telefono character varying, dirigente_nome character varying, dirigente_cognome character varying, anno_protocollo integer, numero_protocollo character varying, data_scadenza timestamp without time zone)
 LANGUAGE plpgsql
AS $function$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query
select distinct tord.ordine_anno,
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
       coalesce(uff.ufficio_codice,'') , 
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
       coalesce(utente.telefono,'') ,
       utenteDir.utente_nome,
       utenteDir.utente_cognome,
       protocollo.anno_protocollo ,
       protocollo.numero_protocollo,
	   tord.data_scadenza
from   CPASS_T_ORD_TESTATA_ORDINE tord
 join  CPASS_D_ORD_TIPO_ORDINE tipoOrd on tord.tipo_ordine_id = tipoOrd.tipo_ordine_id
 join  CPASS_D_ORD_TIPO_PROCEDURA tipoProc on tord.tipo_procedura_id = tipoProc.tipo_procedura_id
 left join  CPASS_T_UFFICIO uff on tord.ufficio_id = uff.ufficio_id
 join  CPASS_T_SETTORE sett on tord.settore_emittente_id = sett.settore_id
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
 join cpass_r_ord_rda_ordine rordrda on destinatario_ordine.testata_ordine_id = rordrda.testata_ordine_id                                               
 join cpass_t_ord_testata_rda rda on rordrda.testata_rda_id = rda.testata_rda_id
 join cpass_t_ord_riga_rda riga_rda on rda.testata_rda_id = riga_rda.testata_rda_id 
 left join cpass_t_rms_riga_rms riga_rms on riga_rda.riga_rda_id = riga_rms.riga_rda_id
 join cpass_t_rms_testata_rms testata_rms on (riga_rms.testata_rms_id = testata_rms.testata_rms_id                                                                                                    
  and destinatario_ordine.settore_destinatario_id = testata_rms.settore_destinatario_id)                                                                                                 
 left join cpass_t_ord_protocollo_ordine protocollo on tord.testata_ordine_id = protocollo.testata_ordine_id 
 left join cpass_t_settore_indirizzo sett_dest_indir on  sett_dest_indir.settore_indirizzo_id = destinatario_ordine.settore_indirizzo_id
 where
    	 destinatario_ordine.destinatario_id= p_destinatario_id::UUID
		 and rordrda.testata_ordine_id is not null 
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
		)
UNION
select distinct tord.ordine_anno,
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
       coalesce(uff.ufficio_codice,'') , 
       sett.settore_codice ,
       sett.settore_descrizione , 
       coalesce(indirizzo_sett.indirizzo,'') ,
       coalesce(indirizzo_sett.num_civico,'') ,
       coalesce(indirizzo_sett.cap,'') ,
       coalesce(indirizzo_sett.localita,'') ,
       coalesce(indirizzo_sett.provincia,'') ,
       0 rda_anno,
       0 rda_numero, 
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
       coalesce(utente.telefono,'') ,
       utenteDir.utente_nome,
       utenteDir.utente_cognome,
       protocollo.anno_protocollo ,
       protocollo.numero_protocollo,
	   tord.data_scadenza
from   CPASS_T_ORD_TESTATA_ORDINE tord
 join  CPASS_D_ORD_TIPO_ORDINE tipoOrd on tord.tipo_ordine_id = tipoOrd.tipo_ordine_id
 join  CPASS_D_ORD_TIPO_PROCEDURA tipoProc on tord.tipo_procedura_id = tipoProc.tipo_procedura_id
 left join  CPASS_T_UFFICIO uff on tord.ufficio_id = uff.ufficio_id
 join  CPASS_T_SETTORE sett on tord.settore_emittente_id = sett.settore_id
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
  left join cpass_t_ord_protocollo_ordine protocollo on tord.testata_ordine_id = protocollo.testata_ordine_id 
 left join cpass_t_settore_indirizzo sett_dest_indir on  sett_dest_indir.settore_indirizzo_id = destinatario_ordine.settore_indirizzo_id
 where
    	 destinatario_ordine.destinatario_id= p_destinatario_id::UUID
 
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
		)  
and 0 = (select count(*) from cpass_r_ord_rda_ordine r where r.testata_ordine_id = tord.testata_ordine_id)
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
;
=======

drop FUNCTION cpass.pck_cpass_ord_rep_ordini_dest(character varying);

CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_rep_ordini_dest(p_destinatario_id character varying)
 RETURNS TABLE(ordine_anno integer, ordine_numero integer, ordine_data_emis timestamp without time zone, ordine_consegna_da timestamp without time zone, ordine_consegna_a timestamp without time zone, ordine_num_procedura character varying, ordine_note character varying, ordine_provv_numero character varying, ordine_provv_anno integer, ordine_cons_rif character varying, ordine_consegna_indirizzo character varying, ordine_consegna_cap character varying, ordine_consegna_localita character varying, ordine_tipo_doc character varying, ordine_tipo_proc character varying, ufficio_codice character varying, settore_codice character varying, settore_descrizione character varying, settore_indirizzo character varying, settore_num_civico character varying, settore_cap character varying, settore_localita character varying, settore_provincia character varying, rda_anno integer, rda_numero integer, ente_codice_fiscale character varying, forn_ragione_sociale character varying, forn_indirizzo character varying, forn_numero_civico character varying, forn_cap character varying, forn_comune character varying, forn_provincia character varying, forn_codice character varying, settdest_codice character varying, settdest_descrizione character varying, dest_indirizzo character varying, dest_num_civico character varying, dest_cap character varying, dest_localita character varying, dest_provincia character varying, dest_contatto character varying, dest_email character varying, dest_telefono character varying, ogg_descrizione character varying, ogg_codice character varying, codifica_listino_fornitore character varying, unita character varying, ordine_quantita numeric, ordine_percent_sconto numeric, ordine_percent_sconto2 numeric, aliquota_iva character varying, ordine_prezzo_unitario numeric, ordine_importo_totale numeric, ordine_importo_sconto numeric, ordine_importo_sconto2 numeric, ordine_importo_netto numeric, ordine_importo_iva numeric, rigaordine_note character varying, ordine_consegna_parziale boolean, utente_nome character varying, utente_cognome character varying, utente_telefono character varying, dirigente_nome character varying, dirigente_cognome character varying, anno_protocollo integer, numero_protocollo character varying, data_scadenza timestamp without time zone)
 LANGUAGE plpgsql
AS $function$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query
select distinct tord.ordine_anno,
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
       coalesce(uff.ufficio_codice,'') , 
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
       coalesce(utente.telefono,'') ,
       utenteDir.utente_nome,
       utenteDir.utente_cognome,
       protocollo.anno_protocollo ,
       protocollo.numero_protocollo,
	   tord.data_scadenza
from   CPASS_T_ORD_TESTATA_ORDINE tord
 join  CPASS_D_ORD_TIPO_ORDINE tipoOrd on tord.tipo_ordine_id = tipoOrd.tipo_ordine_id
 join  CPASS_D_ORD_TIPO_PROCEDURA tipoProc on tord.tipo_procedura_id = tipoProc.tipo_procedura_id
 left join  CPASS_T_UFFICIO uff on tord.ufficio_id = uff.ufficio_id
 join  CPASS_T_SETTORE sett on tord.settore_emittente_id = sett.settore_id
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
 join cpass_r_ord_rda_ordine rordrda on destinatario_ordine.testata_ordine_id = rordrda.testata_ordine_id                                               
 join cpass_t_ord_testata_rda rda on rordrda.testata_rda_id = rda.testata_rda_id
 join cpass_t_ord_riga_rda riga_rda on rda.testata_rda_id = riga_rda.testata_rda_id 
 left join cpass_t_rms_riga_rms riga_rms on riga_rda.riga_rda_id = riga_rms.riga_rda_id
 join cpass_t_rms_testata_rms testata_rms on (riga_rms.testata_rms_id = testata_rms.testata_rms_id                                                                                                    
  and destinatario_ordine.settore_destinatario_id = testata_rms.settore_destinatario_id)                                                                                                 
 left join cpass_t_ord_protocollo_ordine protocollo on tord.testata_ordine_id = protocollo.testata_ordine_id 
 left join cpass_t_settore_indirizzo sett_dest_indir on  sett_dest_indir.settore_indirizzo_id = destinatario_ordine.settore_indirizzo_id
 where
    	 destinatario_ordine.destinatario_id= p_destinatario_id::UUID
		 and rordrda.testata_ordine_id is not null 
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
		)
UNION
select distinct tord.ordine_anno,
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
       coalesce(uff.ufficio_codice,'') , 
       sett.settore_codice ,
       sett.settore_descrizione , 
       coalesce(indirizzo_sett.indirizzo,'') ,
       coalesce(indirizzo_sett.num_civico,'') ,
       coalesce(indirizzo_sett.cap,'') ,
       coalesce(indirizzo_sett.localita,'') ,
       coalesce(indirizzo_sett.provincia,'') ,
       0 rda_anno,
       0 rda_numero, 
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
       coalesce(utente.telefono,'') ,
       utenteDir.utente_nome,
       utenteDir.utente_cognome,
       protocollo.anno_protocollo ,
       protocollo.numero_protocollo,
	   tord.data_scadenza
from   CPASS_T_ORD_TESTATA_ORDINE tord
 join  CPASS_D_ORD_TIPO_ORDINE tipoOrd on tord.tipo_ordine_id = tipoOrd.tipo_ordine_id
 join  CPASS_D_ORD_TIPO_PROCEDURA tipoProc on tord.tipo_procedura_id = tipoProc.tipo_procedura_id
 left join  CPASS_T_UFFICIO uff on tord.ufficio_id = uff.ufficio_id
 join  CPASS_T_SETTORE sett on tord.settore_emittente_id = sett.settore_id
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
  left join cpass_t_ord_protocollo_ordine protocollo on tord.testata_ordine_id = protocollo.testata_ordine_id 
 left join cpass_t_settore_indirizzo sett_dest_indir on  sett_dest_indir.settore_indirizzo_id = destinatario_ordine.settore_indirizzo_id
 where
    	 destinatario_ordine.destinatario_id= p_destinatario_id::UUID
 
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
		)  
and 0 = (select count(*) from cpass_r_ord_rda_ordine r where r.testata_ordine_id = tord.testata_ordine_id)
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
;

>>>>>>> refs/heads/1.21.0
