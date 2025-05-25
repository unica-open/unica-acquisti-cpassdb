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


CREATE OR REPLACE FUNCTION cpass.pck_cpass_ord_caricamento_impegni_evasione (
  in  p_ente_code		 VARCHAR,
  out codicerisultato    integer,
  out messaggiorisultato varchar
)
RETURNS record AS
$body$
DECLARE
	strMessaggio       				VARCHAR(1500):='';
	strMessaggioFinale 				VARCHAR(1500):='';
    recImpegnoevasione    			record;
    v_chiavelogica					VARCHAR(2000) :='';
    v_riga_evasione_id 				UUID;
    v_impegno_ordine_id             UUID;
	v_impegno_id 					UUID;
    v_id_evasione                   UUID;
    v_anno_impegno  				INTEGER;
    v_numero_impegno 				INTEGER;        
    
BEGIN
	codiceRisultato:=0;
    messaggioRisultato:=null;
	strMessaggioFinale:='Ribaltamento impegni su righe evasioni ';

	for recImpegnoevasione in(
      select
          id 
          ,evasione_anno --INTEGER,
          ,evasione_numero --INTEGER,
          ,progressivo_riga --INTEGER,
          ,progressivo_dest --INTEGER,
          ,progressivo_impegno --INTEGER,
          
          ,progressivo_impegno --INTEGER,
          ,ordine_anno --INTEGER,
          ,ordine_numero --INTEGER,
          ,progr_riga_ordine --INTEGER,
          ,progr_dest_ordine --INTEGER,
  
          ,anno_esercizio --INTEGER,
          ,anno_impegno --INTEGER,
          ,num_impegno --INTEGER,
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
          ,anno_impegno_orig --INTEGER,
          ,num_impegno_orig --INTEGER,
      from appoggio_impegni_evasione
          where esito is null
	)
	loop
    	strMessaggio:='inizio loop';
        begin
          
        v_chiavelogica :=                  recImpegnoevasione.evasione_anno     ||'-'; 
        v_chiavelogica := v_chiavelogica|| recImpegnoevasione.evasione_numero   ||'-'; 
        v_chiavelogica := v_chiavelogica|| recImpegnoevasione.progressivo_riga  ||'-'; 
        v_chiavelogica := v_chiavelogica|| recImpegnoevasione.progressivo_dest  ||'-';         
        v_chiavelogica := v_chiavelogica|| recImpegnoevasione.anno_esercizio    ||'-';      
        v_chiavelogica := v_chiavelogica|| recImpegnoevasione.anno_impegno      ||'-';      
        v_chiavelogica := v_chiavelogica|| recImpegnoevasione.num_impegno 	    ||'-';
        v_chiavelogica := v_chiavelogica|| recImpegnoevasione.progressivo_impegno;
            	
        strMessaggio:='v_chiavelogica  '|| v_chiavelogica;

        strMessaggio := 'estrazione impegno' || recImpegnoevasione.anno_esercizio    ||' anno ese -  ';      
        strMessaggio := strMessaggio|| recImpegnoevasione.anno_impegno      ||' anno imp   - ';      
        strMessaggio := strMessaggio|| recImpegnoevasione.num_impegno 	    ||' num imp    - ';
        strMessaggio := strMessaggio|| recImpegnoevasione.evasione_anno 	||' eva anno   -';
        strMessaggio := strMessaggio|| recImpegnoevasione.evasione_numero 	||' eva numero -';
               
        
        select impegno_id 
        into strict v_impegno_id
        from 
          cpass_t_impegno
          ,cpass_t_ente
        where 
               cpass_t_impegno.ente_id = cpass_t_ente.ente_id
          and  cpass_t_impegno.impegno_anno_esercizio 	= recImpegnoevasione.anno_esercizio 
          and  cpass_t_impegno.impegno_anno 			= recImpegnoevasione.anno_impegno
          and  cpass_t_impegno.impegno_numero 			= recImpegnoevasione.num_impegno
          and  cpass_t_ente.ente_codice 				= p_ente_code;

        strMessaggio :=                recImpegnoevasione.evasione_anno       ||' ord anno  - '; 
        strMessaggio := strMessaggio|| recImpegnoevasione.evasione_numero     ||' ord num   - '; 
        strMessaggio := strMessaggio|| recImpegnoevasione.progressivo_dest    ||' prog dest - ';         
        strMessaggio := strMessaggio|| recImpegnoevasione.progressivo_riga    ||' prog riga - '; 


        select 
            cpass_t_ord_riga_evasione.riga_evasione_id
        into strict v_riga_evasione_id    
        from 
           cpass_t_ord_testata_evasione
          ,cpass_t_ord_destinatario_evasione
          ,cpass_t_ord_riga_evasione
        where 
           cpass_t_ord_testata_evasione.testata_evasione_id 				= cpass_t_ord_destinatario_evasione.testata_evasione_id
           and cpass_t_ord_destinatario_evasione.destinatario_evasione_id 	=  cpass_t_ord_riga_evasione.destinatario_evasione_id
           and cpass_t_ord_testata_evasione.evasione_anno 			        = recImpegnoevasione.evasione_anno
           and cpass_t_ord_testata_evasione.evasione_numero 		        = recImpegnoevasione.evasione_numero
           and cpass_t_ord_destinatario_evasione.progressivo 		        = recImpegnoevasione.progressivo_dest
           and cpass_t_ord_riga_evasione.progressivo 				        = recImpegnoevasione.progressivo_riga;
   

          
          if recImpegnoevasione.num_impegno_orig is not null then
          	v_anno_impegno   := recImpegnoevasione.anno_impegno_orig;
          	v_numero_impegno := recImpegnoevasione.num_impegno_orig;

            strMessaggio :=  'ID --> '|| recImpegnoevasione.id::varchar ;
			raise notice '%',strMessaggio ;

            strMessaggio := ' anno_impegno ' || v_anno_impegno::varchar  || ' num_impegno '       || v_numero_impegno::varchar ;
			raise notice '%',strMessaggio ;
          else 
          	v_anno_impegno   := recImpegnoevasione.anno_impegno;
          	v_numero_impegno := recImpegnoevasione.num_impegno;         
          end if;

          --estraggo id di impegno ordine	
          strMessaggio := 'anno ord ' || recImpegnoevasione.ordine_anno ;
          strMessaggio :=  strMessaggio  || ' numero ord '        || recImpegnoevasione.ordine_numero ;
          strMessaggio :=  strMessaggio  || ' progr_dest_ordine ' || recImpegnoevasione.progr_dest_ordine ;
          strMessaggio :=  strMessaggio  || ' progr_riga_ordine ' || recImpegnoevasione.progr_riga_ordine ;
          strMessaggio :=  strMessaggio  || ' anno_esercizio '    || recImpegnoevasione.anno_esercizio ;
          strMessaggio :=  strMessaggio  || ' anno_impegno '      || v_anno_impegno::varchar ;
          strMessaggio :=  strMessaggio  || ' num_impegno '       || v_numero_impegno::varchar ;
          strMessaggio :=  strMessaggio  || ' eva anno '          || recImpegnoevasione.evasione_anno ;
          strMessaggio :=  strMessaggio  || ' eva numero '        || recImpegnoevasione.evasione_numero ;

          
          select cpass_t_ord_impegno_ordine.impegno_ordine_id
          into strict v_impegno_ordine_id
          from 
                 cpass_t_ord_testata_ordine
                ,cpass_t_ord_destinatario_ordine
                ,cpass_t_ord_riga_ordine
                ,cpass_t_ord_impegno_ordine
          where cpass_t_ord_testata_ordine.testata_ordine_id    	= cpass_t_ord_destinatario_ordine.testata_ordine_id
              and   cpass_t_ord_destinatario_ordine.destinatario_id = cpass_t_ord_riga_ordine.destinatario_id
              and   cpass_t_ord_riga_ordine.riga_ordine_id          = cpass_t_ord_impegno_ordine.riga_ordine_id              
              and   cpass_t_ord_testata_ordine.ordine_numero 		= recImpegnoevasione.ordine_numero
              and   cpass_t_ord_testata_ordine.ordine_anno 			= recImpegnoevasione.ordine_anno              
              and   cpass_t_ord_destinatario_ordine.progressivo 	= recImpegnoevasione.progr_dest_ordine 
              and   cpass_t_ord_riga_ordine.progressivo 			= recImpegnoevasione.progr_riga_ordine
              and   cpass_t_ord_impegno_ordine.impegno_anno         = v_anno_impegno 
              and   cpass_t_ord_impegno_ordine.impegno_numero       = v_numero_impegno; 



          strMessaggio:='prima dell inserimento impegno v_chiavelogica --> '|| v_chiavelogica;

		  select uuid_generate_v5('78e0b3d0-1779-52e5-ae04-e95f047a56f8',v_chiavelogica) into v_id_evasione;

          strMessaggio:='v_id_evasione --> '|| v_id_evasione;
          
          insert into cpass_t_ord_impegno_evasione (
             impegno_evasione_id --UUID NOT NULL,
            ,riga_evasione_id --UUID NOT NULL,
            ,impegno_id --UUID NOT NULL,
            ,impegno_ordine_id --UUID NOT NULL,
            ,impegno_progressivo --INTEGER NOT NULL,
            ,impegno_anno_esercizio --INTEGER NOT NULL,
            ,impegno_anno --INTEGER NOT NULL,
            ,impegno_numero --INTEGER NOT NULL,
            ,importo_ripartito --NUMERIC(13,5),
            ,importo_sospeso --NUMERIC(13,5),
            ,importo_liquidato --NUMERIC(13,5),
            --causale_sospensione_id --INTEGER,
            --data_sospensione --TIMESTAMP WITHOUT TIME ZONE,
            ,data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
            ,utente_creazione --VARCHAR(250) NOT NULL,
            ,data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
            ,utente_modifica --VARCHAR(250) NOT NULL,
            ,data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
            ,utente_cancellazione --VARCHAR(250),                
          )values (
             uuid_generate_v5('78e0b3d0-1779-52e5-ae04-e95f047a56f8',v_chiavelogica)
            ,v_riga_evasione_id --UUID NOT NULL,
            ,v_impegno_id --UUID NOT NULL,
            ,v_impegno_ordine_id --UUID NOT NULL,

            ,recImpegnoevasione.progressivo_impegno --INTEGER NOT NULL,
            ,recImpegnoevasione.anno_esercizio --INTEGER NOT NULL,
            ,recImpegnoevasione.anno_impegno --INTEGER NOT NULL,
            ,recImpegnoevasione.num_impegno --INTEGER NOT NULL,
            
            ,recImpegnoevasione.importo_ripartito --NUMERIC(13,5),
            ,recImpegnoevasione.importo_sospeso --NUMERIC(13,5),
            ,recImpegnoevasione.importo_liquidato --NUMERIC(13,5),
            --,causale_sospensione_id --INTEGER,
            --,data_sospensione --TIMESTAMP WITHOUT TIME ZONE,
            ,recImpegnoevasione.data_creazione --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
            ,recImpegnoevasione.utente_creazione --VARCHAR(250) NOT NULL,
            ,recImpegnoevasione.data_modifica --TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
            ,recImpegnoevasione.utente_modifica --VARCHAR(250) NOT NULL,
            ,recImpegnoevasione.data_cancellazione --TIMESTAMP WITHOUT TIME ZONE,
            ,recImpegnoevasione.utente_cancellazione --VARCHAR(250),   
          );
            
          update appoggio_impegni_evasione set esito = 'OK'  where  id = recImpegnoevasione.id;
          
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

select * from pck_cpass_ord_caricamento_impegni_evasione('CMTO');




/*
update appoggio_impegni_evasione set esito = null;

delete from cpass_t_ord_impegno_evasione
where cpass_t_ord_impegno_evasione.utente_creazione !='AAAAAA00A11B000J';
*/

