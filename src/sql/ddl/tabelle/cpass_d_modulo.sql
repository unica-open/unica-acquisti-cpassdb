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
-- Name: cpass_d_modulo; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_d_modulo (
    modulo_id integer NOT NULL,
    modulo_codice character varying(50) NOT NULL,
    modulo_descrizione character varying(500) NOT NULL
);


ALTER TABLE cpass.cpass_d_modulo OWNER TO cpass;

--
-- Name: cpass_d_modulo_modulo_id_seq; Type: SEQUENCE; Schema: cpass; Owner: cpass
--

CREATE SEQUENCE cpass.cpass_d_modulo_modulo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cpass.cpass_d_modulo_modulo_id_seq OWNER TO cpass;

--
-- Name: cpass_d_modulo_modulo_id_seq; Type: SEQUENCE OWNED BY; Schema: cpass; Owner: cpass
--

ALTER SEQUENCE cpass.cpass_d_modulo_modulo_id_seq OWNED BY cpass.cpass_d_modulo.modulo_id;


--
-- Name: cpass_d_modulo modulo_id; Type: DEFAULT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_d_modulo ALTER COLUMN modulo_id SET DEFAULT nextval('cpass.cpass_d_modulo_modulo_id_seq'::regclass);


--
-- Name: cpass_d_modulo cpass_d_modulo_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_d_modulo
    ADD CONSTRAINT cpass_d_modulo_pkey PRIMARY KEY (modulo_id);


--
-- PostgreSQL database dump complete
--

