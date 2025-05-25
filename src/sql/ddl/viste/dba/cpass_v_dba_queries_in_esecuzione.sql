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
CREATE OR REPLACE VIEW cpass.cpass_v_dba_queries_in_esecuzione AS
SELECT pg_stat_activity.datid,
  pg_stat_activity.datname,
  pg_stat_activity.pid AS procpid,
  pg_stat_activity.usesysid,
  pg_stat_activity.usename,
  pg_stat_activity.application_name,
  pg_stat_activity.client_hostname,
  pg_stat_activity.client_port,
  pg_stat_activity.backend_start,
  pg_stat_activity.xact_start,
  pg_stat_activity.query_start,
  pg_stat_activity.state_change,
  pg_stat_activity.state,
  pg_stat_activity.query,
  (regexp_replace(text(pg_stat_activity.client_addr), '/.*'::text, ''::text) || ':'::text) || pg_stat_activity.client_port::text AS addr
FROM pg_stat_activity
WHERE pg_stat_activity.usename = "current_user"()
AND pg_stat_activity.state <> 'idle'::text;
