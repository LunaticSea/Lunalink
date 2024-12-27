local function enum(tbl)
	local call = {}
	for k, v in pairs(tbl) do
		if call[v] then
			return error(string.format('enum clash for %q and %q', k, call[v]))
		end
		call[v] = k
	end
	return setmetatable({}, {
		__call = function(_, k)
			if call[k] then
				return call[k]
			else
				return error('invalid enumeration: ' .. tostring(k))
			end
		end,
		__index = function(_, k)
			if tbl[k] then
				return tbl[k]
			else
				return error('invalid enumeration: ' .. tostring(k))
			end
		end,
		__pairs = function()
			return next, tbl
		end,
		__newindex = function()
			return error('cannot overwrite enumeration')
		end,
	})
end

local enums = {enum = enum}

--- @class Enums.PluginType
--- @field Default 'default' Default mode for plugin (no search engine registeration)
--- @field SourceResolver 'sourceResolver' Plugin for source resolving (require search engine)
--- <!tag:enums>
enums.PluginType {
  Default = 'default',
  SourceResolver = 'sourceResolver',
}

--- @class Enums.PlayerState
--- @field CONNECTED '0' Player is connected
--- @field DISCONNECTED '1' Player is disconnected
--- @field DESTROYED '2' Player is destroyed
--- <!tag:enums>
enums.PlayerState {
  CONNECTED = 0,
  DISCONNECTED = 1,
  DESTROYED = 2,
}

--- @class Enums.LoopMode
--- @field SONG 'song' Loop only 1 song
--- @field QUEUE 'queue' Loop full queue
--- @field NONE 'none' No loop
--- <!tag:enums>
enums.LoopMode {
  SONG = 'song',
  QUEUE = 'queue',
  NONE = 'none',
}

--- @class Enums.ConnectState
--- @field Connected '0' Node connected
--- @field Disconnected '1' Node disconnected
--- @field Closed '2' Node closed
--- <!tag:enums>
enums.ConnectState {
  Connected = 0,
  Disconnected = 1,
  Closed = 2,
}

--- @class Enums.VoiceState
--- @field SESSION_READY '0' Voice session ready
--- @field SESSION_ID_MISSING '1' Voice session id missing
--- @field SESSION_ENDPOINT_MISSING '2' Voice session endpoint missing
--- @field SESSION_FAILED_UPDATE '3' Voice session failed to update
--- <!tag:enums>
enums.VoiceState {
  SESSION_READY = 0,
  SESSION_ID_MISSING = 1,
  SESSION_ENDPOINT_MISSING = 2,
  SESSION_FAILED_UPDATE = 3,
}

--- @class Enums.VoiceConnectState
--- @field CONNECTING '0' Connecting to the voice
--- @field NEARLY '1' Waiting for voice response
--- @field CONNECTED '2' Voice connection established
--- @field RECONNECTING '3' Trying to reconnect the voice
--- @field DISCONNECTING '4' Trying to disconnect the voice
--- @field DISCONNECTED '5' Voice disconnected
--- <!tag:enums>
enums.VoiceConnectState {
  CONNECTING = 0,
  NEARLY = 1,
  CONNECTED = 2,
  RECONNECTING = 3,
  DISCONNECTING = 4,
  DISCONNECTED = 5,
}

--- @class Enums.LavalinkLoadType
--- @field TRACK 'track' Lavalink response is a track only
--- @field PLAYLIST 'playlist' Lavalink response is a full playlist
--- @field SEARCH 'search' Lavalink response is a search
--- @field EMPTY 'empty' No result
--- @field ERROR 'error' Error when trying to search
--- <!tag:enums>
enums.LavalinkLoadType {
  TRACK = 'track',
  PLAYLIST = 'playlist',
  SEARCH = 'search',
  EMPTY = 'empty',
  ERROR = 'error',
}

return enums