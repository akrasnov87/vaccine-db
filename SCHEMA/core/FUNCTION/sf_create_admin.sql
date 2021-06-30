CREATE OR REPLACE FUNCTION core.sf_create_admin(_login text, _c_first_name text, _password text, _d_expired_date date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
 * @params {text} _login - логин
 * @params {text} _c_first_name - Наименование
 * @params {text} _password - пароль
 * @params {text} _d_expired_date - дата истечения срока использования
 * 
 * @returns {integer} - иден. пользователя
 */
DECLARE
	_userId integer;
BEGIN
	insert into core.pd_users(c_login, c_password, c_first_name, d_expired_date, f_type)
	values (_login, _password, _c_first_name, _d_expired_date, 1) RETURNING id INTO _userId;
	
	perform core.pf_update_user_roles(_userId, '["admin"]'::json);
	
	RETURN _userId;
END
$$;

ALTER FUNCTION core.sf_create_admin(_login text, _c_first_name text, _password text, _d_expired_date date) OWNER TO vaccine;

COMMENT ON FUNCTION core.sf_create_admin(_login text, _c_first_name text, _password text, _d_expired_date date) IS 'Создание администратора';
