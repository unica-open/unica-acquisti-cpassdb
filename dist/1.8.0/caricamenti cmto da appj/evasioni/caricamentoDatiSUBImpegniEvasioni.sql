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


CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_caricamento_subimpegni_evasione (
  in  p_ente_code		 VARCHAR,
  out codicerisultato    integer,
  out messaggiorisultato varchar
)
RETURNS record AS
$body$
DECLARE
	strMessaggio       				VARCHAR(1500):='';
	strMessaggioFinale 				VARCHAR(1500):='';
    recSubImpegnoevasione    		record;
    v_chiavelogica					VARCHAR(2000) :='';
    v_impegno_ordine_id				UUID;		
    v_impegno_evasione_id 			UUID;
    v_subimpegno_ordine_id          UUID;
	v_subimpegno_id 				UUID;
    v_id_evasione                   UUID;
    v_anno_impegno  				INTEGER;
    v_numero_impegno 				INTEGER;        
    v_anno_subimpegno  				INTEGER;
    v_numero_subimpegno 			INTEGER;        
BEGIN
	codiceRisultato:=0;
    messaggioRisultato:=null;
	strMessaggioFinale:='Ribaltamento subImpegno su righe evasioni ';

	for recSubImpegnoevasione in(
      select
          id 
          ,evasione_anno --INTEGER,
          ,evasione_numero --INTEGER,
          ,progressivo_riga --INTEGER,
          ,progressivo_dest --INTEGER,
          ,progressivo_impegno --INTEGER,
          
          ,anno_esercizio --INTEGER,
          ,anno_impegno --INTEGER,
          ,num_impegno --INTEGER,
          ,anno_subimpegno --INTEGER,
          ,numero_subimpegno --INTEGER,
          
          ,importo_ripartito --NUMERIC(13,5),
          ,importo_sospeso --NUMERIC(13,5),
          ,importo_liquidato --NUMERIC(13,5),
          ,causale_sospensione --VARCHAR(50),
          ,data_sospensione --TIMESTAMP WITHOUT TIME ZONE,
          ,data_creazione --TIMESTAMP WITHOUT TIME ZONE,
          ,utente_creazione --VARCHAR(50),
          ,data_modifica --TIMESTAMP WITHOUT TIME ZONE,
          ,utente_modifica --VARCHAR(50),
          ,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
          ,utente_cancellazione --VARCHAR(50),
      from appoggio_submpegni_evasione
          where esito is null
	)
	loop
    	strMessaggio:='inizio loop';
        begin
          
        v_chiavelogica :=                  recSubImpegnoevasione.evasione_anno       ||'-'; 
        v_chiavelogica := v_chiavelogica|| recSubImpegnoevasione.evasione_numero     ||'-'; 
        v_chiavelogica := v_chiavelogica|| recSubImpegnoevasione.progressivo_riga    ||'-'; 
        v_chiavelogica := v_chiavelogica|| recSubImpegnoevasione.progressivo_dest    ||'-';         
        v_chiavelogica := v_chiavelogica|| recSubImpegnoevasione.anno_esercizio      ||'-';      
        v_chiavelogica := v_chiavelogica|| recSubImpegnoevasione.anno_impegno        ||'-';      
        v_chiavelogica := v_chiavelogica|| recSubImpegnoevasione.num_impegno 	     ||'-';
        v_chiavelogica := v_chiavelogica|| recSubImpegnoevasione.progressivo_impegno ||'-'; 
        v_chiavelogica := v_chiavelogica|| recSubImpegnoevasione.anno_subimpegno     ||'-';
        v_chiavelogica := v_chiavelogica|| recSubImpegnoevasione.numero_subimpegno   ||'-';
            	
        strMessaggio:='1 v_chiavelogica  '|| v_chiavelogica;
