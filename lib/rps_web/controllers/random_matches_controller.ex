defmodule RpsWeb.RandomMatchesController do
  use RpsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
