local AnimationConfig = require(script.Parent.AnimationConfig)
local util = require(script.Parent.util)
local helpers = require(script.Parent.helpers)

local Animation = {}
Animation.__index = Animation

type animationType = number | UDim | UDim2 | Vector2 | Vector3 | Color3

function Animation.new(props)
    if props.to and props.from then
        assert(typeof(props.to) == typeof(props.from), "`to` and `from` must be the same type")
    end
    local length = #helpers.getValuesFromType(props.from or props.to)

	return setmetatable({
        values = helpers.getValuesFromType(props.from or props.to),
        toValues = helpers.getValuesFromType(props.to or props.from),
        fromValues = helpers.getValuesFromType(props.from or props.to),
        type = typeof(props.from or props.to),
        config = AnimationConfig:mergeConfig(props.config or {}),
        immediate = props.immediate,

        v0 = table.create(length, nil),
        lastPosition = helpers.getValuesFromType(props.from or props.to),
        lastVelocity = table.create(length, nil),
        done = table.create(length, false),
        elapsedTime = table.create(length, 0),
        durationProgress = table.create(length, 0),
	}, Animation)
end

-- Set the current value. Returns `true` if the value changed
function Animation:setValue(index: number, value)
    self.lastPosition[index] = value
    if self.values[index] == value then
        return false
    end
    self.values[index] = value
    return true
end

function Animation:setProps(props)
    if props then
        self.toValues = if props.to then helpers.getValuesFromType(props.to) else self.toValues
        self.lastPosition = if props.from then helpers.getValuesFromType(props.from) else self.lastPosition
        self.fromValues = if props.from then helpers.getValuesFromType(props.from) else util.copy(self.lastPosition)
        self.config = AnimationConfig:mergeConfig(props.config or {})
        self.immediate = if props.immediate ~= nil then props.immediate else self.immediate

        self.done = table.create(#self.values, false)
        self.elapsedTime = table.create(#self.values, 0)
        self.durationProgress = table.create(#self.values, 0)
    end
end

function Animation:getValue()
    return helpers.getTypeFromValues(self.type, self.values)
end

function Animation:stop()
    for i, v in ipairs(self.values) do
        self.lastPosition[i] = v
        self.lastVelocity[i] = nil
        self.v0[i] = nil
        self.elapsedTime = table.create(#self.values, 0)
        self.durationProgress = table.create(#self.values, 0)
    end
end

return Animation
