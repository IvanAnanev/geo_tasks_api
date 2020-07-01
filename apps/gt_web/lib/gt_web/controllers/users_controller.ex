defmodule GtWeb.UsersController do
  use GtWeb, :controller

  @accounts Application.compile_env(:gt, :accounts_context, Gt.Accounts)

  action_fallback GtWeb.FallbackController

  def create(conn, params) do
    with {:ok, user} <- @accounts.create_user(params) do
      conn
      |> put_status(:created)
      |> render("user.json", user: user)
    end
  end
end
