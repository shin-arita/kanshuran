CREATE TABLE line_customers (
    id UUID NOT NULL,
    store_id UUID NOT NULL,
    line_user_id TEXT NOT NULL,
    display_name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT line_customers_pkey PRIMARY KEY (id),
    CONSTRAINT line_customers_store_id_id_key UNIQUE (store_id, id),
    CONSTRAINT line_customers_store_id_line_user_id_key UNIQUE (store_id, line_user_id),
    CONSTRAINT line_customers_store_id_fkey FOREIGN KEY (store_id)
        REFERENCES stores (id) ON DELETE RESTRICT,
    CONSTRAINT line_customers_line_user_id_not_blank_check CHECK (btrim(line_user_id) <> ''),
    CONSTRAINT line_customers_display_name_not_blank_check CHECK (btrim(display_name) <> '')
);

COMMENT ON TABLE line_customers IS 'LINE連携済み顧客。マイキープ確認とLINE通知受信が可能。Customer/GuestCustomerという名称は用いない。';
COMMENT ON COLUMN line_customers.id IS 'LINE顧客ID。UUIDv7をGo側で生成。';
COMMENT ON COLUMN line_customers.store_id IS '所属店舗ID。Store中心設計の所有者。';
COMMENT ON COLUMN line_customers.line_user_id IS 'LINEユーザID。店舗内で一意。';
COMMENT ON COLUMN line_customers.display_name IS '表示名。';
COMMENT ON COLUMN line_customers.created_at IS '作成日時。';
COMMENT ON COLUMN line_customers.updated_at IS '更新日時。';
