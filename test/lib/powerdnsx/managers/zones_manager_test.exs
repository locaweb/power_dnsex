defmodule PowerDNSx.ZonesManagerTest do

  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias PowerDNSx.ZonesManager
  alias PowerDNSx.Models.Zone
  alias PowerDNSx.FakeConfig, as: Config

  @valid_zone_loca %Zone{name: "devtiagofreire.art.br"}

  @valid_zone_test %Zone{name: "my-domain.tst",
                         serial: 2016060601,
                         comments: ["Test comment"] }

  @expected_records [
    %{"content" => "ns2.my-powerdns.api", "disabled" => false,
      "name" => "my-domain.tst", "ttl" => 3600, "type" => "NS"},
    %{"content" => "ns1.my-powerdns.api", "disabled" => false,
      "name" => "my-domain.tst", "ttl" => 3600, "type" => "NS"},
    %{"content" => "a.misconfigured.powerdns.server " <>
                   "hostmaster.my-domain.tst " <>
                   "2016060601 10800 3600 604800 3600",
      "disabled" => false, "name" => "my-domain.tst", "ttl" => 3600,
      "type" => "SOA"}
  ]

  @expected_zone %Zone{name: "my-domain.tst",
                       id: "my-domain.tst.",
                       account: "",
                       serial: 2016060601,
                       url: "/servers/localhost/zones/my-domain.tst.",
                       records: @expected_records}

  setup_all do
    #Config.set_url
    #Config.set_token

    pwdns_url_loca = "http://cpro36999.systemintegration.locaweb.com.br"
    pwdns_url_test = "http://my-powerdns.api"
    Application.put_env(:powerdns, :url, pwdns_url_test)

    pwdns_token_loca = "Locaweb2016"
    pwdns_token_test = "S3cr3t-T0k3n"
    Application.put_env(:powerdns, :token, pwdns_token_test)

    ExVCR.Config.cassette_library_dir("test/support/cassettes",
                                      "test/support/custom_cassettes")
    HTTPoison.start
  end

  describe "ZoneManager.create/2" do
    @tag :zones_manager_create
    test "type of return given correct parameters" do
      use_cassette "zones_manager/create/valid_parameters" do
        zone = ZonesManager.create(@valid_zone_test)
        assert zone.__struct__ == PowerDNSx.Models.Zone
      end
    end
  end

  describe "ZonesManager.show/2" do
    @tag :zones_manager_show
    test "type of return given a correct zone name" do
      use_cassette "zones_manager/show/valid_record" do
        zone = ZonesManager.show(@valid_zone_test.name)
        assert zone.__struct__ == PowerDNSx.Models.Zone
      end
    end

    @tag :zones_manager_show
    test "values in return given a correct zone name" do
      use_cassette "zones_manager/show/valid_record" do
        zone = ZonesManager.show(@valid_zone_test.name)
        assert zone == @expected_zone
      end
    end
  end

end
