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
    start_session(socket, player_id)
  end

  def mount(_params, _session, socket) do
    start_session(socket, generate_player_id())
  end

  defp generate_player_id do
    1
  end

  defp start_session(socket, player_id) do
    {:ok, pid} = Rps.GameQueue.find_game(player_id)

    if connected?(socket) do
      Rps.GameBroadcaster.subscribe(pid)
    end

    {:ok, assign(socket, pid: pid, player_id: player_id)}
  end

  def handle_info({:update, %{home_player_id: home_player_id, away_player_id: away_player_id}}, socket) do
    {:noreply, assign(socket, player_id: home_player_id, opponent_id: away_player_id)}
  end
end
