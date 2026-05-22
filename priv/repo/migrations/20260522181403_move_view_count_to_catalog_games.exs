defmodule GameBacklog.Repo.Migrations.MoveViewCountToCatalogGames do
  use Ecto.Migration

  def change do
    alter table(:catalog_games) do
      add :view_count, :integer, default: 0, null: false
    end

    alter table(:games) do
      remove :view_count, :integer, default: 0
    end
  end
end
