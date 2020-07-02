defmodule Gt.Repo.Migrations.CreateGeoTasks do
  use Ecto.Migration

  def change do
    execute(
      "CREATE EXTENSION IF NOT EXISTS postgis",
      "DROP EXTENSION IF EXISTS postgis"
    )

    execute(
      "CREATE TYPE geo_task_status AS ENUM ('new', 'assigned', 'done')",
      "DROP TYPE geo_task_status"
    )

    create table(:geo_tasks) do
      add :status, :geo_task_status, null: false, default: "new"

      add :assigned_at, :utc_datetime
      add :done_at, :utc_datetime

      add :manager_id, references(:users)
      add :driver_id, references(:users)

      timestamps()
    end

    execute("SELECT AddGeometryColumn ('geo_tasks','pickup_point',4326,'POINT',2);", "")
    execute("SELECT AddGeometryColumn ('geo_tasks','delivery_point',4326,'POINT',2);", "")
  end
end
