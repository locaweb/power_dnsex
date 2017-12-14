defmodule PowerDNSex.Models.ResourceRecordSetTest do

  use ExUnit.Case, async: true

  alias PowerDNSex.Models.{Record}
  alias PowerDNSex.Models.ResourceRecordSet, as: RRSet


  @soa_content "a.misconfigured.powerdns.server. " <>
    "hostmaster.my-domain.art. " <>
    "2016060601 10800 3600 604800 3600"

  @ns_content "ns1.locaweb.com.br. " <>
    "ns2.locaweb.com.br"

  @record_soa %RRSet {
    name: "my-domain.art.",
    ttl: 3600,
    type: "SOA",
    records: [
      %Record{content: @soa_content,
              disabled: false}
    ]
  }

  @record_ns %RRSet {
    name: "my-domain.art.",
    ttl: 3600,
    type: "NS",
    records: [
      %Record{content: @ns_content,
              disabled: false}
    ]
  }

  @record_a %RRSet {
    name: "store.my-domain.art.",
    ttl: 3600,
    type: "A",
    records: [
      %Record{content: "182.23.2.3",
              disabled: false}
    ]
  }

  @rrsets [
    @record_ns,
    @record_a
  ]

  # describe "nameservers/1" do
  #   test "return empty list for nameserver" do
  #     assert RRSet.nameservers(@empty_ns) == []
  #   end
  #   test "return map of content records" do
  #     assert RRSet.nameservers(@record_with_ns) == [@ns_content]
  #   end
  # end

  describe "find/1" do
    test "find a record" do
      assert RRSet.find(@rrsets, %{name: "store.my-domain.art.", type: "A"}) == @record_a
    end

    test "doest not find record" do
      assert RRSet.find(@rrsets, %{name: "site.my-domain.art.", type: "A"}) == nil
    end
  end

  describe "update/2" do
    test "" do
      new_attrs = %{name: "page.my-domain.art.",
                    records: [%{content: "192.168.0.1", disabled: false}],
                    ttl: "3600", type: "A"}

      new_record  = %PowerDNSex.Models.ResourceRecordSet{changetype: nil,
                                                         name: "store.my-domain.art.",
                                                         records: [
                                                           %PowerDNSex.Models.Record{
                                                             content: "192.168.0.1",
                                                             disabled: false}],
                                                         type: "A",
                                                         ttl: "3600"}

      assert RRSet.update(@record_a, new_attrs) ==  new_record
    end
  end
end
