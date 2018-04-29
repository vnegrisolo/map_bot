use Mix.Config

defmodule MapBot.Car do
  defstruct model: nil, color: nil, code: nil
end

defmodule MapBot.DummyFactory do
  def new(:greenish), do: %{color: :green}
  def new(:tomato), do: %{name: "Tomato", color: :red}
  def new(MapBot.Car), do: %MapBot.Car{model: "SUV", color: :black}
  def new(:with_code), do: %{code: &"CODE-#{&1}"}
end

config :map_bot, factories: MapBot.DummyFactory
