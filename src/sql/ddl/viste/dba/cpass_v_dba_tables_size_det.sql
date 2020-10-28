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
CREATE OR REPLACE VIEW cpass.cpass_v_dba_tables_size_det
AS SELECT c.relname::text AS tablename,
  pg_table_size(c.oid::regclass) AS total_size_no_indexes_num,
  pg_total_relation_size(c.oid::regclass) - pg_table_size(c.oid::regclass) AS total_size_indexes_num,
  pg_total_relation_size(c.oid::regclass) AS total_size_num,
  pg_size_pretty(pg_table_size(c.oid::regclass)) AS total_size_no_indexes,
  pg_size_pretty(pg_total_relation_size(c.oid::regclass) - pg_table_size(c.oid::regclass)) AS total_size_indexes,
  pg_size_pretty(pg_total_relation_size(c.oid::regclass)) AS total_size
FROM pg_class c
LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE (n.nspname <> ALL (ARRAY['pg_catalog'::name, 'information_schema'::name]))
AND c.relkind <> 'i'::"char"
AND n.nspname !~ '^pg_toast'::text
AND n.nspname = 'cpass'::name
ORDER BY (pg_total_relation_size(c.oid::regclass)) DESC;
