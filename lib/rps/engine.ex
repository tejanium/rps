defmodule Rps.Engine do
  @rules [
    rock: 1,
    paper: 2,
    scissor: 3
  ]

  def calculate(_, nil), do: nil
  def calculate(nil, _), do: nil
  def calculate(:timeout, :timeout), do: :timeout
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
