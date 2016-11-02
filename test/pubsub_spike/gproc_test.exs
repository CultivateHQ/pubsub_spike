defmodule PubsubSpike.GprocTest do
  use ExUnit.Case

  alias PubsubSpike.Gproc

  test "broadcast messages" do
    {:ok, pid1} = Gproc.start_link("sue")
    {:ok, pid2} = Gproc.start_link("sue")
    {:ok, pid3} = Gproc.start_link(:miranda)

    Gproc.broadcast("sue", "Hi Sue!")
    Gproc.broadcast(:miranda, "Hi Miranda!")

    assert Gproc.messages_received(pid1) == ["Hi Sue!"]
    assert Gproc.messages_received(pid2) == ["Hi Sue!"]
    assert Gproc.messages_received(pid3) == ["Hi Miranda!"]
  end
end
