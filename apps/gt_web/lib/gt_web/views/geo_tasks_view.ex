defmodule GtWeb.GeoTasksView do
  use GtWeb, :view

  def render("geo_task.json", %{geo_task: geo_task}) do
    %{
      data: %{
        id: geo_task.id,
        status: geo_task.status,
        pickup_point: point(geo_task.pickup_point),
        delivery_point: point(geo_task.delivery_point)
      }
    }
  end

  defp point(%Geo.Point{coordinates: {lat, lng}}) do
    %{lat: lat, lng: lng}
  end
end
