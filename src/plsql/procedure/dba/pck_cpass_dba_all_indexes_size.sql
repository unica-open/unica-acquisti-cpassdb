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
CREATE OR REPLACE FUNCTION siac.fnc_dba_all_indexes_size(schema_in text)
RETURNS TABLE(indexes_size_out_txt text)
LANGUAGE plpgsql
AS $function$
DECLARE
  rec_out record;
BEGIN
  for rec_out in
    select pg_size_pretty(sum(indexes_size_out)) all_indexes_size
    from fnc_dba_indexes_size(schema_in)
  loop
    indexes_size_out_txt:=rec_out.all_indexes_size;
    return next;
  end loop;
  return;
END;
$function$
;
