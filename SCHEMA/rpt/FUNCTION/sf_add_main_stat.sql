CREATE OR REPLACE FUNCTION rpt.sf_add_main_stat() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO rpt.dd_main_stat(
	f_user, n_sert, n_sert_percent, n_vaccine, n_vaccine_percent, n_pcr, n_pcr_percent, n_pcr7, n_pcr7_percent, n_med, n_med_percent, n_vote_09_2021, n_vote_09_2021_percent, n_vote, n_vote_percent, n_vote_loyal, n_vote_loyal_percent)
	select t.id, t.n_sert, t.n_sert_percent, t.n_vaccine, t.n_vaccine_percent, t.n_pcr, t.n_pcr_percent, t.n_pcr7, t.n_pcr7_percent, t.n_med, t.n_med_percent, t.n_vote_09_2021, t.n_vote_09_2021_percent, t.n_vote, t.n_vote_percent, t.n_vote_loyal, t.n_vote_loyal_percent from rpt.cf_rpt_orgs(-1) as t;
	
	INSERT INTO rpt.dd_main_type_stat(
	f_user, f_type, n_sert, n_sert_percent, n_vaccine, n_vaccine_percent, n_pcr, n_pcr_percent, n_pcr7, n_pcr7_percent, n_med, n_med_percent, n_vote_09_2021, n_vote_09_2021_percent, n_vote, n_vote_percent, n_vote_loyal, n_vote_loyal_percent)
	select t.f_parent, t.id, t.n_sert, t.n_sert_percent, t.n_vaccine, t.n_vaccine_percent, t.n_pcr, t.n_pcr_percent, t.n_pcr7, t.n_pcr7_percent, t.n_med, t.n_med_percent, t.n_vote_09_2021, t.n_vote_09_2021_percent, t.n_vote, t.n_vote_percent, t.n_vote_loyal, t.n_vote_loyal_percent from rpt.cf_rpt_orgs_types(-1) as t;
END;
$$;

ALTER FUNCTION rpt.sf_add_main_stat() OWNER TO postgres;

COMMENT ON FUNCTION rpt.sf_add_main_stat() IS 'Добавление статистики за каждый день';
