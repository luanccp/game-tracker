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
        <:subtitle>Use this form to manage game records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="game-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:platform]} type="text" label="Platform" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          options={Ecto.Enum.values(GameBacklog.Backlog.Game, :status) |> Enum.map(&{Phoenix.Naming.humanize(&1), &1})}
        />
        <.input field={@form[:genre]} type="text" label="Genre" />
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
    |> assign(:form, to_form(Backlog.change_game(game)))
  end

  defp apply_action(socket, :new, _params) do
    game = %Game{}

    socket
    |> assign(:page_title, "New Game")
    |> assign(:game, game)
    |> assign(:form, to_form(Backlog.change_game(game)))
  end

  @impl true
  def handle_event("validate", %{"game" => game_params}, socket) do
    changeset = Backlog.change_game(socket.assigns.game, game_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"game" => game_params}, socket) do
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
