---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
INSERT INTO cpass.cpass_d_elaborazione_tipo (elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
SELECT tmp.codice, tmp.descrizione, tmp.modulo
FROM (VALUES
  ('CHIUSURA_FINE_ANNO' , 'CHIUSURA_FINE_ANNO', 'BO')
) AS tmp(codice, descrizione, modulo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo ds
  WHERE ds.elaborazione_tipo_codice = tmp.codice
);

--DROP TABLE if exists cpass_t_pba_acquisti_da_trasmettere;

CREATE TABLE if not exists cpass.cpass_t_pba_acquisti_da_trasmettere (
  acquisti_da_trasmettere_id SERIAL NOT NULL,
  programma_id UUID not null,
  intervento_id UUID not null,
  intervento_cui VARCHAR(50) not null,
  intervento_anno_avvio INTEGER not null,
  esente_cup BOOLEAN,
  intervento_cup VARCHAR(150),
  ricompreso_tipo_codice VARCHAR(150),
  ricompreso_tipo_conteggio_importi BOOLEAN,
  intervento_ricompreso_cui VARCHAR(21),
  intervento_lotto_funzionale BOOLEAN,
  nuts_codice VARCHAR(150),
  nuts_descrizione VARCHAR(100),
  settore_interventi_codice VARCHAR(150),
  settore_interventi_descrizione VARCHAR(100),
  cpv_codice VARCHAR(150),
  cpv_descrizione VARCHAR(500),
  intervento_descrizione_acquisto VARCHAR(500),
  priorita_codice VARCHAR(150),
  priorita_descrizione VARCHAR(150),
  rup_utente_nome VARCHAR(50),
  rup_utente_cognome VARCHAR(50),
  rup_utente_codice_fiscale VARCHAR(20),
  intervento_durata_mesi INTEGER,
  intervento_nuovo_affid BOOLEAN,
  intervento_copia_tipo VARCHAR(150),
  motivazione_non_riproposto VARCHAR(500),
  modalita_affidamento VARCHAR(50),
  ausa_codice VARCHAR(150),
  ausa_descrizione VARCHAR(200),
  acquisto_variato_codice VARCHAR(150),
  acquisto_variato_descrizione VARCHAR(500),
  programma_anno INTEGER not null,
  programma_anno_fine INTEGER,
  referente_cognome VARCHAR(50),
  referente_nome VARCHAR(50),
  ente_id UUID not null,
  ente_codice_fiscale VARCHAR(20) not null,
  ente_denominazione VARCHAR(200) not null,
  importo_anno_primo NUMERIC,
  importo_anno_secondo NUMERIC,
  importo_anno_terzo NUMERIC,
  importo_anni_successivi NUMERIC,
  codice_risorsa VARCHAR(50),
  descrizione_risorsa VARCHAR(500),
  tipologia_risorsa VARCHAR(500),
  risorsa_tag_trasmissione VARCHAR(100),
  intervento_capofila_id UUID,
  note VARCHAR(4000),
  iva_primo_anno NUMERIC,
  iva_secondo_anno NUMERIC,
  iva_terzo_anno NUMERIC,
  iva_anni_successivi NUMERIC,
  CONSTRAINT acquisti_da_trasmettere_id_pkey PRIMARY KEY(acquisti_da_trasmettere_id)
);
-- creare la tabella con solo l'intervento_id e la tipologia_risorsa_privata


create table if not exists  cpass_t_pba_acquisti_cap_privati_da_trasmettere
(acquisti_cap_privati_da_trasmettere_ID serial,
INTERVENTO_ID uuid not null,
PROGRAMMA_ID uuid not null,
TOT_CAPITALE_PRIVATO numeric not null,
CODICE_RISORSA varchar(50) not null,
DESCRIZIONE_RISORSA varchar(500 )not null,
CONSTRAINT acquisti_cap_privati_da_trasmettere_ID_pkey PRIMARY KEY (acquisti_cap_privati_da_trasmettere_ID)
);

INSERT INTO cpass.cpass_d_elaborazione_tipo (elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
SELECT tmp.codice, tmp.descrizione, tmp.modulo
FROM (VALUES
  ('CHIUSURA_FINE_ANNO' , 'CHIUSURA_FINE_ANNO', 'BO')
) AS tmp(codice, descrizione, modulo)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo ds
  WHERE ds.elaborazione_tipo_codice = tmp.codice
);


INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo, disattivabile, attivo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo, tmp.disattivabile, tmp.attivo
FROM (VALUES
	('AVVIA_INTERVENTO','Permette di avviare un intervento','BO',false,'V', 'SI', true)
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo, disattivabile, attivo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );
    
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
  ('ADMIN', 'AVVIA_INTERVENTO') 
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_r_ruolo_permesso rrp
  WHERE rrp.ruolo_id = dr.ruolo_id
  AND rrp.permesso_id = dp.permesso_id
);
INSERT INTO cpass.cpass_d_stato (stato_codice, stato_descrizione, stato_tipo)
SELECT tmp.codice, tmp.descrizione, tmp.tipo
FROM (VALUES
	('ANNULLATA_DA_EVADERE' , 'ANNULLATA_DA_EVADERE', 'RDA')
) AS tmp(codice, descrizione, tipo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_stato ds
	WHERE ds.stato_codice = tmp.codice
);


