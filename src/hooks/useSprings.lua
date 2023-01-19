local ReplicatedStorage = game:GetService("ReplicatedStorage")

local rbxts_include = ReplicatedStorage:FindFirstChild("rbxts_include")
local TS = rbxts_include and require(rbxts_include.RuntimeLib)

local React = if script.Parent.Parent:FindFirstChild("React") then require(script.Parent.Parent.React) else if TS then TS.import(script, TS.getModule(script, "@rbxts", "roact").src) else nil; 
local Promise = if TS then TS.Promise else require(script.Parent.Parent.Parent.Promise)
local Controller = require(script.Parent.Parent.Controller)
local util = require(script.Parent.Parent.util)

local isRoact17 = not React.reconcile
local useRefKey = if isRoact17 then "current" else "value"

local function useSprings(hooks, length: number, props: { any } | (index: number) -> ({[string]: any}), deps: {any}?)
    local isImperative = hooks[if isRoact17 then "useRef" else "useValue"](nil)
    local ctrls = hooks[if isRoact17 then "useRef" else "useValue"]({})
    local stylesList = hooks[if isRoact17 then "useRef" else "useValue"]({})
    local apiList = hooks[if isRoact17 then "useRef" else "useValue"]({})

    if typeof(props) == "table" then
        assert(isImperative[useRefKey] == nil or isImperative[useRefKey] == false, "useSprings detected a change from imperative to declarative. This is not supported.")
        isImperative[useRefKey] = false
    elseif typeof(props) == "function" then
        assert(isImperative[useRefKey] == nil or isImperative[useRefKey] == true, "useSprings detected a change from declarative to imperative. This is not supported.")
        isImperative[useRefKey] = true
    else
        error("Expected table or function for useSprings, got " .. typeof(props))
    end

    hooks.useEffect(function()
        if isImperative[useRefKey] == false then
            for i, spring in ipairs(ctrls[useRefKey]) do
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
        if length > #ctrls[useRefKey] then
            for i = #ctrls[useRefKey] + 1, length do
                local styles, api = Controller.new(if typeof(props) == "table" then props[i] else props(i))
                ctrls[useRefKey][i] = api
                stylesList[useRefKey][i] = styles
            end
        else
            -- Clean up any unused controllers
            for i = length + 1, #ctrls[useRefKey] do
                ctrls[useRefKey][i]:stop()
                ctrls[useRefKey][i] = nil
                stylesList[useRefKey][i] = nil
                apiList[useRefKey][i] = nil
            end
        end
    end, { length })

    hooks.useMemo(function()
        if isImperative[useRefKey] then
            if #ctrls[useRefKey] > 0 then
                for apiName, value in pairs(getmetatable(ctrls[useRefKey][1])) do
                    if typeof(value) == "function" and apiName ~= "new" then
                        apiList[useRefKey][apiName] = function(apiProps: (index: number) -> any | any)
                            local promises = {}
                            for i, spring in ipairs(ctrls[useRefKey]) do
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
            for _, ctrl in ipairs(ctrls[useRefKey]) do
                ctrl:stop()
            end
        end
    end, {})

    if isImperative[useRefKey] then
        return stylesList[useRefKey], apiList[useRefKey]
    end

    return stylesList[useRefKey]
end

if isRoact17 then
    return function(length: number, props: { any } | (index: number) -> ({[string]: any}), deps: {any}?)
        return useSprings(React, length, props, deps)
    end
end

return useSprings
