defmodule PowerDNSex.Managers.RecordsManagerTest do

  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias PowerDNSex.Models.{Zone, Record}
  alias PowerDNSex.Managers.RecordsManager
  alias PowerDNSex.FakeConfig, as: Config

  @valid_zone %Zone{name: "my-domain.art.",
                    url: "api/v1/servers/localhost/zones/my-domain.art."}
  @new_record %{
    name: "new-record.my-domain.art.",
    type: "A",
    ttl: 86_400,
    records: [
      {"127.0.0.1", false},
      {"192.168.0.1", true}
    ]
  }

  @updated_record %{
    name: "updated-record.my-domain.art.",
    type: "A",
    ttl: 86_800,
    records: [{"127.0.0.1", true}]
  }

  @record_to_delete %{
    name: "record-to-delete.my-domain.art.",
    type: "A",
  }

  @invalid_record %{
    name: "updated-record.my-domain.art.",
    type: "NS",
    ttl: 86_800,
    records: [{"127.0.0.1", true}]
  }

  @invalid_zone %Zone{
    name: "not-canonical-domain.tst",
    url: "api/v1/servers/localhost/zones/not-canonical-domain.tst"
  }

  setup do
    Config.set_url
    Config.set_token

    ExVCR.Config.cassette_library_dir("test/support/cassettes",
                                      "test/support/custom_cassettes")
    HTTPoison.start
  end

  describe "create/2" do
    @tag :records_manager_create
    test "exception given empty zones url" do
      raise_msg = "[Records Manager] Zone URL attribute is empty!"
      assert_raise RuntimeError, raise_msg, fn() ->
        RecordsManager.create(%Zone{}, %Record{})
      end
    end

    @tag :records_manager_create
    test "the return given correct params" do
      use_cassette "records_manager/create/success" do
        assert RecordsManager.create(@valid_zone, @new_record) == :ok
      end
    end
  end

  describe "show/2" do
    @tag :records_manager_show
    test "content given attrs of a valid record" do
      use_cassette "records_manager/show/success" do
        zone_name = @valid_zone.name
        attrs = %{name: "new-record.#{zone_name}",
                  type: "A",
                  content: "127.0.0.1"}

        record = RecordsManager.show(zone_name, attrs)
        assert record.name == attrs.name
        assert record.type == attrs.type
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

    @tag :records_manager_update
    test "the return given correct params" do
      use_cassette "records_manager/update/success" do
        assert RecordsManager.update(@valid_zone, @updated_record) == :ok
      end
    end

    @tag :records_manager_update
    test "the return given incorrect zone" do
      use_cassette "records_manager/update/not_found" do
        response = RecordsManager.update(@invalid_zone, @updated_record)
        error_msg = "Could not find domain '#{@invalid_zone.name}.'"
        assert response.error == error_msg
      end
    end

    @tag :records_manager_update
    test "the return given incorrect params" do
      use_cassette "records_manager/update/invalid_record" do
        response = RecordsManager.update(@valid_zone, @invalid_record)
        error_msg = "Record updated-record.my-domain.art./NS '127.0.0.1': " <>
                    "Not in expected format (parsed as '127.0.0.1.')"
        assert response.error == error_msg
      end
    end
  end

  describe "delete/2" do
    @tag :records_manager_delete
    test "the return given a correct record" do
      use_cassette "records_manager/delete/success" do
        assert RecordsManager.delete(@valid_zone, @record_to_delete) == :ok
      end
    end
  end
end
