ExUnit.start()

{:ok, files} = File.ls("./test/support")
files |> Enum.map(&"support/#{&1}") |> Enum.each(&Code.require_file(&1, __DIR__))
