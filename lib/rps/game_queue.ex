defmodule Rps.GameQueue do
  use GenServer

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def find_game(player_id) do
    GenServer.call(__MODULE__, {:find_game, player_id})
  end

  # Callbacks
  @impl true
  def init(_) do
    {:ok, %{
      pid: nil,
      player_id: nil
    }}
  end

  @impl true
  def handle_call({:find_game, player_id}, _from, %{pid: nil, player_id: nil}) do
    {:ok, pid} = Rps.Game.start_link(player_id)

    {:reply, {:ok, pid}, %{pid: pid, player_id: player_id}}
  end

  def handle_call({:find_game, player_id}, _from, %{pid: pid, player_id: player_id}) do
    {:reply, {:ok, pid}, %{pid: pid, player_id: player_id}}
  end

  def handle_call({:find_game, player_id}, _from, %{pid: pid, player_id: _}) do
    Rps.Game.add_opponent(pid, player_id)

    {:reply, {:ok, pid}, %{pid: nil, player_id: nil}}
  end
end
