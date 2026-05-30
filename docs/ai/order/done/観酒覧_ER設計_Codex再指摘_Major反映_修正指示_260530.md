# 観酒覧 ER設計 Codex再指摘 Major反映 修正指示 260530

## 目的

Codex CLI の再レビューで出た Major 指摘を、ER設計レビュー指示書へ反映してください。

今回は docs-only です。

migration 作成、実装、コード変更は行わないでください。

## 対象ファイル

docs/ai/review/観酒覧_ER設計_CodexReview指示_260530.md

## 反映する Codex Major 指摘

以下をすべて反映してください。

### 1. 複合FK + ON DELETE SET NULL の列指定

複合FKに対して単純な ON DELETE SET NULL を使うと、store_id まで NULL 対象になります。

store_id は NOT NULL なので、PostgreSQL の migration として破綻します。

以下は列指定付き SET NULL として明記してください。

bottles(store_id, storage_location_id)
→ storage_locations(store_id, id)
ON DELETE SET NULL (storage_location_id)

notification_reservations(store_id, bottle_id)
→ bottles(store_id, id)
ON DELETE SET NULL (bottle_id)

notification_reservations(store_id, notification_batch_id)
→ notification_batches(store_id, id)
ON DELETE SET NULL (notification_batch_id)

notification_batches(store_id, staff_id)
→ staffs(store_id, id)
ON DELETE SET NULL (staff_id)

補足:
- store_id は NULL にしない
- nullable な参照ID列のみ NULL にする
- 設計メモとして「PostgreSQLでは複合FKの SET NULL は列指定を使う」と明記する

### 2. notification_reservations.notification_batch_id の Store境界制約

notification_reservations.notification_batch_id が単純FKだと、A店の予約をB店のbatchへ紐付け可能になります。

以下の方針に修正してください。

notification_reservations(store_id, notification_batch_id)
→ notification_batches(store_id, id)
ON DELETE SET NULL (notification_batch_id)

参照先に必要な UNIQUE:

notification_batches
- UNIQUE(store_id, id)

### 3. notification_batches.staff_id の Store境界制約

notification_batches.staff_id が単純FKだと、A店のbatch作成者にB店staffを紐付け可能になります。

以下の方針に修正してください。

notification_batches(store_id, staff_id)
→ staffs(store_id, id)
ON DELETE SET NULL (staff_id)

参照先に必要な UNIQUE:

staffs
- UNIQUE(store_id, id)

### 4. 複合FK参照先 UNIQUE の不足を補う

複合FK参照先として必要な UNIQUE を追加してください。

追加対象:

staffs
- UNIQUE(store_id, id)

line_customers
- UNIQUE(store_id, id)

storage_locations
- UNIQUE(store_id, id)

bottles
- UNIQUE(store_id, id)

notification_batches
- UNIQUE(store_id, id)

notification_reservations
- UNIQUE(store_id, id)

補足:
- 既存の UNIQUE(store_id, line_user_id) は維持する
- 既存の UNIQUE(store_id, name) は維持する
- UUIDv7 Go側生成のPK方針は変更しない

## 既存方針として維持する内容

以下は変更しないでください。

- UUIDv7 Go側生成
- Store中心設計
- Keep独立テーブルなし
- Bottle = キープ実体
- Bottle画像は bottles に3カラムで保持
- bottle_photos は作らない
- Notification は以下3テーブル構成
  - notification_batches
  - notification_reservations
  - notification_deliveries
- bottles.remaining_level は many / low / very_low
- 基本 ON DELETE RESTRICT
- 中間テーブルは必要に応じて CASCADE
- nullable参照補助は列指定付き SET NULL
- OCR MVP外
- POS/CRM MVP外
- 複雑権限 MVP外
- 勤務管理 MVP外
- StaffAssignment MVP外

## 禁止事項

以下は禁止です。

- migration作成
- Goコード変更
- Reactコード変更
- Makefile変更
- GitHub Actions変更
- DB実装
- API設計追加
- LINE通知実装
- MVP外機能の追加
- 過剰な将来拡張設計
- commit
- push
- PR作成

## 作業後に実行するコマンド

repo root で以下を実行してください。

git status --short
git diff -- docs/ai/review/観酒覧_ER設計_CodexReview指示_260530.md
git diff --name-only

## 報告形式

以下の形式で報告してください。

1. 修正したファイル
2. 反映した Major 指摘
3. SET NULL 列指定の反映内容
4. notification_batch_id の Store境界制約
5. staff_id の Store境界制約
6. 追加した UNIQUE(store_id, id)
7. git status --short
8. git diff --name-only

## commit / push / PR

commit / push / PR は行わないでください。

有田さんが内容確認後に判断します。
