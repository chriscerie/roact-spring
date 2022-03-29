local ReplicatedStorage = game:GetService("ReplicatedStorage")

local rbxts_include = ReplicatedStorage:FindFirstChild("rbxts_include")
local TS = rbxts_include and require(rbxts_include.RuntimeLib)

local Roact = if TS then TS.import(script, TS.getModule(script, "@rbxts", "roact").src) else require(script.Parent.Parent.Roact)
local Promise = if TS then TS.Promise else require(script.Parent.Parent.Promise)
local SpringValue = require(script.Parent.SpringValue)
local AnimationConfig = require(script.Parent.AnimationConfig)
local helpers = require(script.Parent.helpers)
local util = require(script.Parent.util)

local Controller = {}
Controller.__index = Controller

export type ControllerProps = { 
    [string]: any? 
} | {
    from: { [string]: any }?,
    to: { [string]: any }?,
    delay: number?,
    immediate: boolean?,
    config: AnimationConfig.SpringConfigs?,
    [string]: any?,
}

function Controller.new(props: ControllerProps)
    assert(Roact, "Roact not found. It must be placed in the same folder as roact-spring.")
    assert(typeof(props) == "table", "Props are required.")

    local self = setmetatable({
        bindings = {},
        controls = {},
        queue = {},
    }, Controller)

    self:start(util.merge({ default = true }, props))

    return self.bindings, self
end

local function createSpring(props, key: string)
    local spring = SpringValue.new(props, key)
    local binding, setBinding = Roact.createBinding()
    spring.key = key
    spring.onChange = function(newValue)
        setBinding(newValue)
    end
    return spring, binding
end

--Ensure spring objects exist for each defined key, and attach the `ctrl` to them for observation
local function prepareKeys(ctrl, props)
    if props.keys then
        for _, key in ipairs(props.keys) do
            local spring = ctrl.controls[key]
            if not spring then
                ctrl.controls[key], ctrl.bindings[key] = createSpring(props, key)
                spring = ctrl.controls[key]
            end
            spring:_prepareNode(props)
        end
    end
end

--[[
    Warning: Props might be mutated.

    Process a single set of props using the given controller.
]]
local function flushUpdate(ctrl, props, isLoop: boolean?)
    -- Looping must be handled in this function, or else the values
    -- would end up looping out-of-sync in many common cases.
    local loop = props.loop
    props.loop = false

    local promises = {}
    for _, key in pairs(props.keys or {}) do
        local control = ctrl.controls[key]
        table.insert(promises, control:start(props))
    end

    return Promise.all(promises):andThen(function()
        if loop then
            local nextProps = helpers.createLoopUpdate(props, loop)
            if nextProps then
                prepareKeys(ctrl, nextProps)
                return flushUpdate(ctrl, nextProps, true)
            end
        end
    end)
end

function Controller:start(startProps: ControllerProps?)
    if not startProps then
        return Promise.new(function(resolve)
            resolve()
        end)
    end

    local props = helpers.createUpdate(startProps)

    prepareKeys(self, props)
    return flushUpdate(self, props)
end

function Controller:stop(keys: {string}?)
    if keys then
        for _, key in pairs(keys) do
            if self.controls[key] then
                self.controls[key]:stop()                    
            else
                warn("Tried to stop animation at key `" .. key .. "`, but it doesn't exist.")
            end
        end
    else
        for _, control in pairs(self.controls) do
            control:stop()
        end
    end
end

function Controller:pause(keys: {string}?)
    if keys then
        for _, key in pairs(keys) do
            if self.controls[key] then
                self.controls[key]:pause()                    
            else
                warn("Tried to pause animation at key `" .. key .. "`, but it doesn't exist.")
            end
        end
    else
        for _, control in pairs(self.controls) do
            control:pause()
        end
    end
end

return Controller
