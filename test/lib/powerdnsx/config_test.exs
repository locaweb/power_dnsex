defmodule PowerDNSx.ConfigTest do

  use ExUnit.Case, async: true

  alias PowerDNSx.FakeConfig, as: Config

  setup with_valid_url, do: Config.set_url
  setup with_valid_token, do: Config.set_token
  setup with_valid_token_and_url, do: Config.set_url && Config.set_token

  describe "Config.powerdns_token/0" do
    test "Using Env vars", with_valid_url do
      env_token = "3nv_S3cr37_T0k3n"
      System.put_env("POWERDNS_TOKEN", env_token)
      Application.put_env(:powerdns, :token, {:system, "POWERDNS_TOKEN"})
      assert PowerDNSx.Config.powerdns_token == env_token
    end

    test "using application config", with_valid_token_and_url do
      assert PowerDNSx.Config.powerdns_token == "4pp_S3cr37_T0k3n"
    end

    test "given none token config", with_valid_url do
      Application.delete_env(:powerdns, :token)
      expected_error = "[PowerDNSx] PowerDNS token not configured."

      assert_raise RuntimeError, expected_error, fn ->
        PowerDNSx.Config.powerdns_token
      end
    end
  end

  describe "Config.powerdns_url/0" do
    test "Using Env vars", with_valid_token do
      env_url = "https://env-powerdns.test"
      System.put_env("POWERDNS_URL", env_url)
      Application.put_env(:powerdns, :url, {:system, "POWERDNS_URL"})
      assert PowerDNSx.Config.powerdns_url == env_url
    end

    test "using application config", with_valid_token_and_url do
      assert PowerDNSx.Config.powerdns_url == "https://app-config-powerdns.test"
    end

    test "given none url config", with_valid_token do
      Application.delete_env(:powerdns, :url)
      expected_error = "[PowerDNSx] PowerDNS url not configured."
      assert_raise RuntimeError, expected_error, fn ->
        PowerDNSx.Config.powerdns_url
      end
    end
  end


end
