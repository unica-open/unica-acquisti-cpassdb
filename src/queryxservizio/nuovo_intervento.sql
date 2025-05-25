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
select * from cpass_d_pba_ricompreso_tipo;
select * from cpass_d_pba_ausa;
select * from cpass_t_utente where utente_nome ='LIVIO';
select * from cpass_d_cpv where cpv_codice = '79420000-4';
select * from cpass_t_pba_programma;
select * from cpass_d_pba_nuts;
select * from cpass_d_pba_priorita;
select * from cpass_d_pba_mod_affidamento;
select * from cpass_d_pba_settore_interventi;
select * from cpass_d_stato;
select * from cpass_t_settore where settore_codice = 'A1502B';
select * from cpass_d_pba_risorsa;

--cpassTPbaProgramma.getId() + "|" + interventoCui
select * from uuid_generate_v5('acc51e9e-79d2-5482-899c-4747fca52403'::UUID, 'acc51e9e-79d2-5482-899c-4747fca52403|S80087670016162019000062' );


INSERT INTO cpass_t_pba_intervento
(
   intervento_id --UUID NOT NULL,
  ,intervento_cui --VARCHAR(50) NOT NULL,
  ,intervento_anno_avvio --INTEGER NOT NULL,
  ,intervento_cup --VARCHAR(15),
  ,ricompreso_tipo_id --INTEGER,
  ,intervento_lotto_funzionale --BOOLEAN DEFAULT false NOT NULL,
  ,intervento_durata_mesi --INTEGER NOT NULL,
  ,intervento_nuovo_affid --BOOLEAN DEFAULT false NOT NULL,
  ,ausa_id --INTEGER,
  ,acquisto_variato_id --INTEGER,
  ,utente_rup_id --UUID NOT NULL,
  ,intervento_descrizione_acquisto --VARCHAR(500) NOT NULL,
  ,settore_interventi_id --INTEGER NOT NULL,
  ,cpv_id --INTEGER NOT NULL,
  ,programma_id --UUID NOT NULL,
  ,nuts_id --INTEGER NOT NULL,
  ,priorita_id --INTEGER NOT NULL,
  ,mod_affidamento_id --INTEGER NOT NULL,
  ,stato_id --INTEGER NOT NULL,
  --,data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  ,utente_creazione --VARCHAR(250) NOT NULL,
  --,data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  ,utente_modifica --VARCHAR(250) NOT NULL,
  ,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
  ,utente_cancellazione --VARCHAR(250),
  --,optlock UUID DEFAULT uuid_generate_v4() NOT NULL,
  ,intervento_copia_id --UUID,
  ,flag_cui_non_generato --BOOLEAN DEFAULT false,
  ,motivazione_non_riproposto --VARCHAR(500),
  ,intervento_copia_tipo --VARCHAR(50),
  ,intervento_importi_copia_tipo --VARCHAR(50),
  ,settore_id --UUID NOT NULL,
  ,esente_cup --BOOLEAN DEFAULT false,
  ,data_visto --TIMESTAMP WITHOUT TIME ZONE,
  ,utente_visto_id --UUID,
  ,data_validazione --TIMESTAMP WITHOUT TIME ZONE,
  ,utente_validazione_id --UUID,
  ,data_rifiuto --TIMESTAMP WITHOUT TIME ZONE,
  ,utente_rifiuto_id --UUID,
  ,intervento_ricompreso_cui --VARCHAR(21),
)values(
  '24d12db3-29f2-51bb-96e8-d9b25560f400' 	--intervento_id UUID NOT NULL,
  ,'S80087670016162019000062'				--,intervento_cui
  ,2021                         			--,intervento_anno_avvio INTEGER NOT NULL,
  ,null                         			--,intervento_cup VARCHAR(15),
  ,1                            			--,ricompreso_tipo_id INTEGER,
  ,false                        			--,intervento_lotto_funzionale BOOLEAN DEFAULT false NOT NULL,
  ,36                           			--,intervento_durata_mesi INTEGER NOT NULL,
  ,false   	                    			--,intervento_nuovo_affid BOOLEAN DEFAULT false NOT NULL,
  ,null                         			--,ausa_id INTEGER,
  ,null                              		--,acquisto_variato_id INTEGER,
  ,'e83ed48d-6d3f-59c1-a701-bca419d49fd6'	--,utente_rup_id UUID NOT NULL,
  ,'Azioni di sistema e assistenza tecnica in materia di inserimento lavorativo di persone con disabilità ai sensi dell’art. 14 della L. 68/99'                                          --,intervento_descrizione_acquisto VARCHAR(500) NOT NULL,
  ,2                                        --,settore_interventi_id INTEGER NOT NULL,
  ,7972                                     --,cpv_id INTEGER NOT NULL,
  ,'acc51e9e-79d2-5482-899c-4747fca52403'   --,programma_id UUID NOT NULL,
  ,11                                       --,nuts_id INTEGER NOT NULL,
  ,2                                        --,priorita_id INTEGER NOT NULL,
  ,1                                        --,mod_affidamento_id INTEGER NOT NULL, ??
  ,5                                        --,stato_id INTEGER NOT NULL, ??
                                            --,data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  ,'admin'                                  --,utente_creazione VARCHAR(250) NOT NULL,
                                            --,data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  ,'admin'                                  --,utente_modifica VARCHAR(250) NOT NULL,
  ,null                                     --,data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  ,null                                     --,utente_cancellazione VARCHAR(250),
                                            --,optlock UUID DEFAULT uuid_generate_v4() NOT NULL,
  ,null                                     --,intervento_copia_id UUID,
  ,true                                     --,flag_cui_non_generato BOOLEAN DEFAULT false,
  ,null                                     --,motivazione_non_riproposto VARCHAR(500),
  ,null                                     --,intervento_copia_tipo VARCHAR(50),
  ,null                                     --,intervento_importi_copia_tipo VARCHAR(50),
  ,'09ce7d4a-1c97-52de-9893-8eb23821df3d'   --,settore_id UUID NOT NULL,
  ,false                                    --,esente_cup BOOLEAN DEFAULT false,
  ,null                                     --,data_visto TIMESTAMP WITHOUT TIME ZONE,
  ,null                                     --,utente_visto_id UUID,
  ,null                                     --,data_validazione TIMESTAMP WITHOUT TIME ZONE,
  ,null                                     --,utente_validazione_id UUID,
  ,null                                     --,data_rifiuto TIMESTAMP WITHOUT TIME ZONE,
  ,null                                     --,utente_rifiuto_id UUID,
  ,null                                     --,intervento_ricompreso_cui VARCHAR(21),
);

