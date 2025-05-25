---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
ALTER TABLE if exists cpass.cpass_t_parametro ALTER COLUMN valore TYPE TEXT COLLATE pg_catalog."default";

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_soggetti_aggregatori(p_programma_id character varying)
 RETURNS TABLE(id_allegato_scheda integer, intervento_cui character varying, intervento_anno_avvio integer, intervento_cup character varying, ricompreso_tipo_codice character varying, ricompreso_tipo_descrizione character varying, intervento_lotto_funzionale boolean, nuts_codice character varying, nuts_descrizione character varying, settore_interventi_codice character varying, settore_interventi_descrizione character varying, cpv_codice character varying, cpv_descrizione character varying, intervento_descrizione_acquisto character varying, priorita_codice character varying, priorita_descrizione character varying, utente_nome character varying, utente_cognome character varying, utente_codice_fiscale character varying, intervento_durata_mesi integer, intervento_nuovo_affid boolean, ausa character varying, ausa_descrizione character varying, acquisto_variato_codice character varying, acquisto_variato_descrizione character varying, programma_id uuid, programma_anno integer, ente_id uuid, ente_codice_fiscale character varying, ente_denominazione character varying, importo_anno_primo numeric, importo_anno_secondo numeric, importo_anni_successivi numeric, totale_importi numeric, cap_privati_importo_anno_primo numeric, cap_privati_importo_anno_secondo numeric, cap_privati_importo_anni_successivi numeric, cap_privati_totale_importi numeric, tipologia character varying)
 LANGUAGE plpgsql
AS $function$
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
  JOIN cpass_t_pba_intervento_altri_dati importiva ON int_1.intervento_id = importiva.intervento_id     
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


alter table cpass.cpass_r_ruolo_modulo add column if not exists ente_id UUID;
ALTER TABLE IF EXISTS cpass.cpass_r_ruolo_modulo DROP CONSTRAINT IF EXISTS fk_cpass_r_ruolo_modulo_ente;
ALTER TABLE IF EXISTS cpass.cpass_r_ruolo_modulo ADD CONSTRAINT fk_cpass_r_ruolo_modulo_ente FOREIGN KEY (ente_id)
REFERENCES cpass.cpass_t_ente(ente_id);

ALTER TABLE cpass.cpass_t_parametro
  ALTER COLUMN valore TYPE TEXT COLLATE pg_catalog."default";
 
-- refactoring settore

alter table if exists cpass.cpass_t_settore_indirizzo add column if not exists principale boolean default false;
drop view cpass.cpass_v_settore;
CREATE OR REPLACE VIEW cpass.cpass_v_settore
AS WITH RECURSIVE alberosettore AS (
         SELECT 1 AS livello,
            NULL::uuid AS settore_id_padre,
            s.settore_id,
            s.settore_codice,
            s.settore_descrizione,
 --           s.settore_indirizzo,
 --           s.settore_localita,
 --           s.settore_cap,
 --           s.settore_provincia,
 --           s.settore_telefono,
 --           s.settore_num_civico,
 --           s.settore_contatto,
 --           s.settore_email,
            s.ente_id,
            ts.tipo_settore_id,
            ts.flag_utilizzabile
 --           s.settore_indirizzo_codice
           FROM cpass_t_settore s,
            cpass_d_tipo_settore ts
          WHERE s.settore_padre_id IS NULL AND (s.data_cancellazione IS NULL OR s.data_cancellazione IS NOT NULL AND date_trunc('day'::text, s.data_cancellazione) > date_trunc('day'::text, now())) AND s.tipo_settore_id = ts.tipo_settore_id
        UNION ALL
         SELECT mtree.livello + 1,
            mtree.settore_id AS settore_id_padre,
            s_figlio.settore_id,
            s_figlio.settore_codice,
            s_figlio.settore_descrizione,
  --          s_figlio.settore_indirizzo,
  --         s_figlio.settore_localita,
  --          s_figlio.settore_cap,
  --          s_figlio.settore_provincia,
  --          s_figlio.settore_telefono,
  --          s_figlio.settore_num_civico,
  --         s_figlio.settore_contatto,
  --          s_figlio.settore_email,
            s_figlio.ente_id,
            ts.tipo_settore_id,
            ts.flag_utilizzabile
  --          s_figlio.settore_indirizzo_codice
           FROM cpass_t_settore s_figlio
             JOIN alberosettore mtree ON mtree.settore_id = s_figlio.settore_padre_id
             JOIN cpass_d_tipo_settore ts ON s_figlio.tipo_settore_id = ts.tipo_settore_id
          WHERE s_figlio.data_cancellazione IS NULL OR s_figlio.data_cancellazione IS NOT NULL AND date_trunc('day'::text, s_figlio.data_cancellazione) > date_trunc('day'::text, now())
        )
 SELECT row_number() OVER () AS id_v_settore,
    alberosettore.livello,
    alberosettore.settore_id_padre,
    alberosettore.settore_id,
    alberosettore.settore_codice,
    alberosettore.settore_descrizione,
