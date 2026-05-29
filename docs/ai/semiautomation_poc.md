# GitHub半自動化 PoC

## 目的

観酒覧の標準AI分担フローをGitHub PR上で検証する。

## 検証する流れ

1. ChatGPTがClaude Code指示MDを作成する
2. Claude Codeがdocs-only変更を行う
3. 有田さんがgit diff / git statusを確認する
4. 有田さんがbranch / commit / push / PRを作成する
5. Codex reviewを依頼する
6. Codex指摘をChatGPTに渡す
7. ChatGPTが修正指示を作る
8. Claude Codeが修正する
9. Codex再レビューを行う
10. ChatGPTが工程判断する
11. 有田さんがmerge判断する

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
