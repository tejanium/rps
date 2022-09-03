defmodule RpsWeb.RandomMatchesLive do
  use RpsWeb, :live_view

  def render(%{opponent_id: _opponent_id} = assigns) do
    RpsWeb.GameView.render("show.html", assigns)
  end

  def render(assigns) do
    ~H"""
    <div class="h-screen flex items-center justify-center">
      Searching for opponent... Please wait!
    </div>
    """
  end

  def mount(%{"player_id" => player_id}, _session, socket) do
    start_if_connected(socket, player_id)
  end

  def mount(_params, _session, socket) do
    start_if_connected(socket, socket.id)
  end

  defp start_if_connected(socket, player_id) do
    if connected?(socket) do
      start_session(socket, player_id)
    else
      {:ok, assign(socket, player_id: player_id)}
    end
  end

  defp start_session(socket, player_id) do
    case Rps.GameQueue.find_game(player_id) do
      {:ok, game_pid, opponent_id} ->
        Rps.GameBroadcaster.subscribe(game_pid)
        players = RpsWeb.Presence.track_presence(socket, game_pid)

        {:ok,
         assign(socket, game_pid: game_pid, players: players, player_id: player_id, opponent_id: opponent_id)}

      {:ok, game_pid} ->
        Rps.GameBroadcaster.subscribe(game_pid)
        players = RpsWeb.Presence.track_presence(socket, game_pid)

        {:ok, assign(socket, game_pid: game_pid, players: players, player_id: player_id)}
    end
  end

  def handle_info({:opponent_added, %{away_player_id: away_player_id}}, socket) do
    {:noreply, assign(socket, opponent_id: away_player_id)}
  end

  def handle_info({:moved, %{turns: turns, time: time}}, socket) do
    show_previous_result = turns[map_size(turns)].result == :done

    if show_previous_result do
      Process.send_after(self(), {:next_game, %{turns: turns}}, 2000)
    end

    send_update RpsWeb.TimerComponent, id: "timer", time: time
    {:noreply, assign(socket, turns: turns, show_previous_result: show_previous_result)}
  end

  def handle_info({:next_game, %{turns: turns}}, socket) do
    {:noreply, assign(socket, turns: turns, show_previous_result: false)}
  end

  def handle_info({:timer_ticked, time}, socket) do
    send_update RpsWeb.TimerComponent, id: "timer", time: time

    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff", payload: diff}, %{assigns: assigns} = socket) do
    if map_size(diff.leaves) > 0 do
      Rps.Game.stop(assigns.game_pid)
    end

    {:noreply, assign(socket, players: RpsWeb.Presence.players_from_diff(assigns.players, diff))}
  end

  def handle_event("move", %{"move" => move}, %{assigns: assigns} = socket) do
    if Process.alive?(assigns.game_pid) do
      move = String.to_atom(move)

      {:ok, %{turns: turns}} = Rps.Game.move(assigns.game_pid, assigns.player_id, move)

      {:noreply, assign(socket, turns: turns)}
    else
      {:noreply, push_redirect(socket, to: "/", replace: true)}
    end
  end
end
