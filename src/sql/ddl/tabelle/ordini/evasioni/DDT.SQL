

CREATE TABLE if not exists  cpass.cpass_t_ord_documento_trasporto (
	documento_trasporto_id  SERIAL 
   ,CONSTRAINT cpass_t_ord_documento_trasporto_pkey PRIMARY KEY(documento_trasporto_id)
);
  
COMMENT ON TABLE cpass.cpass_t_ord_documento_trasporto
IS 'UUID namespace: "cpass_t_ord_documento_trasporto"';

CREATE TABLE if not exists  cpass.cpass_t_ord_documento_trasporto_riga (
	documento_trasporto_riga_id  SERIAL 
   ,documento_trasporto_id integer not null
   ,CONSTRAINT cpass_t_ord_documento_trasporto_riga_pkey PRIMARY KEY(documento_trasporto_riga_id)
   ,CONSTRAINT fk_cpass_t_documento_trasporto_documento_trasporto_riga FOREIGN KEY (documento_trasporto_id)
    REFERENCES cpass.cpass_t_ord_documento_trasporto(documento_trasporto_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
);
COMMENT ON TABLE cpass.cpass_t_ord_documento_trasporto_riga
IS 'UUID namespace: "cpass_t_ord_documento_trasporto_riga"';
