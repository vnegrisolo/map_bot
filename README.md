# MapBot

[![CircleCI](https://circleci.com/gh/vnegrisolo/map_bot.svg?style=svg)](https://circleci.com/gh/vnegrisolo/map_bot)

`MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.

Note that this library is very flexible and also very light. It does not add any dependency in your application. In other words it does not add any third party code such `Ecto` or `Faker` but it is so flexible that you can use them if you want to as factory definition remains if your application.

## Factories Definition:

Factories are defined in a single module in your application such as:

```elixir
defmodule YourApp.Factory do
  use MapBot

  @impl MapBot
  def new(YourApp.Car), do: %YourApp.Car{model: "SUV", color: :black}
  def new(:tomato), do: %{name: "Tomato", color: :red}
  def new(:with_code_and_ref), do: %{code: &"CODE-#{&1}", reference: &"REF-#{&1}"}
end
```

This module `use MapBot` to define the function `YourApp.Factory.build/2`. This function is a simple delegation to `MapBot.build/3`. It also requires you to define your own factory definitions by implementing the `new/1` function.

## Examples:

```elixir
YourApp.Factory.build(YourApp.Car)
# => %YourApp.Car{model: "SUV", color: :black}

YourApp.Factory.build(YourApp.Car, color: :yellow)
# => %YourApp.Car{model: "SUV", color: :yellow}

YourApp.Factory.build(YourApp.Car, %{color: :yellow})
# => %YourApp.Car{model: "SUV", color: :yellow}

YourApp.Factory.build(:tomato)
# => %{name: "Tomato", color: :red}

YourApp.Factory.build(:tomato, color: :green)
# => %{name: "Tomato", color: :green}

YourApp.Factory.build(:tomato, %{color: :green})
# => %{name: "Tomato", color: :green}
```

### Sequences:

In order to prevent not unique errors by database constraints and to have a more flexible data you can use a sequence inside your factory definition. To do that use a function with arity 1 and the first argument of that function will be a auto incremented integer.

```elixir
defmodule YourApp.Factory do
  def new(:with_code), do: %{code: &"CODE-#{&1}"}
end
```

will produce:

```elixir
YourApp.Factory.build(:with_code) # %{code: "CODE-1"}
YourApp.Factory.build(:with_code) # %{code: "CODE-2"}
YourApp.Factory.build(:with_code) # %{code: "CODE-3"}
```

Note that this `&"CODE-#{&1}"` is a very short Elixir syntax equivalent for:

```elixir
fn i -> "CODE-#{i}" end
# is the same as `&"CODE-#{&1}"`
```

## Documentation

There's much more use cases on the [hexdocs/map_bot documentation][hexdocs-map_bot].

## Installation

Check out `map_bot` version on [hex.pm/map_bot][hex-pm-map_bot]. The package can be installed by adding `map_bot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:map_bot, "~> 1.2.0"}
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
