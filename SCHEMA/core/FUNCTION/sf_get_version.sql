CREATE OR REPLACE FUNCTION core.sf_get_version() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
/**
* @returns {text} версия базы данных
*/
DECLARE
	_ver text;
BEGIN
	SELECT c_value INTO _ver FROM core.cd_settings WHERE lower(c_key) = lower('DB_VERSION');
	RETURN _ver;
END
$$;

ALTER FUNCTION core.sf_get_version() OWNER TO mobnius;

COMMENT ON FUNCTION core.sf_get_version() IS 'Версия БД';
