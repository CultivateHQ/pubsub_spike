defmodule PubsubSpike.PhoenixPubsubTest do
  use ExUnit.Case

  alias PubsubSpike.PhoenixPubsub

  test "broadcast messages" do
    {:ok, pid1} = PhoenixPubsub.start_link("topic:mavis")
    {:ok, pid2} = PhoenixPubsub.start_link("topic:mavis")
    {:ok, pid3} = PhoenixPubsub.start_link("topic:sue")

    PhoenixPubsub.broadcast("topic:mavis", "Hi Mavis!")
    PhoenixPubsub.broadcast("topic:sue", "Hi Sue!")

    assert PhoenixPubsub.messages_received(pid1) == [{:pubsub_spike, "topic:mavis", "Hi Mavis!"}]
    assert PhoenixPubsub.messages_received(pid2) == [{:pubsub_spike, "topic:mavis", "Hi Mavis!"}]
    assert PhoenixPubsub.messages_received(pid3) == [{:pubsub_spike, "topic:sue", "Hi Sue!"}]
  end
end
