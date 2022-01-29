--[=[
    @class useSpring
    Turns values into animated-values.
]=]

local RunService = game:GetService("RunService")

local Promise = require(script.Parent.Parent.Promise)
local SpringValue = require(script.Parent.SpringValue)
local Spring = require(script.Parent.Spring)
local merge = require(script.Parent.util.merge)

type UseSpringProps = {
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
    @param props UseSpringProps

    @return ({[string]: RoactBinding}, api)
]=]
local function useSpring(hooks, props: UseSpringProps)
    assert(typeof(props) == "table", "Props for `useSpring` is required.")

    local spring = hooks.useValue(nil)
    local isMounted = hooks.useValue(false)

    if spring.value == nil then
        local binding, api = Spring.new(props)
        spring.value = {
            binding = binding,
            api = api,
        }
    end

    hooks.useEffect(function()
        spring.value.api.setProps(props)
        
        if typeof(props.to) == "table" then
            spring.value.api.start(props.to)
        end
    end)

    if props.to then
        return spring.value.binding
    end

    return spring.value.binding, spring.value.api
end

return useSpring
