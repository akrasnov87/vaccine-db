CREATE OR REPLACE FUNCTION core.sf_update_version() RETURNS text
    LANGUAGE plpgsql
    AS $$
/**
* принудительное обновление
*
* @returns {text} новая версия базы данных
*
* @example
* [{ "action": "sf_update_version", "method": "Query", "data": [{ "params": [] }], "type": "rpc", "tid": 0 }]
*/
DECLARE
	_ver text;
BEGIN
	UPDATE core.cd_settings
	SET c_value = core.sf_build_version(0)
	WHERE lower(c_key) = lower('DB_VERSION');
	
	SELECT c_value INTO _ver FROM core.cd_settings WHERE lower(c_key) = lower('DB_VERSION');
	RETURN _ver;
END;
$$;

ALTER FUNCTION core.sf_update_version() OWNER TO postgres;

COMMENT ON FUNCTION core.sf_update_version() IS 'Принудительное обновление версии базу данных';
