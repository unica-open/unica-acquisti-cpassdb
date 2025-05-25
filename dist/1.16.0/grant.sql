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
-- TOC entry 5626 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE cpass_d_pba_acquisto_variato; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_pba_acquisto_variato TO cpass_rw;


--
-- TOC entry 5628 (class 0 OID 0)
-- Dependencies: 228
-- Name: SEQUENCE cpass_d_acquisto_variato_acquisto_variato_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_acquisto_variato_acquisto_variato_id_seq TO cpass_rw;


--
-- TOC entry 5629 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE cpass_d_aliquote_iva; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_aliquote_iva TO cpass_rw;


--
-- TOC entry 5631 (class 0 OID 0)
-- Dependencies: 230
-- Name: SEQUENCE cpass_d_aliquote_iva_aliquote_iva_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_aliquote_iva_aliquote_iva_id_seq TO cpass_rw;


--
-- TOC entry 5632 (class 0 OID 0)
-- Dependencies: 433
-- Name: TABLE cpass_d_aoo_acta; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_d_aoo_acta TO cpass_rw;


--
-- TOC entry 5634 (class 0 OID 0)
-- Dependencies: 432
-- Name: SEQUENCE cpass_d_aoo_acta_aoo_acta_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_aoo_acta_aoo_acta_id_seq TO cpass_rw;


--
-- TOC entry 5635 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE cpass_d_pba_ausa; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_pba_ausa TO cpass_rw;


--
-- TOC entry 5637 (class 0 OID 0)
-- Dependencies: 232
-- Name: SEQUENCE cpass_d_ausa_ausa_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_ausa_ausa_id_seq TO cpass_rw;


--
-- TOC entry 5638 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE cpass_d_cpv; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_cpv TO cpass_rw;


--
-- TOC entry 5640 (class 0 OID 0)
-- Dependencies: 234
-- Name: SEQUENCE cpass_d_cpv_cpv_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_cpv_cpv_id_seq TO cpass_rw;


--
-- TOC entry 5641 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE cpass_d_elaborazione_tipo; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_elaborazione_tipo TO cpass_rw;


--
-- TOC entry 5643 (class 0 OID 0)
-- Dependencies: 236
-- Name: SEQUENCE cpass_d_elaborazione_tipo_elaborazione_tipo_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_elaborazione_tipo_elaborazione_tipo_id_seq TO cpass_rw;


--
-- TOC entry 5644 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE cpass_d_pba_mod_affidamento; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_pba_mod_affidamento TO cpass_rw;


--
-- TOC entry 5646 (class 0 OID 0)
-- Dependencies: 238
-- Name: SEQUENCE cpass_d_mod_affidamento_mod_affidamento_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_mod_affidamento_mod_affidamento_id_seq TO cpass_rw;


--
-- TOC entry 5647 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE cpass_d_modulo; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_modulo TO cpass_rw;


--
-- TOC entry 5649 (class 0 OID 0)
-- Dependencies: 240
-- Name: SEQUENCE cpass_d_modulo_modulo_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_modulo_modulo_id_seq TO cpass_rw;


--
-- TOC entry 5650 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE cpass_d_motivi_esclusione_cig; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_d_motivi_esclusione_cig TO cpass_rw;


--
-- TOC entry 5652 (class 0 OID 0)
-- Dependencies: 242
-- Name: SEQUENCE cpass_d_motivi_esclusione_cig_motivi_esclusione_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_motivi_esclusione_cig_motivi_esclusione_id_seq TO cpass_rw;


--
-- TOC entry 5653 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE cpass_d_pba_nuts; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_pba_nuts TO cpass_rw;


--
-- TOC entry 5655 (class 0 OID 0)
-- Dependencies: 244
-- Name: SEQUENCE cpass_d_nuts_nuts_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_nuts_nuts_id_seq TO cpass_rw;


--
-- TOC entry 5657 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE cpass_d_oggetti_spesa; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_oggetti_spesa TO cpass_rw;


--
-- TOC entry 5659 (class 0 OID 0)
-- Dependencies: 246
-- Name: SEQUENCE cpass_d_oggetti_spesa_oggetti_spesa_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_oggetti_spesa_oggetti_spesa_id_seq TO cpass_rw;


--
-- TOC entry 5660 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE cpass_d_ord_causale_sospensione_evasione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_d_ord_causale_sospensione_evasione TO cpass_rw;


--
-- TOC entry 5662 (class 0 OID 0)
-- Dependencies: 248
-- Name: SEQUENCE cpass_d_ord_causale_sospensione_evas_causale_sospensione_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_ord_causale_sospensione_evas_causale_sospensione_id_seq TO cpass_rw;


--
-- TOC entry 5663 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE cpass_d_ord_stato_nso; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_ord_stato_nso TO cpass_rw;


--
-- TOC entry 5665 (class 0 OID 0)
-- Dependencies: 250
-- Name: SEQUENCE cpass_d_ord_stato_nso_stato_nso_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_ord_stato_nso_stato_nso_id_seq TO cpass_rw;


--
-- TOC entry 5666 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE cpass_d_ord_tipo_evasione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_d_ord_tipo_evasione TO cpass_rw;


--
-- TOC entry 5668 (class 0 OID 0)
-- Dependencies: 252
-- Name: SEQUENCE cpass_d_ord_tipo_evasione_tipo_evasione_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_ord_tipo_evasione_tipo_evasione_id_seq TO cpass_rw;


--
-- TOC entry 5669 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE cpass_d_ord_tipo_ordine; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_ord_tipo_ordine TO cpass_rw;


--
-- TOC entry 5671 (class 0 OID 0)
-- Dependencies: 254
-- Name: SEQUENCE cpass_d_ord_tipo_ordine_tipo_ordine_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_ord_tipo_ordine_tipo_ordine_id_seq TO cpass_rw;


