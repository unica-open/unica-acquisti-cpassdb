---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================


update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Cancellazione di acquisto già previsto nell''elenco annuale'
where acquisto_variato_codice is null;

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Aggiunta acquisto in conseguenza di atto amministrativo'
where acquisto_variato_codice = '1';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Aggiunta acquisto per sopravvenuta disponibilita'' di finanziamenti, comprese risorse disponibili anche a seguito di ribassi d''asta o economie'
where acquisto_variato_codice = '2';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Anticipazione prima annualita'' di acquisizione della fornitura o servizio'
where acquisto_variato_codice = '3';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Modifica quadro economico dell''acquisto previsto nell''elenco annuale in caso di nuove risorse'
where acquisto_variato_codice = '4';

update cpass_d_pba_acquisto_variato 
set acquisto_variato_descrizione_estesa = 'Acquisto reso necessario da eventi imprevedibili o calamitosi o da sopravvenute disposizioni di legge o regolamentari o non previsto nell''elenco annuale realizzabile con un autonomo piano finanziario'
where acquisto_variato_codice = '5';