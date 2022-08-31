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

  @spec has_moved?(map, any) :: boolean
  def has_moved?(nil, _), do: false
  def has_moved?(turns, player_id) do
    turns[map_size(turns)].moves[player_id] != nil
  end

  def has_not_moved?(nil, _), do: true
  def has_not_moved?(turns, player_id), do: !has_moved?(turns, player_id)

  def humanize_player(player_id, current_player_id) do
    case player_id do
      ^current_player_id -> "You"
      _ -> "Opponent"
    end
  end
end
