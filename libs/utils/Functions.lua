local class = require('class')
local Cache = require('utils/Cache')
local Functions = class('Functions', Cache)

function Functions:__init()
  Cache.__init(self)
end

function Functions:exec(commandName, ...)
  local func = self:get(commandName)
  if not func then return nil end
  local getData = func(...)
  return getData
end

return Functions