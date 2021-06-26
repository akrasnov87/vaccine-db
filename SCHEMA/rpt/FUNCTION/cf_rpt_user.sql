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
	with items as (
		select 
			i.f_user, 
			i.f_document, 
			sum(i.n_jpg) as n_jpg, 
			sum(i.n_pdf) as n_pdf,
			max(i.dx_created) as dx_created
		from (select
				d.id as f_document,
				u.id as f_user,
				u.c_first_name,
				case when f.ba_jpg is null then 0 else 1 end as n_jpg,
				case when f.ba_pdf is null then 0 else 1 end as n_pdf,
				f.dx_created,
				row_number() over(partition by d.id order by f.dx_created desc) as n_row
			from core.dd_documents as d 
			inner join core.pd_users as u on u.id = d.f_user
			inner join core.dd_files as f on d.id = f.f_document
			where u.b_disabled = false and u.sn_delete = false and d.sn_delete = false) as i 
		group by i.f_user, i.f_document 
		having sum(i.n_pdf) > 0 or sum(i.n_jpg) > 0)
	select
		d.id,
		d.f_user,
		concat(d.c_first_name, ' ', d.c_last_name, ' ', d.c_middle_name) as c_name,
		d.d_birthday,
		case when i.n_pdf > 0 then 1 else 0 end as n_pdf,
		case when i.n_pdf > 0 then i.dx_created else null end as d_pdf_date,
		case when i.n_jpg > 0 then 1 else 0 end as n_jpg,
		case when i.n_jpg > 0 then i.dx_created else null end as d_jpg_date
	from items as i
	inner join core.dd_documents as d on d.id = i.f_document;
END
$$;

ALTER FUNCTION rpt.cf_rpt_user(_f_user integer) OWNER TO mobnius;

COMMENT ON FUNCTION rpt.cf_rpt_user(_f_user integer) IS 'Отчет сотрудников';
