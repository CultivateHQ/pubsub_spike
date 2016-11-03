defmodule PubsubSpike.ElixirRegistry do
  use GenServer

  @moduledoc """
  Using the new experimental Elixir Process Registry for local event dispatching.
  """

  @doc """
  Create a GenServer that subscribes to messages on the particular topic. The topic can be pretty much any type of thing, binary, atom, tuple, etc...
  """
  def start_link(topic, otp_opts \\ []) do
    GenServer.start_link(__MODULE__, topic, otp_opts)
  end

  @doc """
  Broadcast a message to a particular topic.
  """
  def broadcast(topic, message) do
    Registry.dispatch(:pubsub_elixir_registry, topic, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:broadcast, message})
    end)
  end

  @doc """
  Lists, in order, all the messages received.
  """
  def messages_received(pid) do
    GenServer.call(pid, :messages_received)
  end


  def init(topic) do
    Registry.register(:pubsub_elixir_registry, topic, [])
    {:ok, []}
  end

  def handle_info({:broadcast, message}, messages_received) do
    {:noreply, [message | messages_received]}
  end

  def handle_call(:messages_received, _from, messages_received) do
    {:reply, Enum.reverse(messages_received), messages_received}
  end
end