--    alberosettore.settore_indirizzo,
--    alberosettore.settore_localita,
--    alberosettore.settore_cap,
--    alberosettore.settore_provincia,
--    alberosettore.settore_telefono,
--    alberosettore.settore_num_civico,
--    alberosettore.settore_contatto,
--    alberosettore.settore_email,
    alberosettore.ente_id,
    alberosettore.tipo_settore_id,
    alberosettore.flag_utilizzabile
--    alberosettore.settore_indirizzo_codice
   FROM alberosettore
  ORDER BY alberosettore.livello DESC, alberosettore.settore_codice;

-- Permissions

ALTER TABLE cpass.cpass_v_settore OWNER TO cpass;
GRANT ALL ON TABLE cpass.cpass_v_settore TO cpass;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE cpass.cpass_v_settore TO cpass_rw;

alter table if exists cpass.cpass_t_settore drop column if exists settore_indirizzo;
alter table if exists cpass.cpass_t_settore drop column if exists settore_num_civico;
alter table if exists cpass.cpass_t_settore drop column if exists settore_localita;
alter table if exists cpass.cpass_t_settore drop column if exists settore_provincia;
alter table if exists cpass.cpass_t_settore drop column if exists settore_cap;
alter table if exists cpass.cpass_t_settore drop column if exists settore_contatto;
alter table if exists cpass.cpass_t_settore drop column if exists settore_email;
alter table if exists cpass.cpass_t_settore drop column if exists settore_telefono;
alter table if exists cpass.cpass_t_settore drop column if exists settore_indirizzo_codice;

-- fine refactoring settore

alter table if exists cpass.cpass_t_pba_programma alter column numero_provvedimento type varchar(50);
------------------------------------------------------------------------------------

