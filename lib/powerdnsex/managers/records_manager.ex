defmodule PowerDNSex.Managers.RecordsManager do
  require Logger

  alias PowerDNSex.HttpClient
  alias PowerDNSex.Models.{Zone, Error}
  alias PowerDNSex.Models.ResourceRecordSet, as: RRSet
  alias PowerDNSex.Managers.ZonesManager
  alias HTTPoison.Response

  def create(%Zone{} = zone, %{} = rrset_attrs) do
    rrset_attrs = Map.merge(rrset_attrs, %{changetype: "REPLACE"})
    patch(zone, rrset_attrs)
  end

  def put_zone(%Zone{} = zone, %{} = rrset_attrs) do
    create(zone, rrset_attrs)
  end

  def show(zone_name, %{} = rrset_attrs) do
    case ZonesManager.show(zone_name) do
      {:ok, zone} -> RRSet.find(zone.rrsets, rrset_attrs)
      _ -> nil
    end
  end

  def update(%Zone{} = zone, %{name: rrset_name, type: rrset_type} = rrset_attrs) do
    rrset_find_params = %{name: rrset_name, type: rrset_type}
    rrset = RRSet.find(zone.rrsets, rrset_find_params)

    if rrset do
      updated_rrset = RRSet.update(rrset, rrset_attrs)
      updated_rrset = Map.merge(updated_rrset, %{changetype: "REPLACE"})
      patch(zone, updated_rrset)
    else
      error_msg = "Record #{rrset_find_params.name}, type #{rrset_type}, not found!"
      {:error, %Error{error: error_msg, http_status_code: 404}}
    end
  end

  def delete(%Zone{} = zone, %{} = rrset_attrs) do
    rrset_attrs = Map.merge(rrset_attrs, %{changetype: "DELETE"})
    patch(zone, rrset_attrs)
  end

  ###
  # Private
  ###

  defp process_request_response(%Response{body: body, status_code: status}) do
    case status do
      s when s == 204 ->
        :ok

      s when s < 300 ->
        :ok

      s when s >= 300 ->
        error = Poison.decode!(body, as: %Error{})
        {:error, %{error | http_status_code: s}}
    end
  end

  defp patch(%Zone{url: nil}, _) do
    raise "[Records Manager] Zone URL attribute is empty!"
  end

  defp patch(%Zone{} = zone, %RRSet{} = rrset) do
    rrset_body = RRSet.as_body(rrset)
    Logger.info("Request to [#{zone.name}] with params [#{rrset_body}]")

    zone.url
    |> HttpClient.patch!(rrset_body)
    |> process_request_response
  end

  defp patch(%Zone{} = zone, %{} = rrset_attrs) do
    patch(zone, RRSet.build(rrset_attrs))
  end
end
