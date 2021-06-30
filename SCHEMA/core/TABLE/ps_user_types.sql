CREATE TABLE core.ps_user_types (
	id integer DEFAULT nextval('core.auto_id_ps_user_types'::regclass) NOT NULL,
	n_code integer,
	c_name text NOT NULL,
	c_short_name text,
	c_const text,
	n_order integer DEFAULT 0,
	b_default boolean DEFAULT false,
	b_disabled boolean DEFAULT false
);

ALTER TABLE core.ps_user_types OWNER TO vaccine;

COMMENT ON TABLE core.ps_user_types IS 'Тип настройки';

COMMENT ON COLUMN core.ps_user_types.id IS 'Идентификатор';

COMMENT ON COLUMN core.ps_user_types.n_code IS 'Код';

COMMENT ON COLUMN core.ps_user_types.c_name IS 'Наименование';

COMMENT ON COLUMN core.ps_user_types.c_short_name IS 'Краткое наименование';

COMMENT ON COLUMN core.ps_user_types.c_const IS 'Константа';

COMMENT ON COLUMN core.ps_user_types.n_order IS 'Сортировка';

COMMENT ON COLUMN core.ps_user_types.b_default IS 'По умолчанию';

COMMENT ON COLUMN core.ps_user_types.b_disabled IS 'Отключено';

--------------------------------------------------------------------------------

CREATE TRIGGER ps_user_types_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.ps_user_types
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE core.ps_user_types
	ADD CONSTRAINT ps_user_types_pkey PRIMARY KEY (id);
