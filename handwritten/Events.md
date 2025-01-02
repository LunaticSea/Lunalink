Lunalink uses an event emitter class to broadcast various named events, most of which originate from Lavalink's gateway via WebSocket payloads. 
This is a list of all Lunalink client events and their arguments.

# Event Emitters
The Client class extends the Emitter class. This makes it acceptable to subscribe callbacks or listeners to client events. 
The callbacks are fired when the events are emitted. 
All of the events listed here are called by the Lunalink library and should not be manually emitted by the user.

For example, a listener can be subscribed to the nodeConnect event:

```lua
local lunalink = lunalink.Core()

lunalink:on('nodeConnect', function()
	print('Node connected')
end)
```

This event would print 'Node connected' then a node is connected by lunalink

# Node Events

## nodeConnect
Emitted after a node is connected to it's voice server
- `node` - [[Node]]

## nodeDisconnect
Emitted after a node is disconnected to it's voice server
- `node` - [[Node]]
- `code` - Disconnect code number
- `reason` - Disconnect reason

## nodeClosed
Emitted after a node is closed after numberous of reconnect tries to it's voice server
- `node` - [[Node]]

## nodeReconnect
Emitted after a node is reconnected to it's voice server
- `node` - [[Node]]

# Player Events

## playerCreate
Emitted when a player is created.
- `player` - [[Player]]

## playerDestroy
Emitted when a player is going to destroyed.
- `player` - [[Player]]

## playerUpdate
Emitted when a player updated info.
- `player` - [[Player]]
- `data` - Updated data in table, see [lavalink doc](https://lavalink.dev/api/websocket.html#player-update-op)

## playerPause
Emitted when a track paused.
- `player` - [[Player]]
- `track` - [[Track]]

## playerResume
Emitted when a track resumed.
- `player` - [[Player]]
- `track` - [[Track]]

## playerException
Emitted when a player have an exception.
- `player` - [[Player]]
- `data` - Exception log data in table, see see [lavalink doc](https://lavalink.dev/api/websocket.html#exception-object)

## playerWebsocketClosed
Emitted when a player's websocket closed.
- `player` - [[Player]]
- `data` - Log data in table, see see [lavalink doc](https://lavalink.dev/api/websocket.html#websocketclosedevent)

## playerStop
Emitted when player stoped (not destroyed)
- `player` - [[Player]]

# Track Events

## trackStart
Emitted when a track is going to play.
- `player` - [[Player]]
- `track` - [[Track]]

## trackEnd
Emitted when a track is going to end.
- `player` - [[Player]]
- `track` - [[Track]]

## trackStuck
Emitted when a track stucked.
- `player` - [[Player]]
- `data` - Stuck log data in table, see see [lavalink doc](https://lavalink.dev/api/websocket.html#trackstuckevent)

## trackResolveError
Emitted when a track is failed to resolve using fallback search engine.
- `player` - [[Player]]
- `track` - [[Track]]
- `message` - Error message

# Queue Events

## queueAdd
Emitted when a track added into queue.
- `player` - [[Player]]
- `queue` - [[Queue]]
- `track` - A table of [[Track]]

## queueRemove
Emitted when a track removed from queue.
- `player` - [[Player]]
- `queue` - [[Queue]]
- `track` - [[Track]]

## queueShuffle
Emitted when a queue shuffled.
- `player` - [[Player]]
- `queue` - [[Queue]]

## queueClear
Emitted when a queue cleared.
- `player` - [[Player]]
- `queue` - [[Queue]]

## queueEmpty
Emitted when a queue is empty.
- `player` - [[Player]]
- `queue` - [[Queue]]