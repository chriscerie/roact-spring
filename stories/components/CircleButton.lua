local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)

local e = Roact.createElement

local function Button(props, hooks)
	return e("TextButton", {
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
		Size = props.Size,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        Text = "",

        [Roact.Event.Activated] = props[Roact.Event.Activated],
        [Roact.Event.InputBegan] = props[Roact.Event.InputBegan],
        [Roact.Event.InputEnded] = props[Roact.Event.InputEnded],
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

return Hooks.new(Roact)(Button, {
    defaultProps = {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(150, 150),
    },
})
