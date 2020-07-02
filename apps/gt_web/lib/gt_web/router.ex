defmodule GtWeb.Router do
  use GtWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GtWeb do
    pipe_through :api

    post "/users/signup", UsersController, :create
    post "/session", AuthController, :create
    post "/session/refresh", AuthController, :create
  end
end
