# 観酒覧 開発環境構築 Claude Code 指示書 v1
作成日: 2026-05-29

## 結論

観酒覧プロジェクトの開発環境を構築してください。

本指示の目的は、

- React + Vite
- Go + Gin
- PostgreSQL
- Redis
- LocalStorage
- Docker Compose

を前提に、MVP実装へ進める最小かつ健全な開発基盤を作ることです。

観酒覧はメール文化のサービスではないため、Mailpit / SMTP / mailer は採用しません。

---

# 前提

## サービス名

観酒覧（かんしゅらん）

## サービス思想

観酒覧は、

- 黒子
- 店舗主役
- 店運用支援
- できるだけ軽く
- 設定・入力を増やさない
- 雑でも回る
- しっかり作るが、管理しすぎない

を基本思想とします。

主敵は、

- 紙
- 記憶
- ボトル探索時間

です。

観酒覧は、

- 厳格管理システム
- CRM
- 業務日報
- シフト管理
- 応援勤務管理システム
- メール通知システム

ではありません。

---

# 技術選定

## Frontend

- React
- Vite
- JavaScript

TypeScript は今回の初期構築では採用しないでください。

## Backend

- Go
- Gin

## Database

- PostgreSQL

## Cache / Queue

- Redis

## Storage

初期:

- LocalStorage

将来:

- S3Storage

方針:

- Storage interface を前提にする
- 画像本体はDBに保存しない
- DBでは storage_key を管理する

## Auth

- LINE Login
- OAuth2

ただし今回の開発環境構築では、LINE Login の本実装までは不要です。

## Notification

- LINE Messaging API

ただし今回の開発環境構築では、LINE送信の本実装までは不要です。

## Mail

不採用。

以下は作らないでください。

- Mailpit
- SMTP設定
- mailer
- mail_outbox
- メール通知関連

---

# 作業範囲

以下を作成してください。

```text
.
├── api
├── frontend
├── db
├── storage
├── docs
├── docker-compose.yml
├── .env.example
├── Makefile
├── README.md
└── CLAUDE.md
```

必要に応じてディレクトリ構成は調整して構いませんが、
過度に複雑化しないでください。

---

# Docker Compose 構成

以下のサービスを作成してください。

```text
frontend
api
db
redis
```

## frontend

- React + Vite
- 開発用サーバ
- ホストからアクセス可能
- API URL は環境変数で受ける

## api

- Go + Gin
- ホットリロードは可能なら air を使う
- DB / Redis に接続できる
- health check endpoint を持つ

## db

- PostgreSQL
- volume 永続化
- .env から DB 名 / ユーザ / パスワードを受ける

## redis

- Redis
- 開発用の標準構成でよい

---

# ポート方針

.env.example に以下を用意してください。

```text
FRONTEND_PORT=5173
API_PORT=8080
DB_PUBLISH_PORT=5432
REDIS_PUBLISH_PORT=6379
```

既存ポート競合を避けられるよう、
docker-compose.yml では環境変数からポートを読む形にしてください。

---

# .env.example

最低限以下を含めてください。

```text
TZ=Asia/Tokyo

APP_ENV=local

FRONTEND_PORT=5173
API_PORT=8080
DB_PUBLISH_PORT=5432
REDIS_PUBLISH_PORT=6379

VITE_API_URL=http://localhost:8080

POSTGRES_DB=kanshuran
POSTGRES_USER=kanshuran
POSTGRES_PASSWORD=kanshuran_password
DATABASE_URL=postgres://kanshuran:kanshuran_password@db:5432/kanshuran?sslmode=disable
DB_SSLMODE=disable

REDIS_ADDR=redis:6379

CORS_ALLOW_ORIGIN=http://localhost:5173

LOCAL_STORAGE_ROOT=/app/storage
```

LINE関連は将来用の placeholder として、
コメント付きで置く程度にしてください。

```text
# LINE_LOGIN_CHANNEL_ID=
# LINE_LOGIN_CHANNEL_SECRET=
# LINE_MESSAGING_CHANNEL_ACCESS_TOKEN=
```

---

# Backend 要件

## Go module

module 名は以下で開始してください。

```text
kanshuran-api
```

## Gin

最低限以下を作成してください。

```text
GET /health
GET /api/v1/health
```

レスポンス例:

```json
{
  "status": "ok"
}
```

## DB接続

PostgreSQLへ接続できる構成を作ってください。

ただし今回の段階では、
本格的なテーブル設計・migration実装は行わないでください。

最低限、

- 設定読み込み
- DB接続初期化
- health check で DB疎通確認可能

まででよいです。

## Redis接続

Redisへ接続できる構成を作ってください。

