CREATE OR REPLACE FUNCTION public.sf_percent(_n_item numeric, _n_count numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
/**
* @params {numeric} _n_item - значение
* @params {numeric} _n_count - общее количество
* @returns {numeric}
*
* @example
* [{ "action": "sf_percent", "method": "Select", "data": [{ "params": [_n_item, _n_count] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
	return (_n_item * 100) / coalesce((case when _n_count = 0 then 1 else _n_count end), 1)::numeric;
END;
$$;

ALTER FUNCTION public.sf_percent(_n_item numeric, _n_count numeric) OWNER TO "vaccine-node";

COMMENT ON FUNCTION public.sf_percent(_n_item numeric, _n_count numeric) IS 'Вычисление процента';
