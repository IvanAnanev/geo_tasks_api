defmodule Gt.GeoTasks.GeoTask do
  @moduledoc """
  Table geo_tasks.
  """
  import EctoEnum
  use Ecto.Schema

  defenum(Status, :geo_task_status, [:new, :assigned, :done])

  @timestamps_opts [type: :utc_datetime]

  schema "geo_tasks" do
    belongs_to :manager, Gt.Accounts.User
    belongs_to :driver, Gt.Accounts.User

    field :status, Gt.GeoTasks.GeoTask.Status, default: "new"

    field :pickup_point, Geo.PostGIS.Geometry
    field :delivery_point, Geo.PostGIS.Geometry

    field :assigned_at, :utc_datetime
    field :done_at, :utc_datetime

    timestamps()
  end
end
