defmodule PubsubSpike.GprocTest do
  use ExUnit.Case

  alias PubsubSpike.Gproc

  test "broadcast messages" do
    {:ok, pid1} = Gproc.start_link(:sue)
    {:ok, pid2} = Gproc.start_link(:sue)
    {:ok, pid3} = Gproc.start_link(:miranda)

    Gproc.broadcast_event1(:sue, "Hi Sue!")
    Gproc.broadcast_event1(:miranda, "Hi Miranda!")

    assert Gproc.messages_received(pid1) == [{:event1, :sue, "Hi Sue!"}]
    assert Gproc.messages_received(pid2) == [{:event1, :sue, "Hi Sue!"}]
    assert Gproc.messages_received(pid3) == [{:event1, :miranda, "Hi Miranda!"}]
  end
end
