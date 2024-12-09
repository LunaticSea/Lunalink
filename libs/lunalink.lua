--[=[
@c Lunalink
@d The heart of Rainlink. Manage all package action
]=]

local class = require('class')
local manifest = require('manifest')
local merge_default = require('utils/merge_default')

local lunalink, get = class('Lunalink')

function lunalink:init(options)
  self._manifest = manifest
  self._lunalink_options = merge_default(options, self.default_options)
end

function get:manifest()
  return self._manifest
end

function get:lunalink_options()
  return self._lunalink_options
end

function lunalink:create(options)
	
end

function lunalink:destroy(guild_id)

end

function lunalink:search(query, options)

end

function get:default_options()
  local user_agent = 'Discord/Bot/%s/%s (%s)'
  return {
		additionalDriver = {},
		retryTimeout = 3000,
		retryCount = 15,
		voiceConnectionTimeout = 15000,
		defaultSearchEngine = 'youtube',
		defaultVolume = 100,
		searchFallback = {
			enable = true,
			engine = 'soundcloud',
		},
		resume = false,
		userAgent = string.format(user_agent, manifest.name, manifest.version, manifest.github),
		nodeResolver = nil,
		structures = {
			player = nil,
			rest = nil,
			queue = nil,
			filter = nil,
		},
		resumeTimeout = 300,
	}
end

return lunalink
