defmodule Formation.Repo do
  use Ecto.Repo,
    otp_app: :formation,
    adapter: Ecto.Adapters.Postgres
end
