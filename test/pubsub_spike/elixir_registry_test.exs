defmodule PubsubSpike.ElixirRegistryTest do
  use ExUnit.Case

  alias PubsubSpike.ElixirRegistry

  test "broadcast messages" do
    {:ok, pid1} = ElixirRegistry.start_link("miranda")
    {:ok, pid2} = ElixirRegistry.start_link("miranda")
    {:ok, pid3} = ElixirRegistry.start_link("ariel")

    ElixirRegistry.broadcast("miranda", "Hello Miranda!")
    ElixirRegistry.broadcast("ariel", "Hello Ariel!")

    assert ElixirRegistry.messages_received(pid1) == ["Hello Miranda!"]
    assert ElixirRegistry.messages_received(pid2) == ["Hello Miranda!"]
    assert ElixirRegistry.messages_received(pid3) == ["Hello Ariel!"]
  end

end
