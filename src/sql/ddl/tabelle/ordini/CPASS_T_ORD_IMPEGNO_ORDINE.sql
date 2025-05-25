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
DROP TABLE IF EXISTS cpass.CPASS_T_ORD_IMPEGNO_ORDINE CASCADE;

CREATE TABLE CPASS_T_ORD_IMPEGNO_ORDINE(
     impegno_ordine_id UUID NOT NULL 
    ,impegno_id UUID NOT NULL 
    ,riga_ordine_id UUID NOT NULL
    ,impegno_progressivo Integer NOT NULL
    ,impegno_ordine_anno_esercizio Integer
    ,impegno_ordine_anno Integer
    ,impegno_ordine_numero Integer
    ,importo  NUMERIC(13,5)
    ,data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    ,utente_creazione VARCHAR(250) NOT NULL
    ,data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    ,utente_modifica VARCHAR(250) NOT NULL
    ,data_cancellazione TIMESTAMP WITHOUT TIME ZONE
    ,utente_cancellazione VARCHAR(250)
    ,optlock UUID DEFAULT uuid_generate_v4() NOT NULL
    ,CONSTRAINT CPASS_T_ORD_IMPEGNO_ORDINE_pkey PRIMARY KEY(impegno_ordine_id)
);
COMMENT ON TABLE cpass.CPASS_T_ORD_IMPEGNO_ORDINE IS 'UUID namespace: "CPASS_T_ORD_IMPEGNO_ORDINE"';
 
ALTER TABLE ONLY cpass.CPASS_T_ORD_IMPEGNO_ORDINE ADD CONSTRAINT fk_CPASS_T_ORD_IMPEGNO_ORDINE_riga_ordine FOREIGN KEY (riga_ordine_id) REFERENCES cpass.cpass_t_ord_riga_ordine (riga_ordine_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.CPASS_T_ORD_IMPEGNO_ORDINE ADD CONSTRAINT fk_CPASS_T_ORD_IMPEGNO_ORDINE_IMPEGNO FOREIGN KEY (impegno_id) REFERENCES cpass.cpass_t_ord_impegno (impegno_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