--
-- TOC entry 5672 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE cpass_d_ord_tipo_procedura; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_ord_tipo_procedura TO cpass_rw;


--
-- TOC entry 5674 (class 0 OID 0)
-- Dependencies: 256
-- Name: SEQUENCE cpass_d_ord_tipo_procedura_tipo_procedura_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_ord_tipo_procedura_tipo_procedura_id_seq TO cpass_rw;


--
-- TOC entry 5675 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE cpass_d_pba_priorita; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_pba_priorita TO cpass_rw;


--
-- TOC entry 5676 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE cpass_d_pba_ricompreso_tipo; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_pba_ricompreso_tipo TO cpass_rw;


--
-- TOC entry 5677 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE cpass_d_pba_risorsa; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_pba_risorsa TO cpass_rw;


--
-- TOC entry 5678 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE cpass_d_pba_settore_interventi; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_pba_settore_interventi TO cpass_rw;


--
-- TOC entry 5679 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE cpass_d_pba_tipo_acquisto; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_d_pba_tipo_acquisto TO cpass_rw;


--
-- TOC entry 5681 (class 0 OID 0)
-- Dependencies: 262
-- Name: SEQUENCE cpass_d_pba_tipo_acquisto_tipo_acquisto_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_pba_tipo_acquisto_tipo_acquisto_id_seq TO cpass_rw;


--
-- TOC entry 5682 (class 0 OID 0)
-- Dependencies: 448
-- Name: TABLE cpass_d_pba_tipo_procedura; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_d_pba_tipo_procedura TO cpass_rw;


--
-- TOC entry 5684 (class 0 OID 0)
-- Dependencies: 447
-- Name: SEQUENCE cpass_d_pba_tipo_procedura_tipo_procedura_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_pba_tipo_procedura_tipo_procedura_id_seq TO cpass_rw;


--
-- TOC entry 5685 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE cpass_d_permesso; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_permesso TO cpass_rw;


--
-- TOC entry 5687 (class 0 OID 0)
-- Dependencies: 264
-- Name: SEQUENCE cpass_d_permesso_permesso_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_permesso_permesso_id_seq TO cpass_rw;


--
-- TOC entry 5689 (class 0 OID 0)
-- Dependencies: 265
-- Name: SEQUENCE cpass_d_priorita_priorita_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_priorita_priorita_id_seq TO cpass_rw;


--
-- TOC entry 5690 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE cpass_d_provvedimento_tipo; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_d_provvedimento_tipo TO cpass_rw;


--
-- TOC entry 5692 (class 0 OID 0)
-- Dependencies: 267
-- Name: SEQUENCE cpass_d_provvedimento_tipo_provvedimento_tipo_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_provvedimento_tipo_provvedimento_tipo_id_seq TO cpass_rw;


--
-- TOC entry 5694 (class 0 OID 0)
-- Dependencies: 268
-- Name: SEQUENCE cpass_d_ricompreso_tipo_ricompreso_tipo_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_ricompreso_tipo_ricompreso_tipo_id_seq TO cpass_rw;


--
-- TOC entry 5696 (class 0 OID 0)
-- Dependencies: 269
-- Name: SEQUENCE cpass_d_risorsa_risorsa_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_risorsa_risorsa_id_seq TO cpass_rw;


--
-- TOC entry 5698 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE cpass_d_ruolo; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_ruolo TO cpass_rw;


--
-- TOC entry 5700 (class 0 OID 0)
-- Dependencies: 271
-- Name: SEQUENCE cpass_d_ruolo_ruolo_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_ruolo_ruolo_id_seq TO cpass_rw;


--
-- TOC entry 5702 (class 0 OID 0)
-- Dependencies: 272
-- Name: SEQUENCE cpass_d_settore_interventi_settore_interventi_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_settore_interventi_settore_interventi_id_seq TO cpass_rw;


--
-- TOC entry 5703 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE cpass_d_stato; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_stato TO cpass_rw;


--
-- TOC entry 5704 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE cpass_d_stato_el_ordine; Type: ACL; Schema: cpass; Owner: cpass
--

--GRANT ALL ON TABLE cpass.cpass_d_stato_el_ordine TO cpass_rw;



--
-- TOC entry 5708 (class 0 OID 0)
-- Dependencies: 276
-- Name: SEQUENCE cpass_d_stato_stato_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_stato_stato_id_seq TO cpass_rw;


--
-- TOC entry 5709 (class 0 OID 0)
-- Dependencies: 277
-- Name: TABLE cpass_d_tipo_settore; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_tipo_settore TO cpass_rw;


--
-- TOC entry 5711 (class 0 OID 0)
-- Dependencies: 278
-- Name: SEQUENCE cpass_d_tipo_settore_tipo_settore_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_tipo_settore_tipo_settore_id_seq TO cpass_rw;


--
-- TOC entry 5712 (class 0 OID 0)
-- Dependencies: 279
-- Name: TABLE cpass_d_unita_misura; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_d_unita_misura TO cpass_rw;


--
-- TOC entry 5714 (class 0 OID 0)
-- Dependencies: 280
-- Name: SEQUENCE cpass_d_unita_misura_unita_misura_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_d_unita_misura_unita_misura_id_seq TO cpass_rw;


--
-- TOC entry 5715 (class 0 OID 0)
-- Dependencies: 281
-- Name: TABLE cpass_r_dirigente_settore; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_r_dirigente_settore TO cpass_rw;


--
-- TOC entry 5717 (class 0 OID 0)
-- Dependencies: 282
-- Name: SEQUENCE cpass_r_dirigente_settore_dirigente_settore_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_dirigente_settore_dirigente_settore_id_seq TO cpass_rw;


