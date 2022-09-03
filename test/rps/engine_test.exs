defmodule Rps.EngineTest do
  use ExUnit.Case, async: true

  test "rock vs rock" do
    assert Rps.Engine.calculate(:rock, :rock) == :draw
  end

  test "rock vs paper" do
    assert Rps.Engine.calculate(:rock, :paper) == :paper
  end

  test "rock vs scissors" do
    assert Rps.Engine.calculate(:rock, :scissors) == :rock
  end

  test "paper vs rock" do
    assert Rps.Engine.calculate(:paper, :rock) == :paper
  end

  test "paper vs paper" do
    assert Rps.Engine.calculate(:paper, :paper) == :draw
  end

  test "paper vs scissors" do
    assert Rps.Engine.calculate(:paper, :scissors) == :scissors
  end

  test "scissors vs rock" do
    assert Rps.Engine.calculate(:scissors, :rock) == :rock
  end

  test "scissors vs paper" do
    assert Rps.Engine.calculate(:scissors, :paper) == :scissors
  end

  test "scissors vs scissors" do
    assert Rps.Engine.calculate(:scissors, :scissors) == :draw
  end

  test "timeout vs timeout" do
    assert Rps.Engine.calculate(:timeout, :timeout) == :draw
  end

  test "rock vs timeout" do
    assert Rps.Engine.calculate(:rock, :timeout) == :rock
  end

  test "paper vs timeout" do
    assert Rps.Engine.calculate(:paper, :timeout) == :paper
  end

  test "scissors vs timeout" do
    assert Rps.Engine.calculate(:scissors, :timeout) == :scissors
  end

  test "timeout vs rock" do
    assert Rps.Engine.calculate(:timeout, :rock) == :rock
  end

  test "timeout vs paper" do
    assert Rps.Engine.calculate(:timeout, :paper) == :paper
  end

  test "timeout vs scissors" do
    assert Rps.Engine.calculate(:timeout, :scissors) == :scissors
  end
end
