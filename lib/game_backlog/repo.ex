defmodule GameBacklog.Repo do
  use Ecto.Repo,
    otp_app: :game_backlog,
    adapter: Ecto.Adapters.Postgres
end
