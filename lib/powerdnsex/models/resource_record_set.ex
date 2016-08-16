defmodule PowerDNSex.Models.ResourceRecordSet do

  alias PowerDNSex.Models.Record

  defstruct [:name, :type, :ttl, :records, :changetype]

  def as_body(%__MODULE__{} = record) do
    %{ rrsets: [
       %{
         name: record.name,
         type: record.type,
         ttl: record.ttl,
         changetype: record.changetype,
         records: Record.as_body(record.content)
       }
    ]}
    |> Poison.encode!
  end

end
