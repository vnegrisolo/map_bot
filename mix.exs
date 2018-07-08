defmodule MapBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :map_bot,
      version: "0.1.1",
      package: package(),
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/vnegrisolo/map_bot",
      name: "MapBot",
      docs: [main: "readme", extras: ~w(README.md)]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MapBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.9.2", only: :test},
      {:dialyxir, "~> 0.5.1", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package() do
    [
      description: """
      `MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.
      """,
      licenses: ~w(MIT),
      maintainers: ["Vinicius Ferreira Negrisolo"],
      links: %{
        github: "https://github.com/vnegrisolo/map_bot"
      }
    ]
  end
end
