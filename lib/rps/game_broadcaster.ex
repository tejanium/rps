defmodule Rps.GameBroadcaster do
  def broadcast(pid, subject, data) do
    Phoenix.PubSub.broadcast(Rps.PubSub, channel_name(pid), {subject, data})
  end

  def subscribe(pid) do
    Phoenix.PubSub.subscribe(Rps.PubSub, channel_name(pid))
  end

  defp channel_name(pid) do
    "game:#{inspect(pid)}"
  end
end
