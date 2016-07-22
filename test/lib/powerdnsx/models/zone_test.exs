# defmodule PowerDNSx.Models.ZoneTest do
# 
#   use ExUnit.Case, async: true
# 
#   alias PowerDNSx.Models.Zone
# 
#   describe "Zone.build/1" do
#     test "build zone with all attributes" do
#       ns_servers = ["ns1.powerdnsx.tst", "ns2.powerdnsx.tst"]
# 
#       zone_params = %{id: nil,
#                       name: "test.tst",
#                       nameservers: ns_servers,
#                       account: "pdnaccount",
#                       kind: "Native",
#                       masters: [],
#                       records: [],
#                       serial: nil,
#                       comments: [],
#                       soa_edit: nil,
#                       soa_edit_api: nil}
# 
#      zone_built = Zone.build(zone_params)
#      assert zone_params === Map.from_struct(zone_built)
#     end
#   end
# end
