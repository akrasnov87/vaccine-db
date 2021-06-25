CREATE VIEW core.pv_users AS
	SELECT u.id,
    u.c_login,
    concat('.', ( SELECT string_agg(t.c_name, '.'::text) AS string_agg
           FROM ( SELECT r.c_name
                   FROM (core.pd_userinroles uir
                     JOIN core.pd_roles r ON ((uir.f_role = r.id)))
                  WHERE (uir.f_user = u.id)
                  ORDER BY r.n_weight DESC) t), '.') AS c_claims,
    u.c_description,
    u.c_first_name,
    u.c_phone,
    u.c_email,
    u.b_disabled
   FROM core.pd_users u
  WHERE (u.sn_delete = false);

ALTER VIEW core.pv_users OWNER TO mobnius;

COMMENT ON VIEW core.pv_users IS 'Открытый список пользователей';
