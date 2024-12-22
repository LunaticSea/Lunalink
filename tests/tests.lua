-- local lunalink = require('libs.Lunalink')
-- local manager = lunalink()

-- manager:create()

-- p(manager.manifest)

-- p(manager.default_options)

local class = require('class')
local tc, get = class('tc')

function tc:init() end

function get:id() return 'Hello world' end



p(tc.__getters:id())

p(string.format('%s/%s', 'high', ''))