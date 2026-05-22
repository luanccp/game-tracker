defmodule GameBacklog.BacklogTest do
  use GameBacklog.DataCase

  alias GameBacklog.Backlog

  describe "games" do
    alias GameBacklog.Backlog.Game

    import GameBacklog.BacklogFixtures

    @invalid_attrs %{notes: nil, platform: nil, status: nil, catalog_game_id: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Backlog.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Backlog.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      catalog_game = catalog_game_fixture()

      valid_attrs = %{
        notes: "some notes",
        platform: "some platform",
        status: "backlog",
        catalog_game_id: catalog_game.id
      }

      assert {:ok, %Game{} = game} = Backlog.create_game(valid_attrs)
      assert game.notes == "some notes"
      assert game.platform == "some platform"
      assert game.status == :backlog
      assert game.catalog_game_id == catalog_game.id
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Backlog.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()

      update_attrs = %{
        notes: "some updated notes",
        platform: "some updated platform"
      }

      assert {:ok, %Game{} = game} = Backlog.update_game(game, update_attrs)
      assert game.notes == "some updated notes"
      assert game.platform == "some updated platform"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Backlog.update_game(game, @invalid_attrs)
      assert game == Backlog.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Backlog.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Backlog.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Backlog.change_game(game)
    end
  end
end
