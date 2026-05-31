CREATE TABLE bottles (
    id UUID NOT NULL,
    store_id UUID NOT NULL,
    storage_location_id UUID,
    brand_name TEXT NOT NULL,
    owner_name TEXT,
    owner_note TEXT,
    remaining_level bottle_remaining_level NOT NULL,
    status bottle_status NOT NULL,
    expires_at TIMESTAMPTZ,
    photo_1_storage_key TEXT,
    photo_2_storage_key TEXT,
    photo_3_storage_key TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT bottles_pkey PRIMARY KEY (id),
    CONSTRAINT bottles_store_id_id_key UNIQUE (store_id, id),
    CONSTRAINT bottles_store_id_fkey FOREIGN KEY (store_id)
        REFERENCES stores (id) ON DELETE RESTRICT,
    CONSTRAINT bottles_store_id_storage_location_id_fkey
        FOREIGN KEY (store_id, storage_location_id)
        REFERENCES storage_locations (store_id, id)
        ON DELETE SET NULL (storage_location_id),
    CONSTRAINT bottles_brand_name_not_blank_check CHECK (btrim(brand_name) <> ''),
    CONSTRAINT bottles_owner_name_not_blank_check
        CHECK (owner_name IS NULL OR btrim(owner_name) <> ''),
    CONSTRAINT bottles_owner_note_not_blank_check
        CHECK (owner_note IS NULL OR btrim(owner_note) <> ''),
    CONSTRAINT bottles_photo_1_storage_key_not_blank_check
        CHECK (photo_1_storage_key IS NULL OR btrim(photo_1_storage_key) <> ''),
    CONSTRAINT bottles_photo_2_storage_key_not_blank_check
        CHECK (photo_2_storage_key IS NULL OR btrim(photo_2_storage_key) <> ''),
    CONSTRAINT bottles_photo_3_storage_key_not_blank_check
        CHECK (photo_3_storage_key IS NULL OR btrim(photo_3_storage_key) <> '')
);

COMMENT ON TABLE bottles IS 'ボトルキープ実体。Keep独立テーブルは作らない。LINE未連携客の情報はowner_name/owner_noteに保持。写真3枚をstorage_keyとして保持。';
COMMENT ON COLUMN bottles.id IS 'ボトルID。UUIDv7をGo側で生成。';
COMMENT ON COLUMN bottles.store_id IS '所属店舗ID。Store中心設計の所有者。';
COMMENT ON COLUMN bottles.storage_location_id IS '保管場所ID。任意。Store境界複合FKで参照し、削除時は本列のみNULLとなる。';
COMMENT ON COLUMN bottles.brand_name IS '銘柄名。';
COMMENT ON COLUMN bottles.owner_name IS '所有客名 (LINE未連携客向け)。任意。';
COMMENT ON COLUMN bottles.owner_note IS '所有客メモ (LINE未連携客向け)。任意。';
COMMENT ON COLUMN bottles.remaining_level IS '残量レベル (many / low / very_low)。';
COMMENT ON COLUMN bottles.status IS 'ボトル状態 (stored / finished)。';
COMMENT ON COLUMN bottles.expires_at IS 'キープ期限。任意。';
COMMENT ON COLUMN bottles.photo_1_storage_key IS '写真1のストレージキー。任意。';
COMMENT ON COLUMN bottles.photo_2_storage_key IS '写真2のストレージキー。任意。';
COMMENT ON COLUMN bottles.photo_3_storage_key IS '写真3のストレージキー。任意。';
COMMENT ON COLUMN bottles.created_at IS '作成日時。';
COMMENT ON COLUMN bottles.updated_at IS '更新日時。';

CREATE INDEX bottles_store_id_status_idx ON bottles (store_id, status);
CREATE INDEX bottles_store_id_storage_location_id_idx ON bottles (store_id, storage_location_id);
CREATE INDEX bottles_brand_name_pgroonga_idx ON bottles USING pgroonga (brand_name);
CREATE INDEX bottles_owner_name_pgroonga_idx ON bottles USING pgroonga (owner_name);
