defmodule PowerDNSex.Converter do
  def keys_to_atom(struct) when is_list(struct) do
    for item <- struct, do: keys_to_atom(item)
  end

  def keys_to_atom(%{} = struct) do
    for {key, value} <- struct, into: %{} do
      n_key = if is_binary(key), do: String.to_atom(key), else: key

      n_value =
        if is_map(value) or is_list(value) do
          keys_to_atom(value)
        else
          value
        end

      {n_key, n_value}
    end
  end

  def keys_to_atom(item), do: item
end