drop FUNCTION if exists cpass.pck_cpass_pba_rep_allegato_ii_triennale (varchar);
CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_allegato_ii_triennale (
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
  anno_fine_programma integer,
  ente_id uuid,
  ente_codice_fiscale varchar,
  ente_denominazione varchar,
  importo_tutta_fila numeric,
  intervento_capofila_id varchar,
  stato_programma varchar,
  cap_privati_totale_importi numeric,
  descrizione_risorsa varchar,
  tipologia varchar,  
  importo_anno_primo numeric,
  importo_anno_secondo numeric,
  importo_anno_terzo numeric,
  importo_anni_successivi numeric,
  totale_importi numeric
) AS
$body$
DECLARE

v_valoresoglia numeric(9,2);
v_stato varchar(50);
RTN_MESSAGGIO text; 

BEGIN

    select cpass_d_stato.stato_codice
    	into v_stato
    from   	cpass_t_pba_programma 
			,cpass_d_stato    
    where 
    cpass_t_pba_programma.stato_id = cpass_d_stato.stato_id
    and   cpass_t_pba_programma.programma_id = p_programma_id::UUID;

    select t.valore 
    into v_valoresoglia 
    from  cpass_t_parametro t , 
          cpass_t_pba_programma p
    where t.ente_id = p.ente_id 
    and   p.programma_id = p_programma_id::UUID
    and   t.chiave = 'SOGLIA_DI_NON_INVIO_MIT';


	IF v_stato = 'BOZZA' THEN


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
                          ,0.00 as importo_tutta_fila
                          ,"int".intervento_capofila_id::varchar
                          ,v_stato  as stato_programma                      	  
                          ,importi_cap_privati.cap_privati_totale_importi cap_privati_totale_importi
                          ,risorsa.risorsa_codice descrizione_risorsa --CPASS-1013 Haitham 01/03/2023
                          ,risorsa.risorsa_tipo tipologia --        ,'CAPITALE PRIVATO'::character varying AS tipologia
                          ,importi.importo_anno_primo importo_anno_primo
                          ,importi.importo_anno_secondo importo_anno_secondo
                          ,importi.importo_anno_terzo importo_anno_terzo
                          ,importi.importo_anni_successivi  importo_anni_successivi
                          ,importi.totale_importi totale_importi
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

	ELSE
          return query
          select distinct
               0 AS id_allegato_scheda
              ,aadt.intervento_cui
              ,aadt.intervento_anno_avvio
              ,aadt.intervento_cup
              ,aadt.ricompreso_tipo_codice
              ,aadt.intervento_ricompreso_cui as ricompreso_tipo_descrizione
              ,aadt.intervento_lotto_funzionale
              ,aadt.nuts_codice
              ,aadt.nuts_descrizione
              ,aadt.settore_interventi_codice
              ,aadt.settore_interventi_descrizione
              ,aadt.cpv_codice
              ,aadt.cpv_descrizione
              ,aadt.intervento_descrizione_acquisto
              ,aadt.priorita_codice
              ,aadt.priorita_descrizione
              ,aadt.rup_utente_nome  as utente_nome
              ,aadt.rup_utente_cognome as utente_cognome
              ,aadt.rup_utente_codice_fiscale as utente_codice_fiscale
              ,aadt.intervento_durata_mesi
              ,aadt.intervento_nuovo_affid
              ,aadt.intervento_copia_tipo
              ,aadt.motivazione_non_riproposto
              ,aadt.ausa_codice AS ausa
              ,aadt.ausa_descrizione
              ,aadt.acquisto_variato_codice
              ,aadt.acquisto_variato_descrizione
              ,aadt.programma_id
              ,aadt.programma_anno
              ,aadt.programma_anno_fine as anno_fine_programma
              ,aadt.ente_id
              ,aadt.ente_codice_fiscale
              ,aadt.ente_denominazione
              ,0.00 as importo_tutta_fila
              ,aadt.intervento_capofila_id::varchar
              ,v_stato  as stato_programma           
              ,aacpdt.TOT_CAPITALE_PRIVATO cap_privati_totale_importi
              ,aacpdt.CODICE_RISORSA       descrizione_risorsa
              ,aacpdt.DESCRIZIONE_RISORSA  tipologia 
              ,sum(aadt.importo_anno_primo)   as importo_anno_primo
              ,sum(aadt.importo_anno_secondo) as importo_anno_secondo
              ,sum(aadt.importo_anno_terzo)   as importo_anno_terzo
              ,sum(aadt.importo_anni_successivi) as importo_anni_successivi
              ,sum(aadt.importo_anno_primo + aadt.importo_anno_secondo + aadt.importo_anno_terzo + aadt.importo_anni_successivi) as totale_importi
             from cpass_t_pba_acquisti_da_trasmettere aadt
             left join cpass_t_pba_acquisti_cap_privati_da_trasmettere aacpdt on aacpdt.intervento_id = aadt.intervento_id
             where aadt.tipologia_risorsa= 'BILANCIO'
               and aadt.programma_id = p_programma_id::UUID
             group by 
              id_allegato_scheda
              ,aadt.intervento_cui
              ,aadt.intervento_anno_avvio
              ,aadt.intervento_cup
              ,aadt.ricompreso_tipo_codice
              ,aadt.intervento_ricompreso_cui
              ,aadt.intervento_lotto_funzionale
              ,aadt.nuts_codice
              ,aadt.nuts_descrizione
              ,aadt.settore_interventi_codice
              ,aadt.settore_interventi_descrizione
              ,aadt.cpv_codice
              ,aadt.cpv_descrizione
              ,aadt.intervento_descrizione_acquisto
              ,aadt.priorita_codice
              ,aadt.priorita_descrizione
              ,aadt.rup_utente_nome
              ,aadt.rup_utente_cognome
              ,aadt.rup_utente_codice_fiscale
              ,aadt.intervento_durata_mesi
              ,aadt.intervento_nuovo_affid
              ,aadt.intervento_copia_tipo
              ,aadt.motivazione_non_riproposto
              ,aadt.ausa_codice
              ,aadt.ausa_descrizione
              ,aadt.acquisto_variato_codice
              ,aadt.acquisto_variato_descrizione
              ,aadt.programma_id
              ,aadt.programma_anno
              ,aadt.programma_anno_fine 
              ,aadt.ente_id
              ,aadt.ente_codice_fiscale
              ,aadt.ente_denominazione
              ,importo_tutta_fila
              ,aadt.intervento_capofila_id
              ,stato_programma
              ,aacpdt.TOT_CAPITALE_PRIVATO
              ,aacpdt.CODICE_RISORSA
              ,aacpdt.DESCRIZIONE_RISORSA;   
                 
               
    END iF;                          

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




