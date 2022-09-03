defmodule Rps.Engine do
  @rules [
    rock: 1,
    paper: 2,
    scissors:  3
  ]

  def calculate(:timeout, :timeout), do: :draw
  def calculate(:timeout, right), do: right
  def calculate(left, :timeout), do: left
  def calculate(left, right) do
    @rules[left] - @rules[right]
    |> Integer.mod(Enum.count(@rules))
    |> winner([left, right])
  end

  defp winner(0, _), do: :draw
  defp winner(remainder, list) do
    Enum.at(list, remainder - 1)
  end
end
