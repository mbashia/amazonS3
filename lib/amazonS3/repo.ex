defmodule AmazonS3.Repo do
  use Ecto.Repo,
    otp_app: :amazonS3,
    adapter: Ecto.Adapters.MyXQL
end
