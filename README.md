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
   - 例: `.env.example` を `.env.local` にコピーして値を設定
2. `WORKFLOW.md` の `tracker.project_slug` を自分の Linear Project slug に変更する
3. リポジトリ名を変更した場合は、`hooks.after_create` の `git clone` URL も更新する
4. Symphony (Elixir 実装) を起動する

例:

```bash
cp .env.example .env.local
# .env.local の LINEAR_API_KEY を実値に変更
./script/run_symphony.sh
```

`script/run_symphony.sh` は内部で以下を実行します。

- `openai/symphony` を `/tmp/openai-symphony` に配置/更新
- `mise` で Erlang/Elixir を導入
- `mix deps.get` と `mix build`
- このリポジトリの `WORKFLOW.md` を読み込んで Symphony を起動
- `.env.local` があれば自動で読み込み

停止は `Ctrl+C` です。

参考:
- [openai/symphony](https://github.com/openai/symphony)
- [Symphony Elixir README](https://github.com/openai/symphony/blob/main/elixir/README.md)