INSERT INTO cpass.cpass_d_elaborazione_tipo (elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
SELECT tmp.elaborazione_tipo_codice, tmp.elaborazione_tipo_descrizione, tmp.modulo_codice
FROM (VALUES
   ('STORICO_FILE_DDT','STORICO_FILE_DDT','DDT')
  ,('STORICO_FILE_NSO','STORICO_FILE_NSO','NSO')
) AS tmp(elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo current
  WHERE current.elaborazione_tipo_codice = tmp.elaborazione_tipo_codice
);

update cpass.cpass_d_pba_acquisto_variato set acquisto_variato_descrizione_estesa = 'Acquisto cancellato, da non riproporre nella prossima annualita''' where acquisto_variato_codice = '';
update cpass.cpass_d_pba_acquisto_variato set acquisto_variato_descrizione_estesa = 'Nuovo acquisto conseguenza di atto amministrativo' where acquisto_variato_codice = '1';
update cpass.cpass_d_pba_acquisto_variato set acquisto_variato_descrizione_estesa = 'Nuovo acquisto per sopravvenuta disponibilita'' di finanziamenti' where acquisto_variato_codice = '2';
update cpass.cpass_d_pba_acquisto_variato set acquisto_variato_descrizione_estesa = 'Anticipazione prima annualita'' di acquisizione della fornitura o servizio' where acquisto_variato_codice = '3';
update cpass.cpass_d_pba_acquisto_variato set acquisto_variato_descrizione_estesa = 'Modifica quadro economico dell''acquisto, necessita'' di nuove risorse' where acquisto_variato_codice = '4';
update cpass.cpass_d_pba_acquisto_variato set acquisto_variato_descrizione_estesa = 'Da definire ...' where acquisto_variato_codice = '5';

INSERT INTO cpass.cpass_t_testi_notifiche (codice, it_testo, en_testo)
SELECT tmp.codice, tmp.it_testo, tmp.en_testo
FROM ( VALUES
    ('N0005','Gli acquisti con CUI {{numeri_cui}} precedentemente a suo carico sono stati spostati a carico di un altro RUP',null),
    ('N0006','Le sono stati attribuiti dei nuovi acquisti: {{numeri_cui}}',null)
	) AS tmp(codice, it_testo, en_testo)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_testi_notifiche tp
	WHERE tp.codice = tmp.codice
);

------------------------BONIFICA STATI ------------------
insert into  cpass_d_stato (stato_codice   ,stato_descrizione ,stato_tipo )
select 
--stato_el_ordine_id
 stato_codice 
,stato_descrizione 
,stato_tipo 
from 
cpass_d_stato_el_ordine;


alter table cpass_t_ord_destinatario_evasione add column if not exists stato_id INTEGER;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario_evasione DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_destinatario_evasione_stato;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario_evasione ADD CONSTRAINT fk_cpass_t_ord_destinatario_evasione_stato FOREIGN KEY (stato_id)
REFERENCES cpass.cpass_d_stato(stato_id);


alter table cpass_t_ord_destinatario_ordine add column if not exists stato_id INTEGER;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_destinatario_ordine_stato;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario_ordine ADD CONSTRAINT fk_cpass_t_ord_destinatario_ordine_stato FOREIGN KEY (stato_id)
REFERENCES cpass.cpass_d_stato(stato_id);


alter table cpass_t_ord_riga_ordine add column if not exists stato_id INTEGER;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_riga_ordine_stato;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_ordine_stato FOREIGN KEY (stato_id)
REFERENCES cpass.cpass_d_stato(stato_id);

alter table cpass_t_ord_riga_evasione add column if not exists stato_id INTEGER;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_evasione DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_riga_evasione_stato;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_evasione ADD CONSTRAINT fk_cpass_t_ord_riga_evasione_stato FOREIGN KEY (stato_id)
REFERENCES cpass.cpass_d_stato(stato_id);




ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario_evasione DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_destinatario_evasione_stato_el_ordine;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario_ordine   DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_destinatario_ordine_stato_el_ordine;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine           DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_riga_ordine_stato_el_ordine;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_evasione         DROP CONSTRAINT IF EXISTS fk_cpass_t_ord_riga_evasione_stato_el_ordine;



DROP  VIEW if exists cpass.cpass_v_riepilogo_fattura_evasione;
DROP  VIEW if exists cpass.cpass_v_evasione ;
DROP  VIEW if exists cpass.cpass_v_ordine;

