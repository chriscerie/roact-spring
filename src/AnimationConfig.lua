local constants = require(script.Parent.constants)
local util = require(script.Parent.util)

local AnimationConfig = {}

local defaults = table.freeze(util.merge(constants.config.default, {
    --immediate = false,
    mass = 1,
    clamp = false,
    precision = 0.005,
    velocity = 0,
    easing = constants.easings.linear,
}))

export type SpringConfigs = {
    --[[
        Higher mass means more friction is required to slow down.
        Defaults to 1, which works fine most of the time.
    ]]
    mass: number?,

    --[[
        With higher tension, the spring will resist bouncing and try harder to stop at its end value.
        When tension is zero, no animation occurs.
    ]]
    tension: number?,

    --[[
        The damping ratio coefficient.
        Higher friction means the spring will slow down faster.
    ]]
    friction: number?,

    --[[
        Avoid overshooting by ending abruptly at the goal value.
    ]]
    clamp: boolean?,

    --[[
        The smallest distance from a value before that distance is essentially zero.

        This helps in deciding when a spring is "at rest". The spring must be within
        this distance from its final value, and its velocity must be lower than this
        value too (unless `restVelocity` is defined).
    ]]
    precision: number?,

    --[[
        The initial velocity of one or more values.
    ]]
    velocity: number?,

    --[[
        The animation curve. Only used when `duration` is defined.
        TODO: Define default easing
    ]]
    easing: (t: number) -> number?,

    --[[
        Animation length in number of seconds.
    ]]
    duration: number?,

    --[[
        When above zero, the spring will bounce instead of overshooting when
        exceeding its goal value. Its velocity is multiplied by `-1 + bounce`
        whenever its current value equals or exceeds its goal. For example,
        setting `bounce` to `0.5` chops the velocity in half on each bounce,
        in addition to any friction.
    ]]
    bounce: number?,

    --[[
        The smallest velocity before the animation is considered "not moving".
        When undefined, `precision` is used instead.
    ]]
    restVelocity: number?,
}

function AnimationConfig:mergeConfig(config: any, newConfig: any?): SpringConfigs
    if newConfig then
        config = util.merge(config, newConfig)
    end

    for k, v in pairs(defaults) do
        if config[k] == nil then
            config[k] = v
        end
    end

    return config
end

return AnimationConfig
