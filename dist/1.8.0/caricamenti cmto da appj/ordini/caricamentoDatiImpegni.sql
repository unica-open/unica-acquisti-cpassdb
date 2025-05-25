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


CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_caricamento_impegni_ordine (
  in  p_ente_code		 VARCHAR,
  out codicerisultato    integer,
  out messaggiorisultato varchar
)
RETURNS record AS
$body$
DECLARE
	strMessaggio       				VARCHAR(1500):='';
	strMessaggioFinale 				VARCHAR(1500):='';
    recImpegnoOrdine    			record;
    v_chiavelogica					VARCHAR(2000) :='';
	v_impegno_id 					UUID;
    v_riga_ordine_id 				UUID;
BEGIN
	codiceRisultato:=0;
    messaggioRisultato:=null;
	strMessaggioFinale:='Ribaltamento impegni su righe ordini ';

	for recImpegnoOrdine in(
      select
          distinct  
          --id 
           ordine_anno --INTEGER,
          ,ordine_numero --INTEGER,
          ,progressivo_riga --INTEGER,
          ,progressivo_dest --INTEGER,
          ,progressivo_impegno_sub --INTEGER,
          ,anno_esercizio --INTEGER,
          ,anno_impegno --INTEGER,
          ,num_impegno --INTEGER,
          ,importo_impegno --NUMERIC(13,5),
          --,numero_subimpegno --INTEGER,
          --,importo_subimpegno --NUMERIC(13,5),
          ,data_creazione --TIMESTAMP WITHOUT TIME ZONE,
          ,utente_creazione --VARCHAR(50),
          ,data_modifica --TIMESTAMP WITHOUT TIME ZONE,
          ,utente_modifica --VARCHAR(50),
          ,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
          ,utente_cancellazione --VARCHAR(50),
      from appoggio_ordine_impegni_sub
          where esito is null
	)
	loop
    	strMessaggio:='inizio loop';
        begin
          
        v_chiavelogica :=                  recImpegnoOrdine.ordine_anno       ||'-'; 
        v_chiavelogica := v_chiavelogica|| recImpegnoOrdine.ordine_numero     ||'-'; 
        v_chiavelogica := v_chiavelogica|| recImpegnoOrdine.progressivo_riga  ||'-'; 
        v_chiavelogica := v_chiavelogica|| recImpegnoOrdine.progressivo_dest  ||'-';         
        v_chiavelogica := v_chiavelogica|| recImpegnoOrdine.anno_esercizio    ||'-';      
        v_chiavelogica := v_chiavelogica|| recImpegnoOrdine.anno_impegno      ||'-';      
        v_chiavelogica := v_chiavelogica|| recImpegnoOrdine.num_impegno 	  ||'-';
        v_chiavelogica := v_chiavelogica|| recImpegnoOrdine.progressivo_impegno_sub;
            	
        strMessaggio:='v_chiavelogica --> '|| v_chiavelogica;
               
        select impegno_id 
        into strict v_impegno_id
        from 
          cpass_t_impegno
          ,cpass_t_ente
        where 
               cpass_t_impegno.ente_id = cpass_t_ente.ente_id
          and  cpass_t_impegno.impegno_anno_esercizio 	= recImpegnoOrdine.anno_esercizio 
          and  cpass_t_impegno.impegno_anno 			= recImpegnoOrdine.anno_impegno
          and  cpass_t_impegno.impegno_numero 			= recImpegnoOrdine.num_impegno
          and  cpass_t_ente.ente_codice 				= p_ente_code;

        strMessaggio :=                recImpegnoOrdine.ordine_anno       ||' ord anno  - '; 
        strMessaggio := strMessaggio|| recImpegnoOrdine.ordine_numero     ||' ord num   - '; 
        strMessaggio := strMessaggio|| recImpegnoOrdine.progressivo_dest  ||' prog dest - ';         
        strMessaggio := strMessaggio|| recImpegnoOrdine.progressivo_riga  ||' prog riga - '; 


        select 
            cpass_t_ord_riga_ordine.riga_ordine_id
        into strict v_riga_ordine_id    
        from 
           cpass_t_ord_testata_ordine
          ,cpass_t_ord_destinatario_ordine
          ,cpass_t_ord_riga_ordine
        where 
           cpass_t_ord_testata_ordine.testata_ordine_id 		= cpass_t_ord_destinatario_ordine.testata_ordine_id
           and cpass_t_ord_destinatario_ordine.destinatario_id 	=  cpass_t_ord_riga_ordine.destinatario_id
           and cpass_t_ord_testata_ordine.ordine_anno 			= recImpegnoOrdine.ordine_anno
           and cpass_t_ord_testata_ordine.ordine_numero 		= recImpegnoOrdine.ordine_numero
           and cpass_t_ord_destinatario_ordine.progressivo 		= recImpegnoOrdine.progressivo_dest
           and cpass_t_ord_riga_ordine.progressivo 				= recImpegnoOrdine.progressivo_riga;
   
         strMessaggio:='prima dell inserimento impegno';

          insert into cpass_t_ord_impegno_ordine (
                impegno_ordine_id --UUID NOT NULL,
                ,impegno_id --UUID NOT NULL,
                ,riga_ordine_id --UUID NOT NULL,
                ,impegno_progressivo --INTEGER NOT NULL,
                ,impegno_anno_esercizio --INTEGER NOT NULL,
                ,impegno_anno --INTEGER NOT NULL,
                ,impegno_numero --INTEGER NOT NULL,
                ,importo --NUMERIC(13,5),
                ,data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
                ,utente_creazione --VARCHAR(250) NOT NULL,
                ,data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
                ,utente_modifica--VARCHAR(250) NOT NULL,
          )values (
               uuid_generate_v5('78e0b3d0-1779-52e5-ae04-e95f047a56f8',v_chiavelogica)
              ,v_impegno_id --UUID NOT NULL,
              ,v_riga_ordine_id --UUID NOT NULL,
              ,recImpegnoOrdine.progressivo_impegno_sub --INTEGER NOT NULL,
              ,recImpegnoOrdine.anno_esercizio --INTEGER NOT NULL,
              ,recImpegnoOrdine.anno_impegno --INTEGER NOT NULL,
              ,recImpegnoOrdine.num_impegno --INTEGER NOT NULL,
              ,recImpegnoOrdine.importo_impegno --NUMERIC(13,5),
              ,recImpegnoOrdine.data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
              ,recImpegnoOrdine.utente_creazione --VARCHAR(250) NOT NULL,
              ,recImpegnoOrdine.data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
              ,recImpegnoOrdine.utente_modifica--VARCHAR(250) NOT NULL,
          );
            
          update appoggio_ordine_impegni_sub set esito = 'OK' 
          where 
                  ordine_anno 		= recImpegnoOrdine.ordine_anno      
              and ordine_numero 	= recImpegnoOrdine.ordine_numero     
              and progressivo_riga  = recImpegnoOrdine.progressivo_riga  
              and progressivo_dest  = recImpegnoOrdine.progressivo_dest      
              and anno_esercizio 	= recImpegnoOrdine.anno_esercizio      
              and anno_impegno 		= recImpegnoOrdine.anno_impegno          
              and num_impegno 		= recImpegnoOrdine.num_impegno 	 
              and progressivo_impegno_sub =recImpegnoOrdine.progressivo_impegno_sub;
          
          codiceRisultato := codiceRisultato + 1;    
      exception
        when others  THEN
          raise notice '% % Errore DB % %',strMessaggioFinale,coalesce(strMessaggio,''),SQLSTATE,substring(upper(SQLERRM) from 1 for 2500);
          messaggioRisultato:=strMessaggioFinale||coalesce(strMessaggio,'')||'Errore DB '||SQLSTATE||' '||substring(upper(SQLERRM) from 1 for 2500) ;
          codiceRisultato:=-1;
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

select * from pck_cpass_ord_caricamento_impegni_ordine('CMTO');

