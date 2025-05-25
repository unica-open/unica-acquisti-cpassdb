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
CREATE OR REPLACE VIEW cpass.cpass_v_dba_tables_rows_count_estimated AS
SELECT b.tablename AS table_name,
  a.reltuples AS row_count_estimated
FROM pg_class a,
  pg_tables b
WHERE a.relkind = 'r'::"char"
AND b.tablename = a.relname
AND b.schemaname = 'cpass'::name
ORDER BY b.tablename;
