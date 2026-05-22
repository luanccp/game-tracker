defmodule GameBacklogWeb.GameLive.Index do
  use GameBacklogWeb, :live_view

  alias GameBacklog.Backlog

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Games
        <:actions>
          <.button variant="primary" navigate={~p"/games/new"}>
            <.icon name="hero-plus" /> New Game
          </.button>
        </:actions>
      </.header>

      <.table
        id="games"
        rows={@streams.games}
        row_click={fn {_id, game} -> JS.navigate(~p"/games/#{game}") end}
      >
        <:col :let={{_id, game}} label="Title">{game.catalog_game && game.catalog_game.title}</:col>
        <:col :let={{_id, game}} label="Platform">{game.platform}</:col>
        <:col :let={{_id, game}} label="Status">{game.status}</:col>
        <:col :let={{_id, game}} label="Genre">
          {game.catalog_game && game.catalog_game.genre && game.catalog_game.genre.description}
        </:col>
        <:col :let={{_id, game}} label="Rating">{game.rating}</:col>
        <:col :let={{_id, game}} label="Notes">{game.notes}</:col>
        <:action :let={{_id, game}}>
          <div class="sr-only">
            <.link navigate={~p"/games/#{game}"}>Show</.link>
          </div>
          <.link navigate={~p"/games/#{game}/edit"}>
            <.icon name="hero-pencil" class="w-5 h-5" />
          </.link>
        </:action>
        <:action :let={{id, game}}>
          <.link
            phx-click={JS.push("delete", value: %{id: game.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            <.icon name="hero-trash" class="w-5 h-5" />
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Games")
     |> stream(:games, list_games())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    game = Backlog.get_game!(id)
    {:ok, _} = Backlog.delete_game(game)

    {:noreply, stream_delete(socket, :games, game)}
  end

  defp list_games() do
    Backlog.list_games()
  end
end
