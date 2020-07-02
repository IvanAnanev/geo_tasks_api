defmodule GtWeb.AuthControllerTest do
  use GtWeb.ConnCase
  alias Gt.Accounts.User

  import Mox

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  @user %User{email: "some@email.com", role: :driver}
  @session_create_params %{"email" => "some@email.com", "password" => "password"}

  describe "create session" do
    test "success", %{conn: conn} do
      Gt.Accounts.Mock
      |> expect(:find_user_by_email, fn _email -> {:ok, @user} end)
      |> expect(:verify_user, fn _user, _password -> {:ok, @user} end)

      response = post(conn, "/api/session", @session_create_params)
      assert response.status == 200

      assert match?(
               %{"data" => %{"access_token" => %{}, "refresh_token" => %{}}},
               parse_response(response)
             )
    end

    test "when user is not present", %{conn: conn} do
      Gt.Accounts.Mock
      |> expect(:find_user_by_email, fn _email -> {:error, :not_found} end)

      response = post(conn, "/api/session", @session_create_params)
      assert response.status == 404

      assert match?(
               %{"errors" => %{"general" => "User not found"}},
               parse_response(response)
             )
    end

    test "when password is not wrong", %{conn: conn} do
      Gt.Accounts.Mock
      |> expect(:find_user_by_email, fn _email -> {:ok, @user} end)
      |> expect(:verify_user, fn _user, _password -> {:error, "invalid password"} end)

      response = post(conn, "/api/session", @session_create_params)
      assert response.status == 401

      assert match?(
               %{"errors" => %{"general" => "Invalid password"}},
               parse_response(response)
             )
    end
  end

  describe "refresh session" do
    test "with valid refresh token", %{conn: conn} do
      Gt.Accounts.Mock
      |> expect(:find_user_by_email, fn _email -> {:ok, @user} end)

      {:ok, refresh_token, _claim} = GtWeb.Guardian.encode_and_sign(@user, %{"typ" => "refresh"})

      response = post(conn, "/api/session/refresh", %{"refresh" => refresh_token})
      assert response.status == 200

      assert match?(
               %{"data" => %{"access_token" => %{}, "refresh_token" => %{}}},
               parse_response(response)
             )
    end

    test "with invalid refresh token", %{conn: conn} do
      response = post(conn, "/api/session/refresh", %{"refresh" => "bad_token"})
      assert response.status == 401

      assert match?(
               %{"errors" => %{"general" => "Invalid refresh token"}},
               parse_response(response)
             )
    end

    test "with invalid user", %{conn: conn} do
      Gt.Accounts.Mock
      |> expect(:find_user_by_email, fn _email -> {:error, :not_found} end)

      {:ok, refresh_token, _claim} = GtWeb.Guardian.encode_and_sign(@user, %{"typ" => "refresh"})

      response = post(conn, "/api/session/refresh", %{"refresh" => refresh_token})
      assert response.status == 401

      assert match?(
               %{"errors" => %{"general" => "Invalid refresh token"}},
               parse_response(response)
             )
    end
  end

  defp parse_response(resp) do
    Jason.decode!(resp.resp_body)
  end
end
