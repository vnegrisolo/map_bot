defmodule MapBotTest do
  use ExUnit.Case, async: true
  doctest MapBot

  defmodule YourApp do
    defmodule Car do
      defstruct model: nil, color: nil, code: nil, reference: nil
    end

    defmodule Factory do
      use MapBot

      @impl MapBot.Factory
      def new(:greenish), do: %{color: :green}
      def new(:tomato), do: %{name: "Tomato", color: :red}
      def new(Car), do: %Car{model: "SUV", color: :black}
      def new(:with_code_and_ref), do: %{code: &"CODE-#{&1}", reference: &"REF-#{&1}"}
    end
  end

  alias YourApp.Factory
  alias YourApp.Car

  describe "build/2" do
    test "builds a map with fixed values" do
      assert Factory.build(:tomato) == %{name: "Tomato", color: :red}
    end

    test "builds a struct with fixed values" do
      assert Factory.build(Car) == %Car{model: "SUV", color: :black}
    end

    test "builds a map with dynamic values" do
      assert Factory.build(:tomato, color: :green) == %{name: "Tomato", color: :green}
      assert Factory.build(:tomato, %{color: :green}) == %{name: "Tomato", color: :green}
    end

    test "builds a struct with dynamic values" do
      assert Factory.build(Car, color: :yellow) == %Car{model: "SUV", color: :yellow}
      assert Factory.build(Car, %{color: :yellow}) == %Car{model: "SUV", color: :yellow}
    end

    test "builds a struct with dynamic traits and values" do
      assert Factory.build(Car, [:greenish, model: "Sport"]) == %Car{
               model: "Sport",
               color: :green
             }
    end

    test "builds a struct with dynamic sequence values" do
      assert %Car{
               model: "SUV",
               color: :black,
               code: "CODE-" <> sequence,
               reference: "REF-" <> reference
             } = Factory.build(Car, [:with_code_and_ref])

      assert Integer.parse(sequence) > 0
      assert Integer.parse(reference) > 0
      assert sequence == reference
    end
  end
end
