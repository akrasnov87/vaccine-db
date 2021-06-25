CREATE OR REPLACE FUNCTION core.sf_del_user(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from core.pd_userinroles
	where f_user = _id;

	delete from core.pd_users
	where id = _id;

	RETURN _id;
END
$$;

ALTER FUNCTION core.sf_del_user(_id integer) OWNER TO mobnius;

COMMENT ON FUNCTION core.sf_del_user(_id integer) IS 'Удаление пользователя';