--
-- TOC entry 5718 (class 0 OID 0)
-- Dependencies: 283
-- Name: TABLE cpass_r_fruitore_servizio; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_r_fruitore_servizio TO cpass_rw;


--
-- TOC entry 5720 (class 0 OID 0)
-- Dependencies: 284
-- Name: SEQUENCE cpass_r_fruitore_servizio_fruitore_servizio_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_fruitore_servizio_fruitore_servizio_id_seq TO cpass_rw;


--
-- TOC entry 5721 (class 0 OID 0)
-- Dependencies: 285
-- Name: TABLE cpass_r_intervento_cpv; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_r_intervento_cpv TO cpass_rw;


--
-- TOC entry 5723 (class 0 OID 0)
-- Dependencies: 286
-- Name: SEQUENCE cpass_r_intervento_cpv_intervento_cpv_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_intervento_cpv_intervento_cpv_id_seq TO cpass_rw;


--
-- TOC entry 5724 (class 0 OID 0)
-- Dependencies: 287
-- Name: TABLE cpass_r_notifica_utente; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_r_notifica_utente TO cpass_rw;


--
-- TOC entry 5726 (class 0 OID 0)
-- Dependencies: 288
-- Name: SEQUENCE cpass_r_notifica_utente_notifica_utente_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_notifica_utente_notifica_utente_id_seq TO cpass_rw;


--
-- TOC entry 5727 (class 0 OID 0)
-- Dependencies: 443
-- Name: TABLE cpass_r_ods_dati_contabili; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_r_ods_dati_contabili TO cpass_rw;


--
-- TOC entry 5729 (class 0 OID 0)
-- Dependencies: 442
-- Name: SEQUENCE cpass_r_ods_dati_contabili_dati_contabili_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_ods_dati_contabili_dati_contabili_id_seq TO cpass_rw;


--
-- TOC entry 5730 (class 0 OID 0)
-- Dependencies: 289
-- Name: TABLE cpass_r_ord_rda_ordine; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_r_ord_rda_ordine TO cpass_rw;


--
-- TOC entry 5732 (class 0 OID 0)
-- Dependencies: 290
-- Name: SEQUENCE cpass_r_ord_rda_ordine_rda_ordine_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_ord_rda_ordine_rda_ordine_id_seq TO cpass_rw;


--
-- TOC entry 5733 (class 0 OID 0)
-- Dependencies: 291
-- Name: TABLE cpass_r_ord_utente_sezione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_r_ord_utente_sezione TO cpass_rw;


--
-- TOC entry 5735 (class 0 OID 0)
-- Dependencies: 292
-- Name: SEQUENCE cpass_r_ord_utente_sezione_utente_sezione_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_ord_utente_sezione_utente_sezione_id_seq TO cpass_rw;


--
-- TOC entry 5736 (class 0 OID 0)
-- Dependencies: 426
-- Name: TABLE cpass_r_pba_stati_intervento; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_r_pba_stati_intervento TO cpass_rw;


--
-- TOC entry 5738 (class 0 OID 0)
-- Dependencies: 425
-- Name: SEQUENCE cpass_r_pba_stati_intervento_stati_intervento_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_pba_stati_intervento_stati_intervento_id_seq TO cpass_rw;


--
-- TOC entry 5739 (class 0 OID 0)
-- Dependencies: 293
-- Name: TABLE cpass_r_pba_storico_intervento_rup; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_r_pba_storico_intervento_rup TO cpass_rw;


--
-- TOC entry 5741 (class 0 OID 0)
-- Dependencies: 294
-- Name: SEQUENCE cpass_r_pba_storico_intervento_rup_intervento_rup_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_pba_storico_intervento_rup_intervento_rup_id_seq TO cpass_rw;


--
-- TOC entry 5742 (class 0 OID 0)
-- Dependencies: 295
-- Name: TABLE cpass_r_ruolo_modulo; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_r_ruolo_modulo TO cpass_rw;


--
-- TOC entry 5744 (class 0 OID 0)
-- Dependencies: 296
-- Name: SEQUENCE cpass_r_ruolo_modulo_ruolo_modulo_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_ruolo_modulo_ruolo_modulo_id_seq TO cpass_rw;


--
-- TOC entry 5745 (class 0 OID 0)
-- Dependencies: 297
-- Name: TABLE cpass_r_ruolo_permesso; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_r_ruolo_permesso TO cpass_rw;


--
-- TOC entry 5747 (class 0 OID 0)
-- Dependencies: 298
-- Name: SEQUENCE cpass_r_ruolo_permesso_ruolo_permesso_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_ruolo_permesso_ruolo_permesso_id_seq TO cpass_rw;


--
-- TOC entry 5748 (class 0 OID 0)
-- Dependencies: 299
-- Name: TABLE cpass_r_ruolo_utente_settore; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_r_ruolo_utente_settore TO cpass_rw;


--
-- TOC entry 5750 (class 0 OID 0)
-- Dependencies: 300
-- Name: SEQUENCE cpass_r_ruolo_utente_settore_ruolo_utente_settore_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_ruolo_utente_settore_ruolo_utente_settore_id_seq TO cpass_rw;


--
-- TOC entry 5751 (class 0 OID 0)
-- Dependencies: 441
-- Name: TABLE cpass_r_settore_aoo_acta; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_r_settore_aoo_acta TO cpass_rw;


--
-- TOC entry 5753 (class 0 OID 0)
-- Dependencies: 440
-- Name: SEQUENCE cpass_r_settore_aoo_acta_settore_aoo_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_settore_aoo_acta_settore_aoo_id_seq TO cpass_rw;



--
-- TOC entry 5757 (class 0 OID 0)
-- Dependencies: 435
-- Name: TABLE cpass_r_ufficio_serie; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_r_ufficio_serie TO cpass_rw;


