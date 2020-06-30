defmodule Gt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Gt.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Gt.PubSub}
      # Start a worker by calling: Gt.Worker.start_link(arg)
      # {Gt.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Gt.Supervisor)
  end
end
