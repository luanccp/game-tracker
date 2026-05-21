alias GameBacklog.Backlog

for genre <- ~w(Action Adventure RPG Strategy Simulation Sports Puzzle Racing Horror) do
  Backlog.create_genre(%{description: genre})
end
