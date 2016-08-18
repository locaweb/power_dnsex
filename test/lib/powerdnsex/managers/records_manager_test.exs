defmodule PowerDNSex.RecordsManagerTest do

  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias PowerDNSex.Models.{Zone, ResourceRecordSet, Record}
  alias PowerDNSex.RecordsManager

  @valid_zone %Zone{name: "my-domain.art.",
                    url: "api/v1/servers/localhost/zones/my-domain.art."}
  @new_record %{
    name: "new-record.my-domain.art.",
    type: "A",
    ttl: 86400,
    records: [
      {"127.0.0.1", false},
      {"192.168.0.1", true}
    ]
  }

  @updated_record %{
    name: "updated-record.my-domain.art.",
    type: "A",
    ttl: 86800,
    records: [{"127.0.0.1", true}]
  }

  setup do
   # Config.set_url
   # Config.set_token

    pwdns_url_loca = "http://cpro36999.systemintegration.locaweb.com.br/"
    Application.put_env(:powerdns, :url, pwdns_url_loca)

    pwdns_token_loca = "Locaweb2016"
    Application.put_env(:powerdns, :token, pwdns_token_loca)

    ExVCR.Config.cassette_library_dir("test/support/cassettes",
                                      "test/support/custom_cassettes")
    HTTPoison.start
  end

  describe "create/2" do
    test "exception given empty zones url" do
      raise_msg = "[Records Manager] Zone URL attribute is empty!"
      assert_raise RuntimeError, raise_msg, fn() ->
        RecordsManager.create(%Zone{}, %Record{})
      end
    end

    test "content and value of the return given correct params" do
      use_cassette "records_manager/create/success" do
        assert RecordsManager.create(@valid_zone, @new_record) == :ok
      end
    end
  end

  describe "update/2" do
    @tag :records_manager_update
    test "exception given empty zones url" do
      raise_msg = "[Records Manager] Zone URL attribute is empty!"
      assert_raise RuntimeError, raise_msg, fn() ->
        RecordsManager.update(%Zone{}, %Record{})
      end
    end

    test "the return given correct params" do
      use_cassette "records_manager/update/success" do
        assert RecordsManager.update(@valid_zone, @updated_record) == :ok
      end
    end
  end
end
