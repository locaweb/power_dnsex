defmodule PowerDNSex.Models.Zone do
  @moduledoc """
  Model for PowerDns zones, create and validate format
  """

  @body_attrs ~w(account dns kind masters name nameservers records serial
                 soa_edit soa_edit_api)a

  defstruct name: nil,
            kind: "Native",
            masters: [],
            nameservers: [],
            rrsets: [],
            account: nil,
            comments: [],
            dnssec: false,
            id: nil,
            last_check: 0,
            notified_serial: 0,
            serial: nil,
            soa_edit: "",
            soa_edit_api: "",
            url: nil

  @type t :: %__MODULE__{}

  def as_body(%__MODULE__{} = zone) do
    get_valid_attrs = fn {attr, value}, body ->
      if Enum.member?(@body_attrs, attr) do
        Map.merge(body, %{attr => value})
      else
        body
      end
    end

    zone
    |> Map.from_struct()
    |> Enum.reduce(%{}, get_valid_attrs)
    |> Poison.encode!()
  end
end
