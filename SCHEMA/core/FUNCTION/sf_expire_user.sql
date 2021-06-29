CREATE OR REPLACE FUNCTION core.sf_expire_user() RETURNS void
    LANGUAGE plpgsql
    AS $$
/**
* системная функция должна выполнять от postgres
*/
BEGIN
	update core.pd_users as u
	set b_disabled = true
	from(select u.id from core.pd_userinroles as uir
	inner join core.pd_users as u on uir.f_user = u.id
	inner join core.pd_roles as r on r.id = uir.f_role
	where r.c_name = 'admin' and u.d_expired_date is not null and u.d_expired_date < now()::date) as t
	where u.id = t.id or u.f_parent = t.id;
END;
$$;

ALTER FUNCTION core.sf_expire_user() OWNER TO postgres;

COMMENT ON FUNCTION core.sf_expire_user() IS 'Процедура отлючения пользователей';
