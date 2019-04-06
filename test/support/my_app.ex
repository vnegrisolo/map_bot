defmodule MyApp.Car do
  @moduledoc false
  defstruct id: nil, color: nil, model: nil
end

defmodule MyApp.House do
  @moduledoc false
  defstruct id: nil, color: nil, style: nil

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
  use MapBot

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

defmodule MyApp.FactoryWithRepo do
  @moduledoc false
  use MapBot, repo: MyApp.Repo

  @impl MapBot
  def new(MyApp.Car) do
    %MyApp.Car{
      id: & &1,
      color: color(),
      model: ~w(Truck SUV Hatch) |> Enum.random()
    }
  end

  defp color(), do: ~w(red white black blue green)a |> Enum.random()
end

defmodule MyApp.FactoryWithRepoAndChangeset do
  @moduledoc false
  use MapBot, repo: MyApp.Repo, changeset: true

  @impl MapBot
  def new(MyApp.House) do
    %MyApp.House{
      id: & &1,
      color: color(),
      style: ~w(Asian Mediterranean Colonial American Modern) |> Enum.random()
    }
  end

  defp color(), do: ~w(red white black blue green)a |> Enum.random()
end
