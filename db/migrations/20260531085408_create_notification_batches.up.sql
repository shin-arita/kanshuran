CREATE TABLE notification_batches (
    id UUID NOT NULL,
    store_id UUID NOT NULL,
    staff_id UUID,
    title TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT notification_batches_pkey PRIMARY KEY (id),
    CONSTRAINT notification_batches_store_id_id_key UNIQUE (store_id, id),
    CONSTRAINT notification_batches_store_id_fkey FOREIGN KEY (store_id)
        REFERENCES stores (id) ON DELETE RESTRICT,
    CONSTRAINT notification_batches_store_id_staff_id_fkey
        FOREIGN KEY (store_id, staff_id)
        REFERENCES staffs (store_id, id)
        ON DELETE SET NULL (staff_id),
    CONSTRAINT notification_batches_title_not_blank_check
        CHECK (title IS NULL OR btrim(title) <> '')
);

COMMENT ON TABLE notification_batches IS 'スタッフが作成した一括送信操作単位。通知の親レコード。操作単位を記録する。';
COMMENT ON COLUMN notification_batches.id IS '通知バッチID。UUIDv7をGo側で生成。';
COMMENT ON COLUMN notification_batches.store_id IS '所属店舗ID。Store中心設計の所有者。';
COMMENT ON COLUMN notification_batches.staff_id IS '作成スタッフID。任意。Store境界複合FKで参照し、削除時は本列のみNULLとなる。';
COMMENT ON COLUMN notification_batches.title IS 'バッチタイトル。任意。';
COMMENT ON COLUMN notification_batches.created_at IS '作成日時。';
COMMENT ON COLUMN notification_batches.updated_at IS '更新日時。';

CREATE INDEX notification_batches_store_id_staff_id_idx
    ON notification_batches (store_id, staff_id);
