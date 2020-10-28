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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cpass_t_progressivo; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_t_progressivo (
    progressivo_tipo character varying(200) NOT NULL,
    progressivo_codice character varying(200) NOT NULL,
    progressivo_numero integer NOT NULL
);


ALTER TABLE cpass.cpass_t_progressivo OWNER TO cpass;

--
-- Name: cpass_t_progressivo cpass_t_progressivo_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_progressivo
    ADD CONSTRAINT cpass_t_progressivo_pkey PRIMARY KEY (progressivo_tipo, progressivo_codice);


--
-- PostgreSQL database dump complete
--

