defmodule RpsWeb.GameView do
  use RpsWeb, :view

  def humanize_standing(turns, player_id, opponent_id) do
    turns = Map.values(turns)

    win = Enum.count turns, fn turn ->
      turn[:winner] && turn.winner == player_id
    end

    lose = Enum.count turns, fn turn ->
      turn[:winner] && turn.winner == opponent_id
    end

    draw = Enum.count turns, fn turn ->
      turn[:winner] && turn.winner == :draw
    end

    "Win: #{win}, Lose: #{lose}, Draw: #{draw}"
  end

  def humanize_result(winner, player_id, opponent_id) do
    case winner do
      ^player_id -> "You win!"
      ^opponent_id -> "You lose!"
      :draw -> "Draw!"
    end
  end
end
