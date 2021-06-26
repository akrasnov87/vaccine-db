CREATE OR REPLACE FUNCTION rpt.cf_rpt_orgs(_f_user integer) RETURNS TABLE(f_user integer, c_name text, n_vaccine bigint, n_pcr bigint)
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
	select 
		u.id,
		u.c_first_name, 
		(select count(*) from rpt.vw_stats as i where i.f_user = u.id and i.n_pdf > 0) as n_vaccine,
		(select count(*) from rpt.vw_stats as i where i.f_user = u.id and i.n_jpg > 0) as n_pcr
	from core.pd_userinroles as uir
	inner join core.pd_roles as r on r.id = uir.f_role
	inner join core.pd_users as u on u.id = uir.f_user
	where u.b_disabled = false and u.sn_delete = false and r.c_name = 'user' 
	and case when _f_user is null then true else _f_user = u.id end;
END
$$;

ALTER FUNCTION rpt.cf_rpt_orgs(_f_user integer) OWNER TO mobnius;

COMMENT ON FUNCTION rpt.cf_rpt_orgs(_f_user integer) IS 'Сводный отчет';
