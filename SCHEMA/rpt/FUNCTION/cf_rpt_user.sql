CREATE OR REPLACE FUNCTION rpt.cf_rpt_user(_f_user integer) RETURNS TABLE(id uuid, f_user integer, c_name text, d_birthday date, n_sert integer, n_sert_count bigint, d_sert_date date, n_vac integer, n_vac_count bigint, d_vac_date date, n_test integer, n_test_count bigint, d_test_date date, n_day integer, n_med integer, d_expired_date date, f_status integer, c_status text)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* params _f_user {integer} - идентификатор пользователя
*
* @example
* [{ "action": "cf_rpt_user", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
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
		SELECT i.f_document,
		now()::date - max(i.d_date)::date AS n_day
		FROM ( SELECT d.id AS f_document,
			  		u.id as f_user,
					f.d_date
			   FROM core.dd_documents d
			   JOIN core.pd_users u ON u.id = d.f_user
			   LEFT JOIN core.dd_files f ON d.id = f.f_document AND f.sn_delete = false
			   WHERE case when _c_role = 'admin' then u.f_parent = _f_user else u.id = _f_user end
			   and d.f_status = 3 and d.sn_delete = false and u.b_disabled = false AND u.sn_delete = false) i
	GROUP BY i.f_user, i.f_document
	ORDER BY (max(i.d_date)))
	select
		d.id,
		d.f_user,
		concat(d.c_first_name, ' ', d.c_last_name, ' ', d.c_middle_name) as c_name,
		d.d_birthday,
		case when d.f_status = 1 then 1 else 0 end,
		(select count(*) from core.dd_files as f where f.f_document = d.id and f.c_type = 'sert' and f.sn_delete = false),
		(select f.d_date from core.dd_files as f where f.f_document = d.id and f.c_type = 'sert' and f.sn_delete = false order by f.dx_created desc limit 1),
		case when d.f_status = 2 then 1 else 0 end,
		(select count(*) from core.dd_files as f where f.f_document = d.id and f.c_type = 'vac' and f.sn_delete = false),
		(select f.d_date from core.dd_files as f where f.f_document = d.id and f.c_type = 'vac' and f.sn_delete = false order by f.dx_created desc limit 1),
		case when d.f_status = 3 then 1 else 0 end,
		(select count(*) from core.dd_files as f where f.f_document = d.id and f.c_type = 'test' and f.sn_delete = false),
		(select f.d_date from core.dd_files as f where f.f_document = d.id and f.c_type = 'test' and f.sn_delete = false order by f.dx_created desc limit 1),
		(select s.n_day from stat as s where s.f_document = d.id),
		case when d.f_status = 4 then 1 else 0 end,
		case when d.f_status = 4 then d.d_expired_date else null end,
		d.f_status,
		ds.c_name
	from core.dd_documents as d
	inner join core.pd_users as u on d.f_user = u.id
	inner join core.cs_document_status as ds on ds.id = d.f_status
	where case when _c_role = 'admin' then u.f_parent = _f_user else u.id = _f_user end
	order by d.c_first_name, d.c_last_name, d.c_middle_name, d.d_birthday;
END
$$;

ALTER FUNCTION rpt.cf_rpt_user(_f_user integer) OWNER TO vaccine;

COMMENT ON FUNCTION rpt.cf_rpt_user(_f_user integer) IS 'Отчет сотрудников';
