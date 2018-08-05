defmodule YourApp do
  @moduledoc false

  defmodule Repo do
    @moduledoc false

    def insert(map), do: {:ok, insert!(map)}
    def insert!(map), do: Map.put(map, :id, "123")
  end

  defmodule Car do
    @moduledoc false

    defstruct id: nil, model: nil, color: nil, code: nil, reference: nil
  end

  defmodule Factory do
    @moduledoc false

    use MapBot

    @impl MapBot
    def repo(), do: Repo

    @impl MapBot
    def new(Car), do: %Car{model: "SUV", color: :black}
    def new(:greenish), do: %{color: :green}
    def new(:tomato), do: %{name: "Tomato", color: :red}
    def new(:with_code_and_ref), do: %{code: &"CODE-#{&1}", reference: &"REF-#{&1}"}
  end
end
