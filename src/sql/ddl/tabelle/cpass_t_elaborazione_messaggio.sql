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
-- Name: cpass_t_elaborazione_messaggio; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_t_elaborazione_messaggio (
    elaborazione_messaggio_id integer NOT NULL,
    elaborazione_id integer NOT NULL,
    elaborazione_messaggio_tipo character varying(50) NOT NULL,
    elaborazione_messaggio_code character varying(100),
    elaborazione_messaggio_descrizione character varying(4000)
);


ALTER TABLE cpass.cpass_t_elaborazione_messaggio OWNER TO cpass;

--
-- Name: cpass_t_elaborazione_messaggio_elaborazione_messaggio_id_seq; Type: SEQUENCE; Schema: cpass; Owner: cpass
--

CREATE SEQUENCE cpass.cpass_t_elaborazione_messaggio_elaborazione_messaggio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cpass.cpass_t_elaborazione_messaggio_elaborazione_messaggio_id_seq OWNER TO cpass;

--
-- Name: cpass_t_elaborazione_messaggio_elaborazione_messaggio_id_seq; Type: SEQUENCE OWNED BY; Schema: cpass; Owner: cpass
--

ALTER SEQUENCE cpass.cpass_t_elaborazione_messaggio_elaborazione_messaggio_id_seq OWNED BY cpass.cpass_t_elaborazione_messaggio.elaborazione_messaggio_id;


--
-- Name: cpass_t_elaborazione_messaggio elaborazione_messaggio_id; Type: DEFAULT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_elaborazione_messaggio ALTER COLUMN elaborazione_messaggio_id SET DEFAULT nextval('cpass.cpass_t_elaborazione_messaggio_elaborazione_messaggio_id_seq'::regclass);


--
-- Name: cpass_t_elaborazione_messaggio cpass_t_elaborazione_messaggio_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_elaborazione_messaggio
    ADD CONSTRAINT cpass_t_elaborazione_messaggio_pkey PRIMARY KEY (elaborazione_messaggio_id);


--
-- Name: cpass_t_elaborazione_messaggio fk_cpass_t_elaborazione_messaggio_t_elaborazione; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_elaborazione_messaggio
    ADD CONSTRAINT fk_cpass_t_elaborazione_messaggio_t_elaborazione FOREIGN KEY (elaborazione_id) REFERENCES cpass.cpass_t_elaborazione(elaborazione_id);


--
-- PostgreSQL database dump complete
--

