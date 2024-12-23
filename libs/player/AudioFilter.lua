local class = require('class')
local json = require('json')
local FilterData = require('const').FilterData
local Events = require('const').Events
local PlayerState = require('enums').PlayerState

local AudioFilter, get = class('AudioFilter')

function AudioFilter:init(player)
  self._current = nil
  self._player = player
end

function get:current()
  return self._current
end

function AudioFilter:set(filter)
  self:_checkDestroyed()

  local filter_data = FilterData[filter]

  if not filter_data then
    self:debug("Filter %s not avaliable in Rainlink's filter prebuilt", filter)
    return self._player
  end

  self._player:send({
    guildId = self._player._guildId,
    playerOptions = { filters = filter_data }
  })

  self._current = filter_data

  local log_debug = { '%s filter has been successfully set.', filter }
  if filter == 'clear' then
    log_debug = { 'All filters have been successfully reset to their default positions.', nil }
  end

  self.debug(table.unpack(log_debug))

  return self._player
end

function AudioFilter:clear()
  self:_checkDestroyed()

  self._player:send({
    guildId = self._player._guildId,
    playerOptions = { filters = {} }
  })

  self._current = nil

  self.debug('All filters have been successfully reset to their default positions.')

  return self._player
end

function AudioFilter:setVolume(volume)
  return self:setRaw({ volume = volume })
end

function AudioFilter:setEqualizer(equalizer)
  return self:setRaw({ equalizer = equalizer })
end

function AudioFilter:setKaraoke(karaoke)
  return self:setRaw({ karaoke = karaoke or nil })
end

function AudioFilter:setTimescale(timescale)
  return self:setRaw({ karaoke = timescale or nil })
end

function AudioFilter:setTremolo(tremolo)
  return self:setRaw({ tremolo = tremolo or nil })
end

function AudioFilter:setVibrato(vibrato)
  return self:setRaw({ vibrato = vibrato or nil })
end

function AudioFilter:setRotation(vibrato)
  return self:setRaw({ vibrato = vibrato or nil })
end

function AudioFilter:setDistortion(distortion)
  return self:setRaw({ distortion = distortion or nil })
end

function AudioFilter:setChannelMix(channelMix)
  return self:setRaw({ channelMix = channelMix or nil })
end

function AudioFilter:setLowPass(lowPass)
  return self:setRaw({ lowPass = lowPass or nil })
end

function AudioFilter:setRaw(filter)
  self:_checkDestroyed()

  self._player:send({
    guildId = self._player._guildId,
    playerOptions = {
      filters = filter
    }
  })

  self._current = filter

  self.debug('Custom filter has been successfully set. Data: %s', json.encode(filter))

  return self._player
end

function AudioFilter:_checkDestroyed()
  assert(self._player._state ~= PlayerState.DESTROYED, 'Player is destroyed')
end

function AudioFilter:debug(logs, ...)
	local pre_res = string.format(logs, ...)
	local res = string.format(
    '[Lunalink] / [Player @ %s] / [Filter] | %s',
    self._player._guildId,
    pre_res
  )
	self._player._lunalink:emit(Events.Debug, res)
end

return AudioFilter