# PowerDNSex

A client to [PowerDNS 4 API](https://doc.powerdns.com/md/httpapi/README/), with all CRUD operations to manage zones and records.

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

## Configuration
Insert this in your configuration files. Eg:  `config.exs`

```elixir
config :powerdnsex, url: "localhost:8081",
                    token: "sometoken"
```

You can also use ENV vars to configure PowerDNSex.
```elixir
config :powerdnsex, url: {:system, "POWERDNS_URL"},
                    token: {:system, "POWERDNS_TOKEN"}
```
Make sure you set those environment variables.

## Example usage

### Zone Management

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
```


### Record management

```elixir
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

