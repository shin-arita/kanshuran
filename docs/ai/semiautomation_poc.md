# GitHub半自動化 PoC

## 目的

Claude Code、Codex、ChatGPT、有田さんの分担フローをGitHub PR上で検証する。

## 検証する流れ

1. Claude Codeがdocs-only変更を行う
2. 有田さんがgit diff / git statusを確認する
3. 有田さんがbranch / commit / push / PRを作成する
4. Codex reviewを依頼する
5. Codex指摘をChatGPTに渡す
6. ChatGPTが修正指示を作る
7. Claude Codeが修正する
8. Codex再レビューを行う
9. ChatGPTが工程判断する
10. 有田さんがmerge判断する

## 確認項目

- PRテンプレートが使えること
- GitHub Actionsが実行されること
- Codex reviewを依頼できること
- Codex指摘を修正フローへ渡せること
- AIがmainへ自動mergeしないこと
- 有田さんが最終判断者であること

## 今回やらないこと

- 実装コード変更
- API変更
- DB変更
- migration
- LINE連携
- 自動merge
- 自動commit
