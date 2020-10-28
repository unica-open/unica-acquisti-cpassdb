---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2020 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2020 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
---
CREATE TABLE cpass_t_ord_riga_ordine(	
     riga_ordine_id UUID
    ,consegna_parziale boolean
    ,progressivo INTEGER
    ,prezzo_unitario NUMERIC(13,5)
    ,quantita Integer 
	,percentuale_sconto  NUMERIC(8,5)--"SCONTO1" NUMBER(8,5), 
	,importo_sconto  NUMERIC(8,5)--"SCONTO1" NUMBER(8,5), 	
    ,percentuale_sconto2  NUMERIC(8,5)--"SCONTO2" NUMBER(8,5), 
	,importo_sconto2  NUMERIC(8,5)--"SCONTO1" NUMBER(8,5), 
	,importo_netto  NUMERIC(13,5)--"SCONTO1" NUMBER(8,5), 	
	,importo_totale  NUMERIC(13,5)--"SCONTO1" NUMBER(8,5), 	
    ,stato_el_ordine_id  INTEGER NOT NULL     --> cpass_d_stato_el_ordine 
    ,oggetti_spesa_id INTEGER NOT NULL
    --,cpv_id INTEGER NOT NULL
    ,unita_misura_id INTEGER NOT NULL
    ,aliquote_iva_id INTEGER NOT NULL
    ,destinatario_id UUID NOT NULL
    ,data_creazione TIMESTAMP NOT NULL 
    ,utente_creazione CHARACTER VARYING(250) NOT NULL
	,data_modifica TIMESTAMP NOT NULL DEFAULT now()
	,utente_modifica CHARACTER VARYING(250) NOT NULL
	,data_cancellazione TIMESTAMP
	,utente_cancellazione CHARACTER VARYING(250)
	,optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    ,CONSTRAINT cpass_t_ord_riga_ordine_pkey PRIMARY KEY(riga_ordine_id)
 );
COMMENT ON TABLE cpass.cpass_t_ord_destinatario IS 'UUID namespace: "cpass_t_ord_riga_ordine"';
 
ALTER TABLE ONLY cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_ordine_destinatario_ordine FOREIGN KEY (destinatario_id) REFERENCES cpass.cpass_t_ord_destinatario (destinatario_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_ordine_aliquote_iva FOREIGN KEY (aliquote_iva_id) REFERENCES cpass.cpass_d_aliquote_iva (aliquote_iva_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--ALTER TABLE ONLY cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_ordine_cpv FOREIGN KEY (cpv_id) REFERENCES cpass.cpass_d_cpv (cpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_oggetti_spesa FOREIGN KEY (oggetti_spesa_id) REFERENCES cpass.cpass_d_oggetti_spesa (oggetti_spesa_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_ordine_unita_misura FOREIGN KEY (unita_misura_id) REFERENCES cpass.cpass_d_unita_misura (unita_misura_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
 
ALTER TABLE ONLY cpass.cpass_t_ord_riga_ordine ADD CONSTRAINT fk_cpass_t_ord_riga_ordine_stato_el_ordine FOREIGN KEY (stato_el_ordine_id) REFERENCES cpass.cpass_d_stato_el_ordine (stato_el_ordine_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
