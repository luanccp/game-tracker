defmodule GameBacklogWeb.PageController do
  use GameBacklogWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
