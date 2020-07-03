defmodule Gt.GeoTasks do
  @moduledoc """
  GeoTasks context.
  """

  alias Gt.Accounts.User
  alias Gt.GeoTasks.GeoTask

  defmodule Behaviour do
    @moduledoc false
    @callback create_geo_task(manager :: User.t(), attrs :: map) ::
                {:ok, GeoTask.t()} | {:error, Ecto.Changeset.t()}
    @callback find_geo_task_by_id(id :: integer()) :: {:ok, GeoTask.t()} | {:error, :not_found}
    @callback assigned_geo_task(driver :: User.t(), geo_task :: GeoTask.t()) :: {:ok, GeoTask.t()}
    @callback done_geo_task(driver :: User.t(), geo_task :: GeoTask.t()) :: {:ok, GeoTask.t()}
    @callback all_new_geo_tasks(params :: map()) ::
                {:ok, [GeoTask.t()]} | {:error, Ecto.Changeset.t()}
  end

  @behaviour Gt.GeoTasks.Behaviour

  @impl true
  defdelegate create_geo_task(manager, attrs), to: Gt.GeoTasks.CreateGeoTask

  @impl true
  def find_geo_task_by_id(id) do
    case Gt.Repo.get(GeoTask, id) do
      nil -> {:error, :not_found}
      geo_task -> {:ok, geo_task}
    end
  end

  @impl true
  def assigned_geo_task(%User{} = driver, %GeoTask{} = geo_task) do
    geo_task
    |> Ecto.Changeset.change(%{
      status: :assigned,
      driver_id: driver.id,
      assigned_at: timestamp()
    })
    |> Gt.Repo.update()
  end

  @impl true
  def done_geo_task(%User{} = driver, %GeoTask{} = geo_task) do
    geo_task
    |> Ecto.Changeset.change(%{
      status: :done,
      driver_id: driver.id,
      done_at: timestamp()
    })
    |> Gt.Repo.update()
  end

  @impl true
  defdelegate all_new_geo_tasks(params), to: Gt.GeoTasks.AllNewGeoTasks

  defp timestamp do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
  end
end
