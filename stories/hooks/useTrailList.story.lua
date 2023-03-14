--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = React.createElement

local buttonProps = {
    {
        text = "LOREM",
        gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 215, 72)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 147, 57)),
        }),
    }, {
        text = "IPSUM",
        gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(241, 108, 230)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(238, 71, 130)),
        }),
    }, {
        text = "DOLOR",
        gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 223, 240)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 119, 224)),
        }),
    }, {
        text = "SIT",
        gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(177, 223, 233)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(151, 182, 224)),
        }),
    }
}

local function Button(_)
    local toggle, setToggle = React.useState(false)

    local springProps = {}
    for i in ipairs(buttonProps) do
        table.insert(springProps, {
            position = UDim2.fromScale(if toggle then 0.45 else 0.35, 0.05 + i * 0.15),
            transparency = if toggle then 0 else 1,
            config = { damping = 1, frequency = 0.3 },
        })
    end
    local springs = RoactSpring.useTrail(#buttonProps, springProps)

    React.useEffect(function()
        local conn = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                setToggle(function(prevState)
                    return not prevState
                end)
            end
        end)

        return function()
            conn:Disconnect()
        end
    end, {})

    local buttons = {}

    for index, buttonProp in ipairs(buttonProps) do
        buttons[index] = e("ImageButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = springs[index].position,
            Transparency = springs[index].transparency,
            Size = UDim2.fromScale(1, 0.13),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AutoButtonColor = false,
        }, {
            UICorner = e("UICorner"),
            UIGradient = e("UIGradient", {
                Color = buttonProp.gradient,
            }),
            UIStroke = e("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(95, 95, 95),
                Thickness = 2,
                Transparency = springs[index].transparency,
            }, {
                UIGradient = e("UIGradient", {
                    Rotation = -90,
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.85),
                        NumberSequenceKeypoint.new(1, 1),
                    }),
                }),
            }),
            Label = e("TextLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.7, 0.7),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Text = buttonProp.text,
                TextSize = 22,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = springs[index].ZIndex,
                TextTransparency = springs[index].transparency,
            }),
        })
    end

	return e("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.3, 0.7),
		BackgroundTransparency = 1,
	}, buttons)
end

return function(target)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
    root:render(ReactRoblox.createPortal({
        App = e(Button)
    }, target))

	return function()
		root:unmount()
	end
end
