--[=[
    @class useSpring
    Turns values into animated-values.
]=]

local RunService = game:GetService("RunService")

local SpringValue = require(script.Parent.SpringValue)
local Promise = require(script.Parent.Parent.Promise)
local MergeTable = require(script.Parent.util.MergeTable)

type useSpringProps = {
    [string]: any,
}

--[=[
    @interface api
    @within useSpring
    .start () -> Promise
]=]

--[=[
    @within useSpring

    @param hooks Hook
    @param useSpringProps

    @return ({[string]: RoactBinding}, api)
]=]
local function useSpring(hooks, useSpringProps: useSpringProps)
    local styles: {
        value: {
            [string]: {
                value: any,
                _binding: any,
                _setValue: any,
            },
        },
    } = hooks.useValue({})

    if useSpringProps.config == nil then
        useSpringProps.config = {}
    end

    for k, v in pairs(useSpringProps.from) do
        local style, setStyle = hooks.useBinding(v)

        styles.value[k] = {
            value = style,
            _binding = style,
            _setValue = setStyle,
        }
    end

    local api = {
        start = function(startProps, config)
            config = if config then MergeTable(useSpringProps.config, config) else useSpringProps.config
            local promises = {}

            for name, target in pairs(startProps) do
                table.insert(promises, Promise.new(function(resolve)
                    local style = styles.value[name]
                    local value = style.value:getValue()

                    local getValueFromAlpha = function(alpha)
                        if typeof(value) == "number" then
                            return value + (target - value) * alpha
                        elseif value.Lerp then
                            return value:Lerp(target, alpha)
                        end
                        error("Cannot start animation for " .. name .. ". Value is not a number or lerpable.")
                    end

                    local spring = SpringValue.new(MergeTable(config, {
                        from = 0,
                        to = 1,
                        onChange = function(alpha)
                            style._setValue(getValueFromAlpha(alpha))
                        end,
                    }))

                    spring:start():andThen(function()
                        resolve()
                    end)
                end))
            end

            return Promise.all(promises)
        end,
    }

    return styles.value, api
end

return useSpring
