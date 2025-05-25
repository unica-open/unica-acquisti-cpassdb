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
-- TEST-CMTO-01

--------- INTEGRAZIONE SICRAWEB
delete from cpass_t_parametro where riferimento = 'EXT' and ambiente = 'SIAC';

INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
    ('USE_OAUTH2', 'true','EXT', 'SICRAWEB', 'Dati trasversali SICRAWEB', true,'COTO')
    ,('OAUTH2_URL', @value@,'EXT', 'SICRAWEB', 'Dati trasversali SICRAWEB', true,'COTO')
    ,('CONSUMER_KEY', @value@,'EXT', 'SICRAWEB', 'Dati trasversali SICRAWEB', true,'COTO')-- WA4UDa3GOwjjL0810Muzzg3w5dka appj
    ,('CONSUMER_SECRET', @value@,'EXT', 'SICRAWEB', 'Dati trasversali SICRAWEB', true,'COTO') -- jk225IYTIB0LgoqN1L5YkUgkIlga appj
    ,('CODICE_ENTE', 'COTO','EXT', 'SICRAWEB', 'Dati trasversali SICRAWEB', true,'COTO')
    ,('CODICE_APPLICATIVO', 'APPJ','EXT', 'SICRAWEB', 'Dati trasversali SICRAWEB', true,'COTO')-- appj
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


delete from cpass_t_parametro where riferimento = 'FORNITORE' and (ambiente = 'SIAC' or valore='siac');

INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
    ('IMPLEMENTOR', 'sicraweb','FORNITORE', '', 'Per interrogazione FORNITORE', true,'COTO')
    ,('IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.sicraweb.FornitoreHelperImpl','FORNITORE', 'SICRAWEB', 'Per interrogazione FORNITORE', true,'COTO')
    ,('WSDL_LOCATION', '','FORNITORE', 'SICRAWEB', 'ricerca impegni', false,'COTO')
    ,('IMPLEMENTOR_EJB_NAME', '','FORNITORE', 'SICRAWEB', 'Per interrogazione FORNITORE', false,'COTO')
    ,('IMPLEMENTOR_CDI_NAME', '','FORNITORE', 'SICRAWEB', 'Per interrogazione FORNITORE', false,'COTO')
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

delete from cpass_t_parametro where riferimento = 'IMPEGNO' and (ambiente = 'SIAC' or valore='siac');
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
    ('IMPLEMENTOR', 'sicraweb','IMPEGNO', '', 'Per interrogazione IMPEGNO', true,'COTO')
    ,('IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.sicraweb.ImpegnoHelperImpl','IMPEGNO', 'SICRAWEB', 'Per interrogazione IMPEGNO', true,'COTO')
    ,('WSDL_LOCATION', '','IMPEGNO', 'SICRAWEB', 'ricerca impegni', true,'COTO')
    ,('NUMERAZIONE_ATTI_UNIVOCA', 'true','IMPEGNO', 'SICRAWEB', 'Per interrogazione IMPEGNO', true,'COTO')
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

delete from cpass_t_parametro where riferimento = 'DOCUMENTO-SPESA' and (ambiente = 'SIAC' or valore='siac');
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
    ('IMPLEMENTOR', 'sicraweb','DOCUMENTO-SPESA', '', 'Per interrogazione DOCUMENTO_SPESA', true,'COTO')
    ,('IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.sicraweb.DocumentoSpesaHelperImpl','DOCUMENTO-SPESA', 'SICRAWEB', 'Per interrogazione DOCUMENTO_SPESA', true,'COTO')
    ,('WSDL_LOCATION', '','DOCUMENTO-SPESA', 'SICRAWEB', 'documento spesa', false,'COTO')
    ,('IMPLEMENTOR_EJB_NAME', '','DOCUMENTO-SPESA', 'SICRAWEB', 'Per interrogazione DOCUMENTO_SPESA', false,'COTO')
    ,('IMPLEMENTOR_CDI_NAME', '','DOCUMENTO-SPESA', 'SICRAWEB', 'Per interrogazione DOCUMENTO_SPESA', false,'COTO')
    ,('STATO_FATTURA_RIPARTIBILE', 'I','DOCUMENTO-SPESA', 'SICRAWEB', 'Per interrogazione DOCUMENTO_SPESA', true,'COTO')
    ,('VERIFICA_STORICO_FORNITORI', 'SI','DOCUMENTO-SPESA', 'SICRAWEB', 'Per interrogazione DOCUMENTO_SPESA', true,'COTO')
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

