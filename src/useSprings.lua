--[=[
    @class useSprings
    Creates multiple springs, each with its own config. Use it for static lists, etc.
]=]

local Promise = require(script.Parent.Parent.Promise)
local useSpring = require(script.Parent.useSpring)

local function useSprings(hooks, length: number, props: { any } | (index: number) -> ({[string]: any}))
    local isImperative = hooks.useValue(nil)
    local springs: {
        value: {
            {
                style: any,
                api: any?,
            }
        },
    } = hooks.useValue(nil)
    local stylesList = hooks.useValue(nil)
    local apiList = hooks.useValue(nil)

    if typeof(props) == "table" then
        assert(isImperative.value == nil or isImperative.value == false, "useSprings detected a change from imperative to declarative. This is not supported.")
        isImperative.value = false
    elseif typeof(props) == "function" then
        assert(isImperative.value == nil or isImperative.value == true, "useSprings detected a change from declarative to imperative. This is not supported.")
        isImperative.value = true
    else
        error("Expected table or function for useSprings, got " .. typeof(props))
    end

    if springs.value then
        assert(#springs.value == length, "Length of useSprings changed from " .. #springs.value .. " to " .. length .. ". This is not supported.")
    else
        springs.value = {}
    end

    for i = 1, length do
        local style, api
        if isImperative.value then
            style, api = useSpring(hooks, function()
                return props(i)
            end)
        else
            style = useSpring(hooks, props[i])
        end
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

        if isImperative.value and springs.value[1].api then
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

    if isImperative.value then
        return stylesList.value, apiList.value
    end
    return stylesList.value
end

return useSprings
