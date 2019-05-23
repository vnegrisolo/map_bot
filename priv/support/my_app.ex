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

defmodule MyApp.FactoryWithNoRepo do
  @moduledoc false
  use MapBot

  deffactory(MyApp.Car) do
    %MyApp.Car{
      id: & &1,
      color: color(),
      model: ~w(Truck SUV Hatch) |> Enum.random()
    }
  end

  deffactory(:tomato) do
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

  deffactory(MyApp.Car) do
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

  deffactory(MyApp.House) do
    %MyApp.House{
      id: & &1,
      color: color(),
      style: ~w(Asian Mediterranean Colonial American Modern) |> Enum.random()
    }
  end

  defp color(), do: ~w(red white black blue green)a |> Enum.random()
end
