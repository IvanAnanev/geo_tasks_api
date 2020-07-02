defmodule Gt.GeoTasks do
  @moduledoc """
  GeoTasks context.
  """

  alias Gt.GeoTasks.GeoTask

  defmodule Behaviour do
    @moduledoc false
    @callback create_geo_task(manager :: Gt.Accounts.User.t(), attrs :: map) ::
                {:ok, GeoTask.t()} | {:error, Ecto.Changeset.t()}
    @callback find_geo_task_by_id(id :: integer()) :: {:ok, GeoTask.t()} | {:error, :not_found}
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
end
