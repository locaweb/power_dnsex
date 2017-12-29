defmodule PowerDNSex.Models.ResourceRecordSet do

  alias PowerDNSex.Models.Record

  defstruct [:name, :type, :ttl, :records, :changetype]
  @permited_attrs [:ttl, :records]

  def build(%{records: records} = rrset_attrs) when is_list(records) do
    build_rrset(rrset_attrs)
  end

  def as_body(%__MODULE__{} = rrset) do
    %{rrsets: [
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
    Enum.find(rrsets, fn(rrset) ->
      Enum.all?(attrs, fn({attr, attr_value}) ->
        if Enum.member?(Map.keys(%__MODULE__{}), attr) do
          equal_attr?(attr, attr_value, rrset)
        else
          Record.find(rrset.records, %{attr => attr_value})
        end
      end)
    end)
  end

  def update(%__MODULE__{} = rrset, %{} = new_attrs) do
    Enum.reduce(@permited_attrs, rrset, fn(attr_name, rrset) ->
                  case Map.fetch(new_attrs, attr_name) do
                    {:ok, new_value} ->
                      if attr_name == :records do
                        new_value = Record.build(new_value)
                      end
                      %{rrset | attr_name => new_value}
                    _ -> rrset
                  end
                end)
  end

  def nameservers(rrsets) do
    rrset = Enum.find(rrsets, fn(rrset) -> rrset.type == "NS" end)
    nameservers = case rrset do
      nil -> []
      _ -> Enum.map(rrset.records, &(&1.content) )
    end
  end

  ###
  # Private
  ###
  #

  defp set_attrs(rrset, attr_name, attrs) do
    if Map.has_key?(attrs, attr_name) do
      attr_value = case attr_name do
                        :records -> Record.build(Map.fetch!(attrs, attr_name))
                        _         -> Map.fetch!(attrs, attr_name)
                   end

      %{rrset | attr_name => attr_value}
    else
      rrset
    end
  end

  defp equal_attr?(attr, attr_value, rrset) do
    attr_atom = if is_binary(attr), do: String.to_atom(attr), else: attr
    Map.get(rrset, attr_atom) == attr_value
  end

  defp build_rrset(rrset_attrs) do
    %__MODULE__{}
    |> Map.keys
    |> Enum.reduce(%__MODULE__{}, &(set_attrs(&2, &1, rrset_attrs)))
  end
end
