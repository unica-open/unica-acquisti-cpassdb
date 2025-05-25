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
insert into cpass_t_cdc (cdc_codice, cdc_descrizione, data_validita_inizio, ente_id)
(select tmp.codice, tmp.descrizione, tmp.data_validita_inizio, e.ente_id
from (values
('001','GABINETTO DELLA SINDACA',now(),'COTO'),
('002','CONSIGLIO COMUNALE',now(),'COTO'),
('003','CONTRATTI',now(),'COTO'),
('004','PERSONALE',now(),'COTO'),
('005','APPALTI ED ECONOMATO',now(),'COTO'),
('006','MOBILITA''',now(),'COTO'),
('007','SERVIZI EDUCATIVI',now(),'COTO'),
('008','FACILITY MANAGEMENT',now(),'COTO'),
('010','GESTIONE SPORT',now(),'COTO'),
('011','STATISTICA E TOPONOMASTICA',now(),'COTO'),
('013','TRIBUTI E CATASTO',now(),'COTO'),
('014','SERVIZI DEMOGRAFICI',now(),'COTO'),
('016','COMMERCIO ED ATTIVITÀ PRODUTTIVE',now(),'COTO'),
('018','SERVIZI ELETTORALI',now(),'COTO'),
('019','SERVIZI SOCIALI',now(),'COTO'),
('021','AMBIENTE',now(),'COTO'),
('023','LAVORO',now(),'COTO'),
('024','RISORSE FINANZIARIE',now(),'COTO'),
('025','BIBLIOTECHE',now(),'COTO'),
('026','ARCHIVI, MUSEI, PATRIMONIO CULTURALE',now(),'COTO'),
('027','SISTEMA INFORMATIVO',now(),'COTO'),
('028','PROTEZIONE CIVILE',now(),'COTO'),
('029','ISPETTORATO TECNICO',now(),'COTO'),
('030','EDIFICI COMUNALI GESTIONE TECNICA',now(),'COTO'),
('031','EDILIZIA SCOLASTICA',now(),'COTO'),
('033','SUOLO - PARCHEGGI',now(),'COTO'),
('034','PONTI - VIE D''ACQUA - INFRASTRUTTURE',now(),'COTO'),
('045','CULTURA',now(),'COTO'),
('047','EDILIZIA ABITATIVA PUBBLICA',now(),'COTO'),
('048','CORPO DI POLIZIA MUNICIPALE',now(),'COTO'),
('049','GIUNTA, PREVENZIONE CORRUZIONE',now(),'COTO'),
('050','POLITICHE GIOVANILI ORIENTAMENTO UNIVERSITARIO E INTEGRAZIONE',now(),'COTO'),
('051','ORIENTAMENTO ADOLESCENTI INCLUSIONE',now(),'COTO'),
('052','URBANIZZAZIONI',now(),'COTO'),
('055','AUTORIMESSE',now(),'COTO'),
('059','GRANDI OPERE EDILIZIE',now(),'COTO'),
('060','EDILIZIA PER LA CULTURA',now(),'COTO'),
('061','PROGRAMMAZIONE LL.PP. E VIG. LOCALI POUBBLICO E SPETTACOLO',now(),'COTO'),
('062','SERVIZIO INFRASTRUTTURE PER IL COMMERCIO E LO SPORT',now(),'COTO'),
('063','SERVIZIO EDILIZIA ABITATIVA PUBBLICA E PER IL SOCIALE',now(),'COTO'),
('064','PARTECIPAZIONI COMUNALI',now(),'COTO'),
('066','EX DIREZIONE GENERALE',now(),'COTO'),
('068','PROGETTO SPECIALE INNOVAZIONE FONDI EUROPERI SMART CITY',now(),'COTO'),
('069','TURISMO',now(),'COTO'),
('072','RELAZIONI INTERNAZIONALI PROGETTI EUROPEI COOPERAZIONE E PACE',now(),'COTO'),
('084','CIRC. 1 - CENTRO-CROCETTA',now(),'COTO'),
('085','CIRC. 2 - SANTA RITA-MIRAFIORI NORD-SUD',now(),'COTO'),
('086','CIRC. 3 - SAN PAOLO-CENISIA-POZZO STRADA-CIT TURIN',now(),'COTO'),
('087','CIRC. 4 - SAN DONATO-CAMPIDOGLIO-PARELLA',now(),'COTO'),
('088','CIRC. 5 - VALLETTE-MADONNA DI CAMPAGNA-BORGO VITTORIA',now(),'COTO'),
('089','CIRC. 6 - BARRIERA DI MILANO-FALCHERA-REGIO PARCO',now(),'COTO'),
('090','CIRC. 7 - VALDOCCO-VANCHIGLIA-MADONNA DEL PILONE',now(),'COTO'),
('091','CIRC. 8 - SAN SALVARIO-CAVORETTO-BORSO PO-LINGOTTO',now(),'COTO'),
('092','CIRC. 9 - NIZZA-LINGOTTO',now(),'COTO'),
('093','CIRC. 10 - MIRAFIORI SUD',now(),'COTO'),
('095','PROGETTO TORINO CREATIVA',now(),'COTO'),
('097','EVENTI DELLA CITTA''',now(),'COTO'),
('104','CONVENZIONI E CONTRATTI',now(),'COTO'),
('106','INFRASTRUTTURE PER IL COMMERCIO',now(),'COTO'),
('107','TEMPO LIBERO',now(),'COTO'),
('110','TUTELA ANIMALI',now(),'COTO'),
('111','SISTEMA SICUREZZA E PRONTO INTERVENTO',now(),'COTO'),
('113','COOPERAZIONE INTERNAZIONALE E PACE',now(),'COTO'),
('117','GESTIONE GRANDI OPERE DEL VERDE',now(),'COTO'),
('125','DIREZIONE URBANISTICA E TERRITORIO',now(),'COTO'),
('128','FORMAZIONE ENTE - QUALITA'' E CONTROLLO DI GESTIONE',now(),'COTO'),
('130','PARI OPPORTUNITA''',now(),'COTO'),
('131','PATRIMONIO',now(),'COTO')
) as tmp (codice, descrizione, data_validita_inizio, ente_codice)
join cpass_t_ente e on (tmp.ente_codice = e.ente_codice)
where not exists
(SELECT 1
  FROM cpass.cpass_t_cdc cdc 
  WHERE cdc.cdc_codice = tmp.codice)
 );
 
 INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
	('ALGORITMO_CONFRONTO_PER_DIREZIONE', 'false','PROVVEDIMENTO', 'STILO', 'decide l''algoritmo di confronto tra settore emittente e settore della struttura proponente', true,'COTO')
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