ただし queue / worker 本実装はまだ行わないでください。

## Storage

LocalStorage 用のディレクトリを用意してください。

将来 S3Storage に切り替えられるよう、
最初から Storage interface を置いてください。

ただし画像アップロードAPIの本実装はまだ行わないでください。

---

# Frontend 要件

React + Vite を作成してください。

最低限以下を作成してください。

```text
/
```

表示内容:

```text
観酒覧
Kanshuran
```

API health check を呼び出す簡単な表示があると望ましいです。

ただし画面作り込みは不要です。

PWA対応は今回の必須範囲外です。
ただし将来PWA化しやすい構成を妨げないでください。

---

# Makefile

以下のターゲットを用意してください。

```text
make up
make build
make rebuild
make down
make destroy
make logs
make ps
make api
make frontend
make db
make fmt
make lint
make test
make check
```

## 方針

- make up: docker compose up -d
- make build: docker compose build
- make rebuild: docker compose up -d --build
- make down: docker compose down
- make destroy: docker compose down -v --remove-orphans
- make logs: docker compose logs -f
- make ps: docker compose ps
- make api: apiコンテナに入る
- make frontend: frontendコンテナに入る
- make db: psqlでDB接続
- make fmt: Go / frontend の整形
- make lint: Go / frontend のlint
- make test: Go / frontend のtest
- make check: fmt / lint / test の統合

初期構築段階で lint / test が未整備の場合でも、
可能な範囲でコマンドを用意してください。

---

# README.md

README.md には最低限以下を書いてください。

- サービス概要
- 技術構成
- 起動方法
- 停止方法
- コンテナ一覧
- URL一覧
- .env 作成方法
- health check 確認方法
- メール不採用であること
- 次工程がテーブル設計 / migrationであること

---

# CLAUDE.md

CLAUDE.md を作成してください。

最低限以下を書いてください。

- 観酒覧のサービス思想
- メール不採用
- LINE文化
- Store中心設計
- Bottle探索対象
- LineCustomerはLINE連携済み客
- StorageLocationは探索補助語彙マスタ
- Notificationは店判断の送信予約
- しっかり作るが管理しすぎない
- 不要な複雑化禁止

---

# docs

docs 配下に以下を置いてください。

```text
docs/README.md
docs/development.md
```

## docs/README.md

ドキュメント一覧の入口にしてください。

## docs/development.md

開発環境の起動・停止・確認方法を書いてください。

---

# 禁止事項

以下は禁止です。

- メール関連を追加する
- Mailpitを追加する
- SMTP設定を追加する
- 認証本実装まで進める
- LINE API本実装まで進める
- テーブル設計を勝手に進める
- migrationを勝手に作り込む
- OCRを入れる
- AI画像認識を入れる
- POS連携を入れる
- CRM機能を入れる
- 複雑な権限管理を入れる
- StaffAssignmentを作る
- 勤務可能店舗管理を作る
- 応援勤務予定管理を作る
- GuestCustomerを作る
- Customerという曖昧名称を使う
- Keep独立モデルを作る
- Photo独立ドメインを作る
- 不要なサンプル機能を増やす

---

# 重要な命名方針

顧客は Customer ではなく、
LineCustomer としてください。

理由:

Customer という名称は「店のお客さん全員」に見え、
観酒覧の意味とズレるため。

LineCustomer は、

```text
LINE連携済み客
マイキープを見られる客
LINE通知を受け取れる客
```

です。

---

# 今回やらないこと

今回は開発環境構築のみです。

以下は次工程以降に回してください。

- ERからテーブル設計への落とし込み
- migration作成
- 本格API実装
- LINE Login実装
- LINE Messaging API実装
- 画像アップロードAPI
- PWA本対応
- E2Eテスト
- CI

---

# 確認コマンド

作業完了後、以下を実行して結果を報告してください。

```text
cp .env.example .env
make build
make up
make ps
curl http://localhost:8080/health
curl http://localhost:8080/api/v1/health
make check
```

make check が初期構築段階で完全に通らない場合は、
理由と未整備箇所を明記してください。

---

# 報告形式

作業完了後、以下の形式で報告してください。

```text
## 実施内容

## 作成・変更ファイル

## 起動確認結果

## health check 結果

## make check 結果

## 未実施・未整備事項

## 次工程候補
```

---

# 完了条件

以下を満たしたら完了です。

- docker compose で frontend / api / db / redis が起動する
- API health check が返る
- frontend が起動する
- PostgreSQL接続設定がある
- Redis接続設定がある
- LocalStorage 用のディレクトリと方針がある
- Mailpit / SMTP / mailer が存在しない
- README / docs / CLAUDE.md が作成されている
- 次工程でテーブル設計に進める
