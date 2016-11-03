defmodule PubsubSpike.PhoenixPubsub do
  use GenServer

  alias Phoenix.PubSub

  @moduledoc """
  Illustrates subscribing to a topic using `Phoenix.PubSub`
  """

  @doc """
  Create a GenServer that subscribes to messages on the particular topic. The topic must be a binary (String),
  as that is what Phoenix PubSub supports.
  """
  def start_link(topic, otp_opts \\ []) when is_binary(topic) do
    GenServer.start_link(__MODULE__, topic, otp_opts)
  end

  @doc """
  Broadcast a message to a particular topic.
  """
  def broadcast(topic, message) do
    PubSub.broadcast(:pubsub_spike, topic, {:pubsub_spike, topic, message})
  end

  @doc """
  Lists, in order, all the messages received.
  """
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

  def handle_info({:pubsub_spike, _topic, msg}, messages_received) do
    {:noreply, [msg | messages_received]}
  end
end
