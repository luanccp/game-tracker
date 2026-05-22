defmodule GameBacklog.Repo.Migrations.AddViewCountToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :view_count, :integer, default: 0, null: false
    end
  end
end
