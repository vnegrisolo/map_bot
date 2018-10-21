defmodule MapBotTest do
  use ExUnit.Case, async: true
  doctest MapBot

  describe "build/3" do
    test "builds a struct with dynamic sequence values" do
      assert %{
               code: "CODE-" <> sequence,
               reference: "REF-" <> reference
             } = YourApp.Factory.build(:with_code_and_ref)

      assert Integer.parse(sequence) > 0
      assert Integer.parse(reference) > 0
      assert sequence == reference
    end
  end
end
