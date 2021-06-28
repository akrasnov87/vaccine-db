CREATE TABLE core.cs_document_status (
	id integer DEFAULT nextval('core.auto_id_cs_document_status'::regclass) NOT NULL,
	n_code integer,
	c_name text NOT NULL,
	c_short_name text,
	c_const text NOT NULL,
	n_order integer DEFAULT 0,
	b_default boolean DEFAULT false NOT NULL,
	b_disabled boolean DEFAULT false NOT NULL
);

ALTER TABLE core.cs_document_status OWNER TO vaccine;

COMMENT ON TABLE core.cs_document_status IS 'Статус документа';

COMMENT ON COLUMN core.cs_document_status.id IS 'Идентификатор';

COMMENT ON COLUMN core.cs_document_status.n_code IS 'Код';

COMMENT ON COLUMN core.cs_document_status.c_name IS 'Наименование';

COMMENT ON COLUMN core.cs_document_status.c_short_name IS 'Краткое наименование';

COMMENT ON COLUMN core.cs_document_status.c_const IS 'Константа';

COMMENT ON COLUMN core.cs_document_status.n_order IS 'Сортировка';

COMMENT ON COLUMN core.cs_document_status.b_default IS 'По умолчанию';

COMMENT ON COLUMN core.cs_document_status.b_disabled IS 'Отключено';

--------------------------------------------------------------------------------

CREATE TRIGGER cs_document_status_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.cs_document_status
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE core.cs_document_status
	ADD CONSTRAINT cs_document_status_pkey PRIMARY KEY (id);
