defmodule PowerDNSex.HttpClient do
  @moduledoc """
  Client to do http requests for PowerDns API
  """

  use HTTPoison.Base

  alias PowerDNSex.Config

  def process_url(url), do: Config.powerdns_url() <> url

  def process_request_headers(headers) do
    custom = ["X-API-Key": Config.powerdns_token()]
    Keyword.merge(headers, custom)
  end
end