CREATE OR REPLACE VIEW cpass.cpass_v_evasione (
    evasione_id,
    testata_evasione_id,
    evasione_anno,
    evasione_numero,
    fornitore_id,
    data_inserimento,
    settore_competente_id,
    stato_id,
    ufficio_id,
    totale_con_iva,
    utente_compilatore_id,
    descrizione,
    data_conferma,
    data_ripartizione,
    data_invio_contabilita,
    data_autorizzazione,
    fattura_anno,
    fattura_numero,
    fattura_tipo,
    fattura_codice,
    fattura_protocollo_anno,
    fattura_protocollo_numero,
    fattura_totale,
    fattura_totale_liquidabile,
    data_consegna,
    documento_consegna,
    documento_data_consegna,
    tipo_evasione_id,
    note,
    data_cancellazione_testata,
    destinatario_evasione_id,
    progressivo_destinatario,
    indirizzo,
    num_civico,
    localita,
    provincia,
    cap,
    contatto,
    email,
    telefono,
    destinatario_id,
    settore_destinatario_id,
    stato_destinatario_evasione_id,
    data_cancellazione_destinatario,
    riga_evasione_id,
    progressivo_riga,
    importo_totale,
    prezzo_unitario,
    riga_ordine_id,
    aliquote_iva_id,
    oggetti_spesa_id,
    stato_riga_evasione_id,
    listino_fornitore_id,
    data_cancellazione_riga,
    impegno_evasione_id,
    impegno_id,
    impegno_ordine_id,
    impegno_progressivo,
    impegno_anno_esercizio,
    impegno_anno,
    impegno_numero,
    importo_ripartito,
    importo_sospeso,
    importo_liquidato,
    causale_sospensione_id,
    data_sospensione,
    data_cancellazione_impegno,
    causale_sospensione_codice,
    causale_sospensione_descrizione,
    numero_capitolo,
    numero_articolo,
    subimpegno_evasione_id,
    subimpegno_anno,
    subimpegno_numero,
    sub_importo_ripartito,
    sub_importo_sospeso,
    sub_importo_liquidato,
    subimpegno_id,
    subimpegno_ordine_id,
    data_creazione,
    data_cancellazione_subimpegno)
