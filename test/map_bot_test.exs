defmodule MapBotTest do
  use ExUnit.Case
  doctest MapBot

  describe "build/2" do
    test "a sequence in a struct" do
      assert %YourApp.Car{
               model: "SUV",
               color: :black,
               code: "CODE-" <> sequence
             } = MapBot.build(YourApp.Car, [:with_code])

      assert Integer.parse(sequence) > 0
    end
  end
end
