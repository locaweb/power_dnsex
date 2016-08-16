defmodule PowerDNSex.RecordsManager do

  alias PowerDNSex.HttpClient
  alias PowerDNSex.Models.{Zone, Record, Error}
  alias PowerDNSex.Models.ResourceRecordSet, as: RRset
  alias HTTPoison.Response

  def create(%Zone{url: nil}, _) do
    raise "[Records Manager] Zone URL attribute is empty!"
  end

  def create(%Zone{} = zone, %{} = rrset) do
    rrset = %{rrset | changetype: "REPLACE"}

    zone.url
    |> HttpClient.patch!(rrset.as_body(rrset))
    |> process_request_response
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
