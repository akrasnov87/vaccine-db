CREATE TABLE core.sd_table_change_ref (
	id smallint DEFAULT nextval('core.sd_table_change_ref_id_seq'::regclass) NOT NULL,
	c_table_name text NOT NULL,
	c_table_name_ref text NOT NULL
);

ALTER TABLE core.sd_table_change_ref OWNER TO mobnius;

COMMENT ON TABLE core.sd_table_change_ref IS 'Зависимость таблиц состояний';

COMMENT ON COLUMN core.sd_table_change_ref.c_table_name IS 'Таблица';

COMMENT ON COLUMN core.sd_table_change_ref.c_table_name_ref IS 'Зависимая таблица';

--------------------------------------------------------------------------------

ALTER TABLE core.sd_table_change_ref
	ADD CONSTRAINT sd_table_change_ref_pkey PRIMARY KEY (id);
