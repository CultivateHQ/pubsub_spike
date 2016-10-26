defmodule PubsubSpike.PhoenixPubsubTest do
  use ExUnit.Case

  alias PubsubSpike.PhoenixPubsub

  test "broadcast messages" do
    {:ok, pid1} = PhoenixPubsub.start_link
    {:ok, pid2} = PhoenixPubsub.start_link

    PhoenixPubsub.broadcast("topic:mavis", "Hi Mavis!")

    assert PhoenixPubsub.messages_received(pid1) == [{:pubsub_spike, "topic:mavis", "Hi Mavis!"}]
    assert PhoenixPubsub.messages_received(pid2) == [{:pubsub_spike, "topic:mavis", "Hi Mavis!"}]
  end
end
