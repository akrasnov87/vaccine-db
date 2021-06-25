CREATE TABLE core.sd_table_change (
	c_table_name text NOT NULL,
	n_change double precision NOT NULL,
	f_user integer,
	id bigint DEFAULT nextval('core.sd_table_change_id_seq'::regclass) NOT NULL
);

ALTER TABLE core.sd_table_change OWNER TO mobnius;

COMMENT ON TABLE core.sd_table_change IS 'Изменение состояния таблицы';

COMMENT ON COLUMN core.sd_table_change.c_table_name IS 'Имя таблицы';

COMMENT ON COLUMN core.sd_table_change.n_change IS 'Версия изменения';

--------------------------------------------------------------------------------

ALTER TABLE core.sd_table_change
	ADD CONSTRAINT sd_table_change_f_user_fkey FOREIGN KEY (f_user) REFERENCES core.pd_users(id) NOT VALID;

--------------------------------------------------------------------------------

ALTER TABLE core.sd_table_change
	ADD CONSTRAINT sd_table_change_c_table_name_f_user_pkey UNIQUE (c_table_name, f_user);

--------------------------------------------------------------------------------

ALTER TABLE core.sd_table_change
	ADD CONSTRAINT sd_table_change_pkey PRIMARY KEY (id);
