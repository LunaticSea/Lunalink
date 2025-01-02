WebSocket class uses an event emitter class to broadcast various named events.
This is a list of all WebSocket class events and their arguments.

# Event Emitters
The WebSocket class extends the Emitter class. This makes it acceptable to subscribe callbacks or listeners to client events. 
The callbacks are fired when the events are emitted. 
All of the events listed here are called by the WebSocket class and should not be manually emitted by the user.

For example, a listener can be subscribed to the nodeConnect event:

```lua
local ws = lunalink.WebSocket()

ws:on('open', function()
	print('WebSocket connected')
end)
```

This event would print 'WebSocket connected' when ws client connected to ws server

# All events

## open
Emitted after ws client is open to it's ws server
- `ws` - [[WebSocket]]

## close
Emitted after ws client is closed to it's ws server
- `code` - The websocket close code (number)
- `reason` - The websocket close reason (string)

## message
Emitted when ws server send message to ws client
- `message` - Same interface with [read function](https://bilal2453.github.io/coro-docs/docs/coro-websocket.html#read) but extend with `message.json_payload`

## error
Emitted when have error with ws server
- `error` - String error