AS
SELECT row_number() OVER () AS evasione_id,
    cpass_t_ord_testata_evasione.testata_evasione_id,
    cpass_t_ord_testata_evasione.evasione_anno,
    cpass_t_ord_testata_evasione.evasione_numero,
    cpass_t_ord_testata_evasione.fornitore_id,
    cpass_t_ord_testata_evasione.data_inserimento,
    cpass_t_ord_testata_evasione.settore_competente_id,
    cpass_t_ord_testata_evasione.stato_id,
    cpass_t_ord_testata_evasione.ufficio_id,
    cpass_t_ord_testata_evasione.totale_con_iva,
    cpass_t_ord_testata_evasione.utente_compilatore_id,
    cpass_t_ord_testata_evasione.descrizione,
    cpass_t_ord_testata_evasione.data_conferma,
    cpass_t_ord_testata_evasione.data_ripartizione,
    cpass_t_ord_testata_evasione.data_invio_contabilita,
    cpass_t_ord_testata_evasione.data_autorizzazione,
    cpass_t_ord_testata_evasione.fattura_anno,
    cpass_t_ord_testata_evasione.fattura_numero,
    cpass_t_ord_testata_evasione.fattura_tipo,
    cpass_t_ord_testata_evasione.fattura_codice,
    cpass_t_ord_testata_evasione.fattura_protocollo_anno,
    cpass_t_ord_testata_evasione.fattura_protocollo_numero,
    cpass_t_ord_testata_evasione.fattura_totale,
    cpass_t_ord_testata_evasione.fattura_totale_liquidabile,
    cpass_t_ord_testata_evasione.data_consegna,
    cpass_t_ord_testata_evasione.documento_consegna,
    cpass_t_ord_testata_evasione.documento_data_consegna,
    cpass_t_ord_testata_evasione.tipo_evasione_id,
    cpass_t_ord_testata_evasione.note,
    cpass_t_ord_testata_evasione.data_cancellazione AS data_cancellazione_testata,
    cpass_t_ord_destinatario_evasione.destinatario_evasione_id,
    cpass_t_ord_destinatario_evasione.progressivo AS progressivo_destinatario,
    cpass_t_ord_destinatario_evasione.indirizzo,
    cpass_t_ord_destinatario_evasione.num_civico,
    cpass_t_ord_destinatario_evasione.localita,
    cpass_t_ord_destinatario_evasione.provincia,
    cpass_t_ord_destinatario_evasione.cap,
    cpass_t_ord_destinatario_evasione.contatto,
    cpass_t_ord_destinatario_evasione.email,
    cpass_t_ord_destinatario_evasione.telefono,
    cpass_t_ord_destinatario_evasione.destinatario_id,
    cpass_t_ord_destinatario_evasione.settore_destinatario_id,
    --cpass_t_ord_destinatario_evasione.stato_el_ordine_id AS  stato_el_ordine_id_destinatario,
    cpass_t_ord_destinatario_evasione.stato_id AS  stato_destinatario_evasione_id,
    cpass_t_ord_destinatario_evasione.data_cancellazione AS  data_cancellazione_destinatario,
    cpass_t_ord_riga_evasione.riga_evasione_id,
    cpass_t_ord_riga_evasione.progressivo AS progressivo_riga,
    cpass_t_ord_riga_evasione.importo_totale,
    cpass_t_ord_riga_evasione.prezzo_unitario,
    cpass_t_ord_riga_evasione.riga_ordine_id,
    cpass_t_ord_riga_evasione.aliquote_iva_id,
    cpass_t_ord_riga_evasione.oggetti_spesa_id,
    --cpass_t_ord_riga_evasione.stato_el_ordine_id,
    cpass_t_ord_riga_evasione.stato_id AS stato_riga_evasione_id,
    cpass_t_ord_riga_evasione.listino_fornitore_id,
    cpass_t_ord_riga_evasione.data_cancellazione AS data_cancellazione_riga,
    cpass_t_ord_impegno_evasione.impegno_evasione_id,
    cpass_t_ord_impegno_evasione.impegno_id,
    cpass_t_ord_impegno_evasione.impegno_ordine_id,
    cpass_t_ord_impegno_evasione.impegno_progressivo,
    cpass_t_ord_impegno_evasione.impegno_anno_esercizio,
    cpass_t_ord_impegno_evasione.impegno_anno,
    cpass_t_ord_impegno_evasione.impegno_numero,
    cpass_t_ord_impegno_evasione.importo_ripartito,
    cpass_t_ord_impegno_evasione.importo_sospeso,
    cpass_t_ord_impegno_evasione.importo_liquidato,
    cpass_t_ord_impegno_evasione.causale_sospensione_id,
    cpass_t_ord_impegno_evasione.data_sospensione,
    cpass_t_ord_impegno_evasione.data_cancellazione AS data_cancellazione_impegno,
    cpass_d_ord_causale_sospensione_evasione.causale_sospensione_codice,
    cpass_d_ord_causale_sospensione_evasione.causale_sospensione_descrizione,
    cpass_t_impegno.numero_capitolo,
    cpass_t_impegno.numero_articolo,
    cpass_t_ord_subimpegno_evasione.subimpegno_evasione_id,
    cpass_t_ord_subimpegno_evasione.subimpegno_anno,
    cpass_t_ord_subimpegno_evasione.subimpegno_numero,
    cpass_t_ord_subimpegno_evasione.importo_ripartito AS sub_importo_ripartito,
    cpass_t_ord_subimpegno_evasione.importo_sospeso AS sub_importo_sospeso,
    cpass_t_ord_subimpegno_evasione.importo_liquidato AS sub_importo_liquidato,
    cpass_t_ord_subimpegno_evasione.subimpegno_id,
    cpass_t_ord_subimpegno_evasione.subimpegno_ordine_id,
    cpass_t_ord_subimpegno_evasione.data_creazione,
    cpass_t_ord_subimpegno_evasione.data_cancellazione AS data_cancellazione_subimpegno
