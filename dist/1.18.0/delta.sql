---
-- ========================LICENSE_START=================================
-- CPASS DataBase
-- %%
-- Copyright (C) 2019 - 2025 CSI Piemonte
-- %%
-- SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
-- SPDX-License-Identifier: EUPL-1.2
-- =========================LICENSE_END==================================
ALTER TABLE cpass.cpass_t_settore_indirizzo ALTER COLUMN descrizione TYPE VARCHAR(500);
  
  alter table cpass_t_pba_intervento add column if not exists esente_iva varchar(5);

ALTER TABLE cpass_t_pba_intervento DROP CONSTRAINT esente_iva_check;

ALTER TABLE cpass_t_pba_intervento ADD CONSTRAINT esente_iva_check 
CHECK (esente_iva = 'true' 
      OR esente_iva = 'false'
);

ALTER TABLE CPASS_D_PBA_ACQUISTO_VARIATO 
ADD COLUMN IF NOT EXISTS controlli varchar(50);

INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo, disattivabile, attivo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo, tmp.disattivabile, tmp.attivo
FROM (VALUES
	('SVINCOLA_CAMPI_EDIT','Permette la modifica di campi altrimenti non modificabili','INTERVENTI',false,'F', 'SI', true),
	('SVINCOLA_CAMPI_EDIT_DESCRIZIONE','Permette la modifica del campo descrizione intervento altrimenti non modificabile','INTERVENTI',false,'F', 'SI', true),
	('SVINCOLA_CAMPI_EDIT_CPV','Permette la modifica del campo cpv intervento altrimenti non modificabile','INTERVENTI',false,'F', 'SI', true)
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo, disattivabile, attivo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );

    
update cpass_d_pba_mod_affidamento 
set mod_affidamento_descrizione = 'SI' 
where mod_affidamento_descrizione = 'DELEGATO';


update cpass_d_pba_mod_affidamento 
set mod_affidamento_descrizione = 'NO' 
where mod_affidamento_descrizione = 'NON DELEGATO';
update cpass_d_pba_acquisto_variato
set controlli = 'INSERT'
where acquisto_variato_codice in ('1','2','5');

update cpass_d_pba_acquisto_variato
set controlli = 'ANNO'
where acquisto_variato_codice in ('3');

update cpass_d_pba_acquisto_variato
set controlli = 'IMPORTI'
where acquisto_variato_codice in ('4');

insert into cpass_d_pba_acquisto_variato (acquisto_variato_codice, acquisto_variato_descrizione,acquisti_non_riproposti, controlli)
values ('','CORREZIONE',false,'CORREZIONE');

update cpass_d_pba_acquisto_variato
set controlli = 'CONTROLLI'
where acquisto_variato_descrizione ='MODIFICA IMPORTI';

update cpass_d_pba_acquisto_variato
set controlli = 'CORREZIONE'
where acquisto_variato_descrizione ='CORREZIONE';

INSERT INTO cpass.cpass_d_pba_acquisto_variato (acquisto_variato_codice, acquisto_variato_descrizione, acquisto_variato_descrizione_estesa,controlli)
SELECT tmp.acquisto_variato_codice, tmp.acquisto_variato_descrizione, tmp.acquisto_variato_descrizione_estesa,tmp.controlli
FROM (VALUES
  ('','Correzione','Correzione','CORREZIONE')
) AS tmp(acquisto_variato_codice, acquisto_variato_descrizione, acquisto_variato_descrizione_estesa,controlli)
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_d_pba_acquisto_variato current
  WHERE current.acquisto_variato_codice = tmp.acquisto_variato_codice
  and current.acquisto_variato_descrizione = tmp.acquisto_variato_descrizione
);

INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo, disattivabile, attivo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo, tmp.disattivabile, tmp.attivo
FROM (VALUES
	('CANCELLA_CUI','Permette la cancellazione di un intervento','BO',false,'V', 'SI', true)
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo, disattivabile, attivo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );

    INSERT INTO cpass.cpass_d_permesso (permesso_codice, permesso_descrizione, permesso_titolo_box,permesso_voce_menu,permesso_tipo, disattivabile, attivo)
SELECT tmp.codice, tmp.descrizione, tmp.titolo_box,tmp.voce_menu,tmp.tipo, tmp.disattivabile, tmp.attivo
FROM (VALUES
	('CANCELLA_CUI','Permette la cancellazione di un intervento','BO',false,'V', 'SI', true)
) AS tmp(codice, descrizione, titolo_box, voce_menu, tipo, disattivabile, attivo)
WHERE NOT EXISTS (
	SELECT 1
	FROM cpass.cpass_d_permesso ds
	WHERE ds.permesso_codice = tmp.codice
    );
    
INSERT INTO cpass.cpass_r_ruolo_permesso (ruolo_id, permesso_id)
SELECT dr.ruolo_id, dp.permesso_id
FROM (VALUES
  ('ADMIN', 'CANCELLA_CUI') 
) AS tmp(ruolo, permesso)
JOIN cpass.cpass_d_ruolo dr ON dr.ruolo_codice = tmp.ruolo
JOIN cpass.cpass_d_permesso dp ON dp.permesso_codice = tmp.permesso
WHERE NOT EXISTS (
  SELECT 1
  FROM cpass.cpass_r_ruolo_permesso rrp
  WHERE rrp.ruolo_id = dr.ruolo_id
  AND rrp.permesso_id = dp.permesso_id
);
