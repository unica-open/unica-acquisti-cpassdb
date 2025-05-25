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
DROP FUNCTION IF EXISTS cpass.pck_cpass_pba_rep_allegato_ii (CHARACTER VARYING);

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_allegato_ii(
  p_programma_id CHARACTER VARYING
)
RETURNS TABLE(
  id_allegato_scheda INTEGER,
  intervento_cui CHARACTER VARYING,
  intervento_anno_avvio INTEGER,
  intervento_cup CHARACTER VARYING,
  ricompreso_tipo_codice CHARACTER VARYING,
  ricompreso_tipo_descrizione CHARACTER VARYING,
  intervento_lotto_funzionale BOOLEAN,
  nuts_codice CHARACTER VARYING,
  nuts_descrizione CHARACTER VARYING,
  settore_interventi_codice CHARACTER VARYING,
  settore_interventi_descrizione CHARACTER VARYING,
  cpv_codice CHARACTER VARYING,
  cpv_descrizione CHARACTER VARYING,
  intervento_descrizione_acquisto CHARACTER VARYING,
  priorita_codice CHARACTER VARYING,
  priorita_descrizione CHARACTER VARYING,
  utente_nome CHARACTER VARYING,
  utente_cognome CHARACTER VARYING,
  utente_codice_fiscale CHARACTER VARYING,
  intervento_durata_mesi INTEGER,
  intervento_nuovo_affid BOOLEAN,
  intervento_copia_tipo CHARACTER VARYING,
  motivazione_non_riproposto CHARACTER VARYING,
  ausa CHARACTER VARYING,
  ausa_descrizione CHARACTER VARYING,
  acquisto_variato_codice CHARACTER VARYING,
  acquisto_variato_descrizione CHARACTER VARYING,
  programma_id UUID,
  programma_anno INTEGER,
  ente_id UUID,
  ente_codice_fiscale CHARACTER VARYING,
  ente_denominazione CHARACTER VARYING,
  importo_anno_primo NUMERIC,
  importo_anno_secondo NUMERIC,
  importo_anni_successivi NUMERIC,
  totale_importi NUMERIC,
  cap_privati_importo_anno_primo NUMERIC,
  cap_privati_importo_anno_secondo NUMERIC,
  cap_privati_importo_anni_successivi NUMERIC,
  cap_privati_totale_importi NUMERIC,
  descrizione_risorsa CHARACTER VARYING,
  tipologia CHARACTER VARYING
)
AS $body$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query
WITH importi AS (
  SELECT
    int_1.intervento_id,
    programma_1.programma_id,
    sum(intimp.intervento_importi_importo_anno_primo)      AS importo_anno_primo,
    sum(intimp.intervento_importi_importo_anno_secondo)    AS importo_anno_secondo,
    sum(intimp.intervento_importi_importo_anni_successivi) AS importo_anni_successivi,
    sum(intimp.intervento_importi_importo_anno_primo + intimp.intervento_importi_importo_anno_secondo + intimp.intervento_importi_importo_anni_successivi) AS totale_importi
  FROM cpass_t_pba_intervento int_1
  JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id = intimp.intervento_id
  JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
  JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id = risorsa.risorsa_id AND risorsa.risorsa_tipo::text = 'BILANCIO'::text
  GROUP BY
    int_1.intervento_id,
    programma_1.programma_id
), importi_cap_privati AS (
  SELECT
    int_1.intervento_id,
    programma_1.programma_id,
    risorsa.risorsa_id,
    sum(intimp.intervento_importi_importo_anno_primo)      AS cap_privati_importo_anno_primo,
    sum(intimp.intervento_importi_importo_anno_secondo)    AS cap_privati_importo_anno_secondo,
    sum(intimp.intervento_importi_importo_anni_successivi) AS cap_privati_importo_anni_successivi,
    sum(intimp.intervento_importi_importo_anno_primo + intimp.intervento_importi_importo_anno_secondo + intimp.intervento_importi_importo_anni_successivi) AS cap_privati_totale_importi
  FROM cpass_t_pba_intervento int_1
  JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id = intimp.intervento_id
  JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
  JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id = risorsa.risorsa_id AND risorsa.risorsa_tipo::text = 'CAPITALE PRIVATO'::text
  GROUP BY int_1.intervento_id, programma_1.programma_id, risorsa.risorsa_id
)
SELECT
  --row_number() OVER ()::INTEGER AS id_allegato_scheda
  0 AS id_allegato_scheda
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
  ,sum(importi.importo_anno_primo) importo_anno_primo
  ,sum(importi.importo_anno_secondo) importo_anno_secondo
  ,sum(importi.importo_anni_successivi)  importo_anni_successivi
  ,sum(importi.totale_importi) totale_importi
  ,sum(importi_cap_privati.cap_privati_importo_anno_primo) cap_privati_importo_anno_primo
  ,sum(importi_cap_privati.cap_privati_importo_anno_secondo) cap_privati_importo_anno_secondo
  ,sum(importi_cap_privati.cap_privati_importo_anni_successivi) cap_privati_importo_anni_successivi
  ,sum(importi_cap_privati.cap_privati_totale_importi)cap_privati_totale_importi
  ,risorsa.risorsa_descrizione descrizione_risorsa
  ,risorsa.risorsa_tipo tipologia --        ,'CAPITALE PRIVATO'::character varying AS tipologia
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
  LEFT JOIN cpass_d_pba_risorsa risorsa ON risorsa.risorsa_id =  importi_cap_privati.risorsa_id and importi_cap_privati.cap_privati_totale_importi > 0
  where programma.programma_id = p_programma_id::UUID
  and ("int".intervento_copia_tipo != 'ACQ_NON_RIPROPOSTO' or "int".intervento_copia_tipo is null)
  group by
    "int".intervento_cui
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
    ,"int".intervento_copia_tipo
    ,"int".motivazione_non_riproposto
    ,ausa.ausa_codice
    ,ausa.ausa_descrizione
    ,av.acquisto_variato_codice
    ,av.acquisto_variato_descrizione
    ,programma.programma_id
    ,programma.programma_anno
    ,ente.ente_id
    ,ente.ente_codice_fiscale
    ,ente.ente_denominazione
    ,risorsa.risorsa_descrizione
    ,risorsa.risorsa_tipo;

EXCEPTION
  WHEN no_data_found THEN
    RAISE NOTICE 'Nessun dato trovato per il quadro economico';
    RETURN;
  WHEN others THEN
    RAISE EXCEPTION '% Errore : %-%.', RTN_MESSAGGIO, SQLSTATE, substring(SQLERRM from 1 for 500);
    RETURN;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;
