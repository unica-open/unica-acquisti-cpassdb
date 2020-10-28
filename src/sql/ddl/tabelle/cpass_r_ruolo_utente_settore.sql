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
-- Name: cpass_r_ruolo_utente_settore; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_r_ruolo_utente_settore (
    ruolo_utente_settore_id integer NOT NULL,
    utente_settore_id integer NOT NULL,
    ruolo_id integer NOT NULL
);


ALTER TABLE cpass.cpass_r_ruolo_utente_settore OWNER TO cpass;

--
-- Name: cpass_r_ruolo_utente_settore_ruolo_utente_settore_id_seq; Type: SEQUENCE; Schema: cpass; Owner: cpass
--

CREATE SEQUENCE cpass.cpass_r_ruolo_utente_settore_ruolo_utente_settore_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cpass.cpass_r_ruolo_utente_settore_ruolo_utente_settore_id_seq OWNER TO cpass;

--
-- Name: cpass_r_ruolo_utente_settore_ruolo_utente_settore_id_seq; Type: SEQUENCE OWNED BY; Schema: cpass; Owner: cpass
--

ALTER SEQUENCE cpass.cpass_r_ruolo_utente_settore_ruolo_utente_settore_id_seq OWNED BY cpass.cpass_r_ruolo_utente_settore.ruolo_utente_settore_id;


--
-- Name: cpass_r_ruolo_utente_settore ruolo_utente_settore_id; Type: DEFAULT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_r_ruolo_utente_settore ALTER COLUMN ruolo_utente_settore_id SET DEFAULT nextval('cpass.cpass_r_ruolo_utente_settore_ruolo_utente_settore_id_seq'::regclass);


--
-- Name: cpass_r_ruolo_utente_settore cpass_r_ruolo_utente_settore_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_r_ruolo_utente_settore
    ADD CONSTRAINT cpass_r_ruolo_utente_settore_pkey PRIMARY KEY (ruolo_utente_settore_id);


--
-- Name: cpass_r_ruolo_utente_settore fk_cpass_r_ruolo_utente_settore_d_ruolo; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_r_ruolo_utente_settore
    ADD CONSTRAINT fk_cpass_r_ruolo_utente_settore_d_ruolo FOREIGN KEY (ruolo_id) REFERENCES cpass.cpass_d_ruolo(ruolo_id);


--
-- Name: cpass_r_ruolo_utente_settore fk_cpass_r_ruolo_utente_settore_r_utente_settore; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_r_ruolo_utente_settore
    ADD CONSTRAINT fk_cpass_r_ruolo_utente_settore_r_utente_settore FOREIGN KEY (utente_settore_id) REFERENCES cpass.cpass_r_utente_settore(utente_settore_id);


--
-- PostgreSQL database dump complete
--

