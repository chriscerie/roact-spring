local useSprings = require(script.Parent.useSprings)

local function useSpring(hooks, props, deps: {any}?)
    local isFn = type(props) == "function"

    local styles, api = useSprings(
        hooks,
        1,
        if isFn then props else {props},
        if isFn then deps or {} else deps
    )

    return styles[1], api
end

return useSpring
