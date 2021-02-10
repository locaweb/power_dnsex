defmodule PowerDNSex.Managers.ZonesManager do
  @default_server "localhost"

  alias PowerDNSex.HttpClient
  alias PowerDNSex.Models.{Zone, Error, ResourceRecordSet, Record}
  alias HTTPoison.Response

  def create(%Zone{} = zone, server_name \\ @default_server) do
    server_name
    |> zone_path
    |> HttpClient.post!(Zone.as_body(zone))
    |> process_request_response
  end

  def show(zone_name, server_name \\ @default_server)
      when is_bitstring(zone_name) do
    server_name
    |> zone_path(zone_name)
    |> HttpClient.get!()
    |> process_request_response
  end

  def get_zone(zone_name, server_name \\ @default_server)
    when is_bitstring(zone_name) do
  server_name
  |> zone_path_light(zone_name)
  |> HttpClient.get!()
  |> process_request_response
  end

  def delete(zone_name, server_name \\ @default_server)
      when is_bitstring(zone_name) do
    server_name
    |> zone_path(zone_name)
    |> HttpClient.delete!()
    |> process_request_response
  end

  ###
  # Private
  ###

  defp zone_path(server_name) when is_bitstring(server_name) do
    "api/v1/servers/#{server_name}/zones"
  end

  defp zone_path(server_name, zone_name) when is_bitstring(server_name) do
    zone_path(server_name) <> "/#{zone_name}"
  end

  defp zone_path_light(server_name, zone_name) when is_bitstring(server_name) do
    "api/v1/servers/#{server_name}/zones/#{zone_name}?rrsets=false"
  end

  defp process_request_response(%Response{body: body, status_code: status}) do
    case status do
      s when s == 204 ->
        {:ok, %{}}

      s when s < 300 ->
        {:ok, decode_body(body)}

      s when s == 500 ->
        {:error, %Error{error: "Internal Server Error", http_status_code: s}}

      s when s >= 300 ->
        error = %{Poison.decode!(body, as: %Error{}) | http_status_code: s}
        {:error, error}
    end
  end

  defp decode_body(body) do
    zone =
      body
      |> Poison.decode!(as: %Zone{rrsets: [%ResourceRecordSet{records: [%Record{}]}]})

    nameservers = ResourceRecordSet.nameservers(zone.rrsets)
    Map.put(zone, :nameservers, nameservers)
  end
end
