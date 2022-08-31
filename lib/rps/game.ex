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
    new_state = update_state(state, [:away_player_id], player_id)

    {:reply, {:ok, new_state}, new_state}
  end

  def handle_call({:move, player_id, move}, _from, state) do
    turn_number = map_size(state.turns)

    new_state =
      case get_in(state, [:turns, turn_number, :result]) do
        :wait ->
          state
          |> update_move(turn_number, player_id, move, :done)
          |> update_winner(turn_number)
        _ ->
          update_move(state, turn_number + 1, player_id, move, :wait)
      end

    {:reply, {:ok, new_state}, new_state}
  end

  defp update_move(state, turn_number, player_id, move, status) do
    state
    |> update_state([:turns, turn_number, :moves, player_id], move)
    |> update_state([:turns, turn_number, :result], status)
  end

  def update_winner(state, turn_number) do
    moves = state.turns[turn_number].moves
    winner = calculate_winner(moves, state.home_player_id, state.away_player_id)

    update_state(state, [:turns, turn_number, :winner], winner)
  end

  defp calculate_winner(moves, home_player_id, away_player_id) do
    home_player_move = moves[home_player_id]
    away_player_move = moves[away_player_id]

    case Rps.Engine.calculate(home_player_move, away_player_move) do
      ^home_player_move -> home_player_id
      ^away_player_move -> away_player_id
      :draw -> :draw
    end
  end

  defp update_state(state, keys, value) do
    put_in(state, Enum.map(keys, &Access.key(&1, %{})), value)
  end
end
