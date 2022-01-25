local Promise = require(script.Parent.Parent.Promise)
local Signal = require(script.Parent.Signal)
local AnimationConfig = require(script.Parent.AnimationConfig)

local Animation = {}
Animation.__index = Animation

type animationType = number | UDim | UDim2 | Vector2 | Vector3 | Color3

local function getValuesFromType(data)
    local dataType = typeof(data)

    if dataType == "number" then
        return { data }
    elseif dataType == "UDim" then
        return { data.Scale, data.Offset }
    elseif dataType == "UDim2" then
        return { data.X.Scale, data.X.Offset, data.Y.Scale, data.Y.Offset }
    elseif dataType == "Vector2" then
        return { data.X, data.Y }
    elseif dataType == "Vector3" then
        return { data.X, data.Y, data.Z }
    elseif dataType == "Color3" then
        return { data.R, data.G, data.B }
    end

    error("Unsupported type: " .. dataType)
end

local function getTypeFromValues(type: string, values: { [number]: number })
    if type == "number" then
        return values[1]
    elseif type == "UDim" then
        return UDim.new(values[1], values[2])
    elseif type == "UDim2" then
        return UDim2.new(values[1], values[2], values[3], values[4])
    elseif type == "Vector2" then
        return Vector2.new(values[1], values[2])
    elseif type == "Vector3" then
        return Vector3.new(values[1], values[2], values[3])
    elseif type == "Color3" then
        return Color3.fromRGB(values[1], values[2], values[3])
    end

    error("Unsupported type: " .. type)
end

type animationConfig = {
    to: animationType,
    from: animationType,
}

function Animation.new(config)
    assert(typeof(config.to) == typeof(config.from), "`to` and `from` must be the same type")

	return setmetatable({
        values = getValuesFromType(config.from),
        toValues = getValuesFromType(config.to),
        fromValues = getValuesFromType(config.from),
        type = typeof(config.to),
        config = AnimationConfig:applyDefaults(config),
        v0 = table.create(#getValuesFromType(config.from), 0),
        lastPosition = table.create(#getValuesFromType(config.from), 0),
        lastVelocity = table.create(#getValuesFromType(config.from), 0),
        done = table.create(#getValuesFromType(config.from), false),
	}, Animation)
end

-- Set the current value. Returns `true` if the value changed
function Animation:setValue(index, value)
    self.lastPosition[index] = value
    if self.values[index] == value then
        return false
    end
    self.values[index] = value
    return true
end

function Animation:setConfig(config)
    if config then
        self.toValues = if config.to then getValuesFromType(config.to) else self.toValues
        self.fromValues = if config.from then getValuesFromType(config.from) else self.fromValues
        self.lastPosition = if config.from then getValuesFromType(config.from) else self.lastPosition
        self.config = AnimationConfig:applyDefaults(config)
    end
end

function Animation:getValue()
    return getTypeFromValues(self.type, self.values)
end

return Animation