defmodule PowerDNSex.FakeConfig do
  @app_config_token "S3cr37_70k3n"
  @app_config_url "https://my-powerdns.api"
  @app_config_timeout 42

  def set_url, do: Application.put_env(:powerdnsex, :url, @app_config_url)
  def set_token, do: Application.put_env(:powerdnsex, :token, @app_config_token)
  def set_timeout, do: Application.put_env(:powerdnsex, :timeout, @app_config_timeout)


  def token, do: @app_config_token
  def url, do: @app_config_url
  def timeout, do: @app_config_timeout
end
