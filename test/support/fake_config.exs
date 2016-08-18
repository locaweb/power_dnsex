defmodule PowerDNSex.FakeConfig do
  @app_config_token "S3cr37_70k3n"
  @app_config_url "https://my-powerdns.api"


  def set_url, do: Application.put_env(:powerdns, :url, @app_config_url)
  def set_token, do: Application.put_env(:powerdns, :token, @app_config_token)

  def token, do: @app_config_token
  def url, do: @app_config_url
end
