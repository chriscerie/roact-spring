local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)
local CircleButton = require(script.Parent.Parent.components.CircleButton)

local e = Roact.createElement
local PAUSE_AFTER_SECONDS = 1.5

local function Button(_, hooks)
    local styles, api = RoactSpring.useSpring(hooks, function()
        return {
            position = UDim2.fromScale(0.5, 0.5),
        }
    end)

	return e(CircleButton, {
        Position = styles.position,
        [Roact.Event.Activated] = function()
            api.start({
                to = { position = UDim2.fromScale(0.5, 0.8) },
                config = { bounce = 1, tension = 180, friction = 0 },
            })
            task.wait(PAUSE_AFTER_SECONDS)
            api.pause()
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
