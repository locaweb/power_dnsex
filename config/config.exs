use Mix.Config

config :powerdnsex, timeout: 2

import_config "#{Mix.env()}.exs"
