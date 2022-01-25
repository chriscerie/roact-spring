local RunService = game:GetService("RunService")

local Promise = require(script.Parent.Parent.Promise)
local Signal = require(script.Parent.Signal)
local Animation = require(script.Parent.Animation)

local SpringValue = {}
SpringValue.__index = SpringValue

export type SpringConfig = {
    from: number,
    to: number,
    onChange: (position: number) -> ()?,

    immediate: boolean?,
    mass: number?,
    tension: number?,
    friction: number?,
    clamp: boolean?,
    precision: number?,
    velocity: number?,
    bounce: number?,
    restVelocity: number?,
}

--[=[
    @class SpringValue

    Spring values. Generally, you should use the `useSpring` hook instead.
]=]
function SpringValue.new(config: SpringConfig)
    assert(config.from, "Spring.new: from is required")
    assert(config.to, "Spring.new: to is required")

	return setmetatable({
        animation = Animation.new(config),
        onChange = config.onChange or function() end,

        -- Events
        onComplete = Signal.new(),
	}, SpringValue)
end

function SpringValue:start(config)
    return Promise.new(function(resolve)
        local anim = self.animation
        anim:setConfig(config)

        self.onChange = config.onChange or self.onChange

        if not self._connection then
            self._connection = RunService.RenderStepped:Connect(function(dt)
                self:advance(dt)
            end)
        end

        self.onComplete:Wait()
        resolve()
    end)
end

function SpringValue:stop()
    if self._connection then
        self._connection:Disconnect()
        self._connection = nil
    end

    self.onComplete:Fire()
end

function SpringValue:advance(dt: number)
    local idle = true
    local changed = false

    local anim = self.animation
    local config = anim.config
    local toValues = anim.toValues

    for i, node in ipairs(anim.values) do
        if anim.done[i] then
            continue
        end

        local finished = config.immediate
        local position = toValues[i]
        local from = anim.fromValues[i]
        local to = anim.toValues[i]

        if not finished then
            position = anim.lastPosition[i]

            -- Loose springs never move
            if config.tension <= 0 then
                anim.done[i] = true
                continue
            end
    
            local _v0 = anim.v0[i]
            local velocity
    
            -- Duration easing
            if config.duration then

            else
                -- Spring easing
                velocity = anim.lastVelocity[i] or _v0

                local precision = config.precision or (if from == to then 0.005 else math.min(1, math.abs(to - from) * 0.001))
                
                -- The velocity at which movement is essentially none
                local restVelocity = config.restVelocity or precision / 10
    
                -- Bouncing is opt-in (not to be confused with overshooting)
                local bounceFactor = if config.clamp then 0 else config.bounce
                local canBounce = bounceFactor ~= nil
    
                -- When `true`, the value is increasing over time
                local isGrowing = if from == to then _v0 > 0 else from < to
                
                local step = 1 -- 1ms
                local numSteps = math.ceil(dt / step) * 10
                for n = 0, numSteps do
                    local isMoving = math.abs(velocity) > restVelocity
    
                    if not isMoving then
                        finished = math.abs(to - position) <= precision
                        if finished then
                            break
                        end
                    end
    
                    if canBounce then
                        local isBouncing = position == to or position > to == isGrowing
    
                        -- Invert the velocity with a magnitude, or clamp it
                        if isBouncing then
                            velocity = -velocity * bounceFactor
                            position = to
                        end
                    end

                    local springForce = -config.tension * 0.000001 * (position - to)
                    local dampingForce = -config.friction * 0.001 * velocity
                    local acceleration = (springForce + dampingForce) / config.mass -- pt/ms^2
    
                    velocity = velocity + acceleration * step -- pt/ms
                    position = position + velocity * step
                end
            end
    
            anim.lastVelocity[i] = velocity
        end

        if finished then
            anim.done[i] = true
        else
            idle = false
        end

        if anim:setValue(i, position) then
            changed = true
        end
    end

    if idle then
        self.onChange(anim:getValue())
        self:stop()
    elseif changed then
        self.onChange(anim:getValue())
    end
end

return SpringValue