--select * from pck_cpass_pba_rep_allegato_ii_triennale ('90c847b6-3ab0-59f6-ba90-5ce5904c4d94')
    
    
    
CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_allegato_ii(p_programma_id character varying)
 RETURNS TABLE(id_allegato_scheda integer, intervento_cui character varying, intervento_anno_avvio integer, intervento_cup character varying, ricompreso_tipo_codice character varying, ricompreso_tipo_descrizione character varying, intervento_lotto_funzionale boolean, nuts_codice character varying, nuts_descrizione character varying, settore_interventi_codice character varying, settore_interventi_descrizione character varying, cpv_codice character varying, cpv_descrizione character varying, intervento_descrizione_acquisto character varying, priorita_codice character varying, priorita_descrizione character varying, utente_nome character varying, utente_cognome character varying, utente_codice_fiscale character varying, intervento_durata_mesi integer, intervento_nuovo_affid boolean, intervento_copia_tipo character varying, motivazione_non_riproposto character varying, ausa character varying, ausa_descrizione character varying, acquisto_variato_codice character varying, acquisto_variato_descrizione character varying, programma_id uuid, programma_anno integer, ente_id uuid, ente_codice_fiscale character varying, ente_denominazione character varying, importo_anno_primo numeric, importo_anno_secondo numeric, importo_anni_successivi numeric, totale_importi numeric, cap_privati_importo_anno_primo numeric, cap_privati_importo_anno_secondo numeric, cap_privati_importo_anni_successivi numeric, cap_privati_totale_importi numeric, descrizione_risorsa character varying, tipologia character varying, importo_tutta_fila numeric, intervento_capofila_id character varying)
 LANGUAGE plpgsql
AS $function$

DECLARE

v_valoresoglia numeric(9,2);
v_stato varchar(50);
RTN_MESSAGGIO text; 

BEGIN

select cpass_d_stato.stato_codice
    	into v_stato
    from   	cpass_t_pba_programma 
			,cpass_d_stato    
    where 
    cpass_t_pba_programma.stato_id = cpass_d_stato.stato_id
    and   cpass_t_pba_programma.programma_id = p_programma_id::UUID;

	select t.valore 
into v_valoresoglia 
from  cpass_t_parametro t , 
      cpass_t_pba_programma p
where t.ente_id = p.ente_id 
and   p.programma_id = p_programma_id::UUID
and   t.chiave = 'SOGLIA_DI_NON_INVIO_MIT';

IF v_stato = 'BOZZA' THEN

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
					 and (("int".intervento_capofila_id is null and ((importi.totale_importi - totale_iva) >= v_valoresoglia)) or
						  ("int".intervento_capofila_id is not null and (importi_capofila.totale_importi_fila - iva_capofila.totale_iva_fila >= v_valoresoglia))
						 );
         
ELSE
         
    return query

    select distinct
    	0 AS id_allegato_scheda
        ,ctpadt.intervento_cui
        ,ctpadt.intervento_anno_avvio
        ,ctpadt.intervento_cup
        ,ctpadt.ricompreso_tipo_codice
        ,ctpadt.intervento_ricompreso_cui
        ,ctpadt.intervento_lotto_funzionale
        ,ctpadt.nuts_codice
        ,ctpadt.nuts_descrizione
        ,ctpadt.settore_interventi_codice
        ,ctpadt.settore_interventi_descrizione
        ,ctpadt.cpv_codice
        ,ctpadt.cpv_descrizione
        ,ctpadt.intervento_descrizione_acquisto
        ,ctpadt.priorita_codice
        ,ctpadt.priorita_descrizione
        ,ctpadt.rup_utente_nome 
        ,ctpadt.rup_utente_cognome
        ,ctpadt.rup_utente_codice_fiscale
        ,ctpadt.intervento_durata_mesi
        ,ctpadt.intervento_nuovo_affid
        ,ctpadt.intervento_copia_tipo
        ,ctpadt.motivazione_non_riproposto
        ,ctpadt.ausa_codice AS ausa
        ,ctpadt.ausa_descrizione
        ,ctpadt.acquisto_variato_codice
        ,ctpadt.acquisto_variato_descrizione
        ,ctpadt.programma_id
        ,ctpadt.programma_anno
        ,ctpadt.ente_id
        ,ctpadt.ente_codice_fiscale
        ,ctpadt.ente_denominazione
        ,sum(ctpadt.importo_anno_primo) importo_anno_primo
        ,sum(ctpadt.importo_anno_secondo) importo_anno_secondo
        ,sum(ctpadt.importo_anni_successivi)  importo_anni_successivi
        ,sum(ctpadt.importo_anno_primo + ctpadt.importo_anno_secondo +ctpadt.importo_anni_successivi)
        ,0.00
        ,0.00
        ,0.00
        ,importi_cap_privati.tot_capitale_privato 
        ,importi_cap_privati.codice_risorsa  descrizione_risorsa
        ,''::varchar tipologia
        ,0.00 importo_tutta_fila
        ,ctpadt.intervento_capofila_id::varchar
