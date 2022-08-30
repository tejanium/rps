defmodule Rps.Game do
  use GenServer

  # Client
  def start_link(home_player_id) do
    GenServer.start_link(__MODULE__, home_player_id)
  end

  def add_opponent(pid, player_id) do
    {:ok, state} = GenServer.call(pid, {:add_opponent, player_id})

    Rps.GameBroadcaster.broadcast(pid, state)
  end

  # Callbacks
  @impl true
  def init(home_player_id) do
    {:ok,
     %{
       home_player_id: home_player_id,
       away_player_id: nil
     }}
  end

  @impl true
  def handle_call({:add_opponent, player_id}, _from, state) do
    new_state = %{state | away_player_id: player_id}

    {:reply, {:ok, new_state}, new_state}
  end
end
