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


CREATE TABLE if not exists  cpass.cpass_t_ord_impegno_evasione (
    impegno_evasione_id UUID NOT NULL,

    riga_evasione_id UUID NOT NULL,
    impegno_id UUID NOT NULL,
    impegno_ordine_id UUID NOT NULL,

    impegno_progressivo INTEGER NOT NULL,
    impegno_anno_esercizio INTEGER NOT NULL,
    impegno_anno INTEGER NOT NULL,
    impegno_numero INTEGER NOT NULL,
    importo_evaso NUMERIC(13,5),
    importo_liquidato NUMERIC(13,5),
    sospeso boolean,
    sospensione_causale varchar(4000),
    data_sospensione TIMESTAMP WITHOUT TIME ZONE,   
    data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
    utente_creazione VARCHAR(250) NOT NULL,
    data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
    utente_modifica VARCHAR(250) NOT NULL,
    data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
    utente_cancellazione VARCHAR(250),
    optlock UUID DEFAULT uuid_generate_v4() NOT NULL
	,CONSTRAINT cpass_t_ord_impegno_evasione_pkey PRIMARY KEY(impegno_evasione_id)  
    
    ,CONSTRAINT fk_cpass_t_ord_impegno_evasione_riga_evasione FOREIGN KEY (riga_evasione_id)
      REFERENCES cpass.cpass_t_ord_riga_evasione(riga_evasione_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE
    ,CONSTRAINT fk_cpass_t_ord_impegno_evasione_impegno FOREIGN KEY (impegno_id)
    	REFERENCES cpass.cpass_t_impegno(impegno_id)
    	ON DELETE NO ACTION
    	ON UPDATE NO ACTION
    	NOT DEFERRABLE
    ,CONSTRAINT fk_cpass_t_ord_impegno_evasione_impegno_ordine FOREIGN KEY (impegno_ordine_id)
    	REFERENCES cpass.cpass_t_ord_impegno_ordine(impegno_ordine_id)
    	ON DELETE NO ACTION
    	ON UPDATE NO ACTION
    	NOT DEFERRABLE

 );
 
 COMMENT ON TABLE cpass.cpass_t_ord_impegno_evasione
IS 'UUID namespace: "cpass_t_ord_impegno_evasione"';
