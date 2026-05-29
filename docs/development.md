# 開発環境 起動・停止・確認ガイド

## 初回セットアップ

```bash
cp .env.example .env
make build
make up
```

## 起動確認

```bash
make ps
curl http://localhost:8080/health
curl http://localhost:8080/api/v1/health
```

## 日常操作

| コマンド | 内容 |
|----------|------|
| `make up` | コンテナ起動 |
| `make down` | コンテナ停止 |
| `make rebuild` | ビルド+起動 |
| `make logs` | ログ確認 |
| `make ps` | コンテナ状態確認 |

## コンテナへのアクセス

```bash
make api        # API コンテナ (sh)
make frontend   # frontend コンテナ (sh)
make db         # psql で DB 接続
```

## コード品質

```bash
make fmt    # フォーマット
make lint   # lint
make test   # テスト
make check  # fmt + lint + test
```

## 環境のリセット

```bash
make destroy    # volume も含めて削除
make build
make up
```

## URL一覧

| 用途 | URL |
|------|-----|
| Frontend | http://localhost:5173 |
| API | http://localhost:8080 |
| Health | http://localhost:8080/health |
| API v1 Health | http://localhost:8080/api/v1/health |
