defmodule Rps.GameBroadcaster do
  alias Phoenix.PubSub

  def broadcast(pid, subject, data) do
    PubSub.broadcast(Rps.PubSub, channel_name(pid), {subject, data})
  end

  def subscribe(pid) do
    Phoenix.PubSub.subscribe(Rps.PubSub, channel_name(pid))
  end

  defp channel_name(pid) do
    "game:#{inspect(pid)}"
  end
end
