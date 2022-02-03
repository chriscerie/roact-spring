local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = Roact.createElement

local function Button(props, hooks)
    local styles, api = RoactSpring.useSpring(hooks, function()
        return {
            to = { position = UDim2.fromScale(0.5, 0.5) },
        }
    end)

	return e("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = styles.position,
		Size = UDim2.fromOffset(30, 30),
		BackgroundColor3 = Color3.fromRGB(99, 255, 130),
        Text = "Click me",

        [Roact.Event.Activated] = function()
            api.start({
                position = UDim2.fromScale(0.5, 0.8),
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