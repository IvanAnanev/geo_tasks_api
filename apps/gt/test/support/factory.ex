defmodule Gt.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Gt.Repo

  def user_factory do
    %Gt.Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      password_hash: sequence("pass_hash"),
      role: sequence(:role, [:manager, :driver])
    }
  end

  def geo_task_factory do
    %Gt.GeoTasks.GeoTask{
      status: sequence(:role, [:new, :assigned, :done]),
      manager: build(:user, role: :manager),
      driver: build(:user, role: :driver),
      pickup_point: build(:geo_point, lat: 50.0, lng: 50.0),
      delivery_point: build(:geo_point, lat: 51.0, lng: 51.0)
    }
  end

  def geo_point_factory(%{lat: lat, lng: lng}) do
    Gt.Utils.geo_point(lat, lng)
  end
end
