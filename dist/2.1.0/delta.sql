---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
/*
 select ctu.utente_id ,
ctu.utente_codice_fiscale ,
cts.settore_codice ,
crurs.*
from cpass_r_utente_rup_settore crurs
join cpass_t_settore cts on cts.settore_id = crurs.settore_id 
join cpass_t_utente ctu on ctu.utente_id = crurs.utente_id
where ctu.utente_id = '96ea0033-718d-5291-a569-9bea2d1edc6b'


update cpass_r_utente_rup_settore set data_validita_fine = null  
where utente_id = '96ea0033-718d-5291-a569-9bea2d1edc6b' and settore_id in ('c837f4c6-d16c-5958-96f0-c247293426ec','5c140e35-5536-572d-94ba-4ab438ab5f27');

delete from cpass_r_utente_rup_settore where utente_rup_settore_id >= 185;

select * from Cpass_R_Utente_Settore where utente_id = '96ea0033-718d-5291-a569-9bea2d1edc6b' and settore_id = 'c837f4c6-d16c-5958-96f0-c247293426ec'

delete from Cpass_R_Utente_Settore where  utente_settore_id > 286;
		
delete from cpass_r_ruolo_utente_settore where utente_settore_id > 286;

select * from cpass_r_ruolo_utente_settore where utente_settore_id > 286;
	

drop INDEX Cpass_R_Utente_Settore_unique;

CREATE UNIQUE INDEX Cpass_R_Utente_Settore_unique ON cpass.Cpass_R_Utente_Settore USING btree (utente_id, settore_id, data_validita_fine);



select count (utente_id), utente_id, settore_id, data_validita_fine 
from Cpass_R_Utente_Settore
group by utente_id, settore_id, data_validita_fine order by 1 desc ;


select * from Cpass_R_Utente_Settore where 
utente_id = 'c1954195-33e9-5f81-9e9a-c842a7373f6f' and settore_id = 'b3415484-cd9a-52e8-b55a-521b6801f1d4'

delete from cpass_r_ruolo_utente_settore  where Utente_Settore_id in(251);
delete from Cpass_R_Utente_Settore where Utente_Settore_id in(251);

 */
CREATE UNIQUE INDEX Cpass_R_Utente_Settore_unique ON cpass.Cpass_R_Utente_Settore USING btree (utente_id, settore_id, data_validita_fine);
CREATE UNIQUE INDEX cpass_r_utente_rup_settore_unique ON cpass.cpass_r_utente_rup_settore USING btree (utente_id, settore_id, data_validita_fine);

ALTER TABLE cpass.cpass_t_ord_sezione ALTER COLUMN settore_id SET NOT NULL;


ALTER TABLE cpass.cpass_r_ord_utente_sezione ADD COLUMN settore_id UUID;

ALTER TABLE IF EXISTS cpass.cpass_r_ord_utente_sezione DROP CONSTRAINT IF EXISTS fk_cpass_r_utente_settore_utente_sezione;
ALTER TABLE IF EXISTS cpass.cpass_r_ord_utente_sezione ADD CONSTRAINT fk_cpass_r_utente_settore_utente_sezione FOREIGN KEY (settore_id)
REFERENCES cpass.cpass_t_settore(settore_id);

--NB SANARE I DATI
--update cpass_r_ord_utente_sezione set settore_id = '89e9e5c2-c37e-5b1e-9f9e-c2b4668d8421';

ALTER TABLE cpass.cpass_r_ord_utente_sezione ALTER COLUMN settore_id SET NOT NULL;






