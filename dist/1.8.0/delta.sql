---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
ALTER TABLE IF EXISTS cpass.cpass_t_impegno ADD COLUMN IF NOT EXISTS pdc_codice varchar (50);
ALTER TABLE IF EXISTS cpass.cpass_t_impegno ADD COLUMN IF NOT EXISTS pdc_descrizione varchar (500);

ALTER TABLE IF EXISTS cpass.cpass_t_fornitore ADD COLUMN IF NOT EXISTS ente_id UUID;

ALTER TABLE IF EXISTS cpass.cpass_t_fornitore drop constraint  if exists  fk_cpass_t_fornitore_ente;
ALTER TABLE IF EXISTS cpass.cpass_t_fornitore add constraint  fk_cpass_t_fornitore_ente FOREIGN KEY (ente_id)
REFERENCES cpass.cpass_t_ente (ente_id);



CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_soggetti_aggregatori (
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
  LEFT JOIN cpass_t_pba_intervento_altri_dati importiva ON int_1.intervento_id = importiva.intervento_id     
  JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
  JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id = risorsa.risorsa_id
   AND risorsa.risorsa_tipo::text != 'CAPITALE PRIVATO'::text
GROUP BY int_1.intervento_id, programma_1.programma_id,  importiva.iva_primo_anno, importiva.iva_secondo_anno,importiva.iva_anni_successivi),
importi_cap_privati AS (
    SELECT int_1.intervento_id,
           programma_1.programma_id,
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
    GROUP BY int_1.intervento_id, programma_1.programma_id
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
        --,programma.programma_referente
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
     	 programma.programma_id = p_programma_id::UUID
     and importi.lordo_totale_importi - importi.iva_totale_importi > 1000000
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;

------------------------------------------------------------------------------------------------------------------
INSERT INTO cpass.cpass_d_aliquote_iva (aliquote_iva_codice, aliquote_iva_descrizione,percentuale,codifica_peppol,data_validita_inizio, utente_creazione, utente_modifica)
SELECT tmp.codice, tmp.descrizione,percentuale, peppol,now(),'SYSTEM', 'SYSTEM'
FROM (values
('10','Aliquota 10%',10,'S')
) AS tmp(codice, descrizione,percentuale,peppol)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_aliquote_iva ts
  WHERE ts.aliquote_iva_codice = tmp.codice
);

