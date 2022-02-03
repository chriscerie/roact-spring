local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = Roact.createElement

local function Button(props, hooks)
    local styles, api = RoactSpring.useSpring(hooks, function()
        return {
            Rotation = 0,
            Position = UDim2.fromScale(0.5, 0.5),
        }
    end)

	return e("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = styles.Position,
		Size = UDim2.fromScale(0.3, 0.3),
		BackgroundColor3 = Color3.fromRGB(99, 255, 130),
        Rotation = styles.Rotation,
        Text = "Click me",

        [Roact.Event.Activated] = function()
            api.start({
                Position = UDim2.fromScale(0.5, 0.8),
                immediate = true,
            })
        end,
	}, {
        UICorner = e("UICorner"),
    })
end

Button = Hooks.new(Roact)(Button)

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end