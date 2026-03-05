# Symphony Learning

Ruby on Rails 8.1.2 で作成した、Symphony 連携用のスターターリポジトリです。

## Versions

- Ruby: `4.0.1`
- Rails: `8.1.2`
- DB: `sqlite3`

## Local Setup

```bash
bundle install
bin/rails db:prepare
bin/dev
```

## Run Tests

```bash
bin/rails test
```

## Symphony Setup

このリポジトリには、`openai/symphony` の `elixir/WORKFLOW.md` をベースにした
`WORKFLOW.md` と `.codex/skills` を同梱しています。

1. `LINEAR_API_KEY` を環境変数に設定する
2. `WORKFLOW.md` の `tracker.project_slug` を自分の Linear Project slug に変更する
3. リポジトリ名を変更した場合は、`hooks.after_create` の `git clone` URL も更新する
4. Symphony (Elixir 実装) を起動してこの `WORKFLOW.md` を指定する

例:

```bash
git clone https://github.com/openai/symphony /tmp/symphony
cd /tmp/symphony/elixir
mise trust
mise install
mise exec -- mix setup
mise exec -- mix build
mise exec -- ./bin/symphony /Users/ryosuke_sato/Documents/ryz310/symphony-learning/WORKFLOW.md
```

参考:
- [openai/symphony](https://github.com/openai/symphony)
- [Symphony Elixir README](https://github.com/openai/symphony/blob/main/elixir/README.md)
