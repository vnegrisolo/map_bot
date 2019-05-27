defmodule MapBot do
  @moduledoc """
  `#{__MODULE__}` builds Elixir Maps/Structs based on factory definitions and attributes.

  Let's see how to use this library by examples:

  ## Examples setup:

  ```elixir
  #{:map_bot |> :code.priv_dir() |> Path.join("support/my_app.ex") |> File.read!()}
  ```

  ## Examples

  ### `attrs/2`:

      iex> #{__MODULE__}.Sequence.reset(5)
      iex> :rand.seed(:exsplus, {1, 2, 3})
      ...>
      iex> MyApp.FactoryWithNoRepo.attrs(MyApp.Car)
      %{id: 5, model: "Truck", color: :green}
      ...>
      iex> MyApp.FactoryWithNoRepo.attrs(MyApp.Car, color: :yellow)
      %{id: 6, model: "Hatch", color: :yellow}
      ...>
      iex> MyApp.FactoryWithNoRepo.attrs(MyApp.Car, %{color: :purple})
      %{id: 7, model: "Hatch", color: :purple}
      ...>
      iex> MyApp.FactoryWithNoRepo.attrs(:tomato)
      %{name: "Tomato-8", color: :blue}
      ...>
      iex> MyApp.FactoryWithNoRepo.attrs(:tomato, color: :white)
      %{name: "Tomato-9", color: :white}
      ...>
      iex> MyApp.FactoryWithNoRepo.attrs(:tomato, %{color: :pink})
      %{name: "Tomato-10", color: :pink}

  ### `build/2`:

      iex> #{__MODULE__}.Sequence.reset(5)
      iex> :rand.seed(:exsplus, {1, 2, 3})
      ...>
      iex> MyApp.FactoryWithNoRepo.build(MyApp.Car)
      %MyApp.Car{id: 5, model: "Truck", color: :green}
      ...>
      iex> MyApp.FactoryWithNoRepo.build(MyApp.Car, color: :yellow)
      %MyApp.Car{id: 6, model: "Hatch", color: :yellow}
      ...>
      iex> MyApp.FactoryWithNoRepo.build(MyApp.Car, %{color: :purple})
      %MyApp.Car{id: 7, model: "Hatch", color: :purple}
      ...>
      iex> MyApp.FactoryWithNoRepo.build(:tomato)
      %{name: "Tomato-8", color: :blue}
      ...>
      iex> MyApp.FactoryWithNoRepo.build(:tomato, color: :white)
      %{name: "Tomato-9", color: :white}
      ...>
      iex> MyApp.FactoryWithNoRepo.build(:tomato, %{color: :pink})
      %{name: "Tomato-10", color: :pink}

  ### `insert/2`:

      iex> #{__MODULE__}.Sequence.reset(5)
      iex> :rand.seed(:exsplus, {1, 2, 3})
      ...>
      iex> MyApp.FactoryWithRepo.insert(MyApp.Car)
      {:ok, %MyApp.Car{id: 5, model: "Truck", color: :green}}
      ...>
      iex> MyApp.FactoryWithRepo.insert(MyApp.Car, color: :yellow)
      {:ok, %MyApp.Car{id: 6, model: "Hatch", color: :yellow}}
      ...>
      iex> MyApp.FactoryWithRepo.insert(MyApp.Car, %{color: :purple})
      {:ok, %MyApp.Car{id: 7, model: "Hatch", color: :purple}}
      ...>
      iex> MyApp.FactoryWithRepoAndChangeset.insert(MyApp.House)
      {:ok, %MyApp.House{id: 8, style: "Asian", color: :blue}}
      ...>
      iex> MyApp.FactoryWithRepoAndChangeset.insert(MyApp.House, color: :yellow)
      {:ok, %MyApp.House{id: 9, style: "Asian", color: :yellow}}
      ...>
      iex> MyApp.FactoryWithRepoAndChangeset.insert(MyApp.House, %{color: :purple})
      {:ok, %MyApp.House{id: 10, style: "American", color: :purple}}

  ### `insert!/2`:

      iex> #{__MODULE__}.Sequence.reset(5)
      iex> :rand.seed(:exsplus, {1, 2, 3})
      ...>
      iex> MyApp.FactoryWithRepo.insert!(MyApp.Car)
      %MyApp.Car{id: 5, model: "Truck", color: :green}
      ...>
      iex> MyApp.FactoryWithRepo.insert!(MyApp.Car, color: :yellow)
      %MyApp.Car{id: 6, model: "Hatch", color: :yellow}
      ...>
      iex> MyApp.FactoryWithRepo.insert!(MyApp.Car, %{color: :purple})
      %MyApp.Car{id: 7, model: "Hatch", color: :purple}
      ...>
      iex> MyApp.FactoryWithRepoAndChangeset.insert!(MyApp.House)
      %MyApp.House{id: 8, style: "Asian", color: :blue}
      ...>
      iex> MyApp.FactoryWithRepoAndChangeset.insert!(MyApp.House, color: :yellow)
      %MyApp.House{id: 9, style: "Asian", color: :yellow}
      ...>
      iex> MyApp.FactoryWithRepoAndChangeset.insert!(MyApp.House, %{color: :purple})
      %MyApp.House{id: 10, style: "American", color: :purple}
  """

  @type map_bot_name :: module() | atom()
  @type map_bot_use_option :: {:repo, module} | {:changeset, boolean}

  @doc """
  Macro that defines a factory for the `name` argument.
  """
  @spec deffactory(map_bot_name, do: any) :: any
  defmacro deffactory(name, do: block) do
    quote do
      defp new(unquote(name)), do: unquote(block)
    end
  end

  @doc """
  Use `__MODULE__` with the following options:

  - `:repo` => Repository module to delegate calls on `insert/1` and `insert!/1`
  - `:changeset` => If `true` a `changeset/2` function will be called when inserting into the Repo

  ## Examples

      iex> MyApp.FactoryWithNoRepo.__info__(:functions)
      [attrs: 1, attrs: 2, build: 1, build: 2]

      iex> MyApp.FactoryWithRepo.__info__(:functions)
      [attrs: 1, attrs: 2, build: 1, build: 2, insert: 1, insert: 2, insert!: 1, insert!: 2]

      iex> MyApp.FactoryWithRepoAndChangeset.__info__(:functions)
      [attrs: 1, attrs: 2, build: 1, build: 2, insert: 1, insert: 2, insert!: 1, insert!: 2, validate: 2]

  """
  @spec __using__([map_bot_use_option]) :: any
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      import MapBot, only: [deffactory: 2]

      @map_bot_repo Keyword.get(opts, :repo)
      @map_bot_changeset Keyword.get(opts, :changeset, false)

      @type map_bot_name :: module() | atom()
      @type map_bot_attributes :: map() | keyword()
      @type map_bot_result :: struct() | map()

      @spec attrs(map_bot_name, map_bot_attributes) :: map
      def attrs(name, attrs \\ []) do
        case build(name, attrs) do
          %_{} = struct -> Map.from_struct(struct)
          map -> map
        end
      end

      @spec build(map_bot_name, map_bot_attributes) :: map_bot_result
      def build(name, attrs \\ []) do
        attrs = Map.new(attrs)

        name
        |> new()
        |> Map.merge(attrs)
        |> MapBot.Sequence.apply()
      end

      if @map_bot_repo do
        @spec insert(map_bot_name, map_bot_attributes) :: {:ok, map_bot_result}
        def insert(name, attrs \\ []) do
          name
          |> build_maybe_validate(attrs)
          |> @map_bot_repo.insert()
        end

        @spec insert!(map_bot_name, map_bot_attributes) :: map_bot_result
        def insert!(name, attrs \\ []) do
          name
          |> build_maybe_validate(attrs)
          |> @map_bot_repo.insert!()
        end

        if @map_bot_changeset do
          defp build_maybe_validate(name, attrs) do
            new_attrs = attrs(name, attrs)
            validate(name, new_attrs)
          end

          def validate(name, attrs) do
            name
            |> struct()
            |> name.changeset(attrs)
          end
        else
          defp build_maybe_validate(name, attrs) do
            build(name, attrs)
          end
        end
      end
    end
  end
end
