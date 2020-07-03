defmodule Gt.GeoTasks.AllNewGeoTasks do
  @moduledoc """
  All new geo_tasks .
  """

  import Ecto.Query
  import Geo.PostGIS
  alias Gt.GeoTasks.GeoTask

  def all_new_geo_tasks(params) do
    with {:ok, %{current_lat: lat, current_lng: lng}} <- validate_point_params(params),
         point <- Gt.Utils.geo_point(lat, lng) do
      query =
        from gt in GeoTask,
          where: gt.status == "new",
          order_by: [asc: st_distance(gt.pickup_point, ^point)]

      geo_tasks = Gt.Repo.all(query)

      {:ok, geo_tasks}
    end
  end

  defp validate_point_params(params) do
    changeset =
      {%{},
       %{
         current_lat: :float,
         current_lng: :float
       }}
      |> Ecto.Changeset.cast(params, [:current_lat, :current_lng])
      |> Ecto.Changeset.validate_required([:current_lat, :current_lng])

    if changeset.valid? do
      {:ok, Ecto.Changeset.apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end
end
