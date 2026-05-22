defmodule GameBacklog.Repo.Migrations.CreateCatalogGames do
  use Ecto.Migration

  def change do
    create table(:catalog_games) do
      add :title, :string, null: false
      add :description, :text
      add :image_url, :string
      add :genre_id, references(:genres, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:catalog_games, [:title])

    alter table(:games) do
      add :catalog_game_id, references(:catalog_games, on_delete: :restrict)
      remove :title, :string
      remove :genre_id, references(:genres)
    end
  end
end
