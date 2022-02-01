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

local function getTypeFromValues(type: string, values: { number })
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

function Animation.new(props)
    assert(typeof(props.to) == typeof(props.from), "`to` and `from` must be the same type")
    local length = #getValuesFromType(props.from)

	return setmetatable({
        values = getValuesFromType(props.from),
        toValues = getValuesFromType(props.to),
        fromValues = getValuesFromType(props.from),
        type = typeof(props.to),
        config = AnimationConfig:mergeConfig(props.config or {}),
        immediate = props.immediate,

        v0 = table.create(length, nil),
        lastPosition = table.create(length, 0),
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
        self.toValues = if props.to then getValuesFromType(props.to) else self.toValues
        self.fromValues = if props.from then getValuesFromType(props.from) else self.fromValues
        self.lastPosition = if props.from then getValuesFromType(props.from) else self.lastPosition
        self.config = AnimationConfig:mergeConfig(props.config or {})
        self.immediate = if props.immediate ~= nil then props.immediate else self.immediate

        self.done = table.create(#self.values, false)
        self.elapsedTime = table.create(#self.values, 0)
        self.durationProgress = table.create(#self.values, 0)
    end
end

function Animation:getValue()
    return getTypeFromValues(self.type, self.values)
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