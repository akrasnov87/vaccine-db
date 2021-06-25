CREATE TABLE core.cd_settings (
	id integer DEFAULT nextval('core.auto_id_cd_settings'::regclass) NOT NULL,
	c_key text NOT NULL,
	c_value text,
	f_type integer NOT NULL,
	c_label text,
	c_summary text,
	f_user integer,
	sn_delete boolean DEFAULT false NOT NULL,
	f_role integer
);

ALTER TABLE core.cd_settings OWNER TO mobnius;

COMMENT ON TABLE core.cd_settings IS 'Настройки';

COMMENT ON COLUMN core.cd_settings.id IS 'Идентификатор';

COMMENT ON COLUMN core.cd_settings.c_key IS 'Ключ';

COMMENT ON COLUMN core.cd_settings.c_value IS 'Значение';

COMMENT ON COLUMN core.cd_settings.f_type IS 'Тип';

COMMENT ON COLUMN core.cd_settings.c_label IS 'Заголовок';

COMMENT ON COLUMN core.cd_settings.c_summary IS 'Краткое описание';


COMMENT ON COLUMN core.cd_settings.f_user IS 'Пользователь';

COMMENT ON COLUMN core.cd_settings.sn_delete IS 'Удален';

--------------------------------------------------------------------------------

CREATE TRIGGER cd_settings_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.cd_settings
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE core.cd_settings
	ADD CONSTRAINT cd_settings_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.cd_settings
	ADD CONSTRAINT cd_settings_f_user FOREIGN KEY (f_user) REFERENCES core.pd_users(id);

--------------------------------------------------------------------------------

ALTER TABLE core.cd_settings
	ADD CONSTRAINT cd_settings_f_type FOREIGN KEY (f_type) REFERENCES core.cs_setting_types(id);
