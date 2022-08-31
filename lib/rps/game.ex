defmodule Rps.Game do
  use GenServer

  # Client
  def start_link(home_player_id) do
    GenServer.start_link(__MODULE__, home_player_id)
  end

  def add_opponent(pid, player_id) do
    call_and_broadcast(pid, {:add_opponent, player_id}, :opponent_added)
  end

  def move(pid, player_id, move) do
    call_and_broadcast(pid, {:move, player_id, move}, :moved)
  end

  defp call_and_broadcast(pid, data, subject) do
    {:ok, state} = GenServer.call(pid, data)

    Rps.GameBroadcaster.broadcast(pid, subject, state)

    {:ok, state}
  end

  # Callbacks
  @impl true
  def init(home_player_id) do
    {:ok,
     %{
       home_player_id: home_player_id,
       away_player_id: nil,
       turns: %{}
     }}
  end

  @impl true
  def handle_call({:add_opponent, player_id}, _from, state) do
    new_state = update_map(state, [:away_player_id], player_id)

    {:reply, {:ok, new_state}, new_state}
  end

  def handle_call({:move, player_id, move}, _from, state) do
    current_turn = map_size(state.turns)

    new_state =
      case get_in(state, [:turns, current_turn, :result]) do
        :wait ->
          state
          |> update_state(current_turn, player_id, move, :done)
          |> calculate_result(current_turn)
        _ ->
          update_state(state, current_turn + 1, player_id, move, :wait)
      end

    {:reply, {:ok, new_state}, new_state}
  end

  defp update_state(state, turn_size, player_id, move, status) do
    state
    |> update_map([:turns, turn_size, :moves, player_id], move)
    |> update_map([:turns, turn_size, :result], status)
  end

  def calculate_result(state, current_turn) do
    moves = state.turns[current_turn].moves
    home_player_move = moves[state.home_player_id]
    away_player_move = moves[state.away_player_id]

    winner = case Rps.Engine.calculate(home_player_move, away_player_move) do
      ^home_player_move -> state.home_player_id
      ^away_player_move -> state.away_player_id
    end
    update_map(state, [:turns, current_turn, :winner], winner)
  end

  defp update_map(map, keys, value) do
    put_in(map, Enum.map(keys, &Access.key(&1, %{})), value)
  end
end
