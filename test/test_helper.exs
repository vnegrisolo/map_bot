{:ok, _pid} = MapBot.Sequence.start_link()
ExUnit.start()

support_path = :map_bot |> :code.priv_dir() |> Path.join("support")
{:ok, files} = support_path |> File.ls()

files
|> Enum.map(&Path.join(support_path, &1))
|> Enum.each(&Code.require_file(&1, __DIR__))
