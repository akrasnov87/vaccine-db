CREATE VIEW rpt.vw_stat AS
	SELECT i.f_user,
    i.f_document,
    sum(i.n_jpg) AS n_jpg,
    sum(i.n_pdf) AS n_pdf,
    max(i.dx_created) AS dx_created
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
            row_number() OVER (PARTITION BY d.id ORDER BY f.dx_created DESC) AS n_row
           FROM ((core.dd_documents d
             JOIN core.pd_users u ON ((u.id = d.f_user)))
             JOIN core.dd_files f ON ((d.id = f.f_document)))
          WHERE ((u.b_disabled = false) AND (u.sn_delete = false) AND (d.sn_delete = false))) i
  GROUP BY i.f_user, i.f_document
 HAVING ((sum(i.n_pdf) > 0) OR (sum(i.n_jpg) > 0))
  ORDER BY (max(i.dx_created));

ALTER VIEW rpt.vw_stat OWNER TO mobnius;
