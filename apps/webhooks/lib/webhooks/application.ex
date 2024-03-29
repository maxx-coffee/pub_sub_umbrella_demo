defmodule Webhooks.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Webhooks.Sites,
      {Webhooks.PubsubConsumer, []},
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Webhooks.Endpoint,
        options: [port: 4001]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Webhooks.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
