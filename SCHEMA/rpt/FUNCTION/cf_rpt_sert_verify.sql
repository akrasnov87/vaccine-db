CREATE OR REPLACE FUNCTION rpt.cf_rpt_sert_verify(_f_user integer) RETURNS TABLE(id uuid, c_first_name text, c_name text, d_birthday date, c_verify text, d_date date)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* params _f_user {integer} - идентификтаор пользователя
*
* @example
* [{ "action": "cf_rpt_sert_verify", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
*/
DECLARE
	_c_role text;
BEGIN
	select r.c_name into _c_role from core.pd_userinroles as uir
	inner join core.pd_users as u on uir.f_user = u.id
	inner join core.pd_roles as r on r.id = uir.f_role
	where u.id = _f_user;
	
	return query
	select 
		d.id,
		t.c_first_name,
		concat(d.c_first_name, ' ', d.c_last_name, ' ', d.c_middle_name) as c_name,
		d.d_birthday,
		case when t.b_verify then 'Достоверный' else 'Не подтверждено' end,
		t.dx_created::date
	from (SELECT i.f_user,
    i.f_document,
		  max(i.c_first_name) as c_first_name,
    max(i.d_date) AS d_date,
	max(i.dx_created) AS dx_created,
    max(i.b_verify) = 1 AS b_verify
   FROM ( SELECT d.id AS f_document,
            u.id AS f_user,
		 	u.c_first_name as c_first_name,
            f.dx_created,
		 	f.d_date,
            row_number() OVER (PARTITION BY d.id ORDER BY f.dx_created DESC) AS n_row,
			CASE
				WHEN f.b_verify THEN 1
				ELSE 0
			END AS b_verify
           FROM core.dd_documents d
             JOIN core.pd_users u ON u.id = d.f_user
             LEFT JOIN core.dd_files f ON d.id = f.f_document AND f.sn_delete = false
          WHERE case when _c_role = 'admin' then u.f_parent = _f_user else u.id = _f_user end and u.b_disabled = false AND u.sn_delete = false AND d.sn_delete = false and f.c_type = 'sert') i
  GROUP BY i.f_user, i.f_document
  ORDER BY (max(i.dx_created))) as t
  inner join core.dd_documents as d on t.f_document = d.id
  where t.b_verify = false;
END
$$;

ALTER FUNCTION rpt.cf_rpt_sert_verify(_f_user integer) OWNER TO vaccine;

COMMENT ON FUNCTION rpt.cf_rpt_sert_verify(_f_user integer) IS 'Сводный отчет о достоверности сертификата';
