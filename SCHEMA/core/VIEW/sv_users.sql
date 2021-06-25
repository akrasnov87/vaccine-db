CREATE VIEW core.sv_users AS
	SELECT u.id,
    u.c_login,
    u.c_first_name,
    u.c_first_name AS c_user_name,
    u.c_password,
    u.s_salt,
    u.s_hash,
    concat('.', ( SELECT string_agg(t.c_name, '.'::text) AS string_agg
           FROM ( SELECT r.c_name
                   FROM (core.pd_userinroles uir
                     JOIN core.pd_roles r ON ((uir.f_role = r.id)))
                  WHERE (uir.f_user = u.id)
                  ORDER BY r.n_weight DESC) t), '.') AS c_claims,
    u.b_disabled
   FROM core.pd_users u
  WHERE (u.sn_delete = false);

ALTER VIEW core.sv_users OWNER TO mobnius;

COMMENT ON VIEW core.sv_users IS 'Системный список пользователей';
