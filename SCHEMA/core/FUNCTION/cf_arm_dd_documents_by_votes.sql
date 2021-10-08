CREATE OR REPLACE FUNCTION core.cf_arm_dd_documents_by_votes(_f_user integer) RETURNS TABLE(id uuid, f_vote uuid, c_first_name text, c_last_name text, c_middle_name text, d_birthday date, c_notice text, c_tag text, dx_created timestamp with time zone, b_loyal boolean, d_date_plan date, d_date_fact date)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* @params {uuid} _f_user - идентификатор пользователя (ответственного)
*
* @example
* [{ "action": "cf_arm_dd_documents_by_votes", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
	return query select d.id, v.id as f_vote, d.c_first_name, d.c_last_name, d.c_middle_name, d.d_birthday, d.c_notice, d.c_tag, d.dx_created, v.b_loyal, v.d_date_plan, v.d_date_fact 
	from core.dd_documents as d
	left join core.dd_votes as v on d.id = v.f_document and v.c_type = 'VOTE_2021'
	where d.f_user = _f_user and d.sn_delete = false;
END
$$;

ALTER FUNCTION core.cf_arm_dd_documents_by_votes(_f_user integer) OWNER TO vaccine;

COMMENT ON FUNCTION core.cf_arm_dd_documents_by_votes(_f_user integer) IS 'История изменения документа';
