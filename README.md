# PubsubSpike

Investigating various ways of publishing and subscribing to events:

* Using [gproc](https://github.com/uwiger/gproc)
* Using [phoenix_pubsub](https://github.com/phoenixframework/phoenix_pubsub)
* Using Elixir 1.4's upcoming [Process registry](https://github.com/elixir-lang/registry)


Each version is implemented in its own module, under [lib/pubsub_spike](lib/pubsub_spike). The particular flavour may be deduced from the file/module name. There is a corresponding test in [test/pubusb_spike](test/pubsub_spike).

Each module is a GenServer implementation, and contains the following methods:

`start_link(topic)` - start GenServer that will listen to a particular "topic". Returns `{:ok, pid}`.

`broadcast(topic, message)` - broadcasts message to all in the topic. 

`messages_received(pid)` - returns all messages received by the listening GenServer.

See the corresponding test for usage.

## Distributed events with Phoenix Pubsub

For your convenience, a `PubsubSpike.PhoenixPubsub` worker is started by [the application](lib/pubsub_spike.ex). It is named `:phoenix_pubsub` and is listening on `"topic:phoenix_pubsub"`. You can experiment with broadcasting across connected nodes.

In this root directory (having cloned the repository, obvs.) open a terminal:

```
iex --sname mel@localhost -S mix
```

In another terminal, in the same directory:

```
iex --sname sue@localhost -S mix

Node.connect(:"mel@localhost") # -> true
PubsubSpike.PhoenixPubsub.broadcast("topic:phoenix_pubsub", "Hello distributed Mel and Sue!") # -> :ok
PubsubSpike.PhoenixPubsub.messages_received(:phoenix_pubsub) # -> ["Hello distributed Mel and Sue!"]
```

Switch to the original node, "mel@localhost"

```
PubsubSpike.PhoenixPubsub.messages_received(:phoenix_pubsub) # -> ["Hello distributed Mel and Sue!"]
```

\o/




