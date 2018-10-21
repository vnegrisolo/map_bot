defmodule YourApp do
  @moduledoc false

  defmodule Car do
    @moduledoc false
    defstruct id: nil, model: nil, color: nil
  end

  defmodule Factory do
    @moduledoc false
    use MapBot

    @impl MapBot
    def new(Car), do: %Car{model: "SUV", color: :black}
    def new(:tomato), do: %{name: "Tomato", color: :red}
    def new(:with_code_and_ref), do: %{code: &"CODE-#{&1}", reference: &"REF-#{&1}"}
  end
end
