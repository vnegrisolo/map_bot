# MapBot

`MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.

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

MapBot.build(MapBot.Car, :greenish, model: "Sport")
# => %MapBot.Car{model: "Sport", color: :green}
```

## Development

Check out the `Makefile` for useful development tasks.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `map_bot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:map_bot, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/map_bot](https://hexdocs.pm/map_bot).
