Users are highly encouraged to use values in this page for a better code quality.

```lua
local lunalink = require("lunalink")
local enums = lunalink.enums
```

Enumerations (enums) can be accessed like a regular Lua table, but they cannot be modified. This is completely optional, but it is generally easier to use and read enumerations than it is to use and read plain numbers. For example, given a text channel object, the following are logically equivalent:

```lua
if player.state == 0 then
  print("Player connected")
end

if channel.type == enums.PlayerState.CONNECTED then
  print("Player still connected")
end

print(enums.PlayerState.CONNECTED) -- 0
```

If necessary, custom enumerations can be written using the `enum` constructor:

```lua
local fruit = enums.enum({
  apple = 0,
  orange = 1,
  banana = 2,
  cherry = 3
})

print(enums.fruit.apple) -- 0
print(enums.fruit(2)) -- "banana"
```

# Lunalink Enumerations

These enums only use in Lunalink and cannot be used in another lavalink wrapper

## PluginType
|Name|Value|
|-|-|
|Default|default|
|SourceResolver|sourceResolver|

## PlayerState
|Name|Value|
|-|-|
|CONNECTED|0|
|DISCONNECTED|1|
|DESTROYED|2|

## ConnectState
|Name|Value|
|-|-|
|Connected|0|
|Disconnected|1|
|Closed|2|

## SearchResultType
|Name|Value|
|-|-|
|TRACK|TRACK|
|PLAYLIST|PLAYLIST|
|SEARCH|SEARCH|

# Lavalink Enumerations

These enums avaliable in lavalink v4 version. They are not necessarily unique to Lunalink.

## LavalinkLoadType
|Name|Value|
|-|-|
|TRACK|track|
|PLAYLIST|playlist|
|SEARCH|search|
|EMPTY|empty|
|ERROR|error|

## LavalinkEventsEnum
|Name|Value|
|-|-|
|Ready|ready|
|Status|stats|
|Event|search|
|PlayerUpdate|event|
|ERROR|playerUpdate|

## LavalinkPlayerEventsEnum
|Name|Value|
|-|-|
|TrackStartEvent|TrackStartEvent|
|TrackEndEvent|TrackEndEvent|
|TrackExceptionEvent|TrackExceptionEvent|
|TrackStuckEvent|TrackStuckEvent|
|WebSocketClosedEvent|WebSocketClosedEvent|

# Discord Enumerations

The enumerations are designed to be compatible with the Discord API. They are not necessarily unique to Lunalink.

## VoiceState
|Name|Value|
|-|-|
|SESSION_READY|0|
|SESSION_ID_MISSING|1|
|SESSION_ENDPOINT_MISSING|2|
|SESSION_FAILED_UPDATE|3|

## VoiceConnectState
|Name|Value|
|-|-|
|CONNECTING|0|
|NEARLY|1|
|CONNECTED|2|
|RECONNECTING|3|
|DISCONNECTING|4|
|DISCONNECTED|5|