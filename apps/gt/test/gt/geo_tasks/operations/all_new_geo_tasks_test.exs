defmodule Gt.GeoTasks.AllNewGeoTasksTest do
  use Gt.DataCase, async: true

  alias Gt.GeoTasks.AllNewGeoTasks

  setup do
    insert(:geo_task, status: :new, pickup_point: build(:geo_point, lat: 10.0, lng: 10.0))
    insert(:geo_task, status: :new, pickup_point: build(:geo_point, lat: 20.0, lng: 20.0))

    :ok
  end

  describe "all_new_geo_tasks/1" do
    test "with invalid params" do
      result = AllNewGeoTasks.all_new_geo_tasks(%{})

      assert match?({:error, %Ecto.Changeset{}}, result)
    end

    test "from {0.0, 0.0}" do
      {:ok, result} = AllNewGeoTasks.all_new_geo_tasks(%{current_lat: 0.0, current_lng: 0.0})

      assert match?(
               [
                 %Gt.GeoTasks.GeoTask{pickup_point: %Geo.Point{coordinates: {10.0, 10.0}}},
                 %Gt.GeoTasks.GeoTask{pickup_point: %Geo.Point{coordinates: {20.0, 20.0}}}
               ],
               result
             )
    end

    test "from {30.0, 30.0}" do
      {:ok, result} = AllNewGeoTasks.all_new_geo_tasks(%{current_lat: 30.0, current_lng: 30.0})

      assert match?(
               [
                 %Gt.GeoTasks.GeoTask{pickup_point: %Geo.Point{coordinates: {20.0, 20.0}}},
                 %Gt.GeoTasks.GeoTask{pickup_point: %Geo.Point{coordinates: {10.0, 10.0}}}
               ],
               result
             )
    end
  end
end
