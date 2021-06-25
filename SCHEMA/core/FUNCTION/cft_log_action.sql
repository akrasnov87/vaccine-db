CREATE OR REPLACE FUNCTION core.cft_log_action() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (TG_OP = 'UPDATE') THEN
		INSERT INTO core.cd_action_log(c_table_name, c_operation, jb_old_value, jb_new_value, c_user, d_date)
		VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW), USER, clock_timestamp());
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
		INSERT INTO core.cd_action_log(c_table_name, c_operation, jb_old_value, c_user, d_date)
		VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), USER, clock_timestamp());
        RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO core.cd_action_log(c_table_name, c_operation, jb_new_value, c_user, d_date)
		VALUES (TG_TABLE_NAME, TG_OP, row_to_json(NEW), USER, clock_timestamp());
	    RETURN NEW;
    ELSE
        RETURN OLD;
	END IF;

EXCEPTION
	WHEN OTHERS
    THEN
		INSERT INTO core.cd_sys_log(d_timestamp, c_descr)
		VALUES(clock_timestamp(), 'Непредвиденная ошибка логирования');
    RETURN OLD;
END;
$$;

ALTER FUNCTION core.cft_log_action() OWNER TO mobnius;

COMMENT ON FUNCTION core.cft_log_action() IS 'Триггер. Процедура логирования действия пользователя';
