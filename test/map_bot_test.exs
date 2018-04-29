defmodule MapBotTest do
  use ExUnit.Case
  doctest MapBot

  test "greets the world" do
    assert MapBot.hello() == :world
  end
end
