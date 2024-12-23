local class = require('class')
local json = require('json')
local const = require('const')
local Events = const.Events
local Queue, get = class('Queue')

function Queue:init(lunalink, player)
  self._list = {}
  self._previous = {}
  self._current = nil
  self._player = player
  self._lunalink = lunalink
end

function get:current()
  return self._current
end

function get:previous()
  return self._previous
end

function get:player()
  return self._player
end

function get:lunalink()
  return self._lunalink
end

function get:list()
  return self._list
end

function get:size()
  return #self._list
end

function get:totalSize()
  return #self._list + (self._current and 1 or 0)
end

function get:isEmpty()
  return #self._list == 0
end

function get:duration()
  return self:_reduce(self._list, function (acc, cur)
    return acc + (cur.duration or 0)
  end, 0)
end

function Queue:add(track)
  if type(track) == "table" then
    local full_check = self:_some(track, function (t)
      return t.__name ~= 'LunalinkTrack'
    end)
    assert(not full_check, 'Track must be an instance of LunalinkTrack')
  else
    assert(track.__name == 'LunalinkTrack', 'Track must be an instance of LunalinkTrack')
    track = { track }
  end

  if not self._current then
    if type(track) == "table" then
      self._current = self:_shift(track)
    else
      self._current = track
      return self
    end
  end

  if type(track) == "table" then
    for _, value in pairs(track) do
      table.insert(self._list, value)
    end
  else
    table.insert(self._list, track)
  end

  self._lunalink:emit(
    Events.QueueAdd,
    self._player,
    self,
    type(track) == "table" and track or { track }
  )

  return self
end

function Queue:shuffle()
  math.randomseed(os.time())
  for i = #self._list, 2, -1 do
    local j = math.random(i)
    self._list[i], self._list[j] = self._list[j], self._list[i]
  end
  self._lunalink:emit(Events.QueueShuffle, self._player, self)
  return self
end

function Queue:remove(position)
  if position < 1 or position >= #self._list then
    error('Position must be between 1 and ' .. #self._list)
  end
  table.remove(self._list, position)
  self._lunalink:emit(Events.QueueRemove, self._player, self)
  return self
end

function Queue:clear()
  self._list = {}
  self._lunalink:emit(Events.QueueClear, self._player, self)
  return self
end

function Queue:_reduce(tbl, func, initial)
	local accumulator = initial
	for _, value in ipairs(tbl) do
		accumulator = func(accumulator, value)
	end
	return accumulator
end

function Queue:_some(tbl, callback)
  for _, value in ipairs(tbl) do
    if callback(value) then
      return true
    end
  end
  return false
end

function Queue:_shift(tbl)
  local first = tbl[1]
  table.remove(tbl, 1)
  return first
end

return Queue