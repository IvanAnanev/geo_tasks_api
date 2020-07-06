defmodule Gt.Accounts.Policy do
  @moduledoc """
  Policy.
  """
  alias Gt.Accounts.User
  alias Gt.GeoTasks.GeoTask

  @forbidden {:error, :forbidden}
  @ok :ok

  def authorize(action, user, geo_task \\ nil)
  def authorize(:create, %User{role: :manager}, _geo_task), do: @ok
  def authorize(:view, _user, _geo_task), do: @ok

  def authorize(:assigned, %User{role: :driver} = driver, %GeoTask{status: :new}) do
    case Gt.GeoTasks.count_assigned_geo_tasks_for_driver(driver) do
      0 -> @ok
      _ -> @forbidden
    end
  end

  def authorize(:done, %User{id: id, role: :driver}, %GeoTask{status: :assigned, driver_id: id}),
    do: @ok

  def authorize(_action, _user, _geo_task), do: @forbidden
end
