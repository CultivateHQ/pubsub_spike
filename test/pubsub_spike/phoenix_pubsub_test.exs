defmodule PubsubSpike.PhoenixPubsubTest do
  use ExUnit.Case

  alias PubsubSpike.PhoenixPubsub

  test "broadcast messages" do
    {:ok, pid1} = PhoenixPubsub.start_link("mavis")
    {:ok, pid2} = PhoenixPubsub.start_link("mavis")
    {:ok, pid3} = PhoenixPubsub.start_link("sue") #registering with atoms not supported by Registry

    PhoenixPubsub.broadcast("mavis", "Hi Mavis!")
    PhoenixPubsub.broadcast("sue", "Hi Sue!")

    assert PhoenixPubsub.messages_received(pid1) == ["Hi Mavis!"]
    assert PhoenixPubsub.messages_received(pid2) == ["Hi Mavis!"]
    assert PhoenixPubsub.messages_received(pid3) == ["Hi Sue!"]
  end
end
