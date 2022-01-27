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
    } = hooks.useValue(nil)

    if springs.value == nil then
        local values = {}
        for i = 1, length do
            local style, api = useSpring(hooks, props(i))
            table.insert(values, {
                style = style,
                api = api,
            })
        end
        springs.value = values
    end

    local api = {}
    for apiName in pairs(springs.value[1].api) do
        api[apiName] = function(apiProps: (index: number) -> any)
            local promises = {}

            for i = 1, length do
                table.insert(promises, Promise.new(function(resolve)
                    local result = springs.value[i].api[apiName](apiProps(i))

                    -- Some results might be promises
                    if result.await then
                        result:await()
                    end

                    resolve()
                end))
            end

            return Promise.all(promises)
        end
    end

    local styles = {}
    for k, v in pairs(springs.value) do
        styles[k] = v.style
    end

    return styles, api
end

return useSprings
