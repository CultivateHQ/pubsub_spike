defmodule PubsubSpike do
  use Application

  @moduledoc false

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Phoenix.PubSub.PG2, [:pubsub_spike, []]),
      supervisor(Registry, [:duplicate,  :pubsub_elixir_registry]),
      worker(PubsubSpike.PhoenixPubsub, ["topic:phoenix_pubsub", [name: :phoenix_pubsub]]),
    ]

    opts = [strategy: :one_for_one, name: PubsubSpike.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
