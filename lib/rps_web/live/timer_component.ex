defmodule RpsWeb.TimerComponent do
  use RpsWeb, :live_component

  def render(assigns) do
    ~H"""
      <span id="time" phx-hook="TimeoutSubmit" phx-keyup="move" phx-value-move="timeout"><%= @time %></span>
    """
  end
end
