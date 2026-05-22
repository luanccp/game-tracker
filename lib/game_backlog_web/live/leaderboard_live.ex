defmodule GameBacklogWeb.LeaderboardLive do
  use GameBacklogWeb, :live_view

  alias GameBacklog.Leaderboard

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Leaderboard
        <:subtitle>Most viewed games -- updated in real-time.</:subtitle>
        <:actions>
          <.button phx-click="reset" data-confirm="Reset all view counts?">
            <.icon name="hero-arrow-path" /> Reset
          </.button>
        </:actions>
      </.header>

      <%= if @top_games == [] do %>
        <div class="text-center py-12 text-base-content/60">
          <.icon name="hero-trophy" class="w-12 h-12 mx-auto mb-4 opacity-40" />
          <p class="text-lg">No views recorded yet.</p>
          <p class="text-sm mt-1">Browse some games to see the leaderboard come alive!</p>
        </div>
      <% else %>
        <div class="overflow-x-auto">
          <table class="table w-full" id="leaderboard-table">
            <thead>
              <tr>
                <th class="w-16">#</th>
                <th>Game</th>
                <th>Platform</th>
                <th>Genre</th>
                <th class="text-right">Views</th>
              </tr>
            </thead>
            <tbody>
              <%= for {{entry, rank}, _idx} <- Enum.with_index(Enum.zip(@top_games, 1..length(@top_games))) do %>
                <tr id={"leaderboard-#{entry.game.id}"} class="hover">
                  <td class="font-bold text-lg">
                    <%= cond do %>
                      <% rank == 1 -> %>
                        <span class="text-yellow-500">1</span>
                      <% rank == 2 -> %>
                        <span class="text-gray-400">2</span>
                      <% rank == 3 -> %>
                        <span class="text-amber-600">3</span>
                      <% true -> %>
                        {rank}
                    <% end %>
                  </td>
                  <td>
                    <.link navigate={~p"/games/#{entry.game}"} class="link link-hover font-semibold">
                      {entry.game.catalog_game && entry.game.catalog_game.title}
                    </.link>
                  </td>
                  <td>{entry.game.platform}</td>
                  <td>
                    {entry.game.catalog_game && entry.game.catalog_game.genre &&
                      entry.game.catalog_game.genre.description}
                  </td>
                  <td class="text-right font-mono text-lg">{entry.view_count}</td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
      <% end %>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Leaderboard.subscribe()
    end

    {:ok,
     socket
     |> assign(:page_title, "Leaderboard")
     |> assign(:top_games, Leaderboard.top_games())}
  end

  @impl true
  def handle_info({:leaderboard_updated, top_games}, socket) do
    {:noreply, assign(socket, :top_games, top_games)}
  end

  @impl true
  def handle_event("reset", _params, socket) do
    Leaderboard.reset()

    {:noreply,
     socket
     |> assign(:top_games, [])
     |> put_flash(:info, "Leaderboard has been reset")}
  end
end
