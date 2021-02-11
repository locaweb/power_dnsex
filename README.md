# PowerDNSex

A client to [PowerDNS 4 API](https://doc.powerdns.com/md/httpapi/README/), with all CRUD operations to manage zones and records.

[![Build Status](https://travis-ci.org/digaoddc/power_dnsex.svg?branch=travis)](https://travis-ci.org/digaoddc/power_dnsex)

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

# SHOW ZONE without RRSets:
{:ok, zone} = PowerDNSex.get_zone("example.com")

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

## Development

### Setup application
```bash
$ script/setup
```

### Run local console (IEX)
```bash
$ script/run
```

### Run tests
```bash
$ script/test
```

#### Run tests to a specific File
```bash
$ script/test test/lib/powerdnsex/powerdnsex_test.exs
```

### Reset environment (clean + setup)
### YOU WILL LOSE EVERYTHING

Good for then you change the elixir version and need to delete everything and start again

```bash
$ script/reset
```


