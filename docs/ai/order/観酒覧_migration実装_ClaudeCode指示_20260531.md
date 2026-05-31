# 観酒覧 migration実装 Claude Code指示 20260531

## レビュー前に読むもの

- CLAUDE.md
- docs/roadmap/non_functional_roadmap.md

このロードマップ・優先順位・非機能方針を基準に作業すること。

## 目的

migration実装のみを行う。

ER再設計は行わない。

## AI責務

- Claude Code: migration実装
- Codex: review
- ChatGPT: 工程監督
- User: commit / push

この責務分離を崩さないこと。

## 対象範囲

対象:

- db/migrations

実装対象:

- extension migration
- enum migration
- stores
- staffs
- line_customers
- storage_locations
- bottles
- bottle_line_customers
- notification_batches
- notification_reservations
- notification_deliveries

## migration方針

### 命名

以下の実timestamp命名を使用すること。

YYYYmmddhhiiss_create_xxx.up.sql
YYYYmmddhhiiss_create_xxx.down.sql

擬似連番は禁止。

### 分割

テーブル単位migration。

extension / enum は独立migration。

### migration順序

1. extensions
2. enums
3. stores
4. staffs
5. line_customers
6. storage_locations
7. bottles
8. bottle_line_customers
9. notification_batches
10. notification_reservations
11. notification_deliveries

### extension

pgroonga を含めること。

CREATE EXTENSION IF NOT EXISTS pgroonga;

### up形式

以下形式に統一すること。

- CREATE EXTENSION / TYPE
- CREATE TABLE
- CONSTRAINT（明示名）
- COMMENT ON TABLE
- COMMENT ON COLUMN
- CREATE INDEX

以下を必須とする。

- constraint明示名
- index明示名
- COMMENT ON TABLE
- COMMENT ON COLUMN
- CHECK(btrim(...) <> '')

### down形式

up の完全逆順。

以下形式とする。

- DROP INDEX IF EXISTS
- DROP TABLE IF EXISTS
- DROP TYPE IF EXISTS
- DROP EXTENSION IF EXISTS

rollback安全性を考慮すること。

## 確定済み設計

ER / カラム / FK / index は確定済み。

再設計禁止。

必要な場合は質問すること。

## 禁止事項

禁止:

- main 直接変更
- commit
- push
- schema追加変更
- ER変更
- unrelated docs変更

## bash中心運用

Claude Codeへの指示コピペや結果大量貼り付けではなく、bash中心で進めること。

確認項目:

- tree
- git status
- git diff

migration確認を行うこと。

## 完了報告

以下形式で報告すること。

- 作成migration一覧
- 実装内容要約
- 実行確認内容
- git diff要約
- review依頼準備完了
