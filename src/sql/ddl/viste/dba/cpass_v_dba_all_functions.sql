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
CREATE OR REPLACE VIEW cpass.cpass_v_dba_all_functions AS
SELECT n.nspname AS f_schema,
  format('%I'::text, p.proname) AS f_name,
  pg_get_function_result(p.oid) AS f_result_data_type,
  pg_get_function_arguments(p.oid) AS f_argument_data_type,
  CASE
    WHEN p.proisagg THEN 'agg'::text
    WHEN p.proiswindow THEN 'window'::text
    WHEN p.prorettype = 'trigger'::regtype::oid THEN 'trigger'::text
    ELSE 'normal'::text
  END AS f_type,
  p.prosrc AS f_source_code
FROM pg_proc p
LEFT JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE pg_function_is_visible(p.oid) AND n.nspname <> 'pg_catalog'::name AND n.nspname <> 'information_schema'::name
ORDER BY n.nspname, (format('%I'::text, p.proname)), (pg_get_function_arguments(p.oid));