--
-- TOC entry 5759 (class 0 OID 0)
-- Dependencies: 434
-- Name: SEQUENCE cpass_r_ufficio_serie_ufficio_serie_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_ufficio_serie_ufficio_serie_id_seq TO cpass_rw;


--
-- TOC entry 5760 (class 0 OID 0)
-- Dependencies: 301
-- Name: TABLE cpass_r_ufficio_settore; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_r_ufficio_settore TO cpass_rw;


--
-- TOC entry 5762 (class 0 OID 0)
-- Dependencies: 302
-- Name: SEQUENCE cpass_r_ufficio_settore_ufficio_settore_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_ufficio_settore_ufficio_settore_id_seq TO cpass_rw;


--
-- TOC entry 5763 (class 0 OID 0)
-- Dependencies: 303
-- Name: TABLE cpass_r_utente_rup_settore; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_r_utente_rup_settore TO cpass_rw;


--
-- TOC entry 5765 (class 0 OID 0)
-- Dependencies: 304
-- Name: SEQUENCE cpass_r_utente_rup_settore_utente_rup_settore_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_utente_rup_settore_utente_rup_settore_id_seq TO cpass_rw;


--
-- TOC entry 5766 (class 0 OID 0)
-- Dependencies: 305
-- Name: TABLE cpass_r_utente_settore; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_r_utente_settore TO cpass_rw;


--
-- TOC entry 5768 (class 0 OID 0)
-- Dependencies: 306
-- Name: SEQUENCE cpass_r_utente_settore_utente_settore_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_r_utente_settore_utente_settore_id_seq TO cpass_rw;


--
-- TOC entry 5769 (class 0 OID 0)
-- Dependencies: 307
-- Name: TABLE cpass_t_aggiornamento_struttura; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_aggiornamento_struttura TO cpass_rw;


--
-- TOC entry 5771 (class 0 OID 0)
-- Dependencies: 308
-- Name: SEQUENCE cpass_t_aggiornamento_struttura_aggiornamento_struttura_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_aggiornamento_struttura_aggiornamento_struttura_id_seq TO cpass_rw;


--
-- TOC entry 5772 (class 0 OID 0)
-- Dependencies: 465
-- Name: TABLE cpass_t_cdc; Type: ACL; Schema: cpass; Owner: cpass
--

--
-- TOC entry 5775 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE cpass_t_comunicazione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_comunicazione TO cpass_rw;


--
-- TOC entry 5777 (class 0 OID 0)
-- Dependencies: 310
-- Name: SEQUENCE cpass_t_comunicazione_comunicazione_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_comunicazione_comunicazione_id_seq TO cpass_rw;


--
-- TOC entry 5778 (class 0 OID 0)
-- Dependencies: 311
-- Name: TABLE cpass_t_elaborazione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_elaborazione TO cpass_rw;


--
-- TOC entry 5780 (class 0 OID 0)
-- Dependencies: 312
-- Name: SEQUENCE cpass_t_elaborazione_elaborazione_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_elaborazione_elaborazione_id_seq TO cpass_rw;


--
-- TOC entry 5781 (class 0 OID 0)
-- Dependencies: 313
-- Name: TABLE cpass_t_elaborazione_messaggio; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_elaborazione_messaggio TO cpass_rw;


--
-- TOC entry 5783 (class 0 OID 0)
-- Dependencies: 314
-- Name: SEQUENCE cpass_t_elaborazione_messaggio_elaborazione_messaggio_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_elaborazione_messaggio_elaborazione_messaggio_id_seq TO cpass_rw;


--
-- TOC entry 5784 (class 0 OID 0)
-- Dependencies: 315
-- Name: TABLE cpass_t_elaborazione_parametro; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_elaborazione_parametro TO cpass_rw;


--
-- TOC entry 5786 (class 0 OID 0)
-- Dependencies: 316
-- Name: SEQUENCE cpass_t_elaborazione_parametro_elaborazione_parametro_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_elaborazione_parametro_elaborazione_parametro_id_seq TO cpass_rw;


--
-- TOC entry 5788 (class 0 OID 0)
-- Dependencies: 317
-- Name: TABLE cpass_t_ente; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_ente TO cpass_rw;

--
-- TOC entry 5790 (class 0 OID 0)
-- Dependencies: 319
-- Name: TABLE cpass_t_flusso_anomalie; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_flusso_anomalie TO cpass_rw;


--
-- TOC entry 5792 (class 0 OID 0)
-- Dependencies: 320
-- Name: SEQUENCE cpass_t_flusso_anomalie_flusso_anomalie_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_flusso_anomalie_flusso_anomalie_id_seq TO cpass_rw;


--
-- TOC entry 5793 (class 0 OID 0)
-- Dependencies: 321
-- Name: TABLE cpass_t_flusso_impegni_esterni; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_flusso_impegni_esterni TO cpass_rw;


--
-- TOC entry 5795 (class 0 OID 0)
-- Dependencies: 322
-- Name: SEQUENCE cpass_t_flusso_impegni_esterni_flusso_impegni_esterni_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_flusso_impegni_esterni_flusso_impegni_esterni_id_seq TO cpass_rw;


--
-- TOC entry 5796 (class 0 OID 0)
-- Dependencies: 323
-- Name: TABLE cpass_t_flusso_subimpegni_esterni; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_flusso_subimpegni_esterni TO cpass_rw;


--
-- TOC entry 5798 (class 0 OID 0)
-- Dependencies: 324
-- Name: SEQUENCE cpass_t_flusso_subimpegni_este_flusso_subimpegni_esterni_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_flusso_subimpegni_este_flusso_subimpegni_esterni_id_seq TO cpass_rw;


--
-- TOC entry 5799 (class 0 OID 0)
-- Dependencies: 325
-- Name: TABLE cpass_t_fornitore; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_fornitore TO cpass_rw;


