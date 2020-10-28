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
-- Name: cpass_t_ente; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_t_ente (
    ente_id uuid NOT NULL,
    ente_codice	varchar(50) NOT NULL;
    ente_denominazione character varying(500) NOT NULL,
    ente_codice_fiscale character varying(16) NOT NULL,
    data_creazione timestamp without time zone DEFAULT now() NOT NULL,
    utente_creazione character varying(250) NOT NULL,
    data_modifica timestamp without time zone DEFAULT now() NOT NULL,
    utente_modifica character varying(250) NOT NULL,
    data_cancellazione timestamp without time zone,
    utente_cancellazione character varying(250),
    optlock uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    codice_ipa_amministrazione character varying(200),
    dipartimento character varying(200),
    ufficio character varying(200),
    regione character varying(200),
    provincia character varying(200),
    indirizzo character varying(200),
    telefono character varying(200),
    email character varying(200),
    emailpec character varying(200)
);


ALTER TABLE cpass.cpass_t_ente OWNER TO cpass;

--
-- Name: TABLE cpass_t_ente; Type: COMMENT; Schema: cpass; Owner: cpass
--

COMMENT ON TABLE cpass.cpass_t_ente IS 'UUID namespace: "8863d583-f86b-53b1-8b9d-842fd53d75e8"';


--
-- Name: cpass_t_ente cpass_t_ente_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_ente
    ADD CONSTRAINT cpass_t_ente_pkey PRIMARY KEY (ente_id);


--
-- PostgreSQL database dump complete
--

