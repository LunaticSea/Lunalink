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

enums.PluginType {
  Default = 'default',
  SourceResolver = 'sourceResolver',
}

enums.PlayerState {
  CONNECTED = 0,
  DISCONNECTED = 1,
  DESTROYED = 2,
}

enums.LoopMode {
  SONG = 'song',
  QUEUE = 'queue',
  NONE = 'none',
}

enums.ConnectState {
  Connected = 0,
  Disconnected = 1,
  Closed = 2,
}

enums.VoiceState {
  SESSION_READY = 0,
  SESSION_ID_MISSING = 1,
  SESSION_ENDPOINT_MISSING = 2,
  SESSION_FAILED_UPDATE = 3,
}

enums.VoiceConnectState {
  CONNECTING = 0,
  NEARLY = 1,
  CONNECTED = 2,
  RECONNECTING = 3,
  DISCONNECTING = 4,
  DISCONNECTED = 5,
}

enums.LavalinkLoadType {
  TRACK = 'track',
  PLAYLIST = 'playlist',
  SEARCH = 'search',
  EMPTY = 'empty',
  ERROR = 'error',
}

enums.OP {
	DISPATCH              = 0,
	HEARTBEAT             = 1,
	IDENTIFY              = 2,
	STATUS_UPDATE         = 3,
	VOICE_STATE_UPDATE    = 4,
	-- VOICE_SERVER_PING = 5 -- TODO
	RESUME                = 6,
	RECONNECT             = 7,
	REQUEST_GUILD_MEMBERS = 8,
	INVALID_SESSION       = 9,
	HELLO                 = 10,
	HEARTBEAT_ACK         = 11,
	GUILD_SYNC            = 12,
}

return enums