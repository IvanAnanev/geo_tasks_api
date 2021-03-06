defmodule GtWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use GtWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(GtWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(GtWeb.ErrorView)
    |> render("error.json", %{message: "Not found"})
  end

  def call(conn, {:error, :token_expired}) do
    conn
    |> put_status(401)
    |> put_view(GtWeb.ErrorView)
    |> render("error.json", %{message: "Token is expired"})
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(403)
    |> put_view(GtWeb.ErrorView)
    |> render("error.json", %{message: "Forbidden action with you role"})
  end

  def call(conn, {:error, error_message}) do
    conn
    |> put_status(401)
    |> put_view(GtWeb.ErrorView)
    |> render("error.json", %{message: error_message})
  end
end
