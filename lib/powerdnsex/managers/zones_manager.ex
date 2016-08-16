defmodule PowerDNSex.ZonesManager do

  @default_server "localhost"

  alias PowerDNSex.HttpClient
  alias PowerDNSex.Models.{Zone, Error, ResourceRecordSet, Record}
  alias HTTPoison.Response

  def create(%Zone{} = zone, server_name \\ @default_server) do
    zone_path(server_name)
    |> HttpClient.post!(Zone.as_body(zone))
    |> process_request_response
  end

  def show(zone_name, server_name \\ @default_server)
      when is_bitstring(zone_name) do

    zone_path(server_name, zone_name)
    |> HttpClient.get!
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

  defp process_request_response(%Response{body: body, status_code: status}) do
    case status do
      s when s < 300 ->
        body |> Poison.decode!(as: %Zone{rrsets: [
                                          %ResourceRecordSet{
                                            records: [%Record{}]
                                          }]})
      s when s >= 300 ->
        body |> Poison.decode!(as: %Error{})
    end
  end
end
