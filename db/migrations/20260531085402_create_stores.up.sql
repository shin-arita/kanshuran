CREATE TABLE stores (
    id UUID NOT NULL,
    name TEXT NOT NULL,
    default_expire_days INTEGER NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT stores_pkey PRIMARY KEY (id),
    CONSTRAINT stores_name_not_blank_check CHECK (btrim(name) <> ''),
    CONSTRAINT stores_default_expire_days_positive_check CHECK (default_expire_days > 0)
);

COMMENT ON TABLE stores IS '店舗。全データの所有者であり、期限ポリシーを保持する。';
COMMENT ON COLUMN stores.id IS '店舗ID。UUIDv7をGo側で生成。';
COMMENT ON COLUMN stores.name IS '店舗名。';
COMMENT ON COLUMN stores.default_expire_days IS 'キープ既定有効日数。店舗ごとの期限ポリシー。';
COMMENT ON COLUMN stores.created_at IS '作成日時。';
COMMENT ON COLUMN stores.updated_at IS '更新日時。';
