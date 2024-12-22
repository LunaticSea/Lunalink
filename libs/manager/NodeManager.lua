local Cache = require('utils/Cache')
local Node = require('node/Node')

local class = require('class')
local ConnectState = require('enums').ConnectState
local Events = require('const').Events

local NodeManager, get = class('NodeManager', Cache)

function NodeManager:init(lunalink)
  Cache.init(self)
  self._lunalink = lunalink
end

function get:lunalink()
  return self._lunalink
end

function NodeManager:add(node)
  local new_node = Node(self._lunalink, node)
	new_node:connect()
	self:set(node.name, new_node)
	self:debug('Node $s added to manager!', node.name)
end

function NodeManager:getLeastUsed(custom_node_array)
	local nodes = custom_node_array and  custom_node_array or self:values()
	local custom_resolver = self._lunalink._options.config.nodeResolver

	if custom_resolver then
		local resolver_data = custom_resolver(nodes)
		if resolver_data then return resolver_data end
	end

	local online_nodes = self:_filter(nodes, function (node)
		return node.state == ConnectState.Connected
	end)

	assert(#online_nodes ~= 0, 'No nodes are online')

	local temp = self:_map(online_nodes, function (node)
		local stats = node.rest:getStatus()
		return not stats and { players = 0, node = node } or { players = stats.players, node = node }
	end)

	table.sort(temp, function (a, b) return a.players - b.players end)

	return temp[1].node
end

function NodeManager:all()
	return self:values()
end

function NodeManager:remove(name)
	local node = self:get(name)
	if node then
		node:disconnect()
		self:delete(name)
		self:debug('Node %s removed from manager!', node)
	end
	return self:values()
end

function NodeManager:_filter(t, func)
	local out = {}
	for k, v in pairs(t) do
		if func(v, k, t) then
			table.insert(out, v)
		end
	end
	return out
end

function NodeManager:_map(tbl, func)
	local result = {}
	for i, v in ipairs(tbl) do
			result[i] = func(v, i, tbl)  -- Apply the function to each element
	end
	return result
end

function NodeManager:debug(logs, ...)
	local pre_res = string.format(logs, ...)
	local res = string.format('[Lunalink] / [NodeManager] | %s', pre_res)
	self._lunalink:emit(Events.Debug, res)
end

return NodeManager