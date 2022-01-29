local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = Roact.createElement

local easingsArray = {}
for name, easing in pairs(RoactSpring.easings) do
    table.insert(easingsArray, {
        name = name,
        easing = easing,
    })
end

local function Button(props, hooks)
    local atTarget, setAtTarget = hooks.useState(false)
    local springs = RoactSpring.useSprings(hooks, #easingsArray, function(i)
        return {
            from = { Position = UDim2.fromScale(0.2, 0.05 + i * 0.03) },
            to = { Position = UDim2.fromScale(if atTarget then 0.2 else 0.8, 0.05 + i * 0.03) },
            config = { easing = easingsArray[i].easing, duration = 2 },
        }
    end)

    hooks.useEffect(function()
        local conn = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                setAtTarget(function(prevState)
                    return not prevState
                end)
            end
        end)

        return function()
            conn:Disconnect()
        end
    end, {})

    local buttons = {}

    for index, easing in ipairs(easingsArray) do
        buttons[easing.name] = Roact.createFragment({
            Button = e("TextButton", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = springs[index].Position,
                Size = UDim2.fromOffset(15, 15),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Text = "",
            }, {
                UICorner = e("UICorner"),
            }),
            Label = e("TextLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.fromScale(0.18, 0.05 + index * 0.03),
                Size = UDim2.fromOffset(0, 0),
                BackgroundTransparency = 1,
                Text = easing.name,
                TextSize = 10,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextXAlignment = Enum.TextXAlignment.Right,
            }),
        })
    end

	return Roact.createFragment(buttons)
end

Button = Hooks.new(Roact)(Button)

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end