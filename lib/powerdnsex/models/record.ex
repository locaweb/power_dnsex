defmodule PowerDNSex.Models.Record do
  defstruct [:content, :disabled]

  def as_body(content) when is_list(content) do
    Enum.reduce(content, [], fn({value, status}, records) ->
      records ++ [%__MODULE__{ content: value, disabled: status }]
    end)
  end
end
