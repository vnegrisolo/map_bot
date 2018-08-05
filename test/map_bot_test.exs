defmodule MapBotTest do
  use ExUnit.Case, async: true
  doctest MapBot

  describe "build/3" do
    test "builds a map with fixed values" do
      assert YourApp.Factory.build(:tomato) == %{name: "Tomato", color: :red}
    end

    test "builds a struct with fixed values" do
      assert YourApp.Factory.build(YourApp.Car) == %YourApp.Car{model: "SUV", color: :black}
    end

    test "builds a map with dynamic values" do
      assert YourApp.Factory.build(:tomato, color: :green) == %{name: "Tomato", color: :green}
      assert YourApp.Factory.build(:tomato, %{color: :green}) == %{name: "Tomato", color: :green}
    end

    test "builds a struct with dynamic values" do
      assert YourApp.Factory.build(YourApp.Car, color: :yellow) == %YourApp.Car{
               model: "SUV",
               color: :yellow
             }

      assert YourApp.Factory.build(YourApp.Car, %{color: :yellow}) == %YourApp.Car{
               model: "SUV",
               color: :yellow
             }
    end

    test "builds a struct with dynamic traits and values" do
      assert YourApp.Factory.build(YourApp.Car, [:greenish, model: "Sport"]) == %YourApp.Car{
               model: "Sport",
               color: :green
             }

      assert YourApp.Factory.build(YourApp.Car, [:greenish], model: "Sport") == %YourApp.Car{
               model: "Sport",
               color: :green
             }
    end

    test "builds a struct with dynamic sequence values" do
      assert %YourApp.Car{
               model: "SUV",
               color: :black,
               code: "CODE-" <> sequence,
               reference: "REF-" <> reference
             } = YourApp.Factory.build(YourApp.Car, [:with_code_and_ref])

      assert Integer.parse(sequence) > 0
      assert Integer.parse(reference) > 0
      assert sequence == reference
    end
  end

  describe "create/3" do
    test "builds a map with fixed values" do
      assert YourApp.Factory.create(:tomato) == {:ok, %{id: "123", name: "Tomato", color: :red}}
    end
  end

  describe "create!/3" do
    test "builds a map with fixed values" do
      assert YourApp.Factory.create!(:tomato) == %{id: "123", name: "Tomato", color: :red}
    end
  end
end
