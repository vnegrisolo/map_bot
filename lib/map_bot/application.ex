defmodule MapBot.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    [
      {MapBot.Sequence, 1}
    ]
    |> Supervisor.start_link(strategy: :one_for_one, name: MapBot.Supervisor)
  end
end
