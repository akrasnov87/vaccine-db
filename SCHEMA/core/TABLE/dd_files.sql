CREATE TABLE core.dd_files (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	ba_jpg bytea,
	ba_pdf bytea,
	f_document uuid NOT NULL,
	dx_created timestamp with time zone DEFAULT now() NOT NULL,
	sn_delete boolean DEFAULT false,
	b_verify boolean DEFAULT false
);

ALTER TABLE core.dd_files OWNER TO mobnius;

COMMENT ON COLUMN core.dd_files.ba_jpg IS 'Фото ПЦР';

COMMENT ON COLUMN core.dd_files.ba_pdf IS 'PDF';

--------------------------------------------------------------------------------

CREATE INDEX dd_files_f_document_fkey ON core.dd_files USING btree (f_document);

--------------------------------------------------------------------------------

ALTER TABLE core.dd_files
	ADD CONSTRAINT dd_files_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.dd_files
	ADD CONSTRAINT dd_files_f_document_fkey FOREIGN KEY (f_document) REFERENCES core.dd_documents(id) NOT VALID;