FROM cpass_t_pba_acquisti_da_trasmettere ctpadt 
left JOIN cpass_t_pba_acquisti_cap_privati_da_trasmettere importi_cap_privati ON ctpadt.programma_id = importi_cap_privati.programma_id 
AND ctpadt.intervento_id = importi_cap_privati.intervento_id
where 	ctpadt.programma_id = p_programma_id::UUID
group by id_allegato_scheda
        ,ctpadt.intervento_cui
        ,ctpadt.intervento_anno_avvio
        ,ctpadt.intervento_cup
        ,ctpadt.ricompreso_tipo_codice
        ,ctpadt.intervento_ricompreso_cui
        ,ctpadt.intervento_lotto_funzionale
        ,ctpadt.nuts_codice
        ,ctpadt.nuts_descrizione
        ,ctpadt.settore_interventi_codice
        ,ctpadt.settore_interventi_descrizione
        ,ctpadt.cpv_codice
        ,ctpadt.cpv_descrizione
        ,ctpadt.intervento_descrizione_acquisto
        ,ctpadt.priorita_codice
        ,ctpadt.priorita_descrizione
        ,ctpadt.rup_utente_nome 
        ,ctpadt.rup_utente_cognome
        ,ctpadt.rup_utente_codice_fiscale
        ,ctpadt.intervento_durata_mesi
        ,ctpadt.intervento_nuovo_affid
        ,ctpadt.intervento_copia_tipo
        ,ctpadt.motivazione_non_riproposto
        ,ctpadt.ausa_codice
        ,ctpadt.ausa_descrizione
        ,ctpadt.acquisto_variato_codice
        ,ctpadt.acquisto_variato_descrizione
        ,ctpadt.programma_id
        ,ctpadt.programma_anno
        ,ctpadt.ente_id
        ,ctpadt.ente_codice_fiscale
        ,ctpadt.ente_denominazione
		,importi_cap_privati.tot_capitale_privato 
        ,importi_cap_privati.codice_risorsa
        ,ctpadt.intervento_capofila_id;
		 
END iF;  

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

drop FUNCTION cpass.pck_cpass_pba_rep_allegato_ii_scheda_g_triennale(character varying);
CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_allegato_ii_scheda_g_triennale(p_programma_id character varying)
 RETURNS TABLE(risorsa character varying, tipologia character varying, denominazione character varying, programma_anno integer, anno_fine_programma integer, stato_programma character varying, referente character varying, importo_primo_anno numeric, importo_secondo_anno numeric, importo_terzo_anno numeric, importo_totale_anni numeric)
 LANGUAGE plpgsql
AS $function$

DECLARE

RTN_MESSAGGIO text; 
v_valoresoglia numeric(9,2);
v_stato varchar(50);
BEGIN

select cpass_d_stato.stato_codice
    	into v_stato
    from   	cpass_t_pba_programma 
			,cpass_d_stato    
    where 
    cpass_t_pba_programma.stato_id = cpass_d_stato.stato_id
    and   cpass_t_pba_programma.programma_id = p_programma_id::UUID;

select t.valore 
into v_valoresoglia 
from  cpass_t_parametro t , 
      cpass_t_pba_programma p
where t.ente_id = p.ente_id 
and   p.programma_id = p_programma_id::UUID
and   t.chiave = 'SOGLIA_DI_NON_INVIO_MIT';
		
IF v_stato = 'BOZZA' THEN
	
return query


