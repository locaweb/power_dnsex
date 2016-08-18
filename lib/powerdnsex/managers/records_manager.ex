defmodule PowerDNSex.RecordsManager do

  alias PowerDNSex.HttpClient
  alias PowerDNSex.Models.{Zone, Record, Error}
  alias PowerDNSex.Models.ResourceRecordSet, as: RRset
  alias HTTPoison.Response

  def create(%Zone{url: nil}, _) do
    raise "[Records Manager] Zone URL attribute is empty!"
  end

  def create(%Zone{} = zone, %{} = rrset_attrs) do
    rrset_attrs = Map.merge(rrset_attrs, %{changetype: "REPLACE"})

    zone.url
    |> HttpClient.patch!(RRset.as_body(RRset.build(rrset_attrs)))
    |> process_request_response
  end

  def update(%Zone{} = zone, %{} = rrset_attrs) do
    create(zone, rrset_attrs)
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
end
