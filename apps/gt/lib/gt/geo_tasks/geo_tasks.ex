defmodule Gt.GeoTasks do
  @moduledoc """
  GeoTasks context.
  """

  alias Gt.GeoTasks.GeoTask

  defmodule Behaviour do
    @moduledoc false
    @callback create_geo_task(manager :: Gt.Accounts.User.t(), attrs :: map) ::
                {:ok, GeoTask.t()} | {:error, Ecto.Changeset.t()}
  end

  @behaviour Gt.GeoTasks.Behaviour

  @impl true
  defdelegate create_geo_task(manager, attrs), to: Gt.GeoTasks.CreateGeoTask
end
