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
-- Name: cpass_d_ruolo; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_d_ruolo (
    ruolo_id integer NOT NULL,
    ruolo_codice character varying(50) NOT NULL,
    ruolo_descrizione character varying(500) NOT NULL
);


ALTER TABLE cpass.cpass_d_ruolo OWNER TO cpass;

--
-- Name: TABLE cpass_d_ruolo; Type: COMMENT; Schema: cpass; Owner: cpass
--

COMMENT ON TABLE cpass.cpass_d_ruolo IS 'UUID namespace: "05d66368-91d3-5059-8f1a-e58fbb9ca6e9"';


--
-- Name: cpass_d_ruolo_ruolo_id_seq; Type: SEQUENCE; Schema: cpass; Owner: cpass
--

CREATE SEQUENCE cpass.cpass_d_ruolo_ruolo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cpass.cpass_d_ruolo_ruolo_id_seq OWNER TO cpass;

--
-- Name: cpass_d_ruolo_ruolo_id_seq; Type: SEQUENCE OWNED BY; Schema: cpass; Owner: cpass
--

ALTER SEQUENCE cpass.cpass_d_ruolo_ruolo_id_seq OWNED BY cpass.cpass_d_ruolo.ruolo_id;


--
-- Name: cpass_d_ruolo ruolo_id; Type: DEFAULT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_d_ruolo ALTER COLUMN ruolo_id SET DEFAULT nextval('cpass.cpass_d_ruolo_ruolo_id_seq'::regclass);


--
-- Name: cpass_d_ruolo cpass_d_ruolo_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_d_ruolo
    ADD CONSTRAINT cpass_d_ruolo_pkey PRIMARY KEY (ruolo_id);


--
-- PostgreSQL database dump complete
--

