local constants = require(script.Parent.constants)
local merge = require(script.Parent.util.merge)

local AnimationConfig = {}

local defaults = table.freeze(merge(constants.config.default, {
    immediate = false,
    mass = 1,
    clamp = false,
    precision = 0.005,
    velocity = 0,
}))

function AnimationConfig:applyDefaults(config)
    return merge(defaults, config)
end

return AnimationConfig