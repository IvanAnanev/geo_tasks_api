defmodule Gt.GeoTasksTest do
  use Gt.DataCase, async: true

  alias Gt.GeoTasks
  alias Gt.GeoTasks.GeoTask

  describe "find_geo_task_by_id/1" do
    test "geo_task is present" do
      %{id: id} = insert(:geo_task)
      result = GeoTasks.find_geo_task_by_id(id)
      assert match?({:ok, %GeoTask{id: ^id}}, result)
    end

    test "geo_task is unpresent" do
      result = GeoTasks.find_geo_task_by_id(1)
      assert match?({:error, :not_found}, result)
    end
  end

  describe "assigned_geo_task/2" do
    test "success" do
      driver = insert(:user, role: :driver)
      geo_task_new = insert(:geo_task, status: :new)
      result = GeoTasks.assigned_geo_task(driver, geo_task_new)
      assert match?({:ok, %GeoTask{status: :assigned}}, result)
    end
  end

  describe "done_geo_task/2" do
    test "success" do
      driver = insert(:user, role: :driver)
      geo_task_assigned = insert(:geo_task, status: :assigned, driver: driver)
      result = GeoTasks.done_geo_task(driver, geo_task_assigned)
      assert match?({:ok, %GeoTask{status: :done}}, result)
    end
  end
end
