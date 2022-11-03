local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)
local CircleButton = require(script.Parent.Parent.components.CircleButton)

local e = Roact.createElement

local function Button(_)
    local styles, api = RoactSpring.useSpring(function()
        return { position = UDim2.fromScale(0.5, 0.5), }
    end)

	return e(CircleButton, {
        Position = styles.position,
        [Roact.Event.Activated] = function()
            api.start({
                position = UDim2.fromScale(0.5, 0.8),
                immediate = true,
            })
        end,
	})
end

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end
