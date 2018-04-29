use Mix.Config

defmodule MapBot.DummyFactory do
  def new(:tomato), do: %{name: "Tomato", color: :red}
end

config :map_bot, factories: MapBot.DummyFactory
