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
CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_allegato_scheda_b (
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
  tipologia varchar
) AS
$body$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query
WITH importi AS (
SELECT      int_1.intervento_id, programma_1.programma_id,
            sum(intimp.intervento_importi_importo_anno_primo) AS importo_anno_primo,
            sum(intimp.intervento_importi_importo_anno_secondo) AS importo_anno_secondo,
            sum(intimp.intervento_importi_importo_anni_successivi) AS
                importo_anni_successivi,
            sum(intimp.intervento_importi_importo_anno_primo +
                intimp.intervento_importi_importo_anno_secondo + intimp.intervento_importi_importo_anni_successivi) AS totale_importi
FROM cpass_t_pba_intervento int_1
             JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id =
                 intimp.intervento_id
             JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id =
                 programma_1.programma_id
GROUP BY int_1.intervento_id, programma_1.programma_id
        ), importi_cap_privati AS (
    SELECT int_1.intervento_id, programma_1.programma_id,
            sum(intimp.intervento_importi_importo_anno_primo) AS
                cap_privati_importo_anno_primo,
            sum(intimp.intervento_importi_importo_anno_secondo) AS
                cap_privati_importo_anno_secondo,
            sum(intimp.intervento_importi_importo_anni_successivi) AS
                cap_privati_importo_anni_successivi,
            sum(intimp.intervento_importi_importo_anno_primo +
                intimp.intervento_importi_importo_anno_secondo + intimp.intervento_importi_importo_anni_successivi) AS cap_privati_totale_importi
    FROM cpass_t_pba_intervento int_1
             JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id =
                 intimp.intervento_id
             JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id =
                 programma_1.programma_id
             JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id =
                 risorsa.risorsa_id AND risorsa.risorsa_tipo::text = 'CAPITALE PRIVATO'::text
    GROUP BY int_1.intervento_id, programma_1.programma_id
    )
    SELECT 
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
        --,programma.programma_referente
        ,ente.ente_id       
        ,ente.ente_codice_fiscale
        ,ente.ente_denominazione
        ,importi.importo_anno_primo
        ,importi.importo_anno_secondo
        ,importi.importo_anni_successivi
        ,importi.totale_importi
        ,importi_cap_privati.cap_privati_importo_anno_primo
        ,importi_cap_privati.cap_privati_importo_anno_secondo
        ,importi_cap_privati.cap_privati_importo_anni_successivi
        ,importi_cap_privati.cap_privati_totale_importi
        ,'CAPITALE PRIVATO'::character varying AS tipologia        
    FROM cpass_t_pba_intervento "int"
       JOIN cpass_d_stato stato ON "int".stato_id = stato.stato_id and stato.stato_tipo = 'INTERVENTO' AND stato.stato_codice <>'ANNULLATO'
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


     where
     	programma.programma_id = p_programma_id::UUID;
        
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
