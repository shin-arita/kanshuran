# 観酒覧 ER設計 Codex Review 指示

レビュー前に以下を読んでください。
- CLAUDE.md
- docs/roadmap/non_functional_roadmap.md
このロードマップ・優先順位・非機能方針を基準にレビューしてください。
今回の差分がロードマップ範囲内か、順序違反・責務違反・設計逸脱がないかも確認してください。

# 対象

観酒覧 MVP ER / テーブル設計（論理設計）

今回は migration 実装前の ER レビューです。

実装・修正は不要です。
レビューのみ行ってください。

# スコープ

以下をレビュー対象としてください。

- ER関係図
- テーブル一覧
- テーブル責務
- PK方針
- FK / ON DELETE 方針
- nullable 方針
- UNIQUE 方針
- ENUM 方針
- Store境界制約
- MVP外事項との整合

# ER関係図

```
Store
├── 1:N  Staff
├── 1:N  LineCustomer
├── 1:N  StorageLocation
├── 1:N  Bottle
│          └── N:M  LineCustomer  (bottle_line_customers)
└── 1:N  NotificationBatch
           └── 1:N  NotificationReservation
                      └── 1:N  NotificationDelivery → LineCustomer

Bottle
├── (store_id, storage_location_id) → storage_locations(store_id, id)  [Store境界制約]
├── photo_1_storage_key nullable
├── photo_2_storage_key nullable
└── photo_3_storage_key nullable

bottle_line_customers
├── store_id
├── (store_id, bottle_id)       → bottles(store_id, id)        [Store境界制約]
└── (store_id, line_customer_id) → line_customers(store_id, id) [Store境界制約]

notification_reservations
├── (store_id, bottle_id)              → bottles(store_id, id)             nullable [Store境界制約]
└── (store_id, notification_batch_id)  → notification_batches(store_id, id) nullable [Store境界制約]

notification_deliveries
├── (store_id, notification_reservation_id) → notification_reservations(store_id, id) [Store境界制約]
└── (store_id, line_customer_id)            → line_customers(store_id, id)            [Store境界制約]
```

# テーブル一覧

- stores
- staffs
- line_customers
- storage_locations
- bottles
- bottle_line_customers
- notification_batches
- notification_reservations
- notification_deliveries

# テーブル責務

stores
- 店舗
- 全データ所有者
- 期限ポリシー保持

staffs
- 店舗操作ユーザ
- LINE認証主体
- active/inactiveのみ管理
- 勤務管理・権限管理なし

line_customers
- LINE連携済み顧客
- 店舗ごとの顧客

storage_locations
- 保管場所語彙
- 自由入力育成

bottles
- キープ実体
- Keep独立テーブルなし
- 未連携客情報(owner_name/owner_note)保持
- 写真3枚保持

bottle_line_customers
- Bottle × LineCustomer N:M
- store_id を保持し Store境界複合FK を実現

notification_batches
- 店員が作成した一括送信操作単位
- 通知の親レコード
- 操作単位の記録

notification_reservations
- いつ送るか / 何を送るか / どの文脈で送るか
- 予約単位の管理
- 送信結果は delivery 側で管理（reservation は宛先別結果を持たない）

notification_deliveries
- 宛先別送信状態
- LINE送信結果管理
- 二重送信防止

# PK方針

UUIDv7
Go側生成

対象:
- stores.id
- staffs.id
- line_customers.id
- storage_locations.id
- bottles.id
- notification_batches.id
- notification_reservations.id
- notification_deliveries.id

例外:
- bottle_line_customers
  - PRIMARY KEY(bottle_id, line_customer_id)

# FK / ON DELETE 方針

基本:
- RESTRICT

中間:
- CASCADE

参照補助:
- SET NULL

## 単純FK

staffs.store_id
- RESTRICT

line_customers.store_id
- RESTRICT

storage_locations.store_id
- RESTRICT

bottles.store_id
- RESTRICT

notification_batches.store_id
- RESTRICT

notification_reservations.store_id
- RESTRICT

notification_deliveries.store_id
- RESTRICT

## Store境界複合FK

bottles(store_id, storage_location_id)
→ storage_locations(store_id, id)
- ON DELETE SET NULL (storage_location_id)
- store_id は NOT NULL のまま維持。nullable な storage_location_id のみ NULL にする。

notification_batches(store_id, staff_id)
→ staffs(store_id, id)
- ON DELETE SET NULL (staff_id)
- store_id は NOT NULL のまま維持。nullable な staff_id のみ NULL にする。
- A店batchにB店staffを紐付ける誤参照を防ぐ。

bottle_line_customers(store_id, bottle_id)
→ bottles(store_id, id)
- CASCADE

bottle_line_customers(store_id, line_customer_id)
→ line_customers(store_id, id)
- CASCADE

notification_reservations(store_id, bottle_id)
→ bottles(store_id, id)
- ON DELETE SET NULL (bottle_id)
- store_id は NOT NULL のまま維持。nullable な bottle_id のみ NULL にする。

notification_reservations(store_id, notification_batch_id)
→ notification_batches(store_id, id)
- ON DELETE SET NULL (notification_batch_id)
- store_id は NOT NULL のまま維持。nullable な notification_batch_id のみ NULL にする。
- A店予約をB店batchへ紐付ける誤参照を防ぐ。

notification_deliveries(store_id, notification_reservation_id)
→ notification_reservations(store_id, id)
- RESTRICT

