CREATE OR REPLACE FUNCTION core.cft_table_state_change_version() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	_users json;
BEGIN
	if TG_OP = 'DELETE' and to_jsonb(OLD) ? 'fn_user' then
		select concat('[{"f_user":', OLD.fn_user::text ,'}]')::json into _users;
	else
		if TG_OP != 'DELETE' and to_jsonb(NEW) ? 'fn_user' then
			select concat('[{"f_user":', NEW.fn_user::text ,'}]')::json into _users;
		else
			select '[{"f_user":null}]'::json into _users;
		end if;
	end if;
			
	perform core.sf_table_change_update(t.c_table_name_ref, (u.value#>>'{f_user}')::integer)
	from json_array_elements(_users) as u
	left join (select TG_TABLE_NAME as c_table_name_ref
				UNION
				select c_table_name_ref
				from core.sd_table_change_ref
				where c_table_name = TG_TABLE_NAME) as t on 1=1;

    RETURN null;
END
$$;

ALTER FUNCTION core.cft_table_state_change_version() OWNER TO mobnius;

COMMENT ON FUNCTION core.cft_table_state_change_version() IS 'Триггер. Обновление справочной версии';
