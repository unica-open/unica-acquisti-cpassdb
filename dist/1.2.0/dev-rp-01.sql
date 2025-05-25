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

update  cpass_t_ufficio 
set id_notier = 'ACSI_03_UNICAA1511C'
where ufficio_codice = 'S04VFA';

update  cpass_t_ufficio 
set id_notier = 'ACSI_01_UNICAA1111C'
where ufficio_codice = '7K3KWF';

update  cpass_t_ufficio 
set id_notier = 'ACSI_02_UNICA'
where ufficio_codice = '81YHY9';

delete from cpass.cpass_t_parametro where chiave in ('INTEGRAZIONE_NSO','NSO_UNICO_DESTINATARIO') and ambiente <> 'NOTIER';
INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('INTEGRAZIONE_NSO', 'true', true, 'NSO', 'NOTIER', 'indica se il sistema si integra con NSO','REGP'),
  ('NSO_UNICO_DESTINATARIO', 'true', true, 'NSO', 'NOTIER', 'indica se il sistema si integra con NSO','REGP'),
  ('SISTEMA_DOCUMENTALE', 'NO PROTOCOLLO', true, 'PROTOCOLLO', 'ACTA', 'Aggancio al protocollo','REGP')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);

-- configurazione integrazione notier
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
    ('PROTOCOL_NOTIER','https','NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('KEYSTORE_PATH_NOTIER',@value@,'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('KEYSTORE_PASS_NOTIER',@value@,'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('KEY_PASS_NOTIER',@value@,'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('NSO_DOCUMENT_ID',@value@,'NSO', 'NOTIER', 'Per interrogazione NSO', true)
	) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);
--configurazione integrazione notier per ente
INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
    ('NSO_RECIPIENT_ID','0201:testap', true,'NSO', 'NOTIER', 'Per integrazione NSO, valorizzare SOLO per ambiente di test o sviluppo. Se lasciato bianco il dato viene valorizzato a runtime.', 'REGP')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);

-- configurazione integrazione MIT
update cpass.cpass_t_parametro set valore = '3128' where chiave='MIT_PROXY_PORT';
update cpass.cpass_t_parametro set valore = 'podto2-proxy.site02.nivolapiemonte.it' where chiave = 'MIT_PROXY_HOSTNAME';
update cpass.cpass_t_parametro set valore = 'RegPiemonteApp' where chiave = 'MIT_CLIENT_ID';
update cpass.cpass_t_parametro set valore = 'A$nCot5xAuA3Gd95' where chiave = 'MIT_CLIENT_KEY';
update cpass.cpass_t_parametro set valore = 'RegPiemonte' where chiave = 'MIT_USERNAME';
update cpass.cpass_t_parametro set valore = 'Acquistireg1!' where chiave = 'MIT_PASSWORD';

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, NULL
FROM (VALUES
  ('AMBIENTE','TEST',true,'PROVVEDIMENTO','STILO','ambiente di integrazione')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);

