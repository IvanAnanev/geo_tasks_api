defmodule Gt.GeoTasks.CreateGeoTask do
  @moduledoc """
  Create GeoTask operation.
  """
  def create_geo_task(%Gt.Accounts.User{} = manager, attrs) do
    with {:ok, point_params} <- validate_point_params(attrs),
         {pickup_point, delivery_point} <- prepare_geo_points(point_params) do
      %Gt.GeoTasks.GeoTask{
        status: :new,
        manager_id: manager.id,
        pickup_point: pickup_point,
        delivery_point: delivery_point
      }
      |> Gt.Repo.insert()
    end
  end

  defp validate_point_params(attrs) do
    changeset =
      {%{},
       %{
         pickup_lat: :float,
         pickup_lng: :float,
         delivery_lat: :float,
         delivery_lng: :float
       }}
      |> Ecto.Changeset.cast(attrs, [:pickup_lat, :pickup_lng, :delivery_lat, :delivery_lng])
      |> Ecto.Changeset.validate_required([:pickup_lat, :pickup_lng, :delivery_lat, :delivery_lng])

    if changeset.valid? do
      {:ok, Ecto.Changeset.apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end

  @srid 4326
  defp prepare_geo_points(%{
         pickup_lat: pickup_lat,
         pickup_lng: pickup_lng,
         delivery_lat: delivery_lat,
         delivery_lng: delivery_lng
       }) do
    {
      %Geo.Point{coordinates: {pickup_lat, pickup_lng}, srid: @srid},
      %Geo.Point{coordinates: {delivery_lat, delivery_lng}, srid: @srid}
    }
  end
end
