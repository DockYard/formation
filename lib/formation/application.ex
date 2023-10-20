defmodule Formation.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FormationWeb.Telemetry,
      Formation.Repo,
      {DNSCluster, query: Application.get_env(:formation, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Formation.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Formation.Finch},
      # Start a worker by calling: Formation.Worker.start_link(arg)
      # {Formation.Worker, arg},
      # Start to serve requests, typically the last entry
      FormationWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Formation.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FormationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
