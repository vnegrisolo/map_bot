defmodule MapBot.MixProject do
  use Mix.Project

  @app :map_bot
  @name "MapBot"

  def project do
    [
      app: @app,
      deps: deps(),
      docs: [
        main: "readme",
        extras: ~w(README.md),
        javascript_config_path: "../.doc-versions.js"
      ],
      elixir: "~> 1.7",
      name: @name,
      package: package(),
      source_url: "https://github.com/vnegrisolo/#{@app}",
      start_permanent: Mix.env() == :prod,
      version: "1.3.2"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:credo, "~> 1.1.0", only: :test},
      {:dialyxir, "~> 0.5.1", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package() do
    [
      description: """
      `#{@name}` builds Elixir Maps/Structs based on factory definitions and attributes.
      """,
      licenses: ~w(MIT),
      links: %{
        github: "https://github.com/vnegrisolo/#{@app}"
      },
      maintainers: ["Vinicius Ferreira Negrisolo"]
    ]
  end
end