with risorse as (select int.intervento_id,
				int.intervento_cui, 
                  r.risorsa_codice risorsa,
                  REPLACE (r.risorsa_descrizione,'*',' ')::character varying tipologia,
                      ente.ente_denominazione denominazione,
                      p.programma_anno programma_anno,
                      p.anno_fine_programma anno_fine_programma,
                      v_stato as stato_programma, 
                      CAST(ut.utente_cognome || ' '  || ut.utente_nome as Varchar )  referente,
                         sum(imp.intervento_importi_importo_anno_primo) Importo_Primo_Anno,  
                         sum(imp.intervento_importi_importo_anno_secondo) Importo_Secondo_Anno,
                         sum(imp.intervento_importi_importo_anno_terzo) Importo_Terzo_Anno,
                         (sum(imp.intervento_importi_importo_anno_primo) +  
                         sum(imp.intervento_importi_importo_anno_secondo) +
                         sum(imp.intervento_importi_importo_anno_terzo)) Importo_Totale_Anni
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
                   and int.intervento_capofila_id is null 
				   and v_valoresoglia <= (select sum(imp2.intervento_importi_importo_anno_primo) +
                                       sum(imp2.intervento_importi_importo_anno_secondo) +
                                       sum(imp2.intervento_importi_importo_anno_terzo) +
                                       sum(imp2.intervento_importi_importo_anni_successivi) -
                                       coalesce((ad.iva_primo_anno + ad.iva_secondo_anno + 
                                           ad.iva_terzo_anno + ad.iva_anni_successivi),0)
                                from cpass_t_pba_intervento_importi imp2
                                join cpass_t_pba_intervento int2 on (int2.intervento_id = imp2.intervento_id)
                                left join cpass_t_pba_intervento_altri_dati ad on (int2.intervento_id = ad.intervento_id)
                                where int2.intervento_id = int.intervento_id
                                group by ad.iva_primo_anno , ad.iva_secondo_anno,
                                           ad.iva_terzo_anno , ad.iva_anni_successivi)
                   group by 
				   int.intervento_id,
                   int.intervento_cui,
                   r.risorsa_codice,
                   ente.ente_denominazione,
				   r.risorsa_descrizione,
                   p.programma_anno,
                   p.anno_fine_programma, 
                   v_stato,
                   ut.utente_cognome, ut.utente_nome
                  union
                  select  
				  int.intervento_id,
				  int.intervento_cui,
				  r.risorsa_codice risorsa,
                    REPLACE (r.risorsa_descrizione,'*',' ')::character varying tipologia,
                      ente.ente_denominazione denominazione,
                      p.programma_anno programma_anno,
                      p.anno_fine_programma anno_fine_programma,
                      v_stato as stato_programma,
                      CAST(ut.utente_cognome || ' '  || ut.utente_nome as Varchar )  referente,
                         sum(imp.intervento_importi_importo_anno_primo) Importo_Primo_Anno,  
                         sum(imp.intervento_importi_importo_anno_secondo) Importo_Secondo_Anno,
                         sum(imp.intervento_importi_importo_anno_terzo) Importo_Terzo_Anno,
                         (sum(imp.intervento_importi_importo_anno_primo) +  
                         sum(imp.intervento_importi_importo_anno_secondo) +
                         sum(imp.intervento_importi_importo_anno_terzo)) Importo_Totale_Anni
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
                   and int.intervento_capofila_id is not null
                   and v_valoresoglia <= (select sum(imp2.intervento_importi_importo_anno_primo) +
                                       sum(imp2.intervento_importi_importo_anno_secondo) +
                                       sum(imp2.intervento_importi_importo_anno_terzo) +
                                       sum(imp2.intervento_importi_importo_anni_successivi) -
                                       (select coalesce(sum(ad.iva_primo_anno + ad.iva_secondo_anno + 
                                           ad.iva_terzo_anno + ad.iva_anni_successivi),0)
                                          from cpass_t_pba_intervento int3
                                     left join cpass_t_pba_intervento_altri_dati ad on (int3.intervento_id = ad.intervento_id)
                                     where int3.intervento_capofila_id = int.intervento_capofila_id)
                                from cpass_t_pba_intervento_importi imp2,
                                     cpass_t_pba_intervento int2 
                                where int2.intervento_capofila_id = int.intervento_capofila_id
                                and int2.intervento_id = imp2.intervento_id)
                   group by 
				   int.intervento_id,
				   int.intervento_cui,
				   r.risorsa_codice , 
                   r.risorsa_descrizione , 
                   ente.ente_denominazione,
                   p.programma_anno,
                   p.anno_fine_programma,
                   v_stato,
                   ut.utente_cognome,
                   ut.utente_nome
)
select 
  risorse.risorsa,
  risorse.tipologia,
  risorse.denominazione,
  risorse.programma_anno,
  risorse.anno_fine_programma,
  risorse.stato_programma,
  risorse.referente,
  sum(risorse.Importo_Primo_Anno),
  sum(risorse.Importo_Secondo_Anno),
  sum(risorse.Importo_Terzo_Anno),
  sum(risorse.Importo_Totale_Anni)
from risorse
group by 
risorse.risorsa,
  risorse.tipologia,
  risorse.denominazione,
  risorse.programma_anno,
  risorse.anno_fine_programma, 
  risorse.stato_programma,
  risorse.referente
order by 1;

ELSE

return query

		select ctpdt.codice_risorsa risorsa,
		REPLACE (ctpdt.descrizione_risorsa,'*',' ')::character varying tipologia,
		ctpdt.ENTE_DENOMINAZIONE denominazione,
		ctpdt.PROGRAMMA_ANNO,
		ctpdt.PROGRAMMA_ANNO_FINE anno_fine_programma,
		v_stato stato_programma,
        CAST(ctu.utente_cognome || ' '  || ctu.utente_nome as Varchar )  referente,
		sum(ctpdt.IMPORTO_ANNO_PRIMO),
		sum(ctpdt.IMPORTO_ANNO_SECONDO),
		sum(ctpdt.IMPORTO_ANNO_TERZO),
		sum(ctpdt.IMPORTO_ANNO_PRIMO)+ sum(ctpdt.IMPORTO_ANNO_SECONDO) + sum(ctpdt.importo_anno_terzo)
		from cpass_t_pba_acquisti_da_trasmettere ctpdt
		join cpass_t_pba_programma ctpp on ctpp.programma_id = ctpdt.programma_id 
		join cpass_t_utente ctu on ctu.utente_id = ctpp.utente_referente_id 
		where ctpdt.tipologia_risorsa = 'BILANCIO'
		and ctpdt.motivazione_non_riproposto is null
		and ctpdt.ricompreso_tipo_conteggio_importi = 'true' 
		and ctpdt.programma_id = p_programma_id::UUID
		group by ctpdt.codice_risorsa,
		ctpdt.descrizione_risorsa,
		ctpdt.ENTE_DENOMINAZIONE,
		ctpdt.PROGRAMMA_ANNO,
		ctpdt.PROGRAMMA_ANNO_FINE,
		v_stato,
		ctu.utente_cognome ,
		ctu.utente_nome 
		order by 1;


