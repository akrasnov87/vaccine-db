CREATE AGGREGATE public.max(uuid) (
	SFUNC = public.max,
	STYPE = uuid
);

ALTER AGGREGATE public.max(uuid) OWNER TO postgres;
