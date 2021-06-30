CREATE OR REPLACE FUNCTION imp.sf_imp_people(_f_user integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN

    insert into core.dd_documents(c_first_name, c_last_name, c_middle_name, d_birthday, f_user, sn_delete)
	SELECT TRIM(c_first_name), TRIM(c_last_name), TRIM(c_middle_name), TO_DATE(TRIM(c_birthday),'DD.MM.YYYY'), _f_user, false
	FROM imp.cd_temp;

END;
$$;

ALTER FUNCTION imp.sf_imp_people(_f_user integer) OWNER TO postgres;

COMMENT ON FUNCTION imp.sf_imp_people(_f_user integer) IS 'Процедура переноса сотрудника';
