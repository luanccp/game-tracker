defmodule GameBacklog.BacklogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GameBacklog.Backlog` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        genre: "some genre",
        notes: "some notes",
        platform: "some platform",
        rating: 42,
        status: "some status",
        title: "some title"
      })
      |> GameBacklog.Backlog.create_game()

    game
  end
end
