defmodule PowerDNSx.ZoneValidator do
  alias PowerDNSx.Models.Zone

  @valid_zone_name_reg ~r/^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$/

  def check(%Zone{} = zone) do
    verify_attr = fn({attr, value}, errors)->
                    validate_attr_value(attr, value)
                  end

    errors = Enum.reduce(zone, nil, verify_attr)
    if errors, do: {:error, errors}, else: :ok
  end

  ###
  # Private
  ###

  defp validate_attr_value(:name, zone_name) do
    case validate_zone_name(zone_name) do
      {true, true} -> nil
      {false, _} -> {:error, %{name: "#{zone_name} is invalid."}}
      {_, false} -> {:error, %{name: "#{zone_name} is invalid. Max lenght is 64."}}
      {:format_error} -> {:error, %{name: "Name MUST be a string."}}
    end
  end

  defp validate_zone_name(zone_name) when is_bitstring(zone_name) do
    {String.match?(zone_name, @valid_zone_name_reg), correct_length?(zone_name)}
  end

  defp validate_zone_name(_), do: {:format_error}

  defp correct_length?(zone_name) do
    name = zone_name |> String.split(".") |> hd
    name |> String.length <= 63
  end
end