delete from cpass_t_parametro where riferimento = 'INVIO-QUOTE-DOCUMENTO' and (ambiente = 'SIAC' or valore='siac');
INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
    ('IMPLEMENTOR', 'sicraweb','INVIO-QUOTE-DOCUMENTO', '', 'Per interrogazione INVIO-QUOTE-DOCUMENTO', true,'COTO')
    ,('IMPLEMENTOR_POJO_NAME', 'it.csi.cpass.cpassbe.lib.external.impl.sicraweb.InvioQuoteDocumentoHelperImpl','INVIO-QUOTE-DOCUMENTO', 'SICRAWEB', 'Per interrogazione INVIO-QUOTE-DOCUMENTO', true,'COTO')
    ,('WSDL_LOCATION', '','INVIO-QUOTE-DOCUMENTO', 'SICRAWEB', 'Per interrogazione INVIO-QUOTE-DOCUMENTO', false,'COTO')
    ,('CODICE_TIPO_DOCUMENTO', 'DOCUMENTO_SPESA','INVIO-QUOTE-DOCUMENTO', 'SICRAWEB', 'Per interrogazione INVIO-QUOTE-DOCUMENTO', true,'COTO')
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

----- UFFICI E RELAZIONI SETTORI
INSERT INTO cpass.cpass_t_ufficio (ufficio_codice, ufficio_descrizione,data_creazione, utente_creazione, data_modifica, utente_modifica,  ente_id)
SELECT tmp.ufficio_codice, tmp.ufficio_descrizione, now(), 'SYSTEM', now(), 'SYSTEM', te.ente_id
FROM ( VALUES
('8L5MXU','SERVIZI CIVICI')
,('52YQ8B','ELETTORALE E DEMOGRAFICO')
,('CCBINX','STATISTICA E TOPONOMASTICA')
,('ZBQ9RJ','ORIENTAMENTO, ADOLESCENTI, UNIVERSITA'', INCLUSIONE')
,('VRUXS0','SINDACO')
,('NZN5WV','GRANDI PROGETTI URBANI')
,('V8JVJU','PARTECIPAZIONI')
,('0KRZOC','TRIBUTI')
,('TE6EM1','PUBBLICITA'' E SUOLO PUBBLICO')
,('X6RDMZ','ARREDO URBANO - RIGENERAZIONE URBANA (070)')
,('K5YFWZ','ARREDO URBANO (115)')
,('ZCW783','FACILITY')
,('7G7HWM','CONTROLLO STRATEGICO')
,('XKFOF5','APPALTI ED ECONOMATO')
,('LLYXUT','AVVOCATURA')
,('RVHSNP','PORTAVOCE DEL SINDACO')
,('TN7BMQ','GABINETTO DEL SINDACO')
,('4YQ6AM','RELAZIONI INTERNAZIONALI')
,('WFJ4LV','SEGRETARIO GENERALE')
,('8IASEE','CONSIGLIO COMUNALE')
,('0XY4QE','GIUNTA COMUNALE')
,('MTHT2U','CONTRATTI')
,('2XYMI0','FINANZA')
,('G94EEU','POLIZIA MUNICIPALE')
,('EOUVA5','PROTEZIONE CIVILE')
,('0ZOK6Z','ORGANIZZAZIONE')
,('VV9TGK','GESTIONE PERSONALE TECNICO')
,('44Z59G','TERRITORIO E AMBIENTE')
,('O3GES8','PROCEDURE AMMINISTRATIVE URBANISTICHE')
,('V942BS','EDILIZIA PRIVATA')
,('B12YWH','URBANISTICA')
,('W26W3B','PIANIFICAZIONE')
,('GWQECE','STRATEGIE URBANE')
,('88EQD0','AMBIENTE')
,('48DTZI','CICLO DEI RIFIUTI')
,('EO67B5','TUTELA ANIMALI E AMBIENTE')
,('2GJ7BQ','ADEMPIMENTI TECNICO-AMBIENTALI')
,('0C5H8X','SERVIZI TECNICI PER L''EDILIZIA PUBBLICA')
,('VQS3C5','PROGRAMMAZIONE LL.PP.')
,('ROUJ63','SISTEMA DI SICUREZZA E PRONTO INTERVENTO')
,('3QV24I','EDILIZIA SCOLASTICA')
,('F7UF6T','EDILIZIA PER LA CULTURA')
,('BHPXQN','INFRASTRUTTURE PER IL COMMERCIO E LO SPORT')
,('H3EC6B','EDILIZIA SPORTIVA')
,('1VMBU1','EDILIZIA ABITATIVA PUBBLICA')
,('ECRH40','EDILIZIA PER IL SOCIALE')
,('G4V3CN','EDIFICI MUNICIPALI, PATRIMONIO E VERDE')
,('A4VCVH','AUTOMEZZI, MAGAZZINI E AUTORIMESSE')
,('LE76ES','EDIFICI MUNICIPALI')
,('2YNYYY','GRANDI OPERE DEL VERDE')
,('YF57MZ','VERDE GESTIONE')
,('DH2UQB','PATRIMONIO')
,('WG0VV4','INFRASTRUTTURE E MOBILITA''')
,('ELMPMU','ESERCIZIO')
,('GYTKDI','MOBILITA''')
,('K6WACS','RIQUALIFICAZIONE SPAZIO PUBBLICO')
,('45YKWJ','PONTI, VIE D''ACQUA E INFRASTRUTTURE')
,('5INR3P','CULTURA, EDUCAZIONE, GIOVENTU''')
,('RW4OS0','SPETTACOLI, MANIFESTAZIONI E PROMOZIONE DEL TURISMO')
,('UB04GI','BIBLIOTECHE')
,('O8H1EH','ARCHIVI E GESTIONE DOCUMENTALE')
,('LFN1AK','MUSEI E PATRIMONIO CULTURALE')
,('2FTBOC','ARTI CONTEMPORANEE')
,('NU3P03','SERVIZI EDUCATIVI')
,('4V0D4V','ADOLESCENTI, GIOVANI E PARI OPPORTUNITA''')
,('F47Q89','TEMPI ED ORARI')
,('YUEZAI','PARI OPPORTUNITA''')
,('ZGML0I','I.T.E.R.')
,('9F30JD','POLITICHE SOCIALI E RAPPORTI CON LE AZIENDE SANITARIE')
,('6ZN30O','EDILIZIA RESIDENZIALE PUBBLICA')
,('C5EQOY','CONVENZIONI E CONTRATTI')
,('24SIHL','COMMERCIO, LAVORO, INNOVAZIONE E SISTEMA INFORMATIVO')
,('OL8DWZ','COMMERCIO E ATTIVITA'' PRODUTTIVE')
,('I9XRZB','MERCATI')
,('JWYUQY','CONTENZIOSO AMMINISTRATIVO')
,('IN0X8L','SVILUPPO, FONDI EUROPEI, INNOVAZIONE E SMART CITY')
,('8KY0S0','AGENZIA DELLO SVILUPPO ENERGY MANAGEMENT')
,('IVCY3A','POLITICHE PER IL LAVORO ED ORIENTAMENTO PROFESSIONALE')
,('V7JUKI','SOSTENIBILITA'' ENERGETICA')
,('6K3M8S','SISTEMA INFORMATIVO')
,('FTHOC5','SERVIZI AMMINISTRATIVI')
,('GJCV73','SERVIZI AMMINISTRATIVI DECENTRATI')
,('Q872N9','CIRCOSCRIZIONE 1')
,('GMZ3KD','CIRCOSCRIZIONE 2')
,('R6ETIW','CIRCOSCRIZIONE 3')
,('I7B7VO','CIRCOSCRIZIONE 4')
,('CLWOX2','CIRCOSCRIZIONE 5')
,('3J83WP','CIRCOSCRIZIONE 6')
,('TRN480','CIRCOSCRIZIONE 7')
,('8WPVST','CIRCOSCRIZIONE 8')
,('ASTANR','CIRCOSCRIZIONE 9')
,('9CSBV3','CIRCOSCRIZIONE 10')
,('NLA02W','SPORT E TEMPO LIBERO')
,('WPLH8T','TEMPO LIBERO')
) AS tmp(ufficio_codice, ufficio_descrizione)
JOIN cpass_t_ente te ON te.ente_codice = 'COTO'
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_ufficio tp
	WHERE tp.ufficio_codice = tmp.ufficio_codice
    and tp.ente_id = te.ente_id
);

