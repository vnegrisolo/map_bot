use Mix.Config

defmodule YourApp.Car do
  defstruct model: nil, color: nil, code: nil
end

defmodule YourApp.Factory do
  def new(:greenish), do: %{color: :green}
  def new(:tomato), do: %{name: "Tomato", color: :red}
  def new(YourApp.Car), do: %YourApp.Car{model: "SUV", color: :black}
  def new(:with_code), do: %{code: &"CODE-#{&1}"}
end

config :map_bot, factories: YourApp.Factory
