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
CREATE OR REPLACE FUNCTION cpass.pck_cpass_dba_all_db_size()
RETURNS TABLE(db_name_out text, db_size_out text)
LANGUAGE plpgsql
AS
$function$
DECLARE
  rec_out record;
BEGIN
  for rec_out in
    select a.datname::text database_name,
      pg_size_pretty(pg_database_size(a.datname))::text size
    from pg_database a
  loop
    db_name_out:=rec_out.database_name;
    db_size_out:=rec_out.size;
    return next;
  end loop;
  return;
END;
$function$
;
