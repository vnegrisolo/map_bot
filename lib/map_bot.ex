defmodule MapBot do
  @moduledoc """
  `MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.

  If you want to check how `MapBot` should be installed, configured and used please [check this out](https://hexdocs.pm/map_bot/).

  For building your own maps and structs take a look on the `MapBot.build/2` function.
  """

  @type name :: module() | atom()
  @type traits :: map() | keyword()
  @type attributes :: map() | keyword()
  @type result :: struct() | map()
  @type repo :: module()

  @callback new(name) :: result
  @callback repo :: repo

  defmacro __using__(_opts) do
    quote do
      @behaviour MapBot

      @doc "Creates an Elixir Map/Struct using Repo.insert/1"
      @spec create(MapBot.name(), MapBot.traits(), MapBot.attributes()) :: {:ok, MapBot.result()}
      def create(name, traits \\ [], attrs \\ []) do
        name |> build(traits, attrs) |> repo().insert()
      end

      @doc "Creates an Elixir Map/Struct using Repo.insert!/1"
      @spec create!(MapBot.name(), MapBot.traits(), MapBot.attributes()) :: MapBot.result()
      def create!(name, traits \\ [], attrs \\ []) do
        name |> build(traits, attrs) |> repo().insert!()
      end

      @doc "Builds an Elixir Map/Struct."
      @spec build(MapBot.name(), MapBot.traits(), MapBot.attributes()) :: MapBot.result()
      def build(name, traits \\ [], attrs \\ [])
      def build(name, %{} = traits, attrs), do: build(name, Map.to_list(traits), attrs)
      def build(name, traits, %{} = attrs), do: build(name, traits, Map.to_list(attrs))

      def build(name, traits, attrs) do
        ([name] ++ traits ++ attrs)
        |> Enum.reduce(%{}, &apply_attr/2)
        |> apply_sequence()
      end

      defp apply_attr({key, value}, map), do: Map.put(map, key, value)
      defp apply_attr(name, map), do: Map.merge(map, new(name))

      defp apply_sequence(map) do
        next_int = MapBot.Sequence.next_int()
        map |> Map.to_list() |> Enum.reduce(map, &sequence(&1, &2, next_int))
      end

      defp sequence({_key, val}, map, _i) when not is_function(val), do: map
      defp sequence({key, func}, map, i), do: Map.put(map, key, func.(i))
    end
  end
end