END iF; 

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







CREATE OR REPLACE FUNCTION cpass.pck_pass_pba_rep_allegato_ii_schedaa(p_programma_id character varying)
 RETURNS TABLE(risorsa character varying, tipologia character varying, denominazione character varying, programma_anno integer, referente character varying, importo_primo_anno numeric, importo_secondo_anno numeric, importo_totale_anni numeric)
 LANGUAGE plpgsql
AS $function$

DECLARE

RTN_MESSAGGIO text; 
v_valoresoglia numeric(9,2);
v_stato varchar(50);
BEGIN

select cpass_d_stato.stato_codice
    	into v_stato
    from   	cpass_t_pba_programma 
			,cpass_d_stato    
    where 
    cpass_t_pba_programma.stato_id = cpass_d_stato.stato_id
    and   cpass_t_pba_programma.programma_id = p_programma_id::UUID;

select t.valore 
into v_valoresoglia 
from  cpass_t_parametro t , 
      cpass_t_pba_programma p
where t.ente_id = p.ente_id 
and   p.programma_id = p_programma_id::UUID
and   t.chiave = 'SOGLIA_DI_NON_INVIO_MIT';

IF v_stato = 'BOZZA' THEN
	
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
                   and int.intervento_capofila_id is null 
				   and v_valoresoglia <= (select sum(imp2.intervento_importi_importo_anno_primo) +
                                       sum(imp2.intervento_importi_importo_anno_secondo) +
                                       sum(imp2.intervento_importi_importo_anni_successivi) -
                                       coalesce((ad.iva_primo_anno + ad.iva_secondo_anno + 
                                           ad.iva_anni_successivi),0)
                                from cpass_t_pba_intervento_importi imp2
                                join cpass_t_pba_intervento int2 on (int2.intervento_id = imp2.intervento_id)
                                left join cpass_t_pba_intervento_altri_dati ad on (int2.intervento_id = ad.intervento_id)
                                where int2.intervento_id = int.intervento_id
                                group by ad.iva_primo_anno , ad.iva_secondo_anno,
                                           ad.iva_terzo_anno , ad.iva_anni_successivi)
                   group by 
				   int.intervento_id,
                   int.intervento_cui,
                   r.risorsa_codice,
                   ente.ente_denominazione,
				   r.risorsa_descrizione,
                   p.programma_anno,
                   ut.utente_cognome, ut.utente_nome
                  union
                  select  
				  int.intervento_id,
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
                   and int.intervento_capofila_id is not null
                   and v_valoresoglia <= (select sum(imp2.intervento_importi_importo_anno_primo) +
                                       sum(imp2.intervento_importi_importo_anno_secondo) +
                                       sum(imp2.intervento_importi_importo_anni_successivi) -
                                       (select coalesce(sum(ad.iva_primo_anno + ad.iva_secondo_anno + 
                                           ad.iva_anni_successivi),0)
                                          from cpass_t_pba_intervento int3
                                     left join cpass_t_pba_intervento_altri_dati ad on (int3.intervento_id = ad.intervento_id)
                                     where int3.intervento_capofila_id = int.intervento_capofila_id)
                                from cpass_t_pba_intervento_importi imp2,
                                     cpass_t_pba_intervento int2 
                                where int2.intervento_capofila_id = int.intervento_capofila_id
                                and int2.intervento_id = imp2.intervento_id)
                   group by 
				   int.intervento_id,
				   int.intervento_cui,
				   r.risorsa_codice , 
                   r.risorsa_descrizione , 
                         ente.ente_denominazione,
                         p.programma_anno,
                         ut.utente_cognome,
                         ut.utente_nome
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
group by 
risorse.risorsa,
  risorse.tipologia,
  risorse.denominazione,
  risorse.programma_anno,
  risorse.referente
order by 1;

ELSE

return query

		select ctpdt.codice_risorsa risorsa,
		REPLACE (ctpdt.descrizione_risorsa,'*',' ')::character varying tipologia,
		ctpdt.ENTE_DENOMINAZIONE denominazione,
		ctpdt.PROGRAMMA_ANNO,
		CAST(ctu.utente_cognome || ' '  || ctu.utente_nome as Varchar )  referente,
		sum(ctpdt.IMPORTO_ANNO_PRIMO),
		sum(ctpdt.IMPORTO_ANNO_SECONDO),
		sum(ctpdt.IMPORTO_ANNO_PRIMO)+ sum(ctpdt.IMPORTO_ANNO_SECONDO)
		from cpass_t_pba_acquisti_da_trasmettere ctpdt
		join cpass_t_pba_programma ctpp on ctpp.programma_id = ctpdt.programma_id 
		join cpass_t_utente ctu on ctu.utente_id = ctpp.utente_referente_id 
		where ctpdt.tipologia_risorsa = 'BILANCIO'
		and ctpdt.motivazione_non_riproposto is null
		and ctpdt.ricompreso_tipo_conteggio_importi = 'true' 
		and ctpdt.programma_id = p_programma_id::UUID
		group by ctpdt.codice_risorsa,
		ctpdt.descrizione_risorsa,
		ctpdt.ENTE_DENOMINAZIONE,
		ctpdt.PROGRAMMA_ANNO,
		ctu.utente_cognome ,
		ctu.utente_nome 
		order by 1;


