defmodule MapBot.Sequence do
  @moduledoc false

  use GenServer

  @type state :: integer()

  @spec start_link(state) :: {:ok, pid()}
  def start_link(state \\ 1), do: GenServer.start_link(__MODULE__, state, name: __MODULE__)

  @impl true
  def init(state), do: {:ok, state}

  @spec next_int() :: state
  def next_int(), do: GenServer.call(__MODULE__, :next_int)

  @spec reset(state) :: :ok
  def reset(state), do: GenServer.cast(__MODULE__, {:reset, state})

  @impl true
  def handle_call(:next_int, _from, num), do: {:reply, num, num + 1}

  @impl true
  def handle_cast({:reset, state}, old_state), do: {:noreply, state}
end
