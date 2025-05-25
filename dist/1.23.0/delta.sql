---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
INSERT INTO cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.tipo
FROM (VALUES
  ('IAG' , 'IN ATTESA DI GARA', 'RIGA_RMS')
) AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_stato ds
  WHERE ds.stato_codice = tmp.codice
);

alter table CPASS_T_RMS_RIGA_RMS add column if not exists DATA_ATTESA_GARA TIMESTAMP;
alter table CPASS_T_RMS_RIGA_RMS add column if not exists UTENTE_ATTESA_GARA VARCHAR(50);

alter table cpass_t_rms_testata_rms add column if not exists utente_autorizzatore_id uuid;

--alter table cpass.cpass_t_rms_riga_rms add column if not exists data_autorizzazione timestamp without time zone;

drop FUNCTION cpass.pck_cpass_pba_rep_soggetti_aggregatori_triennale(character varying);

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_soggetti_aggregatori_triennale(p_programma_id character varying)
 RETURNS TABLE(id_allegato_scheda integer, intervento_cui character varying, intervento_anno_avvio integer, intervento_cup character varying, ricompreso_tipo_codice character varying, ricompreso_tipo_descrizione character varying, intervento_lotto_funzionale boolean, nuts_codice character varying, nuts_descrizione character varying, settore_interventi_codice character varying, settore_interventi_descrizione character varying, cpv_codice character varying, cpv_descrizione character varying, intervento_descrizione_acquisto character varying, priorita_codice character varying, priorita_descrizione character varying, utente_nome character varying, utente_cognome character varying, utente_codice_fiscale character varying, intervento_durata_mesi integer, intervento_nuovo_affid boolean, ausa character varying, ausa_descrizione character varying, acquisto_variato_codice character varying, acquisto_variato_descrizione character varying, programma_id uuid, programma_anno integer, ente_id uuid, ente_codice_fiscale character varying, ente_denominazione character varying, importo_anno_primo numeric, importo_anno_secondo numeric, importo_anno_terzo numeric, importo_anni_successivi numeric, totale_importi numeric, cap_privati_importo_anno_primo numeric, cap_privati_importo_anno_secondo numeric, cap_privati_importo_anno_terzo numeric, cap_privati_importo_anni_successivi numeric, cap_privati_totale_importi numeric, tipologia character varying, importo_tutta_fila numeric, intervento_capofila_id character varying, intervento_ricompreso_cui character varying)
 LANGUAGE plpgsql
AS $function$
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
		,"int".intervento_ricompreso_cui 
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
$function$
;



INSERT INTO cpass_t_parametro_stampa (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa,file_name)
SELECT tmp.modulo, tmp.nome_stampa, tmp.file_name_template, tmp.parametro, tmp.parametro_tipo, tmp.ordinamento, tmp.procedure_utilizzate, tmp.note, tmp.formato_stampa, tmp.file_name
FROM (VALUES
      ('RMS', 'RICHIESTA_RMS',                 'Stampa_Richiesta_rms.rptdesign',             'p_richiesta_id', 'UUID', 1, 'pck_cpass_rms_rep_richiesta',    NULL, 'pdf','richiestaRms')
) AS tmp (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa, file_name)
WHERE NOT EXISTS (
    SELECT 1
    FROM cpass_t_parametro_stampa tps
    WHERE tps.modulo = tmp.modulo
    AND tps.nome_stampa = tmp.nome_stampa
    AND tps.parametro = tmp.parametro
    AND tps.ordinamento = tmp.ordinamento
);

INSERT INTO cpass.cpass_d_ruolo(ruolo_codice, ruolo_descrizione)
SELECT tmp.codice, tmp.descrizione
FROM (VALUES
    ('OSSERVATORE_RMS', 'OSSERVATORE RMS')
) AS tmp(codice, descrizione)
WHERE NOT EXISTS (
    SELECT 1
    FROM cpass.cpass_d_ruolo dr
    WHERE dr.ruolo_codice = tmp.codice
);



INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('OSSERVATORE_RMS','CONSULTA_RICHIESTA')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);


drop VIEW if exists cpass.cpass_v_ordine_evasione;
drop VIEW if exists cpass.cpass_v_ordine;

ALTER TABLE cpass.cpass_t_ord_testata_ordine ALTER COLUMN consegna_indirizzo TYPE VARCHAR(500);



