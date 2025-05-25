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
-- PROD-MULT-01
INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
  ('DURATA_PROGRAMMA', 'BIENNALE', true, 'PBA', 'CPASS', 'programma biennale','CSI')
  --,('IMPORTI_TRASLABILI','false'   , true, 'PBA', 'CPASS', 'IMPORTI TRASLABILI IN COPIA','CSI')
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);
INSERT INTO cpass.cpass_t_gestione_campo (nome_campo,visibile, obbligatorio_ins,obbligatorio_upd,editabile,note,ente_id)
select tmp.nome_campo, tmp.visibile, tmp.obbligatorio_ins, tmp.obbligatorio_upd, tmp.editabile, tmp.note, te.ente_id
FROM (VALUES
	('COPIA_INT_IMPORTI_TRASLABILI',false, false, false, false,'possibilita'' di traslare gli importi in fase di copia','MULT')
) AS tmp (nome_campo,visibile, obbligatorio_ins,obbligatorio_upd,editabile,note,ente)
JOIN cpass_t_ente te ON te.ente_codice = tmp.ente
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_gestione_campo tp
	WHERE tp.nome_campo = tmp.nome_campo
    and tp.ente_id = te.ente_id
);

INSERT INTO cpass.cpass_t_parametro (chiave, valore, abilitata, riferimento, ambiente, note, ente_id)
SELECT tmp.chiave, tmp.valore, tmp.abilitata, tmp.riferimento, tmp.ambiente, tmp.note, te.ente_id
FROM (VALUES
   ('report.endpoint',       'https://10.138.129.144:10310/cpassrepeng/report', true, '', 'CPASS', 'ricerca soggetto fonte esterna ','CSI')
  ,('report.multi.endpoint', 'https://10.138.129.144:10310/cpassrepeng/multi-report', true, '', 'CPASS', 'ricerca soggetto fonte esterna ','CSI') 
) AS tmp (chiave, valore, abilitata, riferimento, ambiente, note, ente)
JOIN cpass.cpass_t_ente te ON te.ente_codice = tmp.ente 
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_t_parametro current
  WHERE current.chiave = tmp.chiave
  AND current.riferimento = tmp.riferimento
  AND current.ambiente = tmp.ambiente
);