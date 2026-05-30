# AI分担運用ガイド

観酒覧プロジェクトにおけるAI分担運用の入口ドキュメントです。

---

## 役割分担

| 担当 | 役割 |
|------|------|
| **Claude Code** | 実装・修正（コード・ドキュメント） |
| **Codex** | GitHub PRレビュー（設計整合・スコープ確認） |
| **ChatGPT** | 工程監督・指示書作成・レビュー結果整理 |
| **有田さん** | 最終判断・commit・push・merge |

AIはmainブランチへ直接mergeしません。  
有田さんが最終権限者です。

---

## 関連ドキュメント

| ドキュメント | 内容 |
|---|---|
| [workflow.md](./workflow.md) | Claude Code → Codex → ChatGPT → 有田さん の作業フロー |
| [codex_review_template.md](./codex_review_template.md) | Codexレビュー依頼テンプレート |
| [claude_code_template.md](./claude_code_template.md) | Claude Code指示テンプレート |

---

## GitHub CLI / Make AI運用

GitHub操作はCLIを推奨します。`gh auth login` 済みを前提とします。

```bash
gh auth status                                  # 認証確認
gh pr view 1                                    # PR確認
gh pr checks 1                                  # Checks確認
gh pr comment 1 --body "@codex review"          # Codex review依頼
```

Makefileからも実行できます。

```bash
make codex-review PR=1                          # Codex review依頼（英語）
make codex-review-ja PR=1                       # Codex review依頼（日本語のみ・英語禁止）
make codex-ask-ja PR=1 BODY="質問内容"           # Codexへ日本語質問（会話モード）
make pr-reviews PR=1                            # Reviews/CommentsをJSONで取得
make pr-checks PR=1                             # Checks確認
make pr-comments PR=1                           # コメント確認
make ai-order FILE=docs/ai/order/example.md     # Claude Codeへ指示
```

詳細は [workflow.md](./workflow.md) を参照してください。

---

## 参照すべきドキュメント

レビュー・実装前に以下を必ず参照してください。

- [CLAUDE.md](../../CLAUDE.md) — 観酒覧のサービス思想・命名方針
- [docs/roadmap/non_functional_roadmap.md](../roadmap/non_functional_roadmap.md) — 現在地とフェーズ優先順
