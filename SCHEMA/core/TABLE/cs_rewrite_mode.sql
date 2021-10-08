CREATE TABLE core.cs_rewrite_mode (
	c_const text NOT NULL,
	c_name text
);

ALTER TABLE core.cs_rewrite_mode OWNER TO vaccine;

COMMENT ON TABLE core.cs_rewrite_mode IS 'Справочник способов голосования';

--------------------------------------------------------------------------------

ALTER TABLE core.cs_rewrite_mode
	ADD CONSTRAINT cs_rewrite_mode_pkey PRIMARY KEY (c_const);
