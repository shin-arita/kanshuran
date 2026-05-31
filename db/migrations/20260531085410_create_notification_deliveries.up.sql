CREATE TABLE notification_deliveries (
    id UUID NOT NULL,
    store_id UUID NOT NULL,
    notification_reservation_id UUID NOT NULL,
    line_customer_id UUID NOT NULL,
    status notification_delivery_status NOT NULL,
    sent_at TIMESTAMPTZ,
    failed_at TIMESTAMPTZ,
    error_message TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT notification_deliveries_pkey PRIMARY KEY (id),
    CONSTRAINT notification_deliveries_reservation_customer_key
        UNIQUE (notification_reservation_id, line_customer_id),
    CONSTRAINT notification_deliveries_store_id_fkey FOREIGN KEY (store_id)
        REFERENCES stores (id) ON DELETE RESTRICT,
    CONSTRAINT notification_deliveries_store_id_reservation_id_fkey
        FOREIGN KEY (store_id, notification_reservation_id)
        REFERENCES notification_reservations (store_id, id) ON DELETE RESTRICT,
    CONSTRAINT notification_deliveries_store_id_line_customer_id_fkey
        FOREIGN KEY (store_id, line_customer_id)
        REFERENCES line_customers (store_id, id) ON DELETE RESTRICT,
    CONSTRAINT notification_deliveries_error_message_not_blank_check
        CHECK (error_message IS NULL OR btrim(error_message) <> '')
);

COMMENT ON TABLE notification_deliveries IS '宛先別通知送信状態。LINE送信結果を管理し、(notification_reservation_id, line_customer_id) UNIQUEで二重送信を防止する。';
COMMENT ON COLUMN notification_deliveries.id IS '通知送信ID。UUIDv7をGo側で生成。';
COMMENT ON COLUMN notification_deliveries.store_id IS '所属店舗ID。Store中心設計の所有者。';
COMMENT ON COLUMN notification_deliveries.notification_reservation_id IS '通知予約ID。Store境界複合FKで参照する。';
COMMENT ON COLUMN notification_deliveries.line_customer_id IS '宛先LINE顧客ID。Store境界複合FKで参照する。';
COMMENT ON COLUMN notification_deliveries.status IS '送信状態 (pending / sent / failed / cancelled)。';
COMMENT ON COLUMN notification_deliveries.sent_at IS '送信完了日時。任意。';
COMMENT ON COLUMN notification_deliveries.failed_at IS '送信失敗日時。任意。';
COMMENT ON COLUMN notification_deliveries.error_message IS '送信失敗時のエラーメッセージ。任意。';
COMMENT ON COLUMN notification_deliveries.created_at IS '作成日時。';
COMMENT ON COLUMN notification_deliveries.updated_at IS '更新日時。';

CREATE INDEX notification_deliveries_store_id_status_idx
    ON notification_deliveries (store_id, status);
CREATE INDEX notification_deliveries_store_id_reservation_id_idx
    ON notification_deliveries (store_id, notification_reservation_id);
CREATE INDEX notification_deliveries_store_id_line_customer_id_idx
    ON notification_deliveries (store_id, line_customer_id);
