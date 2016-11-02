defmodule PubsubSpike.Gproc do
  use GenServer
  require Logger

  @moduledoc """
  GenServer that registers itself twice with :gproc, to receive messages. Based on an original post by Preston Marshall,
  http://bbhoss.io/easy-pub-sub-event-dispatch-with-gproc-and-elixir/
  """


  def start_link(topic, otp_opts \\ []) do
    GenServer.start_link(__MODULE__, topic, otp_opts)
  end

  def broadcast(topic, message) do
    GenServer.cast({:via, :gproc, gproc_key(topic)}, {:broadcast, message})
  end

  def messages_received(pid) do
    GenServer.call(pid, :messages_received)
  end

  def init(topic) do
    :gproc.reg(gproc_key(topic))
    {:ok, []}
  end

  def handle_cast({:broadcast, message}, messages_received) do
    {:noreply, [message | messages_received]}
  end

  def handle_call(:messages_received, _from, messages_received) do
    {:reply, Enum.reverse(messages_received), messages_received}
  end


  defp gproc_key(topic) do
    {:p, :l, topic}
  end
end
