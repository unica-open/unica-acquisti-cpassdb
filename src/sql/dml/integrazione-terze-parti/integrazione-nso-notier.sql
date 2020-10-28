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
	('IMPLEMENTOR',           'notier',                                                                               'NSO', '',       'Per interrogazione NSO', true),
	('IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.notier.NSOHelperImpl', 	                      'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('NSO_CUSTOMIZATION_ID',  'urn:fdc:peppol.eu:poacc:trns:order:3:restrictive:urn:www.agid.gov.it:trns:ordine:3.1', 'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('NSO_PROFILE_ID',        'urn:fdc:peppol.eu:poacc:bis:order_only:3',                                             'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('HOST_NOTIER',           'TOBD',                                                                                 'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('PORTA_NOTIER',          'TOBD',                                                                                 'NSO', 'NOTIER', 'Per interrogazione NSO', true)
	) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);
