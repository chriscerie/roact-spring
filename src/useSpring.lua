local RunService = game:GetService("RunService")

local Promise = require(script.Parent.Parent.Promise)
local SpringValue = require(script.Parent.SpringValue)
local Controller = require(script.Parent.Controller)
local merge = require(script.Parent.util.merge)

type UseSpringProps = Controller.SpringProps | () -> {
    from: { [string]: any },
    config: { [string]: any }?
}

local function useSpring(hooks, props: UseSpringProps)
    local isImperative = hooks.useValue(nil)
    local spring = hooks.useValue(nil)

    if typeof(props) == "table" then
        assert(isImperative.value == nil or isImperative.value == false, "useSpring detected a change from imperative to declarative. This is not supported.")
        isImperative.value = false
    elseif typeof(props) == "function" then
        assert(isImperative.value == nil or isImperative.value == true, "useSpring detected a change from declarative to imperative. This is not supported.")
        isImperative.value = true
        props = props()
    else
        error("Expected table or function for useSpring, got " .. typeof(props))
    end

    if spring.value == nil then
        local styles, api = Controller.new(props)
        spring.value = api
    end

    hooks.useEffect(function()
        if isImperative.value == false then
            spring.value:start(props)
        end
    end)

    if isImperative.value then
        local api = {}
        for key, value in pairs(getmetatable(spring.value)) do
            if typeof(value) == "function" and key ~= "new" then
                api[key] = function(...)
                    return value(spring.value, ...)
                end
            end
        end
        return spring.value.bindings, api
    end

    return spring.value.bindings
end

return useSpring
