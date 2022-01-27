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

    for fromName, from in pairs(useSpringProps.from) do
        local style, setStyle = hooks.useBinding(from)
        local toValue = if useSpringProps.to and useSpringProps.to[fromName] then useSpringProps.to[fromName] else from

        styles.bindings[fromName] = style
        styles.controls[fromName] = {
            setValue = setStyle,
            springValue = SpringValue.new(
                merge(useSpringProps, {
                    from = from,
                    to = toValue,
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
        value: {
            bindings: { [string]: any },
            controls: {
                [string]: {
                    setValue: () -> (),
                    springValue: typeof(SpringValue.new()),
                }
            }
        }
        
    } = hooks.useValue(initStyles(hooks, useSpringProps))

    useSpringProps.config = useSpringProps.config or {}

    local api = {
        start = function(startProps, config)
            if not startProps then
                return Promise.new(function(resolve)
                    resolve()
                end)
            end

            config = if config then merge(useSpringProps.config, config) else useSpringProps.config
            local promises = {}

            for name, target in pairs(startProps) do
                local binding = styles.value.bindings[name]
                local control = styles.value.controls[name]
                local value = binding:getValue()

                table.insert(promises, control.springValue:start(merge(config, {
                    from = value,
                    to = target,
                    onChange = function(newValue)
                        control.setValue(newValue)
                    end
                })))
            end

            return Promise.all(promises)
        end,

        stop = function(keys: {string}?)
            if keys then
                for _, key in pairs(keys) do
                    if styles.value.controls[key] then
                        styles.value.controls[key].springValue:stop()                    
                    else
                        warn("Tried to stop animation at key `" .. key .. "`, but it doesn't exist.")
                    end
                end
            else
                for _, control in pairs(styles.value.controls) do
                    control.springValue:stop()
                end
            end
        end,

        pause = function(keys: {string}?)
            if keys then
                for _, key in pairs(keys) do
                    if styles.value.controls[key] then
                        styles.value.controls[key].springValue:pause()                    
                    else
                        warn("Tried to pause animation at key `" .. key .. "`, but it doesn't exist.")
                    end
                end
            else
                for _, control in pairs(styles.value.controls) do
                    control.springValue:pause()
                end
            end
        end,
    }

    return styles.value.bindings, api
end

return useSpring
