defmodule PowerDNSx.Config do
  defstruct url: "",
            token: ""

  alias PowerDNSx.Config

  def data do
    set_attr_value = &(Map.put(&2, &1, get_key(&1)))

    %Config{}
    |> Map.from_struct
    |> Map.keys
    |> Enum.reduce(%Config{}, set_attr_value)
  end

  def powerdns_url do
    data.url
  end

  def powerdns_token do
    data.token
  end

  ###
  # Private
  ###

  defp get_key(key) do
    case Application.fetch_env(:powerdns, key) do
      {:ok, {:system, env_var_name}} -> System.get_env(env_var_name)
      {:ok, value} -> value
      _ ->
        raise "[PowerDNSx] PowerDNS #{Atom.to_string(key)} not configured."
    end
  end
end
