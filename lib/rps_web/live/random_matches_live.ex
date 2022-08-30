defmodule RpsWeb.RandomMatchesLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use RpsWeb, :live_view

  def render(%{opponent_id: opponent_id} = assigns) do
    ~H"""
    You are player <%= @player_id %> vs <%= opponent_id %>
    """
  end

  def render(assigns) do
    ~H"""
    Searching for opponent... Please wait!
    <br>
    You are player <%= @player_id %>
    """
  end

  def mount(%{"player_id" => player_id}, _session, socket) do
    if connected?(socket) do
      start_session(socket, player_id)
    else
      {:ok, assign(socket, player_id: player_id)}
    end
  end

  defp start_session(socket, player_id) do
    case Rps.GameQueue.find_game(player_id) do
      {:ok, pid, opponent_id} ->
        Rps.GameBroadcaster.subscribe(pid)
        {:ok, assign(socket, pid: pid, player_id: player_id, opponent_id: opponent_id)}
      {:ok, pid} ->
        Rps.GameBroadcaster.subscribe(pid)
        {:ok, assign(socket, pid: pid, player_id: player_id)}
    end
  end

  def handle_info({:update, %{home_player_id: home_player_id, away_player_id: away_player_id}}, socket) do
    {:noreply, assign(socket, player_id: home_player_id, opponent_id: away_player_id)}
  end
end
