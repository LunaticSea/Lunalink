local class = require('class')

local Rest, get = class('Rest')

local f = string.format

function Rest:__init(lunalink, options, node)
  self._lunalink = lunalink
  self._node = node
  self._options = options
  self._sessionId = self._node._driver._sessionId or ''
end

function get:node()
  return self._node
end

function get:lunalink()
  return self._lunalink
end

function Rest:getPlayers()
  local options = {
    path = f('/sessions/%s/players', self._sessionId),
    headers = { { 'content-type', 'application/json' } },
  }
  return self._node._driver:requester(options)
end

function Rest:getStatus()
  local options = {
    path = '/stats',
    headers = { { 'content-type', 'application/json' } },
  }
  return self._node._driver:requester(options)
end

function Rest:decodeTrack(encodedTrack)
  local options = {
    path = '/decodetrack',
    params = { encodedTrack = encodedTrack },
    headers = { { 'content-type', 'application/json' } },
  }
  return self._node._driver:requester(options)
end

function Rest:updatePlayer(data)
  local options = {
    path = f('/sessions/%s/players/%s', self._sessionId, data.guildId),
    params = { noReplace = data.noReplace or 'false' },
    headers = { { 'content-type', 'application/json' } },
    method = 'PATCH',
    data = data.playerOptions,
    rawReqData = data,
  }
  return self._node._driver:requester(options)
end

function Rest:destroyPlayer(guildId)
  local options = {
    path = f('/sessions/%s/players/%s', self._sessionId, guildId),
    headers = { { 'content-type', 'application/json' } },
    method = 'DELETE',
  }
  return self._node._driver:requester(options)
end

function Rest:resolver(data)
  local options = {
    path = 'loadtracks',
    params = { identifier = data },
    headers = { { 'content-type', 'application/json' } }
  }
  return self._node._driver:requester(options)
end

function Rest:getRoutePlannerStatus()
  local options = {
    path = '/routeplanner/status',
    headers = { { 'content-type', 'application/json' } },
  }
  return self._node._driver:requester(options)
end

function Rest:unmarkFailedAddress(address)
  local options = {
    path = '/routeplanner/free/address',
    headers = { { 'content-type', 'application/json' } },
    method = 'POST',
    data = { address },
  }
  return self._node._driver:requester(options)
end

function Rest:getInfo()
  local options = {
    path = '/info',
    headers = { { 'content-type', 'application/json' } },
  }
  return self._node._driver:requester(options)
end

return Rest