defmodule Gt.Repo do
  use Ecto.Repo,
    otp_app: :gt,
    adapter: Ecto.Adapters.Postgres
end
