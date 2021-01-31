use Mix.Config

config :mini, Mini.Endpoint, port: 4000

import_config "#{Mix.env()}.exs"
