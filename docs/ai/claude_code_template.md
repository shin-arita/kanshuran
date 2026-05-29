# Claude Code 指示

## 結論

<!-- 何をするかを一行で書いてください -->

---

## 対象フェーズ

<!-- 例: 開発環境構築 / テーブル設計 / API実装 -->

## 作業範囲

<!-- 変更対象のファイル・ディレクトリを列挙してください -->

```text
例:
api/internal/handler/
db/migrations/
docs/
```

---

## やること

<!-- 具体的な作業内容を箇条書きにしてください -->

## やらないこと

<!-- 今回スコープ外を明記してください -->

---

## 禁止事項

観酒覧共通の禁止事項は以下です。すべての指示に適用されます。

- Mailpit / SMTP / mailer / mail_outbox を作らない
- LINE APIの本実装を勝手に進めない
- テーブル設計・migrationを勝手に進めない
- OCR / AI画像認識 / POS連携を入れない
- 複雑な権限管理を入れない
- StaffAssignment / 応援勤務管理を作らない
- Customer という曖昧名称を使わない（LineCustomer を使う）
- Keep独立モデルを作らない
- Photo独立ドメインを作らない
- 不要なサンプル機能を増やさない
- AIがcommit / push / mergeしない

今回フェーズ固有の禁止事項:

<!-- フェーズ別の禁止事項を追記してください -->

---

## 確認コマンド

作業後、必ず以下を実行してください。

```bash
git status --short
git diff
docker compose config --quiet
make check
curl http://localhost:8080/health
curl http://localhost:8080/api/v1/health
```

---

## 報告形式

作業完了後、以下形式で報告してください。

```text
## 実施内容

## 作成・変更ファイル

## 起動確認結果

## health check結果

## make check結果

## git status --short

## 未実施・未整備事項

## 次工程候補
```

---

## 完了条件

<!-- フェーズ・作業ごとの完了条件を記載してください -->

共通完了条件:

- make check が通る
- docker compose config --quiet が通る
- health check が返る
- Mailpit / SMTP / mailer が存在しない
- 次の Codex review に回せる状態になっている

---

> 観酒覧では「いつもの品質」を標準とします。
> commitは有田さんが判断します。Claude Codeはcommitしません。
