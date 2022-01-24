--[=[
    @class useSprings
    Creates multiple springs, each with its own config. Use it for static lists, etc.
]=]

local Promise = require(script.Parent.Parent.Promise)
local useSpring = require(script.Parent.useSpring)

local function useSprings(hooks, length: number, props: (index: number) -> ({[string]: any}))
    local springs: {
        value: {
            [number]: {
                style: any,
                api: any,
            }
        },
    } = hooks.useValue({})

    for i = 1, length do
        local style, api = useSpring(hooks, props(i))
        table.insert(springs.value, {
            style = style,
            api = api,
        })
    end

    local api = {
        start = function(startProps)
            local promises = {}

            for i = 1, length do
                table.insert(promises, Promise.new(function(resolve)
                    springs.value[i].api.start(startProps(i)):andThen(resolve)
                end))
            end

            return Promise.all(promises)
        end,
    }

    local styles = {}

    for k, v in pairs(springs.value) do
        styles[k] = v.style
    end

    return styles, api
end

return useSprings
