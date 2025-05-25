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
CREATE TABLE cpass.cpass_r_ufficio_settore (
   ufficio_settore_id  SERIAL ,
   ufficio_id integer NOT NULL,
   settore_id UUID NOT NULL,
   data_validita_inizio TIMESTAMP NOT NULL,
   data_validita_fine TIMESTAMP,
   CONSTRAINT cpass_r_ufficio_settore_pkey PRIMARY KEY(ufficio_settore_id)
);

ALTER TABLE ONLY cpass.cpass_r_ufficio_settore ADD CONSTRAINT fk_cpass_r_ufficio_settore_t_ufficio FOREIGN KEY (ufficio_id) REFERENCES cpass.cpass_t_ufficio (ufficio_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.cpass_r_ufficio_settore ADD CONSTRAINT fk_cpass_r_ufficio_settore_t_settore FOREIGN KEY (settore_id) REFERENCES cpass.cpass_t_settore (settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
