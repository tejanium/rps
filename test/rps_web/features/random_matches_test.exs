defmodule RpsWeb.Features.RandomMatchesTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query, only: [button: 1]
  @page "/"

  def assert_has_all_buttons(session) do
    session
    |> assert_has(button("rock"))
    |> assert_has(button("paper"))
    |> assert_has(button("scissor"))
  end

  @sessions 2
  feature "Users play with each other", %{sessions: [user_1, user_2]} do
    on_exit(fn ->
      Wallaby.end_session(user_1)
      Wallaby.end_session(user_2)
    end)

    # Preparing the game
    user_1
    |> visit(@page)
    |> assert_text("Searching for opponent... Please wait!")

    user_2
    |> visit(@page)
    |> assert_has_all_buttons()

    user_1
    |> assert_has_all_buttons()

    # Start playing
    user_1
    |> click(button("rock"))
    |> assert_text("Opponent is picking...")

    user_2
    |> assert_text("Opponent has picked their move.")

    user_2
    |> click(button("scissor"))

    assert_text(user_1, "You win!")
    assert_text(user_2, "You lose!")

    # New game
    user_1
    |> assert_has_all_buttons()

    user_2
    |> assert_has_all_buttons()

    user_1
    |> click(button("paper"))

    user_2
    |> click(button("paper"))

    assert_text(user_1, "Draw!")
    assert_text(user_2, "Draw!")

    assert_text(user_1, "Win: 1, Lose: 0, Draw: 1")
    assert_text(user_2, "Win: 0, Lose: 1, Draw: 1")
  end

  @sessions 2
  feature "One user disconnected", %{sessions: [user_1, user_2]} do
    on_exit(fn ->
      Wallaby.end_session(user_1)
      Wallaby.end_session(user_2)
    end)

    # Preparing the game
    user_1
    |> visit(@page)

    user_2
    |> visit(@page)
    |> assert_has_all_buttons()

    # One user leaving the page
    user_1
    |> assert_has_all_buttons()
    |> visit("/")

    user_2
    |> assert_text("The opponent has been disconnected, please refresh to start a new game.")
  end

  @sessions 2
  feature "One user timeout", %{sessions: [user_1, user_2]} do
    on_exit(fn ->
      Wallaby.end_session(user_1)
      Wallaby.end_session(user_2)
    end)

    # Preparing the game
    user_1
    |> visit(@page)

    user_2
    |> visit(@page)
    |> assert_has_all_buttons()

    # One user leaving the page
    user_1
    |> click(button("paper"))

    user_2
    |> assert_text("timeout")
    |> assert_text("You lose!")
  end

  @sessions 2
  feature "Both users timeout", %{sessions: [user_1, user_2]} do
    on_exit(fn ->
      Wallaby.end_session(user_1)
      Wallaby.end_session(user_2)
    end)

    # Preparing the game
    user_1
    |> visit(@page)

    user_2
    |> visit(@page)
    |> assert_has_all_buttons()

    # One user leaving the page
    user_1
    |> assert_text("timeout")
    |> assert_text("Draw!")

    user_2
    |> assert_text("timeout")
    |> assert_text("Draw!")
  end
end
