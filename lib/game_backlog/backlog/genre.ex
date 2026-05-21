defmodule GameBacklog.Backlog.Genre do
  use Ecto.Schema
  import Ecto.Changeset

  schema "genres" do
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:description])
    |> validate_required([:description])
    |> unique_constraint(:description)
  end
end