notification_deliveries(store_id, line_customer_id)
→ line_customers(store_id, id)
- RESTRICT

## 設計メモ: PostgreSQL 複合FK の SET NULL 列指定

PostgreSQL では複合FKに対して ON DELETE SET NULL を使うと、
FK構成列すべてが NULL 対象になる。
store_id は NOT NULL のため、列指定なし SET NULL は migration として破綻する。

対応: ON DELETE SET NULL (列名) の構文で nullable 列のみ指定する。

影響する複合FK:
- bottles(store_id, storage_location_id) → SET NULL (storage_location_id)
- notification_batches(store_id, staff_id) → SET NULL (staff_id)
- notification_reservations(store_id, bottle_id) → SET NULL (bottle_id)
- notification_reservations(store_id, notification_batch_id) → SET NULL (notification_batch_id)

# nullable 方針

stores
- name NOT NULL
- default_expire_days NOT NULL

staffs
- store_id NOT NULL
- line_user_id NOT NULL
- display_name NOT NULL
- status NOT NULL

line_customers
- store_id NOT NULL
- line_user_id NOT NULL
- display_name NOT NULL

storage_locations
- store_id NOT NULL
- name NOT NULL

bottles
- store_id NOT NULL
- brand_name NOT NULL
- remaining_level NOT NULL
- status NOT NULL

nullable:
- storage_location_id
- owner_name
- owner_note
- expires_at
- photo_1_storage_key
- photo_2_storage_key
- photo_3_storage_key

bottle_line_customers
- store_id NOT NULL
- bottle_id NOT NULL
- line_customer_id NOT NULL

notification_batches
- store_id NOT NULL
- created_at NOT NULL
- updated_at NOT NULL

nullable:
- staff_id
- title

notification_reservations
- store_id NOT NULL
- message_body NOT NULL
- scheduled_at NOT NULL
- status NOT NULL
- created_at NOT NULL
- updated_at NOT NULL

nullable:
- notification_batch_id
- bottle_id

notification_deliveries
- store_id NOT NULL
- notification_reservation_id NOT NULL
- line_customer_id NOT NULL
- status NOT NULL
- created_at NOT NULL
- updated_at NOT NULL

nullable:
- sent_at
- failed_at
- error_message

# UNIQUE 方針

staffs
- UNIQUE(store_id, line_user_id)
- UNIQUE(store_id, id)  ← Store境界複合FK参照先として必要（notification_batches から参照）

line_customers
- UNIQUE(store_id, line_user_id)
- UNIQUE(store_id, id)  ← Store境界複合FK参照先として必要（bottle_line_customers・notification_deliveries から参照）

storage_locations
- UNIQUE(store_id, name)
- UNIQUE(store_id, id)  ← Store境界複合FK参照先として必要（bottles から参照）

bottles
- UNIQUE(store_id, id)  ← Store境界複合FK参照先として必要（bottle_line_customers・notification_reservations から参照）

bottle_line_customers
- PRIMARY KEY(bottle_id, line_customer_id)

notification_batches
- UNIQUE(store_id, id)  ← Store境界複合FK参照先として必要（notification_reservations から参照）

notification_reservations
- UNIQUE(store_id, id)  ← Store境界複合FK参照先として必要（notification_deliveries から参照）

notification_deliveries
- UNIQUE(notification_reservation_id, line_customer_id)  ← 二重送信防止

# ENUM 方針

staffs.status
- active
- inactive

bottles.remaining_level
- many
- low
- very_low

bottles.status
- stored
- finished

notification_reservations.status
- pending
- cancelled

notification_deliveries.status
- pending
- sent
- failed
- cancelled

# Store境界制約方針

観酒覧は Store 中心設計である。

以下の誤参照を DB制約で防止する。

- Bottle(A店) → StorageLocation(B店)
- Bottle(A店) → LineCustomer(B店)  via bottle_line_customers
- NotificationBatch(A店) → Staff(B店)
- NotificationReservation(A店) → Bottle(B店)
- NotificationReservation(A店) → NotificationBatch(B店)
- NotificationDelivery(A店) → LineCustomer(B店)
- NotificationDelivery(A店) → NotificationReservation(B店)

実現方法:

- 複合FK: (store_id, FK列) → 参照先テーブル(store_id, id)
- 参照先テーブルに UNIQUE(store_id, id) が必要
- bottle_line_customers に store_id を追加して制約を実現
- id は UUIDv7 Go側生成のまま（PK方針変更なし）

# MVP外事項

MVP外:
- OCR
- POS/CRM連携
- 複雑権限
- 勤務管理
- StaffAssignment
- 写真独立ドメイン
- Keep独立ドメイン

# 禁止事項

- migration作成
- 実装変更
- scope外議論
- 将来機能前提での過剰設計

# レビュー観点

以下を重点確認してください。

- ドメイン責務逸脱がないか
- Store境界複合FK が別店舗データ誤参照を防げるか
- FK設計が事故削除を防げるか
- nullableが過不足ないか
- UNIQUEが業務整合に合うか
- N:M設計が妥当か
- Notification 3テーブルの責務分離が妥当か
- MVP思想に反していないか
- migration前に修正すべき重大問題がないか

# 報告形式

以下形式で報告してください。

1. 結論
- commit可 / 修正必要

2. 指摘一覧
- Major
- Minor
- Nits

3. migration前に直すべき点

4. 最終評価