FROM cpass_t_ord_testata_evasione
     JOIN cpass_t_ord_destinatario_evasione ON cpass_t_ord_testata_evasione.testata_evasione_id = cpass_t_ord_destinatario_evasione.testata_evasione_id
     LEFT JOIN cpass_t_ord_riga_evasione ON cpass_t_ord_destinatario_evasione.destinatario_evasione_id = cpass_t_ord_riga_evasione.destinatario_evasione_id
     LEFT JOIN cpass_t_ord_impegno_evasione ON cpass_t_ord_riga_evasione.riga_evasione_id = cpass_t_ord_impegno_evasione.riga_evasione_id
     LEFT JOIN cpass_d_ord_causale_sospensione_evasione ON cpass_t_ord_impegno_evasione.causale_sospensione_id = cpass_d_ord_causale_sospensione_evasione.causale_sospensione_id
     LEFT JOIN cpass_t_impegno ON cpass_t_impegno.impegno_id = cpass_t_ord_impegno_evasione.impegno_id
     LEFT JOIN cpass_t_ord_subimpegno_evasione ON cpass_t_ord_impegno_evasione.impegno_evasione_id = cpass_t_ord_subimpegno_evasione.impegno_evasione_id;
         
     
--
CREATE OR REPLACE VIEW cpass.cpass_v_riepilogo_fattura_evasione (
    riepilogo_fattura_evasione_id,
    testata_evasione_id,
    impegno_anno_esercizio,
    impegno_anno,
    impegno_numero,
    subimpegno_anno,
    subimpegno_numero,
    ripartito,
    sospeso,
    causale_sospensione_codice,
    causale_sospensione_descrizione,
    data_sospensione)
AS
SELECT row_number() OVER () AS riepilogo_fattura_evasione_id,
    riepilogo.testata_evasione_id,
    riepilogo.impegno_anno_esercizio,
    riepilogo.impegno_anno,
    riepilogo.impegno_numero,
    riepilogo.subimpegno_anno,
    riepilogo.subimpegno_numero,
        CASE
            WHEN riepilogo.subimpegno_anno IS NULL THEN riepilogo.imp_ripartito
            ELSE riepilogo.subimp_ripartito
        END AS ripartito,
        CASE
            WHEN riepilogo.subimpegno_anno IS NULL THEN riepilogo.imp_sospeso
            ELSE riepilogo.subimp_sospeso
        END AS sospeso,
    riepilogo.causale_sospensione_codice,
    riepilogo.causale_sospensione_descrizione,
    riepilogo.data_sospensione
FROM (
    SELECT tmp.testata_evasione_id,
            tmp.impegno_anno_esercizio,
            tmp.impegno_anno,
            tmp.impegno_numero,
            tmp.subimpegno_anno,
            tmp.subimpegno_numero,
            tmp.causale_sospensione_codice,
            tmp.causale_sospensione_descrizione,
            tmp.data_sospensione,
            sum(COALESCE(tmp.importo_ripartito, 0::numeric)) AS imp_ripartito,
            sum(COALESCE(tmp.importo_sospeso, 0::numeric)) AS imp_sospeso,
            sum(COALESCE(tmp.sub_importo_ripartito, 0::numeric)) AS subimp_ripartito,
            sum(COALESCE(tmp.sub_importo_sospeso, 0::numeric)) AS subimp_sospeso
    FROM cpass_v_evasione tmp
    WHERE tmp.impegno_anno IS NOT NULL
    GROUP BY tmp.testata_evasione_id, tmp.impegno_anno_esercizio,
        tmp.impegno_anno, tmp.impegno_numero, tmp.subimpegno_anno, tmp.subimpegno_numero, tmp.causale_sospensione_codice, tmp.causale_sospensione_descrizione, tmp.data_sospensione
    ORDER BY tmp.testata_evasione_id, tmp.impegno_anno_esercizio,
        tmp.impegno_anno, tmp.impegno_numero, tmp.subimpegno_anno, tmp.subimpegno_numero
    ) riepilogo;
                
         
    
    
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
    cpass_t_ord_destinatario_ordine.stato_id AS        stato_destinatario_id,
    cpass_t_ord_destinatario_ordine.progressivo AS progressivo_destinatario,
    cpass_t_ord_destinatario_ordine.data_cancellazione AS        data_cancellazione_destinatario,
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
     JOIN cpass_t_ord_destinatario_ordine ON
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
         
         
         
