defmodule MapBotTest do
  use ExUnit.Case
  doctest MapBot

  defmodule YourApp.Car do
    defstruct model: nil, color: nil, code: nil
  end

  defmodule YourApp.Factory do
    use MapBot

    def new(:greenish), do: %{color: :green}
    def new(:tomato), do: %{name: "Tomato", color: :red}
    def new(YourApp.Car), do: %YourApp.Car{model: "SUV", color: :black}
    def new(:with_code), do: %{code: &"CODE-#{&1}"}
  end

  describe "build/2" do
    test "a sequence in a struct" do
      assert %YourApp.Car{
               model: "SUV",
               color: :black,
               code: "CODE-" <> sequence
             } = YourApp.Factory.build(YourApp.Car, [:with_code])

      assert Integer.parse(sequence) > 0
    end

    test "builds :tomato" do
      assert YourApp.Factory.build(:tomato) == %{name: "Tomato", color: :red}
    end

    test "builds :tomato, color: :green" do
      assert YourApp.Factory.build(:tomato, color: :green) == %{name: "Tomato", color: :green}
    end

    test "builds YourApp.Car, color: :yellow" do
      assert YourApp.Factory.build(YourApp.Car, color: :yellow) == %YourApp.Car{
               model: "SUV",
               color: :yellow
             }
    end

    test "builds YourApp.Car, %{color: :yellow}" do
      assert YourApp.Factory.build(YourApp.Car, %{color: :yellow}) == %YourApp.Car{
               model: "SUV",
               color: :yellow
             }
    end

    test "builds YourApp.Car, [:greenish, model: \"Sport\"]" do
      assert YourApp.Factory.build(YourApp.Car, [:greenish, model: "Sport"]) == %YourApp.Car{
               model: "Sport",
               color: :green
             }
    end
  end
end
