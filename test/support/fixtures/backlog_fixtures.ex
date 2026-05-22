defmodule GameBacklog.BacklogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameBacklog.Backlog` context.
  """

  def genre_fixture(attrs \\ %{}) do
    {:ok, genre} =
      attrs
      |> Enum.into(%{description: "Action #{System.unique_integer([:positive])}"})
      |> GameBacklog.Backlog.create_genre()

    genre
  end

  def catalog_game_fixture(attrs \\ %{}) do
    genre = Map.get_lazy(attrs, :genre, fn -> genre_fixture() end)

    {:ok, catalog_game} =
      attrs
      |> Enum.into(%{
        title: "Test Game #{System.unique_integer([:positive])}",
        description: "A test game description",
        image_url: "https://example.com/image.jpg",
        genre_id: genre.id
      })
      |> GameBacklog.Backlog.create_catalog_game()

    GameBacklog.Backlog.get_catalog_game!(catalog_game.id)
  end

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    catalog_game = Map.get_lazy(attrs, :catalog_game, fn -> catalog_game_fixture() end)

    {:ok, game} =
      attrs
      |> Enum.into(%{
        notes: "some notes",
        platform: "some platform",
        status: "backlog",
        catalog_game_id: catalog_game.id
      })
      |> GameBacklog.Backlog.create_game()

    GameBacklog.Backlog.get_game!(game.id)
  end
end
