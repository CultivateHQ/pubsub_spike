defmodule PubsubSpike.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pubsub_spike,
      version: "0.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [applications: [:gproc, :phoenix_pubsub, :logger], mod: {PubsubSpike, []}]
  end

  defp deps do
    [
      {:gproc, "~> 0.6.0"},
      {:phoenix_pubsub, ">= 0.1.0"},
      {:credo, "~> 0.9.0-rc7"}
    ]
  end
end
