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
-- Name: cpass_t_comunicazione; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_t_comunicazione (
    comunicazione_id integer NOT NULL,
    comunicazione_tipo character varying(50) NOT NULL,
    comunicazione_testo character varying(4000) NOT NULL,
    comunicazione_data_inizio timestamp without time zone,
    comunicazione_data_fine timestamp without time zone,
    data_creazione timestamp without time zone DEFAULT now() NOT NULL,
    utente_creazione character varying(250) NOT NULL,
    data_modifica timestamp without time zone DEFAULT now() NOT NULL,
    utente_modifica character varying(250) NOT NULL,
    data_cancellazione timestamp without time zone,
    utente_cancellazione character varying(250),
    optlock uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


ALTER TABLE cpass.cpass_t_comunicazione OWNER TO cpass;

--
-- Name: cpass_t_comunicazione_comunicazione_id_seq; Type: SEQUENCE; Schema: cpass; Owner: cpass
--

CREATE SEQUENCE cpass.cpass_t_comunicazione_comunicazione_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cpass.cpass_t_comunicazione_comunicazione_id_seq OWNER TO cpass;

--
-- Name: cpass_t_comunicazione_comunicazione_id_seq; Type: SEQUENCE OWNED BY; Schema: cpass; Owner: cpass
--

ALTER SEQUENCE cpass.cpass_t_comunicazione_comunicazione_id_seq OWNED BY cpass.cpass_t_comunicazione.comunicazione_id;


--
-- Name: cpass_t_comunicazione comunicazione_id; Type: DEFAULT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_comunicazione ALTER COLUMN comunicazione_id SET DEFAULT nextval('cpass.cpass_t_comunicazione_comunicazione_id_seq'::regclass);


--
-- Name: cpass_t_comunicazione cpass_t_comunicazione_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_comunicazione
    ADD CONSTRAINT cpass_t_comunicazione_pkey PRIMARY KEY (comunicazione_id);


--
-- PostgreSQL database dump complete
--

