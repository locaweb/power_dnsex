defmodule PowerDNSexTest do

  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup do
    Config.set_url
    Config.set_token

    ExVCR.Config.cassette_library_dir("test/support/cassettes",
                                      "test/support/custom_cassettes")
    HTTPoison.start
  end
end
