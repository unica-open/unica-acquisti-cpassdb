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
CREATE TABLE cpass.cpass_r_fruitore_servizio (
	fruitore_servizio_id serial NOT NULL,
	fruitore_id int4 NOT NULL,
	servizio_id int4 NOT NULL,
	data_validita_inizio timestamp NOT NULL DEFAULT now(),
	data_validita_fine timestamp NULL,
	CONSTRAINT cpass_r_fruitore_servizio_pkey PRIMARY KEY (fruitore_servizio_id),
	CONSTRAINT fk_cpass_r_fruitore_servizio_t_fruitore FOREIGN KEY (fruitore_id) REFERENCES cpass_t_fruitore(fruitore_id),
	CONSTRAINT fk_cpass_r_fruitore_servizio_t_servizio FOREIGN KEY (servizio_id) REFERENCES cpass_t_servizio(servizio_id)
);