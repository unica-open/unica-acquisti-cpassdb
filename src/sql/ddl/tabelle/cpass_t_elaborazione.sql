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
-- Name: cpass_t_elaborazione; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_t_elaborazione (
    elaborazione_id integer NOT NULL,
    entita_id character varying(200) NOT NULL,
    elaborazione_utente character varying(50) NOT NULL,
    elaborazione_stato character varying(50) NOT NULL,
    elaborazione_data timestamp without time zone,
    elaborazione_esito character varying(50),
    elaborazione_tipo_id integer,
    elaborazione_tipo character varying(200)
);


ALTER TABLE cpass.cpass_t_elaborazione OWNER TO cpass;

--
-- Name: cpass_t_elaborazione_elaborazione_id_seq; Type: SEQUENCE; Schema: cpass; Owner: cpass
--

CREATE SEQUENCE cpass.cpass_t_elaborazione_elaborazione_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cpass.cpass_t_elaborazione_elaborazione_id_seq OWNER TO cpass;

--
-- Name: cpass_t_elaborazione_elaborazione_id_seq; Type: SEQUENCE OWNED BY; Schema: cpass; Owner: cpass
--

ALTER SEQUENCE cpass.cpass_t_elaborazione_elaborazione_id_seq OWNED BY cpass.cpass_t_elaborazione.elaborazione_id;


--
-- Name: cpass_t_elaborazione elaborazione_id; Type: DEFAULT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_elaborazione ALTER COLUMN elaborazione_id SET DEFAULT nextval('cpass.cpass_t_elaborazione_elaborazione_id_seq'::regclass);


--
-- Name: cpass_t_elaborazione cpass_t_elaborazione_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_elaborazione
    ADD CONSTRAINT cpass_t_elaborazione_pkey PRIMARY KEY (elaborazione_id);


--
-- Name: cpass_t_elaborazione fk_cpass_t_elaborazione_d_elaborazione_tipo; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_elaborazione
    ADD CONSTRAINT fk_cpass_t_elaborazione_d_elaborazione_tipo FOREIGN KEY (elaborazione_tipo_id) REFERENCES cpass.cpass_d_elaborazione_tipo(elaborazione_tipo_id);


--
-- PostgreSQL database dump complete
--

