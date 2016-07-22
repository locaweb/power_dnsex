ExUnit.start()

{:ok, files} = File.ls("./test/support/")

Enum.each files, fn(file) ->
  if String.match?(file, ~r/(.*).exs$/) do
    Code.require_file "support/#{file}", __DIR__
  end
end
