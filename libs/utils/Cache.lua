local class = require('class')

local Cache = class('Cache')

function Cache:init()
  self._cache = {}
end

function Cache:set(key, value)
  self._cache[key] = value
  return value
end

function Cache:get(key)
  return self._cache[key]
end

function Cache:delete(key)
  self._cache[key] = nil
end

function Cache:clear()
  self._cache = {}
end

function Cache:size()
  local count = 0
  for _, _ in pairs(self._cache) do
    count = count + 1
  end
  return count
end

function Cache:for_each(callback)
  for key, value in pairs(self._cache) do
    callback(value, key)
  end
end

function Cache:values()
  local final_res = {}
  for _, value in pairs(self._cache) do
    table.insert(final_res, value)
  end
  return final_res
end

function Cache:full()
  local final_res = {}
  for key, value in pairs(self._cache) do
    table.insert(final_res, { key, value })
  end
  return final_res
end

return Cache