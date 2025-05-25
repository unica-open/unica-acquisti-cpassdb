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


CREATE TABLE if not exists  cpass.cpass_t_ord_subimpegno_evasione (
    subimpegno_evasione_id UUID NOT NULL,
    impegno_evasione_id UUID NOT NULL,
    impegno_anno_esercizio INTEGER NOT NULL,
    impegno_anno INTEGER NOT NULL,
    impegno_numero INTEGER NOT NULL,
    subimpegno_anno INTEGER,
    subimpegno_numero INTEGER,
    subimpegno_importo_evaso NUMERIC(13,5),
    subimpegno_importo_liquidato NUMERIC(13,5),
    subimpegno_id UUID NOT NULL,
    subimpegno_ordine_id  UUID NOT NULL,
    data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
    utente_creazione VARCHAR(250) NOT NULL,
    data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
    utente_modifica VARCHAR(250) NOT NULL,
    data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
    utente_cancellazione VARCHAR(250),
    optlock UUID DEFAULT uuid_generate_v4() NOT NULL
    ,CONSTRAINT cpass_t_ord_subimpegno_evasione_pkey PRIMARY KEY(subimpegno_evasione_id)  

    ,CONSTRAINT fk_cpass_t_ord_impegno_evasione_subimpegno FOREIGN KEY (impegno_evasione_id)
          REFERENCES cpass.cpass_t_ord_impegno_evasione(impegno_evasione_id)
          ON DELETE NO ACTION
          ON UPDATE NO ACTION
          NOT DEFERRABLE    
    ,CONSTRAINT fk_cpass_t_ord_subimpegno_evaso_subimpegno FOREIGN KEY (subimpegno_id)
        REFERENCES cpass.cpass_t_subimpegno(subimpegno_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
        NOT DEFERRABLE

    ,CONSTRAINT fk_cpass_t_ord_subimpegno_evaso_ord_subimpegno FOREIGN KEY (subimpegno_ordine_id)
        REFERENCES cpass.cpass_t_ord_subimpegno_ordine(subimpegno_ordine_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
        NOT DEFERRABLE

);


COMMENT ON TABLE cpass.cpass_t_ord_impegno_evasione
IS 'UUID namespace: "cpass_t_ord_subimpegno_evasione"';
