defmodule GtWeb.UsersControllerTest do
  use GtWeb.ConnCase
  alias Gt.Accounts.User

  import Mox

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    test "success signup", %{conn: conn} do
      Gt.Accounts.Mock
      |> expect(:create_user, fn _params ->
        {:ok, %User{email: "some@email.com", role: :driver}}
      end)

      response = post(conn, "/api/users/signup", %{})
      assert response.status == 201

      assert match?(
               %{"user" => %{"email" => "some@email.com", "role" => "driver"}},
               parse_response(response)
             )
    end

    test "failed", %{conn: conn} do
      Gt.Accounts.Mock
      |> expect(:create_user, fn _params -> {:error, User.changeset(%User{}, %{})} end)

      response = post(conn, "/api/users/signup", %{})
      assert response.status == 422

      assert match?(
               %{
                 "errors" => %{
                   "email" => ["can't be blank"],
                   "password" => ["can't be blank"],
                   "role" => ["can't be blank"]
                 }
               },
               parse_response(response)
             )
    end
  end

  defp parse_response(resp) do
    Jason.decode!(resp.resp_body)
  end
end
