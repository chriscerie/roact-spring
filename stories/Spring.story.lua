local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = Roact.createElement

local Example = Roact.Component:extend("Example")

function Example:init()
    self.styles, self.api = RoactSpring.Spring.new({
        position = UDim2.fromScale(0.5, 0.5),
    })
end

function Example:render()
    return e("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = self.styles.position,
		Size = UDim2.fromOffset(30, 30),
		BackgroundColor3 = Color3.fromRGB(99, 255, 130),
        Text = "Click me",

        [Roact.Event.Activated] = function()
            self.api.start({
                position = UDim2.fromScale(0.5, 0.8),
            })
        end,
	}, {
        UICorner = e("UICorner"),
    })
end

return function(target)
	local handle = Roact.mount(e(Example), target, "Example")

	return function()
		Roact.unmount(handle)
	end
end