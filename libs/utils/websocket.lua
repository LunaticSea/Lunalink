local class = require('class')
local json = require('json')
local websocket = require('coro-websocket')
local Emitter = require('utils/Emitter')

--- Websocket headers interface
--- 

--- Options for modified of coro-websocket with event based
--- @class WebSocketOptions
--- @field url string The ws url
--- @field headers table A table of ws headers, example: `{'Foo', 'Bar'}`

--- Modified version of coro-websocket with event based
--- @class WebSocket: Emitter
--- <!tag:interface>
local ws = class('Websocket', Emitter)

--- @param options WebSocketOptions Options for modified websocket
function ws:__init(options)
	Emitter.__init(self)
	self._config = websocket.parseUrl(options.url)
	self._config.headers = options.headers
	self._url = options.url
	self._ws = websocket
  self._ws_read = nil
	self._ws_write = nil
	self._close_event_sent = false
end

function ws:connect()
	local res, ws_read, ws_write = self._ws.connect(self._config)

	if res and res.code == 101 then
		self._ws_write, self._ws_read = ws_write, ws_read
		coroutine.wrap(self._listen_msg)(self)
		self:emit('open',  self)
		return true
	else
		self:emit('close', 1006, 'Host not found')
	end
end

function ws:_listen_msg()
	for data in self._ws_read do
		if data.payload == '\003\233' then
			self:emit('close', 1006, 'Host disconnected')
		end
		local json_data = json.decode(data.payload)
		data.json_payload = json_data
		self:emit('message', data)
	end
	if not self._close_event_sent then
		self:emit('close', 1006, 'Host disconnected')
		self._close_event_sent = false
	end
end

function ws:close(code, reason)
	code = code or 1000
	reason = reason or 'Self closed'
	self._close_event_sent = true
	self._ws_write({
    opcode = 8,
    payload = '',
    len = 0,
    mask = false,
    fin = true,
    rsv1 = false,
    rsv2 = false,
    rsv3 = false
  })
	self:emit('close', code, reason)
	self._ws = websocket
  self._ws_read = nil
	self._ws_write = nil
end

function ws:send(payload)
	if type(payload) ~= "string" then
		payload = json.encode(payload)
	end

	self._ws_write({
    opcode = 1,
    payload = payload,
    len = string.len(payload),
    mask = false,
    fin = true,
    rsv1 = false,
    rsv2 = false,
    rsv3 = false
  })
	return true
end


function ws:cleanEvents()
	self:removeAllListeners('close')
	self:removeAllListeners('open')
	self:removeAllListeners('message')
end

return  ws