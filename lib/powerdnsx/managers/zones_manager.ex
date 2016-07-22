defmodule PowerDNSx.ZonesManager do

  @default_server "localhost"

  alias PowerDNSx.HttpClient
  alias HTTPoison.Response, as: PoisonResp
  alias PowerDNSx.Models.Zone

  def create(%Zone{} = zone, server_name \\ @default_server) do
    case Zone.is_valid?(zone) do
      true ->
        zone_path(server_name)
        |> HttpClient.post!(zone)
        |> process_request_response
      {false, errors} -> {:error, errors}
    end
  end

  def show(zone_name, server_name \\ @default_server) when is_bitstring(zone_name) do
    zone_path(server_name, zone_name)
    |> HttpClient.get!
    |> process_request_response
  end

  ###
  # Private
  ###

  defp zone_path(server_name) when is_bitstring(server_name) do
    "/servers/#{server_name}/zones"
  end

  defp zone_path(server_name, zone_name) when is_bitstring(server_name) do
    zone_path(server_name) <> "/#{zone_name}"
  end

  defp process_request_response(%PoisonResp{body: body, status_code: status} ) do
    body |> Poison.decode!(as: %Zone{})
  end
end
