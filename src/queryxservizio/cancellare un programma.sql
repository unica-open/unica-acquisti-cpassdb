---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2021 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2021 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
---
-- per cancellare solo un programma con i suoi interventi

delete from cpass_r_pba_storico_intervento_rup
where intervento_id in 
(select intervento_id from cpass_t_pba_intervento
where programma_id = '533009bb-e6ae-51a3-b258-7b19912e1256');

delete from cpass_r_intervento_cpv
where intervento_id in 
(select intervento_id from cpass_t_pba_intervento
where programma_id = '533009bb-e6ae-51a3-b258-7b19912e1256');


delete from cpass_t_pba_intervento_importi
where intervento_id in 
(select intervento_id from cpass_t_pba_intervento
where programma_id = '533009bb-e6ae-51a3-b258-7b19912e1256');


delete from cpass_t_pba_intervento_altri_dati
where intervento_id in 
(select intervento_id from cpass_t_pba_intervento
where programma_id = '533009bb-e6ae-51a3-b258-7b19912e1256');


delete from cpass_t_pba_intervento
where programma_id = '533009bb-e6ae-51a3-b258-7b19912e1256'


delete from cpass_t_pba_programma
where programma_id = '533009bb-e6ae-51a3-b258-7b19912e1256';