--
-- TOC entry 5800 (class 0 OID 0)
-- Dependencies: 326
-- Name: TABLE cpass_t_fruitore; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_fruitore TO cpass_rw;


--
-- TOC entry 5802 (class 0 OID 0)
-- Dependencies: 327
-- Name: SEQUENCE cpass_t_fruitore_fruitore_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_fruitore_fruitore_id_seq TO cpass_rw;


--
-- TOC entry 5803 (class 0 OID 0)
-- Dependencies: 446
-- Name: TABLE cpass_t_gestione_campo; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_gestione_campo TO cpass_rw;


--
-- TOC entry 5805 (class 0 OID 0)
-- Dependencies: 445
-- Name: SEQUENCE cpass_t_gestione_campo_gestione_campo_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_gestione_campo_gestione_campo_id_seq TO cpass_rw;


--
-- TOC entry 5807 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE cpass_t_impegno; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_impegno TO cpass_rw;


--
-- TOC entry 5808 (class 0 OID 0)
-- Dependencies: 329
-- Name: TABLE cpass_t_listino_fornitore; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_listino_fornitore TO cpass_rw;


--
-- TOC entry 5810 (class 0 OID 0)
-- Dependencies: 330
-- Name: SEQUENCE cpass_t_listino_fornitore_listino_fornitore_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_listino_fornitore_listino_fornitore_id_seq TO cpass_rw;


--
-- TOC entry 5811 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE cpass_t_mag_magazzino; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_mag_magazzino TO cpass_rw;


--
-- TOC entry 5813 (class 0 OID 0)
-- Dependencies: 332
-- Name: SEQUENCE cpass_t_mag_magazzino_magazzino_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_mag_magazzino_magazzino_id_seq TO cpass_rw;


--
-- TOC entry 5814 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE cpass_t_metadati_funzione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_metadati_funzione TO cpass_rw;


--
-- TOC entry 5816 (class 0 OID 0)
-- Dependencies: 334
-- Name: SEQUENCE cpass_t_metadati_funzione_metadati_funzione_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_metadati_funzione_metadati_funzione_id_seq TO cpass_rw;


--
-- TOC entry 5817 (class 0 OID 0)
-- Dependencies: 335
-- Name: TABLE cpass_t_notifica; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_notifica TO cpass_rw;


--
-- TOC entry 5819 (class 0 OID 0)
-- Dependencies: 336
-- Name: SEQUENCE cpass_t_notifica_notifica_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_notifica_notifica_id_seq TO cpass_rw;


--
-- TOC entry 5821 (class 0 OID 0)
-- Dependencies: 337
-- Name: TABLE cpass_t_ord_destinatario_evasione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_destinatario_evasione TO cpass_rw;


--
-- TOC entry 5822 (class 0 OID 0)
-- Dependencies: 338
-- Name: TABLE cpass_t_ord_destinatario_invio_nso_xml; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_destinatario_invio_nso_xml TO cpass_rw;


--
-- TOC entry 5824 (class 0 OID 0)
-- Dependencies: 339
-- Name: SEQUENCE cpass_t_ord_destinatario_invi_destinatario_invio_nso_xml_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_ord_destinatario_invi_destinatario_invio_nso_xml_id_seq TO cpass_rw;


--
-- TOC entry 5825 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE cpass_t_ord_destinatario_invio_nso; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_destinatario_invio_nso TO cpass_rw;


--
-- TOC entry 5827 (class 0 OID 0)
-- Dependencies: 341
-- Name: SEQUENCE cpass_t_ord_destinatario_invio_ns_destinatario_invio_nso_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_ord_destinatario_invio_ns_destinatario_invio_nso_id_seq TO cpass_rw;


--
-- TOC entry 5829 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE cpass_t_ord_destinatario_ordine; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_ord_destinatario_ordine TO cpass_rw;


--
-- TOC entry 5830 (class 0 OID 0)
-- Dependencies: 439
-- Name: TABLE cpass_t_ord_documenti_ordine; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_documenti_ordine TO cpass_rw;


--
-- TOC entry 5832 (class 0 OID 0)
-- Dependencies: 438
-- Name: SEQUENCE cpass_t_ord_documenti_ordine_documenti_ordine_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_ord_documenti_ordine_documenti_ordine_id_seq TO cpass_rw;


--
-- TOC entry 5834 (class 0 OID 0)
-- Dependencies: 343
-- Name: TABLE cpass_t_ord_documento_trasporto; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_documento_trasporto TO cpass_rw;


--
-- TOC entry 5835 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE cpass_t_ord_documento_trasporto_xml; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_documento_trasporto_xml TO cpass_rw;


--
-- TOC entry 5837 (class 0 OID 0)
-- Dependencies: 345
-- Name: SEQUENCE cpass_t_ord_documento_trasporto__documento_trasporto_xml_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_ord_documento_trasporto__documento_trasporto_xml_id_seq TO cpass_rw;


--
-- TOC entry 5839 (class 0 OID 0)
-- Dependencies: 346
-- Name: SEQUENCE cpass_t_ord_documento_trasporto_documento_trasporto_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_ord_documento_trasporto_documento_trasporto_id_seq TO cpass_rw;


--
-- TOC entry 5841 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE cpass_t_ord_documento_trasporto_riga; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_documento_trasporto_riga TO cpass_rw;


--
-- TOC entry 5843 (class 0 OID 0)
-- Dependencies: 348
-- Name: SEQUENCE cpass_t_ord_documento_trasporto_documento_trasporto_riga_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_ord_documento_trasporto_documento_trasporto_riga_id_seq TO cpass_rw;


--
-- TOC entry 5845 (class 0 OID 0)
-- Dependencies: 349
-- Name: TABLE cpass_t_ord_impegno_associato; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_ord_impegno_associato TO cpass_rw;


