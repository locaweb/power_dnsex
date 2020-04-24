defmodule PowerDNSex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :powerdnsex,
      version: "0.4.1",
      elixir: "~> 1.6",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [applications: [:logger, :httpoison, :poolboy], mod: {PowerDNSex, []}]
  end

  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:httpoison, "~> 1.5.0"},
      {:poison, "~> 3.0 or ~> 4.0.1"},
      {:exvcr, "~> 0.10.3", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    A Client to integrate with PowerDNS API version 4
    """
  end

  defp package do
    [
      maintainers: ["Lindolfo Rodrigues"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/locaweb/power_dnsex"}
    ]
  end
end
