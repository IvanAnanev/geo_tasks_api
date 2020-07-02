defmodule GtWeb.AuthController do
  use GtWeb, :controller

  @accounts Application.compile_env(:gt, :accounts_context, Gt.Accounts)

  action_fallback GtWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- @accounts.find_user_by_email(email),
         {:ok, user} <- @accounts.verify_user(user, password),
         {:ok, access_token, refresh_token} <- generate_tokens(user) do
      render(conn, "tokens.json", tokens: {access_token, refresh_token})
    end
  end

  def create(conn, %{"refresh" => token}) do
    with {:ok, user, %{"typ" => "refresh"}} <- GtWeb.Guardian.resource_from_token(token),
         {:ok, access_token, refresh_token} <- generate_tokens(user) do
      render(conn, "tokens.json", tokens: {access_token, refresh_token})
    else
      _ ->
        json_errors_response(conn, 401, "Invalid refresh token")
    end
  end

  def create(conn, _params) do
    json_errors_response(
      conn,
      401,
      "Invalid session create params, expecting `email` and `password`"
    )
  end

  defp generate_tokens(user) do
    with {:ok, access_token, %{"exp" => access_token_expires_at}} <-
           GtWeb.Guardian.encode_and_sign(user, %{"typ" => "access"}),
         {:ok, refresh_token, %{"exp" => refresh_token_expires_at}} <-
           GtWeb.Guardian.encode_and_sign(user, %{"typ" => "refresh"}) do
      {:ok, {access_token, access_token_expires_at}, {refresh_token, refresh_token_expires_at}}
    end
  end
end
