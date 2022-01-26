--[=[
    @class useSpring
    Turns values into animated-values.
]=]

local RunService = game:GetService("RunService")

local SpringValue = require(script.Parent.SpringValue)
local Promise = require(script.Parent.Parent.Promise)
local merge = require(script.Parent.util.merge)

type useSpringProps = {
    [string]: any,
}

--[=[
    @interface api
    @within useSpring
    .start () -> Promise
]=]

local function initStyles(hooks, useSpringProps: useSpringProps)
    local styles = {
        bindings = {},
        controls = {},
    }

    for k, v in pairs(useSpringProps.from) do
        local style, setStyle = hooks.useBinding(v)
        styles.bindings[k] = style
        styles.controls[k] = {
            setValue = setStyle,
            springValue = SpringValue.new(
                merge(useSpringProps, {
                    from = v,
                    to = v,
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
    assert(typeof(useSpringProps) == "table", "Props for `useSpring` is required.")

    local styles: {
        bindings: { [string]: any },
        controls: {
            [string]: {
                setValue: () -> (),
                springValue: typeof(SpringValue.new({ from = 0, to = 0 })),
            }
        }
    } = hooks.useValue(initStyles(hooks, useSpringProps))

    useSpringProps.config = useSpringProps.config or {}

    local api = {
        start = function(startProps, config)
            if not startProps then
                return Promise.new()
            end

            config = if config then merge(useSpringProps.config, config) else useSpringProps.config
            local promises = {}

            for name, target in pairs(startProps) do
                table.insert(promises, Promise.new(function(resolve)
                    local binding = styles.value.bindings[name]
                    local control = styles.value.controls[name]
                    local value = binding:getValue()

                    control.springValue:start(merge(config, {
                        from = value,
                        to = target,
                        onChange = function(newValue)
                            control.setValue(newValue)
                        end
                    })):andThen(function()
                        resolve()
                    end)
                end))
            end

            return Promise.all(promises)
        end,
    }

    return styles.value.bindings, api
end

return useSpring
