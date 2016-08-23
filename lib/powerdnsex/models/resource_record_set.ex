defmodule PowerDNSex.Models.ResourceRecordSet do

  alias PowerDNSex.Models.Record

  defstruct [:name, :type, :ttl, :records, :changetype]

  def build(rrset_attrs) when is_map(rrset_attrs) do
    rrset = %__MODULE__{}

    rrset
    |> Map.keys
    |> Enum.reduce(rrset, &(set_attrs(&2, &1, rrset_attrs)))
  end

  def as_body(%__MODULE__{} = rrset) do
    %{ rrsets: [
       %{
         name: rrset.name,
         type: rrset.type,
         ttl: rrset.ttl,
         changetype: rrset.changetype,
         records: Record.as_body(rrset.records)
       }
    ]}
    |> Poison.encode!
  end

  def find(rrsets, %{} = attrs) when is_list(rrsets) do
    Enum.find(rrsets, fn(rrset)->
      Enum.all?(attrs, fn({attr, attr_value})->
        if Enum.member?(Map.keys(%__MODULE__{}), attr) do
          equal_attr?(attr, attr_value, rrset)
        else
          Record.find(rrset.records, %{attr => attr_value})
        end
      end)
    end)
  end

  ###
  # Private
  ###

  defp set_attrs(rrset, attr_name, attrs) do
    if Map.has_key?(attrs, attr_name) do
      attr_value = case attr_name do
                        :records -> Record.build(Map.fetch!(attrs, attr_name))
                        _        -> Map.fetch!(attrs, attr_name)
                   end

      %{ rrset | attr_name => attr_value }
    else
      rrset
    end
  end

  defp equal_attr?(attr, attr_value, rrset) do
    Map.get(rrset, attr) == attr_value
  end
end
