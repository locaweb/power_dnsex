defmodule PowerDNSex.ConfigTest do
  use ExUnit.Case, async: false

  alias PowerDNSex.FakeConfig, as: Config

  setup do: Config.set_url()
  setup do: Config.set_token()
  setup do: Config.set_timeout()
  setup do: Config.set_url() && Config.set_token()

  describe "Config.powerdns_token/0" do
    @tag :configs
    test "Using Env vars" do
      env_token = "new-token"
      System.put_env("POWERDNS_TOKEN", env_token)
      Application.put_env(:powerdnsex, :token, {:system, "POWERDNS_TOKEN"})
      assert PowerDNSex.Config.powerdns_token() == env_token
    end

    @tag :configs
    test "using application config" do
      assert PowerDNSex.Config.powerdns_token() == Config.token()
    end

    @tag :configs
    test "given none token config" do
      Application.delete_env(:powerdnsex, :token)
      expected_error = "[PowerDNSex] PowerDNS token not configured."

      assert_raise RuntimeError, expected_error, fn ->
        PowerDNSex.Config.powerdns_token()
      end
    end
  end

  describe "Config.powerdns_url/0" do
    @tag :configs
    test "Using Env vars" do
      env_url = "https://env-powerdns.test/"
      System.put_env("POWERDNS_URL", env_url)
      Application.put_env(:powerdnsex, :url, {:system, "POWERDNS_URL"})
      assert PowerDNSex.Config.powerdns_url() == env_url
    end

    @tag :configs
    test "using application config" do
      assert PowerDNSex.Config.powerdns_url() == Config.url() <> "/"
    end

    @tag :configs
    test "given none url config" do
      Application.delete_env(:powerdnsex, :url)
      expected_error = "[PowerDNSex] PowerDNS url not configured."

      assert_raise RuntimeError, expected_error, fn ->
        PowerDNSex.Config.powerdns_url()
      end
    end
  end

  describe "Config.powerdns_timeout/0" do
    @tag :configs
    test "using application config" do
      assert PowerDNSex.Config.powerdns_timeout() == :timer.seconds(Config.timeout())
    end

    @tag :configs
    test "uses default timeout" do
      existing = Application.get_env(:powerdnsex, :timeout)
      on_exit fn ->
        Application.put_env(:powerdnsex, :timeout, existing)
      end

      Application.delete_env(:powerdnsex, :timeout)

      assert PowerDNSex.Config.powerdns_timeout() == :timer.seconds(60)
    end
  end
end
