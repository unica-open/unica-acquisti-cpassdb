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
CREATE TABLE if not exists  cpass.cpass_t_ord_destinatario_evasione (
  destinatario_evasione_id UUID NOT NULL,
  testata_evasione_id UUID NOT NULL,
  progressivo INTEGER NOT NULL, 
  destinatario_id UUID NOT NULL,
  settore_destinatario_id UUID,
  stato_el_ordine_id INTEGER NOT NULL,
  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  optlock UUID DEFAULT uuid_generate_v4() NOT NULL
  ,CONSTRAINT cpass_t_ord_destinatario_evasione_pkey PRIMARY KEY(destinatario_evasione_id)  
  
  ,CONSTRAINT fk_cpass_t_ord_destinatario_evasione_testata_evasione FOREIGN KEY (testata_evasione_id)
    REFERENCES cpass.cpass_t_ord_testata_evasione(testata_evasione_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
  
  ,CONSTRAINT fk_cpass_t_ord_destinatario_evasione_destinatario_ordine FOREIGN KEY (destinatario_id)
    REFERENCES cpass.cpass_t_ord_destinatario_ordine(destinatario_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
   
   ,CONSTRAINT fk_cpass_t_ord_destinatario_evasione_settore FOREIGN KEY (settore_destinatario_id)
    REFERENCES cpass.cpass_t_settore(settore_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
  
  ,CONSTRAINT fk_cpass_t_ord_destinatario_evasione_stato_el_ordine FOREIGN KEY (stato_el_ordine_id)
    REFERENCES cpass.cpass_d_stato_el_ordine(stato_el_ordine_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE 
    
);
COMMENT ON TABLE cpass.cpass_t_ord_destinatario_evasione
IS 'UUID namespace: "cpass_t_ord_destinatario_evasione"';
