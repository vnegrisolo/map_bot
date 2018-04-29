defmodule MapBot do
  @moduledoc """
  `MapBot` builds Elixir Maps/Structs based on factory definitions and attributes.
  """

  @doc """
  Builds an Elixir Map/Struct.

  ## Examples

      iex> MapBot.build(:tomato)
      %{name: "Tomato", color: :red}

  """
  @spec build(atom()) :: map()
  def build(name) do
    factories().new(name)
  end

  defp factories() do
    Application.get_env(:map_bot, :factories)
  end
end
