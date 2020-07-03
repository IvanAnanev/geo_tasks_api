defmodule GtWeb.Auth.AccessPlug do
  @moduledoc """
  Plug for authorization and insert current_user to Plug.Conn struct.
  """

  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user, %{"typ" => "access"}} <- GtWeb.Guardian.resource_from_token(token) do
      assign(conn, :current_user, user)
    else
      _ ->
        conn
        |> put_status(401)
        |> Phoenix.Controller.json(%{errors: %{general: "Unauthorized request"}})
        |> halt
    end
  end
end
