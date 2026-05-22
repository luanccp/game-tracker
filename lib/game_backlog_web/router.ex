defmodule GameBacklogWeb.Router do
  use GameBacklogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GameBacklogWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GameBacklogWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/games", GameLive.Index, :index
    live "/games/new", GameLive.Form, :new
    live "/games/:id", GameLive.Show, :show
    live "/games/:id/edit", GameLive.Form, :edit

    live "/catalog", CatalogLive, :index
    live "/leaderboard", LeaderboardLive, :index
  end

  scope "/api", GameBacklogWeb do
    pipe_through :api

    get "/healthz", HealthzController, :index
  end
end
