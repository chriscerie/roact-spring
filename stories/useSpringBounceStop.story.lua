local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = Roact.createElement

local STOP_AFTER_SECONDS = 3

local function Button(props, hooks)
    local styles, api = RoactSpring.useSpring(hooks, function()
        return {
            from = {
                position = UDim2.fromScale(0.5, 0.3),
            },
        }
    end)

	return e("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = styles.position,
		Size = UDim2.fromOffset(150, 150),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        Text = "",

        [Roact.Event.Activated] = function()
            api.start({
                to = { position = UDim2.fromScale(0.5, 0.8) },
                config = { mass = 2.5, bounce = 1, tension = 180, friction = 0 },
            })
            task.wait(STOP_AFTER_SECONDS)
            api.stop()
        end
	}, {
        UICorner = e("UICorner", {
            CornerRadius = UDim.new(1, 0),
        }),
        UIGradient = e("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 255, 183)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 119, 253)),
            }),
            Rotation = 25,
        }),
    })
end

Button = Hooks.new(Roact)(Button)

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end