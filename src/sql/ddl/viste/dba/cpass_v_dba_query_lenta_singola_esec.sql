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
CREATE OR REPLACE VIEW cpass.cpass_v_dba_query_lenta_singola_esec AS
SELECT tb.query,
  tb.rolname,
  tb.tot_millisecondi,
  tb.tot_minuti,
  tb.tot_secondi,
  tb.secondi_per_esecuzione,
  tb.esecuzioni
FROM (
  SELECT a.query,
    pr.rolname,
    round(a.total_time::numeric, 2) AS tot_millisecondi,
    round(round(round(a.total_time::numeric, 2) / 1000::numeric, 2) / 60::numeric, 2) AS tot_minuti,
    round(round(a.total_time::numeric, 2) / 1000::numeric, 2) AS tot_secondi,
    round(round(round(a.total_time::numeric, 2) / 1000::numeric, 2) / a.calls::numeric, 2) AS secondi_per_esecuzione,
    a.calls AS esecuzioni
  FROM pg_stat_statements a
  JOIN pg_roles pr ON (pr.oid = a.userid)
  WHERE pr.rolname <> 'postgres'
) tb
WHERE tb.secondi_per_esecuzione > 1::numeric
ORDER BY tb.secondi_per_esecuzione DESC;
