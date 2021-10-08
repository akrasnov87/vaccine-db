CREATE TABLE core.dd_rewrites (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	f_document uuid NOT NULL,
	c_rewrite_mode text NOT NULL,
	b_rewrite_qr boolean,
	dx_created timestamp with time zone DEFAULT now() NOT NULL,
	dx_date date DEFAULT (now())::date NOT NULL
);

ALTER TABLE core.dd_rewrites OWNER TO vaccine;

COMMENT ON COLUMN core.dd_rewrites.f_document IS 'Ссылка на документ';

COMMENT ON COLUMN core.dd_rewrites.c_rewrite_mode IS 'Способ голосования: GOS_USLUGI, HOME, SECTOR';

COMMENT ON COLUMN core.dd_rewrites.b_rewrite_qr IS 'Признак подтверждения QR';

--------------------------------------------------------------------------------

CREATE INDEX dd_rewrites_f_document_c_type ON core.dd_rewrites USING btree (f_document, c_rewrite_mode);

--------------------------------------------------------------------------------

CREATE TRIGGER dd_rewrites_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.dd_rewrites
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE core.dd_rewrites
	ADD CONSTRAINT dd_rewrites_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.dd_rewrites
	ADD CONSTRAINT dd_rewrites_f_document_fkey FOREIGN KEY (f_document) REFERENCES core.dd_documents(id);
