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
--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.16
-- Dumped by pg_dump version 9.6.17

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: cpass_v_cpv; Type: VIEW; Schema: cpass; Owner: cpass
--

CREATE VIEW cpass.cpass_v_cpv AS
 WITH RECURSIVE alberocpv(livello, cpv_id_padre, cpv_id, cpv_codice, cpv_descrizione, cpv_codice_padre, cpv_tipologia, cpv_divisione, cpv_gruppo, cpv_classe, cpv_categoria, settore_interventi_id, settore_interventi_codice, settore_interventi_descrizione) AS (
         SELECT 1 AS livello,
            NULL::integer AS cpv_id_padre,
            cpv.cpv_id,
            cpv.cpv_codice,
            cpv.cpv_descrizione,
            cpv.cpv_codice_padre,
            cpv.cpv_tipologia,
            cpv.cpv_divisione,
            cpv.cpv_gruppo,
            cpv.cpv_classe,
            cpv.cpv_categoria,
            cpv.settore_interventi_id,
            si.settore_interventi_codice,
            si.settore_interventi_descrizione
           FROM cpass.cpass_d_cpv cpv,
            cpass.cpass_d_pba_settore_interventi si
          WHERE ((cpv.settore_interventi_id = si.settore_interventi_id) AND (cpv.cpv_codice_padre IS NULL))
        UNION ALL
         SELECT (mtree.livello + 1),
            mtree.cpv_id AS cpv_id_padre,
            cpv_figlio.cpv_id,
            cpv_figlio.cpv_codice,
            cpv_figlio.cpv_descrizione,
            cpv_figlio.cpv_codice_padre,
            cpv_figlio.cpv_tipologia,
            cpv_figlio.cpv_divisione,
            cpv_figlio.cpv_gruppo,
            cpv_figlio.cpv_classe,
            cpv_figlio.cpv_categoria,
            cpv_figlio.settore_interventi_id,
            si_figio.settore_interventi_codice,
            si_figio.settore_interventi_descrizione
           FROM cpass.cpass_d_cpv cpv_figlio,
            cpass.cpass_d_pba_settore_interventi si_figio,
            alberocpv mtree
          WHERE ((cpv_figlio.settore_interventi_id = si_figio.settore_interventi_id) AND ((mtree.cpv_codice)::text = (cpv_figlio.cpv_codice_padre)::text))
        )
 SELECT row_number() OVER () AS id_v_cpv,
    alberocpv.livello,
    alberocpv.cpv_id_padre,
    alberocpv.cpv_id,
    alberocpv.cpv_codice,
    alberocpv.cpv_descrizione,
    alberocpv.cpv_codice_padre,
    alberocpv.cpv_tipologia,
    alberocpv.cpv_divisione,
    alberocpv.cpv_gruppo,
    alberocpv.cpv_classe,
    alberocpv.cpv_categoria,
    alberocpv.settore_interventi_id,
    alberocpv.settore_interventi_codice,
    alberocpv.settore_interventi_descrizione
   FROM alberocpv
  ORDER BY alberocpv.livello DESC, alberocpv.cpv_id;


ALTER TABLE cpass.cpass_v_cpv OWNER TO cpass;

--
-- PostgreSQL database dump complete
--

