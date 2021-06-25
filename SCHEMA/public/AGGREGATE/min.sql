CREATE AGGREGATE public.min(uuid) (
	SFUNC = public.min,
	STYPE = uuid
);

ALTER AGGREGATE public.min(uuid) OWNER TO postgres;
