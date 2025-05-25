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
-- Name: cpass_t_pba_programma; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_t_pba_programma (
    programma_id uuid NOT NULL,
    programma_anno integer NOT NULL,
    ente_id uuid NOT NULL,
    data_creazione timestamp without time zone DEFAULT now() NOT NULL,
    utente_creazione character varying(250) NOT NULL,
    data_modifica timestamp without time zone DEFAULT now() NOT NULL,
    utente_modifica character varying(250) NOT NULL,
    data_cancellazione timestamp without time zone,
    utente_cancellazione character varying(250),
    optlock uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    stato_id integer NOT NULL,
    numero_provvedimento integer,
    descrizione_provvedimento character varying(500),
    data_provvedimento timestamp without time zone,
    data_pubblicazione timestamp without time zone,
    url character varying(500),
    utente_referente_id uuid NOT NULL,
    programma_descrizione character varying(200),
    programma_versione integer DEFAULT 1 NOT NULL,
    programma_codice_mit character varying(20) DEFAULT '00000000000000000000'::character varying NOT NULL,
    id_ricevuto_mit bigint,
    data_approvazione timestamp without time zone
);


ALTER TABLE cpass.cpass_t_pba_programma OWNER TO cpass;

--
-- Name: TABLE cpass_t_pba_programma; Type: COMMENT; Schema: cpass; Owner: cpass
--

COMMENT ON TABLE cpass.cpass_t_pba_programma IS 'UUID namespace: "303e83fc-cede-58e8-8744-0801cd354225"';


--
-- Name: cpass_t_pba_programma cpass_t_programma_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_programma
    ADD CONSTRAINT cpass_t_programma_pkey PRIMARY KEY (programma_id);


--
-- Name: cpass_t_pba_programma idx_anno_versione_unique; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_programma
    ADD CONSTRAINT idx_anno_versione_unique UNIQUE (programma_anno, programma_versione);


--
-- Name: cpass_t_pba_programma fk_cpass_t_programma_d_stato; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_programma
    ADD CONSTRAINT fk_cpass_t_programma_d_stato FOREIGN KEY (stato_id) REFERENCES cpass.cpass_d_stato(stato_id);


--
-- Name: cpass_t_pba_programma fk_cpass_t_programma_t_ente; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_programma
    ADD CONSTRAINT fk_cpass_t_programma_t_ente FOREIGN KEY (ente_id) REFERENCES cpass.cpass_t_ente(ente_id);


--
-- PostgreSQL database dump complete
--

