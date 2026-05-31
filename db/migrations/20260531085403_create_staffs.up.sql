CREATE TABLE staffs (
    id UUID NOT NULL,
    store_id UUID NOT NULL,
    line_user_id TEXT NOT NULL,
    display_name TEXT NOT NULL,
    status staff_status NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT staffs_pkey PRIMARY KEY (id),
    CONSTRAINT staffs_store_id_id_key UNIQUE (store_id, id),
    CONSTRAINT staffs_store_id_line_user_id_key UNIQUE (store_id, line_user_id),
    CONSTRAINT staffs_store_id_fkey FOREIGN KEY (store_id)
        REFERENCES stores (id) ON DELETE RESTRICT,
    CONSTRAINT staffs_line_user_id_not_blank_check CHECK (btrim(line_user_id) <> ''),
    CONSTRAINT staffs_display_name_not_blank_check CHECK (btrim(display_name) <> '')
);

COMMENT ON TABLE staffs IS '店舗操作スタッフ。LINE認証主体。active/inactiveのみ管理し、勤務管理や複雑権限は持たない。';
COMMENT ON COLUMN staffs.id IS 'スタッフID。UUIDv7をGo側で生成。';
COMMENT ON COLUMN staffs.store_id IS '所属店舗ID。Store中心設計の所有者。';
COMMENT ON COLUMN staffs.line_user_id IS 'LINEユーザID。店舗内で一意。';
COMMENT ON COLUMN staffs.display_name IS '表示名。';
COMMENT ON COLUMN staffs.status IS '稼働状態 (active / inactive)。';
COMMENT ON COLUMN staffs.created_at IS '作成日時。';
COMMENT ON COLUMN staffs.updated_at IS '更新日時。';

CREATE INDEX staffs_store_id_status_idx ON staffs (store_id, status);
