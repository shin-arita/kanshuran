CREATE TABLE bottle_line_customers (
    store_id UUID NOT NULL,
    bottle_id UUID NOT NULL,
    line_customer_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT bottle_line_customers_pkey PRIMARY KEY (bottle_id, line_customer_id),
    CONSTRAINT bottle_line_customers_store_id_bottle_id_fkey
        FOREIGN KEY (store_id, bottle_id)
        REFERENCES bottles (store_id, id) ON DELETE CASCADE,
    CONSTRAINT bottle_line_customers_store_id_line_customer_id_fkey
        FOREIGN KEY (store_id, line_customer_id)
        REFERENCES line_customers (store_id, id) ON DELETE CASCADE
);

COMMENT ON TABLE bottle_line_customers IS 'BottleとLineCustomerのN:M中間テーブル。store_idを保持し、Store境界複合FKで誤参照を防止する。';
COMMENT ON COLUMN bottle_line_customers.store_id IS '所属店舗ID。BottleとLineCustomerが同一店舗に属することを保証する。';
COMMENT ON COLUMN bottle_line_customers.bottle_id IS 'ボトルID。';
COMMENT ON COLUMN bottle_line_customers.line_customer_id IS 'LINE顧客ID。';
COMMENT ON COLUMN bottle_line_customers.created_at IS '紐付け作成日時。';

CREATE INDEX bottle_line_customers_store_id_line_customer_id_idx
    ON bottle_line_customers (store_id, line_customer_id);
