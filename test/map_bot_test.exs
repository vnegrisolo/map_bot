defmodule MapBotTest do
  use ExUnit.Case
  doctest MapBot

  describe "build/2" do
    test "a sequence in a struct" do
      assert %MapBot.Test.Car{
               model: "SUV",
               color: :black,
               code: "CODE-" <> sequence
             } = MapBot.build(MapBot.Test.Car, [:with_code])

      assert Integer.parse(sequence) > 0
    end
  end
end
