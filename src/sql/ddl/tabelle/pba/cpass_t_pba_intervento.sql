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
-- Name: cpass_t_pba_intervento; Type: TABLE; Schema: cpass; Owner: cpass
--

CREATE TABLE cpass.cpass_t_pba_intervento (
    intervento_id uuid NOT NULL,
    intervento_cui character varying(50) NOT NULL,
    intervento_anno_avvio integer NOT NULL,
    intervento_cup character varying(15),
    ricompreso_tipo_id integer,
    intervento_ricompreso_id uuid,
    intervento_lotto_funzionale boolean DEFAULT false NOT NULL,
    intervento_durata_mesi integer NOT NULL,
    intervento_nuovo_affid boolean DEFAULT false NOT NULL,
    ausa_id integer,
    acquisto_variato_id integer,
    utente_rup_id uuid NOT NULL,
    intervento_descrizione_acquisto character varying(500) NOT NULL,
    settore_interventi_id integer NOT NULL,
    cpv_id integer NOT NULL,
    programma_id uuid NOT NULL,
    nuts_id integer NOT NULL,
    priorita_id integer NOT NULL,
    mod_affidamento_id integer NOT NULL,
    stato_id integer NOT NULL,
    data_creazione timestamp without time zone DEFAULT now() NOT NULL,
    utente_creazione character varying(250) NOT NULL,
    data_modifica timestamp without time zone DEFAULT now() NOT NULL,
    utente_modifica character varying(250) NOT NULL,
    data_cancellazione timestamp without time zone,
    utente_cancellazione character varying(250),
    optlock uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    intervento_copia_id uuid,
    flag_cui_non_generato boolean DEFAULT false,
    motivazione_non_riproposto character varying(500),
    intervento_copia_tipo character varying(50),
    intervento_importi_copia_tipo character varying(50)
);


ALTER TABLE cpass.cpass_t_pba_intervento OWNER TO cpass;

--
-- Name: TABLE cpass_t_pba_intervento; Type: COMMENT; Schema: cpass; Owner: cpass
--

COMMENT ON TABLE cpass.cpass_t_pba_intervento IS 'UUID namespace: "b128dcb1-ce93-5a44-9f7f-b13a5996989b"';


--
-- Name: cpass_t_pba_intervento cpass_t_intervento_pkey; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT cpass_t_intervento_pkey PRIMARY KEY (intervento_id);


--
-- Name: cpass_t_pba_intervento idx_cui_programma_unique; Type: CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT idx_cui_programma_unique UNIQUE (programma_id, intervento_cui);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_d_acquisto_variato; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_d_acquisto_variato FOREIGN KEY (acquisto_variato_id) REFERENCES cpass.cpass_d_pba_acquisto_variato(acquisto_variato_id);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_d_ausa; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_d_ausa FOREIGN KEY (ausa_id) REFERENCES cpass.cpass_d_pba_ausa(ausa_id);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_d_cpv; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_d_cpv FOREIGN KEY (cpv_id) REFERENCES cpass.cpass_d_cpv(cpv_id);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_d_mod_affidamento; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_d_mod_affidamento FOREIGN KEY (mod_affidamento_id) REFERENCES cpass.cpass_d_pba_mod_affidamento(mod_affidamento_id);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_d_nuts; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_d_nuts FOREIGN KEY (nuts_id) REFERENCES cpass.cpass_d_pba_nuts(nuts_id);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_d_priorita; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_d_priorita FOREIGN KEY (priorita_id) REFERENCES cpass.cpass_d_pba_priorita(priorita_id);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_d_ricompreso; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_d_ricompreso FOREIGN KEY (ricompreso_tipo_id) REFERENCES cpass.cpass_d_pba_ricompreso_tipo(ricompreso_tipo_id);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_d_settore_interventi; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_d_settore_interventi FOREIGN KEY (settore_interventi_id) REFERENCES cpass.cpass_d_pba_settore_interventi(settore_interventi_id);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_d_stato; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_d_stato FOREIGN KEY (stato_id) REFERENCES cpass.cpass_d_stato(stato_id);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_t_intervento; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_t_intervento FOREIGN KEY (intervento_ricompreso_id) REFERENCES cpass.cpass_t_pba_intervento(intervento_id);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_t_intervento_copia; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_t_intervento_copia FOREIGN KEY (intervento_copia_id) REFERENCES cpass.cpass_t_pba_intervento(intervento_id);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_t_programma; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_t_programma FOREIGN KEY (programma_id) REFERENCES cpass.cpass_t_pba_programma(programma_id);


--
-- Name: cpass_t_pba_intervento fk_cpass_t_intervento_t_utente_rup; Type: FK CONSTRAINT; Schema: cpass; Owner: cpass
--

ALTER TABLE ONLY cpass.cpass_t_pba_intervento
    ADD CONSTRAINT fk_cpass_t_intervento_t_utente_rup FOREIGN KEY (utente_rup_id) REFERENCES cpass.cpass_t_utente(utente_id);


--
-- PostgreSQL database dump complete
--


    
    
    
  /*  
delete from   cpass_r_utente_settore  where settore_id <>'a2f1eaa7-17dd-59db-ad27-d57db6dc0175';
delete from   cpass_r_ruolo_utente_settore  where settore_id <>'a2f1eaa7-17dd-59db-ad27-d57db6dc0175';
delete from   cpass_t_comunicazione;
delete from   cpass_t_elaborazione_parametro;
delete from   cpass_t_elaborazione_messaggio;
delete from   cpass_t_elaborazione;
delete from   cpass_t_progressivo;
delete from   cpass_t_utente;
delete from   cpass_t_settore where settore_id <> 'a2f1eaa7-17dd-59db-ad27-d57db6dc0175';
delete from   cpass_t_pba_intervento_importi;
delete from   cpass_t_pba_intervento;
delete from   cpass_t_pba_programma;
*/    
    
    
    
5-5-2020    
11-5-2020
18-5-2020
25-5-2020
