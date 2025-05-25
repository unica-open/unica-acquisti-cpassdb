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
CREATE OR REPLACE FUNCTION cpass.pck_cpass_pezza_bordello(p_programma_id_new varchar,p_programma_id_old varchar, OUT codicerisultato integer, OUT messaggiorisultato character varying)
 RETURNS record
 LANGUAGE plpgsql
AS $function$
DECLARE
	strMessaggio       				VARCHAR(1500):='';
	strMessaggioFinale 				VARCHAR(1500):='';
	v_num_liq_agg_imp				INTEGER := 0;
	v_num_liq_agg_sub				INTEGER := 0;
	elabRec record;

BEGIN
	codiceRisultato:=0;
    messaggioRisultato:=null;
	strMessaggioFinale:='pck_cpass_pezza_bordello ';


for  elabRec in
    (
      select pagopa.*
      from siac_t_file_pagopa pagopa, siac_d_file_pagopa_stato stato
      where stato.ente_proprietario_id=enteProprietarioId
      and   stato.file_pagopa_stato_code in (ACQUISITO_ST,ELABORATO_IN_CORSO_ST,ELABORATO_IN_CORSO_SC_ST,ELABORATO_IN_CORSO_ER_ST)
      and   pagopa.file_pagopa_stato_id=stato.file_pagopa_stato_id
      and   pagopa.file_pagopa_anno=annoRec.anno_elab
      and   pagopa.data_cancellazione is null
      and   pagopa.validita_fine is null
      and   codiceRisultato=0
      order by pagopa.file_pagopa_id
    )
    loop
 





    end loop;





	codiceRisultato:=0;																												  
    messaggioRisultato:=strMessaggioFinale||' FINE';
	raise notice 'messaggioRisultato=%  ', messaggioRisultato;
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
$function$
;
