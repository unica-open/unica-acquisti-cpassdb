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
CREATE OR REPLACE VIEW cpass.cpass_v_dba_kill_pid AS
SELECT 'select * from pg_terminate_backend('::text || pg_stat_activity.pid || ');'::text AS script
FROM pg_stat_activity
WHERE pg_stat_activity.datname = current_database();
