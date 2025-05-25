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
-- PROD-MULT-01
UPDATE cpass_d_provvedimento_tipo SET ente_id=ente.ente_id
FROM (SELECT ente_id,ente_denominazione  FROM  cpass_t_ente) AS ente
WHERE ente.ente_denominazione = 'CSI';

update cpass.cpass_t_pba_programma 
	set data_trasmissione_mit = data_modifica
	, stato_id = ( select stato_id from cpass_d_stato where stato_codice = 'TRASMESSO')
    where id_ricevuto_mit is not null
    and data_trasmissione_mit is null;
