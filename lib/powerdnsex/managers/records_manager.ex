defmodule PowerDNSex.Managers.RecordsManager do

  alias PowerDNSex.HttpClient
  alias PowerDNSex.Models.{Zone, Record, Error}
  alias PowerDNSex.Models.ResourceRecordSet, as: RRSet
  alias PowerDNSex.Managers.ZonesManager
  alias HTTPoison.Response


  def create(%Zone{} = zone, %{} = rrset_attrs) do
    rrset_attrs = Map.merge(rrset_attrs, %{"changetype" => "REPLACE"})
    IO.puts "RRSet create: #{inspect rrset_attrs}"
    patch(zone, rrset_attrs)
  end

  def show(zone_name, %{} = rrset_attrs) do
    case ZonesManager.show(zone_name) do
      {:ok, zone} -> RRSet.find(zone.rrsets, rrset_attrs)
      _ -> nil
    end
  end

  def update(%Zone{} = zone, %{} = rrset_attrs) do
    rrset_attrs = Map.merge(rrset_attrs, %{"changetype" => "REPLACE"})
    patch(zone, rrset_attrs)
  end

  def delete(%Zone{} = zone, %{} = rrset_attrs) do
    rrset_attrs = Map.merge(rrset_attrs, %{"changetype" => "DELETE"})
    patch(zone, rrset_attrs)
  end

  ###
  # Private
  ##

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

  defp patch(%Zone{} = zone, %{} = rrset_attrs) do
    IO.puts "Patch rrset_attrs: #{inspect rrset_attrs}"
    rrset_struct = RRSet.build(rrset_attrs)
    IO.puts "[Patch] Struct: #{inspect rrset_struct}"
    IO.puts "[Patch] Body: #{inspect RRSet.as_body(rrset_struct)}"

    zone.url
    |> HttpClient.patch!(RRSet.as_body(RRSet.build(rrset_attrs)))
    |> process_request_response
  end

  defp has_attrs?(rrset, attrs) do
    Map.keys(attrs)
    |> Enum.all?(&(equal_attr?(&1, attrs[&1], rrsets)))
  end
end
