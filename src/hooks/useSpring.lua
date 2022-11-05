local ReplicatedStorage = game:GetService("ReplicatedStorage")

local rbxts_include = ReplicatedStorage:FindFirstChild("rbxts_include")
local TS = rbxts_include and require(rbxts_include.RuntimeLib)

local React = if TS then TS.import(script, TS.getModule(script, "@rbxts", "roact").src) else require(script.Parent.Parent.Parent.React)
local useSprings = require(script.Parent.useSprings)

local isRoact17 = not React.reconcile

if isRoact17 then
    return function(props, deps: {any}?)
        local isFn = type(props) == "function"

        local styles, api = useSprings(
            1,
            if isFn then props else {props},
            if isFn then deps or {} else deps
        )

        return styles[1], api
    end
end

return function(hooks, props, deps: {any}?)
    local isFn = type(props) == "function"

    local styles, api = useSprings(
        hooks,
        1,
        if isFn then props else {props},
        if isFn then deps or {} else deps
    )

    return styles[1], api
end
