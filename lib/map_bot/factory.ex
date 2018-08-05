defmodule MapBot.Factory do
  @moduledoc false
  @callback new(MapBot.name()) :: MapBot.result()

  @moduledoc false
  @callback repo() :: MapBot.repo()
end
