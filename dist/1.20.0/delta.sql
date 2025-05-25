---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
ALTER TABLE cpass_t_pba_intervento_altri_dati ALTER COLUMN iva_primo_anno TYPE numeric;
ALTER TABLE cpass_t_pba_intervento_altri_dati ALTER COLUMN iva_secondo_anno TYPE numeric;
ALTER TABLE cpass_t_pba_intervento_altri_dati ALTER COLUMN iva_terzo_anno TYPE numeric;
ALTER TABLE cpass_t_pba_intervento_altri_dati ALTER COLUMN iva_anni_successivi TYPE numeric;
ALTER TABLE cpass_t_flusso_impegni_esterni ALTER COLUMN num_elaborazione_di_giornata TYPE integer USING num_elaborazione_di_giornata::integer;
ALTER TABLE cpass_t_flusso_subimpegni_esterni ALTER COLUMN num_elaborazione_di_giornata TYPE integer USING num_elaborazione_di_giornata::integer;

ALTER TABLE cpass_t_impegno ALTER COLUMN impegno_descrizione TYPE varchar(500);


  INSERT INTO cpass.cpass_d_elaborazione_tipo (elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
SELECT tmp.elaborazione_tipo_codice, tmp.elaborazione_tipo_descrizione, tmp.modulo_codice
FROM (VALUES
 ('CARICA_IMPEGNO_TMP','CARICA_IMPEGNO_TMP','BO')
,('CARICA_SUBIMPEGNO_TMP','CARICA_SUBIMPEGNO_TMP','BO')
,('AGG_IMPEGNO_TMP','AGG_IMPEGNO_TMP','BO')
,('AGG_SUBIMPEGNO_TMP','AGG_SUBIMPEGNO_TMP','BO')
) AS tmp(elaborazione_tipo_codice, elaborazione_tipo_descrizione, modulo_codice)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_elaborazione_tipo current
  WHERE current.elaborazione_tipo_codice = tmp.elaborazione_tipo_codice
);


drop INDEX cpass_r_ruolo_utente_settore_unique;
CREATE UNIQUE INDEX cpass_r_ruolo_utente_settore_unique ON cpass.cpass_r_ruolo_utente_settore USING btree (utente_settore_id, ruolo_id, data_validita_fine);


ALTER TABLE cpass_t_pba_intervento DROP CONSTRAINT esente_iva_check;

ALTER TABLE cpass_t_pba_intervento ADD CONSTRAINT esente_iva_check 
CHECK (esente_iva = 'true' 
      OR esente_iva = 'false'
);

INSERT INTO cpass.cpass_t_testi_notifiche (codice, it_testo, en_testo)
SELECT tmp.codice, tmp.it_testo, tmp.en_testo
FROM ( VALUES
    ('N0007','L''acquisto {{cui_acquisto}} è stato riportato in BOZZA con la seguente motivazione {{motivazione}}',null)
	) AS tmp(codice, it_testo, en_testo)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_testi_notifiche tp
	WHERE tp.codice = tmp.codice
);




alter table Cpass_T_Aggiornamento_Struttura add column if not exists DATA_VALIDITA_INIZIO TIMESTAMP;
alter table Cpass_T_Aggiornamento_Struttura add column if not exists  descrizione_indirizzo VARCHAR(500);
alter table Cpass_T_Aggiornamento_Struttura add column if not exists  indirizzo VARCHAR(200);
alter table Cpass_T_Aggiornamento_Struttura add column if not exists  num_civico VARCHAR(20);
alter table Cpass_T_Aggiornamento_Struttura add column if not exists  localita VARCHAR(200);
alter table Cpass_T_Aggiornamento_Struttura add column if not exists  provincia VARCHAR(200);
alter table Cpass_T_Aggiornamento_Struttura add column if not exists  cap VARCHAR(5);
alter table Cpass_T_Aggiornamento_Struttura add column if not exists  contatto VARCHAR(200);
alter table Cpass_T_Aggiornamento_Struttura add column if not exists  email VARCHAR(50);
alter table Cpass_T_Aggiornamento_Struttura add column if not exists  telefono VARCHAR(50);
--alter table Cpass_T_Aggiornamento_Struttura add column  settore_indirizzo_codice VARCHAR(50);
--alter table Cpass_T_Aggiornamento_Struttura add column  principale BOOLEAN DEFAULT true;
--alter table Cpass_T_Aggiornamento_Struttura add column  esterno_ente BOOLEAN DEFAULT false; 


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
  importo_anno_primo numeric,
  importo_anno_secondo numeric,
  importo_anno_terzo numeric,
  importo_anni_successivi numeric,
  totale_importi numeric,
  cap_privati_importo_anno_primo numeric,
  cap_privati_importo_anno_secondo numeric,
  cap_privati_importo_anno_terzo numeric,
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
            sum(intimp.intervento_importi_importo_anno_primo + 
			    intimp.intervento_importi_importo_anno_secondo + 
				intimp.intervento_importi_importo_anno_terzo + 
				intimp.intervento_importi_importo_anni_successivi) as totale_importi_fila,
			coalesce(importiva.iva_primo_anno + importiva.iva_secondo_anno + importiva.iva_terzo_anno +
			importiva.iva_anni_successivi,0) totale_iva_fila
