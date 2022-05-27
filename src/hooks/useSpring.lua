local useSprings = require(script.Parent.useSprings)
local SpringValue = require(script.Parent.Parent.SpringValue)

type Styles = { [string]: any}
type Api = { [string]: (any) -> any }

local function useSpring(hooks, props: SpringValue.SpringValueProps | (number) -> SpringValue.SpringValueProps, deps: { [number]: any }?): (Styles, Api)
    local isFn = type(props) == "function"

    local styles, api = useSprings(
        hooks,
        1,
        if isFn then props :: (number) -> SpringValue.SpringValueProps else {props :: SpringValue.SpringValueProps},
        if isFn then deps or {} else deps
    )

    return styles[1], api
end

return useSpring
