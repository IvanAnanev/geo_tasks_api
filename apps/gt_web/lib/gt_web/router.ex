defmodule GtWeb.Router do
  use GtWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_protected do
    plug GtWeb.Auth.AccessPlug
  end

  scope "/api", GtWeb do
    pipe_through :api

    post "/users/signup", UsersController, :create

    post "/session", AuthController, :create
    post "/session/refresh", AuthController, :create

    scope "/" do
      pipe_through :api_protected

      post "/geo_tasks", GeoTasksController, :create
      get "/geo_tasks/:id", GeoTasksController, :show
    end
  end
end
