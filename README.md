# PowerDNSex

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `powerdnsex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:powerdnsex, "~> 0.1.0"}]
    end
    ```

  2. Ensure `powerdnsex` is started before your application:

    ```elixir
    def application do
      [applications: [:powerdnsex]]
    end
    ```

## Example usage

```elixir
# CREATE ZONE:
zone_model = %PowerDNSex.Models.Zone{
  id: "example.com.",
  kind: "Master",
  name: "example.com.",
  serial: 1,
}
{:ok, zone} = PowerDNSex.create_zone(zone_model)

# SHOW ZONE:
{:ok, zone} = PowerDNSex.show_zone("example.com")

# DELETE ZONE:
res = PowerDNSex.delete_zone("example.com")

# CREATE RECORD:
{:ok, zone} = PowerDNSex.show_zone("example.com")
record = %{
  name: "test.example.com.",
  type: "A",
  ttl: 60,
  records: [
    %{
      content: "192.168.11.67",
      disabled: false,
    }
  ]
}
res = PowerDNSex.create_record(zone, record)

# SHOW RECORD:
record = %{
  name: "test.example.com.",
  type: "A",
}
rrset = PowerDNSex.show_record("example.com", record)

# UPDATE RECORD:
{:ok, zone} = PowerDNSex.show_zone("example.com")
record = %{
  name: "test.example.com.",
  type: "A",
  ttl: 60,
  records: [
    %{
      content: "192.168.11.100",
      disabled: false,
    }
  ]
}
res = PowerDNSex.update_record(zone, record)

# DELETE RECORD:
{:ok, zone} = PowerDNSex.show_zone("example.com")
record = %{
  name: "test.example.com.",
  type: "A",
}
rrset = PowerDNSex.show_record("example.com", record)
res = PowerDNSex.delete_record(zone, rrset)

```
