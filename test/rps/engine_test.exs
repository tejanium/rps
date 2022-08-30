defmodule Rps.EngineTest do
  use ExUnit.Case, async: true

  test "nil" do
    assert Rps.Engine.calculate(:rock, nil) == nil
    assert Rps.Engine.calculate(nil, :rock) == nil
  end

  test "rock vs rock" do
    assert Rps.Engine.calculate(:rock, :rock) == :draw
  end

  test "rock vs paper" do
    assert Rps.Engine.calculate(:rock, :paper) == :paper
  end

  test "rock vs scissor" do
    assert Rps.Engine.calculate(:rock, :scissor) == :rock
  end

  test "paper vs rock" do
    assert Rps.Engine.calculate(:paper, :rock) == :paper
  end

  test "paper vs paper" do
    assert Rps.Engine.calculate(:paper, :paper) == :draw
  end

  test "paper vs scissor" do
    assert Rps.Engine.calculate(:paper, :scissor) == :scissor
  end

  test "scissor vs rock" do
    assert Rps.Engine.calculate(:scissor, :rock) == :rock
  end

  test "scissor vs paper" do
    assert Rps.Engine.calculate(:scissor, :paper) == :scissor
  end

  test "scissor vs scissor" do
    assert Rps.Engine.calculate(:scissor, :scissor) == :draw
  end

  test "timeout vs timeout" do
    assert Rps.Engine.calculate(:timeout, :timeout) == :timeout
  end

  test "rock vs timeout" do
    assert Rps.Engine.calculate(:rock, :timeout) == :rock
  end

  test "paper vs timeout" do
    assert Rps.Engine.calculate(:paper, :timeout) == :paper
  end

  test "scissor vs timeout" do
    assert Rps.Engine.calculate(:scissor, :timeout) == :scissor
  end

  test "timeout vs rock" do
    assert Rps.Engine.calculate(:timeout, :rock) == :rock
  end

  test "timeout vs paper" do
    assert Rps.Engine.calculate(:timeout, :paper) == :paper
  end

  test "timeout vs scissor" do
    assert Rps.Engine.calculate(:timeout, :scissor) == :scissor
  end
end
