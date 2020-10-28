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
INSERT INTO cpass_t_parametro_stampa (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
SELECT tmp.modulo, tmp.nome_stampa, tmp.file_name_template, tmp.parametro, tmp.parametro_tipo, tmp.ordinamento, tmp.procedure_utilizzate, tmp.note, tmp.formato_stampa
FROM (VALUES
      ('PBA', 'ALLEGATO_II',                 'Allegato_II.rptdesign',            'Programma_id', 'UUID', 1, 'pck_cpass_pba_rep_allegato_scheda_b',    NULL, 'pdf')
    , ('PBA', 'REPORT_SOGGETTI_AGGREGATORI', 'SoggettiAggregatori.rptdesign',    'Programma_id', 'UUID', 1, 'pck_cpass_pba_rep_soggetti_aggregatori', NULL, 'xlsx')
    , ('PBA', 'STAMPA_INTERVENTI',           'Stampa_acquisti.rptdesign',        'Programma_id', 'UUID', 1, NULL,                                     NULL, 'xls')
    , ('ORD', 'PRT_T_ORD',                   'Stampa_Copia_Fornitore.rptdesign', 'p_ordine_id',  'UUID', 1, NULL,                                     NULL, 'pdf')
) AS tmp (modulo, nome_stampa, file_name_template, parametro, parametro_tipo, ordinamento, procedure_utilizzate, note, formato_stampa)
WHERE NOT EXISTS (
    SELECT 1
    FROM cpass_t_parametro_stampa tps
    WHERE tps.modulo = tmp.modulo
    AND tps.nome_stampa = tmp.nome_stampa
    AND tps.parametro = tmp.parametro
    AND tps.ordinamento = tmp.ordinamento
);
