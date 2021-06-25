CREATE TABLE core.pd_userinroles (
	id integer DEFAULT nextval('core.auto_id_pd_userinroles'::regclass) NOT NULL,
	f_user integer NOT NULL,
	f_role integer NOT NULL,
	sn_delete boolean DEFAULT false NOT NULL
);

ALTER TABLE core.pd_userinroles OWNER TO mobnius;

COMMENT ON TABLE core.pd_userinroles IS 'Пользователи в ролях';

COMMENT ON COLUMN core.pd_userinroles.id IS 'Идентификатор';

COMMENT ON COLUMN core.pd_userinroles.f_user IS 'Пользователь';

COMMENT ON COLUMN core.pd_userinroles.f_role IS 'Роль';

COMMENT ON COLUMN core.pd_userinroles.sn_delete IS 'Удален';

--------------------------------------------------------------------------------

CREATE TRIGGER pd_userinroles_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.pd_userinroles
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

--------------------------------------------------------------------------------

CREATE TRIGGER pd_userinroles_change_version
	AFTER INSERT OR UPDATE OR DELETE ON core.pd_userinroles
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_table_state_change_version();

--------------------------------------------------------------------------------

ALTER TABLE core.pd_userinroles
	ADD CONSTRAINT pd_userinroles_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.pd_userinroles
	ADD CONSTRAINT pd_userinroles_f_role_fkey FOREIGN KEY (f_role) REFERENCES core.pd_roles(id);

--------------------------------------------------------------------------------

ALTER TABLE core.pd_userinroles
	ADD CONSTRAINT pd_userinroles_f_user_fkey FOREIGN KEY (f_user) REFERENCES core.pd_users(id);
