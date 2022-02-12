local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)
local CircleButton = require(script.Parent.Parent.components.CircleButton)

local e = Roact.createElement

local function Button(_, hooks)
    local styles, api = RoactSpring.useSpring(hooks, function()
        return {
            position = UDim2.fromScale(0.5, 0.6),
            config = {
                friction = 8,
                velocity = { 0, 0, 0, -5 }
            },
        }
    end)

	return e(CircleButton, {
        Position = styles.position,

        [Roact.Event.Activated] = function()
            api.start({ position = UDim2.fromScale(0.5, 0.6) })
        end
	})
end

Button = Hooks.new(Roact)(Button)

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end
