defmodule HookBugRepro.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HookBugReproWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:hook_bug_repro, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HookBugRepro.PubSub},
      # Start a worker by calling: HookBugRepro.Worker.start_link(arg)
      # {HookBugRepro.Worker, arg},
      # Start to serve requests, typically the last entry
      HookBugReproWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HookBugRepro.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HookBugReproWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
