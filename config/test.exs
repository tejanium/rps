import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rps, RpsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "BG9WSOq8vj7BWhXI6M+hoPmCLIZ+RmdpGuRp3ussjQr72I86M9tQnJpLLEcakYCw",
  server: true

config :rps, time_limit: 2

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
