defmodule PubsubSpike do
  use Application

  @moduledoc false

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Phoenix.PubSub.PG2, [:pubsub_spike, []])
    ]

    opts = [strategy: :one_for_one, name: PubsubSpike.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
