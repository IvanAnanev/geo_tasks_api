defmodule GtWeb.GeoTasksControllerTest do
  use GtWeb.ConnCase
  alias Gt.Accounts.User
  alias Gt.GeoTasks.GeoTask

  import Mox

  @manager %User{email: "manager@email.com", role: :manager}
  @driver %User{email: "driver@email.com", role: :driver}
  @geo_task_new %GeoTask{
    id: 1,
    status: :new,
    pickup_point: %Geo.Point{coordinates: {50.0, 51.0}},
    delivery_point: %Geo.Point{coordinates: {52.0, 53.0}}
  }
  @geo_task_assigned %GeoTask{
    id: 1,
    status: :assigned,
    pickup_point: %Geo.Point{coordinates: {50.0, 51.0}},
    delivery_point: %Geo.Point{coordinates: {52.0, 53.0}}
  }
  @params %{
    "pickup_lat" => 50.0,
    "pickup_lng" => 51.0,
    "delivery_lat" => 52.0,
    "delivery_lng" => 53.0
  }
  @changeset Ecto.Changeset.cast({%{}, %{some: :float}}, %{}, [:some])

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")
    {:ok, manager_token, _claim} = GtWeb.Guardian.encode_and_sign(@manager, %{"typ" => "access"})
    manager_conn = put_req_header(conn, "authorization", "Bearer #{manager_token}")
    {:ok, driver_token, _claim} = GtWeb.Guardian.encode_and_sign(@driver, %{"typ" => "access"})
    driver_conn = put_req_header(conn, "authorization", "Bearer #{driver_token}")

    {:ok, conn: conn, manager_conn: manager_conn, driver_conn: driver_conn}
  end

  describe "create" do
    test "success", %{manager_conn: conn} do
      Gt.Accounts.Mock
      |> expect(:find_user_by_email, fn _email -> {:ok, @manager} end)
      |> expect(:authorize, fn _action, _user -> :ok end)

      Gt.GeoTasks.Mock
      |> expect(:create_geo_task, fn _user, _params -> {:ok, @geo_task_new} end)

      response = post(conn, "/api/geo_tasks", @params)
      assert response.status == 201

      assert match?(
               %{"geo_task" => %{"status" => "new"}},
               parse_response(response)
             )
    end

    test "without authorization token", %{conn: conn} do
      response = post(conn, "/api/geo_tasks", @params)
      assert response.status == 401

      assert match?(
               %{"errors" => %{"general" => "Unauthorized request"}},
               parse_response(response)
             )
    end

    test "with driver token", %{driver_conn: conn} do
      Gt.Accounts.Mock
      |> expect(:find_user_by_email, fn _email -> {:ok, @driver} end)
      |> expect(:authorize, fn _action, _user -> {:error, :forbidden} end)

      response = post(conn, "/api/geo_tasks", @params)
      assert response.status == 403

      assert match?(
               %{"errors" => %{"general" => "Forbidden action with you role"}},
               parse_response(response)
             )
    end

    test "with invalid params", %{manager_conn: conn} do
      Gt.Accounts.Mock
      |> expect(:find_user_by_email, fn _email -> {:ok, @manager} end)
      |> expect(:authorize, fn _action, _user -> :ok end)

      Gt.GeoTasks.Mock
      |> expect(:create_geo_task, fn _user, _params -> {:error, @changeset} end)

      response = post(conn, "/api/geo_tasks", %{})
      assert response.status == 422

      assert match?(
               %{"errors" => %{}},
               parse_response(response)
             )
    end
  end

  describe "show" do
    test "without authorization token", %{conn: conn} do
      response = get(conn, "/api/geo_tasks/1")
      assert response.status == 401

      assert match?(
               %{"errors" => %{"general" => "Unauthorized request"}},
               parse_response(response)
             )
    end

    test "with authorize", %{driver_conn: conn} do
      Gt.Accounts.Mock
      |> expect(:find_user_by_email, fn _email -> {:ok, @driver} end)
      |> expect(:authorize, fn _action, _user -> :ok end)

      Gt.GeoTasks.Mock
      |> expect(:find_geo_task_by_id, fn _id -> {:ok, @geo_task_new} end)

      response = get(conn, "/api/geo_tasks/1")
      assert response.status == 200

      assert match?(
               %{"geo_task" => %{"status" => "new"}},
               parse_response(response)
             )
    end
  end

  describe "assigned" do
    test "without authorization token", %{conn: conn} do
      response = post(conn, "/api/geo_tasks/1/assigned")
      assert response.status == 401

      assert match?(
               %{"errors" => %{"general" => "Unauthorized request"}},
               parse_response(response)
             )
    end

    test "with authorize", %{driver_conn: conn} do
      Gt.Accounts.Mock
      |> expect(:find_user_by_email, fn _email -> {:ok, @driver} end)
      |> expect(:authorize, fn _action, _user, _geo_task -> :ok end)

      Gt.GeoTasks.Mock
      |> expect(:find_geo_task_by_id, fn _id -> {:ok, @geo_task_new} end)
      |> expect(:assigned_geo_task, fn _user, _geo_task -> {:ok, @geo_task_assigned} end)

      response = post(conn, "/api/geo_tasks/1/assigned")
      assert response.status == 200

      assert match?(
               %{"geo_task" => %{"status" => "assigned"}},
               parse_response(response)
             )
    end
  end

  defp parse_response(resp) do
    Jason.decode!(resp.resp_body)
  end
end
