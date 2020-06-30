defmodule GtWeb.Router do
  use GtWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GtWeb do
    pipe_through :api
  end
end
