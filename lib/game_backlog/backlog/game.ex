defmodule GameBacklog.Backlog.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :title, :string
    field :platform, :string
    field :status, Ecto.Enum, values: [:backlog, :playing, :completed, :dropped]
    field :genre, :string
    field :rating, :integer
    field :notes, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:title, :platform, :status, :genre, :rating, :notes])
    |> validate_required([:title, :platform, :status, :genre, :rating, :notes])
  end
end
