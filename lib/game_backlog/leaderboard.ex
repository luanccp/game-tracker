defmodule GameBacklog.Leaderboard do
  use GenServer

  import Ecto.Query
  alias GameBacklog.Repo
  alias GameBacklog.Backlog.CatalogGame
  alias GameBacklog.Backlog.Game

  @persist_interval :timer.minutes(5)
  @pubsub GameBacklog.PubSub
  @topic "leaderboard"

  # --- Public API ---

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def record_view(catalog_game_id) do
    GenServer.cast(__MODULE__, {:record_view, catalog_game_id})
  end

  def top_viewed(limit \\ 10) do
    GenServer.call(__MODULE__, {:top_viewed, limit})
  end

  def most_played(limit \\ 10) do
    Repo.all(
      from g in Game,
        where: g.status in [:playing, :completed],
        join: cg in assoc(g, :catalog_game),
        group_by: cg.id,
        select: %{catalog_game_id: cg.id, count: count(g.id)},
        order_by: [desc: count(g.id)],
        limit: ^limit
    )
    |> Enum.map(fn %{catalog_game_id: id, count: count} ->
      catalog_game = Repo.get!(CatalogGame, id) |> Repo.preload(:genre)
      %{catalog_game: catalog_game, play_count: count}
    end)
  end

  def reset do
    GenServer.cast(__MODULE__, :reset)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub, @topic)
  end

  # --- GenServer callbacks ---

  @impl true
  def init(:ok) do
    counts = load_counts_from_db()
    schedule_persist()
    {:ok, %{counts: counts}}
  end

  @impl true
  def handle_cast({:record_view, catalog_game_id}, state) do
    counts = Map.update(state.counts, catalog_game_id, 1, &(&1 + 1))
    broadcast_update(counts)
    {:noreply, %{state | counts: counts}}
  end

  def handle_cast(:reset, state) do
    reset_counts_in_db()
    broadcast_update(%{})
    {:noreply, %{state | counts: %{}}}
  end

  @impl true
  def handle_call({:top_viewed, limit}, _from, state) do
    top = build_top_viewed(state.counts, limit)
    {:reply, top, state}
  end

  @impl true
  def handle_info(:persist, state) do
    persist_counts(state.counts)
    schedule_persist()
    {:noreply, state}
  end

  # --- Private helpers ---

  defp load_counts_from_db do
    Repo.all(from cg in CatalogGame, where: cg.view_count > 0, select: {cg.id, cg.view_count})
    |> Map.new()
  end

  defp persist_counts(counts) when map_size(counts) == 0, do: :ok

  defp persist_counts(counts) do
    Enum.each(counts, fn {catalog_game_id, count} ->
      Repo.update_all(
        from(cg in CatalogGame, where: cg.id == ^catalog_game_id),
        set: [view_count: count]
      )
    end)
  end

  defp reset_counts_in_db do
    Repo.update_all(CatalogGame, set: [view_count: 0])
  end

  defp build_top_viewed(counts, limit) do
    catalog_game_ids =
      counts
      |> Enum.sort_by(fn {_id, count} -> count end, :desc)
      |> Enum.take(limit)
      |> Enum.map(fn {id, _count} -> id end)

    catalog_games =
      Repo.all(from cg in CatalogGame, where: cg.id in ^catalog_game_ids, preload: [:genre])
      |> Map.new(&{&1.id, &1})

    counts
    |> Enum.sort_by(fn {_id, count} -> count end, :desc)
    |> Enum.take(limit)
    |> Enum.map(fn {id, count} ->
      %{catalog_game: Map.get(catalog_games, id), view_count: count}
    end)
    |> Enum.filter(fn %{catalog_game: cg} -> cg != nil end)
  end

  defp broadcast_update(counts) do
    top = build_top_viewed(counts, 10)
    Phoenix.PubSub.broadcast(@pubsub, @topic, {:leaderboard_updated, top})
  end

  defp schedule_persist do
    Process.send_after(self(), :persist, @persist_interval)
  end
end
