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
-- Name: cpass_t_elaborazione_parametro; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_t_elaborazione_parametro (
    elaborazione_parametro_id integer NOT NULL,
    elaborazione_id integer NOT NULL,
    elaborazione_parametro_chiave character varying(50) NOT NULL,
    elaborazione_parametro_valore character varying(4000)
);


ALTER TABLE cpass.cpass_t_elaborazione_parametro OWNER TO cpass;

--
-- Name: cpass_t_elaborazione_parametro_elaborazione_parametro_id_seq; Type: SEQUENCE; Schema: cpass; Owner: cpass
--

CREATE SEQUENCE cpass.cpass_t_elaborazione_parametro_elaborazione_parametro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cpass.cpass_t_elaborazione_parametro_elaborazione_parametro_id_seq OWNER TO cpass;

--
-- Name: cpass_t_elaborazione_parametro_elaborazione_parametro_id_seq; Type: SEQUENCE OWNED BY; Schema: cpass; Owner: cpass
--

ALTER SEQUENCE cpass.cpass_t_elaborazione_parametro_elaborazione_parametro_id_seq OWNED BY cpass.cpass_t_elaborazione_parametro.elaborazione_parametro_id;


--
-- Name: cpass_t_elaborazione_parametro elaborazione_parametro_id; Type: DEFAULT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_elaborazione_parametro ALTER COLUMN elaborazione_parametro_id SET DEFAULT nextval('cpass.cpass_t_elaborazione_parametro_elaborazione_parametro_id_seq'::regclass);


--
-- Name: cpass_t_elaborazione_parametro cpass_t_elaborazione_parametro_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_elaborazione_parametro
    ADD CONSTRAINT cpass_t_elaborazione_parametro_pkey PRIMARY KEY (elaborazione_parametro_id);


--
-- Name: cpass_t_elaborazione_parametro fk_cpass_t_elaborazione_parametro_t_elaborazione; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_elaborazione_parametro
    ADD CONSTRAINT fk_cpass_t_elaborazione_parametro_t_elaborazione FOREIGN KEY (elaborazione_id) REFERENCES cpass.cpass_t_elaborazione(elaborazione_id);


--
-- PostgreSQL database dump complete
--

