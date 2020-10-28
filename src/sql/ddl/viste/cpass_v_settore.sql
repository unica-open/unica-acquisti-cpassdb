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
drop view if exists cpass.cpass_v_settore;
CREATE OR REPLACE VIEW cpass.cpass_v_settore
AS WITH RECURSIVE alberosettore AS (
         SELECT 1 AS livello,
            NULL::uuid AS settore_id_padre,
            s.settore_id,
            s.settore_codice,
            s.settore_descrizione,
            s.settore_indirizzo,
            s.settore_localita,
            s.settore_cap,
            s.settore_provincia,
            s.settore_telefono,
            s.settore_num_civico ,
            s.settore_contatto,
            s.settore_email ,
            s.ente_id
           FROM cpass_t_settore s
             --JOIN cpass_t_ente e ON e.ente_id = s.ente_id AND e.ente_denominazione::text = 'REGIONE PIEMONTE'::text
          WHERE s.settore_padre_id IS null
          and (
          	s.data_cancellazione is null or (s.data_cancellazione is not null and s.data_cancellazione >= date_trunc('day',now()))
          	)
        UNION ALL
         SELECT mtree.livello + 1,
            mtree.settore_id AS settore_id_padre,
            s_figlio.settore_id,
            s_figlio.settore_codice,
            s_figlio.settore_descrizione,
            s_figlio.settore_indirizzo,
            s_figlio.settore_localita,
            s_figlio.settore_cap,
            s_figlio.settore_provincia,
            s_figlio.settore_telefono,
            s_figlio.settore_num_civico ,
            s_figlio.settore_contatto,
            s_figlio.settore_email ,
            s_figlio.ente_id 
           FROM cpass_t_settore s_figlio
           JOIN alberosettore mtree ON mtree.settore_id = s_figlio.settore_padre_id
           where (s_figlio.data_cancellazione is null or (s_figlio.data_cancellazione is not null and s_figlio.data_cancellazione >= date_trunc('day',now())))
        )
 SELECT
    row_number() OVER () AS id_v_settore,
    alberosettore.livello,
    alberosettore.settore_id_padre,
    alberosettore.settore_id,
    alberosettore.settore_codice,
    alberosettore.settore_descrizione,
    alberosettore.settore_indirizzo,
    alberosettore.settore_localita,
    alberosettore.settore_cap,
    alberosettore.settore_provincia,
    alberosettore.settore_telefono,
    alberosettore.settore_num_civico ,
    alberosettore.settore_contatto,
    alberosettore.settore_email ,
    alberosettore.ente_id
   FROM alberosettore
  ORDER BY alberosettore.livello DESC, alberosettore.settore_id;

-- Permissions

ALTER TABLE cpass.cpass_v_settore OWNER TO cpass;
GRANT ALL ON TABLE cpass.cpass_v_settore TO cpass;
