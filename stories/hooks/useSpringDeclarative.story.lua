local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)
local CircleButton = require(script.Parent.Parent.components.CircleButton)

local e = Roact.createElement

local function Button(_, hooks)
    local toggle, setToggle = hooks.useState(false)
    local styles = RoactSpring.useSpring(hooks, {
        position = if toggle then UDim2.fromScale(0.7, 0.5) else UDim2.fromScale(0.3, 0.5),
        config = if toggle then { tension = 200 } else { tension = 50 },
    }, { toggle })

	return e(CircleButton, {
        Position = styles.position,
        [Roact.Event.Activated] = function()
            setToggle(function(prevState)
                return not prevState
            end)
        end,
	})
end

Button = Hooks.new(Roact)(Button)

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end