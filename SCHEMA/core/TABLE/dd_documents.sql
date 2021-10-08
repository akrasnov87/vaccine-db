CREATE TABLE core.dd_documents (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	c_first_name text NOT NULL,
	c_last_name text NOT NULL,
	c_middle_name text NOT NULL,
	d_birthday date,
	c_notice text,
	f_user integer NOT NULL,
	c_tag text,
	sn_delete boolean NOT NULL,
	dx_created timestamp with time zone DEFAULT now(),
	f_status integer,
	d_expired_date date,
	b_vote_09_2021 boolean
);

ALTER TABLE core.dd_documents OWNER TO vaccine;

COMMENT ON COLUMN core.dd_documents.id IS 'Идентификатор';

COMMENT ON COLUMN core.dd_documents.c_first_name IS 'Фамилия';

COMMENT ON COLUMN core.dd_documents.c_last_name IS 'Имя';

COMMENT ON COLUMN core.dd_documents.c_middle_name IS 'Отчество';

COMMENT ON COLUMN core.dd_documents.d_birthday IS 'Дата рождения';

COMMENT ON COLUMN core.dd_documents.c_notice IS 'Примечание';

COMMENT ON COLUMN core.dd_documents.f_user IS 'Идентификатор муниципалитета';

COMMENT ON COLUMN core.dd_documents.dx_created IS 'Дата создания';

COMMENT ON COLUMN core.dd_documents.d_expired_date IS 'Дата истечения срока давности';

COMMENT ON COLUMN core.dd_documents.b_vote_09_2021 IS 'Принял учсатие в голосовании сентябрь 2021';

--------------------------------------------------------------------------------

CREATE INDEX dd_documents_f_user_idx ON core.dd_documents USING btree (f_user);

--------------------------------------------------------------------------------

CREATE INDEX dd_documents_f_user_f_status_idx ON core.dd_documents USING btree (f_user, f_status);

--------------------------------------------------------------------------------

CREATE INDEX dd_documents_f_user_sn_delete_b_vote_09_2021_idx ON core.dd_documents USING btree (f_user, sn_delete, b_vote_09_2021);

--------------------------------------------------------------------------------

CREATE INDEX dd_documents_sn_delete ON core.dd_documents USING btree (sn_delete);

--------------------------------------------------------------------------------

CREATE INDEX dd_documents_f_user_sn_delete_idx ON core.dd_documents USING btree (f_user, sn_delete);

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

--------------------------------------------------------------------------------

ALTER TABLE core.dd_documents
	ADD CONSTRAINT dd_documnets_f_status_fkey FOREIGN KEY (f_status) REFERENCES core.cs_document_status(id) NOT VALID;
