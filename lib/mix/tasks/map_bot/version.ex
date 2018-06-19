defmodule Mix.Tasks.MapBot.Version do
  use Mix.Task

  @shortdoc "MapBot version"
  def run(_) do
    IO.puts(Mix.Project.config()[:version])
  end
end