/*
        strMessaggio := 'estrazione impegno' || recSubImpegnoevasione.anno_esercizio    ||' anno ese -  ';      
        strMessaggio := strMessaggio|| recSubImpegnoevasione.anno_impegno      			||' anno imp - ';      
        strMessaggio := strMessaggio|| recSubImpegnoevasione.num_impegno 	    		||' num imp  - ';
        strMessaggio := strMessaggio|| recSubImpegnoevasione.anno_subimpegno      		||' anno sub - ';      
        strMessaggio := strMessaggio|| recSubImpegnoevasione.numero_subimpegno 	    	||' num  sub - ';
        strMessaggio := strMessaggio|| recSubImpegnoevasione.evasione_anno 				||' eva anno -';
        strMessaggio := strMessaggio|| recSubImpegnoevasione.evasione_numero 			||' eva numero -';
*/           

        strMessaggio := '2 '        || recSubImpegnoevasione.evasione_anno       ||' evasione_anno  - '; 
        strMessaggio := strMessaggio|| recSubImpegnoevasione.evasione_numero     ||' evasione_numero   - '; 
        strMessaggio := strMessaggio|| recSubImpegnoevasione.progressivo_dest    ||' prog dest - ';         
        strMessaggio := strMessaggio|| recSubImpegnoevasione.progressivo_riga    ||' prog riga - ';   
        strMessaggio := strMessaggio|| recSubImpegnoevasione.anno_impegno        ||' anno_impegno - ';   
        strMessaggio := strMessaggio|| recSubImpegnoevasione.num_impegno         ||' num_impegno - ';   
    	select 
            cpass_t_ord_impegno_evasione.impegno_evasione_id
        into strict v_impegno_evasione_id    
        from 
           cpass_t_ord_testata_evasione
          ,cpass_t_ord_destinatario_evasione
          ,cpass_t_ord_riga_evasione
          ,cpass_t_ord_impegno_evasione
        where 
           cpass_t_ord_testata_evasione.testata_evasione_id 				= cpass_t_ord_destinatario_evasione.testata_evasione_id
           and cpass_t_ord_destinatario_evasione.destinatario_evasione_id 	= cpass_t_ord_riga_evasione.destinatario_evasione_id
           and cpass_t_ord_riga_evasione.riga_evasione_id                   = cpass_t_ord_impegno_evasione.riga_evasione_id
           and cpass_t_ord_testata_evasione.evasione_anno 			        = recSubImpegnoevasione.evasione_anno
           and cpass_t_ord_testata_evasione.evasione_numero 		        = recSubImpegnoevasione.evasione_numero
           and cpass_t_ord_destinatario_evasione.progressivo 		        = recSubImpegnoevasione.progressivo_dest
           and cpass_t_ord_riga_evasione.progressivo 				        = recSubImpegnoevasione.progressivo_riga
           and cpass_t_ord_impegno_evasione.impegno_anno					= recSubImpegnoevasione.anno_impegno
           and cpass_t_ord_impegno_evasione.impegno_numero					= recSubImpegnoevasione.num_impegno
           and cpass_t_ord_impegno_evasione.impegno_progressivo             = recSubImpegnoevasione.progressivo_impegno
           ;

        strMessaggio :=  '3'           || ' anno_esercizio '    || recSubImpegnoevasione.anno_esercizio ;
        strMessaggio := strMessaggio  || ' anno_impegno '      || recSubImpegnoevasione.anno_impegno ;
        strMessaggio := strMessaggio   || ' prog dest - '       || recSubImpegnoevasione.progressivo_dest  ;         
        strMessaggio := strMessaggio   || ' prog riga - '       || recSubImpegnoevasione.progressivo_riga    ;   
        strMessaggio := strMessaggio  || ' num_impegno '       || recSubImpegnoevasione.num_impegno ;
        strMessaggio := strMessaggio  || ' anno_subimpegno '   || recSubImpegnoevasione.anno_subimpegno ;
        strMessaggio := strMessaggio  || ' num_subimpegno '    || recSubImpegnoevasione.numero_subimpegno ;

        select cpass_t_subimpegno.subimpegno_id 
        into strict v_subimpegno_id
        from 
          cpass_t_subimpegno
          ,cpass_t_ente
        where 
               cpass_t_subimpegno.ente_id                   = cpass_t_ente.ente_id
          and  cpass_t_subimpegno.impegno_anno_esercizio 	= recSubImpegnoevasione.anno_esercizio 
          and  cpass_t_subimpegno.impegno_anno 			    = recSubImpegnoevasione.anno_impegno
          and  cpass_t_subimpegno.impegno_numero 			= recSubImpegnoevasione.num_impegno          
          and  cpass_t_subimpegno.subimpegno_anno 			= recSubImpegnoevasione.anno_subimpegno
          and  cpass_t_subimpegno.subimpegno_numero 	    = recSubImpegnoevasione.numero_subimpegno
          and  cpass_t_ente.ente_codice 				    = p_ente_code;
        
        --estraggo id di impegno ordine	
        strMessaggio :=  '4 num_impegno '       || recSubImpegnoevasione.num_impegno ;
        strMessaggio :=  strMessaggio  || ' anno_impegno '   || recSubImpegnoevasione.anno_impegno ;
        strMessaggio :=  strMessaggio  || ' num_impegno '    || recSubImpegnoevasione.num_impegno ;
        strMessaggio :=  strMessaggio  || ' progressivo_impegno '    || recSubImpegnoevasione.progressivo_impegno ;
        strMessaggio :=  strMessaggio  || ' anno_subimpegno '   || recSubImpegnoevasione.anno_subimpegno ;
        strMessaggio :=  strMessaggio  || ' num_subimpegno '    || recSubImpegnoevasione.numero_subimpegno ;
        strMessaggio :=  strMessaggio  || ' evasione_anno '   || recSubImpegnoevasione.evasione_anno ;
        strMessaggio :=  strMessaggio  || ' evasione_numero '    || recSubImpegnoevasione.evasione_numero ;
        strMessaggio := strMessaggio   || ' prog dest - '       || recSubImpegnoevasione.progressivo_dest  ;         
        strMessaggio := strMessaggio   || ' prog riga - '       || recSubImpegnoevasione.progressivo_riga    ;   

        

          select cpass_t_ord_subimpegno_ordine.subimpegno_ordine_id
          into strict v_subimpegno_ordine_id
          from 
             cpass_t_ord_testata_evasione
            ,cpass_t_ord_destinatario_evasione
            ,cpass_t_ord_riga_evasione
			,cpass_t_ord_impegno_evasione
            ,cpass_t_ord_impegno_ordine
            ,cpass_t_ord_subimpegno_ordine
          where 
                cpass_t_ord_testata_evasione.testata_evasione_id 			= cpass_t_ord_destinatario_evasione.testata_evasione_id
            and cpass_t_ord_destinatario_evasione.destinatario_evasione_id 	= cpass_t_ord_riga_evasione.destinatario_evasione_id
            and cpass_t_ord_riga_evasione.riga_evasione_id                  = cpass_t_ord_impegno_evasione.riga_evasione_id
            and cpass_t_ord_impegno_evasione.impegno_ordine_id  			= cpass_t_ord_impegno_ordine.impegno_ordine_id
            and cpass_t_ord_impegno_ordine.impegno_ordine_id    			= cpass_t_ord_subimpegno_ordine.impegno_ordine_id
            
            and cpass_t_ord_testata_evasione.evasione_anno 			    	= recSubImpegnoevasione.evasione_anno
            and cpass_t_ord_testata_evasione.evasione_numero 		    	= recSubImpegnoevasione.evasione_numero
            and cpass_t_ord_destinatario_evasione.progressivo 		    	= recSubImpegnoevasione.progressivo_dest
            and cpass_t_ord_riga_evasione.progressivo 				    	= recSubImpegnoevasione.progressivo_riga

            and cpass_t_ord_subimpegno_ordine.subimpegno_numero 			= recSubImpegnoevasione.numero_subimpegno 
            and cpass_t_ord_subimpegno_ordine.subimpegno_anno   			= recSubImpegnoevasione.anno_impegno 
            and cpass_t_ord_impegno_evasione.impegno_anno       			= recSubImpegnoevasione.anno_impegno
            and cpass_t_ord_impegno_evasione.impegno_numero     			= recSubImpegnoevasione.num_impegno
            and cpass_t_ord_impegno_evasione.impegno_progressivo        	= recSubImpegnoevasione.progressivo_impegno
            ;
               
          strMessaggio:='prima dell inserimento impegno v_chiavelogica --> '|| v_chiavelogica;

		  select uuid_generate_v5('1a312b0f-f51b-52a7-b2da-12ec8ddd8d82',v_chiavelogica) into v_id_evasione;

          strMessaggio:='v_id_evasione --> '|| v_id_evasione;
          
          insert into cpass_t_ord_subimpegno_evasione (
               subimpegno_evasione_id --UUID NOT NULL,
              ,impegno_evasione_id --UUID NOT NULL,
              ,impegno_anno_esercizio --INTEGER NOT NULL,
              ,impegno_anno --INTEGER NOT NULL,
              ,impegno_numero --INTEGER NOT NULL,
              ,subimpegno_anno --INTEGER,
              ,subimpegno_numero --INTEGER,
              ,importo_ripartito --NUMERIC(13,5),
              ,importo_sospeso --NUMERIC(13,5),
              ,importo_liquidato --NUMERIC(13,5),
              ,subimpegno_id --UUID NOT NULL,
              ,subimpegno_ordine_id --UUID NOT NULL,
              ,data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
              ,utente_creazione --VARCHAR(250) NOT NULL,
              ,data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
              ,utente_modifica --VARCHAR(250) NOT NULL,
              ,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
              ,utente_cancellazione --VARCHAR(250),
              --,data_sospensione --TIMESTAMP WITHOUT TIME ZONE,
              --,causale_sospensione_id --INTEGER,              
          )values (
             uuid_generate_v5('78e0b3d0-1779-52e5-ae04-e95f047a56f8',v_chiavelogica)
            
            ,v_impegno_evasione_id --UUID NOT NULL,
            
            ,recSubImpegnoevasione.anno_esercizio --INTEGER NOT NULL,
            ,recSubImpegnoevasione.anno_impegno --INTEGER NOT NULL,
            ,recSubImpegnoevasione.num_impegno --INTEGER NOT NULL,
            ,recSubImpegnoevasione.anno_subimpegno --INTEGER,
            ,recSubImpegnoevasione.numero_subimpegno --INTEGER,
            ,recSubImpegnoevasione.importo_ripartito --NUMERIC(13,5),
            ,recSubImpegnoevasione.importo_sospeso --NUMERIC(13,5),
            ,recSubImpegnoevasione.importo_liquidato --NUMERIC(13,5),
            
            ,v_subimpegno_id --UUID NOT NULL,
            ,v_subimpegno_ordine_id --UUID NOT NULL,
            
            ,recSubImpegnoevasione.data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
            ,recSubImpegnoevasione.utente_creazione --VARCHAR(250) NOT NULL,
            ,recSubImpegnoevasione.data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
            ,recSubImpegnoevasione.utente_modifica --VARCHAR(250) NOT NULL,
            ,recSubImpegnoevasione.data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
            ,recSubImpegnoevasione.utente_cancellazione --VARCHAR(250),
             --,data_sospensione --TIMESTAMP WITHOUT TIME ZONE,
             --,causale_sospensione_id --INTEGER,                
          );
            
          update appoggio_submpegni_evasione set esito = 'OK'  where  id = recSubImpegnoevasione.id;
          
          codiceRisultato := codiceRisultato + 1;    
      exception
        when others  THEN
          raise notice '% % Errore DB % %',strMessaggioFinale,coalesce(strMessaggio,''),SQLSTATE,substring(upper(SQLERRM) from 1 for 2500);
          messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'Errore DB '||SQLSTATE||' '||substring(upper(SQLERRM) from 1 for 2500) ;
      END;
    end loop;
    
    messaggioRisultato:=strMessaggioFinale||' FINE';
    return;

exception
    when RAISE_EXCEPTION THEN
        raise notice 'strMessaggio=%  ', strMessaggio;
    	raise notice '% % ERRORE : %',strMessaggioFinale,coalesce(strMessaggio,''),substring(upper(SQLERRM) from 1 for 500);
        messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'ERRORE :'||' '||substring(upper(SQLERRM) from 1 for 2500) ;
        codiceRisultato:=-1;
        return;
	when no_data_found THEN
		raise notice ' % % Nessun elemento trovato.' ,strMessaggioFinale,coalesce(strMessaggio,'');
        messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'Nessun elemento trovato.' ;
        codiceRisultato:=-1;
		return;
	when others  THEN
		raise notice '% % Errore DB % %',strMessaggioFinale,coalesce(strMessaggio,''),SQLSTATE,substring(upper(SQLERRM) from 1 for 2500);
        messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'Errore DB '||SQLSTATE||' '||substring(upper(SQLERRM) from 1 for 2500) ;
        codiceRisultato:=-1;
        return;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

select * from pck_cpass_ord_caricamento_subimpegni_evasione('CMTO');


