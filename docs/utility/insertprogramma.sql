 insert into cpass_t_pba_programma (
  programma_id --UUID NOT NULL
  ,programma_anno --INTEGER NOT NULL
  ,ente_id
  ,utente_creazione --VARCHAR(250) NOT NULL,
  ,utente_modifica --VARCHAR(250) NOT NULL,
  ,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
  ,utente_cancellazione --VARCHAR(250),
  ,stato_id --INTEGER NOT NULL,
  ,numero_provvedimento --VARCHAR(50),
  ,descrizione_provvedimento --VARCHAR(500),
  ,data_provvedimento --TIMESTAMP WITHOUT TIME ZONE,
  ,data_pubblicazione --TIMESTAMP WITHOUT TIME ZONE,
  ,url --VARCHAR(500),
  ,utente_referente_id --UUID NOT NULL,
  ,programma_descrizione --VARCHAR(200),
  ,programma_versione --INTEGER DEFAULT 1 NOT NULL,
  ,programma_codice_mit --VARCHAR(20) DEFAULT '00000000000000000000'::character varying NOT NULL,
  ,id_ricevuto_mit --BIGINT,
  ,data_approvazione --TIMESTAMP WITHOUT TIME ZONE,
  ,data_trasmissione_mit --TIMESTAMP WITHOUT TIME ZONE,
  ,anno_fine_programma --INTEGER DEFAULT 1900 NOT NULL,
)values(
  uuid_generate_v4()		-- uuid_generate_v5('b128dcb1-ce93-5a44-9f7f-b13a5996989b'::UUID, '10b6b288-a3d8-50eb-bacc-74f8886c9b9b'+'|'+'f02'),
  ,2024
  ,'3ddfa599-8ede-514c-ac46-34c9ef033620'
  ,'AAAAAA00A11B000J'
  ,'AAAAAA00A11B000J'
  ,null
  ,null
  ,8
  ,null
  ,null
  ,null
  ,null
  ,null
  ,'595b026c-07dc-5bdc-af08-499170373ae3'
  ,'Programma - 2023-2024 CSI Referente (SEMIATKOVA JULIA)'
  ,1
  ,'FS019951200192024001'
  ,null
  ,null
  ,null
  ,2026
);