---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
    ('MOTIVAZIONE_NON_COMPETENZA', 'in attesa di riassegnazione, in quanto non di competenza dell ufficio/servizio ordinatore', 'RMS', '', '', true)
) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);


CREATE TABLE if not exists cpass.cpass_r_rms_stati_riga_rms (
  rms_stati_riga_rms_id SERIAL,
  riga_rms_id UUID NOT NULL,
  stato VARCHAR(50) NOT NULL,
  motivazione VARCHAR(4000),
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
   CONSTRAINT PK_cpass_r_rms_stati_riga_rms_pkey PRIMARY KEY(rms_stati_riga_rms_id),
  CONSTRAINT fk_riga_rms_riga_rms_id FOREIGN KEY (riga_rms_id)
    REFERENCES cpass.cpass_t_rms_riga_rms(riga_rms_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) ;

CREATE TABLE if not exists cpass.CPASS_R_RMS_RIGA_RDA (
  
  rms_riga_RDA_id serial,
  RIGA_RMS_ID  UUID NOT NULL,
  RIGA_RDA_ID  UUID NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  
  CONSTRAINT PK_CPASS_R_RMS_RIGA_RDA_pkey PRIMARY KEY(rms_riga_RDA_id),
  
  CONSTRAINT fk_cpass_t_rms_riga_rms FOREIGN KEY (riga_rms_id)
    REFERENCES cpass.cpass_t_rms_riga_rms(riga_rms_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  
  CONSTRAINT fk_cpass_t_ord_riga_rda FOREIGN KEY (RIGA_RDA_ID)
    REFERENCES cpass.cpass_t_ord_riga_rda(RIGA_RDA_ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) ;
alter table CPASS_R_RMS_RIGA_RDA add column if not exists quantita integer default 0 not null;
ALTER TABLE cpass.cpass_r_rms_riga_rda
  ALTER COLUMN quantita TYPE NUMERIC(8,2);

insert into CPASS_R_RMS_RIGA_RDA (
   RIGA_RMS_ID  
  ,RIGA_RDA_ID  
  ,data_modifica
  ,utente_modifica
) 
select 
 cpass_t_rms_riga_rms.RIGA_RMS_ID
,cpass_t_rms_riga_rms.RIGA_RDA_ID
,cpass_t_rms_riga_rms.data_modifica
,cpass_t_rms_riga_rms.utente_modifica
from cpass_t_rms_riga_rms
where RIGA_RDA_ID is not null;

alter table CPASS_T_RMS_RIGA_RMS add column if not exists flg_non_competenza boolean;

update cpass_t_rms_riga_rms   set quantita_su_rda = 0  where quantita_su_rda is null ;

DROP VIEW if exists cpass_v_ordine;

CREATE VIEW cpass.cpass_v_ordine AS
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
    cpass_t_ord_destinatario_ordine.data_cancellazione AS data_cancellazione_destinatario,
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
    ord_stato_nso_testata_ordine.stato_nso_descrizione AS stato_invio_nso_destinatario,
    cpass_t_settore_indirizzo.descrizione descrizione_sett_ind, 
    cpass_t_settore_indirizzo.indirizzo AS sett_ind_indirizzo ,
    cpass_t_settore_indirizzo.num_civico AS sett_ind_num_civico,
    cpass_t_settore_indirizzo.localita AS sett_ind_localita,
    cpass_t_settore_indirizzo.provincia AS sett_ind_provincia,
    cpass_t_settore_indirizzo.cap AS sett_ind_cap,
    cpass_t_settore_indirizzo.contatto AS sett_ind_contatto,
    cpass_t_settore_indirizzo.email AS sett_ind_email,
    cpass_t_settore_indirizzo.telefono AS sett_ind_telefono,
    cpass_t_settore_indirizzo.settore_indirizzo_codice AS sett_ind_codice,
    cpass_t_settore_indirizzo.principale AS sett_ind_principale,
    cpass_t_settore_indirizzo.esterno_ente AS sett_ind_esterno_emte
    
FROM cpass_t_ord_testata_ordine
     LEFT JOIN cpass_t_ord_destinatario_ordine ON cpass_t_ord_testata_ordine.testata_ordine_id = cpass_t_ord_destinatario_ordine.testata_ordine_id
     
     LEFT JOIN cpass_t_settore_indirizzo    ON cpass_t_ord_destinatario_ordine.settore_indirizzo_id = cpass_t_settore_indirizzo.settore_indirizzo_id
         
     LEFT JOIN cpass_t_ord_riga_ordine ON cpass_t_ord_destinatario_ordine.destinatario_id = cpass_t_ord_riga_ordine.destinatario_id
     LEFT JOIN cpass_t_ord_impegno_ordine ON cpass_t_ord_riga_ordine.riga_ordine_id = cpass_t_ord_impegno_ordine.riga_ordine_id
     LEFT JOIN cpass_t_impegno ON cpass_t_impegno.impegno_id = cpass_t_ord_impegno_ordine.impegno_id
     LEFT JOIN cpass_t_ord_subimpegno_ordine ON cpass_t_ord_impegno_ordine.impegno_ordine_id = cpass_t_ord_subimpegno_ordine.impegno_ordine_id
     LEFT JOIN cpass_d_ord_stato_nso ord_stato_nso_testata_ordine ON cpass_t_ord_testata_ordine.stato_nso_id = ord_stato_nso_testata_ordine.stato_nso_id
     LEFT JOIN cpass_d_ord_stato_nso ord_stato_nso_destinatario ON cpass_t_ord_destinatario_ordine.stato_nso_id = ord_stato_nso_destinatario.stato_nso_id;
     
     drop view if exists cpass_v_rms_rda_ordine; 
     
     create view cpass_v_rms_rda_ordine AS
select 
  row_number() OVER () AS rms_rda_ordine_id
  ,cpass_t_rms_Testata_rms.testata_rms_id
  ,cpass_t_rms_Testata_rms.rms_anno 
  ,cpass_t_rms_Testata_rms.rms_numero 
  ,cpass_t_rms_Testata_rms.rms_descrizione 
  ,cpass_t_rms_Testata_rms.settore_emittente_id 
  ,cpass_t_rms_Testata_rms.settore_destinatario_id
  ,cpass_t_rms_Testata_rms.settore_indirizzo_id 

  ,cpass_t_rms_riga_rms.riga_rms_id
  ,cpass_t_rms_riga_rms.progressivo_riga
  ,cpass_t_rms_riga_rms.settore_acquisto_id
  ,cpass_t_rms_riga_rms.oggetti_spesa_id
  ,cpass_t_rms_riga_rms.quantita  quantita_riga_rms
  ,cpass_t_rms_riga_rms.sezione_id
  ,cpass_t_rms_riga_rms.quantita_su_rda
  ,cpass_t_ord_riga_rda.riga_rda_id
  ,cpass_t_ord_riga_rda.quantita quantita_riga_rda

  ,cpass_t_ord_testata_rda.testata_rda_id
  ,cpass_t_ord_testata_rda.rda_anno
  ,cpass_t_ord_testata_rda.rda_numero
  ,stato_rda.stato_codice stato_testata_rda

  ,cpass_t_ord_testata_ordine.testata_ordine_id
  ,cpass_t_ord_testata_ordine.ordine_anno
  ,cpass_t_ord_testata_ordine.ordine_numero
  ,stato_ordine.stato_codice stato_testata_ordine

from
cpass_t_rms_Testata_rms
left join cpass_t_rms_riga_rms          ON cpass_t_rms_Testata_rms.testata_rms_id   = cpass_t_rms_riga_rms.testata_rms_id
left join cpass_r_rms_riga_rda 			ON cpass_t_rms_riga_rms.riga_rms_id         = cpass_r_rms_riga_rda.riga_rms_id
left join cpass_t_ord_riga_rda 			ON cpass_r_rms_riga_rda.riga_rda_id         = cpass_t_ord_riga_rda.riga_rda_id
left join cpass_t_ord_testata_rda		ON cpass_t_ord_riga_rda.testata_rda_id      = cpass_t_ord_testata_rda.testata_rda_id
left join cpass_d_stato stato_rda       ON cpass_t_ord_testata_rda.stato_id         = stato_rda.stato_id AND stato_rda.stato_codice !='ANNULLATA'
left join cpass_r_ord_rda_ordine        ON cpass_t_ord_testata_rda.testata_rda_id   = cpass_r_ord_rda_ordine.testata_rda_id
left join cpass_t_ord_testata_ordine    ON cpass_r_ord_rda_ordine.testata_ordine_id = cpass_t_ord_testata_ordine.testata_ordine_id
left join cpass_d_stato stato_ordine    ON cpass_t_ord_testata_ordine.stato_id      = stato_ordine.stato_id AND stato_ordine.stato_codice !='ANNULLATO';
ALTER TABLE cpass_d_permesso ADD COLUMN if not exists modulo_id integer;

ALTER TABLE  cpass_d_permesso drop CONSTRAINT  if exists fk_cpass_d_permesso_d_modulo;

ALTER TABLE ONLY cpass.cpass_d_permesso 
ADD CONSTRAINT  fk_cpass_d_permesso_d_modulo 
FOREIGN KEY (modulo_id) 
REFERENCES cpass.cpass_d_modulo (modulo_id) 
ON DELETE NO ACTION 
ON UPDATE NO ACTION;




CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_confr_progr_sheet1 (
  p_programma_prec varchar,
  p_programma_succ varchar
)
RETURNS TABLE (
  anno_programma integer,
  cui varchar,
  settore varchar,
  descrizione_acquisto varchar,
  annualita integer,
  durata integer,
  lotto_funzionale boolean,
  esente_cup boolean,
  intervento_cup varchar,
  cpv varchar,
  priorita varchar,
  codice_ausa varchar,
  denominazione_ausa varchar,
  totale1anno numeric,
  totale2anno numeric,
  totale3anno numeric,
  totalealtrianni numeric
) AS
$body$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query
select 
PROG.programma_anno anno_programma,
SUCC.intervento_cui CUI,
SETT_INT.settore_interventi_descrizione settore,
SUCC.intervento_descrizione_acquisto descrizione_acquisto,
SUCC.intervento_anno_avvio annualita,
SUCC.intervento_durata_mesi durata,
SUCC.intervento_lotto_funzionale lotto_funzionale,
SUCC.esente_cup esente_cup,
SUCC.intervento_cup cup,
CPV.cpv_codice Codice_Cpv,
P.priorita_descrizione priorita,
AUSA.ausa_codice Codice_Ausa,
AUSA.ausa_descrizione Denominazione_Ausa,
sum(IMP.intervento_importi_importo_anno_primo) as Totale1anno,
sum(IMP.intervento_importi_importo_anno_secondo) as Totale2anno,
sum(IMP.intervento_importi_importo_anno_terzo) as Totale3anno,
sum(IMP.intervento_importi_importo_anni_successivi) as Totalealtrianni
from cpass_t_pba_intervento SUCC
join cpass_t_pba_programma PROG on (PROG.programma_id = SUCC.programma_id)
join cpass_d_pba_settore_interventi SETT_INT on (SETT_INT.settore_interventi_id = SUCC.settore_interventi_id)
join cpass_d_cpv CPV on (CPV.cpv_id = SUCC.cpv_id)
join cpass_d_pba_priorita P on (SUCC.priorita_id = P.priorita_id)
left join cpass_d_pba_ausa AUSA on (AUSA.ausa_id = SUCC.ausa_id)
join cpass_t_pba_intervento_importi IMP on (SUCC.intervento_id = IMP.intervento_id)
where SUCC.programma_id = p_programma_succ::UUID
and IMP.risorsa_id in (select risorsa_id from cpass_d_pba_risorsa cdpr where risorsa_tipo = 'BILANCIO')
and 0 = (select count(*)
         from cpass_t_pba_intervento PREC,
         cpass_t_pba_programma PROG_PREC
         where PROG_PREC.programma_id = p_programma_prec::UUID
         and   PREC.intervento_cui = SUCC.intervento_cui
         and   PROG_PREC.programma_id= PREC.programma_id) 
         and SUCC.stato_id not in (select stato_id
                                       from cpass_d_stato cds 
                                       where stato_tipo = 'INTERVENTO' and stato_codice = 'CANCELLATO')
and 0 = (select count(*)
          from cpass_t_pba_intervento altro
          where altro.intervento_cui = SUCC.intervento_cui 
          and   altro.programma_id in 
            (select programma_id from cpass_t_pba_programma ctpp
            where ctpp.programma_anno <
             (select programma_anno from cpass_t_pba_programma ctpp2
              where ctpp2.programma_id= p_programma_prec::UUID)
            )
          )
group by 
anno_programma,
CUI,
settore,
descrizione_acquisto,
annualita,
durata,
lotto_funzionale,
SUCC.esente_cup,
cup,
Codice_Cpv,
priorita,
Codice_Ausa,
Denominazione_Ausa;

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
and IMP_SUCC.risorsa_id in (select risorsa_id from cpass_d_pba_risorsa cdpr where risorsa_tipo = 'BILANCIO')	
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
and IMP_PREC.risorsa_id in (select risorsa_id from cpass_d_pba_risorsa cdpr where risorsa_tipo = 'BILANCIO')	
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


CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_confr_progr_sheet3 (
  p_programma_prec varchar,
  p_programma_succ varchar
)
RETURNS TABLE (
  anno_programma integer,
  cui varchar,
  settore varchar,
  descrizione_acquisto varchar,
  annualita integer,
  durata integer,
  lotto_funzionale boolean,
  esente_cup boolean,
  intervento_cup varchar,
  cpv varchar,
  priorita varchar,
  codice_ausa varchar,
  denominazione_ausa varchar,
  totale1anno numeric,
  totale2anno numeric,
  totale3anno numeric,
  totalealtrianni numeric
) AS
$body$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query
select 
PROG.programma_anno anno_programma,
SUCC.intervento_cui CUI,
SETT_INT.settore_interventi_descrizione settore,
SUCC.intervento_descrizione_acquisto descrizione_acquisto,
SUCC.intervento_anno_avvio annualita,
SUCC.intervento_durata_mesi durata,
SUCC.intervento_lotto_funzionale lotto_funzionale,
SUCC.esente_cup esente_cup,
SUCC.intervento_cup cup,
CPV.cpv_codice Codice_Cpv,
P.priorita_descrizione priorita,
AUSA.ausa_codice Codice_Ausa,
AUSA.ausa_descrizione Denominazione_Ausa,
sum(IMP.intervento_importi_importo_anno_primo) as Totale1anno,
sum(IMP.intervento_importi_importo_anno_secondo) as Totale2anno,
sum(IMP.intervento_importi_importo_anno_terzo) as Totale3anno,
sum(IMP.intervento_importi_importo_anni_successivi) as Totalealtrianni
from cpass_t_pba_intervento SUCC
join cpass_t_pba_programma PROG on (PROG.programma_id = SUCC.programma_id)
join cpass_d_pba_settore_interventi SETT_INT on (SETT_INT.settore_interventi_id = SUCC.settore_interventi_id)
join cpass_d_cpv CPV on (CPV.cpv_id = SUCC.cpv_id)
join cpass_d_pba_priorita P on (SUCC.priorita_id = P.priorita_id)
left join cpass_d_pba_ausa AUSA on (AUSA.ausa_id = SUCC.ausa_id)
join cpass_t_pba_intervento_importi IMP on (SUCC.intervento_id = IMP.intervento_id)
where SUCC.programma_id = p_programma_succ::UUID
and IMP.risorsa_id in (select risorsa_id from cpass_d_pba_risorsa cdpr where risorsa_tipo = 'BILANCIO')
and 0 = (select count(*)
         from cpass_t_pba_intervento PREC
         where programma_id = p_programma_prec::UUID
         and   PREC.intervento_cui = SUCC.intervento_cui)
and 0 != (select count(*)
          from cpass_t_pba_intervento altro
          where altro.intervento_cui = SUCC.intervento_cui 
          and   altro.programma_id in 
            (select programma_id from cpass_t_pba_programma ctpp
            where ctpp.programma_anno <
             (select programma_anno from cpass_t_pba_programma ctpp2
              where ctpp2.programma_id= p_programma_prec::UUID)
            )
            )
and SUCC.stato_id not in (select stato_id
                              from cpass_d_stato cds 
                              where stato_tipo = 'INTERVENTO' 
							  and stato_codice = 'CANCELLATO')
group by 
anno_programma,
CUI,
settore,
descrizione_acquisto,
annualita,
durata,
lotto_funzionale,
SUCC.esente_cup,
cup,
Codice_Cpv,
priorita,
Codice_Ausa,
Denominazione_Ausa;

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


CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_confr_progr_sheet1 (
  p_programma_prec varchar,
  p_programma_succ varchar
)
RETURNS TABLE (
  anno_programma integer,
  cui varchar,
  settore varchar,
  descrizione_acquisto varchar,
  annualita integer,
  durata integer,
  lotto_funzionale boolean,
  esente_cup boolean,
  intervento_cup varchar,
  cpv varchar,
  priorita varchar,
  codice_ausa varchar,
  denominazione_ausa varchar,
  totale1anno numeric,
  totale2anno numeric,
  totale3anno numeric,
  totalealtrianni numeric
) AS
$body$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query
select 
PROG.programma_anno anno_programma,
SUCC.intervento_cui CUI,
SETT_INT.settore_interventi_descrizione settore,
SUCC.intervento_descrizione_acquisto descrizione_acquisto,
SUCC.intervento_anno_avvio annualita,
SUCC.intervento_durata_mesi durata,
SUCC.intervento_lotto_funzionale lotto_funzionale,
SUCC.esente_cup esente_cup,
SUCC.intervento_cup cup,
CPV.cpv_codice Codice_Cpv,
P.priorita_descrizione priorita,
AUSA.ausa_codice Codice_Ausa,
AUSA.ausa_descrizione Denominazione_Ausa,
sum(IMP.intervento_importi_importo_anno_primo) as Totale1anno,
sum(IMP.intervento_importi_importo_anno_secondo) as Totale2anno,
sum(IMP.intervento_importi_importo_anno_terzo) as Totale3anno,
sum(IMP.intervento_importi_importo_anni_successivi) as Totalealtrianni
from cpass_t_pba_intervento SUCC
join cpass_t_pba_programma PROG on (PROG.programma_id = SUCC.programma_id)
join cpass_d_pba_settore_interventi SETT_INT on (SETT_INT.settore_interventi_id = SUCC.settore_interventi_id)
join cpass_d_cpv CPV on (CPV.cpv_id = SUCC.cpv_id)
join cpass_d_pba_priorita P on (SUCC.priorita_id = P.priorita_id)
left join cpass_d_pba_ausa AUSA on (AUSA.ausa_id = SUCC.ausa_id)
join cpass_t_pba_intervento_importi IMP on (SUCC.intervento_id = IMP.intervento_id)
where SUCC.programma_id = p_programma_succ::UUID
and IMP.risorsa_id in (select risorsa_id from cpass_d_pba_risorsa cdpr where risorsa_tipo = 'BILANCIO')
and 0 = (select count(*)
         from cpass_t_pba_intervento PREC,
         cpass_t_pba_programma PROG_PREC
         where PROG_PREC.programma_id = p_programma_prec::UUID
         and   PREC.intervento_cui = SUCC.intervento_cui
         and   PROG_PREC.programma_id= PREC.programma_id) 
         and SUCC.stato_id not in (select stato_id
                                       from cpass_d_stato cds 
                                       where stato_tipo = 'INTERVENTO' and stato_codice = 'CANCELLATO')
and 0 = (select count(*)
          from cpass_t_pba_intervento altro
          where altro.intervento_cui = SUCC.intervento_cui 
          and   altro.programma_id in 
            (select programma_id from cpass_t_pba_programma ctpp
            where ctpp.programma_anno <
             (select programma_anno from cpass_t_pba_programma ctpp2
              where ctpp2.programma_id= p_programma_prec::UUID)
            )
          )
group by 
anno_programma,
CUI,
settore,
descrizione_acquisto,
annualita,
durata,
lotto_funzionale,
SUCC.esente_cup,
cup,
Codice_Cpv,
priorita,
Codice_Ausa,
Denominazione_Ausa;

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
and IMP_SUCC.risorsa_id in (select risorsa_id from cpass_d_pba_risorsa cdpr where risorsa_tipo = 'BILANCIO')	
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
and IMP_PREC.risorsa_id in (select risorsa_id from cpass_d_pba_risorsa cdpr where risorsa_tipo = 'BILANCIO')	
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


CREATE OR REPLACE FUNCTION cpass.pck_cpass_pba_rep_confr_progr_sheet3 (
  p_programma_prec varchar,
  p_programma_succ varchar
)
RETURNS TABLE (
  anno_programma integer,
  cui varchar,
  settore varchar,
  descrizione_acquisto varchar,
  annualita integer,
  durata integer,
  lotto_funzionale boolean,
  esente_cup boolean,
  intervento_cup varchar,
  cpv varchar,
  priorita varchar,
  codice_ausa varchar,
  denominazione_ausa varchar,
  totale1anno numeric,
  totale2anno numeric,
  totale3anno numeric,
  totalealtrianni numeric
) AS
$body$
DECLARE

RTN_MESSAGGIO text;

BEGIN

return query
select 
PROG.programma_anno anno_programma,
SUCC.intervento_cui CUI,
SETT_INT.settore_interventi_descrizione settore,
SUCC.intervento_descrizione_acquisto descrizione_acquisto,
SUCC.intervento_anno_avvio annualita,
SUCC.intervento_durata_mesi durata,
SUCC.intervento_lotto_funzionale lotto_funzionale,
SUCC.esente_cup esente_cup,
SUCC.intervento_cup cup,
CPV.cpv_codice Codice_Cpv,
P.priorita_descrizione priorita,
AUSA.ausa_codice Codice_Ausa,
AUSA.ausa_descrizione Denominazione_Ausa,
sum(IMP.intervento_importi_importo_anno_primo) as Totale1anno,
sum(IMP.intervento_importi_importo_anno_secondo) as Totale2anno,
sum(IMP.intervento_importi_importo_anno_terzo) as Totale3anno,
sum(IMP.intervento_importi_importo_anni_successivi) as Totalealtrianni
from cpass_t_pba_intervento SUCC
join cpass_t_pba_programma PROG on (PROG.programma_id = SUCC.programma_id)
join cpass_d_pba_settore_interventi SETT_INT on (SETT_INT.settore_interventi_id = SUCC.settore_interventi_id)
join cpass_d_cpv CPV on (CPV.cpv_id = SUCC.cpv_id)
join cpass_d_pba_priorita P on (SUCC.priorita_id = P.priorita_id)
left join cpass_d_pba_ausa AUSA on (AUSA.ausa_id = SUCC.ausa_id)
join cpass_t_pba_intervento_importi IMP on (SUCC.intervento_id = IMP.intervento_id)
where SUCC.programma_id = p_programma_succ::UUID
and IMP.risorsa_id in (select risorsa_id from cpass_d_pba_risorsa cdpr where risorsa_tipo = 'BILANCIO')
and 0 = (select count(*)
         from cpass_t_pba_intervento PREC
         where programma_id = p_programma_prec::UUID
         and   PREC.intervento_cui = SUCC.intervento_cui)
and 0 != (select count(*)
          from cpass_t_pba_intervento altro
          where altro.intervento_cui = SUCC.intervento_cui 
          and   altro.programma_id in 
            (select programma_id from cpass_t_pba_programma ctpp
            where ctpp.programma_anno <
             (select programma_anno from cpass_t_pba_programma ctpp2
              where ctpp2.programma_id= p_programma_prec::UUID)
            )
            )
and SUCC.stato_id not in (select stato_id
                              from cpass_d_stato cds 
                              where stato_tipo = 'INTERVENTO' 
							  and stato_codice = 'CANCELLATO')
group by 
anno_programma,
CUI,
settore,
descrizione_acquisto,
annualita,
durata,
lotto_funzionale,
SUCC.esente_cup,
cup,
Codice_Cpv,
priorita,
Codice_Ausa,
Denominazione_Ausa;

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


