CREATE OR REPLACE FUNCTION core.sf_get_arm_version() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
/**
* @returns {text} версия арм
*/
DECLARE
	_ver text;
BEGIN
	SELECT c_value INTO _ver FROM core.cd_settings WHERE lower(c_key) = lower('ARM_VERSION');
	RETURN _ver;
END
$$;

ALTER FUNCTION core.sf_get_arm_version() OWNER TO vaccine;

COMMENT ON FUNCTION core.sf_get_arm_version() IS 'Версия АРМ';
