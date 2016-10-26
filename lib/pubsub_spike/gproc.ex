defmodule PubsubSpike.Gproc do
  use GenServer
  require Logger

  @moduledoc """
  GenServer that registers itself twice with :gproc, to receive messages. Based on an original post by Preston Marshall,
  http://bbhoss.io/easy-pub-sub-event-dispatch-with-gproc-and-elixir/
  """

  @gproc_names [:mavis, :sue]

  def start_link do
    GenServer.start_link(__MODULE__, {})
  end

  def broadcast_event1(destination, msg) do
    GenServer.cast({:via, :gproc, {:p, :l, destination}}, {:event1, destination, msg})
  end

  def messages_received(pid) do
    GenServer.call(pid, :messages_received)
  end

  def init(_) do
    @gproc_names
    |> Enum.each(fn name ->
      :gproc.reg({:p, :l, name})
    end)
    {:ok, []}
  end

  def handle_cast(event, messages_received) do
    {:noreply, [event | messages_received]}
  end

  def handle_call(:messages_received, _from, messages_received) do
    {:reply, Enum.reverse(messages_received), messages_received}
  end
end