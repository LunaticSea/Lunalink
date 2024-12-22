local class = require('class')
local Events = require('const').Events

local AbstractDriver, get = class('AbstractDriver')

function AbstractDriver:init() end

function get:id()
  error('driver id missing')
end

function get:wsUrl()
  error('driver wsUrl missing')
end

function get:httpUrl()
  error('driver httpUrl missing')
end

function get:sessionId()
  error('driver sessionId missing')
end

function get:playerFunctions()
  error('driver playerFunctions missing')
end

function get:functions()
  error('driver functions missing')
end

function get:lunalink()
  error('driver lunalink missing')
end

function get:node()
  error('driver node missing')
end

function AbstractDriver:connect()
  error('driver function: connect missing')
end

function AbstractDriver:requester()
  error('driver function: requester missing')
end

function AbstractDriver:wsClose()
  error('driver function: wsClose missing')
end

function AbstractDriver:updateSession()
  error('driver function: updateSession missing')
end

function AbstractDriver:_includes(t, e)
  for _, value in pairs(t) do
		if value == e then
			return e
		end
	end
	return nil
end

function AbstractDriver:_urlencode(obj)
	return (string.gsub(tostring(obj), '%W', function (char)
    return string.format('%%%02X', string.byte(char))
  end))
end


function AbstractDriver:_urlparams(obj)
  local buf = { '' }
  for k, v in pairs(obj) do
    table.insert(buf, #buf == 1 and '?' or '&')
    table.insert(buf, self:_urlencode(k))
    table.insert(buf, '=')
    table.insert(buf, self:_urlencode(v))
  end
  return table.concat(buf)
end

function AbstractDriver:debug(logs, ...)
	local pre_res = string.format(logs, ...)
	local res = string.format('[Lunalink] / [Node @ %s] / [Driver] / [Lavalink4] | %s', self.node.options.name, pre_res)
	self._lunalink:emit(Events.Debug, res)
end

return AbstractDriver