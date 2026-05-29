# 観酒覧 (Kanshuran) — Claude向けコンテキスト

## サービス思想

観酒覧は「黒子」であり、店舗が主役。

- 店運用を支援する
- できるだけ軽く
- 設定・入力を増やさない
- 雑でも回る
- しっかり作るが、管理しすぎない

### 主敵

- 紙
- 記憶
- ボトル探索時間

### 観酒覧ではないもの

- 厳格管理システム
- CRM
- 業務日報
- シフト管理
- 応援勤務管理
- メール通知システム

---

## メール不採用

観酒覧はメール文化のサービスではない。

以下は絶対に作らない:

- Mailpit
- SMTP設定
- mailer
- mail_outbox
- メール通知関連

---

## LINE文化

通知・認証はLINEで行う。

- 顧客認証: LINE Login (OAuth2)
- 通知: LINE Messaging API
- 顧客は `Customer` ではなく `LineCustomer`

### LineCustomerとは

LINE連携済みの客。マイキープを確認でき、LINE通知を受け取れる。

`GuestCustomer` や `Customer` という名称は使わない。

---

## Store中心設計

観酒覧の主軸は店舗 (Store)。

- StaffはStoreに紐づく
- BottleKeepはStoreに紐づく
- StorageLocationはStore内の保管場所

StoreをまたいだStaffAssignment管理・応援勤務管理は不要。

---

## ボトルキープが探索対象

BottleKeepの主目的は「探索」。どこにあるか素早く見つけること。

- StorageLocationは探索補助語彙マスタ (棚A、冷蔵庫など)
- Photoはkeepに紐づくが独立ドメインにしない

---

## Notification方針

NotificationはLineCustomerへの送信予約。

- 店スタッフが判断して送る
- 自動送信の作り込みはMVP外

---

## 不要な複雑化禁止

- 複雑な権限管理を入れない
- OCR・AI画像認識を入れない
- POS連携を入れない
- Keep独立モデルを作らない
- Photo独立ドメインを作らない
- StaffAssignmentを作らない

---

## 技術構成

| レイヤー | 技術 |
|----------|------|
| Frontend | React + Vite (JavaScript) |
| Backend | Go + Gin |
| DB | PostgreSQL |
| Cache | Redis |
| Storage | LocalStorage → S3 (将来) |
| Auth | LINE Login / OAuth2 |
| Notification | LINE Messaging API |

TypeScriptは今回採用しない。

---

## 現在地

開発環境構築フェーズ完了。次工程はテーブル設計とmigration。
