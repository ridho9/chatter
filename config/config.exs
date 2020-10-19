# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :chatter,
  ecto_repos: [Chatter.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :chatter, ChatterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ci+b+4NRImXJf8vTLDPb+8suTN+Z4X56HTWpTvL7py3HGn2xRORaPmEojUeAbhQb",
  render_errors: [view: ChatterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Chatter.PubSub,
  live_view: [signing_salt: "TgZMZ+2K"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
