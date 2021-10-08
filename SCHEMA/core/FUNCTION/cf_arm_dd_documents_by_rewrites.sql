CREATE OR REPLACE FUNCTION core.cf_arm_dd_documents_by_rewrites(_f_user integer) RETURNS TABLE(id uuid, f_vote uuid, c_first_name text, c_last_name text, c_middle_name text, d_birthday date, c_notice text, c_tag text, dx_created timestamp with time zone, c_rewrite_mode text, b_rewrite_qr boolean)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* @params {uuid} _f_user - идентификатор пользователя (ответственного)
*
* @example
* [{ "action": "cf_arm_dd_documents_by_rewrites", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
	return query select d.id, w.id as f_vote, d.c_first_name, d.c_last_name, d.c_middle_name, d.d_birthday, d.c_notice, d.c_tag, d.dx_created, w.c_rewrite_mode, w.b_rewrite_qr
	from core.dd_documents as d
	left join core.dd_rewrites as w on d.id = w.f_document
	where d.f_user = _f_user and d.sn_delete = false;
END
$$;

ALTER FUNCTION core.cf_arm_dd_documents_by_rewrites(_f_user integer) OWNER TO vaccine;

COMMENT ON FUNCTION core.cf_arm_dd_documents_by_rewrites(_f_user integer) IS 'Список документов по организации для переписи';
