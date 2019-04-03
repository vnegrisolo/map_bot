defmodule MyApp.Car do
  @moduledoc false
  defstruct id: nil, color: nil, model: nil

  def changeset(%__MODULE__{} = schema, attrs) do
    Map.merge(schema, attrs)
  end
end

defmodule MyApp.Repo do
  @moduledoc false
  def insert(schema), do: {:ok, schema}
  def insert!(schema), do: schema
end

defmodule MyApp.Factory do
  @moduledoc false
  use MapBot, repo: MyApp.Repo, changeset: true

  @impl MapBot
  def new(MyApp.Car) do
    %MyApp.Car{
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
