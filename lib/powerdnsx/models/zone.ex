defmodule PowerDNSx.Models.Zone do
  @moduledoc """
  Model for PowerDns zones, create and validate format
  """

  @valid_hostname_regex ~r/^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$/

  defstruct name: nil,
            kind: "Native",
            masters: [],
            nameservers: [],
            records: [],
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


end
