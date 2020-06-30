# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :gt,
  ecto_repos: [Gt.Repo]

config :gt_web,
  ecto_repos: [Gt.Repo],
  generators: [context_app: :gt]

# Configures the endpoint
config :gt_web, GtWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uuGvmf+C9LnE9KPAsZXUVmRopHjBEWIGnxK+7K3YXT+W6loBl+iNZ9s0qjEiPM4t",
  render_errors: [view: GtWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Gt.PubSub,
  live_view: [signing_salt: "PnaVtwbx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
