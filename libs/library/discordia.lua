local AbstractLibrary = require('AbstractLibrary')

local class = require('class')

local Discordia, get = class('Discordia', AbstractLibrary)

function Discordia:__init(client)
  AbstractLibrary.__init(self, client)
  self._client = client
end

function get:id()
  return self._client.user.id
end

function get:shardCount()
  return self._client.totalShardCount or 1
end

function Discordia:sendPacket(shardId, OP_CODE, payload)
  self._client._shards[shardId]:_send(OP_CODE, payload)
end

function Discordia:listen()
  self._client:once('ready', function () return self:_ready() end)
  self._client:on('raw', function (packet) self:_raw(packet) end)
end

return Discordia