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
  end


  scope "/api", GameBacklogWeb do
    pipe_through :api

    get "/healthz", HealthzController, :index
  end

end
