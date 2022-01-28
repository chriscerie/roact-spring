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
        onComplete = Signal.new(),

        _memoizedDuration = 0,
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
    end):catch(function(err)
        self:stop()
        error(err)
    end)
end

function SpringValue:stop()
    if self._connection then
        self._connection:Disconnect()
        self._connection = nil
    end

    self.animation:stop()
    self.onComplete:Fire()
end

function SpringValue:pause()
    if self._connection then
        self._connection:Disconnect()
        self._connection = nil
    end
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
    
            anim.elapsedTime[i] += dt
            local elapsed = anim.elapsedTime[i]
            local _v0 = anim.v0[i]
            local velocity
    
            if config.duration then
                -- Duration easing
                local p = 1

                if config.duration > 0 then
                    --[[
                    * Here we check if the duration has changed in the config
                    * and if so update the elapsed time to the percentage
                    * of completition so there is no jank in the animation
                    ]]
                    if self._memoizedDuration ~= config.duration then
                        -- Update the memoized version to the new duration
                        self._memoizedDuration = config.duration
            
                        -- If the value has started animating we need to update it
                        if anim.durationProgress[i] > 0 then
                            -- Set elapsed time to be the same percentage of progress as the previous duration
                            anim.elapsedTime[i] = config.duration * anim.durationProgress[i]
                            -- Add the delta so the below updates work as expected
                            anim.elapsedTime[i] += dt
                            elapsed = anim.elapsedTime[i]
                        end
                    end

                    -- Calculate the new progress
                    p = (config.progress or 0) + elapsed / self._memoizedDuration
                    -- p is clamped between 0-1
                    p = if p > 1 then 1 elseif p < 0 then 0 else p
                    -- Store our new progress
                    anim.durationProgress[i] = p
                end

                position = from + config.easing(p) * (to - from)
                velocity = (position - anim.lastPosition[i]) / dt

                finished = p == 1
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
            -- Set position to target value due to precision
            position = to
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
