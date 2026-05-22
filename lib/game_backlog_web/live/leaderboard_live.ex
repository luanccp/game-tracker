defmodule GameBacklogWeb.LeaderboardLive do
  use GameBacklogWeb, :live_view

  alias GameBacklog.Leaderboard

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Leaderboard
        <:subtitle>Game rankings updated in real-time.</:subtitle>
        <:actions>
          <.button phx-click="reset" data-confirm="Reset all view counts?">
            <.icon name="hero-arrow-path" /> Reset Views
          </.button>
        </:actions>
      </.header>

      <div class="mt-8 space-y-12">
        <section>
          <h2 class="text-xl font-bold mb-4 flex items-center gap-2">
            <.icon name="hero-eye" class="w-5 h-5" /> Most Viewed
          </h2>

          <%= if @top_viewed == [] do %>
            <div class="text-center py-8 text-base-content/60">
              <p>No views recorded yet. Browse the catalog to see this come alive!</p>
            </div>
          <% else %>
            <div class="overflow-x-auto">
              <table class="table w-full" id="most-viewed-table">
                <thead>
                  <tr>
                    <th class="w-16">#</th>
                    <th>Game</th>
                    <th>Genre</th>
                    <th class="text-right">Views</th>
                  </tr>
                </thead>
                <tbody>
                  <%= for {entry, rank} <- Enum.with_index(@top_viewed, 1) do %>
                    <tr id={"viewed-#{entry.catalog_game.id}"} class="hover">
                      <td class="font-bold text-lg">
                        <.rank value={rank} />
                      </td>
                      <td>
                        <.link
                          navigate={~p"/catalog/#{entry.catalog_game}"}
                          class="link link-hover font-semibold"
                        >
                          {entry.catalog_game.title}
                        </.link>
                      </td>
                      <td>{entry.catalog_game.genre && entry.catalog_game.genre.description}</td>
                      <td class="text-right font-mono text-lg">{entry.view_count}</td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          <% end %>
        </section>

        <section>
          <h2 class="text-xl font-bold mb-4 flex items-center gap-2">
            <.icon name="hero-play" class="w-5 h-5" /> Most Played
          </h2>

          <%= if @most_played == [] do %>
            <div class="text-center py-8 text-base-content/60">
              <p>No games marked as playing or completed yet.</p>
            </div>
          <% else %>
            <div class="overflow-x-auto">
              <table class="table w-full" id="most-played-table">
                <thead>
                  <tr>
                    <th class="w-16">#</th>
                    <th>Game</th>
                    <th>Genre</th>
                    <th class="text-right">Players</th>
                  </tr>
                </thead>
                <tbody>
                  <%= for {entry, rank} <- Enum.with_index(@most_played, 1) do %>
                    <tr id={"played-#{entry.catalog_game.id}"} class="hover">
                      <td class="font-bold text-lg">
                        <.rank value={rank} />
                      </td>
                      <td>
                        <.link
                          navigate={~p"/catalog/#{entry.catalog_game}"}
                          class="link link-hover font-semibold"
                        >
                          {entry.catalog_game.title}
                        </.link>
                      </td>
                      <td>{entry.catalog_game.genre && entry.catalog_game.genre.description}</td>
                      <td class="text-right font-mono text-lg">{entry.play_count}</td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          <% end %>
        </section>
      </div>
    </Layouts.app>
    """
  end

  attr :value, :integer, required: true

  defp rank(assigns) do
    ~H"""
    <%= cond do %>
      <% @value == 1 -> %>
        <span class="text-yellow-500">1</span>
      <% @value == 2 -> %>
        <span class="text-gray-400">2</span>
      <% @value == 3 -> %>
        <span class="text-amber-600">3</span>
      <% true -> %>
        {@value}
    <% end %>
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
     |> assign(:top_viewed, Leaderboard.top_viewed())
     |> assign(:most_played, Leaderboard.most_played())}
  end

  @impl true
  def handle_info({:leaderboard_updated, top_viewed}, socket) do
    {:noreply, assign(socket, :top_viewed, top_viewed)}
  end

  @impl true
  def handle_event("reset", _params, socket) do
    Leaderboard.reset()

    {:noreply,
     socket
     |> assign(:top_viewed, [])
     |> put_flash(:info, "View counts have been reset")}
  end
end
