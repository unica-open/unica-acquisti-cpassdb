---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2021 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2021 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
---
drop view cpass.cpass_v_utente;
-- � una vista di utilit� allo sviluppo, modificare se serve
CREATE OR REPLACE VIEW cpass.cpass_v_utente
AS SELECT u.utente_cognome,
    u.utente_nome,
    rus.ruolo_utente_settore_id,
    u.utente_codice_fiscale,
    s.settore_codice,
    r.ruolo_codice,
    rus.data_validita_inizio AS ruolo_utentesettore_inizio,
    rus.data_validita_fine AS ruolo_utentesettore_fine,
    us.data_validita_inizio AS utente_settore_inizio,
    us.data_validita_fine AS utente_settore_fine,
    e.ente_id ,
    e.ente_codice 
   FROM cpass_t_utente u
     JOIN cpass_r_utente_settore us ON us.utente_id = u.utente_id
     JOIN cpass_t_settore s ON us.settore_id = s.settore_id
     JOIN cpass_r_ruolo_utente_settore rus ON rus.utente_settore_id = us.utente_settore_id
     JOIN cpass_d_ruolo r ON r.ruolo_id = rus.ruolo_id
     join cpass_t_ente e on e.ente_id = s.ente_id 
  ORDER BY u.utente_codice_fiscale;
