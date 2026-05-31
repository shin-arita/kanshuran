# 観酒覧 migration設計 引き継ぎ 2026-05-30

## 結論

ER論理設計フェーズは完了しました。

PR #2 は merge 済みです。

main 反映済み。

```text
PR #2
docs: add ER design review document
```

merge / branch cleanup / main更新 完了。

現在位置:

```text
開発環境構築
↓
GitHub半自動化PoC
↓
ER / 論理設計
✓ 完了
↓
次工程
migration設計
```

---

## 旧チャットタイトル

観酒覧 ER・テーブル設計 260530

## 新チャット推奨タイトル

☆ 観酒覧 migration設計 260530

---

## 今回merge済みPR

PR #2

```text
docs: add ER design review document
```

結果:

```text
✓ Checks passing
✓ Codex final review OK
✓ Didn't find any major issues
✓ merge済み
```

---

## ER論理設計 最終状態

Codex final review:

```text
commit可
migration設計へ進める状態
```

migration前修正事項:

```text
なし
```

---

## 確定済みドメイン / テーブル

MVPテーブル:

- stores
- staffs
- line_customers
- storage_locations
- bottles
- bottle_line_customers
- notification_batches
- notification_reservations
- notification_deliveries

不採用:

- bottle_photos
- Keep独立テーブル
- StaffAssignment
- OCR
- POS / CRM
- 複雑権限

---

## ER設計 確定事項

### PK

UUIDv7

Go側生成

例外:

```text
bottle_line_customers
PRIMARY KEY(bottle_id, line_customer_id)
```

### FK / Store境界

Store中心設計。

複合FKで Store境界保証。

PostgreSQL 複合FK + SET NULL は列指定方式。

例:

```text
ON DELETE SET NULL (storage_location_id)
```

### Notification

3テーブル。

- notification_batches
- notification_reservations
- notification_deliveries

責務分離済み。

### ENUM

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

---

## 次チャットで最初にやること

migration設計。

順番:

1. migrationファイル一覧
2. migration依存順序
3. timestamp migration名
4. FK生成順序
5. Claude Code 指示DLMD
6. branch / PR / Codex review

---

## 次チャットで読むもの

- CLAUDE.md
- docs/roadmap/non_functional_roadmap.md
- docs/ai/review/観酒覧_ER設計_CodexReview指示_260530.md

---

## 新チャットで貼るファイル

なし。

既に repo 管理済み。
