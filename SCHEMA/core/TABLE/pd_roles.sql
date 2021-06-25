CREATE TABLE core.pd_roles (
	id integer DEFAULT nextval('core.auto_id_pd_roles'::regclass) NOT NULL,
	c_name text NOT NULL,
	c_description text,
	n_weight integer NOT NULL,
	sn_delete boolean DEFAULT false NOT NULL
);

ALTER TABLE core.pd_roles OWNER TO mobnius;

COMMENT ON TABLE core.pd_roles IS 'Роли';

COMMENT ON COLUMN core.pd_roles.id IS 'Идентификатор';

COMMENT ON COLUMN core.pd_roles.c_name IS 'Наименование';

COMMENT ON COLUMN core.pd_roles.c_description IS 'Описание роли';

COMMENT ON COLUMN core.pd_roles.n_weight IS 'Приоритет';

COMMENT ON COLUMN core.pd_roles.sn_delete IS 'Удален';

--------------------------------------------------------------------------------

CREATE TRIGGER pd_roles_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.pd_roles
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE core.pd_roles
	ADD CONSTRAINT pd_roles_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.pd_roles
	ADD CONSTRAINT pd_roles_uniq_c_name UNIQUE (c_name);
