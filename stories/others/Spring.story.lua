local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)
local CircleButton = require(script.Parent.Parent.components.CircleButton)

local e = Roact.createElement

local Example = Roact.Component:extend("Example")

function Example:init()
    self.styles, self.api = RoactSpring.Controller.new({
        position = UDim2.fromScale(0.5, 0.5),
    })
end

function Example:render()
    return e(CircleButton, {
        Position = self.styles.position,

        [Roact.Event.Activated] = function()
            self.api:start({
                position = UDim2.fromScale(0.5, 0.8),
            })
        end,
	})
end

return function(target)
	local handle = Roact.mount(e(Example), target, "Example")

	return function()
		Roact.unmount(handle)
	end
end