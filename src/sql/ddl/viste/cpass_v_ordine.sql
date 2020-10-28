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
DROP VIEW if exists cpass.cpass_v_ordine;
CREATE VIEW cpass.cpass_v_ordine AS (
    select 
       row_number() OVER () AS ordine_id
       
    ,cpass_t_ord_testata_ordine.testata_ordine_id
    ,cpass_t_ord_testata_ordine.tipo_ordine_id
    ,cpass_t_ord_testata_ordine.ordine_anno
    ,cpass_t_ord_testata_ordine.ordine_numero
    ,cpass_t_ord_testata_ordine.fornitore_id
    ,cpass_t_ord_testata_ordine.tipo_procedura_id
    ,cpass_t_ord_testata_ordine.numero_procedura
    ,cpass_t_ord_testata_ordine.data_emissione
    ,cpass_t_ord_testata_ordine.data_conferma
    ,cpass_t_ord_testata_ordine.data_autorizzazione
    ,cpass_t_ord_testata_ordine.totale_no_iva
    ,cpass_t_ord_testata_ordine.totale_con_iva
    ,cpass_t_ord_testata_ordine.descrizione_acquisto
    ,cpass_t_ord_testata_ordine.consegna_riferimento
    ,cpass_t_ord_testata_ordine.consegna_data_da
    ,cpass_t_ord_testata_ordine.consegna_data_a
    ,cpass_t_ord_testata_ordine.consegna_indirizzo
    ,cpass_t_ord_testata_ordine.consegna_cap
    ,cpass_t_ord_testata_ordine.consegna_localita
    ,cpass_t_ord_testata_ordine.provvedimento_anno
    ,cpass_t_ord_testata_ordine.provvedimento_numero
    ,cpass_t_ord_testata_ordine.lotto_anno
    ,cpass_t_ord_testata_ordine.lotto_numero
    ,cpass_t_ord_testata_ordine.stato_invio_nso  stato_invio_nso_testata
    ,cpass_t_ord_testata_ordine.utente_compilatore_id
    ,cpass_t_ord_testata_ordine.settore_emittente_id
    ,cpass_t_ord_testata_ordine.ufficio_id
    ,cpass_t_ord_testata_ordine.stato_id
    ,cpass_t_ord_testata_ordine.note
    ,cpass_t_ord_testata_ordine.data_cancellazione data_cancellazione_testata
         
    ,cpass_t_ord_destinatario.destinatario_id
    ,cpass_t_ord_destinatario.indirizzo
    ,cpass_t_ord_destinatario.num_civico
    ,cpass_t_ord_destinatario.localita
    ,cpass_t_ord_destinatario.provincia
    ,cpass_t_ord_destinatario.cap
    ,cpass_t_ord_destinatario.contatto
    ,cpass_t_ord_destinatario.email
    ,cpass_t_ord_destinatario.telefono
    ,cpass_t_ord_destinatario.data_invio_nso
    ,cpass_t_ord_destinatario.stato_invio_nso stato_invio_nso_destinatario
    ,cpass_t_ord_destinatario.settore_destinatario_id
    ,cpass_t_ord_destinatario.stato_el_ordine_id stato_el_ordine_id_destinatario
    ,cpass_t_ord_destinatario.progressivo progressivo_destinatario
    ,cpass_t_ord_destinatario.data_cancellazione data_cancellazione_destinatario

    ,cpass_t_ord_riga_ordine.riga_ordine_id
    ,cpass_t_ord_riga_ordine.consegna_parziale
    ,cpass_t_ord_riga_ordine.progressivo progressivo_riga
    ,cpass_t_ord_riga_ordine.prezzo_unitario
    ,cpass_t_ord_riga_ordine.quantita
    ,cpass_t_ord_riga_ordine.percentuale_sconto
    ,cpass_t_ord_riga_ordine.importo_sconto
    ,cpass_t_ord_riga_ordine.percentuale_sconto2
    ,cpass_t_ord_riga_ordine.importo_sconto2
    ,cpass_t_ord_riga_ordine.importo_netto
    ,cpass_t_ord_riga_ordine.importo_iva
    ,cpass_t_ord_riga_ordine.importo_totale
    ,cpass_t_ord_riga_ordine.note note_riga
    ,cpass_t_ord_riga_ordine.stato_el_ordine_id stato_el_ordine_id_riga
    ,cpass_t_ord_riga_ordine.oggetti_spesa_id
    ,cpass_t_ord_riga_ordine.unita_misura_id
    ,cpass_t_ord_riga_ordine.aliquote_iva_id
    ,cpass_t_ord_riga_ordine.data_cancellazione data_cancellazione_riga

    ,cpass_t_ord_impegno_ordine.impegno_ordine_id
    ,cpass_t_ord_impegno_ordine.impegno_id
    ,cpass_t_ord_impegno_ordine.impegno_progressivo
    ,cpass_t_ord_impegno_ordine.impegno_anno_esercizio
    ,cpass_t_ord_impegno_ordine.impegno_anno
    ,cpass_t_ord_impegno_ordine.impegno_numero
    ,cpass_t_ord_impegno_ordine.importo importo_impegno
    ,cpass_t_ord_impegno_ordine.data_cancellazione data_cancellazione_impegno

    ,cpass_t_impegno.numero_capitolo
    ,cpass_t_impegno.numero_articolo
   
    ,cpass_t_ord_subimpegno_ordine.subimpegno_ordine_id
    ,cpass_t_ord_subimpegno_ordine.subimpegno_id
    ,cpass_t_ord_subimpegno_ordine.subimpegno_anno
    ,cpass_t_ord_subimpegno_ordine.subimpegno_numero
    ,cpass_t_ord_subimpegno_ordine.subimpegno_importo
    ,cpass_t_ord_subimpegno_ordine.data_cancellazione data_cancellazione_subimpegno
    from 
             cpass.cpass_t_ord_testata_ordine 
        join cpass.cpass_t_ord_destinatario  on (cpass_t_ord_testata_ordine.testata_ordine_id=cpass_t_ord_destinatario.testata_ordine_id)
        left Outer join cpass.cpass_t_ord_riga_ordine  on (cpass_t_ord_destinatario.destinatario_id=cpass_t_ord_riga_ordine.destinatario_id)
        left Outer join cpass.cpass_t_ord_impegno_ordine  on (cpass_t_ord_riga_ordine.riga_ordine_id=cpass_t_ord_impegno_ordine.riga_ordine_id)
        left Outer join cpass.cpass_t_impegno  on (cpass_t_impegno.impegno_id=cpass_t_ord_impegno_ordine.impegno_id)
        left Outer join cpass.cpass_t_ord_subimpegno_ordine  on (cpass_t_ord_impegno_ordine.impegno_ordine_id=cpass_t_ord_subimpegno_ordine.impegno_ordine_id)    
  );
