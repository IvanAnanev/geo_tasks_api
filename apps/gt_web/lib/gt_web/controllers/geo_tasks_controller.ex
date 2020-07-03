defmodule GtWeb.GeoTasksController do
  use GtWeb, :controller

  @accounts Application.compile_env(:gt, :accounts_context, Gt.Accounts)
  @geo_tasks Application.compile_env(:gt, :geo_tasks_context, Gt.GeoTasks)

  action_fallback GtWeb.FallbackController

  def create(%{assigns: %{current_user: user}} = conn, params) do
    with :ok <- @accounts.authorize(:create, user),
         {:ok, geo_task} <- @geo_tasks.create_geo_task(user, params) do
      conn
      |> put_status(:created)
      |> render("geo_task.json", geo_task: geo_task)
    end
  end
end