FROM cpass_t_pba_intervento int_1
  JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id = intimp.intervento_id
  left JOIN cpass_t_pba_intervento_altri_dati importiva ON int_1.intervento_id = importiva.intervento_id     
  JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
  JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id = risorsa.risorsa_id  AND risorsa.risorsa_tipo::text != 'CAPITALE PRIVATO'::text
--where int_1.intervento_lotto_funzionale = true
   --  and int_1.capofila = true
  GROUP BY int_1.intervento_capofila_id, programma_1.programma_id,
  importiva.iva_primo_anno ,importiva.iva_secondo_anno , importiva.iva_terzo_anno ,
			importiva.iva_anni_successivi),
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
        --,risorsa.risorsa_descrizione descrizione_risorsa
        --,''::character varying descrizione_risorsa CPASS-1013 Haitham 01/03/2023
        ,risorsa.risorsa_codice descrizione_risorsa --CPASS-1013 Haitham 01/03/2023
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
     and (("int".intervento_capofila_id is null and ((importi.totale_importi - totale_iva) >= v_valoresoglia)) or
          ("int".intervento_capofila_id is not null and (importi_capofila.totale_importi_fila -totale_iva_fila >= v_valoresoglia))
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

CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_allegato_ii_scheda_g_triennale (
  p_programma_id varchar
)
RETURNS TABLE (
  risorsa varchar,
  tipologia varchar,
  denominazione varchar,
  programma_anno integer,
  anno_fine_programma integer,
  referente varchar,
  importo_primo_anno numeric,
  importo_secondo_anno numeric,
  importo_terzo_anno numeric,
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
                      p.anno_fine_programma anno_fine_programma,
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
                   ut.utente_cognome,
                   ut.utente_nome
)
select 
  risorse.risorsa,
  risorse.tipologia,
  risorse.denominazione,
  risorse.programma_anno,
  risorse.anno_fine_programma,
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
  risorse.referente
order by 1;



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
            sum(intimp.intervento_importi_importo_anno_primo + 
			intimp.intervento_importi_importo_anno_secondo + 
			intimp.intervento_importi_importo_anni_successivi) as totale_importi_fila,
			coalesce(importiva.iva_primo_anno + importiva.iva_secondo_anno + importiva.iva_anni_successivi,0) totale_iva_fila
FROM cpass_t_pba_intervento int_1
  JOIN cpass_t_pba_intervento_importi intimp ON int_1.intervento_id = intimp.intervento_id
  left JOIN cpass_t_pba_intervento_altri_dati importiva ON int_1.intervento_id = importiva.intervento_id     
  JOIN cpass_t_pba_programma programma_1 ON int_1.programma_id = programma_1.programma_id
  JOIN cpass_d_pba_risorsa risorsa ON intimp.risorsa_id = risorsa.risorsa_id  AND risorsa.risorsa_tipo::text != 'CAPITALE PRIVATO'::text
  --where int_1.intervento_lotto_funzionale = true
   --  and int_1.capofila = true
  GROUP BY int_1.intervento_capofila_id, programma_1.programma_id,
  importiva.iva_primo_anno,importiva.iva_secondo_anno, importiva.iva_anni_successivi),
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
     and (("int".intervento_capofila_id is null and ((importi.totale_importi-importi.totale_iva) >= v_valoresoglia)) or
          ("int".intervento_capofila_id is not null and (importi_capofila.totale_importi_fila - totale_iva_fila >= v_valoresoglia))
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


delete from cpass_t_parametro where chiave ='report.endpoint'; 
delete from cpass_t_parametro where chiave ='report.multi.endpoint'; 

insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('1','25b3cb3e-0c7e-53b2-88bd-afc47011647d','001 - Sistema Informativo e Telecomunicazioni');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('2','25b3cb3e-0c7e-53b2-88bd-afc47011647d','002 - Archivi e Gestione Documentale');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('3','25b3cb3e-0c7e-53b2-88bd-afc47011647d','003 - Servizi Culturali');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('4','25b3cb3e-0c7e-53b2-88bd-afc47011647d','004 - Commercio');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('5','25b3cb3e-0c7e-53b2-88bd-afc47011647d','005 - SINDACO');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('6','25b3cb3e-0c7e-53b2-88bd-afc47011647d','020 - Presidente del Consiglio Comunale');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('7','25b3cb3e-0c7e-53b2-88bd-afc47011647d','029 - Segreteria Generale');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('8','25b3cb3e-0c7e-53b2-88bd-afc47011647d','030 - Direzione Generale');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('9','25b3cb3e-0c7e-53b2-88bd-afc47011647d','031 - Gabinetto del Sindaco');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('10','25b3cb3e-0c7e-53b2-88bd-afc47011647d','032 - Agenzia per i Servizi Pubblici Locali');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('11','25b3cb3e-0c7e-53b2-88bd-afc47011647d','033 - Gioventù');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('12','25b3cb3e-0c7e-53b2-88bd-afc47011647d','034 - VDG Risorse Finanziarie');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('13','25b3cb3e-0c7e-53b2-88bd-afc47011647d','035 - Risorse Umane');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('14','25b3cb3e-0c7e-53b2-88bd-afc47011647d','037 - Tributi e Catasto');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('15','25b3cb3e-0c7e-53b2-88bd-afc47011647d','040 - Consiglio Comunale');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('16','25b3cb3e-0c7e-53b2-88bd-afc47011647d','041 - Contratti e Appalti');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('17','25b3cb3e-0c7e-53b2-88bd-afc47011647d','042 - Giunta Comunale');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('18','25b3cb3e-0c7e-53b2-88bd-afc47011647d','043 - Servizi Sociali');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('19','25b3cb3e-0c7e-53b2-88bd-afc47011647d','044 - Servizi Educativi');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('20','25b3cb3e-0c7e-53b2-88bd-afc47011647d','045 - VDG Servizi Tecnici');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('21','25b3cb3e-0c7e-53b2-88bd-afc47011647d','046 - Edilizia per Servizi Culturali - Sociali - Commerciali');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('22','25b3cb3e-0c7e-53b2-88bd-afc47011647d','049 - VDG Servizi Amministrativi');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('23','25b3cb3e-0c7e-53b2-88bd-afc47011647d','050 - Affari Legali');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('24','25b3cb3e-0c7e-53b2-88bd-afc47011647d','051 - Lavoro');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('25','25b3cb3e-0c7e-53b2-88bd-afc47011647d','052 - Edilizia Residenziale Pubblica');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('26','25b3cb3e-0c7e-53b2-88bd-afc47011647d','054 - Infrastrutture e Mobilità');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('27','25b3cb3e-0c7e-53b2-88bd-afc47011647d','055 - Urbanistica');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('28','25b3cb3e-0c7e-53b2-88bd-afc47011647d','056 - Edilizia Privata');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('29','25b3cb3e-0c7e-53b2-88bd-afc47011647d','058 - Servizi Civici');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('30','25b3cb3e-0c7e-53b2-88bd-afc47011647d','059 - Economato');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('31','25b3cb3e-0c7e-53b2-88bd-afc47011647d','060 - Circoscrizione I');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('32','25b3cb3e-0c7e-53b2-88bd-afc47011647d','061 - Circoscrizione II');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('33','25b3cb3e-0c7e-53b2-88bd-afc47011647d','062 - Circoscrizione III');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('34','25b3cb3e-0c7e-53b2-88bd-afc47011647d','063 - Circoscrizione IV');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('35','25b3cb3e-0c7e-53b2-88bd-afc47011647d','064 - Circoscrizione V');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('36','25b3cb3e-0c7e-53b2-88bd-afc47011647d','065 - Circoscrizione VI');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('37','25b3cb3e-0c7e-53b2-88bd-afc47011647d','066 - Circoscrizione VII');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('38','25b3cb3e-0c7e-53b2-88bd-afc47011647d','067 - Circoscrizione VIII');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('39','25b3cb3e-0c7e-53b2-88bd-afc47011647d','068 - Circoscrizione IX');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('40','25b3cb3e-0c7e-53b2-88bd-afc47011647d','069 - Circoscrizione X');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('41','25b3cb3e-0c7e-53b2-88bd-afc47011647d','070 - Protezione Civile');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('42','25b3cb3e-0c7e-53b2-88bd-afc47011647d','072 - Sport e Tempo Libero');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('43','25b3cb3e-0c7e-53b2-88bd-afc47011647d','073 - Corpo di Polizia Municipale');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('44','25b3cb3e-0c7e-53b2-88bd-afc47011647d','074 - Ambiente');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('45','25b3cb3e-0c7e-53b2-88bd-afc47011647d','076 - Patrimonio');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('46','25b3cb3e-0c7e-53b2-88bd-afc47011647d','077 - Servizi Bibliotecari');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('47','25b3cb3e-0c7e-53b2-88bd-afc47011647d','078 - Centri di Cultura');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('48','25b3cb3e-0c7e-53b2-88bd-afc47011647d','079 - Suolo Pubblico e Arredo Urbano');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('49','25b3cb3e-0c7e-53b2-88bd-afc47011647d','080 - Garante Diritti Detenuti');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('50','25b3cb3e-0c7e-53b2-88bd-afc47011647d','096 - Informazione e Rapporti con il Cittadino');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('51','25b3cb3e-0c7e-53b2-88bd-afc47011647d','097 - Grandi Opere Edilizie e Verde Pubblico');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('52','25b3cb3e-0c7e-53b2-88bd-afc47011647d','098 - Facility Management');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('53','25b3cb3e-0c7e-53b2-88bd-afc47011647d','099 - Partecipazioni Comunali');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('107','25b3cb3e-0c7e-53b2-88bd-afc47011647d','100 - ATTIVITA'' INTERNAZIONALI E GIOVENTU''');
insert into CPASS_D_AOO_ACTA (aoo_acta_orig_id,ente_id,aoo_descrizione) values ('139','25b3cb3e-0c7e-53b2-88bd-afc47011647d','121 - SISTEMI INFORMATIVI');



update cpass_d_aoo_acta 
set aoo_codice = substr(aoo_descrizione, 1,3);


insert into cpass_r_settore_aoo_acta(
settore_id,
aoo_acta_id)
select cts.settore_id,  cdaa.aoo_acta_id
from (values 
('200260','001'),
('200319','001'),
('200345','001'),
('200085','003'),
('200331','003'),
('200349','003'),
('200104','004'),
('200352','004'),
('200325','004'),
('200224','004'),
('200105','004'),
('200084','004'),
('200323','004'),
('000100','005'),
('200001','029'),
('200261','031'),
('200327','033'),
('200353','034'),
('200040','034'),
('200256','034'),
('200355','034'),
('200356','034'),
('200133','035'),
('200135','035'),
('200342','035'),
('200044','037'),
('200188','037'),
('200354','037'),
('200014','040'),
('200253','040'),
('200390','042'),
('200171','043'),
('200220','043'),
('200338','043'),
('200123','043'),
('200101','043'),
('200102','043'),
('200335','043'),
('200341','043'),
('200326','044'),
('200328','044'),
('200329','044'),
('200068','046'),
('200202','046'),
('200294','046'),
('200271','046'),
('200347','046'),
('200365','046'),
('200360','046'),
('200363','046'),
('200364','046'),
('200260','049'),
('200387','049'),
('200180','050'),
('200259','051'),
('200103','052'),
('200339','052'),
('200077','054'),
('200379','054'),
('200078','054'),
('200081','054'),
('200076','054'),
('200055','055'),
('200196','055'),
('200367','055'),
('200369','055'),
('200234','056'),
('200367','056'),
('200198','056'),
('200368','056'),
('200052','056'),
('200269','058'),
('200333','058'),
('200183','059'),
('200359','059'),
('200147','059'),
('100011','060'),
('100012','061'),
('100013','062'),
('100014','063'),
('100015','064'),
('200124','064'),
('100016','065'),
('200125','065'),
('100017','066'),
('100018','067'),
('200122','067'),
('200152','070'),
('200115','072'),
('200351','072'),
('200386','073'),
('200384','073'),
('200383','073'),
('200155','073'),
('200200','074'),
('200164','074'),
('200372','074'),
('200346','076'),
('200111','076'),
('200086','077'),
('200322','079'),
('200072','097'),
('200370','097'),
('200358','098'),
('200074','098'),
('200050','098'),
('200051','098'),
('200342','098'),
('200344','099')
) AS tmp(settore_codice, aoo_codice)
JOIN cpass.cpass_d_aoo_acta cdaa on (tmp.aoo_codice = cdaa.aoo_codice)
join cpass_t_settore cts on (cts.settore_codice= tmp.settore_codice
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_r_settore_aoo_acta current
  WHERE current.settore_id= cts.settore_id
);


