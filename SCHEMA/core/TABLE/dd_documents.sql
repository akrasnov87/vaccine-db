CREATE TABLE core.dd_documents (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	n_number integer NOT NULL,
	c_fio text NOT NULL,
	d_birthday date NOT NULL,
	n_year smallint NOT NULL,
	c_document text NOT NULL,
	c_address text NOT NULL,
	d_date timestamp with time zone NOT NULL,
	c_time text NOT NULL,
	c_intent text NOT NULL,
	c_account text NOT NULL,
	c_accept text,
	c_earth text,
	d_take_off_solution date,
	d_take_off_message date,
	c_notice text,
	f_user integer NOT NULL,
	jb_child jsonb,
	sn_delete boolean NOT NULL,
	c_import_doc text,
	c_import_warning text,
	dx_created timestamp with time zone DEFAULT now()
);

ALTER TABLE core.dd_documents OWNER TO mobnius;

COMMENT ON COLUMN core.dd_documents.id IS 'Идентификатор';

COMMENT ON COLUMN core.dd_documents.n_number IS 'Номер';

COMMENT ON COLUMN core.dd_documents.c_fio IS 'Фамилия, Имя, Отчество заявителя';

COMMENT ON COLUMN core.dd_documents.d_birthday IS 'Дата рождения';

COMMENT ON COLUMN core.dd_documents.n_year IS 'Возраст на момент постановки';

COMMENT ON COLUMN core.dd_documents.c_document IS 'Реквизиты документа, удостоверяющего личность';

COMMENT ON COLUMN core.dd_documents.c_address IS 'Адрес, телефон';

COMMENT ON COLUMN core.dd_documents.d_date IS 'Дата подачи заявления';

COMMENT ON COLUMN core.dd_documents.c_time IS 'Время подачи заявления';

COMMENT ON COLUMN core.dd_documents.c_intent IS 'Цель использования земельного участка';

COMMENT ON COLUMN core.dd_documents.c_account IS 'Постановление о постановке на учет';

COMMENT ON COLUMN core.dd_documents.c_accept IS 'Дата и номер принятия решения';

COMMENT ON COLUMN core.dd_documents.c_earth IS 'Кадастровй номер земельного участка';

COMMENT ON COLUMN core.dd_documents.d_take_off_solution IS 'Решение о снятии с учета';

COMMENT ON COLUMN core.dd_documents.d_take_off_message IS 'Сообщение заявителю о снятии с учета';

COMMENT ON COLUMN core.dd_documents.c_notice IS 'Примечание';

COMMENT ON COLUMN core.dd_documents.f_user IS 'Пользователь';

COMMENT ON COLUMN core.dd_documents.jb_child IS 'Вложения';

COMMENT ON COLUMN core.dd_documents.c_import_doc IS 'Документ из которого импортировались данные';

COMMENT ON COLUMN core.dd_documents.c_import_warning IS 'Замечания после импорта';

--------------------------------------------------------------------------------

CREATE TRIGGER dd_documents_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.dd_documents
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE core.dd_documents
	ADD CONSTRAINT dd_documents_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.dd_documents
	ADD CONSTRAINT dd_documnets_f_user_fkey FOREIGN KEY (f_user) REFERENCES core.pd_users(id) NOT VALID;
