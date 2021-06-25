CREATE TABLE core.cd_action_log_user (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	integer_id bigint,
	uuid_id uuid,
	c_action text NOT NULL,
	c_method text,
	d_date timestamp with time zone DEFAULT now() NOT NULL,
	f_user integer DEFAULT '-1'::integer NOT NULL,
	jb_data jsonb NOT NULL
);

ALTER TABLE core.cd_action_log_user OWNER TO mobnius;

COMMENT ON TABLE core.cd_action_log_user IS 'Логирование запросов пользователя';

COMMENT ON COLUMN core.cd_action_log_user.integer_id IS 'Идентификатор';

COMMENT ON COLUMN core.cd_action_log_user.uuid_id IS 'Идентификатор';

COMMENT ON COLUMN core.cd_action_log_user.c_action IS 'Имя таблицы';

COMMENT ON COLUMN core.cd_action_log_user.c_method IS 'Метод';

COMMENT ON COLUMN core.cd_action_log_user.f_user IS 'Пользователь';

--------------------------------------------------------------------------------

ALTER TABLE core.cd_action_log_user
	ADD CONSTRAINT cd_user_action_log_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.cd_action_log_user
	ADD CONSTRAINT cd_action_log_user_f_user_fkey FOREIGN KEY (f_user) REFERENCES core.pd_users(id) NOT VALID;
