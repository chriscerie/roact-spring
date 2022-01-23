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
        config = {
            mass = 0.1,
        },
    })

	return e("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = styles.Position.value,
		Size = UDim2.fromScale(0.3, 0.3),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Rotation = styles.Rotation.value,

        [Roact.Event.Activated] = function()
            api.start({
                Position = UDim2.fromScale(0.5, 0.8),
            }, {
                velocity = -0.3,
            }):andThen(function()
                print("Completed")
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