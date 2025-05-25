INSERT INTO cpass.cpass_t_utente (utente_id, utente_nome, utente_cognome, utente_codice_fiscale, telefono, email, rup, data_creazione, utente_creazione, data_modifica, utente_modifica)
SELECT uuid_generate_v5(tun.uuid_namespace_value, tmp.utente_codice_fiscale), tmp.utente_nome, tmp.utente_cognome, tmp.utente_codice_fiscale, tmp.telefono, NULL, tmp.rup, now(), 'SYSTEM', now(), 'SYSTEM'
FROM (VALUES
	('LPUMRA67P12C665S', 'LUPO', 'MARIO', null,true)
) AS tmp(utente_codice_fiscale,utente_cognome,utente_nome, telefono, rup)
JOIN cpass.cpass_t_uuid_namespace tun ON (tun.uuid_namespace_table = 'cpass_t_utente')
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_utente current
  WHERE current.utente_codice_fiscale = tmp.utente_codice_fiscale
);


-------------------------UTENTE_SETTORE-------------------------------


INSERT INTO cpass.cpass_r_utente_settore (utente_id, settore_id)
SELECT tu.utente_id, ts.settore_id
FROM (VALUES
	('LPUMRA67P12C665S','A2104B')
)	AS tmp(utente, settore)
JOIN cpass.cpass_t_utente tu ON tu.utente_codice_fiscale = tmp.utente
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_r_utente_settore rus
  WHERE rus.utente_id = tu.utente_id
  AND rus.settore_id = ts.settore_id
);

INSERT INTO cpass.cpass_r_ruolo_utente_settore (utente_settore_id, ruolo_id)
SELECT rus.utente_settore_id, dr.ruolo_id
FROM (values
	('LPUMRA67P12C665S','A2104B','RUP')
) AS tmp(utente, settore, ruolo)
JOIN cpass.cpass_t_utente tu ON tu.utente_codice_fiscale = tmp.utente
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
JOIN cpass.cpass_r_utente_settore rus ON (rus.utente_id = tu.utente_id AND rus.settore_id = ts.settore_id)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_r_ruolo_utente_settore rrus
  WHERE rrus.utente_settore_id = rus.utente_settore_id
  AND rrus.ruolo_id = dr.ruolo_id
);

-- cpass_r_utente_rup_settore
INSERT INTO cpass.cpass_r_utente_rup_settore (utente_id, settore_id)
SELECT tu.utente_id, ts.settore_id
FROM (VALUES
	('LPUMRA67P12C665S','A2104B')
)AS tmp(utente, settore)
JOIN cpass.cpass_t_utente tu ON tu.utente_codice_fiscale = tmp.utente
JOIN cpass.cpass_t_settore ts ON ts.settore_codice = tmp.settore
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_r_utente_rup_settore rus
  WHERE rus.utente_id = tu.utente_id
  AND rus.settore_id = ts.settore_id
);
