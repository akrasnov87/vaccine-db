CREATE OR REPLACE FUNCTION rpt.cf_rpt_user_vote(_f_user integer) RETURNS TABLE(id uuid, f_user integer, c_name text, d_birthday date, n_vote integer, d_date_plan date, d_date_fact date)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* params _f_user {integer} - идентификатор пользователя
*
* @example
* [{ "action": "cf_rpt_user_vote", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
*/
DECLARE
	_c_role text;
BEGIN
	select r.c_name into _c_role from core.pd_userinroles as uir
	inner join core.pd_users as u on uir.f_user = u.id
	inner join core.pd_roles as r on r.id = uir.f_role
	where u.id = _f_user;
	
	return query select d.id, d.f_user, concat(d.c_first_name, ' ', d.c_last_name, ' ', d.c_middle_name) as c_name, 
	d.d_birthday, 
	case when v.b_loyal is not null and v.b_loyal = true then 1 else 0 end, 
	v.d_date_plan, v.d_date_fact 
	from core.dd_documents as d
	inner join core.pd_users as u on d.f_user = u.id
	left join core.dd_votes as v on d.id = v.f_document and v.c_type = 'VOTE_2021'
	where d.sn_delete = false and case when _c_role = 'admin' then u.f_parent = _f_user else u.id = _f_user end
	order by d.c_first_name, d.c_last_name, d.c_middle_name, d.d_birthday;
END
$$;

ALTER FUNCTION rpt.cf_rpt_user_vote(_f_user integer) OWNER TO vaccine;

COMMENT ON FUNCTION rpt.cf_rpt_user_vote(_f_user integer) IS 'Отчет сотрудников';
