defmodule PowerDNSx.HttpClient do
  @moduledoc"""
  Client to do http requests for PowerDns API
  """

  use HTTPoison.Base

  alias PowerDNSx.Config

  def process_url(url) do
    Config.powerdns_url <> url
  end

  defp process_request_headers(headers) do
    custom = ["X-API-Key": Config.powerdns_token]
    Enum.into(headers, custom)
  end
end
