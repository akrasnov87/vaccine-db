CREATE OR REPLACE FUNCTION core.cf_arm_dd_documents_search(_txt text) RETURNS TABLE(id uuid, n_number integer, c_fio text, c_document text, c_address text, d_date date, c_account text, c_accept text, c_notice text, sn_delete boolean)
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
	    d.n_number,
	    d.c_fio,
	    d.c_document,
	    d.c_address,
		d.d_date::date,
	    d.c_account,
	    d.c_accept,
	    d.c_notice,
	    d.sn_delete
	from core.dd_documents as d
	where d.n_number::text like '%'||_txt||'%' or lower(d.c_fio) ilike '%'||_txt||'%' or lower(d.c_document) ilike '%'||_txt||'%'
	or lower(d.c_address) ilike '%'||_txt||'%' or lower(d.c_account) ilike '%'||_txt||'%' or lower(d.c_accept) ilike '%'||_txt||'%' or lower(d.c_notice) ilike '%'||_txt||'%';
END
$$;

ALTER FUNCTION core.cf_arm_dd_documents_search(_txt text) OWNER TO mobnius;

COMMENT ON FUNCTION core.cf_arm_dd_documents_search(_txt text) IS 'Поиск документа';
