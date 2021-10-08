CREATE TABLE core.dd_votes (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	f_document uuid NOT NULL,
	b_loyal boolean NOT NULL,
	d_date_plan date,
	d_date_fact date,
	dx_created timestamp with time zone DEFAULT now() NOT NULL,
	c_type text NOT NULL
);

ALTER TABLE core.dd_votes OWNER TO vaccine;

COMMENT ON COLUMN core.dd_votes.f_document IS 'Ссылка на документ';

COMMENT ON COLUMN core.dd_votes.b_loyal IS 'Лояльность';

COMMENT ON COLUMN core.dd_votes.d_date_plan IS 'Дата планового голосования';

COMMENT ON COLUMN core.dd_votes.d_date_fact IS 'Дата фактического голосования';

COMMENT ON COLUMN core.dd_votes.c_type IS 'Тип голосования';

--------------------------------------------------------------------------------

CREATE INDEX dd_votes_f_document_c_type ON core.dd_votes USING btree (f_document, c_type);

--------------------------------------------------------------------------------

CREATE TRIGGER dd_votes_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.dd_votes
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE core.dd_votes
	ADD CONSTRAINT dd_votes_f_document_fkey FOREIGN KEY (f_document) REFERENCES core.dd_documents(id) NOT VALID;

--------------------------------------------------------------------------------

ALTER TABLE core.dd_votes
	ADD CONSTRAINT dd_votes_pkey PRIMARY KEY (id);
