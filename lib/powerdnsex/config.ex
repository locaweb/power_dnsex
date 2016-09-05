defmodule PowerDNSex.Config do
  defstruct url: "",
            token: ""

  alias PowerDNSex.Config

  def data do
    set_attr_value = &(Map.put(&2, &1, get_key(&1)))

    %Config{}
    |> Map.from_struct
    |> Map.keys
    |> Enum.reduce(%Config{}, set_attr_value)
  end

  def powerdns_url do
     url = data.url
     if String.ends_with?(url, "/"), do: url, else: url <> "/"
  end

  def powerdns_token, do: data.token

  def valid?(), do: powerdns_url && powerdns_token

  ###
  # Private
  ###

  defp get_key(key) do
    case Application.fetch_env(:powerdns, key) do
      {:ok, {:system, env_var_name}} -> System.get_env(env_var_name)
      {:ok, value} -> value
      _ ->
        raise "[PowerDNSex] PowerDNS #{Atom.to_string(key)} not configured."
    end
  end
end
