CREATE SEQUENCE core.sd_table_change_id_seq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE core.sd_table_change_id_seq OWNER TO mobnius;

ALTER SEQUENCE core.sd_table_change_id_seq
	OWNED BY core.sd_table_change.id;
