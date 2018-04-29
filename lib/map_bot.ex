defmodule MapBot do
  @moduledoc """
  `MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.

  ## Factories Definition:

  Factories are defined in a single module such as:

  ```elixir
  defmodule MyApp.Factory do
    def new(:greenish), do: %{color: :green}
    def new(:tomato), do: %{name: "Tomato", color: :red}
    def new(MapBot.Car), do: %MapBot.Car{model: "SUV", color: :black}
    def new(:with_code), do: %{code: &"CODE-\#{&1}"}
  end
  ```

  ## Configuration:

  Then configure `:map_bot` to use that factories definition:

  ```elixir
  config :map_bot, factories: MyApp.Factory
  ```

  And now you can start using the `MapBot.build/2` function.
  """

  @type name :: module() | atom()
  @type attributes :: map() | keyword()
  @type result :: struct() | map()

  @doc """
  Builds an Elixir Map/Struct.

  ## Examples

      iex> MapBot.build(:tomato)
      %{name: "Tomato", color: :red}

      iex> MapBot.build(:tomato, color: :green)
      %{name: "Tomato", color: :green}

      iex> MapBot.build(MapBot.Car, color: :yellow)
      %MapBot.Car{model: "SUV", color: :yellow}

      iex> MapBot.build(MapBot.Car, %{color: :yellow})
      %MapBot.Car{model: "SUV", color: :yellow}

      iex> MapBot.build(MapBot.Car, [:greenish, model: "Sport"])
      %MapBot.Car{model: "Sport", color: :green}
  """
  @spec build(name, attributes) :: result
  def build(name, attrs \\ [])
  def build(name, %{} = attrs), do: build(name, Map.to_list(attrs))

  def build(name, attrs) do
    map = Enum.reduce([name | attrs], %{}, &apply_attr/2)
    Enum.reduce(Map.to_list(map), map, &apply_sequence/2)
  end

  defp apply_attr({key, value}, map), do: Map.put(map, key, value)
  defp apply_attr(name, map), do: Map.merge(map, factories().new(name))

  defp apply_sequence({key, func}, map) when is_function(func) do
    value = func.(MapBot.Sequence.next_int())
    apply_attr({key, value}, map)
  end

  defp apply_sequence({_key, _value}, map), do: map

  defp factories(), do: Application.get_env(:map_bot, :factories)
end
