CREATE OR REPLACE FUNCTION rpt.cf_rpt_orgs_types(_f_user integer) RETURNS TABLE(id integer, f_parent integer, c_name text, n_count bigint, n_sert numeric, n_sert_percent numeric, n_vaccine numeric, n_vaccine_percent numeric, n_pcr numeric, n_pcr_percent numeric, n_pcr7 numeric, n_pcr7_percent numeric, n_med numeric, n_med_percent numeric)
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
		sum(t.n_sert),
		avg(t.n_sert_percent),
		sum(t.n_vaccine),
		avg(t.n_vaccine_percent),
		sum(t.n_pcr),
		avg(t.n_pcr_percent),
		sum(t.n_pcr7),
		avg(t.n_pcr7_percent),
		sum(t.n_med),
		avg(t.n_med_percent)
	from (select 
		ut.id,
		u.f_parent as f_parent,
		ut.n_order,
		ut.c_name,
		coalesce(u.n_count, 0) as n_count,
		(select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 1) as n_sert,
		sf_percent((select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 1), u.n_count) as n_sert_percent,
		(select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 2) as n_vaccine,
		sf_percent((select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 2), u.n_count) as n_vaccine_percent,
		(select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 3) as n_pcr,
		sf_percent((select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 3), u.n_count) as n_pcr_percent,
		(select count(*) from stat as s where s.f_user = u.id and s.n_day > 7) as n_pcr7,
		sf_percent((select count(*) from stat as s where s.f_user = u.id and s.n_day > 7), u.n_count) as n_pcr7_percent,
		(select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 4) as n_med,
		sf_percent((select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 4), u.n_count) as n_med_percent
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

ALTER FUNCTION rpt.cf_rpt_orgs_types(_f_user integer) OWNER TO vaccine;

COMMENT ON FUNCTION rpt.cf_rpt_orgs_types(_f_user integer) IS 'Сводный отчет по отраслям';
