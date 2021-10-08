CREATE OR REPLACE FUNCTION rpt.cf_rpt_main_vote(_f_user integer, _d_date_start date = NULL::date, _d_date_end date = NULL::date) RETURNS TABLE(n_vote bigint, n_vote_percent numeric, n_vote_loyal bigint, n_vote_loyal_percent numeric, dx_created date)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* params _f_user {integer} - идентификтаор пользователя
* params _d_date_start {date} - дата начала
* params _d_date_end {date} - дата завершения
*
* @example
* [{ "action": "cf_rpt_main", "method": "Select", "data": [{ "params": [_f_user, _d_date_start, _d_date_end] }], "type": "rpc", "tid": 0 }]
*/
DECLARE
	_c_role text;
BEGIN
	select r.c_name into _c_role from core.pd_userinroles as uir
	inner join core.pd_users as u on uir.f_user = u.id
	inner join core.pd_roles as r on r.id = uir.f_role
	where u.id = _f_user;
	
	IF _c_role = 'admin' THEN
	
		return query 
		select
			sum(ms.n_vote),
			avg(ms.n_vote_percent),
			sum(ms.n_vote_loyal),
			avg(ms.n_vote_loyal_percent),
			ms.dx_created
		from rpt.dd_main_stat as ms
		inner join core.pd_users as u on u.id = ms.f_user
		where --case when _f_user = -1 then true else (
			case when _c_role = 'admin' then u.f_parent = _f_user else u.id = _f_user end
		--) end
		and case when _d_date_start is null then true else ms.dx_created >= _d_date_start end
		and case when _d_date_end is null then true else ms.dx_created <= _d_date_end end
		group by ms.dx_created
		order by ms.dx_created;
	ELSE
	return query 
		select
			sum(ms.n_vote),
			avg(ms.n_vote_percent),
			sum(ms.n_vote_loyal),
			avg(ms.n_vote_loyal_percent),
			ms.dx_created
		from rpt.dd_main_stat as ms
		inner join core.pd_users as u on u.id = ms.f_user
		where --case when _f_user = -1 then true else (
			case when _c_role = 'admin' then u.f_parent = _f_user else u.id = _f_user end
		--) end
		and case when _d_date_start is null then true else ms.dx_created >= _d_date_start end
		and case when _d_date_end is null then true else ms.dx_created <= _d_date_end end
		group by ms.f_user, ms.dx_created
		order by ms.dx_created;
	END IF;
END
$$;

ALTER FUNCTION rpt.cf_rpt_main_vote(_f_user integer, _d_date_start date, _d_date_end date) OWNER TO vaccine;

COMMENT ON FUNCTION rpt.cf_rpt_main_vote(_f_user integer, _d_date_start date, _d_date_end date) IS 'Главный сводный отчет';
