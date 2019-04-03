defmodule MyApp do
  @moduledoc false

  defmodule Car do
    @moduledoc false
    defstruct id: nil,
              color: nil,
              model: nil
  end

  defmodule Factory do
    @moduledoc false
    use MapBot

    @impl MapBot
    def new(Car) do
      %Car{
        id: & &1,
        color: ~w(red white black blue green)a |> Enum.random(),
        model: ~w(Truck SUV Hatch) |> Enum.random()
      }
    end

    def new(:tomato) do
      %{
        name: &"Tomato-#{&1}",
        color: ~w(red green yellow)a |> Enum.random()
      }
    end
  end
end
