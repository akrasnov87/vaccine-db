CREATE OR REPLACE FUNCTION core.cf_mui_sd_table_change(_fn_user integer, _c_version text) RETURNS TABLE(c_table_name text, n_change double precision, f_user integer)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* @params {integer} _fn_user - идентификатор пользователя
* @params {text} _c_version - текущая версия приложения
*
* @example
* [{ "action": "cf_mui_sd_table_change", "method": "Select", "data": [{ "params": [_fn_user, _c_version] }], "type": "rpc", "tid": 0 }]
*/
DECLARE
	_b_change boolean;
BEGIN
	select false into _b_change; -- значение по умолчанию

	select (case when c_value = 'true' then true else false end) into _b_change 
	from core.cd_settings
	where c_key = 'MBL_TABLE_CHANGE'
	limit 1;

	IF _b_change then 
		return query 
		select 
			tc.c_table_name,
			max(coalesce(tc.n_change, 0.0)) as n_change,
			max(tc.f_user) as f_user
		from core.sd_table_change as tc
		where tc.f_user is null or tc.f_user = _fn_user
		group by tc.c_table_name;
	else
		return query select null::text, 0.0::double precision, null::integer from core.sd_table_change as tc
		where tc.c_table_name = 'unknow';
	end if;
END
$$;

ALTER FUNCTION core.cf_mui_sd_table_change(_fn_user integer, _c_version text) OWNER TO mobnius;

COMMENT ON FUNCTION core.cf_mui_sd_table_change(_fn_user integer, _c_version text) IS 'Получение списка изменений для пользователя';
