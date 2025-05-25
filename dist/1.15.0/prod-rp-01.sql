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

delete from cpass_r_ruolo_permesso where permesso_id = (select permesso_id from cpass_d_permesso cdp where permesso_codice = 'CARICA_INTERVENTI_ANNI_PREC');

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('DELEGATO_RUP','CARICA_INTERVENTI_ANNI_PREC_V2'),
	('RUP','CARICA_INTERVENTI_ANNI_PREC_V2'),
	('ADMIN','CARICA_INTERVENTI_ANNI_PREC_V2'),
	('DELEGATO_REFP','CARICA_INTERVENTI_ANNI_PREC_V2'),
	('REFP','CARICA_INTERVENTI_ANNI_PREC_V2')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);

INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
	('TITOLARIO_ID', '6','DOCUMENTALE', 'ACTA', 'id titolario', true,'REGP')
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

INSERT INTO cpass.cpass_r_ruolo_modulo (ruolo_id, modulo_id, ente_id)
SELECT dr.ruolo_id, dm.modulo_id, te.ente_id
FROM (VALUES
	('GESTORE_UTENTI', 'BO', 'REGP')
) AS tmp(ruolo, modulo, ente)
JOIN cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass_d_modulo dm ON dm.modulo_codice = tmp.modulo
JOIN cpass_t_ente te ON te.ente_codice = tmp.ente
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_r_ruolo_modulo rrm
	WHERE rrm.ruolo_id = dr.ruolo_id
	AND rrm.modulo_id = dm.modulo_id
	and rrm.ente_id = te.ente_id
);



INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, NULL
FROM (VALUES
  ('IMPLEMENTOR','hr',true,'UTENTE-HR','','Per interrogazione utente su hr '),
  ('IMPLEMENTOR_POJO_NAME','it.csi.cpass.cpassbe.lib.external.impl.hr.UtenteHrHelperImpl',true,'UTENTE-HR','HR','Per interrogazione UTENTE'),
  ('INTEGRAZIONE_HR','true',true,'UTENTE-HR','HR','Per interrogazione UTENTE')
  ) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);
-- da cambiare con i dati di produzione
INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('WSDL_LOCATION', 'https://tst-aphr01.csi.it:4444/webservices/SOAProvider/plsql/cuscsi_soa_giunta_regionale/?wsdl', true, 'UTENTE-HR', 'HR', 'location servizio','REGP'),
  ('USER', 'WS_UNICA_BKOFF_GIUNTA', true, 'UTENTE-HR', 'HR', 'user','REGP'),
  ('PW', 'mypass$1', true, 'UTENTE-HR', 'HR', 'pw','REGP')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);


INSERT INTO cpass.cpass_r_ruolo_modulo (ruolo_id, modulo_id, ente_id)
SELECT dr.ruolo_id, dm.modulo_id, te.ente_id
FROM (VALUES
	('LETTORE_ODS', 'BO', 'REGP'),
	('GESTORE_ODS', 'BO', 'REGP')
) AS tmp(ruolo, modulo, ente)
JOIN cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass_d_modulo dm ON dm.modulo_codice = tmp.modulo
JOIN cpass_t_ente te ON te.ente_codice = tmp.ente
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_r_ruolo_modulo rrm
	WHERE rrm.ruolo_id = dr.ruolo_id
	AND rrm.modulo_id = dm.modulo_id
	and rrm.ente_id = te.ente_id
);

INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('COMPILATORE','CARICA_INTERVENTI_ANNI_PREC_V2')
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ruolo_permesso rrp
	WHERE rrp.ruolo_id = dr.ruolo_id
	AND rrp.permesso_id = dp.permesso_id
);
INSERT INTO cpass.cpass_r_ruolo_modulo (ruolo_id, modulo_id, ente_id)
SELECT dr.ruolo_id, dm.modulo_id, te.ente_id
FROM (VALUES
	('ADMIN', 'BO', 'REGP')
) AS tmp(ruolo, modulo, ente)
JOIN cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass_d_modulo dm ON dm.modulo_codice = tmp.modulo
JOIN cpass_t_ente te ON te.ente_codice = tmp.ente
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_r_ruolo_modulo rrm
	WHERE rrm.ruolo_id = dr.ruolo_id
	AND rrm.modulo_id = dm.modulo_id
	and rrm.ente_id = te.ente_id
);
