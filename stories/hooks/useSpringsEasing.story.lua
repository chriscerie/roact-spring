--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = React.createElement

local easingsArray = {}
for name, easing in pairs(RoactSpring.easings) do
    table.insert(easingsArray, {
        name = name,
        easing = easing,
    })
end

local function Button(_)
    local toggle, setToggle = React.useState(false)

    local springProps = {}
    for i in ipairs(easingsArray) do
        table.insert(springProps, {
            position = UDim2.fromScale(if toggle then 0.8 else 0.2, 0.05 + i * 0.03),
            config = { easing = easingsArray[i].easing, duration = 2 },
        })
    end
    local springs = RoactSpring.useSprings(#easingsArray, springProps)

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

    for index, easing in ipairs(easingsArray) do
        buttons[easing.name] = e(React.Fragment, nil, {
            Button = e("TextButton", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = springs[index].position,
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

	return e(React.Fragment, nil, buttons)
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
