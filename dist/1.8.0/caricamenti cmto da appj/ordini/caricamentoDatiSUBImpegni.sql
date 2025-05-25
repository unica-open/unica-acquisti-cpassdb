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
CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_caricamento_subimpegni_ordine (
  p_ente_code varchar,
  out codicerisultato integer,
  out messaggiorisultato varchar
)
RETURNS record AS
$body$
DECLARE
	strMessaggio       				VARCHAR(1500):='';
	strMessaggioFinale 				VARCHAR(1500):='';
    recSubImpegnoOrdine    			record;
    v_chiavelogica					VARCHAR(2000) :='';
	v_impegno_id 					UUID;
	v_subimpegno_id 				UUID;    
    v_riga_ordine_id 				UUID;
    v_impegno_ordine_id             UUID;
BEGIN
	codiceRisultato:=0;
    messaggioRisultato:=null;
	strMessaggioFinale:='Ribaltamento impegni su righe ordini ';

	for recSubImpegnoOrdine in(
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
          ,numero_subimpegno --INTEGER,
          ,importo_subimpegno --NUMERIC(13,5),
          ,data_creazione --TIMESTAMP WITHOUT TIME ZONE,
          ,utente_creazione --VARCHAR(50),
          ,data_modifica --TIMESTAMP WITHOUT TIME ZONE,
          ,utente_modifica --VARCHAR(50),
          ,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
          ,utente_cancellazione --VARCHAR(50),
      from appoggio_ordine_impegni_sub
          where esito_sub is null
          and numero_subimpegno is not null
	)
	loop
    	strMessaggio:='inizio loop';
        begin
          

               
        strMessaggio :=                recSubImpegnoOrdine.anno_esercizio    ||' - '; 
        strMessaggio := strMessaggio|| recSubImpegnoOrdine.anno_impegno      ||' - '; 
        strMessaggio := strMessaggio|| recSubImpegnoOrdine.num_impegno       ||' - '; 
        strMessaggio := strMessaggio|| recSubImpegnoOrdine.anno_impegno      ||' - ';
        strMessaggio := strMessaggio|| recSubImpegnoOrdine.numero_subimpegno ||' - '; 
        
        
        select  subimpegno_id 
        into    strict v_subimpegno_id
        from 
          cpass_t_subimpegno,cpass_t_ente
        where 
               cpass_t_subimpegno.ente_id 					= cpass_t_ente.ente_id
          and  cpass_t_subimpegno.impegno_anno_esercizio 	= recSubImpegnoOrdine.anno_esercizio 
          and  cpass_t_subimpegno.impegno_anno 			    = recSubImpegnoOrdine.anno_impegno
          and  cpass_t_subimpegno.impegno_numero 			= recSubImpegnoOrdine.num_impegno

          and  cpass_t_subimpegno.subimpegno_anno 			= recSubImpegnoOrdine.anno_impegno
          and  cpass_t_subimpegno.subimpegno_numero 		= recSubImpegnoOrdine.numero_subimpegno
          and  cpass_t_ente.ente_codice 				    = p_ente_code;

        strMessaggio :=                recSubImpegnoOrdine.ordine_anno       ||' ord anno  - '; 
        strMessaggio := strMessaggio|| recSubImpegnoOrdine.ordine_numero     ||' ord num   - '; 
        strMessaggio := strMessaggio|| recSubImpegnoOrdine.progressivo_dest  ||' prog dest - ';         
        strMessaggio := strMessaggio|| recSubImpegnoOrdine.progressivo_riga  ||' prog riga - '; 
        strMessaggio := strMessaggio|| recSubImpegnoOrdine.progressivo_impegno_sub  ||' progressivo_impegno_sub - '; 


        select 
            cpass_t_ord_impegno_ordine.impegno_ordine_id
        into strict v_impegno_ordine_id    
        from 
           cpass_t_ord_testata_ordine
          ,cpass_t_ord_destinatario_ordine
          ,cpass_t_ord_riga_ordine
          ,cpass_t_ord_impegno_ordine
        where 
           cpass_t_ord_testata_ordine.testata_ordine_id 		= cpass_t_ord_destinatario_ordine.testata_ordine_id
           and cpass_t_ord_destinatario_ordine.destinatario_id 	= cpass_t_ord_riga_ordine.destinatario_id
           and cpass_t_ord_riga_ordine.riga_ordine_id           = cpass_t_ord_impegno_ordine.riga_ordine_id

           and cpass_t_ord_testata_ordine.ordine_anno 			= recSubImpegnoOrdine.ordine_anno
           and cpass_t_ord_testata_ordine.ordine_numero 		= recSubImpegnoOrdine.ordine_numero
           and cpass_t_ord_destinatario_ordine.progressivo 		= recSubImpegnoOrdine.progressivo_dest
           and cpass_t_ord_riga_ordine.progressivo 				= recSubImpegnoOrdine.progressivo_riga
   		   and cpass_t_ord_impegno_ordine.impegno_progressivo	= recSubImpegnoOrdine.progressivo_impegno_sub;
            
        v_chiavelogica :=                  recSubImpegnoOrdine.ordine_anno       ||'-'; 
        v_chiavelogica := v_chiavelogica|| recSubImpegnoOrdine.ordine_numero     ||'-'; 
        v_chiavelogica := v_chiavelogica|| recSubImpegnoOrdine.progressivo_riga  ||'-'; 
        v_chiavelogica := v_chiavelogica|| recSubImpegnoOrdine.progressivo_dest  ||'-';         
        v_chiavelogica := v_chiavelogica|| recSubImpegnoOrdine.anno_esercizio    ||'-';      
        v_chiavelogica := v_chiavelogica|| recSubImpegnoOrdine.anno_impegno      ||'-';      
        v_chiavelogica := v_chiavelogica|| recSubImpegnoOrdine.num_impegno 	     ||'-';
        v_chiavelogica := v_chiavelogica|| recSubImpegnoOrdine.progressivo_impegno_sub ||'-';
        v_chiavelogica := v_chiavelogica|| recSubImpegnoOrdine.numero_subimpegno;            	
        strMessaggio:='v_chiavelogica --> '|| v_chiavelogica;
        
          insert into cpass_t_ord_subimpegno_ordine (
              subimpegno_ordine_id --UUID NOT NULL,
              ,impegno_ordine_id --UUID NOT NULL,
              ,subimpegno_id --UUID NOT NULL,
              
              ,impegno_anno_esercizio --INTEGER NOT NULL,
              ,impegno_anno --INTEGER NOT NULL,
              ,impegno_numero --INTEGER NOT NULL,

              ,subimpegno_anno --INTEGER,
              ,subimpegno_numero --INTEGER,
              ,subimpegno_importo --NUMERIC(13,5),

              ,data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
              ,utente_creazione --VARCHAR(250) NOT NULL,
              ,data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
              ,utente_modifica --VARCHAR(250) NOT NULL,
          )values (
               uuid_generate_v5('78e0b3d0-1779-52e5-ae04-e95f047a56f8',v_chiavelogica)
              ,v_impegno_ordine_id --UUID NOT NULL,
			  ,v_subimpegno_id
              
              ,recSubImpegnoOrdine.anno_esercizio 
              ,recSubImpegnoOrdine.anno_impegno 
              ,recSubImpegnoOrdine.num_impegno 

              ,recSubImpegnoOrdine.anno_impegno 
              ,recSubImpegnoOrdine.numero_subimpegno 
              ,recSubImpegnoOrdine.importo_subimpegno 

              ,recSubImpegnoOrdine.data_creazione 
              ,recSubImpegnoOrdine.utente_creazione 
              ,recSubImpegnoOrdine.data_modifica 
              ,recSubImpegnoOrdine.utente_modifica
          );
            
          update appoggio_ordine_impegni_sub set esito_sub = 'OK' 
          where 
                  ordine_anno 		= recSubImpegnoOrdine.ordine_anno      
              and ordine_numero 	= recSubImpegnoOrdine.ordine_numero     
              and progressivo_riga  = recSubImpegnoOrdine.progressivo_riga  
              and progressivo_dest  = recSubImpegnoOrdine.progressivo_dest      
              and anno_esercizio 	= recSubImpegnoOrdine.anno_esercizio      
              and anno_impegno 		= recSubImpegnoOrdine.anno_impegno          
              and num_impegno 		= recSubImpegnoOrdine.num_impegno 
              and numero_subimpegno = recSubImpegnoOrdine.numero_subimpegno;

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