-----------------------------------------------------     
     
     
update cpass_t_ord_destinatario_evasione odr set stato_id = st.stato_id
from 
cpass_d_stato st
,cpass_d_stato_el_ordine steo
where 
    st.stato_codice = steo.stato_codice
and st.stato_tipo = steo.stato_tipo
and st.stato_tipo = 'DESTINATARIO_EVASIONE'
and odr.stato_el_ordine_id = steo.stato_el_ordine_id;

update cpass_t_ord_destinatario_ORDINE odr set stato_id = st.stato_id
from 
cpass_d_stato st
,cpass_d_stato_el_ordine steo
where 
    st.stato_codice = steo.stato_codice
and st.stato_tipo = steo.stato_tipo
and st.stato_tipo = 'DEST_ORDINE'
and odr.stato_el_ordine_id = steo.stato_el_ordine_id;


update cpass_t_ord_riga_ordine odr set stato_id = st.stato_id
from 
cpass_d_stato st
,cpass_d_stato_el_ordine steo
where 
    st.stato_codice = steo.stato_codice
and st.stato_tipo = steo.stato_tipo
and st.stato_tipo = 'RIGA_ORDINE'
and odr.stato_el_ordine_id = steo.stato_el_ordine_id;

update cpass_t_ord_riga_evasione odr set stato_id = st.stato_id
from 
cpass_d_stato st
,cpass_d_stato_el_ordine steo
where 
    st.stato_codice = steo.stato_codice
and st.stato_tipo = steo.stato_tipo
and st.stato_tipo = 'RIGA_EVASIONE'
and odr.stato_el_ordine_id = steo.stato_el_ordine_id;

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Cancellazione di acquisto già previsto nell''elenco annuale'
where acquisto_variato_codice ='';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Aggiunta acquisto in conseguenza di atto amministrativo'
where acquisto_variato_codice = '1';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Aggiunta acquisto per sopravvenuta disponibilita'' di finanziamenti, comprese risorse disponibili anche a seguito di ribassi d''asta o economie'
where acquisto_variato_codice = '2';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Anticipazione prima annualita'' di acquisizione della fornitura o servizio'
where acquisto_variato_codice = '3';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Modifica quadro economico dell''acquisto previsto nell''elenco annuale in caso di nuove risorse'
where acquisto_variato_codice = '4';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Acquisto reso necessario da eventi imprevedibili o calamitosi o da sopravvenute disposizioni di legge o regolamentari o non previsto nell''elenco annuale realizzabile con un autonomo piano finanziario'
where acquisto_variato_codice = '5';

ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario_evasione  DROP column if exists stato_el_ordine_id;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_evasione          DROP column if exists stato_el_ordine_id;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_destinatario_ordine    DROP column if exists stato_el_ordine_id;
ALTER TABLE IF EXISTS cpass.cpass_t_ord_riga_ordine            DROP column if exists  stato_el_ordine_id;
drop table IF EXISTS cpass.cpass_d_stato_el_ordine;
update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Cancellazione di acquisto già previsto nell''elenco annuale'
where acquisto_variato_codice ='';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Aggiunta acquisto in conseguenza di atto amministrativo'
where acquisto_variato_codice = '1';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Aggiunta acquisto per sopravvenuta disponibilita'' di finanziamenti, comprese risorse disponibili anche a seguito di ribassi d''asta o economie'
where acquisto_variato_codice = '2';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Anticipazione prima annualita'' di acquisizione della fornitura o servizio'
where acquisto_variato_codice = '3';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Modifica quadro economico dell''acquisto previsto nell''elenco annuale in caso di nuove risorse'
where acquisto_variato_codice = '4';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Acquisto reso necessario da eventi imprevedibili o calamitosi o da sopravvenute disposizioni di legge o regolamentari o non previsto nell''elenco annuale realizzabile con un autonomo piano finanziario'
where acquisto_variato_codice = '5';


