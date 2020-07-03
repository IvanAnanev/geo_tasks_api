defmodule Gt.Accounts.PolicyTest do
  use Gt.DataCase, async: true

  alias Gt.Accounts.Policy
  @ok :ok
  @forbidden {:error, :forbidden}

  setup do
    manager = insert(:user, role: :manager)
    driver_1 = insert(:user, role: :driver)
    driver_2 = insert(:user, role: :driver)
    {:ok, manager: manager, driver_1: driver_1, driver_2: driver_2}
  end

  describe "policy create geo_task" do
    test "for manager", %{manager: manager} do
      assert Policy.authorize(:create, manager) == @ok
    end

    test "for driver", %{driver_1: driver} do
      assert Policy.authorize(:create, driver) == @forbidden
    end
  end

  describe "policy view geo_tasks" do
    test "for manager", %{manager: manager} do
      assert Policy.authorize(:view, manager) == @ok
    end

    test "for driver", %{driver_1: driver} do
      assert Policy.authorize(:view, driver) == @ok
    end
  end

  describe "policy assigned geo_task" do
    test "for manager", %{manager: manager} do
      geo_task = insert(:geo_task, driver: nil, status: :new)
      assert Policy.authorize(:assigned, manager, geo_task) == @forbidden
    end

    test "for driver and not assigned geo_task", %{driver_1: driver} do
      geo_task = insert(:geo_task, driver: nil, status: :new)
      assert Policy.authorize(:assigned, driver, geo_task) == @ok
    end

    test "for driver and assigned geo_task", %{driver_1: driver, driver_2: driver_2} do
      geo_task = insert(:geo_task, driver: driver_2)
      assert Policy.authorize(:assigned, driver, geo_task) == @forbidden
    end
  end

  describe "policy done geo_task" do
    test "for manager", %{manager: manager} do
      geo_task = insert(:geo_task)
      assert Policy.authorize(:done, manager, geo_task) == @forbidden
    end

    test "for driver and not assigned geo_task", %{driver_1: driver} do
      geo_task = insert(:geo_task, driver: nil)
      assert Policy.authorize(:done, driver, geo_task) == @forbidden
    end

    test "for driver and assigned geo_task by another driver", %{
      driver_1: driver,
      driver_2: driver_2
    } do
      geo_task = insert(:geo_task, driver: driver_2)
      assert Policy.authorize(:done, driver, geo_task) == @forbidden
    end

    test "for driver and assigned geo_task self", %{driver_1: driver} do
      geo_task = insert(:geo_task, driver: driver, status: :assigned)
      assert Policy.authorize(:done, driver, geo_task) == @ok
    end
  end
end
