defmodule GameBacklog.Leaderboard do
  use GenServer

  import Ecto.Query
  alias GameBacklog.Repo
  alias GameBacklog.Backlog.Game

  @persist_interval :timer.minutes(5)
  @pubsub GameBacklog.PubSub
  @topic "leaderboard"

  # --- Public API ---

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def record_view(game_id) do
    GenServer.cast(__MODULE__, {:record_view, game_id})
  end

  def top_games(limit \\ 10) do
    GenServer.call(__MODULE__, {:top_games, limit})
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
  def handle_cast({:record_view, game_id}, state) do
    counts = Map.update(state.counts, game_id, 1, &(&1 + 1))
    broadcast_update(counts)
    {:noreply, %{state | counts: counts}}
  end

  def handle_cast(:reset, state) do
    reset_counts_in_db()
    broadcast_update(%{})
    {:noreply, %{state | counts: %{}}}
  end

  @impl true
  def handle_call({:top_games, limit}, _from, state) do
    top = build_top_games(state.counts, limit)
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
    Repo.all(from g in Game, where: g.view_count > 0, select: {g.id, g.view_count})
    |> Map.new()
  end

  defp persist_counts(counts) when map_size(counts) == 0, do: :ok

  defp persist_counts(counts) do
    Enum.each(counts, fn {game_id, count} ->
      Repo.update_all(
        from(g in Game, where: g.id == ^game_id),
        set: [view_count: count]
      )
    end)
  end

  defp reset_counts_in_db do
    Repo.update_all(Game, set: [view_count: 0])
  end

  defp build_top_games(counts, limit) do
    game_ids =
      counts
      |> Enum.sort_by(fn {_id, count} -> count end, :desc)
      |> Enum.take(limit)
      |> Enum.map(fn {id, _count} -> id end)

    games =
      Repo.all(from g in Game, where: g.id in ^game_ids, preload: [:genre])
      |> Map.new(&{&1.id, &1})

    counts
    |> Enum.sort_by(fn {_id, count} -> count end, :desc)
    |> Enum.take(limit)
    |> Enum.map(fn {id, count} ->
      game = Map.get(games, id)
      %{game: game, view_count: count}
    end)
    |> Enum.filter(fn %{game: game} -> game != nil end)
  end

  defp broadcast_update(counts) do
    top = build_top_games(counts, 10)
    Phoenix.PubSub.broadcast(@pubsub, @topic, {:leaderboard_updated, top})
  end

  defp schedule_persist do
    Process.send_after(self(), :persist, @persist_interval)
  end
end
