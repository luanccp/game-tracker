# Game Backlog Tracker — Build Plan

## What was generated

- Phoenix app scaffolded with `mix phx.new`
- LiveView CRUD generated with `mix phx.gen.live Backlog Game games`

### Game schema fields
| Field    | Type    | Notes                                  |
|----------|---------|----------------------------------------|
| title    | string  | Game name                              |
| platform | string  | e.g. PC, PS5, Switch                   |
| status   | string  | backlog / playing / completed / dropped |
| genre    | string  | e.g. RPG, FPS, Strategy               |
| rating   | integer | 1–10, fill in when completed           |
| notes    | text    | Free-form personal notes              |

---

## Steps to get it running

### 1. Configure the database
Edit `config/dev.exs` — update username, password, and database name to match your local Postgres setup.

### 2. Create the database and run migrations
```bash
mix ecto.create
mix ecto.migrate
```

### 3. Wire up the routes
Add to the browser scope in `lib/game_backlog_web/router.ex`:
```elixir
live "/games", GameLive.Index, :index
live "/games/new", GameLive.Form, :new
live "/games/:id", GameLive.Show, :show
live "/games/:id/edit", GameLive.Form, :edit
```

### 4. Start the server
```bash
mix phx.server
# or inside IEx:
iex -S mix phx.server
```

Visit http://localhost:4000/games

---

## Improvements to try (in order)

- [ ] **Constrain `status`** — use an Ecto enum or `validate_inclusion` in the changeset instead of a free text field
- [ ] **Constrain `rating`** — add `validate_number(rating, greater_than: 0, less_than_or_equal_to: 10)` in the changeset
- [ ] **Filter by status** — add a LiveView event to filter the list (backlog / playing / completed) without page reload
- [ ] **Stats page** — average rating per genre using Ecto's `group_by` + `avg`
- [ ] **Authentication** — run `mix phx.gen.auth Accounts User users` to add login so each user has their own backlog
