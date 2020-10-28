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
-- ESTRAE GLI UTENTI CON I RELATIVI RUOLI E PERMESSI
select ut.utente_nome, ut.utente_cognome, ut.utente_codice_fiscale , s.settore_descrizione, r.ruolo_codice, p.*
from cpass_t_utente ut
join cpass_r_utente_settore rus on (rus.utente_id = ut.utente_id)
join cpass_t_settore s on (rus.settore_id = s.settore_id)
join cpass_r_ruolo_utente_settore rrus on (rrus.utente_settore_id = rus.utente_settore_id)
join cpass_d_ruolo r on (r.ruolo_id = rrus.ruolo_id)
join cpass_r_ruolo_permesso rp on (rp.ruolo_id = r.ruolo_id)
join cpass_d_permesso p on (p.permesso_id = rp.permesso_id);
