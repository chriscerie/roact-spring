--[=[
    @class useSpring
    Turns values into animated-values.
]=]

local RunService = game:GetService("RunService")

local Promise = require(script.Parent.Parent.Promise)
local SpringValue = require(script.Parent.SpringValue)
local Spring = require(script.Parent.Spring)
local merge = require(script.Parent.util.merge)

type UseSpringProps = Spring.SpringProps | () -> {
    from: { [string]: any },
    config: { [string]: any }?
}

--[=[
    @interface api
    @within useSpring
    .start () -> Promise
]=]

--[=[
    @within useSpring

    @param hooks Hook
    @param props UseSpringProps

    @return ({[string]: RoactBinding}, api)
]=]
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
        local binding, api = Spring.new(props)
        spring.value = {
            binding = binding,
            api = api,
        }
    end

    hooks.useEffect(function()
        if isImperative.value == false then
            spring.value.api.start(props)
        end
    end)

    if isImperative.value then
        return spring.value.binding, spring.value.api
    end

    return spring.value.binding
end

return useSpring
