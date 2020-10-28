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
-- cpass_t_parametro per MIT inizio
-- UPDATE cpass.cpass_t_parametro
-- SET valore = 'https://www.serviziocontrattipubblici.it/WSLoginCollaudo/rest'
-- WHERE chiave = 'MIT_URL_WSLOGIN'
-- ;

-- UPDATE cpass.cpass_t_parametro
-- SET valore = 'https://www.serviziocontrattipubblici.it/WSProgrammiCollaudo/rest'
-- WHERE chiave = 'MIT_URL_WSPROGRAMMI'
-- ;

-- prendere l'IP di www.serviziocontrattipubblici.it
UPDATE cpass.cpass_t_parametro
SET valore = 'http://131.1.220.215/WSLoginCollaudo/rest'
WHERE chiave = 'MIT_URL_WSLOGIN'
;

UPDATE cpass.cpass_t_parametro
SET valore = 'http://131.1.220.215/WSProgrammiCollaudo/rest'
WHERE chiave = 'MIT_URL_WSPROGRAMMI'
;

-- cpass_t_parametro per MIT fine
