defmodule RpsWeb.TimerComponent do
  use RpsWeb, :live_component

  def render(assigns) do
    ~H"""
      <span id="time"><%= if @time <= 20, do: @time %></span>
    """
  end
end