END iF; 

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

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_confr_progr_sheet2 (
  p_programma_prec varchar,
  p_programma_succ varchar
)
RETURNS TABLE (
  anno_programma integer,
  cui varchar,
  settore varchar,
  annualita integer,
  esente_cup boolean,
  intervento_cup varchar,
  lotto_funzionale boolean,
  priorita varchar,
  codice_ausa varchar,
  denominazione_ausa varchar,
  descrizione_acquisto_prec varchar,
  cpv_prec varchar,
  cognome_rup_prec varchar,
  nome_rup_prec varchar,
  durata_prec integer,
  totale_prec numeric,
  totale1anno_prec numeric,
  totale2anno_prec numeric,
  totale3anno_prec numeric,
  totalealtrianni_prec numeric,
  descrizione_acquisto_succ varchar,
  acquisto_variato_succ varchar,
  cpv_succ varchar,
  cognome_rup_succ varchar,
  nome_rup_succ varchar,
  durata_succ integer,
  totale_succ numeric,
  totale1anno_succ numeric,
  totale2anno_succ numeric,
  totale3anno_succ numeric,
  totalealtrianni_succ numeric
) AS
$body$
DECLARE

RTN_MESSAGGIO text;
v_stato varchar(50);

BEGIN

	
	
return query 
 


WITH SUCC AS (
select 
PROG.programma_id,	 
PROG.programma_anno anno_programma,
SUCC.intervento_cui CUI,
SETT_INT.settore_interventi_descrizione settore,
SUCC.intervento_anno_avvio annualita,
SUCC.esente_cup esente_cup,
SUCC.intervento_cup cup,
SUCC.intervento_lotto_funzionale lotto_funzionale,
P.priorita_descrizione priorita,
AUSA.ausa_codice Codice_Ausa,
AUSA.ausa_descrizione Denominazione_Ausa,
SUCC.intervento_descrizione_acquisto descrizione_Acquisto_SUCC,
coalesce(ACQ_VAR.acquisto_variato_descrizione,'') acquisto_variato_succ,
CPV_SUCC.cpv_codice as cpv_SUCC, 
RUP_SUCC.utente_cognome cognome_rup_SUCC,
RUP_SUCC.utente_nome nome_rup_SUCC,
SUCC.intervento_durata_mesi durata_SUCC,
sum(IMP_SUCC.intervento_importi_importo_anno_primo + 
   IMP_SUCC.intervento_importi_importo_anno_secondo +
   IMP_SUCC.intervento_importi_importo_anno_terzo +
	IMP_SUCC.intervento_importi_importo_anni_successivi) as Totale_SUCC,
sum(IMP_SUCC.intervento_importi_importo_anno_primo) as Totale1anno_SUCC,
sum(IMP_SUCC.intervento_importi_importo_anno_secondo) as Totale2anno_SUCC,
sum(IMP_SUCC.intervento_importi_importo_anno_terzo) as Totale3anno_SUCC,
sum(IMP_SUCC.intervento_importi_importo_anni_successivi) as Totalealtrianni_SUCC
from cpass_t_pba_intervento SUCC
join cpass_t_pba_programma PROG on (PROG.programma_id = SUCC.programma_id)
join cpass_d_pba_settore_interventi SETT_INT on (SETT_INT.settore_interventi_id = SUCC.settore_interventi_id)
join cpass_d_cpv CPV_SUCC on (CPV_SUCC.cpv_id = SUCC.cpv_id)
join cpass_d_pba_priorita P on (SUCC.priorita_id = P.priorita_id)
left join cpass_d_pba_ausa AUSA on (AUSA.ausa_id = SUCC.ausa_id)
left join cpass_d_pba_acquisto_variato ACQ_VAR on (ACQ_VAR.acquisto_variato_id = SUCC.acquisto_variato_id)
join cpass_t_pba_intervento_importi IMP_SUCC on (SUCC.intervento_id = IMP_SUCC.intervento_id)
join cpass_t_utente RUP_SUCC on (RUP_SUCC.utente_id = SUCC.utente_rup_id)
where 
    SUCC.programma_id = p_programma_succ::UUID
and (IMP_SUCC.intervento_importi_importo_anno_primo !=0
    or IMP_SUCC.intervento_importi_importo_anno_secondo !=0
    or IMP_SUCC.intervento_importi_importo_anno_terzo !=0
    or IMP_SUCC.intervento_importi_importo_anni_successivi !=0)
and SUCC.stato_id not in (select stato_id from cpass_d_stato cds  where stato_tipo = 'INTERVENTO' and stato_codice = 'CANCELLATO')
group by 
PROG.programma_id,	 
anno_programma,
SUCC.intervento_cui,
settore ,
annualita, 
SUCC.esente_cup,
SUCC.intervento_cup,
lotto_funzionale ,
priorita  ,
codice_ausa, 
denominazione_ausa,
descrizione_Acquisto_SUCC,	
acquisto_variato_succ,	 
cpv_SUCC, 
RUP_SUCC.utente_cognome,
RUP_SUCC.utente_nome,
durata_SUCC 
 ), PREC AS ( 
select 
PROG.programma_id,	 
PROG.programma_anno anno_programma,
PREC.intervento_cui CUI,
SETT_INT.settore_interventi_descrizione settore,
PREC.intervento_anno_avvio annualita,
PREC.esente_cup esente_cup,
PREC.intervento_cup cup,
PREC.intervento_lotto_funzionale lotto_funzionale,
P.priorita_descrizione priorita,
AUSA.ausa_codice Codice_Ausa,
AUSA.ausa_descrizione Denominazione_Ausa,
PREC.intervento_descrizione_acquisto descrizione_Acquisto_PREC,
coalesce(ACQ_VAR.acquisto_variato_descrizione,'') acquisto_variato_PREC,
CPV_PREC.cpv_codice as cpv_PREC, 
RUP_PREC.utente_cognome cognome_rup_PREC,
RUP_PREC.utente_nome nome_rup_PREC,
PREC.intervento_durata_mesi durata_PREC,
sum(IMP_PREC.intervento_importi_importo_anno_primo + 
   IMP_PREC.intervento_importi_importo_anno_secondo +
   IMP_PREC.intervento_importi_importo_anno_terzo +
	IMP_PREC.intervento_importi_importo_anni_Successivi) as Totale_PREC,
sum(IMP_PREC.intervento_importi_importo_anno_primo) as Totale1anno_PREC,
sum(IMP_PREC.intervento_importi_importo_anno_secondo) as Totale2anno_PREC,
sum(IMP_PREC.intervento_importi_importo_anno_terzo) as Totale3anno_PREC,
sum(IMP_PREC.intervento_importi_importo_anni_Successivi) as Totalealtrianni_PREC
from cpass_t_pba_intervento PREC
join cpass_t_pba_programma PROG on (PROG.programma_id = PREC.programma_id)
join cpass_d_pba_settore_interventi SETT_INT on (SETT_INT.settore_interventi_id = PREC.settore_interventi_id)
join cpass_d_cpv CPV_PREC on (CPV_PREC.cpv_id = PREC.cpv_id)
join cpass_d_pba_priorita P on (PREC.priorita_id = P.priorita_id)
left join cpass_d_pba_ausa AUSA on (AUSA.ausa_id = PREC.ausa_id)
left join cpass_d_pba_acquisto_variato ACQ_VAR on (ACQ_VAR.acquisto_variato_id = PREC.acquisto_variato_id)
join cpass_t_pba_intervento_importi IMP_PREC on (PREC.intervento_id = IMP_PREC.intervento_id)
join cpass_t_utente RUP_PREC on (RUP_PREC.utente_id = PREC.utente_rup_id)
where 
    PREC.programma_id = p_programma_prec::UUID
and (IMP_PREC.intervento_importi_importo_anno_primo !=0
    or IMP_PREC.intervento_importi_importo_anno_secondo !=0
    or IMP_PREC.intervento_importi_importo_anno_terzo !=0
    or IMP_PREC.intervento_importi_importo_anni_successivi !=0)
and PREC.stato_id not in (select stato_id from cpass_d_stato cds  where stato_tipo = 'INTERVENTO' and stato_codice = 'CANCELLATO')
group by 
PROG.programma_id,	 
anno_programma,
PREC.intervento_cui,
settore ,
annualita, 
PREC.esente_cup,
PREC.intervento_cup,
lotto_funzionale ,
priorita  ,
codice_ausa, 
denominazione_ausa,
descrizione_Acquisto_PREC ,	
acquisto_variato_PREC,	 
cpv_PREC, 
RUP_PREC.utente_cognome,
RUP_PREC.utente_nome,
durata_PREC 
)

