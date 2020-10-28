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
CREATE OR REPLACE VIEW cpass.cpass_v_cpv_ods
AS with recursive alberoCpvOds (livello, cpv_id_padre, cpv_id, cpv_codice, cpv_descrizione, cpv_codice_padre, cpv_tipologia, cpv_divisione, cpv_gruppo, cpv_classe, cpv_categoria, settore_interventi_id, settore_interventi_codice, settore_interventi_descrizione) AS (
			select livello, cpv_id_padre, cpv_id, cpv_codice, cpv_descrizione, cpv_codice_padre, cpv_tipologia, cpv_divisione, cpv_gruppo, cpv_classe, cpv_categoria, settore_interventi_id, settore_interventi_codice, settore_interventi_descrizione
			from cpass_v_cpv cvc where exists 
			( select 1 from cpass_d_oggetti_spesa cdos 
			where cdos.cpv_id = cvc.cpv_id )
			union all 
			 select
				 cvc2.livello, cvc2.cpv_id_padre, cvc2.cpv_id, cvc2.cpv_codice, cvc2.cpv_descrizione, cvc2.cpv_codice_padre, cvc2.cpv_tipologia, cvc2.cpv_divisione, cvc2.cpv_gruppo, cvc2.cpv_classe, cvc2.cpv_categoria, cvc2.settore_interventi_id, cvc2.settore_interventi_codice, cvc2.settore_interventi_descrizione
			 FROM cpass_v_cpv cvc2,
			   alberoCpvOds alberoCpvOds
			WHERE alberoCpvOds.cpv_id_padre = cvc2.cpv_id
			        )	
 SELECT row_number() OVER () AS id_v_cpv_ods, dist.*
 FROM
    ( SELECT DISTINCT  
    alberoCpvOds.livello,
    alberoCpvOds.cpv_id_padre,
    alberoCpvOds.cpv_id,
    alberoCpvOds.cpv_codice,
    alberoCpvOds.cpv_descrizione,
    alberoCpvOds.cpv_codice_padre,
    alberoCpvOds.cpv_tipologia,
    alberoCpvOds.cpv_divisione,
    alberoCpvOds.cpv_gruppo,
    alberoCpvOds.cpv_classe,
    alberoCpvOds.cpv_categoria,
    alberoCpvOds.settore_interventi_id,
    alberoCpvOds.settore_interventi_codice,
    alberoCpvOds.settore_interventi_descrizione
   FROM alberoCpvOds) dist
   ORDER BY dist.livello DESC, dist.cpv_id;

-- Permissions

ALTER TABLE cpass.cpass_v_cpv OWNER TO cpass;
GRANT ALL ON TABLE cpass.cpass_v_cpv TO cpass;
