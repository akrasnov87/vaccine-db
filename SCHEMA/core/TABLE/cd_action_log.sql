CREATE TABLE core.cd_action_log (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	c_table_name text,
	c_operation text,
	jb_old_value jsonb,
	jb_new_value jsonb,
	c_user text,
	d_date timestamp with time zone
);

ALTER TABLE core.cd_action_log OWNER TO mobnius;

COMMENT ON TABLE core.cd_action_log IS 'Логирование действий пользователей с данными. Полная информация';

COMMENT ON COLUMN core.cd_action_log.c_table_name IS 'Имя таблицы в которой произошли изменения';

COMMENT ON COLUMN core.cd_action_log.c_operation IS 'Тип операции, INSERT, UPDATE, DELETE';

COMMENT ON COLUMN core.cd_action_log.jb_old_value IS 'Предыдущие данные';

COMMENT ON COLUMN core.cd_action_log.jb_new_value IS 'Новые данные';

COMMENT ON COLUMN core.cd_action_log.c_user IS 'Учетная запись';

COMMENT ON COLUMN core.cd_action_log.d_date IS 'Дата события';

--------------------------------------------------------------------------------

CREATE INDEX cd_action_log_c_table_name_idx ON core.cd_action_log USING btree (c_table_name);

--------------------------------------------------------------------------------

CREATE INDEX cd_action_log_d_date_idx ON core.cd_action_log USING btree (d_date DESC NULLS LAST);