--
-- TOC entry 5847 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE cpass_t_ord_impegno_evasione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_impegno_evasione TO cpass_rw;


--
-- TOC entry 5849 (class 0 OID 0)
-- Dependencies: 351
-- Name: TABLE cpass_t_ord_impegno_ordine; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_ord_impegno_ordine TO cpass_rw;


--
-- TOC entry 5850 (class 0 OID 0)
-- Dependencies: 437
-- Name: TABLE cpass_t_ord_protocollo_ordine; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_protocollo_ordine TO cpass_rw;


--
-- TOC entry 5852 (class 0 OID 0)
-- Dependencies: 436
-- Name: SEQUENCE cpass_t_ord_protocollo_ordine_protocollo_ordine_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_ord_protocollo_ordine_protocollo_ordine_id_seq TO cpass_rw;


--
-- TOC entry 5854 (class 0 OID 0)
-- Dependencies: 352
-- Name: TABLE cpass_t_ord_riga_evasione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_riga_evasione TO cpass_rw;


--
-- TOC entry 5855 (class 0 OID 0)
-- Dependencies: 353
-- Name: TABLE cpass_t_ord_riga_ordine; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_ord_riga_ordine TO cpass_rw;


--
-- TOC entry 5856 (class 0 OID 0)
-- Dependencies: 451
-- Name: TABLE cpass_t_ord_riga_rda; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_riga_rda TO cpass_rw;


--
-- TOC entry 5857 (class 0 OID 0)
-- Dependencies: 354
-- Name: TABLE cpass_t_ord_sezione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_sezione TO cpass_rw;


--
-- TOC entry 5859 (class 0 OID 0)
-- Dependencies: 355
-- Name: SEQUENCE cpass_t_ord_sezione_sezione_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_ord_sezione_sezione_id_seq TO cpass_rw;


--
-- TOC entry 5861 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE cpass_t_ord_subimpegno_associato; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_ord_subimpegno_associato TO cpass_rw;


--
-- TOC entry 5862 (class 0 OID 0)
-- Dependencies: 357
-- Name: TABLE cpass_t_ord_subimpegno_evasione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_subimpegno_evasione TO cpass_rw;


--
-- TOC entry 5864 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE cpass_t_ord_subimpegno_ordine; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_ord_subimpegno_ordine TO cpass_rw;


--
-- TOC entry 5866 (class 0 OID 0)
-- Dependencies: 359
-- Name: TABLE cpass_t_ord_testata_evasione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_testata_evasione TO cpass_rw;


--
-- TOC entry 5868 (class 0 OID 0)
-- Dependencies: 360
-- Name: TABLE cpass_t_ord_testata_ordine; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_ord_testata_ordine TO cpass_rw;


--
-- TOC entry 5869 (class 0 OID 0)
-- Dependencies: 450
-- Name: TABLE cpass_t_ord_testata_rda; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_ord_testata_rda TO cpass_rw;


--
-- TOC entry 5870 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE cpass_t_parametro; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_parametro TO cpass_rw;


--
-- TOC entry 5872 (class 0 OID 0)
-- Dependencies: 362
-- Name: SEQUENCE cpass_t_parametro_parametro_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_parametro_parametro_id_seq TO cpass_rw;


--
-- TOC entry 5873 (class 0 OID 0)
-- Dependencies: 363
-- Name: TABLE cpass_t_parametro_stampa; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_parametro_stampa TO cpass_rw;


--
-- TOC entry 5875 (class 0 OID 0)
-- Dependencies: 364
-- Name: SEQUENCE cpass_t_parametro_stampa_stampa_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_parametro_stampa_stampa_id_seq TO cpass_rw;


--
-- TOC entry 5877 (class 0 OID 0)
-- Dependencies: 365
-- Name: TABLE cpass_t_pba_intervento; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_pba_intervento TO cpass_rw;


--
-- TOC entry 5878 (class 0 OID 0)
-- Dependencies: 366
-- Name: TABLE cpass_t_pba_intervento_altri_dati; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_pba_intervento_altri_dati TO cpass_rw;


--
-- TOC entry 5879 (class 0 OID 0)
-- Dependencies: 430
-- Name: TABLE cpass_t_pba_intervento_cig; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_pba_intervento_cig TO cpass_rw;


--
-- TOC entry 5881 (class 0 OID 0)
-- Dependencies: 429
-- Name: SEQUENCE cpass_t_pba_intervento_cig_intervento_cig_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_pba_intervento_cig_intervento_cig_id_seq TO cpass_rw;


--
-- TOC entry 5883 (class 0 OID 0)
-- Dependencies: 367
-- Name: TABLE cpass_t_pba_intervento_importi; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_pba_intervento_importi TO cpass_rw;


--
-- TOC entry 5885 (class 0 OID 0)
-- Dependencies: 368
-- Name: TABLE cpass_t_pba_programma; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_pba_programma TO cpass_rw;


--
-- TOC entry 5886 (class 0 OID 0)
-- Dependencies: 369
-- Name: TABLE cpass_t_progressivo; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_progressivo TO cpass_rw;


--
-- TOC entry 5887 (class 0 OID 0)
-- Dependencies: 370
-- Name: TABLE cpass_t_provvedimento; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_provvedimento TO cpass_rw;


--
-- TOC entry 5889 (class 0 OID 0)
-- Dependencies: 371
-- Name: SEQUENCE cpass_t_provvedimento_provvedimento_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_provvedimento_provvedimento_id_seq TO cpass_rw;


--
-- TOC entry 5890 (class 0 OID 0)
-- Dependencies: 372
-- Name: TABLE cpass_t_regole_smistamento_rms; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_regole_smistamento_rms TO cpass_rw;


