CREATE TABLE notification_reservations (
    id UUID NOT NULL,
    store_id UUID NOT NULL,
    notification_batch_id UUID,
    bottle_id UUID,
    message_body TEXT NOT NULL,
    scheduled_at TIMESTAMPTZ NOT NULL,
    status notification_reservation_status NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT notification_reservations_pkey PRIMARY KEY (id),
    CONSTRAINT notification_reservations_store_id_id_key UNIQUE (store_id, id),
    CONSTRAINT notification_reservations_store_id_fkey FOREIGN KEY (store_id)
        REFERENCES stores (id) ON DELETE RESTRICT,
    CONSTRAINT notification_reservations_store_id_notification_batch_id_fkey
        FOREIGN KEY (store_id, notification_batch_id)
        REFERENCES notification_batches (store_id, id)
        ON DELETE SET NULL (notification_batch_id),
    CONSTRAINT notification_reservations_store_id_bottle_id_fkey
        FOREIGN KEY (store_id, bottle_id)
        REFERENCES bottles (store_id, id)
        ON DELETE SET NULL (bottle_id),
    CONSTRAINT notification_reservations_message_body_not_blank_check
        CHECK (btrim(message_body) <> '')
);

COMMENT ON TABLE notification_reservations IS '通知予約。いつ何をどの文脈で送るかを管理する。送信結果はnotification_deliveriesで管理し、本テーブルは宛先別結果を持たない。';
COMMENT ON COLUMN notification_reservations.id IS '通知予約ID。UUIDv7をGo側で生成。';
COMMENT ON COLUMN notification_reservations.store_id IS '所属店舗ID。Store中心設計の所有者。';
COMMENT ON COLUMN notification_reservations.notification_batch_id IS '所属バッチID。任意。Store境界複合FKで参照し、削除時は本列のみNULLとなる。';
COMMENT ON COLUMN notification_reservations.bottle_id IS '対象ボトルID。任意。Store境界複合FKで参照し、削除時は本列のみNULLとなる。';
COMMENT ON COLUMN notification_reservations.message_body IS '送信メッセージ本文。';
COMMENT ON COLUMN notification_reservations.scheduled_at IS '送信予定日時。';
COMMENT ON COLUMN notification_reservations.status IS '予約状態 (pending / cancelled)。';
COMMENT ON COLUMN notification_reservations.created_at IS '作成日時。';
COMMENT ON COLUMN notification_reservations.updated_at IS '更新日時。';

CREATE INDEX notification_reservations_store_id_scheduled_at_idx
    ON notification_reservations (store_id, scheduled_at);
CREATE INDEX notification_reservations_store_id_notification_batch_id_idx
    ON notification_reservations (store_id, notification_batch_id);
CREATE INDEX notification_reservations_store_id_bottle_id_idx
    ON notification_reservations (store_id, bottle_id);
