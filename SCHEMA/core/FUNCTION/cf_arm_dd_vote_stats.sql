CREATE OR REPLACE FUNCTION core.cf_arm_dd_vote_stats(_f_user integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_user - идентификатор пользователя (ответственного)
*
* @example
* [{ "action": "cf_arm_dd_vote_stats", "method": "Select", "data": [{ "params": [_f_user] }], "type": "rpc", "tid": 0 }]
*/
DECLARE
	_n_all_vote bigint; -- всего проголосовало
	_n_plan_vote bigint; -- ожидаю голосования сегодня
	_n_wait_vote bigint; -- ожидаю голосования
	
	_c_tech text;
BEGIN
	select count(*) into _n_all_vote
	from core.dd_documents as d
	left join core.dd_votes as v on d.id = v.f_document and v.c_type = 'VOTE_2021'
	where d.f_user = _f_user and d.sn_delete = false and v.d_date_fact is not null;
	
	select count(*) into _n_wait_vote
	from core.dd_documents as d
	left join core.dd_votes as v on d.id = v.f_document and v.c_type = 'VOTE_2021'
	where d.f_user = _f_user and d.sn_delete = false and v.d_date_fact is null and v.d_date_plan is not null;
	
	select count(*) into _n_plan_vote
	from core.dd_documents as d
	left join core.dd_votes as v on d.id = v.f_document and v.c_type = 'VOTE_2021'
	where d.f_user = _f_user and d.sn_delete = false and v.d_date_fact is null and v.d_date_plan = now()::date;
	
	select concat('<p>Техническая поддержка:<br />Telegram канал: <a href="https://t.me/joinchat/r-zS1ePBs2k3ZGFi">https://t.me/joinchat/r-zS1ePBs2k3ZGFi</a><br />Телефон: <a href="tel:+79613399624">+79613399624</a></p>') into _c_tech;
	
	return concat('<p><b>Всего проголосовало:</b> ', _n_all_vote, '<br /><b>Должно проголосовать сегодня:</b> ', _n_plan_vote, '<br /><b>Всего должно проголосовать:</b> ', _n_wait_vote, '</p>', _c_tech);
END
$$;

ALTER FUNCTION core.cf_arm_dd_vote_stats(_f_user integer) OWNER TO vaccine;

COMMENT ON FUNCTION core.cf_arm_dd_vote_stats(_f_user integer) IS 'Вывод статистики по голосованию';
