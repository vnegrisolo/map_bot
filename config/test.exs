use Mix.Config

defmodule MapBot.Test.Car do
  defstruct model: nil, color: nil, code: nil
end

defmodule MapBot.Test.Factory do
  def new(:greenish), do: %{color: :green}
  def new(:tomato), do: %{name: "Tomato", color: :red}
  def new(MapBot.Test.Car), do: %MapBot.Test.Car{model: "SUV", color: :black}
  def new(:with_code), do: %{code: &"CODE-#{&1}"}
end

config :map_bot, factories: MapBot.Test.Factory
