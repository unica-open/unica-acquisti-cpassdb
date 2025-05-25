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
-- DEV-CMTO-01


alter table appoggio_testata_ordine add column if not exists id serial;
alter table appoggio_testata_ordine add column if not exists  esito VARCHAR(2);


alter table appoggio_ordine_righe_dest add column if not exists id serial;
alter table appoggio_ordine_righe_dest add column if not exists esito VARCHAR(2);

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('CONGRUENZA_BENI_IMPEGNI', 'true', true, '', 'CPASS', 'indica se il sistema deve verificare la congruenza dati nell''ordine tra ods e finanziario associato','CMTO')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);



UPDATE cpass.cpass_t_ente SET path_logo='/img/logo_torino_metropoli.png', link='http://www.cittametropolitana.torino.it/'
where ente_codice ='CMTO';

update cpass_t_fornitore set ente_id = (select ente_id from cpass_t_ente where ente_codice = 'CMTO');
alter table IF EXISTS  cpass.cpass_t_fornitore alter column ente_id set not null;
