# MapBot

`MapBot` builds and creates Elixir Maps/Structs based on factory definitions and attributes.

Note that this library is very flexible and also very light. It does not add any dependency in your application. In other words it does not add any third party code such `Ecto` or `Faker` but it is so flexible that you can use them if you want to as factory definition remains if your application.

## Factories Definition:

Factories are defined in a single module in your application such as:

```elixir
defmodule YourApp.Factory do
  use MapBot

  @impl MapBot
  def repo(), do: Repo

  @impl MapBot
  def new(YourApp.Car), do: %YourApp.Car{model: "SUV", color: :black}
  def new(:greenish), do: %{color: :green}
  def new(:tomato), do: %{name: "Tomato", color: :red}
  def new(:with_code_and_ref), do: %{code: &"CODE-#{&1}", reference: &"REF-#{&1}"}
end
```

This module `use MapBot` to define the functions `YourApp.Factory.build/3`, `YourApp.Factory.create/3` and `YourApp.Factory.create!/3`. These functions are simple delegations to `MapBot.build/4`, `MapBot.create/4` and `MapBot.create!/4`. It also requires you to define a `repo/0` function to return a module for `Repo.insert/1` and finally your own factory definitions by implementing the `new/1` function.

## Examples:

```elixir
YourApp.Factory.build(:tomato)
# => %{name: "Tomato", color: :red}

YourApp.Factory.build(YourApp.Car)
# => %YourApp.Car{model: "SUV", color: :black}

YourApp.Factory.build(:tomato, color: :green)
# => %{name: "Tomato", color: :green}

YourApp.Factory.build(:tomato, %{color: :green})
# => %{name: "Tomato", color: :green}

YourApp.Factory.build(YourApp.Car, color: :yellow)
# => %YourApp.Car{model: "SUV", color: :yellow}

YourApp.Factory.build(YourApp.Car, %{color: :yellow})
# => %YourApp.Car{model: "SUV", color: :yellow}

YourApp.Factory.build(YourApp.Car, [:greenish])
# => %YourApp.Car{model: "SUV", color: :green}

YourApp.Factory.build(YourApp.Car, [:greenish], model: "Sport")
# => %YourApp.Car{model: "Sport", color: :green}

YourApp.Factory.build(YourApp.Car, [:greenish, model: "Sport"])
# => %YourApp.Car{model: "Sport", color: :green}

YourApp.Factory.create(YourApp.Car, color: :yellow)
# => {:ok, %YourApp.Car{id: "123", model: "SUV", color: :yellow}}

YourApp.Factory.create!(YourApp.Car, color: :yellow)
# => %YourApp.Car{id: "123", model: "SUV", color: :yellow}
```

### Traits:

Note that if you want to compose multiple definitions to your map you can use a `trait`. This is a great feature that allows our factory definition to be very flexible.

In `MapBot` a trait is just passing another factory definition as the second or third argument for `YourApp.Factory.build/3`. You may have noted by the examples above that there's no difference between the second and the third argument, but they were split in the function definitions for readability purposes.

```elixir
YourApp.Factory.build(YourApp.Car, [:greenish])
# => %YourApp.Car{model: "SUV", color: :green}

YourApp.Factory.build(YourApp.Car, [:greenish], model: "Sport")
# => %YourApp.Car{model: "Sport", color: :green}

YourApp.Factory.build(YourApp.Car, [:greenish, model: "Sport"])
# => %YourApp.Car{model: "Sport", color: :green}
```

In the previous example we are:

1. building a map based on **YourApp.Car** factory definition;
2. then merging the result with the factory defition for the **:greenish** atom;
3. finally merging the result again with the attributes `[model: "Sport"]`

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

## Installation

Check out `map_bot` dependency version on [map_bot hex](https://hex.pm/packages/map_bot).

Change your `mix.exs` to add `map_bot` with the correct version:

```elixir
def deps do
  [
    {:map_bot, "~> 1.0.0"}
  ]
end
```

## Documentation

The `MapBot` documentation are [available here](https://hexdocs.pm/map_bot/).

## Development

Check out the `Makefile` for useful development tasks.
