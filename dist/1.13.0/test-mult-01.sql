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
update cpass_d_ord_tipo_procedura set ente_id = (select ente_id from cpass_t_ente where ente_codice = 'CSI');
insert into cpass.cpass_d_pba_tipo_procedura (
  tipo_procedura_codice
  ,tipo_procedura_descrizione
  ,utente_creazione
  ,utente_modifica 
  ,ente_id
) select
	 tipo_procedura_codice 
    ,tipo_procedura_descrizione 
    ,'admin'
    ,'admin'
    ,ente_id
from 
cpass_d_ord_tipo_procedura where 
	not exists (select 1 from cpass_d_pba_tipo_procedura
				where cpass_d_pba_tipo_procedura.tipo_procedura_codice = cpass_d_ord_tipo_procedura.tipo_procedura_codice
				and cpass_d_pba_tipo_procedura.ente_id = cpass_d_ord_tipo_procedura.ente_id);

INSERT INTO cpass.cpass_t_gestione_campo (nome_campo,visibile, obbligatorio_ins,obbligatorio_upd,editabile,note,ente_id)
select tmp.nome_campo, tmp.visibile, tmp.obbligatorio_ins, tmp.obbligatorio_upd, tmp.editabile, tmp.note, te.ente_id
FROM (VALUES
	('INT_TIPO_PROCEDURA',false, false, false, false,'','CSI'),
	('INT_ACQ_AGGIUNTO_O_VARIATO',true, true, true, true,'obbligatorieta'' subordinata al permesso SVINCOLA_INT_ACQ_AGGIUNTO_O_VARIATO','CSI')
) AS tmp (nome_campo,visibile, obbligatorio_ins,obbligatorio_upd,editabile,note,ente)
JOIN cpass_t_ente te ON te.ente_codice = tmp.ente
WHERE NOT EXISTS(
	SELECT 1
	FROM cpass_t_gestione_campo tp
	WHERE tp.nome_campo = tmp.nome_campo
    and tp.ente_id = te.ente_id
);