defmodule GameBacklogWeb.CatalogLive.Show do
  use GameBacklogWeb, :live_view

  alias GameBacklog.Backlog

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@catalog_game.title}
        <:subtitle>{@catalog_game.genre && @catalog_game.genre.description}</:subtitle>
        <:actions>
          <.button navigate={~p"/catalog"}>
            <.icon name="hero-arrow-left" /> Back to Catalog
          </.button>
        </:actions>
      </.header>

      <div class="mt-8 flex flex-col md:flex-row gap-8">
        <div class="md:w-1/3">
          <%= if @catalog_game.image_url do %>
            <img
              src={@catalog_game.image_url}
              alt={@catalog_game.title}
              class="w-full rounded-xl shadow-md object-cover"
            />
          <% else %>
            <div class="w-full aspect-square rounded-xl bg-base-200 flex items-center justify-center">
              <.icon name="hero-photo" class="w-20 h-20 opacity-20" />
            </div>
          <% end %>
        </div>

        <div class="md:w-2/3 space-y-4">
          <%= if @catalog_game.description do %>
            <div>
              <h3 class="text-sm font-semibold text-base-content/60 uppercase tracking-wide">
                Description
              </h3>
              <p class="mt-1 text-base-content">{@catalog_game.description}</p>
            </div>
          <% end %>

          <div class="flex gap-6">
            <div>
              <h3 class="text-sm font-semibold text-base-content/60 uppercase tracking-wide">
                Genre
              </h3>
              <span class="inline-block mt-1 px-3 py-1 rounded-full text-sm font-medium bg-primary/10 text-primary">
                {@catalog_game.genre && @catalog_game.genre.description}
              </span>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    catalog_game = Backlog.get_catalog_game!(id)

    if connected?(socket) do
      GameBacklog.Leaderboard.record_view(catalog_game.id)
    end

    {:ok,
     socket
     |> assign(:page_title, catalog_game.title)
     |> assign(:catalog_game, catalog_game)
     |> assign(:view_count, catalog_game.view_count)}
  end
end
