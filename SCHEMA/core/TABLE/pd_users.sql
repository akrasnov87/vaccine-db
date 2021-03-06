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
	c_email text,
	n_count integer DEFAULT 0,
	f_parent integer,
	d_expired_date date,
	f_type integer DEFAULT 1,
	c_main_user text,
	c_version text
);

ALTER TABLE core.pd_users OWNER TO vaccine;

COMMENT ON TABLE core.pd_users IS 'Пользователи';

COMMENT ON COLUMN core.pd_users.id IS 'Идентификатор';

COMMENT ON COLUMN core.pd_users.c_login IS 'Логин';

COMMENT ON COLUMN core.pd_users.c_password IS 'Пароль';

COMMENT ON COLUMN core.pd_users.s_salt IS 'Salt';

COMMENT ON COLUMN core.pd_users.s_hash IS 'Hash';

COMMENT ON COLUMN core.pd_users.c_first_name IS 'Наименование';

COMMENT ON COLUMN core.pd_users.c_description IS 'Описание';

COMMENT ON COLUMN core.pd_users.b_disabled IS 'Отключен';

COMMENT ON COLUMN core.pd_users.sn_delete IS 'Удален';

COMMENT ON COLUMN core.pd_users.c_email IS 'Эл. почта';

COMMENT ON COLUMN core.pd_users.f_parent IS 'Родительская запись';

COMMENT ON COLUMN core.pd_users.f_type IS 'Тип организации из таблицы ps_user_types';

COMMENT ON COLUMN core.pd_users.c_main_user IS 'Куратор';

--------------------------------------------------------------------------------

CREATE INDEX pd_users_b_disabled_sn_delete_idx ON core.pd_users USING btree (b_disabled, sn_delete);

--------------------------------------------------------------------------------

CREATE INDEX pd_users_f_parent_idx ON core.pd_users USING btree (f_parent);

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
