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
CREATE TABLE cpass.cpass_t_impegno (
	impegno_id UUID
	, ente_id UUID NOT NULL
	, impegno_anno_esercizio  INTEGER NOT NULL
	, impegno_anno INTEGER NOT NULL
	, impegno_numero INTEGER NOT NULL
	, impegno_descrizione varchar(150)
	, numero_capitolo INTEGER NOT NULL
	, numero_articolo INTEGER NOT NULL
	, descrizione_capitolo varchar(500)
	, provvedimento_anno INTEGER NOT NULL
	, provvedimento_numero INTEGER NOT NULL
	, provvedimento_settore varchar(50)
	, fornitore_id UUID NOT NULL
	, importo_iniziale NUMERIC NOT NULL
	, importo_attuale NUMERIC NOT NULL
	, stato varchar(1)
	, liq_anno_prec NUMERIC NOT NULL
    , data_creazione TIMESTAMP NOT NULL 
    , utente_creazione CHARACTER VARYING(250) NOT NULL
	, data_modifica TIMESTAMP NOT NULL DEFAULT now()
	, utente_modifica CHARACTER VARYING(250) NOT NULL
	, data_cancellazione TIMESTAMP
	, utente_cancellazione CHARACTER VARYING(250)
	, optlock UUID NOT NULL DEFAULT uuid_generate_v4()
    , CONSTRAINT cpass_t_impegno_pkey PRIMARY KEY(impegno_id)
	);
COMMENT ON TABLE cpass.cpass_t_impegno IS 'UUID namespace: "cpass_t_impegno"';

ALTER TABLE ONLY cpass.cpass_t_impegno ADD CONSTRAINT fk_cpass_t_impegno_ente FOREIGN KEY (ente_id) REFERENCES cpass.cpass_t_ente (ente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_impegno ADD CONSTRAINT fk_cpass_t_impegno_fornitore FOREIGN KEY (fornitore_id) REFERENCES cpass.cpass_t_fornitore (fornitore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
