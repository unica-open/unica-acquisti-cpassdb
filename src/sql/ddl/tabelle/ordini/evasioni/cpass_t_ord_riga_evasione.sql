---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
---

CREATE TABLE if not exists  cpass.cpass_t_ord_riga_evasione (
  riga_evasione_id UUID NOT NULL,
  progressivo INTEGER NOT NULL, 
  quantita NUMERIC(8,2),
  importo_totale NUMERIC(13,5),
  prezzo_unitario NUMERIC(13,5),
  destinatario_evasione_id UUID NOT NULL,
  riga_ordine_id UUID NOT NULL,
  aliquote_iva_id INTEGER NOT NULL,
  oggetti_spesa_id INTEGER NOT NULL,
  stato_el_ordine_id INTEGER NOT NULL,
  listino_fornitore_id INTEGER,
  documento_trasporto_id INTEGER, 
  data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_creazione VARCHAR(250) NOT NULL,
  data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  utente_modifica VARCHAR(250) NOT NULL,
  data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  utente_cancellazione VARCHAR(250),
  optlock UUID DEFAULT uuid_generate_v4() NOT NULL
  ,CONSTRAINT cpass_t_ord_riga_evasione_pkey PRIMARY KEY(riga_evasione_id)  
  ,CONSTRAINT fk_cpass_t_ord_riga_evasione_destinatario_evasione FOREIGN KEY (destinatario_evasione_id)
      REFERENCES cpass.cpass_t_ord_destinatario_evasione(destinatario_evasione_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE

  ,CONSTRAINT fk_cpass_t_ord_riga_evasione_riga_ordine FOREIGN KEY (riga_ordine_id)
      REFERENCES cpass.cpass_t_ord_riga_ordine(riga_ordine_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE
   
   ,CONSTRAINT fk_cpass_t_ord_riga_evasione_aliquote_iva FOREIGN KEY (aliquote_iva_id)
      REFERENCES cpass.cpass_d_aliquote_iva(aliquote_iva_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE

    ,CONSTRAINT fk_cpass_t_ord_riga_evasione_oggetti_spesa FOREIGN KEY (oggetti_spesa_id)
      REFERENCES cpass.cpass_d_oggetti_spesa(oggetti_spesa_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE
      
    ,CONSTRAINT fk_cpass_t_ord_riga_evasione_stato_el_ordine FOREIGN KEY (stato_el_ordine_id)
      REFERENCES cpass.cpass_d_stato_el_ordine(stato_el_ordine_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE
    
    ,CONSTRAINT fk_cpass_t_ord_riga_evasionee_listino_fornitore FOREIGN KEY (listino_fornitore_id)
      REFERENCES cpass.cpass_t_listino_fornitore(listino_fornitore_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE
      
     ,CONSTRAINT fk_cpass_t_ord_riga_evasionee_ddt FOREIGN KEY (documento_trasporto_id)
      REFERENCES cpass.cpass_t_documento_trasporto_riga(documento_trasporto_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
      NOT DEFERRABLE      
);

 COMMENT ON TABLE cpass.cpass_t_ord_riga_evasione
IS 'UUID namespace: "cpass_t_ord_riga_evasione"';
