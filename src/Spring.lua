local Roact = require(script.Parent.Parent.Roact)
local Promise = require(script.Parent.Parent.Promise)
local SpringValue = require(script.Parent.SpringValue)
local AnimationConfig = require(script.Parent.AnimationConfig)
local util = require(script.Parent.util)
local constants = require(script.Parent.constants)

local Spring = {}

export type SpringProps = { 
    [string]: any? 
} | {
    from: { [string]: any }?,
    to: { [string]: any }?,
    immediate: boolean?,
    config: AnimationConfig.SpringConfigs?,
    [string]: any?,
}

-- Merge unrecognized props to the `to` table
local function prepareKeys(props: SpringProps)
    local newProps = {}

    for key, value in pairs(props) do
        if constants.propsList[key] ~= nil then
            newProps[key] = value
        else
            if newProps.to == nil then
                newProps.to = {}
            end
            newProps.to[key] = value
        end
    end

    return newProps
end

function Spring.new(props: SpringProps)
    -- TODO: Merge all unrecognized props into `to`
    assert(Roact, "Roact not found. It must be placed in the same folder as roact-spring.")
    assert(typeof(props) == "table", "Props for `useSpring` is required.")

    props = prepareKeys(props)

    local state = {
        bindings = {},
        controls = {},
    }

    for toName, to in pairs(props.to or props.from) do
        local from = if props.from and props.from[toName] then props.from[toName] else to
        local style, setStyle = Roact.createBinding(from)

        state.bindings[toName] = style
        state.controls[toName] = {
            setValue = setStyle,
            springValue = SpringValue.new(
                util.merge(props, {
                    from = from,
                    to = to,
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
            startProps = prepareKeys(startProps)

            local promises = {}
    
            for name, target in pairs(startProps.to or {}) do
                local binding = state.bindings[name]
                local control = state.controls[name]
                local value = binding:getValue()

                table.insert(promises, control.springValue:start({
                    from = value,
                    to = target,
                    immediate = startProps.immediate,
                    config = startProps.config,
                    onChange = function(newValue)
                        control.setValue(newValue)
                    end,
                }))
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
    }

    return state.bindings, api
end

return Spring
