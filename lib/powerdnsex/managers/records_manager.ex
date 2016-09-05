defmodule PowerDNSex.Managers.RecordsManager do

  alias PowerDNSex.HttpClient
  alias PowerDNSex.Models.{Zone, Record, Error}
  alias PowerDNSex.Models.ResourceRecordSet, as: RRSet
  alias PowerDNSex.Managers.ZonesManager
  alias HTTPoison.Response


  def create(%Zone{} = zone, %{} = rrset_attrs) do
    rrset_attrs = Map.merge(rrset_attrs, %{changetype: "REPLACE"})
    patch(zone, rrset_attrs)
  end

  def show(zone_name, %{} = rrset_attrs) do
    zone = ZonesManager.show(zone_name)
    RRSet.find(zone.rrsets, rrset_attrs)
  end

  def update(%Zone{} = zone, %{} = rrset_attrs) do
    rrset_attrs = Map.merge(rrset_attrs, %{changetype: "REPLACE"})
    patch(zone, rrset_attrs)
  end

  def delete(%Zone{} = zone, %{} = rrset_attrs) do
    rrset_attrs = Map.merge(rrset_attrs, %{changetype: "DELETE"})
    patch(zone, rrset_attrs)
  end

  ###
  # Private
  ##

  defp process_request_response(%Response{body: body, status_code: status}) do
    case status do
      s when s < 300 -> :ok
      s when s >= 300 -> body |> Poison.decode!(as: %Error{})
    end
  end

  defp patch(%Zone{url: nil}, _) do
    raise "[Records Manager] Zone URL attribute is empty!"
  end

  defp patch(%Zone{} = zone, %{} = rrset_attrs) do
    zone.url
    |> HttpClient.patch!(RRSet.as_body(RRSet.build(rrset_attrs)))
    |> process_request_response
  end

  defp has_attrs?(rrset, attrs) do
    Map.keys(attrs)
    |> Enum.all?(&(equal_attr?(&1, attrs[&1], rrsets)))
  end
end
