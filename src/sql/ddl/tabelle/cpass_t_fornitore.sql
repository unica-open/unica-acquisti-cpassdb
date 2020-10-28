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
CREATE TABLE cpass.cpass_t_fornitore(	
    fornitore_id UUID 
    ,codice varchar(50)
    ,natura_giuridica varchar(5)
	,ragione_sociale varchar(200)	--"RAGSOC" VARCHAR2(150 BYTE) NOT NULL ENABLE, 
	,cognome varchar(50)				--"COGNOME" VARCHAR2(50 BYTE), 
	,nome varchar(50)   				--"NOME" VARCHAR2(50 BYTE), 
	,codice_fiscale varchar(16)      --"CODFISC" VARCHAR2(16 BYTE), 
	,codice_fiscale_estero varchar(21)     -- "CODFISC_ESTERO" VARCHAR2(21 BYTE),
	,partita_iva VARCHAR(11)--"PARTIVA" VARCHAR2(11 BYTE), 	
	--,sedime VARCHAR(10)--"SEDIME" VARCHAR2(10 BYTE), 
	,indirizzo varchar(500) --"VIA" VARCHAR2(500 BYTE), 
	,numero_civico varchar(40)--"N_CIVICO" VARCHAR2(40 BYTE), 
	,cap varchar(5)--"CAP" VARCHAR2(5 BYTE), 
	,comune varchar(200)--"COMUNE" VARCHAR2(50 BYTE), 
	,provincia varchar(2)--"PROV" VARCHAR2(2 BYTE), 
	--,nazione VARCHAR(3)--"COD_STATO" VARCHAR2(3 BYTE), 
	--,telefono VARCHAR(20) --"TEL1" VARCHAR2(20 BYTE), 
	--,telefono2 VARCHAR(20) --"TEL2" VARCHAR2(20 BYTE), 
	--,fax VARCHAR(20)--"FAX" VARCHAR2(15 BYTE), 	
    ,stato varchar(10) --"STAOPER" VARCHAR2(1 BYTE) NOT NULL ENABLE,  dalla tabella statieventualmente	
    ,CONSTRAINT cpass_t_fornitore_pkey PRIMARY KEY(fornitore_id)
    );
