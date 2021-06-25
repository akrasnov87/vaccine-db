CREATE OR REPLACE FUNCTION core.sf_create_user(_login text, _password text, _claims text, _f_subdivision integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
 * @params {text} _login - логин
 * @params {text} _password - пароль
 * @params {text} _claims - роли,  в формате JSON, например ["admin", "master"]
 * @params {integer} _f_subdivision - округ
 * 
 * @returns {integer} - иден. пользователя
 */
DECLARE
	_userId integer;
BEGIN
	insert into core.pd_users(c_login, c_password, f_subdivision)
	values (_login, _password, _f_subdivision) RETURNING id INTO _userId;
	
	perform dbo.pf_update_user_roles(_userId, _claims);
	
	RETURN _userId;
END
$$;

ALTER FUNCTION core.sf_create_user(_login text, _password text, _claims text, _f_subdivision integer) OWNER TO mobnius;

COMMENT ON FUNCTION core.sf_create_user(_login text, _password text, _claims text, _f_subdivision integer) IS 'Создание пользователя с определенными ролями';
