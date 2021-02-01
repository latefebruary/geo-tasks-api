use Mix.Config

config :mini, Mini.Repo,
  database: "mini_repo",
  username: System.get_env("PG_USERNAME"),
  password: System.get_env("PG_PASSWORD"),
  hostname: "localhost",
  types: Mini.PostgresTypes

config :mini, Mini.Endpoint, port: 4000

config :mini,
  ecto_repos: [Mini.Repo]

import_config "#{Mix.env()}.exs"
