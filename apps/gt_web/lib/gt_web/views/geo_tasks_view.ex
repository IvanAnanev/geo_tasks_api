defmodule GtWeb.GeoTasksView do
  use GtWeb, :view

  def render("show.json", %{geo_task: geo_task}) do
    %{
      geo_task: render_one(geo_task, GtWeb.GeoTasksView, "geo_task.json")
    }
  end

  def render("index.json", %{geo_tasks: geo_tasks}) do
    %{
      geo_tasks: render_many(geo_tasks, GtWeb.GeoTasksView, "geo_task.json")
    }
  end

  def render("geo_task.json", %{geo_tasks: geo_task}) do
    %{
      id: geo_task.id,
      status: geo_task.status,
      pickup_point: point(geo_task.pickup_point),
      delivery_point: point(geo_task.delivery_point),
      inserted_at: geo_task.inserted_at,
      assigned_at: geo_task.assigned_at,
      done_at: geo_task.done_at
    }
  end

  defp point(%Geo.Point{coordinates: {lat, lng}}) do
    %{lat: lat, lng: lng}
  end
end
