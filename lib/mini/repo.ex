defmodule Mini.Repo do
  use Ecto.Repo,
    otp_app: :mini,
    adapter: Ecto.Adapters.Postgres

  Postgrex.Types.define(
    Mini.PostgresTypes,
    [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
    []
  )
end
