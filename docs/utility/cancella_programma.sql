/*
delete from cpass_t_pba_intervento_altri_dati
where intervento_id in 
(select intervento_id 
from cpass_t_pba_intervento
where programma_id = 'f7a94635-714a-56bf-a2cd-47faeaa22efa' )

delete from cpass_t_pba_intervento_cig
where intervento_id in 
(select intervento_id 
from cpass_t_pba_intervento
where programma_id = 'f7a94635-714a-56bf-a2cd-47faeaa22efa' )


delete from cpass_t_pba_intervento_importi
where intervento_id in 
(select intervento_id 
from cpass_t_pba_intervento
where programma_id = 'f7a94635-714a-56bf-a2cd-47faeaa22efa' );


DELETE from cpass_r_pba_stati_intervento where intervento_id in 
(select intervento_id 
from cpass_t_pba_intervento
where programma_id = 'f7a94635-714a-56bf-a2cd-47faeaa22efa' );


delete from cpass_t_pba_intervento
where programma_id = 'f7a94635-714a-56bf-a2cd-47faeaa22efa';


delete from cpass_t_pba_programma
where programma_id = 'f7a94635-714a-56bf-a2cd-47faeaa22efa';

*/