INSERT INTO cpass.cpass_r_ufficio_settore (ufficio_id, settore_id, data_validita_inizio)
SELECT ufficio.ufficio_id, settore.settore_id, now()
FROM (VALUES
	('200044','0KRZOC')
	,('200188','0KRZOC')
	,('200133','0ZOK6Z')
	,('200135','0ZOK6Z')
	,('200152','EOUVA5')
	,('200155','G94EEU')
	,('200040','2XYMI0')
	,('200055','W26W3B')
	,('200196','GWQECE')
	,('200052','V942BS')
	,('200198','V942BS')
	,('200234','V942BS')
	,('200164','48DTZI')
	,('200200','2GJ7BQ')
	,('200068','3QV24I')
	,('200074','A4VCVH')
	,('200111','DH2UQB')
	,('200072','2YNYYY')
	,('200076','ELMPMU')
	,('200077','GYTKDI')
	,('200081','45YKWJ')
	,('200084','RW4OS0')
	,('200086','UB04GI')
	,('200085','2FTBOC')
	,('200101','9F30JD')
	,('200102','9F30JD')
	,('200171','9F30JD')
	,('200220','9F30JD')
	,('200103','C5EQOY')
	,('200104','OL8DWZ')
	,('200105','I9XRZB')
	,('200224','JWYUQY')
	,('100011','Q872N9')
	,('100012','GMZ3KD')
	,('100013','R6ETIW')
	,('100014','I7B7VO')
	,('100015','CLWOX2')
	,('100016','3J83WP')
	,('100017','TRN480')
	,('100018','8WPVST')
	,('200122','8WPVST')
	,('200123','R6ETIW')
	,('200124','CLWOX2')
	,('200125','3J83WP')
	,('200115','WPLH8T')
	,('200180','LLYXUT')
	,('200001','WFJ4LV')
	,('200014','8IASEE')
	,('200260','6K3M8S')
	,('200294','BHPXQN')
	,('200319','6K3M8S')
	,('200322','X6RDMZ')
	,('200323','24SIHL')
	,('200325','OL8DWZ')
	,('200326','NU3P03')
	,('200333','8L5MXU')
	,('200271','3QV24I')
	,('200335','9F30JD')
	,('200338','9F30JD')
	,('200339','6ZN30O')
	,('200344','V8JVJU')
	,('200345','6K3M8S')
	,('200346','DH2UQB')
	,('200347','0C5H8X')
	,('200351','NLA02W')
	,('200051','ZCW783')
	,('200253','8IASEE')
	,('200256','2XYMI0')
	,('200259','IN0X8L')
	,('200261','TN7BMQ')
	,('200183','XKFOF5')
	,('000100','VRUXS0')
	,('200147','XKFOF5')
	,('200050','7G7HWM')
	,('200352','RW4OS0')
	,('200353','2XYMI0')
	,('200354','0KRZOC')
	,('200355','2XYMI0')
	,('200342','ZCW783')
	,('200365','0C5H8X')
	,('200368','V942BS')
	,('200379','WG0VV4')
	,('200342','0ZOK6Z')
	,('200327','4V0D4V')
	,('200269','CCBINX')
	,('200386','G94EEU')
	,('200349','5INR3P')
	,('200390','0XY4QE')
	,('200331','FTHOC5')
	,('200358','ZCW783')
	,('200359','XKFOF5')
	,('200360','0C5H8X')
	,('200367','44Z59G')
	,('200370','G4V3CN')
	,('200372','88EQD0')
	,('200383','G94EEU')
	,('200341','9F30JD')
	,('200356','2XYMI0')
	,('200363','3QV24I')
	,('200364','BHPXQN')
) AS tmp(settore_codice, ufficio_codice)
JOIN cpass_t_settore settore on settore.settore_codice = tmp.settore_codice
join cpass_t_ufficio ufficio on ufficio.ufficio_codice = tmp.ufficio_codice
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_r_ufficio_settore tu
	WHERE tu.ufficio_id = ufficio.ufficio_id
	and   tu.settore_id = settore.settore_id
);


INSERT INTO cpass.cpass_r_ruolo_modulo (ruolo_id, modulo_id, ente_id)
SELECT dr.ruolo_id, dm.modulo_id, te.ente_id
FROM (VALUES
	('UTENTE_RAGIONERIA', 'PBA', 'COTO')
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
