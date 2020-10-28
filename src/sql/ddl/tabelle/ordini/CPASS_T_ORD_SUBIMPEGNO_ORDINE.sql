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
CREATE TABLE cpass.CPASS_T_ORD_SUBIMPEGNO_ORDINE(
     subimpegno_ordine_id UUID NOT NULL 
    ,impegno_ordine_id UUID NOT NULL 
    ,subimpegno_id UUID NOT NULL 
    ,impegno_anno Integer
    ,impegno_numero Integer
    ,subimpegno_anno Integer
    ,subimpegno_numero Integer
    ,subimpegno_importo  NUMERIC(13,5)
    ,data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    ,utente_creazione VARCHAR(250) NOT NULL
    ,data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
    ,utente_modifica VARCHAR(250) NOT NULL
    ,data_cancellazione TIMESTAMP WITHOUT TIME ZONE
    ,utente_cancellazione VARCHAR(250)
    ,optlock UUID DEFAULT uuid_generate_v4() NOT NULL
    ,CONSTRAINT CPASS_T_ORD_SUBIMPEGNO_ORDINE_pkey PRIMARY KEY(subimpegno_ordine_id)
);

COMMENT ON TABLE cpass.CPASS_T_ORD_SUBIMPEGNO_ORDINE IS 'UUID namespace: "CPASS_T_ORD_SUBIMPEGNO_ORDINE"';
 
ALTER TABLE ONLY cpass.CPASS_T_ORD_SUBIMPEGNO_ORDINE ADD CONSTRAINT fk_CPASS_T_ORD_SUBIMPEGNO_ORDINE_IMPEGNO_ORDINE FOREIGN KEY (impegno_ordine_id) REFERENCES cpass.CPASS_T_ORD_IMPEGNO_ORDINE (impegno_ordine_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.CPASS_T_ORD_SUBIMPEGNO_ORDINE ADD CONSTRAINT fk_CPASS_T_ORD_SUBIMPEGNO_ORDINE_SUBIMPEGNO FOREIGN KEY (subimpegno_id) REFERENCES cpass.cpass_t_subimpegno (subimpegno_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