--
-- TOC entry 5892 (class 0 OID 0)
-- Dependencies: 373
-- Name: SEQUENCE cpass_t_regole_smistamento_rms_regole_smistamento_rms_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_regole_smistamento_rms_regole_smistamento_rms_id_seq TO cpass_rw;


--
-- TOC entry 5893 (class 0 OID 0)
-- Dependencies: 374
-- Name: TABLE cpass_t_rms_riga_rms; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_rms_riga_rms TO cpass_rw;


--
-- TOC entry 5894 (class 0 OID 0)
-- Dependencies: 375
-- Name: TABLE cpass_t_rms_testata_rms; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_rms_testata_rms TO cpass_rw;


--
-- TOC entry 5895 (class 0 OID 0)
-- Dependencies: 376
-- Name: TABLE cpass_t_scarico_mepa_riga; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_scarico_mepa_riga TO cpass_rw;


--
-- TOC entry 5897 (class 0 OID 0)
-- Dependencies: 377
-- Name: SEQUENCE cpass_t_scarico_mepa_riga_scarico_mepa_riga_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_scarico_mepa_riga_scarico_mepa_riga_id_seq TO cpass_rw;


--
-- TOC entry 5898 (class 0 OID 0)
-- Dependencies: 378
-- Name: TABLE cpass_t_scarico_mepa_sconti; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_scarico_mepa_sconti TO cpass_rw;


--
-- TOC entry 5900 (class 0 OID 0)
-- Dependencies: 379
-- Name: SEQUENCE cpass_t_scarico_mepa_sconti_scarico_mepa_sconti_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_scarico_mepa_sconti_scarico_mepa_sconti_id_seq TO cpass_rw;


--
-- TOC entry 5901 (class 0 OID 0)
-- Dependencies: 380
-- Name: TABLE cpass_t_scarico_mepa_testata; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_scarico_mepa_testata TO cpass_rw;


--
-- TOC entry 5903 (class 0 OID 0)
-- Dependencies: 381
-- Name: SEQUENCE cpass_t_scarico_mepa_testata_scarico_mepa_testata_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_scarico_mepa_testata_scarico_mepa_testata_id_seq TO cpass_rw;


--
-- TOC entry 5904 (class 0 OID 0)
-- Dependencies: 382
-- Name: TABLE cpass_t_scarico_mepa_xml; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_scarico_mepa_xml TO cpass_rw;


--
-- TOC entry 5906 (class 0 OID 0)
-- Dependencies: 383
-- Name: SEQUENCE cpass_t_scarico_mepa_xml_scarico_mepa_xml_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_scarico_mepa_xml_scarico_mepa_xml_id_seq TO cpass_rw;


--
-- TOC entry 5907 (class 0 OID 0)
-- Dependencies: 384
-- Name: TABLE cpass_t_schedulazione_batch; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_schedulazione_batch TO cpass_rw;


--
-- TOC entry 5909 (class 0 OID 0)
-- Dependencies: 385
-- Name: SEQUENCE cpass_t_schedulazione_batch_schedulazione_batch_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_schedulazione_batch_schedulazione_batch_id_seq TO cpass_rw;


--
-- TOC entry 5910 (class 0 OID 0)
-- Dependencies: 386
-- Name: TABLE cpass_t_servizio; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_servizio TO cpass_rw;


--
-- TOC entry 5912 (class 0 OID 0)
-- Dependencies: 387
-- Name: SEQUENCE cpass_t_servizio_servizio_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_servizio_servizio_id_seq TO cpass_rw;


--
-- TOC entry 5914 (class 0 OID 0)
-- Dependencies: 388
-- Name: TABLE cpass_t_settore; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_settore TO cpass_rw;


--
-- TOC entry 5915 (class 0 OID 0)
-- Dependencies: 389
-- Name: TABLE cpass_t_settore_indirizzo; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_settore_indirizzo TO cpass_rw;


--
-- TOC entry 5917 (class 0 OID 0)
-- Dependencies: 390
-- Name: SEQUENCE cpass_t_settore_indirizzo_settore_indirizzo_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_settore_indirizzo_settore_indirizzo_id_seq TO cpass_rw;


--
-- TOC entry 5918 (class 0 OID 0)
-- Dependencies: 391
-- Name: TABLE cpass_t_settore_storico; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_settore_storico TO cpass_rw;


--
-- TOC entry 5920 (class 0 OID 0)
-- Dependencies: 392
-- Name: SEQUENCE cpass_t_settore_storico_settore_storico_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_settore_storico_settore_storico_id_seq TO cpass_rw;


--
-- TOC entry 5922 (class 0 OID 0)
-- Dependencies: 393
-- Name: TABLE cpass_t_subimpegno; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_subimpegno TO cpass_rw;


--
-- TOC entry 5923 (class 0 OID 0)
-- Dependencies: 394
-- Name: TABLE cpass_t_testi_notifiche; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_testi_notifiche TO cpass_rw;


--
-- TOC entry 5925 (class 0 OID 0)
-- Dependencies: 395
-- Name: SEQUENCE cpass_t_testi_notifiche_testo_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_testi_notifiche_testo_id_seq TO cpass_rw;


--
-- TOC entry 5926 (class 0 OID 0)
-- Dependencies: 396
-- Name: TABLE cpass_t_ufficio; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_ufficio TO cpass_rw;


--
-- TOC entry 5928 (class 0 OID 0)
-- Dependencies: 397
-- Name: SEQUENCE cpass_t_ufficio_ufficio_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_ufficio_ufficio_id_seq TO cpass_rw;


--
-- TOC entry 5930 (class 0 OID 0)
-- Dependencies: 398
-- Name: TABLE cpass_t_utente; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_utente TO cpass_rw;


--
-- TOC entry 5931 (class 0 OID 0)
-- Dependencies: 399
-- Name: TABLE cpass_t_utente_rup_deleghe; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_t_utente_rup_deleghe TO cpass_rw;


