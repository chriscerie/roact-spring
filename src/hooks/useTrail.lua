local useSprings = require(script.Parent.useSprings)
local util = require(script.Parent.Parent.util)

local function useTrail(hooks, length: number, propsArg, deps: {any}?)
    local isFn = type(propsArg) == "function"

    local props = hooks.useMemo(function()
        if isFn then
            return propsArg
        end

        local newProps = table.create(length)
        local currentDelay = 0
        for i, v in ipairs(propsArg) do
            local prop = util.merge({ delay = 0.1 }, v)
            local delayAmount = prop.delay
            prop.delay = currentDelay
            currentDelay += delayAmount
            newProps[i] = prop
        end
        return newProps

        -- Need to pass {{}} because useMemo doesn't support nil dependency yet
    end, deps or {{}})

    -- TODO: Calculate delay for api methods as well
    local styles, api = useSprings(hooks, length, props, deps)

    local modifiedApi = hooks.useValue({})

    -- Return api with modified api.start
    if isFn then
        -- We can't just copy as we want to guarantee the returned api doesn't change its reference
        table.clear(modifiedApi.value)
        for key, value in pairs(api) do
            modifiedApi.value[key] = value
        end

        modifiedApi.value.start = function(startFn)
            local currentDelay = 0
            api.start(function(i)
                local startProps = util.merge({ delay = 0.1 }, startFn(i))
                local delayAmount = startProps.delay
                startProps.delay = currentDelay
                currentDelay += delayAmount
                return startProps
            end)
        end

        return styles, modifiedApi.value
    end

    return styles
end

return useTrail
