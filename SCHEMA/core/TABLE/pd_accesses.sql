CREATE TABLE core.pd_accesses (
	id integer DEFAULT nextval('core.auto_id_pd_accesses'::regclass) NOT NULL,
	f_user integer,
	f_role integer,
	c_name text,
	c_criteria text,
	c_path text,
	c_function text,
	c_columns text,
	b_deletable boolean DEFAULT false NOT NULL,
	b_creatable boolean DEFAULT false NOT NULL,
	b_editable boolean DEFAULT false NOT NULL,
	b_full_control boolean DEFAULT false NOT NULL,
	sn_delete boolean DEFAULT false NOT NULL
);

ALTER TABLE core.pd_accesses OWNER TO mobnius;

REVOKE ALL ON TABLE core.pd_accesses FROM mobnius;
GRANT SELECT ON TABLE core.pd_accesses TO mobnius WITH GRANT OPTION;

COMMENT ON TABLE core.pd_accesses IS 'Права доступа';

COMMENT ON COLUMN core.pd_accesses.id IS 'Идентификатор';

COMMENT ON COLUMN core.pd_accesses.f_user IS 'Пользователь';

COMMENT ON COLUMN core.pd_accesses.f_role IS 'Роль';

COMMENT ON COLUMN core.pd_accesses.c_name IS 'Табл./Предст./Функц.';

COMMENT ON COLUMN core.pd_accesses.c_criteria IS 'Серверный фильтр';

COMMENT ON COLUMN core.pd_accesses.c_path IS 'Путь в файловой системе';

COMMENT ON COLUMN core.pd_accesses.c_function IS 'Функция RPC или её часть';

COMMENT ON COLUMN core.pd_accesses.c_columns IS 'Запрещенные колонки';

COMMENT ON COLUMN core.pd_accesses.b_deletable IS 'Разрешено удалени';

COMMENT ON COLUMN core.pd_accesses.b_creatable IS 'Разрешено создание';

COMMENT ON COLUMN core.pd_accesses.b_editable IS 'Разрешено редактирование';

COMMENT ON COLUMN core.pd_accesses.b_full_control IS 'Дополнительный доступ';

COMMENT ON COLUMN core.pd_accesses.sn_delete IS 'Удален';

--------------------------------------------------------------------------------

CREATE TRIGGER pd_accesses_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.pd_accesses
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

--------------------------------------------------------------------------------

CREATE TRIGGER pd_accesses_change_version
	AFTER INSERT OR UPDATE OR DELETE ON core.pd_accesses
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_table_state_change_version();

--------------------------------------------------------------------------------

ALTER TABLE core.pd_accesses
	ADD CONSTRAINT pd_accesses_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.pd_accesses
	ADD CONSTRAINT pd_accesses_f_role FOREIGN KEY (f_role) REFERENCES core.pd_roles(id);

--------------------------------------------------------------------------------

ALTER TABLE core.pd_accesses
	ADD CONSTRAINT pd_accesses_f_user FOREIGN KEY (f_user) REFERENCES core.pd_users(id);
