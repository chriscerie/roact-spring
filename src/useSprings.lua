local Promise = require(script.Parent.Parent.Promise)
local Controller = require(script.Parent.Controller)

local function useSprings(hooks, length: number, props: { any } | (index: number) -> ({[string]: any}), deps: {any}?)
    local isImperative = hooks.useValue(nil)
    local springs = hooks.useValue({})
    local stylesList = hooks.useValue({})
    local apiList = hooks.useValue({})

    if typeof(props) == "table" then
        assert(isImperative.value == nil or isImperative.value == false, "useSprings detected a change from imperative to declarative. This is not supported.")
        isImperative.value = false
    elseif typeof(props) == "function" then
        assert(isImperative.value == nil or isImperative.value == true, "useSprings detected a change from declarative to imperative. This is not supported.")
        isImperative.value = true
    else
        error("Expected table or function for useSprings, got " .. typeof(props))
    end

    hooks.useEffect(function()
        if isImperative.value == false then
            for i, spring in ipairs(springs.value) do
                spring:start(props[i])
            end
        end
    end, deps)

    hooks.useMemo(function()
        if length > #springs then
            for i = #springs + 1, length do
                local styles, api = Controller.new(if typeof(props) == "table" then props[i] else props(i))
                springs.value[i] = api
                stylesList.value[i] = styles
            end
        else
            for i = length + 1, #springs do
                springs.value[i]:stop()
                springs.value[i] = nil
                stylesList.value[i] = nil
                apiList.value[i] = nil
            end
        end
    end, { length })

    hooks.useMemo(function()
        if isImperative.value then
            for apiName, value in pairs(getmetatable(springs.value[1])) do
                if typeof(value) == "function" and apiName ~= "new" then
                    apiList.value[apiName] = function(apiProps: (index: number) -> any | any)
                        local promises = {}
                        for i, spring in ipairs(springs.value) do
                            table.insert(promises, Promise.new(function(resolve)
                                local result = spring[apiName](spring, if typeof(apiProps) == "function" then apiProps(i) else apiProps)

                                -- Some results might be promises
                                if result and result.await then
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
        -- Need to pass {{}} because useMemo doesn't support nil dependency yet
    end, deps or {{}})

    if isImperative.value then
        return stylesList.value, apiList.value
    end

    return stylesList.value
end

return useSprings
