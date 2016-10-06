defmodule PowerDNSex.Models.Record do
  defstruct [:content, :disabled]

  def build(attrs) when is_list(attrs) do
    Enum.reduce(attrs, [], &(&2 ++ [build_item(&1)]))
  end

  def as_body(nil), do: []

  def as_body(content) when is_list(content) do
    Enum.reduce(content, [], &(&2 ++ [as_body(&1)]))
  end

  def as_body(%__MODULE__{} = record_attrs) do
    Map.from_struct(record_attrs)
  end

  def as_body(record_attrs) when is_tuple(record_attrs) do
    %{content: elem(record_attrs, 0), disabled: elem(record_attrs, 1)}
  end

  def find(records, attrs) when is_list(records) do
    Enum.find(records, fn(record) ->
      Enum.all?(attrs, fn({attr, attr_value}) ->
        Map.get(record, attr) == attr_value
      end)
    end)
  end

  ###
  # PRIVATE
  ###

  defp build_item(attrs) when is_map(attrs) do
    disabled = attrs[:disabled] || false
    record = %__MODULE__{content: attrs.content, disabled: disabled}
    record
  end

  defp build_item(attrs) when is_tuple(attrs) do
    %__MODULE__{content: elem(attrs, 0), disabled: elem(attrs, 1)}
  end
end
