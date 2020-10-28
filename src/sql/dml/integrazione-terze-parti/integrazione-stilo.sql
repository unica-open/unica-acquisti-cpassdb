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
-- Ambiente TEST
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('CODICE_ENTE', 'REGP', 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', true),
	('CODICE_APPLICATIVO', 'CPASS', 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', true),
    ('WSDL_LOCATION', 'https://digidoc-coll.eng.it/AurigaBusiness2/soap/WSGetMetadataUd?wsdl', 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', false),
	('USER', 'USER-CPASS', 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', true),
	('PW', '', 'PROVVEDIMENTO', 'STILO', 'Per interrogazione Provvedimento', true)

) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);
