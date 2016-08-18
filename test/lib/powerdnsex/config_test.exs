defmodule PowerDNSex.ConfigTest do

  use ExUnit.Case, async: true

  alias PowerDNSex.FakeConfig, as: Config

  setup with_valid_url, do: Config.set_url
  setup with_valid_token, do: Config.set_token
  setup with_valid_token_and_url, do: Config.set_url && Config.set_token

  describe "Config.powerdns_token/0" do
    @tag :configs
    test "Using Env vars", with_valid_url do
      env_token = "3nv_S3cr37_T0k3n"
      System.put_env("POWERDNS_TOKEN", env_token)
      Application.put_env(:powerdns, :token, {:system, "POWERDNS_TOKEN"})
      assert PowerDNSex.Config.powerdns_token == env_token
    end

    @tag :configs
    test "using application config", with_valid_token_and_url do
      assert PowerDNSex.Config.powerdns_token == Config.token
    end

    @tag :configs
    test "given none token config", with_valid_url do
      Application.delete_env(:powerdns, :token)
      expected_error = "[PowerDNSex] PowerDNS token not configured."

      assert_raise RuntimeError, expected_error, fn ->
        PowerDNSex.Config.powerdns_token
      end
    end
  end

  describe "Config.powerdns_url/0" do
    @tag :configs
    test "Using Env vars", with_valid_token do
      env_url = "https://env-powerdns.test"
      System.put_env("POWERDNS_URL", env_url)
      Application.put_env(:powerdns, :url, {:system, "POWERDNS_URL"})
      assert PowerDNSex.Config.powerdns_url == env_url
    end

    @tag :configs
    test "using application config", with_valid_token_and_url do
      assert PowerDNSex.Config.powerdns_url == Config.url
    end

    @tag :configs
    test "given none url config", with_valid_token do
      Application.delete_env(:powerdns, :url)
      expected_error = "[PowerDNSex] PowerDNS url not configured."
      assert_raise RuntimeError, expected_error, fn ->
        PowerDNSex.Config.powerdns_url
      end
    end
  end
end
