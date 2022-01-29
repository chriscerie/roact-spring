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
                api: any?,
            }
        },
    } = hooks.useValue(nil)
    local stylesList = hooks.useValue(nil)
    local apiList = hooks.useValue(nil)

    if springs.value then
        assert(#springs.value == length, "Length of useSprings changed from " .. #springs.value .. " to " .. length .. ". This is not supported.")
    else
        springs.value = {}
    end

    for i = 1, length do
        local style, api = useSpring(hooks, props(i))
        springs.value[i] = {
            style = style,
            api = api,
        }
    end

    if stylesList.value == nil then
        stylesList.value = {}
        apiList.value = {}

        for springName, spring in pairs(springs.value) do
            stylesList.value[springName] = spring.style
        end

        if springs.value[1].api then
            for apiName in pairs(springs.value[1].api) do
                apiList.value[apiName] = function(apiProps: (index: number) -> any)
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
        end
    end

    return stylesList.value, apiList.value
end

return useSprings
