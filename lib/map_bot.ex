defmodule MapBot do
  @moduledoc """
  `MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.

  If you want to check how `MapBot` should be installed, configured and used please [check this out](https://hexdocs.pm/map_bot/).

  In summary you should create your own Factory module such as this:

  ```elixir
  defmodule YourApp.Factory do
    use MapBot

    @impl MapBot
    def new(YouyApp.Car), do: %YouyApp.Car{model: "SUV", color: :black}
    def new(:tomato), do: %{name: "Tomato", color: :red}
    def new(:with_code_and_ref), do: %{code: &"CODE-\#{&1}", reference: &"REF-\#{&1}"}
  end

  defmodule YourApp.Car do
    defstruct id: nil, model: nil, color: nil
  end
  ```

  For building your own maps and structs take a look on the function `MapBot.build/3`.
  """

  @type factory :: module()
  @type name :: module() | atom()
  @type attributes :: map() | keyword()
  @type result :: struct() | map()

  @callback new(name) :: result

  @doc """
  Builds an Elixir Map or Struct.

  ## Examples

      iex> YourApp.Factory.build(YourApp.Car)
      %YourApp.Car{model: "SUV", color: :black}

      iex> YourApp.Factory.build(YourApp.Car, color: :yellow)
      %YourApp.Car{model: "SUV", color: :yellow}

      iex> YourApp.Factory.build(YourApp.Car, %{color: :yellow})
      %YourApp.Car{model: "SUV", color: :yellow}

      iex> YourApp.Factory.build(:tomato)
      %{name: "Tomato", color: :red}

      iex> YourApp.Factory.build(:tomato, color: :green)
      %{name: "Tomato", color: :green}

      iex> YourApp.Factory.build(:tomato, %{color: :green})
      %{name: "Tomato", color: :green}

      iex> MapBot.Sequence.reset(123)
      iex> YourApp.Factory.build(:with_code_and_ref)
      %{code: "CODE-123", reference: "REF-123"}
  """
  @spec build(factory, name, attributes) :: result
  def build(factory, name, attrs) do
    attrs = Map.new(attrs)

    name
    |> factory.new()
    |> Map.merge(attrs)
    |> apply_sequence()
  end

  defp apply_sequence(map) do
    next_int = MapBot.Sequence.next_int()
    map |> Map.to_list() |> Enum.reduce(map, &sequence(&1, &2, next_int))
  end

  defp sequence({_key, val}, map, _i) when not is_function(val), do: map
  defp sequence({key, func}, map, i), do: Map.put(map, key, func.(i))

  defmacro __using__(_opts) do
    quote do
      @behaviour MapBot

      @spec build(MapBot.name(), MapBot.attributes()) :: MapBot.result()
      def build(name, attrs \\ []) do
        MapBot.build(__MODULE__, name, attrs)
      end
    end
  end
end
