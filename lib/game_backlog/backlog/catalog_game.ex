defmodule GameBacklog.Backlog.CatalogGame do
  use Ecto.Schema
  import Ecto.Changeset

  schema "catalog_games" do
    field :title, :string
    field :description, :string
    field :image_url, :string
    belongs_to :genre, GameBacklog.Backlog.Genre

    timestamps(type: :utc_datetime)
  end

  def changeset(catalog_game, attrs) do
    catalog_game
    |> cast(attrs, [:title, :description, :image_url, :genre_id])
    |> validate_required([:title, :genre_id])
    |> unique_constraint(:title)
  end
end
