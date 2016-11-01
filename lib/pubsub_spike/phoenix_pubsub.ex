defmodule PubsubSpike.PhoenixPubsub do
  use GenServer

  alias Phoenix.PubSub

  @moduledoc """
  Illustrates subscribing to a topic using `Phoenix.PubSub`
  """


  def start_link(topic, otp_opts \\ []) do
    GenServer.start_link(__MODULE__, topic, otp_opts)
  end

  def broadcast(topic, message) do
    PubSub.broadcast(:pubsub_spike, topic, {:pubsub_spike, topic, message})
  end

  def messages_received(pid) do
    GenServer.call(pid, :messages_received)
  end

  def init(topic) do
    PubSub.subscribe(:pubsub_spike, topic)
    {:ok, []}
  end

  def handle_call(:messages_received, _from, messages_received) do
    {:reply, Enum.reverse(messages_received), messages_received}
  end

  def handle_info({:pubsub_spike, _, _} = msg, messages_received) do
    {:noreply, [msg | messages_received]}
  end
end
