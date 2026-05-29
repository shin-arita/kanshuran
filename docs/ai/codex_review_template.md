# Codex Review 指示

レビュー前に以下を読んでください。

- CLAUDE.md
- docs/roadmap/non_functional_roadmap.md
- docs/ai/workflow.md

---

## 対象

<!-- PRのタイトル・番号・ブランチ名を記載してください -->

## 今回のフェーズ

<!-- 対象フェーズを記載してください -->
<!-- 例: 開発環境構築 / テーブル設計 / API実装 -->

## レビュー観点

以下の観点でレビューしてください。

- **スコープ逸脱**: 今回フェーズの範囲外の実装が含まれていないか
- **設計逸脱**: CLAUDE.md・ドメイン設計ドキュメントと整合しているか
- **docs整合**: コードとdocsの記述が一致しているか
- **テスト結果**: make check / GitHub Actions が通っているか
- **GitHub Actions結果**: check.yml が全ジョブpassしているか
- **観酒覧思想との整合**:
  - 黒子・店舗主役の思想を守っているか
  - メール関連が混入していないか
  - 不要な複雑化をしていないか
  - LineCustomer / BottleLineCustomer 命名方針を守っているか

## 報告形式

以下の形式で報告してください。

```text
## レビュー結果

## Blocker（commit不可）

## Warning（要確認）

## Info（次フェーズ候補）

## commit可否

- [ ] commit可
- [ ] commit不可（Blocker解消後に再レビュー）
```

## commit可否

<!-- Codexが判定してください -->

---

> このテンプレートは共通土台です。
> フェーズ別の詳細指示はChatGPTが都度作成します。
