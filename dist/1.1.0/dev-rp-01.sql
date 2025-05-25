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
-- DEV-RP-01

insert into cpass.cpass_t_fruitore (fruitore_codice , fruitore_ente_codice_fiscale)
select tmp.codice, tmp.fe_ente
from (values 
	('SIAC', '80087670016')
	)AS tmp(codice, fe_ente)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_t_fruitore rfs
	WHERE rfs.fruitore_codice = tmp.codice
	AND rfs.fruitore_ente_codice_fiscale = tmp.fe_ente
);

INSERT INTO cpass_r_fruitore_servizio  (servizio_id , fruitore_id )
SELECT s.servizio_id, f.fruitore_id
FROM (VALUES
	('VERIFICA_EVASIONE', 'SIAC', '80087670016')
) AS tmp(servizio, fruitore_codice, fruitore_cf)
JOIN cpass_t_servizio s ON s.servizio_codice = tmp.servizio
JOIN cpass_t_fruitore f ON f.fruitore_codice = tmp.fruitore_codice and f.fruitore_ente_codice_fiscale = tmp.fruitore_cf
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass_r_fruitore_servizio rfs
	WHERE rfs.servizio_id = s.servizio_id
	AND rfs.fruitore_id = f.fruitore_id
);

update cpass.cpass_d_tipo_settore set flag_direzione = true	, flag_utilizzabile=true , ente_id = '0ced449c-a147-5419-802f-01acfab32807' where tipo_settore_codice='4';
update cpass.cpass_d_tipo_settore set flag_direzione = true	, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='21';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='8';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-001';
update cpass.cpass_d_tipo_settore set flag_direzione = true	, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-002';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=FALSE, ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-003';
update cpass.cpass_d_tipo_settore set flag_direzione = true	, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-004';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=FALSE, ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-005';
update cpass.cpass_d_tipo_settore set flag_direzione = true	, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-006';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-007';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-008';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-009';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=FALSE, ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-010';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-011';
update cpass.cpass_d_tipo_settore set flag_direzione = true	, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-012';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-013';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-014';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=FALSE, ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-015';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=FALSE, ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-016';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-020';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-021';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-022';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-023';
update cpass.cpass_d_tipo_settore set flag_direzione = FALSE, flag_utilizzabile=true , ente_id = '32936085-3fc2-52df-8f1d-36c40fe398b2' where tipo_settore_codice='R1-024';
ALTER TABLE if exists cpass.cpass_d_tipo_settore ALTER column ente_id SET NOT NULL;

-- integrazione NOTIER
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('IMPLEMENTOR',           'notier',                                                                               'NSO', '',       'Per interrogazione NSO', true),
	('IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.notier.NSOHelperImpl', 	                      'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('NSO_CUSTOMIZATION_ID',  'urn:fdc:peppol.eu:poacc:trns:order:3:restrictive:urn:www.agid.gov.it:trns:ordine:3.1', 'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('NSO_PROFILE_ID',        'urn:fdc:peppol.eu:poacc:bis:order_only:3',                                             'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('HOST_NOTIER',           'test-notier.regione.emilia-romagna.it',                                                'NSO', 'NOTIER', 'Per interrogazione NSO', true),
    ('PORTA_NOTIER',          '8443',                                                                                 'NSO', 'NOTIER', 'Per interrogazione NSO', true)
	) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);


update  cpass_t_ufficio 
set id_notier = 'ACSI_03_UNICAA1511C'
where ufficio_codice = 'S04VFA';

update  cpass_t_ufficio 
set id_notier = 'ACSI_01_UNICAA1111C'
where ufficio_codice = '7K3KWF';

update  cpass_t_ufficio 
set id_notier = 'ACSI_02_UNICA'
where ufficio_codice = '81YHY9';
