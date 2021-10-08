CREATE OR REPLACE FUNCTION rpt.cf_rpt_orgs_types_by_rewrite(_f_user integer) RETURNS TABLE(c_group text, n_count bigint, n_rewrite bigint, n_rewrite_percent numeric, n_rewrite_prev bigint, n_gos_uslugi_count bigint, n_home_count bigint, n_sector_count bigint, n_rewrite_qr_count bigint)
    LANGUAGE plpgsql
    AS $$
/**
* params _f_user {integer} - идентификтаор пользователя
*
* @example
* [{ "action": "cf_rpt_orgs_types_by_rewrite", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
*/
DECLARE
	_c_role text;
BEGIN
	select r.c_name into _c_role from core.pd_userinroles as uir
	inner join core.pd_users as u on uir.f_user = u.id
	inner join core.pd_roles as r on r.id = uir.f_role
	where u.id = _f_user;
	
	create temp table t_results (
		f_org integer,
		f_group integer,
		c_group text,
		n_count integer,
		n_rewrite integer,
		n_rewrite_qr integer,
		d_date date, -- дата создания записи
		c_rewrite_mode text -- способ голосования
	) on commit drop;
	
	insert into t_results(f_org, f_group, c_group, n_count, n_rewrite, n_rewrite_qr, d_date, c_rewrite_mode)
	select 
		u.id as f_org,
		ut.id as f_group,
		ut.c_name as c_group,
		u.n_count,
		case when w.c_rewrite_mode is not null then 1 else 0 end as n_rewrite,
		case when w.b_rewrite_qr then 1 else 0 end as n_rewrite_qr,
		w.dx_date,
		w.c_rewrite_mode
	from core.dd_documents as d
	inner join core.pd_users as u on d.f_user = u.id
	inner join core.ps_user_types as ut on ut.id = u.f_type
	left join core.dd_rewrites as w on d.id = w.f_document
	where case when _c_role = 'admin' then u.f_parent = _f_user else u.id = _f_user end and d.sn_delete = false;

	CREATE INDEX t_results_f_group_idx ON t_results (f_group);
	CREATE INDEX t_results_f_group_d_date_idx ON t_results (f_group, d_date);
	CREATE INDEX t_results_f_group_c_rewrite_mode_idx ON t_results (f_group, c_rewrite_mode);

	return query select
		max(t.c_group) as c_group,
		count(*) as n_count,
		-- Приняло участие во ВПН
		sum(t.n_rewrite) as n_rewrite,
		sf_percent(sum(t.n_rewrite), max((select count(*) from t_results as i where t.f_group = i.f_group))) as n_rewrite_percent,
		(select count(*) from t_results as i where t.f_group = i.f_group and i.d_date = now()::date - interval '1 day') as n_rewrite_prev,
		-- Из них
		(select count(*) from t_results as i where t.f_group = i.f_group and i.c_rewrite_mode = 'GOS_USLUGI') as n_gos_uslugi_count,
		(select count(*) from t_results as i where t.f_group = i.f_group and i.c_rewrite_mode = 'HOME') as n_home_count,
		(select count(*) from t_results as i where t.f_group = i.f_group and i.c_rewrite_mode = 'SECTOR') as n_sector_count,
		-- Подтвержден QR код переписчиком
		sum(t.n_rewrite_qr) as n_rewrite_qr
	from t_results as t
	group by t.f_group;
END
$$;

ALTER FUNCTION rpt.cf_rpt_orgs_types_by_rewrite(_f_user integer) OWNER TO vaccine;

COMMENT ON FUNCTION rpt.cf_rpt_orgs_types_by_rewrite(_f_user integer) IS 'Сводный отчет по отраслям для организации - Перепись';
