local Roact = require(script.Parent.Parent.Roact)
local Promise = require(script.Parent.Parent.Promise)
local SpringValue = require(script.Parent.SpringValue)
local merge = require(script.Parent.util.merge)

local Spring = {}

local function processProps(props, currentState)
    local newState = currentState or {
        bindings = {},
        controls = {},
        config = props.config or {}
    }

    for fromName, from in pairs(props.from) do
        local toValue = if props.to and props.to[fromName] then props.to[fromName] else from

        if newState.bindings[fromName] then
            -- TODO: Update controls' springValues with new props
        else
            local style, setStyle = Roact.createBinding(from)

            newState.bindings[fromName] = style
            newState.controls[fromName] = {
                setValue = setStyle,
                springValue = SpringValue.new(
                    merge(props, {
                        from = from,
                        to = toValue,
                    })
                ),
            }
        end
    end

    return newState
end

function Spring.new(props)
    assert(Roact, "Roact not found. It is required to be placed on the same level as roact-spring.")
    assert(typeof(props) == "table", "Props for `useSpring` is required.")

    local state = processProps(props)

    local api = {
        start = function(startProps, config)
            if not startProps then
                return Promise.new(function(resolve)
                    resolve()
                end)
            end

            config = if config then merge(state.config, config) else state.config
            local promises = {}

            for name, target in pairs(startProps) do
                local binding = state.bindings[name]
                local control = state.controls[name]
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
            state = processProps(newProps, state)
        end,
    }

    return state.bindings, api
end

return Spring