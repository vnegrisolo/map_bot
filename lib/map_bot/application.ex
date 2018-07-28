defmodule MapBot.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [{MapBot.Sequence, 1}]
    opts = [strategy: :one_for_one, name: MapBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
