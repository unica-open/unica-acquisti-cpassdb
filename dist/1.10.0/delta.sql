---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
DROP TABLE if exists cpass.CPASS_T_INTERVENTO_CIG ;
DROP TABLE if exists cpass.CPASS_T_PBA_INTERVENTO_CIG ;


CREATE TABLE if not exists cpass.CPASS_T_PBA_INTERVENTO_CIG (
   INTERVENTO_CIG_ID	serial PRIMARY KEY
  ,INTERVENTO_ID		uuid    NOT NULL
  ,CIG					varchar (10)
  ,CONSTRAINT fk_T_INTERVENTO_CIG_INTERVENTO FOREIGN KEY (INTERVENTO_ID) REFERENCES cpass_t_pba_intervento(INTERVENTO_ID)
                             
);

 INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo, disattivabile, attivo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo, tmp.disattivabile, tmp.attivo
FROM (VALUES
	('RIPORTA_INTERVENTO_BOZZA','riporta intervento in stato bozza','INTERVENTI',false,'B', 'SI', true),
	('AVVIA_ACQUISTO','avvio intervento','INTERVENTI',false,'B', 'SI', true)
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo, disattivabile, attivo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );
    
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
	('DELEGATO_REFP','RIPORTA_INTERVENTO_BOZZA'),
	('DELEGATO_REFP','AVVIA_ACQUISTO'),
	('REFP','RIPORTA_INTERVENTO_BOZZA'),
	('REFP','AVVIA_ACQUISTO'),
	('ADMIN','RIPORTA_INTERVENTO_BOZZA'),
	('ADMIN','AVVIA_ACQUISTO')
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
	('DELEGATO_REFP', 'PBA', 'REGP')
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

DROP VIEW if exists cpass.cpass_v_ultimo_programma_biennio;
CREATE VIEW cpass.cpass_v_ultimo_programma_biennio  AS
WITH  ultimi AS (
  select 
  programma_anno
  ,ente_id
  ,max(programma_versione) programma_versione
  from 
  cpass_t_pba_programma
  group By
  ente_id
  ,programma_anno
)
select 
   cpass_t_pba_programma.programma_id
  ,cpass_t_pba_programma.programma_anno
  ,cpass_t_pba_programma.ente_id 
  ,cpass_t_pba_programma.data_creazione 
  ,cpass_t_pba_programma.utente_creazione 
  ,cpass_t_pba_programma.data_modifica
  ,cpass_t_pba_programma.utente_modifica
  ,cpass_t_pba_programma.data_cancellazione 
  ,cpass_t_pba_programma.utente_cancellazione 
  ,cpass_t_pba_programma.optlock 
  ,cpass_t_pba_programma.stato_id 
  ,cpass_t_pba_programma.numero_provvedimento
  ,cpass_t_pba_programma.descrizione_provvedimento
  ,cpass_t_pba_programma.data_provvedimento
  ,cpass_t_pba_programma.data_pubblicazione 
  ,cpass_t_pba_programma.url 
  ,cpass_t_pba_programma.utente_referente_id
  ,cpass_t_pba_programma.programma_descrizione
  ,cpass_t_pba_programma.programma_versione 
  ,cpass_t_pba_programma.programma_codice_mit 
  ,cpass_t_pba_programma.id_ricevuto_mit
  ,cpass_t_pba_programma.data_approvazione 
  ,cpass_t_pba_programma.data_trasmissione_mit 
from 
  cpass_t_pba_programma
  ,ultimi
where   
 cpass_t_pba_programma.programma_anno =  ultimi.programma_anno 
 AND cpass_t_pba_programma.ente_id = ultimi.ente_id 
 AND cpass_t_pba_programma.programma_versione = ultimi.programma_versione; 

 alter table cpass_t_ufficio  DROP CONSTRAINT if exists cpass_t_ufficio_unique;
alter table cpass_t_ufficio  ADD CONSTRAINT cpass_t_ufficio_unique UNIQUE (ufficio_codice,ente_id);

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Cancellazione di acquisto già previsto nell''elenco annuale'
where acquisto_variato_codice is null;

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Aggiunta acquisto in conseguenza di atto amministrativo'
where acquisto_variato_codice = '1';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Aggiunta acquisto per sopravvenuta disponibilita'' di finanziamenti, comprese risorse disponibili anche a seguito di ribassi d''asta o economie'
where acquisto_variato_codice = '2';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Anticipazione prima annualita'' di acquisizione della fornitura o servizio'
where acquisto_variato_codice = '3';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Modifica quadro economico dell''acquisto previsto nell''elenco annuale in caso di nuove risorse'
where acquisto_variato_codice = '4';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Acquisto reso necessario da eventi imprevedibili o calamitosi o da sopravvenute disposizioni di legge o regolamentari o non previsto nell''elenco annuale realizzabile con un autonomo piano finanziario'
where acquisto_variato_codice = '5';


INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('VISTO_RAGIONERIA'                 , 'false', true, 'PBA', 'CPASS', 'visto ragioneria','CMTO')
 ,('GESTIONE_ACQUISTO_VERS_DEFINITIVA', 'false',TRUE, 'PBA', 'CPASS', 'acq vers definitiva','CMTO')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);