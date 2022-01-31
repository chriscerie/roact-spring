local Roact = require(script.Parent.Parent.Roact)
local Promise = require(script.Parent.Parent.Promise)
local SpringValue = require(script.Parent.SpringValue)
local AnimationConfig = require(script.Parent.AnimationConfig)
local util = require(script.Parent.util)

local Spring = {}

export type SpringProps = { 
    [string]: any? 
} | {
    from: { [string]: any }?,
    to: { [string]: any }?,
    immediate: boolean?,
    config: AnimationConfig.SpringConfigs?,
}

function Spring.new(props: SpringProps)
    -- TODO: Merge all unrecognized props into `to`
    assert(Roact, "Roact not found. It must be placed in the same folder as roact-spring.")
    assert(typeof(props) == "table", "Props for `useSpring` is required.")

    local state = {
        bindings = {},
        controls = {},
        config = props.config or {},
    }

    for fromName, from in pairs(props.from) do
        local toValue = if props.to and props.to[fromName] then props.to[fromName] else from
        local style, setStyle = Roact.createBinding(from)

        state.bindings[fromName] = style
        state.controls[fromName] = {
            setValue = setStyle,
            springValue = SpringValue.new(
                util.merge(props, {
                    from = from,
                    to = toValue,
                })
            ),
        }
    end

    local api = {
        start = function(startProps: SpringProps?)
            if not startProps then
                return Promise.new(function(resolve)
                    resolve()
                end)
            end

            local config = if startProps.config then util.merge(state.config, startProps.config) else state.config
            local toValues = startProps.to or startProps
            local promises = {}

            for name, target in pairs(toValues) do
                local binding = state.bindings[name]
                local control = state.controls[name]
                local value = binding:getValue()

                table.insert(promises, control.springValue:start(util.merge(config, {
                    from = value,
                    to = target,
                    immediate = startProps.immediate,
                    onChange = function(newValue)
                        control.setValue(newValue)
                    end,
                })))
            end

            return Promise.all(promises)
        end,

        stop = function(keys: {string}?)
            if keys then
                for _, key in pairs(keys) do
                    if state.controls[key] then
                        state.controls[key].springValue:stop()                    
                    else
                        warn("Tried to stop animation at key `" .. key .. "`, but it doesn't exist.")
                    end
                end
            else
                for _, control in pairs(state.controls) do
                    control.springValue:stop()
                end
            end
        end,

        pause = function(keys: {string}?)
            if keys then
                for _, key in pairs(keys) do
                    if state.controls[key] then
                        state.controls[key].springValue:pause()                    
                    else
                        warn("Tried to pause animation at key `" .. key .. "`, but it doesn't exist.")
                    end
                end
            else
                for _, control in pairs(state.controls) do
                    control.springValue:pause()
                end
            end
        end,

        setProps = function(newProps)
            -- TODO: handle new default props
            if newProps then
                state.config = newProps.config or {}
            end
        end,
    }

    return state.bindings, api
end

return Spring