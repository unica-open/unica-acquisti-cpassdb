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
CREATE OR REPLACE VIEW cpass.cpass_v_dba_stat_all_tables AS
SELECT tb.schemaname,
  tb.relname,
  tb.n_live_tup,
  tb.n_dead_tup,
  tb.reltuples,
  tb.threshold_tup,
  tb.percent_dead_on_live,
  tb.threshold_percent_deadtup_on_livetup,
  tb.autovacuum_vacuum_cost_limit,
  tb.autovacuum_vacuum_cost_delay,
  tb.vacuum_cost_limit,
  tb.deadtup_size_num,
  tb.deadtup_size,
  tb.total_size_indexes_num,
  tb.total_size_num,
  tb.total_size_no_indexes,
  tb.total_size_indexes,
  tb.total_size,
  tb.seq_scan,
  tb.seq_tup_read,
  tb.idx_scan,
  tb.idx_tup_fetch,
  tb.n_tup_ins,
  tb.n_tup_upd,
  tb.n_tup_del,
  tb.n_tup_hot_upd,
  tb.last_vacuum,
  tb.last_autovacuum,
  tb.last_analyze,
  tb.last_autoanalyze,
  tb.vacuum_count,
  tb.autovacuum_count,
  tb.analyze_count,
  tb.autoanalyze_count
FROM (
  WITH thr AS (
    SELECT c.setting::numeric AS autovacuum_vacuum_threshold
    FROM pg_settings c
    WHERE c.name = 'autovacuum_vacuum_threshold'::text
  ), avcl AS (
    SELECT c.setting::numeric AS autovacuum_vacuum_cost_limit
    FROM pg_settings c
    WHERE c.name = 'autovacuum_vacuum_cost_limit'::text
  ), avcd AS (
    SELECT c.setting::numeric AS autovacuum_vacuum_cost_delay
    FROM pg_settings c
    WHERE c.name = 'autovacuum_vacuum_cost_delay'::text
  ), vcl AS (
    SELECT c.setting::numeric AS vacuum_cost_limit
    FROM pg_settings c
    WHERE c.name = 'vacuum_cost_limit'::text
  ), scaf AS (
    SELECT c.setting::numeric AS autovacuum_vacuum_scale_factor
    FROM pg_settings c
    WHERE c.name = 'autovacuum_vacuum_scale_factor'::text
  ), dt AS (
    WITH aa AS (
      SELECT a.schemaname,
        a.relname,
        a.seq_scan,
        a.seq_tup_read,
        a.idx_scan,
        a.idx_tup_fetch,
        a.n_tup_ins,
        a.n_tup_upd,
        a.n_tup_del,
        a.n_tup_hot_upd,
        a.last_vacuum,
        a.last_autovacuum,
        a.last_analyze,
        a.last_autoanalyze,
        a.vacuum_count,
        a.autovacuum_count,
        a.analyze_count,
        a.autoanalyze_count,
        a.n_live_tup,
        a.n_dead_tup,
        CASE
          WHEN a.n_dead_tup IS NULL OR a.n_dead_tup = 0 OR a.n_live_tup IS NULL OR a.n_live_tup = 0 THEN 0::numeric
          ELSE round(a.n_dead_tup::numeric / a.n_live_tup::numeric * 100::numeric, 2)
        END AS percent_dead_on_live,
        b.reltuples::numeric AS reltuples
      FROM pg_stat_all_tables a,
        pg_class b
      WHERE b.oid = a.relid
    ), bb AS (
      SELECT c.relname::text AS tablename,
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
    )
    SELECT aa.schemaname,
      aa.relname,
      aa.seq_scan,
      aa.seq_tup_read,
      aa.idx_scan,
      aa.idx_tup_fetch,
      aa.n_tup_ins,
      aa.n_tup_upd,
      aa.n_tup_del,
      aa.n_tup_hot_upd,
      aa.last_vacuum,
      aa.last_autovacuum,
      aa.last_analyze,
      aa.last_autoanalyze,
      aa.vacuum_count,
      aa.autovacuum_count,
      aa.analyze_count,
      aa.autoanalyze_count,
      aa.n_live_tup,
      aa.n_dead_tup,
      aa.percent_dead_on_live,
      aa.reltuples,
      bb.total_size_no_indexes_num,
      bb.total_size_indexes_num,
      bb.total_size_num,
      bb.total_size_no_indexes,
      bb.total_size_indexes,
      bb.total_size
    FROM aa
    JOIN bb ON aa.relname::text = bb.tablename
  )
  SELECT dt.schemaname,
    dt.relname,
    dt.n_live_tup,
    dt.n_dead_tup,
    dt.reltuples,
    thr.autovacuum_vacuum_threshold + dt.reltuples * scaf.autovacuum_vacuum_scale_factor AS threshold_tup,
    dt.percent_dead_on_live,
    CASE
      WHEN dt.n_live_tup IS NULL OR dt.n_live_tup = 0 THEN 0::numeric
      ELSE round((thr.autovacuum_vacuum_threshold + dt.reltuples * scaf.autovacuum_vacuum_scale_factor) / dt.n_live_tup::numeric, 2) * 100::numeric
    END AS threshold_percent_deadtup_on_livetup,
    avcl.autovacuum_vacuum_cost_limit,
    avcd.autovacuum_vacuum_cost_delay,
    vcl.vacuum_cost_limit,
    CASE
      WHEN dt.percent_dead_on_live = 0::numeric OR dt.percent_dead_on_live IS NULL THEN 0::numeric
      ELSE dt.percent_dead_on_live / 100::numeric * dt.total_size_num::numeric
    END AS deadtup_size_num,
    CASE
      WHEN dt.percent_dead_on_live = 0::numeric OR dt.percent_dead_on_live IS NULL THEN pg_size_pretty(0::numeric)
      ELSE pg_size_pretty(dt.percent_dead_on_live / 100::numeric * dt.total_size_num::numeric)
    END AS deadtup_size,
    dt.total_size_indexes_num,
    dt.total_size_num,
    dt.total_size_no_indexes,
    dt.total_size_indexes,
    dt.total_size,
    dt.seq_scan,
    dt.seq_tup_read,
    dt.idx_scan,
    dt.idx_tup_fetch,
    dt.n_tup_ins,
    dt.n_tup_upd,
    dt.n_tup_del,
    dt.n_tup_hot_upd,
    dt.last_vacuum,
    dt.last_autovacuum,
    dt.last_analyze,
    dt.last_autoanalyze,
    dt.vacuum_count,
    dt.autovacuum_count,
    dt.analyze_count,
    dt.autoanalyze_count
  FROM dt,
    thr,
    scaf,
    avcl,
    avcd,
    vcl
) tb;
