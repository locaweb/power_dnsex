defmodule PowerDNSex.Mixfile do
  use Mix.Project

  def project do
    [app: :powerdnsex,
     version: "0.0.1",
     elixir: "~> 1.3",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison], mod: {PowerDNSex, []}]
  end

  defp deps do
    [{:httpoison, "~> 0.9.0"},
     {:poison, "~> 2.2"},
     {:exvcr, "~> 0.8.0", only: :test}]
  end

  defp description do
    """
    A Client to integrate with PowerDNS API version 4
    """
  end

  defp package do
    [maintainers: ["Rodrigo Coutinho"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/digaoddc/power_dnsex"}
    ]
  end
end
