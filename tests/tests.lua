-- local lunalink = require('libs.Lunalink')
-- local manager = lunalink()

-- manager:create()

-- p(manager.manifest)

-- p(manager.default_options)

local class = require('class')
local tc, get = class('tc')

function tc:__init() end

function get:id() return 'Hello world' end

local test = tc()

p(test.__name)

p(string.format('%s/%s', 'high', ''))