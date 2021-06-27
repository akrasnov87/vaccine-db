CREATE VIEW rpt.vw_stat AS
	SELECT i.f_user,
    i.f_document,
    sum(i.n_jpg) AS n_jpg,
    sum(i.n_pdf) AS n_pdf,
    max(i.dx_created) AS dx_created,
    ((now())::date - (max(i.dx_created))::date) AS n_day,
    (max(i.b_ignore) = 1) AS b_ignore
   FROM ( SELECT d.id AS f_document,
            u.id AS f_user,
            u.c_first_name,
                CASE
                    WHEN (f.ba_jpg IS NULL) THEN 0
                    ELSE 1
                END AS n_jpg,
                CASE
                    WHEN (f.ba_pdf IS NULL) THEN 0
                    ELSE 1
                END AS n_pdf,
            f.dx_created,
            row_number() OVER (PARTITION BY d.id ORDER BY f.dx_created DESC) AS n_row,
                CASE
                    WHEN d.b_ignore THEN 1
                    ELSE 0
                END AS b_ignore
           FROM ((core.dd_documents d
             JOIN core.pd_users u ON ((u.id = d.f_user)))
             LEFT JOIN core.dd_files f ON (((d.id = f.f_document) AND (f.sn_delete = false))))
          WHERE ((u.b_disabled = false) AND (u.sn_delete = false) AND (d.sn_delete = false))) i
  GROUP BY i.f_user, i.f_document
  ORDER BY (max(i.dx_created));

ALTER VIEW rpt.vw_stat OWNER TO mobnius;
