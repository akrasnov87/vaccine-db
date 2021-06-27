CREATE OR REPLACE FUNCTION rpt.cf_rpt_user(_f_user integer) RETURNS TABLE(f_document uuid, f_user integer, c_name text, d_birthday date, n_pdf integer, d_pdf_date timestamp with time zone, n_jpg integer, d_jpg_date timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* params _f_user {integer} - идентификатор пользователя
*
* @example
* [{ "action": "cf_rpt_user", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
	return query
	select
		d.id,
		d.f_user,
		concat(d.c_first_name, ' ', d.c_last_name, ' ', d.c_middle_name) as c_name,
		d.d_birthday,
		case when i.n_pdf > 0 then 1 else 0 end as n_pdf,
		case when i.n_pdf > 0 then i.dx_created else null end as d_pdf_date,
		case when i.n_jpg > 0 then 1 else 0 end as n_jpg,
		case when i.n_jpg > 0 then i.dx_created else null end as d_jpg_date
	from rpt.vw_stat as i
	inner join core.dd_documents as d on d.id = i.f_document
	where case when _f_user is null then true else i.f_user = _f_user end
	order by i.dx_created;
END
$$;

ALTER FUNCTION rpt.cf_rpt_user(_f_user integer) OWNER TO mobnius;

COMMENT ON FUNCTION rpt.cf_rpt_user(_f_user integer) IS 'Отчет сотрудников';