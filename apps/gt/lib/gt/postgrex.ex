Postgrex.Types.define(
  Gt.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  library: Geo
)
