CREATE OR REPLACE FUNCTION public.max(uuid, uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$
BEGIN
	IF $1 IS NULL OR $1 < $2 THEN
		RETURN $2;
	END IF;

	RETURN $1;
END;
$_$;

ALTER FUNCTION public.max(uuid, uuid) OWNER TO postgres;
