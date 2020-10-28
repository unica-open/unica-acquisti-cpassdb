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
-- Parametri trasversali
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('USE_OAUTH2',         'true',  'EXT', 'SIAC', 'Dati trasversali SIAC', true),
	('OAUTH2_URL',         '',      'EXT', 'SIAC', 'Dati trasversali SIAC', true),
	('CONSUMER_KEY',       '',      'EXT', 'SIAC', 'Dati trasversali SIAC', true),
	('CONSUMER_SECRET',    '',      'EXT', 'SIAC', 'Dati trasversali SIAC', true),
	('CODICE_ENTE',        'REGP',  'EXT', 'SIAC', 'Dati trasversali SIAC', true),
	('CODICE_APPLICATIVO', 'CPASS', 'EXT', 'SIAC', 'Dati trasversali SIAC', true)
) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);

-- Servizio FORNITORE
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('IMPLEMENTOR',           'siac',                                                            'FORNITORE', '',     'Per interrogazione FORNITORE', true),
	('IMPLEMENTOR_EJB_NAME',  'java:global/cpassbe/cpassbe-lib-siac/FornitoreHelperEJBImpl',     'FORNITORE', 'SIAC', 'Per interrogazione FORNITORE', false),
	('IMPLEMENTOR_CDI_NAME',  'FornitoreHelperCDIImpl-SIAC',                                     'FORNITORE', 'SIAC', 'Per interrogazione FORNITORE', false),
	('IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.siac.FornitoreHelperImpl', 'FORNITORE', 'SIAC', 'Per interrogazione FORNITORE', true),
	('WSDL_LOCATION',         '',                                                                'FORNITORE', 'SIAC', 'Per interrogazione FORNITORE', false)
) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);

INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('IMPLEMENTOR',           'siac',                                                            		'DOCUMENTO-SPESA', '',     'Per interrogazione DOCUMENTO_SPESA', true),
	('IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.siac.DocumentoSpesaHelperImpl', 	'DOCUMENTO-SPESA', 'SIAC', 'Per interrogazione DOCUMENTO_SPESA', true),
    ('STATO_FATTURA_RIPARTIBILE', 'I', 	                                                                'DOCUMENTO-SPESA', 'SIAC', 'Per interrogazione DOCUMENTO_SPESA', true),
    ('TOLLERANZA_EVASIONE', '0', 	                                                                    'DOCUMENTO-SPESA', 'SIAC', 'Per interrogazione DOCUMENTO_SPESA', true),
    ('VERIFICA_STORICO_FORNITORI', 'SI', 	                                                            'DOCUMENTO-SPESA', 'SIAC', 'Per interrogazione DOCUMENTO_SPESA', true)
	
     
	) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);

-- Servizio IMPEGNO
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('IMPLEMENTOR',                  'siac',                                                          'IMPEGNO', '',     'Per interrogazione IMPEGNO', true),
	('ANNO_AVVIO_STILO',             '2019',                                                          'IMPEGNO', '',     'Per interrogazione IMPEGNO', true),
	('CODICE_TIPO_PROVV_STILO',      'DD',                                                            'IMPEGNO', '',     'Per interrogazione IMPEGNO', true),
	('CODICE_TIPO_PROVV_ANTE_STILO', 'AD',                                                            'IMPEGNO', '',     'Per interrogazione IMPEGNO', true),
	('DATA_ORDINI_FUTURI',           '01/06',                                                         'IMPEGNO', '',     'Per interrogazione IMPEGNO', true),
	('ASSOC_IMPEGNI_ORD',            'DISP_CRESC',                                                    'IMPEGNO', '',     'Per interrogazione IMPEGNO', true),
	('CTRL_CLASSE_SOGG',             'AVVISO',                                                        'IMPEGNO', '',     'Per interrogazione IMPEGNO', true),
	('IMPLEMENTOR_POJO_NAME',        'it.csi.cpass.cpassbe.lib.external.impl.siac.ImpegnoHelperImpl', 'IMPEGNO', 'SIAC', 'Per interrogazione IMPEGNO', true),
	('WSDL_LOCATION',                '',                                                              'IMPEGNO', 'SIAC', 'Per interrogazione IMPEGNO', false)
) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);


INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note
FROM ( VALUES
	('IMPLEMENTOR',           'siac',                                                            		    'INVIO-QUOTE-DOCUMENTO', '',     'Per interrogazione INVIO-QUOTE-DOCUMENTO', true),
	('IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.siac.InvioQuoteDocumentoHelperImpl', 	'INVIO-QUOTE-DOCUMENTO', 'SIAC', 'Per interrogazione INVIO-QUOTE-DOCUMENTO', true),
    ('WSDL_LOCATION',         '',                                                                           'INVIO-QUOTE-DOCUMENTO', 'SIAC', 'Per interrogazione INVIO-QUOTE-DOCUMENTO', false)
	) AS tmp(chiave, valore, riferimento, ambiente, note, abilitata)
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_parametro tp
	WHERE tp.chiave = tmp.chiave
	AND ((tp.riferimento IS NULL AND tmp.riferimento IS NULL) OR (tp.riferimento = tmp.riferimento))
	AND ((tp.ambiente IS NULL AND tmp.ambiente IS NULL) OR (tp.ambiente = tmp.ambiente))
);


-- AMBIENTE test
UPDATE cpass_t_parametro SET valore = 'https://tst-api-ent.ecosis.csi.it/api/token'                          WHERE riferimento = 'EXT'       AND ambiente = 'SIAC' AND chiave = 'OAUTH2_URL';
UPDATE cpass_t_parametro SET valore = 'kWcMwvFctfRpDgcKL_2ppEnwQbYa'                                         WHERE riferimento = 'EXT'       AND ambiente = 'SIAC' AND chiave = 'CONSUMER_KEY';
UPDATE cpass_t_parametro SET valore = 'I7ZAUNlapUSugn17uqOOA97wjn8a'                                         WHERE riferimento = 'EXT'       AND ambiente = 'SIAC' AND chiave = 'CONSUMER_SECRET';
UPDATE cpass_t_parametro SET valore = 'http://tst-srv-consip.bilancio.csi.it/siacbilser/RicercaService?wsdl' WHERE riferimento = 'FORNITORE' AND ambiente = 'SIAC' AND chiave = 'WSDL_LOCATION';

-- AMBIENTE prod
UPDATE cpass_t_parametro SET valore = 'https://tst-api-ent.ecosis.csi.it/api/token' WHERE riferimento = 'EXT'       AND ambiente = 'SIAC' AND chiave = 'OAUTH2_URL';
UPDATE cpass_t_parametro SET valore = 'kWcMwvFctfRpDgcKL_2ppEnwQbYa'                WHERE riferimento = 'EXT'       AND ambiente = 'SIAC' AND chiave = 'CONSUMER_KEY';
UPDATE cpass_t_parametro SET valore = 'I7ZAUNlapUSugn17uqOOA97wjn8a'                WHERE riferimento = 'EXT'       AND ambiente = 'SIAC' AND chiave = 'CONSUMER_SECRET';
UPDATE cpass_t_parametro SET valore = '???', abilitata = true                       WHERE riferimento = 'FORNITORE' AND ambiente = 'SIAC' AND chiave = 'WSDL_LOCATION';
UPDATE cpass_t_parametro SET valore = '???', abilitata = true                       WHERE riferimento = 'IMPEGNO'   AND ambiente = 'SIAC' AND chiave = 'WSDL_LOCATION';
