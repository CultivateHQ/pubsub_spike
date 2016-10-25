defmodule PubsubSpike.GprocTest do
  use ExUnit.Case

  alias PubsubSpike.Gproc

  test "broadcast messages" do
    {:ok, pid1} = Gproc.start_link
    {:ok, pid2} = Gproc.start_link

    Gproc.broadcast_event1(:sue, "Hi Sue!")

    assert Gproc.messages_received(pid1) == [{:event1, :sue, "Hi Sue!"}]
    assert Gproc.messages_received(pid2) == [{:event1, :sue, "Hi Sue!"}]
  end
end
