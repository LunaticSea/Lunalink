local class = require('class')
local setTimeout = require('timer').setTimeout
local Events = require('const').Events
local enums = require('enums')

local ConnectState = enums.ConnectState
local LavalinkEventsEnum = enums.LavalinkEventsEnum

local Rest = require('node/Rest')
local PlayerEvents = require('node/PlayerEvents')
local LavalinkFour = require('drivers/LavalinkFour')

local Node, get = class('Node')

function Node:__init(lunalink, options)
  self._lunalink = lunalink
  self._options = options

  local get_driver =  self:_filter(self._lunalink._drivers, function (driver)
    return driver.__getters:id() == options.driver
  end)

  if not get_driver or #get_driver == 0 or not options.driver then
    self:debug('No driver was found, using lavalink v4 driver instead')
    self._driver = LavalinkFour(lunalink, self)
  else
    self:debug("Now using driver = %s", get_driver[1].__getters:id())
    self._driver = get_driver[1](lunalink, self)
  end

  self._wsEvent = PlayerEvents(lunalink)

  self._stats = {
    players = 0,
    playingPlayers = 0,
    uptime = 0,
    memory = {
      free = 0,
      used = 0,
      allocated = 0,
      reservable = 0,
    },
    cpu = {
      cores = 0,
      systemLoad = 0,
      lavalinkLoad = 0,
    },
    frameStats = {
      sent = 0,
      nulled = 0,
      deficit = 0,
    },
  }
end

function get:lunalink()
  return self._lunalink
end

function get:options()
  return self._options
end

function get:rest()
  return self._rest
end

function get:online()
  return self._online
end

function get:state()
  return self._state
end

function get:stats()
  return self._stats
end

function get:driver()
  return self._driver
end

function Node:connect()
  self._driver:connect()
  return self._driver
end

function Node:wsOpenEvent()
  self:clean(true)
  self._state = ConnectState.Connected
  self:debug('Node connected! URL: %s', self._driver._wsUrl)
  self._lunalink:emit(Events.NodeConnect, self)
end

function Node:wsMessageEvent(data)
  if data.op == LavalinkEventsEnum.Ready then
    local is_resume = self._lunalink._options.config.resume
    local timeout = self._lunalink._options.config.resumeTimeout
    self._driver.sessionId = data.sessionId

    if is_resume and timeout then
      self._driver:updateSession(data.sessionId, is_resume, timeout)
    end

    local custom_rest =
      (self._lunalink._options.config.structures and
      self._lunalink._options.config.structures.rest)

    self._rest = custom_rest
      and self._lunalink.options.config.structures.rest(self._lunalink, self._options, self)
      or Rest(self._lunalink, self._options, self)

    return
  end

  if data.op == LavalinkEventsEnum.Event then
    self._wsEvent:initial(data)
    return
  end

  if data.op == LavalinkEventsEnum.PlayerUpdate then
    self._wsEvent:initial(data)
    return
  end

  if data.op == LavalinkEventsEnum.Status then
    self._stats = self:_updateStatusData(data)
    return
  end
end

function Node:wsCloseEvent(code, reason)
  self._online = false
  self._state = ConnectState.Disconnected
  self:debug('Node disconnected! URL: %s', self._driver._wsUrl)
  self._lunalink:emit(Events.NodeDisconnect, self, code, reason)
  if (
    not self._sudoDisconnect and
    self._retryCounter ~= self._lunalink._options.config.retryCount
  ) then
    setTimeout(self._lunalink._options.config.retryTimeout)
    self.retryCounter = self.retryCounter + 1
    self.reconnect(true)
    return
  end
  self:nodeClosed()
end

function Node:_nodeClosed()
  self._lunalink:emit(Events.NodeClosed, self)
  self:debug('Node closed! URL: %s', self._driver._wsUrl)
  self:clean()
end

function Node:_updateStatusData(data)
  return {
    players = data.players or self._stats.players,
    playingPlayers = data.playingPlayers or self._stats.playingPlayers,
    uptime = data.uptime or self._stats.uptime,
    memory = data.memory or self._stats.memory,
    cpu = data.cpu or self._stats.cpu,
    frameStats = data.frameStats or self._stats.frameStats,
  }
end

function Node:disconnect()
  self._sudoDisconnect = true
  self._driver:wsClose()
end

function Node:reconnect(noClean)
  if not noClean then self:clean() end
  self:debug("Node is trying to reconnect! URL = %s", self._driver._wsUrl)
  self._lunalink:emit(Events.NodeReconnect, self)
  self.driver:connect()
end

function Node:clean(online)
  self._sudoDisconnect = false
  self._retryCounter = 0
  self._online = online
  self._state = ConnectState.Closed
end

function Node:_filter(t, func)
	local out = {}
	for k, v in pairs(t) do
		if func(v, k, t) then
			table.insert(out, v)
		end
	end
	return out
end

function Node:debug(logs, ...)
	local pre_res = string.format(logs, ...)
	local res = string.format('[Lunalink] / [Node @ %s] | %s', self._options.name, pre_res)
	self._lunalink:emit(Events.Debug, res)
end

return Node