CREATE TABLE storage_locations (
    id UUID NOT NULL,
    store_id UUID NOT NULL,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT storage_locations_pkey PRIMARY KEY (id),
    CONSTRAINT storage_locations_store_id_id_key UNIQUE (store_id, id),
    CONSTRAINT storage_locations_store_id_name_key UNIQUE (store_id, name),
    CONSTRAINT storage_locations_store_id_fkey FOREIGN KEY (store_id)
        REFERENCES stores (id) ON DELETE RESTRICT,
    CONSTRAINT storage_locations_name_not_blank_check CHECK (btrim(name) <> '')
);

COMMENT ON TABLE storage_locations IS '保管場所語彙マスタ。ボトル探索を補助するための「棚A」「冷蔵庫」などの自由入力語彙。';
COMMENT ON COLUMN storage_locations.id IS '保管場所ID。UUIDv7をGo側で生成。';
COMMENT ON COLUMN storage_locations.store_id IS '所属店舗ID。Store中心設計の所有者。';
COMMENT ON COLUMN storage_locations.name IS '保管場所名。店舗内で一意。';
COMMENT ON COLUMN storage_locations.created_at IS '作成日時。';
COMMENT ON COLUMN storage_locations.updated_at IS '更新日時。';
