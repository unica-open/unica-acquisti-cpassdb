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
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
    ('APPKEY', @value@,'DOCUMENTALE', 'ACTA', 'app key', true,'CMTO')
    ,('REPOSITORY_NAME', @value@, 'ACTA', 'nome del repository', true,'CMTO')
    ,('SISTEMA_DOCUMENTALE', 'NO_PROTOCOLLO', 'DOCUMENTALE', 'ACTA', 'no gest propocollo su acta', true,'CMTO')
    ,('WSDL_LOCATION', '', 'DOCUMENTALE', 'ACTA', 'location wsdl', false,'CMTO')
    ,('ID_AOO', @value@,'DOCUMENTALE', 'ACTA', 'eventuale forzatura aoo', true,'CMTO')
    ,('CODICE_FISCALE_UTENTE', @value@,'DOCUMENTALE', 'ACTA', 'eventuale forzatura cf', true,'CMTO')
    ,('NODO_RESPONSABILE', 'A11000-O1 - SEGRETERIA','DOCUMENTALE', 'ACTA', 'descrizione nodo', true,'CMTO')
) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata,ente)
JOIN cpass_t_ente te ON te.ente_codice = tmp.ente
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
    and tp.ente_id = te.ente_id
);
update  cpass_t_parametro set valore = 'SEGRETERIA' where ambiente = 'ACTA'
and valore LIKE '%SEGRETERIA%';
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
     ('FORMA_DOC_ORDINI',  '186','DOCUMENTALE', 'ACTA', 'FORMA_DOC_ORDINI', true,'CMTO')
    ,('STATO_EFFICACIA',   '8','DOCUMENTALE', 'ACTA', 'STATO_EFFICACIA', true,'CMTO')
    ,('VITAL_RECORD_CODE', '12','DOCUMENTALE' , 'ACTA', 'VITAL_RECORD_CODE', true,'CMTO')  
) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata,ente)
JOIN cpass_t_ente te ON te.ente_codice = tmp.ente
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
    and tp.ente_id = te.ente_id
);

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('RICERCA_SOGGETTO_FONTE_ESTERNA', 'true', true, 'DOCUMENTALE', 'ACTA', 'ricerca soggetto fonte esterna ','CMTO')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('SOGLIA_DI_NON_INVIO_MIT', '40000', true, '', 'MIT', 'ricerca soggetto fonte esterna ','CMTO')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.acta.DocumentaleHelperImpl', true, 'DOCUMENTALE', 'ACTA', 'implementatore','CMTO')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);

INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
    ('IMPLEMENTOR', 'acta', 'DOCUMENTALE', null, 'Per interrogazione PROTOCOLLO ACTA', true,null)
    ,('IMPLEMENTOR_POJO_NAME',@value@,'DOCUMENTALE', 'ACTA', 'implementatore', true,'CMTO')    
    
) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata,ente)
JOIN cpass_t_ente te ON te.ente_codice = tmp.ente
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
    and tp.ente_id = te.ente_id
);