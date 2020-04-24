defmodule PowerDNSexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup do
    PowerDNSex.FakeConfig.set_url()
    PowerDNSex.FakeConfig.set_token()

    ExVCR.Config.cassette_library_dir(
      "test/support/cassettes",
      "test/support/custom_cassettes"
    )

    HTTPoison.start()
  end
end
