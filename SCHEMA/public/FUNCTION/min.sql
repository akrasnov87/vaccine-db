CREATE OR REPLACE FUNCTION public.min(uuid, uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$
BEGIN
    IF $2 IS NULL OR $1 > $2 THEN
        RETURN $2;
    END IF;

    RETURN $1;
END;
$_$;

ALTER FUNCTION public.min(uuid, uuid) OWNER TO postgres;
