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
      |> render("show.json", geo_task: geo_task)
    end
  end

  def show(%{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    with :ok <- @accounts.authorize(:view, user),
         {:ok, geo_task} <- @geo_tasks.find_geo_task_by_id(id) do
      render(conn, "show.json", geo_task: geo_task)
    end
  end

  def assigned(%{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    with {:ok, geo_task} <- @geo_tasks.find_geo_task_by_id(id),
         :ok <- @accounts.authorize(:assigned, user, geo_task),
         {:ok, geo_task} <- @geo_tasks.assigned_geo_task(user, geo_task) do
      render(conn, "show.json", geo_task: geo_task)
    end
  end

  def done(%{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    with {:ok, geo_task} <- @geo_tasks.find_geo_task_by_id(id),
         :ok <- @accounts.authorize(:done, user, geo_task),
         {:ok, geo_task} <- @geo_tasks.done_geo_task(user, geo_task) do
      render(conn, "show.json", geo_task: geo_task)
    end
  end

  def index(%{assigns: %{current_user: user}} = conn, params) do
    with :ok <- @accounts.authorize(:view, user),
         {:ok, geo_tasks} <- @geo_tasks.all_new_geo_tasks(params) do
      render(conn, "index.json", geo_tasks: geo_tasks)
    end
  end
end
