# MapBot

[![CircleCI](https://circleci.com/gh/vnegrisolo/map_bot.svg?style=svg)](https://circleci.com/gh/vnegrisolo/map_bot)

`MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.

Note that this library is very flexible and also very light. It does not add any dependency in your application. In other words it does not add any third party code such `Ecto` or `Faker` but it is so flexible that you can use them if you want to as factory definition remains if your application.

## Factories Definition:

Factories are defined in a single module in your application such as:

```elixir
defmodule MyApp.Factory do
  @moduledoc false
  use MapBot, repo: MyApp.Repo, changeset: true

  deffactory(MyApp.Car) do
    %MyApp.Car{
      id: & &1,
      color: color(),
      model: ~w(Truck SUV Hatch) |> Enum.random()
    }
  end

  deffactory(:tomato) do
    %{
      name: &"Tomato-#{&1}",
      color: color()
    }
  end

  defp color(), do: ~w(red white black blue green)a |> Enum.random()
end
```

## Examples

### `attrs/2`:

```elixir
iex> MyApp.Factory.attrs(MyApp.Car)
%{id: 5, model: "Truck", color: :green}

iex> MyApp.Factory.attrs(MyApp.Car, color: :yellow)
%{id: 6, model: "Hatch", color: :yellow}

iex> MyApp.Factory.attrs(MyApp.Car, %{color: :purple})
%{id: 7, model: "Hatch", color: :purple}

iex> MyApp.Factory.attrs(:tomato)
%{name: "Tomato-8", color: :blue}

iex> MyApp.Factory.attrs(:tomato, color: :white)
%{name: "Tomato-9", color: :white}

iex> MyApp.Factory.attrs(:tomato, %{color: :pink})
%{name: "Tomato-10", color: :pink}
```

### `build/2`:

```elixir
iex> MyApp.Factory.build(MyApp.Car)
%MyApp.Car{id: 5, model: "Truck", color: :green}

iex> MyApp.Factory.build(MyApp.Car, color: :yellow)
%MyApp.Car{id: 6, model: "Hatch", color: :yellow}

iex> MyApp.Factory.build(MyApp.Car, %{color: :purple})
%MyApp.Car{id: 7, model: "Hatch", color: :purple}

iex> MyApp.Factory.build(:tomato)
%{name: "Tomato-8", color: :blue}

iex> MyApp.Factory.build(:tomato, color: :white)
%{name: "Tomato-9", color: :white}

iex> MyApp.Factory.build(:tomato, %{color: :pink})
%{name: "Tomato-10", color: :pink}
```

### `insert/2`:

```elixir
iex> MyApp.Factory.insert(MyApp.Car)
{:ok, %MyApp.Car{id: 5, model: "Truck", color: :green}}

iex> MyApp.Factory.insert(MyApp.Car, color: :yellow)
{:ok, %MyApp.Car{id: 6, model: "Hatch", color: :yellow}}

iex> MyApp.Factory.insert(MyApp.Car, %{color: :purple})
{:ok, %MyApp.Car{id: 7, model: "Hatch", color: :purple}}
```

### `insert!/2`:

```elixir
iex> MyApp.Factory.insert!(MyApp.Car)
%MyApp.Car{id: 5, model: "Truck", color: :green}

iex> MyApp.Factory.insert!(MyApp.Car, color: :yellow)
%MyApp.Car{id: 6, model: "Hatch", color: :yellow}

iex> MyApp.Factory.insert!(MyApp.Car, %{color: :purple})
%MyApp.Car{id: 7, model: "Hatch", color: :purple}
```

## Documentation

There's much more use cases on the [hexdocs/map_bot documentation][hexdocs-map_bot].

## Installation

Check out `map_bot` version on [hex.pm/map_bot][hex-pm-map_bot]. The package can be installed by adding `map_bot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:map_bot, "~> 1.3.0"}
  ]
end
```

If you are going to use `MapBot.Sequence` please start the counter by adding into your `test/test_helper.exs` the following:

```elixir
# test/test_helper.exs
{:ok, _pid} = MapBot.Sequence.start_link()
```

## Development

Check out the `Makefile` for useful development tasks.

<!-- Links & Images -->
[hex-pm-map_bot]: https://hex.pm/packages/map_bot 'MapBot on Hex'
[hexdocs-map_bot]: https://hexdocs.pm/map_bot/ 'MapBot on HexDocs'
