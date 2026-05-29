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
gh pr comment <PR番号> --body-file docs/ai/review/example.md
```

---

## 参照

- [codex_review_template.md](./codex_review_template.md)
- [claude_code_template.md](./claude_code_template.md)
- [CLAUDE.md](../../CLAUDE.md)
