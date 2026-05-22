defmodule GameBacklogWeb.GameLive.Form do
  use GameBacklogWeb, :live_view

  alias GameBacklog.Backlog
  alias GameBacklog.Backlog.Game

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
      </.header>

      <.form for={@form} id="game-form" phx-change="validate" phx-submit="save">
        <div class="relative">
          <div class="fieldset mb-2">
            <label for="catalog-search">
              <span class="label mb-1">Game</span>
            </label>
            <%= if @selected_catalog_game do %>
              <div class="flex items-center gap-3 p-3 rounded-lg border border-base-300 bg-base-200">
                <%= if @selected_catalog_game.image_url do %>
                  <img
                    src={@selected_catalog_game.image_url}
                    alt={@selected_catalog_game.title}
                    class="w-12 h-12 rounded object-cover"
                  />
                <% end %>
                <div class="flex-1">
                  <p class="font-semibold">{@selected_catalog_game.title}</p>
                  <p class="text-sm text-base-content/60">
                    {if @selected_catalog_game.genre, do: @selected_catalog_game.genre.description}
                  </p>
                </div>
                <button type="button" phx-click="clear_catalog_game" class="btn btn-ghost btn-sm">
                  <.icon name="hero-x-mark" class="w-4 h-4" />
                </button>
              </div>
              <input type="hidden" name="game[catalog_game_id]" value={@selected_catalog_game.id} />
            <% else %>
              <input
                type="text"
                id="catalog-search"
                name="search_query"
                value={@search_query}
                placeholder="Search for a game..."
                phx-change="search_catalog"
                phx-debounce="300"
                autocomplete="off"
                class="w-full input"
              />
            <%= if @catalog_results != [] do %>
              <ul class="absolute z-10 mt-1 w-full rounded-lg border border-base-300 bg-base-100 shadow-lg max-h-60 overflow-auto">
                <%= for game <- @catalog_results do %>
                  <li
                    phx-click="select_catalog_game"
                    phx-value-id={game.id}
                    class="flex items-center gap-3 px-4 py-3 cursor-pointer hover:bg-base-200 transition"
                  >
                    <%= if game.image_url do %>
                      <img
                        src={game.image_url}
                        alt={game.title}
                        class="w-10 h-10 rounded object-cover"
                      />
                    <% else %>
                      <div class="w-10 h-10 rounded bg-base-300 flex items-center justify-center">
                        <.icon name="hero-photo" class="w-5 h-5 opacity-40" />
                      </div>
                    <% end %>
                    <div>
                      <p class="font-semibold text-sm">{game.title}</p>
                      <p class="text-xs text-base-content/60">
                        {if game.genre, do: game.genre.description}
                      </p>
                    </div>
                  </li>
                <% end %>
              </ul>
            <% end %>
          <% end %>
          </div>
        </div>

        <.input
          field={@form[:platform]}
          type="select"
          label="Platform"
          prompt="Select a platform"
          options={["PC", "PlayStation", "Xbox", "Nintendo"]}
        />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Select your status"
          options={
            Ecto.Enum.values(GameBacklog.Backlog.Game, :status)
            |> Enum.map(&{Phoenix.Naming.humanize(&1), &1})
          }
        />
        <%= if Ecto.Changeset.get_field(@form.source, :status) == :completed do %>
          <.input field={@form[:rating]} type="number" label="Rating" min="1" max="10" />
        <% end %>
        <.input field={@form[:notes]} type="textarea" label="Notes" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Game</.button>
          <.button navigate={return_path(@return_to, @game)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    game = Backlog.get_game!(id)

    socket
    |> assign(:page_title, "Edit Game")
    |> assign(:game, game)
    |> assign(:search_query, "")
    |> assign(:catalog_results, [])
    |> assign(:selected_catalog_game, game.catalog_game)
    |> assign(:form, to_form(Backlog.change_game(game)))
  end

  defp apply_action(socket, :new, _params) do
    game = %Game{}

    socket
    |> assign(:page_title, "New Game")
    |> assign(:game, game)
    |> assign(:search_query, "")
    |> assign(:catalog_results, [])
    |> assign(:selected_catalog_game, nil)
    |> assign(:form, to_form(Backlog.change_game(game)))
  end

  @impl true
  def handle_event("search_catalog", %{"search_query" => query}, socket) do
    results = Backlog.search_catalog_games(query)
    {:noreply, assign(socket, search_query: query, catalog_results: results)}
  end

  def handle_event("select_catalog_game", %{"id" => id}, socket) do
    catalog_game = Backlog.get_catalog_game!(id)

    changeset =
      Backlog.change_game(socket.assigns.game, %{
        "catalog_game_id" => catalog_game.id
      })

    {:noreply,
     socket
     |> assign(:selected_catalog_game, catalog_game)
     |> assign(:search_query, "")
     |> assign(:catalog_results, [])
     |> assign(:form, to_form(changeset))}
  end

  def handle_event("clear_catalog_game", _params, socket) do
    changeset =
      Backlog.change_game(socket.assigns.game, %{"catalog_game_id" => nil})

    {:noreply,
     socket
     |> assign(:selected_catalog_game, nil)
     |> assign(:search_query, "")
     |> assign(:catalog_results, [])
     |> assign(:form, to_form(changeset))}
  end

  def handle_event("validate", %{"game" => game_params}, socket) do
    game_params =
      if socket.assigns.selected_catalog_game do
        Map.put(game_params, "catalog_game_id", socket.assigns.selected_catalog_game.id)
      else
        game_params
      end

    changeset = Backlog.change_game(socket.assigns.game, game_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"game" => game_params}, socket) do
    game_params =
      if socket.assigns.selected_catalog_game do
        Map.put(game_params, "catalog_game_id", socket.assigns.selected_catalog_game.id)
      else
        game_params
      end

    save_game(socket, socket.assigns.live_action, game_params)
  end

  defp save_game(socket, :edit, game_params) do
    case Backlog.update_game(socket.assigns.game, game_params) do
      {:ok, game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, game))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_game(socket, :new, game_params) do
    case Backlog.create_game(game_params) do
      {:ok, game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Game created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, game))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _game), do: ~p"/games"
  defp return_path("show", game), do: ~p"/games/#{game}"
end
