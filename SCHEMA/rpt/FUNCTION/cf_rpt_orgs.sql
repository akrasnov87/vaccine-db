CREATE OR REPLACE FUNCTION rpt.cf_rpt_orgs(_f_user integer) RETURNS TABLE(id integer, c_name text, n_count integer, n_sert bigint, n_sert_percent numeric, n_vaccine bigint, n_vaccine_percent numeric, n_pcr bigint, n_pcr_percent numeric, n_pcr7 bigint, n_pcr7_percent numeric, n_med bigint, n_med_percent numeric)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* params _f_user {integer} - идентификтаор пользователя
*
* @example
* [{ "action": "cf_rpt_orgs", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
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
			   WHERE d.f_status = 3 and d.sn_delete = false and u.b_disabled = false AND u.sn_delete = false) i
	GROUP BY i.f_user, i.f_document
	ORDER BY (max(i.d_date)))
	select 
		u.id,
		u.c_first_name,
		u.n_count,
		(select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 1),
		sf_percent((select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 1), u.n_count),
		(select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 2),
		sf_percent((select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 2), u.n_count),
		(select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 1),
		sf_percent((select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 3), u.n_count),
		(select count(*) from stat as s where s.f_user = u.id and s.n_day > 7),
		sf_percent((select count(*) from stat as s where s.f_user = u.id and s.n_day > 7), u.n_count),
		(select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 4),
		sf_percent((select count(*) from core.dd_documents as d where d.f_user = u.id and d.f_status = 4), u.n_count)
	from core.pd_userinroles as uir
	inner join core.pd_roles as r on r.id = uir.f_role
	inner join core.pd_users as u on u.id = uir.f_user
	where u.b_disabled = false and u.sn_delete = false and r.c_name = 'user' 
	and case when _f_user = -1 then true else _f_user = u.id end
	order by u.c_description, u.c_first_name;
END
$$;

ALTER FUNCTION rpt.cf_rpt_orgs(_f_user integer) OWNER TO vaccine;

COMMENT ON FUNCTION rpt.cf_rpt_orgs(_f_user integer) IS 'Сводный отчет';
