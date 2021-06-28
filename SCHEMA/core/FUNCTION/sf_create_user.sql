CREATE OR REPLACE FUNCTION core.sf_create_user(_login text, _c_first_name text, _password text, _claims text, _c_description text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
 * @params {text} _login - логин
 * @params {text} _c_first_name - Наименование
 * @params {text} _password - пароль
 * @params {text} _claims - роли,  в формате JSON, например ["admin", "master"]
 * @params {text} _c_description - примечание
 * 
 * @returns {integer} - иден. пользователя
 */
DECLARE
	_userId integer;
BEGIN
	insert into core.pd_users(c_login, c_password, c_first_name, c_description)
	values (_login, _password, _c_first_name, _c_description) RETURNING id INTO _userId;
	
	perform core.pf_update_user_roles(_userId, _claims::json);
	
	RETURN _userId;
END
$$;

ALTER FUNCTION core.sf_create_user(_login text, _c_first_name text, _password text, _claims text, _c_description text) OWNER TO vaccine;

COMMENT ON FUNCTION core.sf_create_user(_login text, _c_first_name text, _password text, _claims text, _c_description text) IS 'Создание пользователя с определенными ролями';
