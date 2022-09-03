defmodule RpsWeb.TimerComponent do
  use RpsWeb, :live_component

  def render(assigns) do
    ~H"""
      <span id="time"><%= @time %></span>
    """
  end
end
