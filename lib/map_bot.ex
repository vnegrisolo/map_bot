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
      iex> MyApp.Factory.attrs(MyApp.Car, color: :yellow)
      %{id: 6, model: "Hatch", color: :yellow}
      ...>
      iex> MyApp.Factory.attrs(MyApp.Car, %{color: :purple})
      %{id: 7, model: "Hatch", color: :purple}
      ...>
      iex> MyApp.Factory.attrs(:tomato)
      %{name: "Tomato-8", color: :blue}
      ...>
      iex> MyApp.Factory.attrs(:tomato, color: :white)
      %{name: "Tomato-9", color: :white}
      ...>
      iex> MyApp.Factory.attrs(:tomato, %{color: :pink})
      %{name: "Tomato-10", color: :pink}

  ### `build/2`:

      iex> MapBot.Sequence.reset(5)
      iex> :rand.seed(:exsplus, {1, 2, 3})
      ...>
      iex> MyApp.Factory.build(MyApp.Car)
      %MyApp.Car{id: 5, model: "Truck", color: :green}
      ...>
      iex> MyApp.Factory.build(MyApp.Car, color: :yellow)
      %MyApp.Car{id: 6, model: "Hatch", color: :yellow}
      ...>
      iex> MyApp.Factory.build(MyApp.Car, %{color: :purple})
      %MyApp.Car{id: 7, model: "Hatch", color: :purple}
      ...>
      iex> MyApp.Factory.build(:tomato)
      %{name: "Tomato-8", color: :blue}
      ...>
      iex> MyApp.Factory.build(:tomato, color: :white)
      %{name: "Tomato-9", color: :white}
      ...>
      iex> MyApp.Factory.build(:tomato, %{color: :pink})
      %{name: "Tomato-10", color: :pink}

  ### `insert/2`:

      iex> MapBot.Sequence.reset(5)
      iex> :rand.seed(:exsplus, {1, 2, 3})
      ...>
      iex> MyApp.Factory.insert(MyApp.Car)
      {:ok, %MyApp.Car{id: 5, model: "Truck", color: :green}}
      ...>
      iex> MyApp.Factory.insert(MyApp.Car, color: :yellow)
      {:ok, %MyApp.Car{id: 6, model: "Hatch", color: :yellow}}
      ...>
      iex> MyApp.Factory.insert(MyApp.Car, %{color: :purple})
      {:ok, %MyApp.Car{id: 7, model: "Hatch", color: :purple}}

  ### `insert!/2`:

      iex> MapBot.Sequence.reset(5)
      iex> :rand.seed(:exsplus, {1, 2, 3})
      ...>
      iex> MyApp.Factory.insert!(MyApp.Car)
      %MyApp.Car{id: 5, model: "Truck", color: :green}
      ...>
      iex> MyApp.Factory.insert!(MyApp.Car, color: :yellow)
      %MyApp.Car{id: 6, model: "Hatch", color: :yellow}
      ...>
      iex> MyApp.Factory.insert!(MyApp.Car, %{color: :purple})
      %MyApp.Car{id: 7, model: "Hatch", color: :purple}
  """

  @type name :: module() | atom()
  @type result :: struct() | map()

  @callback new(name) :: result

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour MapBot

      @repo Keyword.get(opts, :repo)
      @changeset Keyword.get(opts, :changeset, false)

      @type factory :: module()
      @type name :: module() | atom()
      @type attributes :: map() | keyword()
      @type result :: struct() | map()

      if @repo do
        if @changeset do
          @spec changeset(name, attributes) :: result
          def changeset(name, attrs) do
            new_attrs = attrs(name, attrs)

            name
            |> struct()
            |> name.changeset(new_attrs)
          end
        else
          @spec changeset(name, attributes) :: result
          def changeset(name, attrs) do
            build(name, attrs)
          end
        end

        @spec insert(name, attributes) :: {:ok, result}
        def insert(name, attrs \\ []) do
          name
          |> changeset(attrs)
          |> @repo.insert()
        end

        @spec insert!(name, attributes) :: result
        def insert!(name, attrs \\ []) do
          name
          |> changeset(attrs)
          |> @repo.insert!()
        end
      end

      @spec build(name, attributes) :: result
      def build(name, attrs \\ []) do
        attrs = Map.new(attrs)

        name
        |> new()
        |> Map.merge(attrs)
        |> MapBot.Sequence.apply()
      end

      @spec attrs(name, attributes) :: map
      def attrs(name, attrs \\ []) do
        case build(name, attrs) do
          %_{} = struct -> Map.from_struct(struct)
          map -> map
        end
      end
    end
  end
end
