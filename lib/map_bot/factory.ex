defmodule MapBot.Factory do
  @moduledoc false
  @callback new(MapBot.name()) :: MapBot.result()
end
