defmodule PowerDNSex.Models.ResourceRecordSetTest do
  use ExUnit.Case, async: true

  alias PowerDNSex.Models.ResourceRecordSet

  @multivalue_record_attrs %{"name" => "domain.com.",
     "records" => [%{"content" => "25 mx10.core.locaweb.com.br.",
     "disabled" => false}], "ttl" => 3600, "type" => "MX"}

  @record_attrs %{"name" => "domain.com.",
     "records" => [%{"content" => "192.168.0.1",
     "disabled" => false}], "ttl" => 3600, "type" => "A"}


  @tag :resource_record_set_find
  test "find params with multivalue record" do
    result = %{content: "25 mx10.core.locaweb.com.br.", name: "domain.com.",
                  type: "MX"}
    assert ResourceRecordSet.find_params(@multivalue_record_attrs) == result
  end

  @tag :resource_record_set_find
  test "find params with regular record" do
    result = %{name: "domain.com.", type: "A"}
    assert ResourceRecordSet.find_params(@record_attrs) == result
  end

  @tag :resource_record_set_record_attrs
  test "record_attrs new record" do
    rrsets = [%PowerDNSex.Models.ResourceRecordSet{changetype: nil, name: "domain.com.",
      records: [
        %PowerDNSex.Models.Record{content: "25 mx10.core.locaweb.com.br.", disabled: false}],
    ttl: 3600, type: "MX"}]

    #record_attrs = %{"name" => "domain.com.",
     #"records" => [%{"content" => "25 mx10.core.locaweb.com.br.",
       #"disabled" => false}], "ttl" => 3600, "type" => "MX"}

    #assert ResourceRecordSet.record_attrs(rrsets, record_attrs) == {}
  end

  @tag :resource_record_set_record_attrs
  test "record_attrs with previous rrset" do

  end
end
