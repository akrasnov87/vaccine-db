CREATE OR REPLACE FUNCTION rpt.cf_rpt_orgs_types(_f_user integer, _d_date_end date = (now())::date) RETURNS TABLE(id integer, f_parent integer, c_name text, n_count bigint, n_total numeric, n_total_prev numeric, n_total_percent numeric, n_sert numeric, n_sert_prev numeric, n_sert_percent numeric, n_vaccine numeric, n_vaccine_prev numeric, n_vaccine_percent numeric, n_pcr numeric, n_pcr_prev numeric, n_pcr_percent numeric, n_pcr7 numeric, n_pcr7_prev numeric, n_pcr7_percent numeric, n_med numeric, n_med_prev numeric, n_med_percent numeric, d_date_end date)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* params _f_user {integer} - идентификтаор пользователя
*
* @example
* [{ "action": "cf_rpt_orgs_types", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
*/
DECLARE
	_c_role text;
BEGIN
	select r.c_name into _c_role from core.pd_userinroles as uir
	inner join core.pd_users as u on uir.f_user = u.id
	inner join core.pd_roles as r on r.id = uir.f_role
	where u.id = _f_user;
	
	if _d_date_end is null then
		_d_date_end = now()::date;
	end if;
	
	return query
	with stat as(
		SELECT i.f_user,
		now()::date - max(i.d_date)::date AS n_day
		FROM ( SELECT d.id AS f_document,
					u.id AS f_user,
					f.d_date
			   FROM core.dd_documents d
			   JOIN core.pd_users u ON u.id = d.f_user
			   LEFT JOIN core.dd_files f ON d.id = f.f_document AND f.sn_delete = false
			   WHERE case when _f_user = -1 then true else (case when _c_role = 'admin' then u.f_parent = _f_user else u.id = _f_user end) end
			   and d.f_status = 3 and d.sn_delete = false and u.b_disabled = false AND u.sn_delete = false) i
	GROUP BY i.f_user, i.f_document
	ORDER BY (max(i.d_date)))
	select
		t.id,
		t.f_parent,
		max(t.c_name),
		sum(t.n_count),
		sum(t.n_sert) + sum(t.n_vaccine) as n_total,
		(sum(t.n_sert) - (select ms.n_sert from rpt.dd_main_type_stat as ms where ms.f_type = t.id and ms.f_user = _f_user and ms.dx_created = _d_date_end - '1 day'::interval)) + (sum(t.n_vaccine) - (select ms.n_vaccine from rpt.dd_main_type_stat as ms where ms.f_type = t.id and ms.f_user = _f_user and ms.dx_created = _d_date_end - '1 day'::interval)) as n_total_prev,
		sf_percent(sum(t.n_sert), sum(t.n_count)) + sf_percent(sum(t.n_vaccine), sum(t.n_count)) as n_total_percent,
		sum(t.n_sert),
		sum(t.n_sert) - (select ms.n_sert from rpt.dd_main_type_stat as ms where ms.f_type = t.id and ms.f_user = _f_user and ms.dx_created = _d_date_end - '1 day'::interval) as n_sert_prev,
		sf_percent(sum(t.n_sert), sum(t.n_count)), 
		sum(t.n_vaccine),
		sum(t.n_vaccine) - (select ms.n_vaccine from rpt.dd_main_type_stat as ms where ms.f_type = t.id and ms.f_user = _f_user and ms.dx_created = _d_date_end - '1 day'::interval) as n_vaccine_prev,
		sf_percent(sum(t.n_vaccine), sum(t.n_count)),
		sum(t.n_pcr),
		sum(t.n_pcr) - (select ms.n_pcr from rpt.dd_main_type_stat as ms where ms.f_type = t.id and ms.f_user = _f_user and ms.dx_created = _d_date_end - '1 day'::interval) as n_pcr_prev,
		sf_percent(sum(t.n_pcr), sum(t.n_count)),
		sum(t.n_pcr7),
		sum(t.n_pcr7) - (select ms.n_pcr7 from rpt.dd_main_type_stat as ms where ms.f_type = t.id and ms.f_user = _f_user and ms.dx_created = _d_date_end - '1 day'::interval) as n_pcr7_prev,
		sf_percent(sum(t.n_pcr7), sum(t.n_count)),
		sum(t.n_med),
		sum(t.n_med) - (select ms.n_med from rpt.dd_main_type_stat as ms where ms.f_type = t.id and ms.f_user = _f_user and ms.dx_created = _d_date_end - '1 day'::interval) as n_med_prev,
		sf_percent(sum(t.n_med), sum(t.n_count)),
		(_d_date_end - '1 day'::interval)::date as d_date_end
	from (select 
		ut.id,
		u.f_parent as f_parent,
		ut.n_order,
		ut.c_name,
		coalesce(u.n_count, 0) as n_count,
		(select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 1 and d.sn_delete = false) as n_sert,
		sf_percent((select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 1 and d.sn_delete = false), u.n_count) as n_sert_percent,
		(select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 2 and d.sn_delete = false) as n_vaccine,
		sf_percent((select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 2 and d.sn_delete = false), u.n_count) as n_vaccine_percent,
		(select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 3 and d.sn_delete = false) as n_pcr,
		sf_percent((select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 3 and d.sn_delete = false), u.n_count) as n_pcr_percent,
		(select count(*) from stat as s where s.f_user = u.id and s.n_day > 7) as n_pcr7,
		sf_percent((select count(*) from stat as s where s.f_user = u.id and s.n_day > 7), u.n_count) as n_pcr7_percent,
		(select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 4 and d.sn_delete = false) as n_med,
		sf_percent((select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 4 and d.sn_delete = false), u.n_count) as n_med_percent
	from core.pd_userinroles as uir
	inner join core.pd_roles as r on r.id = uir.f_role
	inner join core.pd_users as u on u.id = uir.f_user
	inner join core.ps_user_types as ut on ut.id = u.f_type
	where case when _f_user = -1 then true else (case when _c_role = 'admin' then u.f_parent = _f_user else u.id = _f_user end) end
	and u.b_disabled = false and u.sn_delete = false and r.c_name = 'user') as t
	group by t.f_parent, t.id
	order by max(t.n_order);
	--order by u.c_description, u.c_first_name;
END
$$;

ALTER FUNCTION rpt.cf_rpt_orgs_types(_f_user integer, _d_date_end date) OWNER TO vaccine;

COMMENT ON FUNCTION rpt.cf_rpt_orgs_types(_f_user integer, _d_date_end date) IS 'Сводный отчет по отраслям';
