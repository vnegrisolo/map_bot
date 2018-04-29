# MapBot

`MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.

## Factories Definition:

Factories are defined in a single module such as:

```elixir
defmodule MyApp.Factory do
  def new(:greenish), do: %{color: :green}
  def new(:tomato), do: %{name: "Tomato", color: :red}
  def new(MapBot.Car), do: %MapBot.Car{model: "SUV", color: :black}
  def new(:with_code), do: %{code: &"CODE-#{&1}"}
end
```

## Configuration:

Then configure `:map_bot` to use that factories definition:

```elixir
config :map_bot, factories: MyApp.Factory
```

And now you can start using the `MapBot.build/2` function.

## Usage Examples:

```elixir
MapBot.build(:tomato)
# => %{name: "Tomato", color: :red}

MapBot.build(:tomato, color: :green)
# => %{name: "Tomato", color: :green}

MapBot.build(MapBot.Car, color: :yellow)
# => %MapBot.Car{model: "SUV", color: :yellow}

MapBot.build(MapBot.Car, %{color: :yellow})
# => %MapBot.Car{model: "SUV", color: :yellow}

MapBot.build(MapBot.Car, [:greenish, model: "Sport"])
# => %MapBot.Car{model: "Sport", color: :green}

MapBot.build(MapBot.Car, [:with_code])
# => %MapBot.Car{model: "SUV", color: :black, code: "CODE-123"}
```

## Installation

Check out `map_bot` dependency version on [map_bot hex](https://hex.pm/packages/map_bot).

Change your `mix.exs` to add `map_bot` with the correct version:

```elixir
def deps do
  [
    {:map_bot, "~> 0.1.0"}
  ]
end
```

## Documentation

The `MapBot` documentation are [available here](https://hexdocs.pm/map_bot/api-reference.html).

## Development

Check out the `Makefile` for useful development tasks.
