CREATE OR REPLACE FUNCTION rpt.cf_rpt_orgs_by_vote(_f_user integer) RETURNS TABLE(c_org_name text, c_group text, c_boss text, n_count bigint, n_loyal bigint, n_loyal_percent numeric, n_no_loyal bigint, n_no_loyal_percent numeric, n_plan_day1 bigint, n_loyal_day1_percent numeric, n_fact_day1 bigint, n_plan_day1_percent numeric, n_fact_day1_percent numeric, n_plan_day2 bigint, n_loyal_day2_percent numeric, n_fact_day2 bigint, n_plan_day2_percent numeric, n_fact_day2_percent numeric, n_plan_day3 bigint, n_loyal_day3_percent numeric, n_fact_day3 bigint, n_plan_day3_percent numeric, n_fact_day3_percent numeric, n_plan_all bigint, n_plan_loyal_percent numeric, n_plan_all_percent numeric)
    LANGUAGE plpgsql
    AS $$
/**
* params _f_user {integer} - идентификтаор пользователя
*
* @example
* [{ "action": "cf_rpt_orgs_by_vote", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
*/
DECLARE
	_c_role text;
BEGIN
	select r.c_name into _c_role from core.pd_userinroles as uir
	inner join core.pd_users as u on uir.f_user = u.id
	inner join core.pd_roles as r on r.id = uir.f_role
	where u.id = _f_user;

	create temp table t_results (
		f_org integer,
		c_org_name text,
		c_boss text,
		c_group text,
		n_count integer,
		n_loyal integer,
		n_no_loyal integer,
		d_date_plan date,
		d_date_fact date
	) on commit drop;
	
	insert into t_results(f_org, c_org_name, c_boss, c_group, n_count, n_loyal, n_no_loyal, d_date_plan, d_date_fact)
	select 
		u.id as f_org,
		u.c_first_name as c_org_name,
		u.c_main_user as c_boss,
		ut.c_name as c_group,
		u.n_count,
		case when v.b_loyal then 1 else 0 end as n_loyal,
		case when v.b_loyal then 0 else 1 end as n_no_loyal,
		v.d_date_plan,
		v.d_date_fact
	from core.dd_documents as d
	inner join core.pd_users as u on d.f_user = u.id
	inner join core.ps_user_types as ut on ut.id = u.f_type
	left join core.dd_votes as v on d.id = v.f_document and v.c_type = 'VOTE_2021'
	where case when _c_role = 'admin' then u.f_parent = _f_user else u.id = _f_user end and d.sn_delete = false and d.dx_created::date < '2021-09-17';

	CREATE INDEX t_results_f_org_idx ON t_results (f_org);
	CREATE INDEX t_results_f_org_d_date_plan_idx ON t_results (f_org, d_date_plan);
	CREATE INDEX t_results_f_org_d_date_fact_idx ON t_results (f_org, d_date_fact);

	return query select
	m.c_org_name,
	m.c_group,
	m.c_boss,
	m.n_count,
	-- Количество лояльных сотрудников
	m.n_loyal, -- число
	m.n_loyal_percent, -- %
	-- Количество нелояльных сотрудников
	m.n_no_loyal, -- число
	m.n_no_loyal_percent, -- %
	-- Дата голосования 17.09.2021
	m.n_plan_day1, -- План (количество)
	sf_percent(m.n_plan_day1, m.n_loyal) as n_loyal_day1_percent, -- %от числа лояльных сотрудников
	m.n_fact_day1, -- Факт  (количество)
	sf_percent(m.n_fact_day1, m.n_plan_day1) as n_plan_day1_percent, -- % от плана
	sf_percent(m.n_fact_day1, m.n_loyal) as n_fact_day1_percent, -- % от числа лояльных сотрудников
	-- Дата голосования 18.09.2021
	m.n_plan_day2, -- План (количество)
	sf_percent(m.n_plan_day2, m.n_loyal) as n_loyal_day2_percent, -- %
	m.n_fact_day2, -- Факт  (количество)
	sf_percent(m.n_fact_day2, m.n_plan_day2) as n_plan_day2_percent, -- % от плана
	sf_percent(m.n_fact_day2, m.n_loyal) as n_fact_day2_percent, -- % от числа лояльных сотрудников
	-- Дата голосования 19.09.2021
	m.n_plan_day3, -- План (количество)
	sf_percent(m.n_plan_day3, m.n_loyal) as n_loyal_day3_percent, -- %от числа лояльных сотрудников
	m.n_fact_day3, -- Факт  (количество)
	sf_percent(m.n_fact_day3, m.n_plan_day3) as n_plan_day3_percent, -- % от плана
	sf_percent(m.n_fact_day3, m.n_loyal) as n_fact_day1_percent, -- % от числа лояльных сотрудников
	--Общая явка лояльных сотрудников за 3 дня
	m.n_plan_all, -- количество
	sf_percent(m.n_plan_all, m.n_loyal) as n_plan_all_percent, -- % от лояльных сотрудников
	sf_percent(m.n_plan_all, m.n_count) as n_plan_all_percent -- % от числа сотрудников
from (
	select
		max(t.c_org_name) as c_org_name,
		max(t.c_group) as c_group,
		max(t.c_boss) as c_boss,
		-- Количество лояльных сотрудников
		(select count(*) from t_results as i where t.f_org = i.f_org) as n_count,
		sum(t.n_loyal) as n_loyal,
		sf_percent(sum(t.n_loyal), max((select count(*) from t_results as i where t.f_org = i.f_org))) as n_loyal_percent,
		-- Количество нелояльных сотрудников
		sum(t.n_no_loyal) as n_no_loyal,
		sf_percent(sum(t.n_no_loyal), max((select count(*) from t_results as i where t.f_org = i.f_org))) as n_no_loyal_percent,
		-- Дата голосования 17.09.2021
		(select count(*) from t_results as i where t.f_org = i.f_org and i.d_date_plan = '2021-09-17') as n_plan_day1, -- План (количество)
		(select count(*) from t_results as i where t.f_org = i.f_org and i.d_date_fact = '2021-09-17') as n_fact_day1, -- Факт (количество)
		-- Дата голосования 18.09.2021
		(select count(*) from t_results as i where t.f_org = i.f_org and i.d_date_plan = '2021-09-18') as n_plan_day2, -- План (количество)
		(select count(*) from t_results as i where t.f_org = i.f_org and i.d_date_fact = '2021-09-18') as n_fact_day2, -- Факт (количество)
		-- Дата голосования 19.09.2021
		(select count(*) from t_results as i where t.f_org = i.f_org and i.d_date_plan = '2021-09-19') as n_plan_day3, -- План (количество)
		(select count(*) from t_results as i where t.f_org = i.f_org and i.d_date_fact = '2021-09-19') as n_fact_day3, -- Факт (количество)
		-- за 3 дня
		(select count(*) from t_results as i where t.f_org = i.f_org and i.d_date_fact is not null) as n_plan_all -- Общая явка лояльных сотрудников за 3 дня
	from t_results as t
	group by t.f_org) as m;
END
$$;

ALTER FUNCTION rpt.cf_rpt_orgs_by_vote(_f_user integer) OWNER TO vaccine;

COMMENT ON FUNCTION rpt.cf_rpt_orgs_by_vote(_f_user integer) IS 'Сводный отчет по организациям';
