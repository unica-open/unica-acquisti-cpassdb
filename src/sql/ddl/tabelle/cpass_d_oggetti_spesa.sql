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
CREATE TABLE cpass.cpass_d_oggetti_spesa(	
     oggetti_spesa_id SERIAL 
    ,oggetti_spesa_codice character varying(50) NOT NULL
    ,oggetti_spesa_descrizione character varying(500) NOT NULL
	,unita_misura_id  INTEGER NOT NULL	
	,cpv_id		 INTEGER NOT NULL
	,aliquote_iva_id INTEGER
	,inventariabile boolean
	, prezzo_unitario NUMERIC (13,5) NOT NULL
	, data_validita_inizio TIMESTAMP NULL 
	, data_validita_fine TIMESTAMP NULL 
    ,data_creazione TIMESTAMP NOT NULL 
    ,utente_creazione CHARACTER VARYING(250) NOT NULL
	,data_modifica TIMESTAMP NOT NULL DEFAULT now()
	,utente_modifica CHARACTER VARYING(250) NOT NULL
	,data_cancellazione TIMESTAMP
	,utente_cancellazione CHARACTER VARYING(250)
	,optlock UUID NOT NULL DEFAULT uuid_generate_v4()
  
    ,CONSTRAINT cpass_d_oggetti_spesa_pkey PRIMARY KEY(oggetti_spesa_id)
);
COMMENT ON TABLE cpass.cpass_d_oggetti_spesa IS 'cpass_d_oggetti_spesa';

ALTER TABLE ONLY cpass.cpass_d_oggetti_spesa ADD CONSTRAINT fk_cpass_d_oggetti_spesa_aliquote_iva FOREIGN KEY (aliquote_iva_id) REFERENCES cpass.cpass_d_aliquote_iva (aliquote_iva_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.cpass_d_oggetti_spesa ADD CONSTRAINT fk_cpass_d_oggetti_spesa_unita_misura FOREIGN KEY (unita_misura_id) REFERENCES cpass.cpass_d_unita_misura (unita_misura_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.cpass_d_oggetti_spesa ADD CONSTRAINT fk_cpass_d_oggetti_spesa_cpv FOREIGN KEY (cpv_id) REFERENCES cpass.cpass_d_cpv (cpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
