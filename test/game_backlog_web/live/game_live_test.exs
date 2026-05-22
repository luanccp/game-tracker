defmodule GameBacklogWeb.GameLiveTest do
  use GameBacklogWeb.ConnCase

  import Phoenix.LiveViewTest
  import GameBacklog.BacklogFixtures

  defp create_game(_) do
    game = game_fixture()

    %{game: game}
  end

  describe "Index" do
    setup [:create_game]

    test "lists all games", %{conn: conn, game: game} do
      {:ok, _index_live, html} = live(conn, ~p"/games")

      assert html =~ "Listing Games"
      assert html =~ game.catalog_game.title
    end

    test "navigates to new game page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/games")

      assert {:ok, _form_live, html} =
               index_live
               |> element("a", "New Game")
               |> render_click()
               |> follow_redirect(conn, ~p"/games/new")

      assert html =~ "New Game"
    end

    test "deletes game in listing", %{conn: conn, game: game} do
      {:ok, index_live, _html} = live(conn, ~p"/games")

      assert index_live |> element("#games-#{game.id} a[data-confirm]") |> render_click()
      refute has_element?(index_live, "#games-#{game.id}")
    end
  end

  describe "Show" do
    setup [:create_game]

    test "displays game", %{conn: conn, game: game} do
      {:ok, _show_live, html} = live(conn, ~p"/games/#{game}")

      assert html =~ "Show Game"
      assert html =~ game.catalog_game.title
    end

    test "navigates to edit page from show", %{conn: conn, game: game} do
      {:ok, show_live, _html} = live(conn, ~p"/games/#{game}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/games/#{game}/edit?return_to=show")

      assert render(form_live) =~ "Edit Game"
    end
  end
end
