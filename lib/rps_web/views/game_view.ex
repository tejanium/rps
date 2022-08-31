defmodule RpsWeb.GameView do
  use RpsWeb, :view

  def humanize_standing(id, turns) do
    turns = Map.values(turns)

    win = Enum.count turns, fn turn ->
      turn[:winner] && turn.winner == id
    end

    lose = Enum.count turns, fn turn ->
      turn[:winner] && turn.winner != id
    end

    "Win: #{win}, Lose: #{lose}"
  end
end
