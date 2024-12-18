local lunalink = require('libs.Lunalink')
local manager = lunalink()

manager:create()

p(manager.manifest)

p(manager.default_options)
