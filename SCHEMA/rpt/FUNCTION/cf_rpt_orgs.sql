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
	with items as (
		select 
			i.f_user, 
			i.f_document, 
			sum(i.n_jpg) as n_jpg, 
			sum(i.n_pdf) as n_pdf
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
		u.id,
		u.c_first_name, 
		(select count(*) from items as i where i.f_user = u.id and i.n_pdf > 0) as n_vaccine,
		(select count(*) from items as i where i.f_user = u.id and i.n_jpg > 0) as n_pcr
	from core.pd_userinroles as uir
	inner join core.pd_roles as r on r.id = uir.f_role
	inner join core.pd_users as u on u.id = uir.f_user
	where u.b_disabled = false and u.sn_delete = false and r.c_name = 'user' and case when _f_user is null then true else _f_user = u.id end;
END
$$;

ALTER FUNCTION rpt.cf_rpt_orgs(_f_user integer) OWNER TO mobnius;

COMMENT ON FUNCTION rpt.cf_rpt_orgs(_f_user integer) IS 'Сводный отчет';
