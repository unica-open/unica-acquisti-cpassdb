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
    
  CREATE TABLE cpass.cpass_t_ord_destinatario(	
     destinatario_id UUID  
	,indirizzo varchar(200)   --"INDIR_DEST" VARCHAR2(50 BYTE), 
	,num_civico varchar(20) 
	,localita varchar(200)    --"LOCAL_DEST" VARCHAR2(50 BYTE), 
	,provincia varchar(200)   --"PROV_DEST" VARCHAR2(2 BYTE), 
	,cap varchar(5)           --"CAP_DEST" VARCHAR2(5 BYTE), 
	,contatto varchar(200) --"DESCR_DEST" VARCHAR2(150 BYTE), 
	,email varchar(50)        --"DESCR_DEST" VARCHAR2(150 BYTE), 
	,telefono varchar(50)     --"DESCR_DEST" VARCHAR2(150 BYTE), 	
	,data_invio_nso TIMESTAMP WITHOUT TIME ZONE
	,stato_nso_id INTEGER
    ,settore_destinatario_id  UUID  -- cpass_d_settore	
    ,stato_el_ordine_id  INTEGER NOT NULL     --> cpass_d_stato_el_ordine 
    ,testata_ordine_id UUID NOT NULL
    ,progressivo INTEGER  NOT NULL
    ,data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    ,utente_creazione CHARACTER VARYING(250) NOT NULL
	,data_modifica TIMESTAMP NOT NULL DEFAULT now()
	,utente_modifica CHARACTER VARYING(250) NOT NULL
	,data_cancellazione TIMESTAMP
	,utente_cancellazione CHARACTER VARYING(250)
	,optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    ,CONSTRAINT cpass_t_ord_destinatario_pkey PRIMARY KEY(destinatario_id)
	);
	
COMMENT ON TABLE cpass.cpass_t_ord_destinatario IS 'UUID namespace: "cpass_t_ord_destinatario"';

ALTER TABLE ONLY cpass.cpass_t_ord_destinatario ADD CONSTRAINT fk_cpass_t_ord_destinatario_testata_ordine FOREIGN KEY (testata_ordine_id) REFERENCES cpass.cpass_t_ord_testata_ordine (testata_ordine_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.cpass_t_ord_destinatario ADD CONSTRAINT fk_cpass_t_ord_destinatario_stato_el_ordine FOREIGN KEY (stato_el_ordine_id) REFERENCES cpass.cpass_d_stato_el_ordine (stato_el_ordine_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.cpass_t_ord_destinatario ADD CONSTRAINT fk_cpass_t_ord_destinatario_settore FOREIGN KEY (settore_destinatario_id) REFERENCES cpass.cpass_t_settore (settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE cpass_t_ord_destinatario
ADD CONSTRAINT cpass_t_ord_destinatario_testata_progressivo_unique UNIQUE (testata_ordine_id,progressivo);
