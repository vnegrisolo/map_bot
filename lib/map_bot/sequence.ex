defmodule MapBot.Sequence do
  @moduledoc false

  use GenServer

  def start_link(state), do: GenServer.start_link(__MODULE__, state, name: __MODULE__)

  @impl true
  def init(state), do: {:ok, state}

  def next_int(), do: GenServer.call(__MODULE__, :next_int)

  @impl true
  def handle_call(:next_int, _from, num), do: {:reply, num, num + 1}
end
