defmodule PowerDNSex.Managers.RecordsManager do

  alias PowerDNSex.HttpClient
  alias PowerDNSex.Models.{Zone, Record, Error}
  alias PowerDNSex.Models.ResourceRecordSet, as: RRSet
  alias PowerDNSex.Managers.ZonesManager
  alias HTTPoison.Response


  def create(%Zone{} = zone, %{} = rrset_attrs) do
    changetype = %{changetype_key(rrset_attrs) => "REPLACE"}
    rrset_attrs = Map.merge(rrset_attrs, changetype)
    patch(zone, rrset_attrs)
  end

  def show(zone_name, %{} = rrset_attrs) do
    case ZonesManager.show(zone_name) do
      {:ok, zone} -> RRSet.find(zone.rrsets, rrset_attrs)
      _ -> nil
    end
  end

  def update(%Zone{} = zone, %{} = rrset_attrs) do
    changetype = %{changetype_key(rrset_attrs) => "REPLACE"}
    rrset_attrs = Map.merge(rrset_attrs, changetype)
    patch(zone, rrset_attrs)
  end

  def delete(%Zone{} = zone, %{} = rrset_attrs) do
    changetype = %{changetype_key(rrset_attrs) => "DELETE"}
    rrset_attrs = Map.merge(rrset_attrs, changetype)
    patch(zone, rrset_attrs)
  end

  ###
  # Private
  ##

  defp changetype_key(attrs) do
    key = "changetype"
    if Map.has_key?(attrs, key), do: key, else: String.to_atom(key)
  end

  defp process_request_response(%Response{body: body, status_code: status}) do
    case status do
      s when s == 204 -> :ok
      s when s < 300 ->
        IO.puts "Response status: #{s}"
        :ok
      s when s >= 300 ->
        error = Poison.decode!(body, as: %Error{})
        {:error, %{error | http_status_code: s} }
    end
  end

  defp patch(%Zone{url: nil}, _) do
    raise "[Records Manager] Zone URL attribute is empty!"
  end

  defp patch(%Zone{} = zone, %RRSet{} = rrset) do
    zone.url
    |> HttpClient.patch!(RRSet.as_body(rrset))
    |> process_request_response
  end

  defp patch(%Zone{} = zone, %{} = rrset_attrs) do
    patch(zone, RRSet.build(rrset_attrs))
  end

  defp has_attrs?(rrset, attrs) do
    Map.keys(attrs)
    |> Enum.all?(&(equal_attr?(&1, attrs[&1], rrsets)))
  end
end
