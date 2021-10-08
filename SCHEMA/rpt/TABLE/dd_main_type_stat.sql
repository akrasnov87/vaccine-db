CREATE TABLE rpt.dd_main_type_stat (
	id integer NOT NULL,
	f_user integer,
	n_sert integer,
	n_sert_percent numeric,
	n_vaccine integer,
	n_vaccine_percent numeric,
	n_pcr integer,
	n_pcr_percent numeric,
	n_pcr7 integer,
	n_pcr7_percent numeric,
	n_med integer,
	n_med_percent numeric,
	dx_created date DEFAULT (now())::date,
	f_type integer,
	n_vote_09_2021 integer,
	n_vote_09_2021_percent numeric,
	n_vote_loyal integer,
	n_vote_loyal_percent numeric,
	n_vote integer,
	n_vote_percent numeric
);

ALTER TABLE rpt.dd_main_type_stat ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
	SEQUENCE NAME rpt.dd_main_type_stat_id_seq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1
);

ALTER TABLE rpt.dd_main_type_stat OWNER TO vaccine;

COMMENT ON TABLE rpt.dd_main_type_stat IS 'Сводная статистика';

--------------------------------------------------------------------------------

ALTER TABLE rpt.dd_main_type_stat
	ADD CONSTRAINT dd_main_type_stat_f_user_fkey FOREIGN KEY (f_user) REFERENCES core.pd_users(id);

--------------------------------------------------------------------------------

ALTER TABLE rpt.dd_main_type_stat
	ADD CONSTRAINT dd_main_type_stat_pkey PRIMARY KEY (id);
