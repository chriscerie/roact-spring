local RunService = game:GetService("RunService")

local Promise = require(script.Parent.Parent.Promise)
local Signal = require(script.Parent.Signal)

local SpringValue = {}
SpringValue.__index = SpringValue

export type SpringConfig = {
    from: number,
    to: number,
    onChange: (position: number) -> ()?,
    mass: number?,
    tension: number?,
    friction: number?,
    clamp: boolean?,
    precision: number?,
    velocity: number?,
    bounce: number?,
    restVelocity: number?,
}

local function applyConfigDefault(config)
    return {
        mass = config.mass or 1,
        tension = config.tension or 170,
        friction = config.friction or 26,
        clamp = config.clamp or false,
        precision = config.precision or 0.01,
        velocity = config.velocity or 0,
        bounce = config.bounce,
        restVelocity = config.restVelocity,
    }
end

--[=[
    @class SpringValue

    Spring values. Generally, you should use the `useSpring` hook instead of this class.
]=]
function SpringValue.new(config: SpringConfig)
    assert(config.from, "Spring.new: from is required")
    assert(config.to, "Spring.new: to is required")

	return setmetatable({
        from = config.from,
        to = config.to,
        onChange = config.onChange or function() end,
        _finished = false,
        _elapsedTime = 0,
        _immediate = false,
        _lastPosition = config.from,
        _config = applyConfigDefault(config),

        -- Events
        onComplete = Signal.new()
	}, SpringValue)
end

function SpringValue:start(config)
    return Promise.new(function(resolve)
        if config then
            self._config = applyConfigDefault(config)
            if config.to then
                self.to = config.to
            end
        end
    
        if self._connection then
            self._connection:Disconnect()
        end
    
        self._connection = RunService.Heartbeat:connect(function(dt)
            self:advance(dt)
        end)

        self.onComplete:Wait()
        resolve()
    end)
end

function SpringValue:stop()
    if self._connection then
        self._finished = true
        self._connection:Disconnect()
        self._connection = nil
    end

    self.onComplete:Fire()
end

function SpringValue:advance(dt: number)
    local config = self._config
    local to = self.to
    local position = self.to
    local from = self.from

    if not self._finished then
        position = self._lastPosition

        -- Loose springs never move
        if config.tension <= 0 then
            self._finished = true
            return
        end

        local elapsed = self._elapsedTime + dt

        local _v0 = if self.v0 ~= nil then self.v0 else config.velocity

        local velocity

        -- Duration easing
        if config.duration then
            
        else
            -- Spring easing
            velocity = if self._lastVelocity == nil then _v0 else self._lastVelocity
            
            -- The velocity at which movement is essentially none
            local restVelocity = config.restVelocity or config.precision / 10

            -- Bouncing is opt-in (not to be confused with overshooting)
            local bounceFactor = if config.clamp then 0 else config.bounce
            local canBounce = bounceFactor ~= nil

            -- When `true`, the value is increasing over time
            local isGrowing = if from == to then _v0 > 0 else to > from

            local isMoving: boolean
            local isBouncing = false
            
            local step = 1 -- 1ms
            local numSteps = math.ceil(dt / step)
            for n = 0, numSteps do
                isMoving = math.abs(velocity) > restVelocity

                if not isMoving then
                    self._finished = math.abs(to - position) <= config.precision
                    if self._finished then
                        break
                    end
                end

                if canBounce then
                    isBouncing = position == to or position > to == isGrowing

                    -- Invert the velocity with a magnitude, or clamp it
                    if isBouncing then
                        velocity = -velocity * bounceFactor
                        position = to
                    end
                end

                local springForce = -config.tension * 0.00001 * (position - to)
                local dampingForce = -config.friction * 0.001 * velocity
                local acceleration = (springForce + dampingForce) / config.mass -- pt/ms^2

                velocity = velocity + acceleration * step -- pt/ms
                position = position + velocity * step
            end

            self._lastVelocity = velocity

            if position ~= self._lastPosition then
                self._lastPosition = position
                self.onChange(position)
            end

            if self._finished then
                self:stop()
            end
        end
    end
end

return SpringValue