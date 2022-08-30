defmodule RpsWeb.RandomMatchesLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use RpsWeb, :live_view

  def render(assigns) do
    ~H"""
    Searching for opponent... Please wait!
    """
  end

  def mount(_params, %{ player_id: player_id }, socket) do
    {:ok, assign(socket, :ok, player_id)}
  end

  def mount(_params, session, socket) do
    session = Map.put(session, :player_id, 1)

    {:ok, assign(socket, :ok, session[:player_id])}
  end
end
