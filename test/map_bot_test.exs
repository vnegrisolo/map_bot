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

    test "builds :tomato" do
      assert MapBot.build(:tomato) == %{name: "Tomato", color: :red}
    end

    test "builds :tomato, color: :green" do
      assert MapBot.build(:tomato, color: :green) == %{name: "Tomato", color: :green}
    end

    test "builds YourApp.Car, color: :yellow" do
      assert MapBot.build(YourApp.Car, color: :yellow) == %YourApp.Car{
               model: "SUV",
               color: :yellow
             }
    end

    test "builds YourApp.Car, %{color: :yellow}" do
      assert MapBot.build(YourApp.Car, %{color: :yellow}) == %YourApp.Car{
               model: "SUV",
               color: :yellow
             }
    end

    test "builds YourApp.Car, [:greenish, model: \"Sport\"]" do
      assert MapBot.build(YourApp.Car, [:greenish, model: "Sport"]) == %YourApp.Car{
               model: "Sport",
               color: :green
             }
    end
  end
end
