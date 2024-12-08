local lunalink = require('../libs/lunalink')
local manager = lunalink()

manager:create()

p(manager.manifest)

p(manager.default_options)
