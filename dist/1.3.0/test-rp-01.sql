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

update cpass.cpass_d_oggetti_spesa set ente_id = (select ente_id from cpass_t_ente where cpass_t_ente.ente_codice = 'REGP');
update cpass.cpass_t_progressivo set ente_id = (select ente_id from cpass_t_ente where cpass_t_ente.ente_codice = 'REGP');
ALTER TABLE IF EXISTS cpass.cpass_t_progressivo DROP CONSTRAINT IF EXISTS cpass_t_progressivo_pkey;
ALTER TABLE IF EXISTS cpass.cpass_t_progressivo ADD CONSTRAINT cpass_t_progressivo_pkey PRIMARY KEY(progressivo_tipo, progressivo_codice, ente_id);


INSERT INTO cpass.cpass_t_progressivo (progressivo_tipo, progressivo_codice, progressivo_numero, ente_id)
SELECT tmp.progressivo_tipo, tmp.progressivo_codice, tmp.progressivo_numero,cte.ente_id
FROM (VALUES
  ('RMS.TESTATA','REGP-2021',0,'REGP')
) AS tmp(progressivo_tipo, progressivo_codice,progressivo_numero,ente)
join cpass_t_ente cte on (cte.ente_codice = tmp.ente)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_progressivo current
  WHERE current.progressivo_tipo = tmp.progressivo_tipo
  	AND current.progressivo_codice = tmp.progressivo_codice
);

INSERT INTO cpass.cpass_d_oggetti_spesa (	
	oggetti_spesa_codice,
	oggetti_spesa_descrizione,
	unita_misura_id,
	cpv_id,
	prezzo_unitario,
	data_validita_inizio,
	data_creazione,
	utente_creazione,
	utente_modifica,
	generico,
	ente_id
)
SELECT tmp.codice, tmp.descrizione, ui.unita_misura_id, cpv.cpv_id, tmp.prezzo_unitario, now(),now(),'SYSTEM','SYSTEM',tmp.generico,cte.ente_id
FROM (VALUES
  ('999999','Oggetto generico per materiale ufficio','C62','30000000-9',0,true, 'REGP')
) AS tmp (codice, descrizione, unita_misura, cpv, prezzo_unitario, generico, ente)
join cpass_d_unita_misura ui on ( ui.unita_misura_codice = tmp.unita_misura)
join cpass_d_cpv cpv on (cpv_codice = tmp.cpv)
join cpass_t_ente cte on (cte.ente_codice = tmp.ente)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_oggetti_spesa current
  WHERE current.oggetti_spesa_codice = tmp.codice
);