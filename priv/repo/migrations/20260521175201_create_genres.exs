defmodule GameBacklog.Repo.Migrations.CreateGenres do
  use Ecto.Migration

  def change do
    create table(:genres) do
      add :description, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:genres, [:description])

    alter table(:games) do
      add :genre_id, references(:genres, on_delete: :restrict)
      remove :genre, :string
    end
  end
end
