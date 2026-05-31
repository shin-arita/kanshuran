# 観酒覧 (Kanshuran)

ボトルキープ管理サービス。紙・記憶・探索時間を主敵とし、店舗運用を軽く支援する。

---

## 技術構成

| レイヤー | 技術 |
|----------|------|
| Frontend | React + Vite (JavaScript) |
| Backend | Go + Gin |
| DB | PostgreSQL 16 |
| Cache | Redis 7 |
| Storage | LocalStorage (将来: S3) |
| Auth | LINE Login / OAuth2 (未実装) |
| Notification | LINE Messaging API (未実装) |

メール・SMTPは採用しない。

---

## 起動方法

```bash
cp .env.example .env
make build
make up
```

## 停止方法

```bash
make down        # コンテナ停止
make destroy     # コンテナ + volume 削除
```

---

## Migration 実行方法

DB は PGroonga 同梱イメージ (`groonga/pgroonga:3.2.5-alpine-16`) を使用しています。

### 初回 / イメージ変更後

```bash
make build   # api イメージ再ビルド (golang-migrate が追加されています)
make up
```

### migration 適用

```bash
make migrate-up
```

### 1ステップ ロールバック

```bash
make migrate-down
```

### PGroonga extension 確認

```bash
docker compose exec db psql -U kanshuran -d kanshuran \
  -c "SELECT extname, extversion FROM pg_extension WHERE extname = 'pgroonga';"
```

### migration ファイルの場所

`db/migrations/` 配下に `YYYYMMDDHHMMSS_create_*.{up,down}.sql` 形式で配置します。

---

## コンテナ一覧

| サービス | 説明 |
|----------|------|
| frontend | React + Vite 開発サーバ |
| api | Go + Gin API サーバ |
| db | PostgreSQL |
| redis | Redis |

```bash
make ps
```

---

## URL一覧

| 用途 | URL |
|------|-----|
| Frontend | http://localhost:5173 |
| API | http://localhost:8080 |
| Health check | http://localhost:8080/health |
| API v1 health | http://localhost:8080/api/v1/health |
| DB (direct) | localhost:5432 |
| Redis (direct) | localhost:6379 |

---

## .env 作成方法

```bash
cp .env.example .env
```

必要に応じてポート番号等を変更する。

---

## health check 確認方法

```bash
curl http://localhost:8080/health
curl http://localhost:8080/api/v1/health
```

レスポンス例:

```json
{"status": "ok"}
{"status": "ok", "db": "ok"}
```

---

## メール不採用について

観酒覧はメール文化のサービスではないため、以下は採用しない:

- Mailpit
- SMTP設定
- mailer

---

## 次工程

テーブル設計 → migration作成 → API本実装

---

## AI分担運用

Claude Code / Codex / ChatGPT / 有田さんによる半自動化運用を採用しています。

- [docs/ai/README.md](docs/ai/README.md) — 役割分担・概要
- [docs/ai/workflow.md](docs/ai/workflow.md) — 作業フロー
- [docs/ai/codex_review_template.md](docs/ai/codex_review_template.md) — Codexレビュー依頼テンプレート
- [docs/ai/claude_code_template.md](docs/ai/claude_code_template.md) — Claude Code指示テンプレート
