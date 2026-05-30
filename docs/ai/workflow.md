# 観酒覧 AI分担ワークフロー

## 概要

Claude Code と Codex のやり取りを GitHub PR 上で管理し、  
実装・レビュー・修正の流れを安全に半自動化します。

---

## フロー

```text
1. ChatGPTがClaude Code指示MDを作る
        ↓
2. Claude Codeが作業する
        ↓
3. 有田さんがgit status / diffを確認する
        ↓
4. 必要に応じてPRを作る
        ↓
5. Codex reviewを依頼する
        ↓
6. Codex指摘をChatGPTに渡す
        ↓
7. ChatGPTがClaude Code修正指示を作る
        ↓
8. Claude Codeが修正する
        ↓
9. Codex再レビュー
        ↓
10. ChatGPTが工程判断
        ↓
11. 有田さんがcommit / push / merge
```

---

## 重要原則

- **mainへAIが直接mergeしない**
- Codex reviewはPR単位で行う
- Claude Codeは実装担当
- Codexはレビュー担当
- ChatGPTは工程監督
- **有田さんが最終権限者**

---

## 各担当の責務

### Claude Code
- 指示MDに従って実装・修正する
- `make check` を通してから報告する
- `git diff` を確認してからスコープを報告する
- commitは行わない（有田さんが判断する）

### Codex
- GitHub PRに対してレビューを行う
- スコープ逸脱・設計逸脱・docs整合を確認する
- `commit可否` を判定して報告する
- 修正は行わない（Claude Codeが担当）

### ChatGPT
- Codex指摘を整理してClaude Code指示MDを作る
- フェーズ・スコープを管理する
- 工程進捗を監督する

### 有田さん
- git status / diff を確認する
- PR作成・commit・push・mergeを判断・実行する
- 最終的な品質・方針の判断をする

---

## PR作成時のチェックリスト

PR作成前に以下を確認してください。

```bash
git status --short
git diff
docker compose config --quiet
make check
curl http://localhost:8080/health
curl http://localhost:8080/api/v1/health
```

---

## GitHub CLI 運用

GitHub画面へのコピペを減らし、CLI中心でPR・checks・Codexレビューを扱います。  
事前に `gh auth login` が完了していることを前提とします。

### 認証確認

```bash
gh auth status
```

### PR確認

```bash
gh pr view <PR番号>
# 例
gh pr view 1
```

### Checks確認

```bash
gh pr checks <PR番号>
# 例
gh pr checks 1
```

### PRコメント確認

```bash
gh pr view <PR番号> --comments
```

### Codex review依頼

```bash
gh pr comment <PR番号> --body "@codex review"
```

### 深掘りレビュー依頼（body-file形式）

詳細な指示をMarkdownファイルで渡す場合:

```bash
gh pr comment <PR番号> --body-file docs/ai/codex_review_template.md
```

---

## Make AI運用

Makefileから直接AI運用コマンドを実行できます。  
`gh auth login` および `claude` CLI が利用可能であることを前提とします。

### Claude Code に指示を渡す

```bash
make ai-order FILE=docs/ai/order/example.md
```

`docs/ai/order/` に指示MDを置いて呼び出します。  
`FILE` 未指定時はエラーになります。

### Codex review依頼

```bash
make codex-review PR=1
```

内部実行: `gh pr comment 1 --body "@codex review"`  
`PR` 未指定時はエラーになります。

### Codex review依頼（日本語）

```bash
make codex-review-ja PR=1
```

Codexへ日本語レビューを強く依頼します（英語禁止・日本語のみ）。  
`PR` 未指定時はエラーになります。

### Codexへ日本語で質問

```bash
make codex-ask-ja PR=1 BODY="このPRを日本語で要約してください。重要な指摘があれば日本語で教えてください。"
```

Codexへの会話モード質問用です。`codex-review-ja` との使い分け:

- `codex-review-ja` — レビューBot起動（`@codex review` トリガー）
- `codex-ask-ja` — 会話モードでの質問（`@codex` 呼びかけ）

`PR` または `BODY` 未指定時はエラーになります。

### PRのreviews / comments取得

```bash
make pr-reviews PR=1
```

内部実行: `gh pr view 1 --json reviews,comments`  
ReviewとコメントをJSON形式で取得します。`PR` 未指定時はエラーになります。

### PRコメント確認

```bash
make pr-comments PR=1
```

内部実行: `gh pr view 1 --comments`

### Checks確認

```bash
make pr-checks PR=1
```

内部実行: `gh pr checks 1`

### gh単体コマンドとの使い分け

| 用途 | Make版 | gh単体 |
|------|--------|--------|
| Codex review依頼 | `make codex-review PR=1` | `gh pr comment 1 --body "@codex review"` |
| Codex review依頼（日本語） | `make codex-review-ja PR=1` | — |
| Codexへ日本語質問 | `make codex-ask-ja PR=1 BODY="..."` | — |
| Reviews/Comments取得 | `make pr-reviews PR=1` | `gh pr view 1 --json reviews,comments` |
| Checks確認 | `make pr-checks PR=1` | `gh pr checks 1` |
| コメント確認 | `make pr-comments PR=1` | `gh pr view 1 --comments` |
| 指示MDをClaude Codeへ | `make ai-order FILE=...` | `cat ... \| claude` |

---

## 参照

- [codex_review_template.md](./codex_review_template.md)
- [claude_code_template.md](./claude_code_template.md)
- [CLAUDE.md](../../CLAUDE.md)
