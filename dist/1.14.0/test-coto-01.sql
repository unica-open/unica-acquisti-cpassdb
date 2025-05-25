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

delete from cpass_d_ord_causale_sospensione_evasione where causale_sospensione_codice = '0.50';

insert into cpass_d_ord_causale_sospensione_evasione(
   causale_sospensione_codice
  ,causale_sospensione_descrizione
  ,utente_creazione
  ,utente_modifica,ente_id
)values(
  '0.50'
  ,'Sospensione quota 0,50%'
  ,'admin'
  ,'admin'
  ,'25b3cb3e-0c7e-53b2-88bd-afc47011647d'
);

INSERT INTO cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note,ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM ( VALUES
	('TITOLARIO_ID', '6','DOCUMENTALE', 'ACTA', 'id titolario', true,'COTO')
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
	('GESTORE_UTENTI', 'BO', 'COTO')
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

update cpass_t_pba_intervento set tipo_procedura_id = null;

delete from cpass_d_pba_tipo_procedura ;

insert into cpass.cpass_d_pba_tipo_procedura   (tipo_procedura_codice,tipo_procedura_descrizione,utente_creazione,utente_modifica ,ente_id)        
select   
   tmp.tipo_procedura_codice
  ,tmp.tipo_procedura_descrizione
  ,tmp.utente_creazione
  ,tmp.utente_modifica 
  ,tmp.ente_id
 from   ( values           
                                  ('01','PROCEDURA APERTA','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('02','PROCEDURA RISTRETTA','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'),
                                  ('03','PROCEDURA NEGOZIATA PREVIA PUBBLICAZIONE','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('04','PROCEDURA NEGOZIATA SENZA PREVIA PUBBLICAZIONE','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('05','DIALOGO COMPETITIVO','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('06','PROCEDURA NEGOZIATA SENZA PREVIA INDIZIONE DI GARA (SETTORI SPECIALI)','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('07','SISTEMA DINAMICO DI ACQUISIZIONE','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('08','AFFIDAMENTO IN ECONOMIA - COTTIMO FIDUCIARIO','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('14','PROCEDURA SELETTIVA EX ART 238 C.7, D.LGS. 163/2006','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('17','AFFIDAMENTO DIRETTO EX ART. 5 DELLA LEGGE 381/91','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('21','PROCEDURA RISTRETTA DERIVANTE DA AVVISI CON CUI SI INDICE LA GARA','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('22','PROCEDURA NEGOZIATA CON PREVIA INDIZIONE DI GARA (SETTORI SPECIALI)','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('23','AFFIDAMENTO DIRETTO','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('24','AFFIDAMENTO DIRETTO A SOCIETA'' IN HOUSE','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('25','AFFIDAMENTO DIRETTO A SOCIETA'' RAGGRUPPATE/CONSORZIATE O CONTROLLATE NELLE CONCESSIONI E NEI PARTENARIATI','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('26','AFFIDAMENTO DIRETTO IN ADESIONE AD ACCORDO QUADRO/CONVENZIONE','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('27','CONFRONTO COMPETITIVO IN ADESIONE AD ACCORDO QUADRO/CONVENZIONE','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('28','PROCEDURA AI SENSI DEI REGOLAMENTI DEGLI ORGANI COSTITUZIONALI','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('29','PROCEDURA RISTRETTA SEMPLIFICATA','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('30','PROCEDURA DERIVANTE DA LEGGE REGIONALE','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('31','AFFIDAMENTO DIRETTO PER VARIANTE SUPERIORE AL 20% DELL''IMPORTO CONTRATTUALE','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('32','AFFIDAMENTO RISERVATO','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('33','PROCEDURA NEGOZIATA PER AFFIDAMENTI SOTTO SOGLIA','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('34','PROCEDURA ART.16 COMMA 2-BIS DPR 380/2001 PER OPERE URBANIZZAZIONE A SCOMPUTO PRIMARIE SOTTO SOGLIA COMUNITARIA','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('35','PARTERNARIATO PER L’INNOVAZIONE','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('36','AFFIDAMENTO DIRETTO PER LAVORI, SERVIZI O FORNITURE SUPPLEMENTARI','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('37','PROCEDURA COMPETITIVA CON NEGOZIAZIONE','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('38','PROCEDURA DISCIPLINATA DA REGOLAMENTO INTERNO PER SETTORI SPECIALI','admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID),
                                  ('39','AFFIDAMENTO DIRETTO PER MODIFICHE CONTRATTUALI O VARIANTI PER LE QUALI È NECESSARIA UNA NUOVA PROCEDURA DI AFFIDAMENTO' ,'admin','admin','25b3cb3e-0c7e-53b2-88bd-afc47011647d'::UUID)            
) as tmp (tipo_procedura_codice,tipo_procedura_descrizione,utente_creazione,utente_modifica ,ente_id)
where 
	not exists (select 1 from cpass_d_pba_tipo_procedura
				where cpass_d_pba_tipo_procedura.tipo_procedura_codice = cpass_d_pba_tipo_procedura.tipo_procedura_codice
				and cpass_d_pba_tipo_procedura.ente_id = cpass_d_pba_tipo_procedura.ente_id);


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
				
				
INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('WSDL_LOCATION', 'https://tst-aphr01.csi.it:4444/webservices/SOAProvider/plsql/cuscsi_soa_comune_torino/?wsdl', true, 'UTENTE-HR', 'HR', 'location servizio','COTO'),
  ('USER', 'WS_UNICA_BKOFF_COTO', true, 'UTENTE-HR', 'HR', 'user','COTO'),
  ('PW', 'mypass$1', true, 'UTENTE-HR', 'HR', 'pw','COTO')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);