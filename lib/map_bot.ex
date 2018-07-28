defmodule MapBot do
  @moduledoc """
  `MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.

  If you want to check how `MapBot` should be installed, configured and used please [check this out](https://hexdocs.pm/map_bot/).

  For building your own maps and structs take a look on the `MapBot.build/2` function.
  """

  defmacro __using__(_opts) do
    quote do
      @type name :: module() | atom()
      @type attributes :: map() | keyword()
      @type result :: struct() | map()

      @doc "Builds an Elixir Map/Struct."
      @spec build(name, attributes) :: result
      def build(name, attrs \\ [])
      def build(name, %{} = attrs), do: build(name, Map.to_list(attrs))

      def build(name, attrs) do
        map = Enum.reduce([name | attrs], %{}, &apply_attr/2)
        Enum.reduce(Map.to_list(map), map, &apply_sequence/2)
      end

      defp apply_attr({key, value}, map), do: Map.put(map, key, value)
      defp apply_attr(name, map), do: Map.merge(map, new(name))

      defp apply_sequence({key, func}, map) when is_function(func) do
        value = func.(MapBot.Sequence.next_int())
        apply_attr({key, value}, map)
      end

      defp apply_sequence({_key, _value}, map), do: map
    end
  end
end
