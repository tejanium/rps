defmodule RpsWeb.Router do
  use RpsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RpsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RpsWeb do
    pipe_through :browser

    get "/", RandomMatchesController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", RpsWeb do
  #   pipe_through :api
  # end
end
