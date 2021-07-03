CREATE TABLE core.dd_files (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	ba_data bytea,
	f_document uuid NOT NULL,
	dx_created timestamp with time zone DEFAULT now() NOT NULL,
	sn_delete boolean DEFAULT false,
	b_verify boolean DEFAULT false,
	c_gosuslugi_key text,
	c_type text,
	d_date date,
	c_notice text
);

ALTER TABLE core.dd_files OWNER TO vaccine;

COMMENT ON COLUMN core.dd_files.ba_data IS 'Фото';

COMMENT ON COLUMN core.dd_files.b_verify IS 'Мне для отчета и генерации в C#';

COMMENT ON COLUMN core.dd_files.c_gosuslugi_key IS 'Ключ от сертификата, если GUID.Empty, то сертификат не валиден';

COMMENT ON COLUMN core.dd_files.c_type IS 'sert(сертификат)|test(ПЦР)|med(справка)|vac(вакцинирован)';

COMMENT ON COLUMN core.dd_files.d_date IS 'Дата справки, вакцинации, медотвод';

--------------------------------------------------------------------------------

CREATE INDEX dd_files_f_document_c_type_idx ON core.dd_files USING btree (f_document, c_type);

--------------------------------------------------------------------------------

ALTER TABLE core.dd_files
	ADD CONSTRAINT dd_files_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.dd_files
	ADD CONSTRAINT dd_files_f_document_fkey FOREIGN KEY (f_document) REFERENCES core.dd_documents(id) NOT VALID;
