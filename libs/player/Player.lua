local class = require('class')
local Queue = require('player/Queue')
local Cache = require('utils/Cache')
local AudioFilter = require('player/AudioFilter')
local Functions = require('utils/Functions')
local enums = require('enums')
local LoopMode = enums.LoopMode
local PlayerState = enums.PlayerState

---A class for managing player action.
---@class Player
---<!tag:interface>
---@field lunalink Core Main manager class
---@field node Node Player's current using lavalink server
---@field guildId string Player's guild id
---@field voiceId 'string/nil' Player's voice id
---@field textId string Player's text id
---@field queue Queue Player's queue
---@field data Cache The temporary database of player, u can set any thing here and us like Map class!
---@field paused boolean Whether the player is paused or not
---@field position number Get the current track's position of the player
---@field volume number Get the current volume of the player
---@field playing boolean Whether the player is playing or not
---@field loop '[LoopMode](Enumerations.md#loopmode)' Get the current loop mode of the player
---@field state '[PlayerState](Enumerations.md#playerstate)' Get the current state of the player
---@field deaf boolean Whether the player is deafened or not
---@field mute boolean Whether the player is muted or not
---@field track string ID of the current track
---@field functions Functions All function to extend support driver
---@field shardId string ID of the Shard that contains the guild that contains the connected voice channel
---@field filter AudioFilter Filter class to set, clear get the current filter data
---@field voice Voice Voice handler class
-- @field _sudoDestroy Core Main manager class

local Player, get = class('Player')

---Initial function for Player class
---@param lunalink Core
---@param voice Voice
---@param node Node
function Player:__init(lunalink, voice, node)
  self._voice = voice
  self._lunalink = lunalink
  local lunalink_config = self._manager.options.config
  self._guildId = voice.guildId
  self._voiceId = voice.voiceId
  self._shardId = voice.shardId
  self._mute = voice.mute or false
  self._deaf = voice.deaf or false
  self._node = node
  self._guildId = voice.guildId
  self._voiceId = voice.voiceId
  self._textId = voice.options.textId
  local customQueue = lunalink_config.structures and lunalink_config.structures.queue
  self._queue = customQueue
    and lunalink_config.structures.queue(lunalink, self)
    or Queue(lunalink, self)
  self._data = Cache()
  if lunalink_config.structures and lunalink_config.structures.filter then
    self._filter = lunalink_config.structures.filter(self)
  else self._filter = AudioFilter(self) end
  self._volume = lunalink_config.defaultVolume
  self._loop = LoopMode.NONE
  self._state = PlayerState.DESTROYED
  self._deaf = voice.deaf or false
  self._mute = voice.mute or false
  self._functions = Functions()
  if (self._node.driver.playerFunctions.size ~= 0) then
    for _, value in pairs(self._node.driver.playerFunctions.full) do
      self._functions:set(value[1], value[2])
    end
  end
  if (voice.options.volume and voice.options.volume ~= self._volume) then
    self._volume = voice.options.volume
  end
end

function get:lunalink()
  return self._lunalink
end

function get:node()
  return self._node
end

function get:guildId()
  return self._guildId
end

function get:voiceId()
  return self._voiceId
end

function get:textId()
  return self._textId
end

function get:queue()
  return self._queue
end

function get:data()
  return self._data
end

function get:paused()
  return self._paused
end

function get:position()
  return self._position
end

function get:volume()
  return self._volume
end

function get:playing()
  return self._playing
end

function get:loop()
  return self._loop
end

function get:state()
  return self._state
end

function get:deaf()
  return self._deaf
end

function get:mute()
  return self._mute
end

function get:track()
  return self._track
end

function get:functions()
  return self._functions
end

function get:shardId()
  return self._shardId
end

function get:filter()
  return self._filter
end

function get:voice()
  return self._voice
end

return Player