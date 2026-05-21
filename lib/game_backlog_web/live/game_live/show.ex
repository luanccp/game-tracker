defmodule GameBacklogWeb.GameLive.Show do
  use GameBacklogWeb, :live_view

  alias GameBacklog.Backlog

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Game {@game.id}
        <:subtitle>This is a game record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/games"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/games/#{@game}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit game
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@game.title}</:item>
        <:item title="Platform">{@game.platform}</:item>
        <:item title="Status">{@game.status}</:item>
        <:item title="Genre">{@game.genre.description}</:item>
        <:item title="Rating">{@game.rating}</:item>
        <:item title="Notes">{@game.notes}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Game")
     |> assign(:game, Backlog.get_game!(id))}
  end
end
