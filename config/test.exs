import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :amazonS3, AmazonS3.Repo,
  username: "root",
  password: "",
  database: "amazons3_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :amazonS3, AmazonS3Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "TkP2lItUIlE6gCSfGXMQI8pJZQ2Ebd56IjtaYItXkAqM7ibHMqR17zkql4tI2f5D",
  server: false

# In test we don't send emails.
config :amazonS3, AmazonS3.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
