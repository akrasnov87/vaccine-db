CREATE OR REPLACE FUNCTION core.sf_remove_outdated() RETURNS void
    LANGUAGE plpgsql
    AS $$
/**
* системная функция должна выполнять от postgres
*/
DECLARE
    _n_val      integer = 100;
    _d_data     timestamptz = date_trunc('day', now()) + '1 day'::interval; -- начало следующего дня
	_dg_cnt		integer; --diagnostic
	_dg_text	text = '';
BEGIN

    -- опрос настройки
    BEGIN
        select
            c_value::integer
        into _n_val
        from core.cd_settings
        where c_key = 'ALL_DEL_AFTER';

    --в любых непонятных ситуациях берем 100 дней
    EXCEPTION
        WHEN OTHERS
        THEN _n_val = 100;
    END;

    _d_data  = _d_data - _n_val * '1 day'::interval;

	/*delete from core.cd_action_log where d_date < _d_data;
	get diagnostics _dg_cnt = row_count;
	_dg_text = _dg_text || ' core.cd_action_log: удалено '|| _dg_cnt::text || E'\n';*/
	
	delete from core.cd_action_log_user where d_date < _d_data;
	get diagnostics _dg_cnt = row_count;
	_dg_text = _dg_text || ' core.cd_action_log_user: удалено '|| _dg_cnt::text || E'\n';

	insert into core.cd_sys_log(d_timestamp, c_descr)
	values(clock_timestamp(), 'Очистка таблиц выполнена. ' || E'\n' || _dg_text);

	EXCEPTION
	WHEN OTHERS
    THEN
		insert into core.cd_sys_log(d_timestamp, c_descr)
		values(clock_timestamp(), 'Непредвиденная ошибка очистки таблиц');

END;
$$;

ALTER FUNCTION core.sf_remove_outdated() OWNER TO postgres;

COMMENT ON FUNCTION core.sf_remove_outdated() IS 'Процедура очистки устаревших данных';
