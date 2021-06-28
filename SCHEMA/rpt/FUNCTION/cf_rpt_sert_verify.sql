CREATE OR REPLACE FUNCTION rpt.cf_rpt_sert_verify(_f_user integer) RETURNS TABLE(id uuid, c_name text, d_birthday date, c_verify text, d_date date)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* params _f_user {integer} - идентификтаор пользователя
*
* @example
* [{ "action": "cf_rpt_sert_verify", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
	return query
	select 
		d.id,
		concat(d.c_first_name, ' ', d.c_last_name, ' ', d.c_middle_name) as c_name,
		d.d_birthday,
		case when t.b_verify then 'Достоверный' else 'Неподтверждён' end,
		t.dx_created::date
	from (SELECT i.f_user,
    i.f_document,
    max(i.d_date) AS d_date,
	max(i.dx_created) AS dx_created,
    max(i.b_verify) = 1 AS b_verify
   FROM ( SELECT d.id AS f_document,
            u.id AS f_user,
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
          WHERE u.b_disabled = false AND u.sn_delete = false AND d.sn_delete = false) i
  GROUP BY i.f_user, i.f_document
  ORDER BY (max(i.dx_created))) as t
  inner join core.dd_documents as d on t.f_document = d.id
  where t.b_verify = false and case when _f_user = -1 then true else _f_user = d.f_user end;
END
$$;

ALTER FUNCTION rpt.cf_rpt_sert_verify(_f_user integer) OWNER TO vaccine;

COMMENT ON FUNCTION rpt.cf_rpt_sert_verify(_f_user integer) IS 'Сводный отчет о достоверности сертификата';