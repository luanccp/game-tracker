defmodule GameBacklog.Backlog.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :title, :string
    field :platform, :string
    field :status, Ecto.Enum, values: [:backlog, :playing, :completed, :dropped]
    belongs_to :genre, GameBacklog.Backlog.Genre
    field :rating, :integer
    field :notes, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:title, :platform, :status, :genre_id, :rating, :notes])
    |> validate_required([:title, :platform, :status, :genre_id])
    |> validate_rating()
  end

  defp validate_rating(changeset) do
    status = get_field(changeset, :status)
    rating = get_field(changeset, :rating)

    cond do
      status == :completed and is_nil(rating) ->
        add_error(changeset, :rating, "is required for completed games")

      status != :completed and not is_nil(rating) ->
        add_error(changeset, :rating, "can only be set for completed games")

      true ->
        changeset
    end
  end
end
