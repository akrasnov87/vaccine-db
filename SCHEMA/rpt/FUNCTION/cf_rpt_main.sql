CREATE OR REPLACE FUNCTION rpt.cf_rpt_main(_f_user integer) RETURNS TABLE(n_sert bigint, n_sert_percent numeric, n_vaccine bigint, n_vaccine_percent numeric, n_pcr bigint, n_pcr_percent numeric, n_pcr7 bigint, n_pcr7_percent numeric, n_med bigint, n_med_percent numeric, dx_created date)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* params _f_user {integer} - идентификтаор пользователя
*
* @example
* [{ "action": "cf_rpt_main", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
*/
DECLARE
	_c_role text;
BEGIN
	select r.c_name into _c_role from core.pd_userinroles as uir
	inner join core.pd_users as u on uir.f_user = u.id
	inner join core.pd_roles as r on r.id = uir.f_role
	where u.id = _f_user;
	
	return query 
	select * from (select
		sum(ms.n_sert),
		avg(ms.n_sert_percent),
		sum(ms.n_vaccine),
		avg(ms.n_vaccine_percent),
		sum(ms.n_pcr),
		avg(ms.n_pcr_percent),
		sum(ms.n_pcr7),
		avg(ms.n_pcr7_percent),
		sum(ms.n_med),
		avg(ms.n_med_percent),
		ms.dx_created
	from rpt.dd_main_stat as ms
	inner join core.pd_users as u on u.id = ms.f_user
	where case when _f_user = -1 then true else (case when _c_role = 'admin' then u.f_parent = _f_user else u.id = _f_user end) end
	group by ms.f_user, ms.dx_created
	order by ms.dx_created desc
	limit 60) as t order by t.dx_created asc;
END
$$;

ALTER FUNCTION rpt.cf_rpt_main(_f_user integer) OWNER TO vaccine;

COMMENT ON FUNCTION rpt.cf_rpt_main(_f_user integer) IS 'Главный сводный отчет';
