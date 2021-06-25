CREATE TABLE core.pd_users (
	id integer DEFAULT nextval('core.auto_id_pd_users'::regclass) NOT NULL,
	c_login text NOT NULL,
	c_password text,
	s_salt text,
	s_hash text,
	c_first_name text,
	c_description text,
	b_disabled boolean DEFAULT false NOT NULL,
	sn_delete boolean DEFAULT false NOT NULL,
	c_phone text,
	c_email text
);

ALTER TABLE core.pd_users OWNER TO mobnius;

COMMENT ON TABLE core.pd_users IS 'Пользователи';

COMMENT ON COLUMN core.pd_users.id IS 'Идентификатор';

COMMENT ON COLUMN core.pd_users.c_login IS 'Логин';

COMMENT ON COLUMN core.pd_users.c_password IS 'Пароль';

COMMENT ON COLUMN core.pd_users.s_salt IS 'Salt';

COMMENT ON COLUMN core.pd_users.s_hash IS 'Hash';

COMMENT ON COLUMN core.pd_users.c_first_name IS 'Имя';

COMMENT ON COLUMN core.pd_users.c_description IS 'Описание';

COMMENT ON COLUMN core.pd_users.b_disabled IS 'Отключен';

COMMENT ON COLUMN core.pd_users.sn_delete IS 'Удален';

COMMENT ON COLUMN core.pd_users.c_phone IS 'Телефон';

COMMENT ON COLUMN core.pd_users.c_email IS 'Эл. почта';

--------------------------------------------------------------------------------

CREATE TRIGGER pd_users_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.pd_users
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

--------------------------------------------------------------------------------

CREATE TRIGGER pd_users_change_version
	AFTER INSERT OR UPDATE OR DELETE ON core.pd_users
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_table_state_change_version();

--------------------------------------------------------------------------------

ALTER TABLE core.pd_users
	ADD CONSTRAINT pd_users_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.pd_users
	ADD CONSTRAINT pd_users_uniq_c_login UNIQUE (c_login);
