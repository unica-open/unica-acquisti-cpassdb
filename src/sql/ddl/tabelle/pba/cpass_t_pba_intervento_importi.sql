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
-- Name: cpass_t_pba_intervento_importi; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_t_pba_intervento_importi (
    intervento_importi_id uuid NOT NULL,
    intervento_importi_importo_anno_primo numeric NOT NULL,
    intervento_importi_importo_anno_secondo numeric NOT NULL,
    intervento_importi_importo_anni_successivi numeric NOT NULL,
    risorsa_id integer NOT NULL,
    intervento_id uuid NOT NULL,
    data_creazione timestamp without time zone DEFAULT now() NOT NULL,
    utente_creazione character varying(250) NOT NULL,
    data_modifica timestamp without time zone DEFAULT now() NOT NULL,
    utente_modifica character varying(250) NOT NULL,
    data_cancellazione timestamp without time zone,
    utente_cancellazione character varying(250),
    optlock uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


ALTER TABLE cpass.cpass_t_pba_intervento_importi OWNER TO cpass;

--
-- Name: TABLE cpass_t_pba_intervento_importi; Type: COMMENT; Schema: cpass; Owner: cpass
--

COMMENT ON TABLE cpass.cpass_t_pba_intervento_importi IS 'UUID namespace: "0a6cbfee-6a4e-588e-a963-9714f24e009b"';


--
-- Name: cpass_t_pba_intervento_importi cpass_t_intervento_importi_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento_importi
    ADD CONSTRAINT cpass_t_intervento_importi_pkey PRIMARY KEY (intervento_importi_id);


--
-- Name: cpass_t_pba_intervento_importi fk_cpass_t_intervento_importi_d_risorsa; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento_importi
    ADD CONSTRAINT fk_cpass_t_intervento_importi_d_risorsa FOREIGN KEY (risorsa_id) REFERENCES cpass.cpass_d_pba_risorsa(risorsa_id);


--
-- Name: cpass_t_pba_intervento_importi fk_cpass_t_intervento_importi_t_intervento; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento_importi
    ADD CONSTRAINT fk_cpass_t_intervento_importi_t_intervento FOREIGN KEY (intervento_id) REFERENCES cpass.cpass_t_pba_intervento(intervento_id);


--
-- PostgreSQL database dump complete
--

