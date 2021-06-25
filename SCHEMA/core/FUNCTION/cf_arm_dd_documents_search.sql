CREATE OR REPLACE FUNCTION core.cf_arm_dd_documents_search(_txt text) RETURNS TABLE(id uuid, c_first_name text, c_last_name text, c_middle_name text, d_birthday date, c_address_reg text, c_address_life text, c_notice text, sn_delete boolean, c_tag text)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* @params {uuid} _txt - текст для поиска
*
* @example
* [{ "action": "cf_arm_dd_documents_search", "method": "Select", "data": [{ "params": [_txt] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
	return query 
	select d.id,
	    d.c_first_name,
	    d.c_last_name,
	    d.c_middle_name,
		d.d_birthday,
	    d.c_notice,
	    d.sn_delete,
		d.c_tag
	from core.dd_documents as d
	where d.c_first_name ilike '%'||_txt||'%' or d.c_last_name ilike '%'||_txt||'%' or d.c_middle_name ilike '%'||_txt||'%'
	or d.c_notice ilike '%'||_txt||'%'
	order by d.dx_created desc;
END
$$;

ALTER FUNCTION core.cf_arm_dd_documents_search(_txt text) OWNER TO mobnius;

COMMENT ON FUNCTION core.cf_arm_dd_documents_search(_txt text) IS 'Поиск документа';