select 

SUCC.anno_programma,
SUCC.CUI,
SUCC.settore,
SUCC.annualita,
SUCC.esente_cup,
SUCC.cup,
SUCC.lotto_funzionale,
SUCC.priorita,
SUCC.Codice_Ausa,
SUCC.Denominazione_Ausa,
PREC.descrizione_Acquisto_prec,
PREC.cpv_prec, 
PREC.cognome_rup_prec,
PREC.nome_rup_prec,
PREC.durata_prec,
PREC.Totale_prec,
PREC.Totale1anno_prec,
PREC.Totale2anno_prec,
PREC.Totale3anno_prec,
PREC.Totalealtrianni_prec,
SUCC.descrizione_acquisto_succ,
SUCC.acquisto_variato_succ,
SUCC.cpv_succ ,
SUCC.cognome_rup_succ ,
SUCC.nome_rup_succ ,
SUCC.durata_succ,
SUCC.Totale_succ,
SUCC.Totale1anno_succ,
SUCC.Totale2anno_succ,
SUCC.Totale3anno_succ,
SUCC.Totalealtrianni_succ
from
PREC,SUCC
where
		SUCC.CUI = PREC.CUI
and   
(  
   (SUCC.descrizione_Acquisto_SUCC != PREC.descrizione_Acquisto_prec)
or (SUCC.durata_SUCC      != PREC.durata_PREC)
or (PREC.Totale1anno_prec != SUCC.Totale1anno_succ)
or (PREC.Totale2anno_prec != SUCC.Totale2anno_succ)
or (PREC.Totale3anno_prec != SUCC.Totale3anno_succ)
or (PREC.Totalealtrianni_prec != SUCC.Totalealtrianni_succ)
);
 
  
	 
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