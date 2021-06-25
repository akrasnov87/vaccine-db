CREATE OR REPLACE FUNCTION core.sf_table_change_update(_c_table_name text, _f_user integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _c_table_name - имя таблицы
* @params {integer} _f_user - иднтификатор пользователя
*
* @returns {integer} - 0 результат выполнения
*
* @example
* [{ "action": "sf_table_change_update", "method": "Query", "data": [{ "params": [_c_table_name, _f_user] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
	IF (select count(*) from core.sd_table_change where c_table_name = _c_table_name
		and (case when _f_user is null then _f_user is null else f_user = _f_user end)) = 0 then
		INSERT INTO core.sd_table_change (c_table_name, n_change, f_user)
		VALUES (_c_table_name, (SELECT EXTRACT(EPOCH FROM now())), _f_user);
	else
		update core.sd_table_change
		set n_change = (SELECT EXTRACT(EPOCH FROM now()))
		where c_table_name = _c_table_name and f_user = _f_user;
	end if;

	RETURN 0;
END
$$;

ALTER FUNCTION core.sf_table_change_update(_c_table_name text, _f_user integer) OWNER TO postgres;
