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
CREATE OR REPLACE VIEW cpass.cpass_v_dba_fk_all AS
SELECT tc.constraint_schema AS schema_name,
  ss2.confrelid::regclass AS pk_table,
  af.attname AS pk_field,
  ss2.conrelid::regclass AS fk_table,
  a.attname AS fk_field,
  tc.constraint_name
FROM pg_attribute af,
  pg_attribute a,
  (
    SELECT ss.conrelid,
      ss.confrelid,
      ss.conkey[ss.i] AS conkey,
      ss.confkey[ss.i] AS confkey
    FROM (
      SELECT pg_constraint.conrelid,
        pg_constraint.confrelid,
        pg_constraint.conkey,
        pg_constraint.confkey,
        generate_series(1, array_upper(pg_constraint.conkey, 1)) AS i
      FROM pg_constraint
      WHERE pg_constraint.contype = 'f'::"char"
    ) ss
  ) ss2,
information_schema.table_constraints tc,
information_schema.key_column_usage kcu,
information_schema.constraint_column_usage ccu
WHERE af.attnum = ss2.confkey
AND af.attrelid = ss2.confrelid
AND a.attnum = ss2.conkey
AND a.attrelid = ss2.conrelid
AND tc.constraint_name::text = kcu.constraint_name::text
AND ccu.constraint_name::text = tc.constraint_name::text
AND tc.constraint_type::text = 'FOREIGN KEY'::text
AND tc.constraint_schema::text = 'cpass'::text
AND tc.table_name::text = ss2.conrelid::regclass::character varying::text;
