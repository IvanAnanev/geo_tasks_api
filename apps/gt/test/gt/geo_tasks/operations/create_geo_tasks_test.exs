defmodule Gt.GeoTasks.CreateGeoTaskTest do
  use Gt.DataCase, async: true

  alias Gt.GeoTasks.CreateGeoTask

  setup do
    manager = insert(:user, role: :manager)
    {:ok, manager: manager}
  end

  @valid_params %{
    "pickup_lat" => "50.0",
    "pickup_lng" => "51.0",
    "delivery_lat" => "52.0",
    "delivery_lng" => "53.0"
  }

  describe "create_geo_task/2" do
    test "with unvalid params", %{manager: manager} do
      result = CreateGeoTask.create_geo_task(manager, %{})
      assert match?({:error, %Ecto.Changeset{}}, result)
    end

    test "with valid params", %{manager: manager} do
      result = CreateGeoTask.create_geo_task(manager, @valid_params)
      assert match?({:ok, %Gt.GeoTasks.GeoTask{}}, result)
    end
  end
end