CREATE OR REPLACE VIEW cpass.cpass_v_ordine (
    ordine_id,
    testata_ordine_id,
    tipo_ordine_id,
    ordine_anno,
    ordine_numero,
    fornitore_id,
    tipo_procedura_id,
    numero_procedura,
    data_emissione,
    data_conferma,
    data_autorizzazione,
    totale_no_iva,
    totale_con_iva,
    descrizione_acquisto,
    consegna_riferimento,
    consegna_data_da,
    consegna_data_a,
    consegna_indirizzo,
    consegna_cap,
    consegna_localita,
    provvedimento_anno,
    provvedimento_numero,
    provvedimento_tipo,
    provvedimento_settore,
    lotto_anno,
    lotto_numero,
    utente_compilatore_id,
    settore_emittente_id,
    ufficio_id,
    stato_id,
    note,
    data_cancellazione_testata,
    destinatario_id,
    indirizzo,
    num_civico,
    localita,
    provincia,
    cap,
    contatto,
    email,
    telefono,
    data_invio_nso,
    settore_destinatario_id,
    stato_destinatario_id,
    progressivo_destinatario,
    data_cancellazione_destinatario,
    riga_ordine_id,
    consegna_parziale,
    progressivo_riga,
    prezzo_unitario,
    quantita,
    percentuale_sconto,
    importo_sconto,
    percentuale_sconto2,
    importo_sconto2,
    importo_netto,
    importo_iva,
    importo_totale,
    note_riga,
    stato_riga_ordine_id,
    oggetti_spesa_id,
    unita_misura_id,
    aliquote_iva_id,
    data_cancellazione_riga,
    impegno_ordine_id,
    impegno_id,
    impegno_progressivo,
    impegno_anno_esercizio,
    impegno_anno,
    impegno_numero,
    importo_impegno,
    data_cancellazione_impegno,
    numero_capitolo,
    numero_articolo,
    subimpegno_ordine_id,
    subimpegno_id,
    subimpegno_anno,
    subimpegno_numero,
    subimpegno_importo,
    data_cancellazione_subimpegno,
    stato_invio_nso_testata,
    stato_invio_nso_destinatario)
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
    cpass_t_ord_destinatario_ordine.data_cancellazione AS
        data_cancellazione_destinatario,
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
         
CREATE OR REPLACE VIEW cpass.cpass_v_ordine_evasione (
    ordine_id,
    testata_ordine_id,
    tipo_ordine_id,
    ordine_anno,
    ordine_numero,
    fornitore_id,
    tipo_procedura_id,
    numero_procedura,
    data_emissione,
    data_conferma,
    data_autorizzazione,
    totale_no_iva,
    totale_con_iva,
    descrizione_acquisto,
    consegna_riferimento,
    consegna_data_da,
    consegna_data_a,
    consegna_indirizzo,
    consegna_cap,
    consegna_localita,
    provvedimento_anno,
    provvedimento_numero,
    lotto_anno,
    lotto_numero,
    utente_compilatore_id,
    settore_emittente_id,
    ufficio_id,
    stato_id,
    note,
    data_cancellazione_testata,
    destinatario_id,
    indirizzo,
    num_civico,
    localita,
    provincia,
    cap,
    contatto,
    email,
    telefono,
    data_invio_nso,
    settore_destinatario_id,
    stato_destinatario_id,
    progressivo_destinatario,
    data_cancellazione_destinatario,
    riga_ordine_id,
    consegna_parziale,
    progressivo_riga,
    prezzo_unitario,
    quantita,
    percentuale_sconto,
    importo_sconto,
    percentuale_sconto2,
    importo_sconto2,
    importo_netto,
    importo_iva,
    importo_totale,
    note_riga,
    stato_riga_ordine_id,
    oggetti_spesa_id,
    unita_misura_id,
    aliquote_iva_id,
    data_cancellazione_riga,
    testata_evasione_id,
    evasione_anno,
    evasione_numero,
    evasione_fornitore_id,
    evasione_stato_id,
    evasione_totale_con_iva,
    descrizione,
    fattura_anno,
    fattura_numero,
    fattura_tipo,
    fattura_codice,
    evasione_stato_codice,
    evasione_stato_descrizione,
    evasione_fornitore_codice,
    evasione_fornitore_ragione_sociale)
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
    cpass_t_ord_destinatario_ordine.data_cancellazione AS
        data_cancellazione_destinatario,
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
    cpass_t_ord_testata_evasione.fattura_codice_fornitore AS fattura_codice,
    cpass_d_stato.stato_codice AS evasione_stato_codice,
    cpass_d_stato.stato_descrizione AS evasione_stato_descrizione,
    cpass_t_fornitore.codice AS evasione_fornitore_codice,
    cpass_t_fornitore.ragione_sociale AS evasione_fornitore_ragione_sociale
FROM cpass_t_ord_testata_ordine
     JOIN cpass_t_ord_destinatario_ordine ON
         cpass_t_ord_testata_ordine.testata_ordine_id = cpass_t_ord_destinatario_ordine.testata_ordine_id
     JOIN cpass_t_ord_riga_ordine ON
         cpass_t_ord_destinatario_ordine.destinatario_id = cpass_t_ord_riga_ordine.destinatario_id
     JOIN cpass_t_ord_riga_evasione ON cpass_t_ord_riga_ordine.riga_ordine_id =
         cpass_t_ord_riga_evasione.riga_ordine_id
     JOIN cpass_t_ord_destinatario_evasione ON
         cpass_t_ord_riga_evasione.destinatario_evasione_id = cpass_t_ord_destinatario_evasione.destinatario_evasione_id
     JOIN cpass_t_ord_testata_evasione ON
         cpass_t_ord_destinatario_evasione.testata_evasione_id = cpass_t_ord_testata_evasione.testata_evasione_id
     JOIN cpass_t_fornitore ON cpass_t_ord_testata_evasione.fornitore_id =
         cpass_t_fornitore.fornitore_id
     JOIN cpass_d_stato ON cpass_t_ord_testata_evasione.stato_id =
         cpass_d_stato.stato_id;
         
