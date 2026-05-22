defmodule GameBacklog.Backlog do
  @moduledoc """
  The Backlog context.
  """

  import Ecto.Query, warn: false
  alias GameBacklog.Repo

  alias GameBacklog.Backlog.Game
  alias GameBacklog.Backlog.Genre
  alias GameBacklog.Backlog.CatalogGame

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(from g in Game, preload: [catalog_game: [:genre]])
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id) |> Repo.preload(catalog_game: [:genre])

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  @doc """
  Returns the list of genres.
  """
  def list_genres do
    Repo.all(from g in Genre, order_by: g.description)
  end

  @doc """
  Creates a genre.
  """
  def create_genre(attrs) do
    %Genre{}
    |> Genre.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a genre if it doesn't exist.
  """
  def get_or_create_genre(description) do
    case Repo.get_by(Genre, description: description) do
      nil -> create_genre(%{description: description})
      genre -> {:ok, genre}
    end
  end

  @doc """
  Searches catalog games by title.
  """
  def search_catalog_games(query) when is_binary(query) and byte_size(query) > 0 do
    search = "%#{query}%"

    Repo.all(
      from cg in CatalogGame,
        where: ilike(cg.title, ^search),
        order_by: cg.title,
        limit: 10,
        preload: [:genre]
    )
  end

  def search_catalog_games(_query), do: []

  @doc """
  Gets a single catalog game.
  """
  def get_catalog_game!(id), do: Repo.get!(CatalogGame, id) |> Repo.preload(:genre)

  @doc """
  Creates a catalog game.
  """
  def create_catalog_game(attrs) do
    %CatalogGame{}
    |> CatalogGame.changeset(attrs)
    |> Repo.insert()
  end
end
