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
--DROP TABLE IF EXISTS cpass.cpass_r_ruolo_utente_settore CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_r_utente_settore CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_t_utente CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_t_settore CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_r_ruolo_modulo CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_r_ruolo_permesso CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_ruolo CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_tipo_settore CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_permesso CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_modulo CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_ausa CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_t_intervento_importi CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_t_intervento CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_t_programma CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_t_ente CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_cpv CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_settore_interventi CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_mod_affidamento CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_priorita CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_nuts CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_risorsa CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_stato CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_ricompreso_tipo CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_t_progressivo CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_t_uuid_namespace CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_t_comunicazione CASCADE;
--DROP TABLE IF EXISTS cpass.cpass_d_acquisto_variato CASCADE;


CREATE TABLE cpass.cpass_t_progressivo (
	progressivo_tipo CHARACTER VARYING(200),
	progressivo_codice CHARACTER VARYING(200),
	progressivo_numero INTEGER NOT NULL
);
CREATE TABLE cpass.cpass_d_risorsa (
	risorsa_id SERIAL PRIMARY KEY,
	risorsa_codice CHARACTER VARYING(50) NOT NULL,
	risorsa_descrizione CHARACTER VARYING(500) NOT NULL,
	risorsa_tipo CHARACTER VARYING(500) 
);

CREATE TABLE cpass.cpass_d_acquisto_variato (
	acquisto_variato_id SERIAL PRIMARY KEY,
	acquisto_variato_codice CHARACTER VARYING(50) NOT NULL,
	acquisto_variato_descrizione CHARACTER VARYING(500) NOT NULL
);

