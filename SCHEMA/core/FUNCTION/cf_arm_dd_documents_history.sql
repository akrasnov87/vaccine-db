CREATE OR REPLACE FUNCTION core.cf_arm_dd_documents_history(_id uuid) RETURNS TABLE(c_operation text, jb_old_value jsonb, jb_new_value jsonb, d_date timestamp with time zone, f_user integer, c_user text)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* @params {uuid} _id - идентификатор
*
* @example
* [{ "action": "cf_arm_dd_documents_history", "method": "Select", "data": [{ "params": [_id] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
	return query select l.c_operation, l.jb_old_value, l.jb_new_value, l.d_date, u.id, u.c_login
	from core.cd_action_log as l
	left join core.pd_users as u on (l.jb_new_value->>'f_user')::integer = u.id
	where l.c_table_name = 'dd_documents' and (l.jb_new_value->>'id') = _id::text
	order by l.d_date desc;
END
$$;

ALTER FUNCTION core.cf_arm_dd_documents_history(_id uuid) OWNER TO mobnius;

COMMENT ON FUNCTION core.cf_arm_dd_documents_history(_id uuid) IS 'История изменнения документа';
