defmodule RpsWeb.Presence do
  use Phoenix.Presence,
    otp_app: :rps,
    pubsub_server: Rps.PubSub

  def players_from_diff(players, diff) do
    players
    |> handle_joins(diff.joins)
    |> handle_leaves(diff.leaves)
  end

  def track_presence(socket, pid) do
    topic = topic(pid)

    Phoenix.PubSub.subscribe(Rps.PubSub, topic)

    RpsWeb.Presence.track(self(), topic, socket.id, %{
      online_at: inspect(System.system_time(:second))
    })

    RpsWeb.Presence.list(topic)
  end

  defp handle_joins(players, joins) do
    Enum.reduce(joins, players, fn {user, %{metas: [meta | _]}}, acc ->
      Map.put(acc, user, meta)
    end)
  end

  defp handle_leaves(players, leaves) do
    Enum.reduce(leaves, players, fn {user, _}, acc ->
      Map.delete(acc, user)
    end)
  end

  def topic(pid) do
    "players:#{inspect(pid)}"
  end

  def present?(pid, player_id) do
    pid
    |> players()
    |> Enum.member?(player_id)
  end

  def players(pid) do
    pid
    |> topic()
    |> RpsWeb.Presence.list()
    |> Map.keys()
  end
end
