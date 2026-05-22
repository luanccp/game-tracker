defmodule GameBacklogWeb.CatalogLive do
  use GameBacklogWeb, :live_view

  alias GameBacklog.Backlog

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Game Catalog
        <:subtitle>Browse all available games in the catalog.</:subtitle>
      </.header>

      <div class="mt-8">
        <%= if @catalog_games == [] do %>
          <div class="text-center py-12 text-base-content/60">
            <.icon name="hero-magnifying-glass" class="w-12 h-12 mx-auto mb-4 opacity-40" />
            <p class="text-lg">No games found.</p>
          </div>
        <% else %>
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            <%= for game <- @catalog_games do %>
              <.link
                navigate={~p"/catalog/#{game}"}
                class="group block rounded-xl border border-base-300 bg-base-100 shadow-sm hover:shadow-md transition overflow-hidden"
              >
                <%= if game.image_url do %>
                  <div class="aspect-square overflow-hidden bg-base-200">
                    <img
                      src={game.image_url}
                      alt={game.title}
                      class="w-full h-full object-cover group-hover:scale-105 transition duration-300"
                    />
                  </div>
                <% else %>
                  <div class="aspect-square bg-base-200 flex items-center justify-center">
                    <.icon name="hero-photo" class="w-16 h-16 opacity-20" />
                  </div>
                <% end %>
                <div class="p-4">
                  <h3 class="font-bold text-lg truncate">{game.title}</h3>
                  <span class="inline-block mt-1 px-2 py-0.5 rounded-full text-xs font-medium bg-primary/10 text-primary">
                    {game.genre && game.genre.description}
                  </span>
                  <%= if game.description do %>
                    <p class="mt-2 text-sm text-base-content/60 line-clamp-3">{game.description}</p>
                  <% end %>
                </div>
              </.link>
            <% end %>
          </div>
        <% end %>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Game Catalog")
     |> assign(:catalog_games, Backlog.list_catalog_games())}
  end
end
