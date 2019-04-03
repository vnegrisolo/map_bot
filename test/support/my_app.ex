defmodule MyApp do
  @moduledoc false

  defmodule Car do
    @moduledoc false
    defstruct id: nil, color: nil, model: nil
  end

  defmodule Repo do
    @moduledoc false
    def insert(schema), do: {:ok, schema}
    def insert!(schema), do: schema
  end

  defmodule Factory do
    @moduledoc false
    use MapBot, repo: Repo

    @impl MapBot
    def new(Car) do
      %Car{
        id: & &1,
        color: color(),
        model: ~w(Truck SUV Hatch) |> Enum.random()
      }
    end

    def new(:tomato) do
      %{
        name: &"Tomato-#{&1}",
        color: color()
      }
    end

    defp color(), do: ~w(red white black blue green)a |> Enum.random()
  end
end
