defmodule PowerDNSx.FakeConfig do
  @app_config_token "4pp_S3cr37_T0k3n"
  @app_config_url "https://app-config-powerdns.test"


  def set_url, do: Application.put_env(:powerdns, :url, @app_config_url)
  def set_token, do: Application.put_env(:powerdns, :token, @app_config_token)
end
