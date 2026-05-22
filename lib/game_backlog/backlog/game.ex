defmodule GameBacklog.Backlog.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    belongs_to :catalog_game, GameBacklog.Backlog.CatalogGame
    field :platform, :string
    field :status, Ecto.Enum, values: [:backlog, :playing, :completed, :dropped]
    field :rating, :integer
    field :notes, :string
    field :view_count, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:catalog_game_id, :platform, :status, :rating, :notes])
    |> validate_required([:catalog_game_id, :platform, :status])
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
