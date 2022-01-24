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

local function getValueFromAlpha(value, target, alpha)
    if typeof(value) == "number" then
        return value + (target - value) * alpha
    elseif value.Lerp then
        return value:Lerp(target, alpha)
    end
    error("Cannot start animation. Value is not a number or lerpable.")
end

local function initStyles(hooks, useSpringProps: useSpringProps)
    local styles = {}
    for k, v in pairs(useSpringProps.from) do
        local style, setStyle = hooks.useBinding(v)
        styles[k] = {
            value = style,
            _binding = style,
            _setValue = setStyle,
            _springValue = SpringValue.new(
                MergeTable(useSpringProps, {
                    from = 0,
                    to = 1,
                })
            ),
        }
    end
    return styles
end

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
                _springValue: any,
            },
        },
    } = hooks.useValue(initStyles(hooks, useSpringProps))

    if useSpringProps.config == nil then
        useSpringProps.config = {}
    end

    local api = {
        start = function(startProps, config)
            if not startProps then
                return Promise.new()
            end

            config = if config then MergeTable(useSpringProps.config, config) else useSpringProps.config
            local promises = {}

            for name, target in pairs(startProps) do
                table.insert(promises, Promise.new(function(resolve)
                    local style = styles.value[name]
                    local value = style.value:getValue()

                    style._springValue:start(MergeTable(config, {
                        from = 0,
                        to = 1,
                        onChange = function(position)
                            style._setValue(getValueFromAlpha(value, target, position))
                        end
                    })):andThen(function()
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
