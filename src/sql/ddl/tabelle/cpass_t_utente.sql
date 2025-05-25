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
-- Name: cpass_t_utente; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_t_utente (
    utente_id uuid NOT NULL,
    utente_nome character varying(100) NOT NULL,
    utente_cognome character varying(100) NOT NULL,
    utente_codice_fiscale character varying(16) NOT NULL,
    data_creazione timestamp without time zone DEFAULT now() NOT NULL,
    utente_creazione character varying(250) NOT NULL,
    data_modifica timestamp without time zone DEFAULT now() NOT NULL,
    utente_modifica character varying(250) NOT NULL,
    data_cancellazione timestamp without time zone,
    utente_cancellazione character varying(250),
    optlock uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    telefono character varying(200),
    email character varying(200)
);


ALTER TABLE cpass.cpass_t_utente OWNER TO cpass;

--
-- Name: TABLE cpass_t_utente; Type: COMMENT; Schema: cpass; Owner: cpass
--

COMMENT ON TABLE cpass.cpass_t_utente IS 'UUID namespace: "da1eb474-aca6-58dc-a7ba-012a655f6855"';


--
-- Name: cpass_t_utente cpass_t_utente_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_utente
    ADD CONSTRAINT cpass_t_utente_pkey PRIMARY KEY (utente_id);


--
-- PostgreSQL database dump complete
--