CREATE TABLE cpass.cpass_d_ricompreso_tipo (
	ricompreso_tipo_id SERIAL PRIMARY KEY,
	ricompreso_tipo_codice CHARACTER VARYING(50) NOT NULL,
	ricompreso_tipo_descrizione CHARACTER VARYING(500) NOT NULL,
	ricompreso_tipo_cui_obbligatorio BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TABLE cpass.cpass_d_stato (
	stato_id SERIAL PRIMARY KEY,
	stato_codice CHARACTER VARYING(50) NOT NULL,
	stato_descrizione CHARACTER VARYING(500) NOT NULL,
	stato_tipo CHARACTER VARYING(200) NOT NULL
);
CREATE TABLE cpass.cpass_d_ausa (
	ausa_id SERIAL PRIMARY KEY,
	ausa_codice CHARACTER VARYING(50) NOT NULL,
	ausa_descrizione CHARACTER VARYING(500) NOT NULL,
	ausa_codice_fiscale CHARACTER VARYING(16) NOT NULL
);
CREATE TABLE cpass.cpass_d_nuts (
	nuts_id SERIAL PRIMARY KEY,
	nuts_codice CHARACTER VARYING(50) NOT NULL,
	nuts_descrizione CHARACTER VARYING(500) NOT NULL
);
CREATE TABLE cpass.cpass_d_priorita (
	priorita_id          SERIAL PRIMARY KEY,
	priorita_codice      CHARACTER VARYING(50) NOT NULL,
	priorita_descrizione CHARACTER VARYING(500) NOT NULL
);
CREATE TABLE cpass.cpass_d_mod_affidamento (
	mod_affidamento_id SERIAL PRIMARY KEY,
	mod_affidamento_codice      CHARACTER VARYING(50) NOT NULL,	
	mod_affidamento_descrizione CHARACTER VARYING(500) NOT NULL
);
CREATE TABLE cpass.cpass_d_settore_interventi (
	settore_interventi_id SERIAL PRIMARY KEY,
	settore_interventi_codice CHARACTER VARYING(500) NOT NULL,
	settore_interventi_descrizione CHARACTER VARYING(500) NOT NULL
);
CREATE TABLE cpass.cpass_d_cpv (
	cpv_id SERIAL PRIMARY KEY,
	cpv_codice CHARACTER VARYING(50) NOT NULL,
	cpv_descrizione CHARACTER VARYING(500) NOT NULL,
	cpv_codice_padre CHARACTER VARYING(50),
	cpv_tipologia CHARACTER VARYING(50) NOT NULL,
	cpv_divisione CHARACTER VARYING(50) NOT NULL,
	cpv_gruppo CHARACTER VARYING(50) NOT NULL,
	cpv_classe CHARACTER VARYING(50) NOT NULL,
	cpv_categoria CHARACTER VARYING(50) NOT NULL,
	settore_interventi_id INTEGER
);
CREATE TABLE cpass.cpass_t_ente (
	ente_id UUID PRIMARY KEY,
	ente_denominazione CHARACTER VARYING(500) NOT NULL,
	ente_codice_fiscale CHARACTER VARYING(16) NOT NULL,
	data_creazione TIMESTAMP NOT NULL DEFAULT now(),
	utente_creazione CHARACTER VARYING(250) NOT NULL,
	data_modifica TIMESTAMP NOT NULL DEFAULT now(),
	utente_modifica CHARACTER VARYING(250) NOT NULL,
	data_cancellazione TIMESTAMP,
	utente_cancellazione CHARACTER VARYING(250),
	optlock UUID NOT NULL DEFAULT uuid_generate_v4()
);
CREATE TABLE cpass.cpass_t_programma (
	programma_id UUID PRIMARY KEY,
	programma_anno INTEGER NOT NULL,
	programma_referente CHARACTER VARYING(50),
	ente_id UUID NOT NULL,
	stato_id INTEGER NOT NULL,
	data_creazione TIMESTAMP NOT NULL DEFAULT now(),
	utente_creazione CHARACTER VARYING(250) NOT NULL,
	data_modifica TIMESTAMP NOT NULL DEFAULT now(),
	utente_modifica CHARACTER VARYING(250) NOT NULL,
	data_cancellazione TIMESTAMP,
	utente_cancellazione CHARACTER VARYING(250),
	optlock UUID NOT NULL DEFAULT uuid_generate_v4()
);
CREATE TABLE cpass.cpass_t_intervento (
	intervento_id UUID PRIMARY KEY,
	intervento_cui CHARACTER VARYING(50) NOT NULL,
	intervento_anno_avvio INTEGER NOT NULL,
	intervento_cup CHARACTER VARYING(15),	
	--intervento_ricompreso CHARACTER VARYING(500),
	ricompreso_tipo_id INTEGER ,
	intervento_ricompreso_id UUID,
	intervento_lotto_funzionale BOOLEAN NOT NULL DEFAULT false,
	intervento_durata_mesi INTEGER NOT NULL,
	intervento_nuovo_affid BOOLEAN NOT NULL DEFAULT false,
	ausa_id INTEGER,
	acquisto_variato_id INTEGER,	
	utente_rup_id UUID NOT NULL,
    intervento_descrizione_acquisto CHARACTER VARYING(500) NOT NULL,
	settore_interventi_id INTEGER NOT NULL,
	cpv_id INTEGER NOT NULL,
	programma_id UUID NOT NULL,
	nuts_id INTEGER NOT NULL,
	priorita_id INTEGER NOT NULL,
	mod_affidamento_id INTEGER NOT NULL,
	stato_id INTEGER NOT NULL,
	data_creazione TIMESTAMP NOT NULL DEFAULT now(),
	utente_creazione CHARACTER VARYING(250) NOT NULL,
	data_modifica TIMESTAMP NOT NULL DEFAULT now(),
	utente_modifica CHARACTER VARYING(250) NOT NULL,
	data_cancellazione TIMESTAMP,
	utente_cancellazione CHARACTER VARYING(250),
	optlock UUID NOT NULL DEFAULT uuid_generate_v4()
);
CREATE TABLE cpass.cpass_t_intervento_importi (
	intervento_importi_id UUID PRIMARY KEY,
	intervento_importi_importo_anno_primo NUMERIC NOT NULL,
	intervento_importi_importo_anno_secondo NUMERIC NOT NULL,
	intervento_importi_importo_anni_successivi NUMERIC NOT NULL,
	risorsa_id INTEGER NOT NULL,
	intervento_id UUID NOT NULL,
	data_creazione TIMESTAMP NOT NULL DEFAULT now(),
	utente_creazione CHARACTER VARYING(250) NOT NULL,
	data_modifica TIMESTAMP NOT NULL DEFAULT now(),
	utente_modifica CHARACTER VARYING(250) NOT NULL,
	data_cancellazione TIMESTAMP,
	utente_cancellazione CHARACTER VARYING(250),
	optlock UUID NOT NULL DEFAULT uuid_generate_v4()
);
CREATE TABLE cpass.cpass_t_uuid_namespace (
	uuid_namespace_table CHARACTER VARYING(200) PRIMARY KEY,
	uuid_namespace_value UUID NOT NULL
);
CREATE TABLE cpass.cpass_d_modulo(
	modulo_id SERIAL PRIMARY KEY,
    modulo_codice VARCHAR(50) NOT NULL,
    modulo_descrizione VARCHAR(500) NOT NULL
);
CREATE TABLE cpass.cpass_d_permesso (
  permesso_id SERIAL PRIMARY KEY,
  permesso_codice VARCHAR(50) NOT NULL,
  permesso_descrizione VARCHAR(500) NOT NULL,
  permesso_titolo_box VARCHAR(200) NOT NULL,
  permesso_voce_menu BOOLEAN DEFAULT FALSE,
  permesso_tipo VARCHAR(200) NOT NULL
); 
CREATE TABLE cpass.cpass_d_tipo_settore (
	tipo_settore_id SERIAL PRIMARY KEY,
	tipo_settore_codice CHARACTER VARYING(50) NOT NULL,
	tipo_settore_descrizione CHARACTER VARYING(500) NOT NULL
);
CREATE TABLE cpass.cpass_d_ruolo (
	ruolo_id SERIAL PRIMARY KEY,
	ruolo_codice CHARACTER VARYING(50) NOT NULL,
	ruolo_descrizione CHARACTER VARYING(500) NOT NULL
);

CREATE TABLE cpass.cpass_r_ruolo_permesso (
	ruolo_permesso_id SERIAL PRIMARY KEY,
	ruolo_id INTEGER NOT NULL,
	permesso_id INTEGER NOT NULL
);
CREATE TABLE cpass.cpass_r_ruolo_modulo (
	ruolo_modulo_id SERIAL PRIMARY KEY,
	ruolo_id INTEGER NOT NULL,
	modulo_id INTEGER NOT NULL
);
CREATE TABLE cpass.cpass_t_settore (
	settore_id UUID PRIMARY KEY,
	settore_codice CHARACTER VARYING(50) NOT NULL,
	settore_descrizione CHARACTER VARYING(500) NOT NULL,
	settore_indirizzo CHARACTER VARYING(500) NOT NULL,
	settore_localita CHARACTER VARYING(500) NOT NULL,
	settore_provincia CHARACTER VARYING(2) NOT NULL,
	settore_cap CHARACTER VARYING(5) NOT NULL,
	settore_telefono CHARACTER VARYING(50) NOT NULL,
	ente_id UUID NOT NULL,
	tipo_settore_id INTEGER NOT NULL,
	data_creazione TIMESTAMP NOT NULL DEFAULT now(),
	utente_creazione CHARACTER VARYING(250) NOT NULL,
	data_modifica TIMESTAMP NOT NULL DEFAULT now(),
	utente_modifica CHARACTER VARYING(250) NOT NULL,
	data_cancellazione TIMESTAMP,
	utente_cancellazione CHARACTER VARYING(250),
	optlock UUID NOT NULL DEFAULT uuid_generate_v4()
);
CREATE TABLE cpass.cpass_t_utente (
	utente_id UUID PRIMARY KEY,
	utente_nome CHARACTER VARYING(100) NOT NULL,
	utente_cognome CHARACTER VARYING(100) NOT NULL,
	utente_codice_fiscale CHARACTER VARYING(16) NOT NULL,
	data_creazione TIMESTAMP NOT NULL DEFAULT now(),
	utente_creazione CHARACTER VARYING(250) NOT NULL,
	data_modifica TIMESTAMP NOT NULL DEFAULT now(),
	utente_modifica CHARACTER VARYING(250) NOT NULL,
	data_cancellazione TIMESTAMP,
	utente_cancellazione CHARACTER VARYING(250),
	optlock UUID NOT NULL DEFAULT uuid_generate_v4()
);
CREATE TABLE cpass.cpass_r_utente_settore (
	utente_settore_id SERIAL PRIMARY KEY,
	utente_id UUID NOT NULL,
	settore_id UUID NOT NULL,
	utente_settore_default BOOLEAN NOT NULL DEFAULT FALSE,
    utente_rup_id UUID
);
CREATE TABLE cpass.cpass_r_ruolo_utente_settore (
	ruolo_utente_settore_id SERIAL PRIMARY KEY,
	utente_settore_id INTEGER NOT NULL,
	ruolo_id INTEGER NOT NULL
);
CREATE TABLE cpass.cpass_t_comunicazione (
	comunicazione_id SERIAL PRIMARY KEY,
	comunicazione_tipo CHARACTER VARYING(50) NOT NULL,
	comunicazione_testo CHARACTER VARYING(4000) NOT NULL,
    comunicazione_data_inizio TIMESTAMP ,
    comunicazione_data_fine TIMESTAMP ,    
    data_creazione TIMESTAMP NOT NULL DEFAULT now(),
	utente_creazione CHARACTER VARYING(250) NOT NULL,
	data_modifica TIMESTAMP NOT NULL DEFAULT now(),
	utente_modifica CHARACTER VARYING(250) NOT NULL,
	data_cancellazione TIMESTAMP,
	utente_cancellazione CHARACTER VARYING(250),
	optlock UUID NOT NULL DEFAULT uuid_generate_v4()
);

ALTER TABLE cpass.cpass_t_progressivo ADD CONSTRAINT cpass_t_progressivo_pkey PRIMARY KEY (progressivo_tipo, progressivo_codice);

ALTER TABLE ONLY cpass.cpass_t_programma ADD CONSTRAINT fk_cpass_t_programma_t_ente FOREIGN KEY (ente_id) REFERENCES cpass.cpass_t_ente (ente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento ADD CONSTRAINT fk_cpass_t_intervento_t_programma FOREIGN KEY (programma_id) REFERENCES cpass.cpass_t_programma (programma_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento ADD CONSTRAINT fk_cpass_t_intervento_d_settore_interventi FOREIGN KEY (settore_interventi_id) REFERENCES cpass.cpass_d_settore_interventi (settore_interventi_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento ADD CONSTRAINT fk_cpass_t_intervento_d_cpv FOREIGN KEY (cpv_id) REFERENCES cpass.cpass_d_cpv (cpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_d_cpv ADD CONSTRAINT fk_cpass_d_cpv_d_settore_interventi FOREIGN KEY (settore_interventi_id) REFERENCES cpass.cpass_d_settore_interventi(settore_interventi_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento ADD CONSTRAINT fk_cpass_t_intervento_d_nuts FOREIGN KEY (nuts_id) REFERENCES cpass.cpass_d_nuts (nuts_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento ADD CONSTRAINT fk_cpass_t_intervento_d_priorita FOREIGN KEY (priorita_id) REFERENCES cpass.cpass_d_priorita (priorita_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento ADD CONSTRAINT fk_cpass_t_intervento_d_acquisto_variato FOREIGN KEY (acquisto_variato_id) REFERENCES cpass.cpass_d_acquisto_variato (acquisto_variato_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento ADD CONSTRAINT fk_cpass_t_intervento_d_mod_affidamento FOREIGN KEY (mod_affidamento_id) REFERENCES cpass.cpass_d_mod_affidamento (mod_affidamento_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento ADD CONSTRAINT fk_cpass_t_intervento_d_ricompreso FOREIGN KEY (ricompreso_tipo_id) REFERENCES cpass.cpass_d_ricompreso_tipo (ricompreso_tipo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento ADD CONSTRAINT fk_cpass_t_intervento_d_stato FOREIGN KEY (stato_id) REFERENCES cpass.cpass_d_stato (stato_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_programma ADD CONSTRAINT fk_cpass_t_programma_d_stato FOREIGN KEY (stato_id) REFERENCES cpass.cpass_d_stato (stato_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento ADD CONSTRAINT fk_cpass_t_intervento_d_ausa FOREIGN KEY (ausa_id) REFERENCES cpass.cpass_d_ausa (ausa_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento ADD CONSTRAINT fk_cpass_t_intervento_t_intervento FOREIGN KEY (intervento_ricompreso_id) REFERENCES cpass.cpass_t_intervento (intervento_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento ADD CONSTRAINT fk_cpass_t_intervento_t_utente_rup FOREIGN KEY (utente_rup_id) REFERENCES cpass.cpass_t_utente (utente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento_importi ADD CONSTRAINT fk_cpass_t_intervento_importi_d_risorsa FOREIGN KEY (risorsa_id) REFERENCES cpass.cpass_d_risorsa (risorsa_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_intervento_importi ADD CONSTRAINT fk_cpass_t_intervento_importi_t_intervento FOREIGN KEY (intervento_id) REFERENCES cpass.cpass_t_intervento (intervento_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_r_ruolo_permesso ADD CONSTRAINT fk_cpass_r_ruolo_permesso_d_ruolo FOREIGN KEY (ruolo_id) REFERENCES cpass.cpass_d_ruolo (ruolo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_r_ruolo_permesso ADD CONSTRAINT fk_cpass_r_ruolo_permesso_d_permesso FOREIGN KEY (permesso_id) REFERENCES cpass.cpass_d_permesso (permesso_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_r_ruolo_modulo ADD CONSTRAINT fk_cpass_r_ruolo_modulo_d_ruolo FOREIGN KEY (ruolo_id) REFERENCES cpass.cpass_d_ruolo (ruolo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_r_ruolo_modulo ADD CONSTRAINT fk_cpass_r_ruolo_modulo_d_modulo FOREIGN KEY (modulo_id) REFERENCES cpass.cpass_d_modulo (modulo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_settore ADD CONSTRAINT fk_cpass_t_settore_t_ente FOREIGN KEY (ente_id) REFERENCES cpass.cpass_t_ente (ente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_t_settore ADD CONSTRAINT fk_cpass_t_settore_d_tipo_settore FOREIGN KEY (tipo_settore_id) REFERENCES cpass.cpass_d_tipo_settore (tipo_settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.cpass_r_utente_settore ADD CONSTRAINT fk_cpass_r_utente_settore_t_utente FOREIGN KEY (utente_id) REFERENCES cpass.cpass_t_utente (utente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_r_utente_settore ADD CONSTRAINT fk_cpass_r_utente_settore_t_settore FOREIGN KEY (settore_id) REFERENCES cpass.cpass_t_settore (settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.cpass_r_utente_settore ADD CONSTRAINT fk_cpass_r_utente_settore_t_utente_rup FOREIGN KEY (utente_rup_id) REFERENCES cpass.cpass_t_utente (utente_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE ONLY cpass.cpass_r_ruolo_utente_settore ADD CONSTRAINT fk_cpass_r_ruolo_utente_settore_r_utente_settore FOREIGN KEY (utente_settore_id) REFERENCES cpass.cpass_r_utente_settore (utente_settore_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE ONLY cpass.cpass_r_ruolo_utente_settore ADD CONSTRAINT fk_cpass_r_ruolo_utente_settore_d_ruolo FOREIGN KEY (ruolo_id) REFERENCES cpass.cpass_d_ruolo (ruolo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;



COMMENT ON TABLE cpass.cpass_t_utente IS 'UUID namespace: "da1eb474-aca6-58dc-a7ba-012a655f6855"';
COMMENT ON TABLE cpass.cpass_t_settore IS 'UUID namespace: "b7fcf183-a9ad-5b9e-928b-7ad2a903fcf4"';
COMMENT ON TABLE cpass.cpass_d_ruolo IS 'UUID namespace: "05d66368-91d3-5059-8f1a-e58fbb9ca6e9"';
COMMENT ON TABLE cpass.cpass_t_intervento_importi IS 'UUID namespace: "0a6cbfee-6a4e-588e-a963-9714f24e009b"';
COMMENT ON TABLE cpass.cpass_t_intervento IS 'UUID namespace: "b128dcb1-ce93-5a44-9f7f-b13a5996989b"';
COMMENT ON TABLE cpass.cpass_t_programma IS 'UUID namespace: "303e83fc-cede-58e8-8744-0801cd354225"';
COMMENT ON TABLE cpass.cpass_t_ente IS 'UUID namespace: "8863d583-f86b-53b1-8b9d-842fd53d75e8"';
COMMENT ON TABLE cpass.cpass_t_uuid_namespace IS 'UUID namespaces for the tables';
