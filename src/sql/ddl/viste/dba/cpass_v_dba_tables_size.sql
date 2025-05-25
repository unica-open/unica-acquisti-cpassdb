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
CREATE OR REPLACE VIEW cpass.cpass_v_dba_tables_size AS
SELECT sum(a.total_size_indexes_num) AS size_tables_indexes_num,
  sum(a.total_size_no_indexes_num) AS size_tables_no_indexes_num,
  sum(a.total_size_num) AS size_tables_num,
  pg_size_pretty(sum(a.total_size_indexes_num)) AS size_tables_indexes,
  pg_size_pretty(sum(a.total_size_no_indexes_num)) AS size_tables_no_indexes,
  pg_size_pretty(sum(a.total_size_num)) AS size_tables
FROM cpass_v_dba_tables_size_det a
ORDER BY (sum(a.total_size_num)) DESC;
