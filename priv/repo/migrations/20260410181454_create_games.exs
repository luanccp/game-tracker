defmodule GameBacklog.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :title, :string
      add :platform, :string
      add :status, :string
      add :genre, :string
      add :rating, :integer
      add :notes, :text

      timestamps(type: :utc_datetime)
    end
  end
end