--
-- TOC entry 5933 (class 0 OID 0)
-- Dependencies: 400
-- Name: SEQUENCE cpass_t_utente_rup_deleghe_utente_rup_deleghe_id_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.cpass_t_utente_rup_deleghe_utente_rup_deleghe_id_seq TO cpass_rw;


--
-- TOC entry 5935 (class 0 OID 0)
-- Dependencies: 401
-- Name: TABLE cpass_t_uuid_namespace; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_t_uuid_namespace TO cpass_rw;


--
-- TOC entry 5936 (class 0 OID 0)
-- Dependencies: 402
-- Name: TABLE cpass_v_cpv; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_v_cpv TO cpass_rw;


--
-- TOC entry 5937 (class 0 OID 0)
-- Dependencies: 403
-- Name: TABLE cpass_v_cpv_ods; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON TABLE cpass.cpass_v_cpv_ods TO cpass_rw;


--
-- TOC entry 5938 (class 0 OID 0)
-- Dependencies: 404
-- Name: TABLE cpass_v_dba_activity; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_dba_activity TO cpass_rw;


--
-- TOC entry 5939 (class 0 OID 0)
-- Dependencies: 405
-- Name: TABLE cpass_v_dba_all_functions; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_dba_all_functions TO cpass_rw;


--
-- TOC entry 5940 (class 0 OID 0)
-- Dependencies: 406
-- Name: TABLE cpass_v_dba_fk_all; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_dba_fk_all TO cpass_rw;


--
-- TOC entry 5941 (class 0 OID 0)
-- Dependencies: 407
-- Name: TABLE cpass_v_dba_kill_pid; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_dba_kill_pid TO cpass_rw;


--
-- TOC entry 5942 (class 0 OID 0)
-- Dependencies: 408
-- Name: TABLE cpass_v_dba_locks_waiting; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_dba_locks_waiting TO cpass_rw;


--
-- TOC entry 5943 (class 0 OID 0)
-- Dependencies: 409
-- Name: TABLE cpass_v_dba_queries_in_esecuzione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_dba_queries_in_esecuzione TO cpass_rw;


--
-- TOC entry 5944 (class 0 OID 0)
-- Dependencies: 410
-- Name: TABLE cpass_v_dba_queries_lente; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_dba_queries_lente TO cpass_rw;


--
-- TOC entry 5945 (class 0 OID 0)
-- Dependencies: 411
-- Name: TABLE cpass_v_dba_query_lenta_singola_esec; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_dba_query_lenta_singola_esec TO cpass_rw;


--
-- TOC entry 5946 (class 0 OID 0)
-- Dependencies: 412
-- Name: TABLE cpass_v_dba_stat_all_tables; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_dba_stat_all_tables TO cpass_rw;


--
-- TOC entry 5947 (class 0 OID 0)
-- Dependencies: 413
-- Name: TABLE cpass_v_dba_tables_rows_count_estimated; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_dba_tables_rows_count_estimated TO cpass_rw;


--
-- TOC entry 5948 (class 0 OID 0)
-- Dependencies: 414
-- Name: TABLE cpass_v_dba_tables_size_det; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_dba_tables_size_det TO cpass_rw;


--
-- TOC entry 5949 (class 0 OID 0)
-- Dependencies: 415
-- Name: TABLE cpass_v_dba_tables_size; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_dba_tables_size TO cpass_rw;


--
-- TOC entry 5950 (class 0 OID 0)
-- Dependencies: 416
-- Name: TABLE cpass_v_evasione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_evasione TO cpass_rw;


--
-- TOC entry 5951 (class 0 OID 0)
-- Dependencies: 417
-- Name: TABLE cpass_v_ordine; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_ordine TO cpass_rw;


--
-- TOC entry 5952 (class 0 OID 0)
-- Dependencies: 418
-- Name: TABLE cpass_v_ordine_evasione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_ordine_evasione TO cpass_rw;


-- TOC entry 5954 (class 0 OID 0)
-- Dependencies: 420
-- Name: TABLE cpass_v_riepilogo_fattura_evasione; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_riepilogo_fattura_evasione TO cpass_rw;


--
-- TOC entry 5955 (class 0 OID 0)
-- Dependencies: 421
-- Name: TABLE cpass_v_rms_da_smistare; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_rms_da_smistare TO cpass_rw;


--
-- TOC entry 5956 (class 0 OID 0)
-- Dependencies: 422
-- Name: TABLE cpass_v_settore; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_settore TO cpass_rw;


--
-- TOC entry 5957 (class 0 OID 0)
-- Dependencies: 431
-- Name: TABLE cpass_v_ultimo_programma_biennio; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_ultimo_programma_biennio TO cpass_rw;


--
-- TOC entry 5958 (class 0 OID 0)
-- Dependencies: 423
-- Name: TABLE cpass_v_utente; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.cpass_v_utente TO cpass_rw;


--
-- TOC entry 5959 (class 0 OID 0)
-- Dependencies: 428
-- Name: TABLE csi_log_audit; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cpass.csi_log_audit TO cpass_rw;


--
-- TOC entry 5961 (class 0 OID 0)
-- Dependencies: 427
-- Name: SEQUENCE csi_log_audit_id_audit_seq; Type: ACL; Schema: cpass; Owner: cpass
--

GRANT ALL ON SEQUENCE cpass.csi_log_audit_id_audit_seq TO cpass_rw;



ALTER DEFAULT PRIVILEGES FOR ROLE cpass IN SCHEMA cpass REVOKE ALL ON TABLES  FROM cpass;
ALTER DEFAULT PRIVILEGES FOR ROLE cpass IN SCHEMA cpass GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES  TO cpass_rw;