--select * from cpass_t_pba_intervento where intervento_id = '24d12db3-29f2-51bb-96e8-d9b25560f400'


------------------------------------IMPORTI




select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_1' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( '28aa9282-e5cd-5e88-bbdf-2fda15609849',0,0,0,1,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_2' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( '3d85d2d5-ba5b-58f6-a97a-e8c8a7e87507',0,0,0,2,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_3' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( '866582b3-da96-5508-bcf0-fc6f37eb3b95',0,0,0,3,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_4' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( '5f470e90-9920-5d71-84b2-c0f210a8aa00',0,0,0,4,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_5' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( '14fa73e3-3502-55bc-af3d-6d8f66768a5c',0,0,0,5,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_6' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( 'ad868d88-f7ee-5a12-bbfd-51a04db28910',0,0,0,6,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_7' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( 'fcfc02b4-5459-59e8-b350-f83106e9a4f0',0,0,0,7,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_8' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( '3b844522-a858-5ded-86a8-3be804da3e9a',0,0,0,8,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_9' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( 'a4bbbdd5-5ebb-5f5a-a5d5-a729a3b2b573',0,0,0,9,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_10' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( '5e115994-a0fe-5796-829f-5abf99a3f3b5',0,0,0,10,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_11' );
insert into cpass_t_pba_intervento_importi (
  intervento_importi_id --UUID NOT NULL,
  ,intervento_importi_importo_anno_primo --NUMERIC NOT NULL,
  ,intervento_importi_importo_anno_secondo --NUMERIC NOT NULL,
  ,intervento_importi_importo_anni_successivi --NUMERIC NOT NULL,
  ,risorsa_id --INTEGER NOT NULL,
  ,intervento_id --UUID NOT NULL,
  --,data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  ,utente_creazione --VARCHAR(250) NOT NULL,
  --,data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  ,utente_modifica --VARCHAR(250) NOT NULL,
  ,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
  ,utente_cancellazione --VARCHAR(250),
  --,optlock --UUID DEFAULT uuid_generate_v4() NOT NULL,
  --,richiesta_motivazione --BOOLEAN DEFAULT false NOT NULL,
  ,motivazione --VARCHAR(200),
)values (
  '73c764d4-dd8a-50f7-89ac-032876b222dc'--intervento_importi_id UUID NOT NULL,
  ,0--intervento_importi_importo_anno_primo NUMERIC NOT NULL,
  ,0--intervento_importi_importo_anno_secondo NUMERIC NOT NULL,
  ,903101.8 --intervento_importi_importo_anni_successivi NUMERIC NOT NULL,
  ,11--risorsa_id INTEGER NOT NULL,
  ,'24d12db3-29f2-51bb-96e8-d9b25560f400'--intervento_id UUID NOT NULL,
  --data_creazione TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  ,'admin'--utente_creazione VARCHAR(250) NOT NULL,
  --data_modifica TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  ,'admin'--utente_modifica VARCHAR(250) NOT NULL,
  ,null--data_cancellazione TIMESTAMP WITHOUT TIME ZONE,
  ,null--utente_cancellazione VARCHAR(250),
  --optlock UUID DEFAULT uuid_generate_v4() NOT NULL,
  --,null--richiesta_motivazione BOOLEAN DEFAULT false NOT NULL,
  ,null--motivazione VARCHAR(200),
);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_12' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( 'a1164d39-ece5-567d-a6c6-23322f094780',0,0,0,12,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_13' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( '9c62ef4e-f4ff-5a38-b3b0-291159a0ef28',0,0,0,13,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);

select * from uuid_generate_v5('24d12db3-29f2-51bb-96e8-d9b25560f400'::UUID, '24d12db3-29f2-51bb-96e8-d9b25560f400_14' );
insert into cpass_t_pba_intervento_importi (intervento_importi_id ,intervento_importi_importo_anno_primo ,intervento_importi_importo_anno_secondo,intervento_importi_importo_anni_successivi,risorsa_id,intervento_id,utente_creazione,utente_modifica,data_cancellazione,utente_cancellazione,motivazione 
)values ( '816c0263-fac4-5327-815d-0a3b48f25b51',0,0,0,14,'24d12db3-29f2-51bb-96e8-d9b25560f400','admin','admin',null,null,null);
