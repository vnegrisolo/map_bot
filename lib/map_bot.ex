defmodule MapBot do
  @moduledoc """
  `MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.

  Let's see how to use this library by examples:

  ## Examples setup:

  ```elixir
  #{File.read!("test/support/my_app.ex")}
  ```

  ## Examples

  ### `attrs/2`:

      iex> MapBot.Sequence.reset(5)
      iex> :rand.seed(:exsplus, {1, 2, 3})
      ...>
      iex> MyApp.Factory.attrs(MyApp.Car)
      %{id: 5, model: "Truck", color: :green}
      ...>
      iex> MyApp.Factory.attrs(:tomato)
      %{name: "Tomato-6", color: :green}

  ### `build/2`:

      iex> MapBot.Sequence.reset(5)
      iex> :rand.seed(:exsplus, {1, 2, 3})
      ...>
      iex> MyApp.Factory.build(MyApp.Car)
      %MyApp.Car{id: 5, model: "Truck", color: :green}
      ...>
      iex> MyApp.Factory.build(:tomato)
      %{name: "Tomato-6", color: :green}
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
    |> MapBot.Sequence.apply()
  end

  defmacro __using__(_opts) do
    quote do
      @behaviour MapBot

      @spec build(MapBot.name(), MapBot.attributes()) :: MapBot.result()
      def build(name, attrs \\ []) do
        MapBot.build(__MODULE__, name, attrs)
      end

      @spec attrs(MapBot.name(), MapBot.attributes()) :: map()
      def attrs(name, attrs \\ []) do
        case build(name, attrs) do
          %_{} = struct -> Map.from_struct(struct)
          map -> map
        end
      end
    end
  end
end
