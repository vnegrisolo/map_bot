defmodule MapBot do
  @moduledoc """
  `MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.
  """

  use GenServer

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
    Map.put(map, key, func.(next_int()))
  end

  defp apply_sequence({_key, _value}, map), do: map

  def start_link(), do: GenServer.start_link(__MODULE__, 1, name: __MODULE__)

  @impl true
  def init(state), do: {:ok, state}

  def next_int(), do: GenServer.call(__MODULE__, :next_int)

  @impl true
  def handle_call(:next_int, _from, next), do: {:reply, next, next + 1}

  defp factories(), do: Application.get_env(:map_bot, :factories)
end
