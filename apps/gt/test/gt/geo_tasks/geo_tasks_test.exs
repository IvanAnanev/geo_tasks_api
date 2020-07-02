defmodule Gt.GeoTasksTest do
  use Gt.DataCase, async: true

  alias Gt.GeoTasks

  describe "find_geo_task_by_id/1" do
    test "geo_task is present" do
      %{id: id} = insert(:geo_task)
      result = GeoTasks.find_geo_task_by_id(id)

      assert match?({:ok, %Gt.GeoTasks.GeoTask{id: ^id}}, result)
    end

    test "geo_task is unpresent" do
      result = GeoTasks.find_geo_task_by_id(1)

      assert match?({:error, :not_found}, result)
    end
  end
end
