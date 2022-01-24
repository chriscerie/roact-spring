local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = Roact.createElement

local function Button(props, hooks)
    local styles, api = RoactSpring.useSpring(hooks, {
        from = {
            Rotation = 0,
            Position = UDim2.fromScale(0.5, 0.5),
        },
    })

	return e("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = styles.Position.value,
		Size = UDim2.fromScale(0.3, 0.3),
		BackgroundColor3 = Color3.fromRGB(99, 255, 130),
        Rotation = styles.Rotation.value,
        Text = "Click me",

        [Roact.Event.Activated] = function()
            api.start({
                Position = UDim2.fromScale(0.5, 0.8),
            }, {
                bounce = 1,
                velocity = -0.05,
            }):andThen(function()
                print("Completed")
            end)
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