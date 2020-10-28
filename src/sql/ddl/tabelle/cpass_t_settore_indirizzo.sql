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
DROP TABLE IF EXISTS cpass.cpass_t_settore_indirizzo CASCADE;

create table cpass.cpass_t_settore_indirizzo (
    settore_indirizzo_id SERIAL 
    ,descrizione varchar (50) 
    ,indirizzo varchar(200)  
    ,num_civico varchar(20) 
    ,localita varchar(200)    
    ,provincia varchar(200)   
    ,cap varchar(5)           
    ,contatto varchar(200) 
    ,email varchar(50)       
    ,telefono varchar(50)     
    ,settore_id uuid
    ,CONSTRAINT cpass_t_settore_indirizzo_pkey PRIMARY KEY(settore_indirizzo_id)
    ,CONSTRAINT fk_cpass_T_settore_settore_indirizzo FOREIGN KEY (settore_id) REFERENCES cpass_T_settore(settore_id)
);