CREATE OR REPLACE FUNCTION cpass.pck_cpass_rms_rep_richiesta(p_richiesta_id character varying)
 RETURNS TABLE(richiesta_anno integer, richiesta_numero integer, richiesta_data_conferma timestamp without time zone, utente_cognome character varying, utente_nome character varying, riferimento character varying, codice_settore_richiedente character varying, descrizione_settore_richiedente character varying, richiesta_descrizione character varying, richiesta_note character varying, codice_destinatario character varying, descrizione_destinatario character varying, principale boolean, descrizione_indirizzo character varying, destinatario_indirizzo character varying, destinatario_num_civico character varying, destinatario_localita character varying, destinatario_cap character varying, destinatario_provincia character varying, destinatario_contatto character varying, destinatario_email character varying, destinatario_telefono character varying, ods_codice character varying, ods_descrizione character varying, cpv_codice character varying, cpv_descrizione character varying, quantita numeric, unita_misura_descrizione character varying, data_inizio_consegna timestamp without time zone, data_fine_consegna timestamp without time zone, consegna_parziale boolean, sezione_codice character varying, note character varying, data_autorizzazione timestamp without time zone, autorizzatore_cognome character varying, autorizzatore_nome character varying)
 LANGUAGE plpgsql
AS $function$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query


select 
ctrtr.rms_anno richiesta_anno,
ctrtr.rms_numero richiesta_numero,
ctrtr.data_conferma richiesta_data_conferma,
richiedente.utente_cognome,
richiedente.utente_nome ,
ctrtr.note_richiedente riferimento,
emittente.settore_codice codice_settore_richiedente,
emittente.settore_descrizione descrizione_settore_richiedente,
ctrtr.rms_descrizione  richiesta_descrizione,
ctrtr.note richiesta_note,
destinatario.settore_codice codice_destinatario,
destinatario.settore_descrizione  descrizione_destinatario,
ctsi.principale principale,
ctsi.descrizione descrizione_indirizzo,
ctrtr.destinatario_indirizzo ,
ctrtr.destinatario_num_civico ,
ctrtr.destinatario_localita ,
ctrtr.destinatario_cap ,
ctrtr.destinatario_provincia ,
ctrtr.destinatario_contatto ,
ctrtr.destinatario_email ,
ctrtr.destinatario_telefono ,
cdos.oggetti_spesa_codice ods_codice,
cdos.oggetti_spesa_descrizione ods_descrizione,
cdc.cpv_codice cpv_codice,
cdc.cpv_descrizione cpv_descrizione,
ctrrr.quantita,
cdum.unita_misura_descrizione  ,
ctrrr.data_inizio_consegna ,
ctrrr.data_fine_consegna,
ctrrr.consegna_parziale ,
ctos.sezione_codice ,
ctrrr.note ,
ctrtr.data_autorizzazione,
coalesce(autorizzatore.utente_cognome, ''),
coalesce(autorizzatore.utente_nome, '')
from cpass_t_rms_testata_rms ctrtr
left join cpass_t_rms_riga_rms ctrrr on ctrtr.testata_rms_id = ctrrr.testata_rms_id 
left join cpass_t_settore emittente on emittente.settore_id = ctrtr.settore_emittente_id 
left join cpass_t_settore destinatario on destinatario.settore_id = ctrtr.settore_destinatario_id 
left join cpass_t_settore_indirizzo ctsi on destinatario.settore_id = ctsi.settore_id and ctsi.settore_indirizzo_id = ctrtr.settore_indirizzo_id
left join cpass_d_oggetti_spesa cdos on cdos.oggetti_spesa_id = ctrrr.oggetti_spesa_id 
left join cpass_d_cpv cdc on cdc.cpv_id = cdos.cpv_id 
left join cpass_d_unita_misura cdum on cdum.unita_misura_id = cdos.unita_misura_id 
left join cpass_t_ord_sezione ctos on ctos.sezione_id = ctrrr.sezione_id 
left join cpass_t_utente richiedente on richiedente.utente_id = ctrtr.utente_richiedente_id
left join cpass_t_utente autorizzatore on autorizzatore.utente_id = ctrtr.utente_autorizzatore_id 
where ctrtr.testata_rms_id= p_richiesta_id::UUID ;
        
exception
	when no_data_found THEN
		raise notice 'Nessun dato trovato per la richiesta';
		return;
	when others  THEN
		RAISE EXCEPTION '% Errore : %-%.',RTN_MESSAGGIO,SQLSTATE,substring(SQLERRM from 1 for 500);
		return;

	
END;
$function$
;

         
         