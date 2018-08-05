defmodule MapBot do
  @moduledoc """
  `MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.

  If you want to check how `MapBot` should be installed, configured and used please [check this out](https://hexdocs.pm/map_bot/).

  For building your own maps and structs take a look on the `MapBot.build/2` function.
  """

  @type factory :: module()
  @type name :: module() | atom()
  @type traits :: map() | keyword()
  @type attributes :: map() | keyword()
  @type result :: struct() | map()
  @type repo :: module()

  @callback new(name) :: result
  @callback repo :: repo

  @doc "Creates an Elixir Map or Struct using your Repo.insert/1"
  @spec create(factory, name, traits, attributes) :: {:ok, result}
  def create(factory, name, traits \\ [], attrs \\ []) do
    factory |> build(name, traits, attrs) |> factory.repo().insert()
  end

  @doc "Creates an Elixir Map or Struct using your Repo.insert!/1"
  @spec create!(factory, name, traits, attributes) :: result
  def create!(factory, name, traits \\ [], attrs \\ []) do
    factory |> build(name, traits, attrs) |> factory.repo().insert!()
  end

  @doc "Builds an Elixir Map or Struct."
  @spec build(factory, name, traits, attributes) :: result
  def build(factory, name, traits \\ [], attrs \\ [])

  def build(factory, name, %{} = traits, attrs) do
    build(factory, name, Map.to_list(traits), attrs)
  end

  def build(factory, name, traits, %{} = attrs) do
    build(factory, name, traits, Map.to_list(attrs))
  end

  def build(factory, name, traits, attrs) do
    ([name] ++ traits ++ attrs)
    |> Enum.reduce(%{}, &apply_attr(factory, &1, &2))
    |> apply_sequence()
  end

  defp apply_attr(_factory, {key, value}, map), do: Map.put(map, key, value)
  defp apply_attr(factory, name, map), do: Map.merge(map, factory.new(name))

  defp apply_sequence(map) do
    next_int = MapBot.Sequence.next_int()
    map |> Map.to_list() |> Enum.reduce(map, &sequence(&1, &2, next_int))
  end

  defp sequence({_key, val}, map, _i) when not is_function(val), do: map
  defp sequence({key, func}, map, i), do: Map.put(map, key, func.(i))

  defmacro __using__(_opts) do
    quote do
      @behaviour MapBot

      def create(name, traits \\ [], attrs \\ []) do
        MapBot.create(__MODULE__, name, traits, attrs)
      end

      def create!(name, traits \\ [], attrs \\ []) do
        MapBot.create!(__MODULE__, name, traits, attrs)
      end

      def build(name, traits \\ [], attrs \\ []) do
        MapBot.build(__MODULE__, name, traits, attrs)
      end
    end
  end
end
