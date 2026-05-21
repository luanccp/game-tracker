# GameBacklog

A personal video game backlog tracker built with Phoenix LiveView. Track the games you're playing, finished, or want to play next.

## Features

- Full CRUD for managing your game collection
- Track title, platform, genre, status, rating, and notes
- Game status workflow: **Backlog** → **Playing** → **Completed** / **Dropped**
- Rating (1–10) required only for completed games
- Real-time form validation with LiveView
- Light / dark / system theme toggle
- Health check endpoint at `GET /api/healthz`

## Tech stack

- [Elixir](https://elixir-lang.org/) ~> 1.15
- [Phoenix](https://www.phoenixframework.org/) 1.8 with LiveView
- [PostgreSQL](https://www.postgresql.org/) via Ecto
- [Tailwind CSS](https://tailwindcss.com/) v4

## Prerequisites

- Elixir and Erlang installed (see `.tool-versions` or `elixir_buildpack.config`)
- PostgreSQL running locally — the easiest way is with Docker Compose:

```bash
docker compose up -d
```

Or with a standalone container:

```bash
docker run --name game-backlog-postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  -d postgres
```

## Getting started

```bash
mix setup          # install deps, create DB, run migrations, and seeds
mix phx.server     # start the app at http://localhost:4000
```

Or run inside IEx:

```bash
iex -S mix phx.server
```

## Useful commands

| Command | Description |
|---------|-------------|
| `mix test` | Run the test suite |
| `mix precommit` | Compile (warnings-as-errors), format, and test |
| `mix ecto.reset` | Drop, recreate, migrate, and seed the database |

## Production

The app reads configuration from environment variables at runtime:

| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_URL` | Yes | PostgreSQL connection string |
| `SECRET_KEY_BASE` | Yes | Phoenix secret (generate with `mix phx.gen.secret`) |
| `PHX_HOST` | No | Hostname for URL generation |
| `PORT` | No | HTTP port (default 4000) |
