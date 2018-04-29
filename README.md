# MapBot

`MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.

## Usage Examples:

```elixir
MapBot.build(App.User, name: "Johnny")
# => %App.User{name: "Johnny", age: 35, email: "foo@mail.com"}
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
