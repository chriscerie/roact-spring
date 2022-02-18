local helpers = {}

function helpers.getValuesFromType(data)
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

function helpers.getTypeFromValues(type: string, values: { number })
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
        return Color3.new(values[1], values[2], values[3])
    end

    error("Unsupported type: " .. type)
end

return helpers
