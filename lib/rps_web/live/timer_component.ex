defmodule RpsWeb.TimerComponent do
  use RpsWeb, :live_component

  def render(assigns) do
    ~H"""
      <span><%= @time %></span>
    """
  end
end
