local ReplicatedStorage = game:GetService("ReplicatedStorage")

local rbxts_include = ReplicatedStorage:FindFirstChild("rbxts_include")
local TS = rbxts_include and require(rbxts_include.RuntimeLib)

local Roact = if TS then TS.import(script, TS.getModule(script, "@rbxts", "roact").src) else require(script.Parent.Parent.Roact)
local Promise = if TS then TS.Promise else require(script.Parent.Parent.Promise)
local SpringValue = require(script.Parent.SpringValue)
local AnimationConfig = require(script.Parent.AnimationConfig)
local util = require(script.Parent.util)
local constants = require(script.Parent.constants)

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

-- Merge unrecognized props to the `to` table
local function prepareKeys(props: ControllerProps)
    local newProps = {}

    for key, value in pairs(props) do
        if constants.propsList[key] ~= nil then
            newProps[key] = value
        else
            if newProps.to == nil then
                newProps.to = {}
            end
            newProps.to[key] = value
        end
    end

    return newProps
end

function Controller.new(props: ControllerProps)
    assert(Roact, "Roact not found. It must be placed in the same folder as roact-spring.")
    assert(typeof(props) == "table", "Props are required.")

    props = prepareKeys(props)

    local self = {
        bindings = {},
        controls = {},
    }

    for toName, to in pairs(props.to or props.from or error("`to` or `from` expected, none passed.")) do
        local from = if props.from and props.from[toName] then props.from[toName] else to

        to = if typeof(to) == "string" then Color3.fromHex(to) else to
        from = if typeof(from) == "string" then Color3.fromHex(from) else from

        local style, setStyle = Roact.createBinding(from)

        self.bindings[toName] = style
        self.controls[toName] = {
            setValue = setStyle,
            springValue = SpringValue.new(
                util.merge(props, {
                    from = from,
                    to = to,
                })
            ),
        }
    end

    return self.bindings, setmetatable(self, Controller)
end

function Controller:start(startProps: ControllerProps?)
    if not startProps then
        return Promise.new(function(resolve)
            resolve()
        end)
    end
    startProps = prepareKeys(startProps)

    local promises = {}

    for name, target in pairs(startProps.to or {}) do
        local control = self.controls[name]

        if typeof(target) == "string" then
            target = Color3.fromHex(target)
        end

        table.insert(promises, control.springValue:start({
            to = target,
            delay = startProps.delay,
            immediate = startProps.immediate,
            config = startProps.config,
            onChange = function(newValue)
                control.setValue(newValue)
            end,
        }))
    end

    return Promise.all(promises)
end

function Controller:stop(keys: {string}?)
    if keys then
        for _, key in pairs(keys) do
            if self.controls[key] then
                self.controls[key].springValue:stop()                    
            else
                warn("Tried to stop animation at key `" .. key .. "`, but it doesn't exist.")
            end
        end
    else
        for _, control in pairs(self.controls) do
            control.springValue:stop()
        end
    end
end

function Controller:pause(keys: {string}?)
    if keys then
        for _, key in pairs(keys) do
            if self.controls[key] then
                self.controls[key].springValue:pause()                    
            else
                warn("Tried to pause animation at key `" .. key .. "`, but it doesn't exist.")
            end
        end
    else
        for _, control in pairs(self.controls) do
            control.springValue:pause()
        end
    end
end

return Controller
