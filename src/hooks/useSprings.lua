local ReplicatedStorage = game:GetService("ReplicatedStorage")

local rbxts_include = ReplicatedStorage:FindFirstChild("rbxts_include")
local TS = rbxts_include and require(rbxts_include.RuntimeLib)

local Promise = if TS then TS.Promise else require(script.Parent.Parent.Parent.Promise)
local Controller = require(script.Parent.Parent.Controller)
local util = require(script.Parent.Parent.util)

local function useSprings(hooks, length: number, props: { any } | (index: number) -> ({[string]: any}), deps: {any}?)
    local isImperative = hooks.useValue(nil)
    local ctrls = hooks.useValue({})
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
            for i, spring in ipairs(ctrls.value) do
                local startProps = util.merge(props[i], {
                    reset = if props[i].reset then props[i].reset else false,
                })
                spring:start(util.merge({ default = true }, startProps))
            end
        end
    end, deps)

    -- Create new controllers when "length" increases, and destroy
    -- the affected controllers when "length" decreases
    hooks.useMemo(function()
        if length > #ctrls.value then
            for i = #ctrls.value + 1, length do
                local styles, api = Controller.new(if typeof(props) == "table" then props[i] else props(i))
                ctrls.value[i] = api
                stylesList.value[i] = styles
            end
        else
            -- Clean up any unused controllers
            for i = length + 1, #ctrls.value do
                ctrls.value[i]:stop()
                ctrls.value[i] = nil
                stylesList.value[i] = nil
                apiList.value[i] = nil
            end
        end
    end, { length })

    hooks.useMemo(function()
        if isImperative.value then
            if #ctrls.value > 0 then
                for apiName, value in pairs(getmetatable(ctrls.value[1])) do
                    if typeof(value) == "function" and apiName ~= "new" then
                        apiList.value[apiName] = function(apiProps: (index: number) -> any | any)
                            local promises = {}
                            for i, spring in ipairs(ctrls.value) do
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
        end
        -- Need to pass {{}} because useMemo doesn't support nil dependency yet
    end, deps or {{}})

    -- Cancel the animations of all controllers on unmount
    hooks.useEffect(function()
        return function()
            for _, ctrl in ipairs(ctrls.value) do
                ctrl:stop()
            end
        end
    end, {})

    if isImperative.value then
        return stylesList.value, apiList.value
    end

    return stylesList.value
end

return useSprings
