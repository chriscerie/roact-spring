--!strict
--[[
    Note: Since this story uses performs mouse position calculations, this
    must be viewed in the Roblox Studio window to work properly.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

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
    local springs, api = RoactSpring.useSprings(#buttonProps, function(i)
        return {
            Position = UDim2.fromScale(0.5, i * 0.16),
            Size = UDim2.fromScale(1, 0.13), 
            ZIndex = 1,
        }
    end)
    local connection = React.useRef(nil :: RBXScriptConnection?)

    local contents = {}

    for index, buttonProp in ipairs(buttonProps) do
        contents[index] = e("ImageButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = springs[index].Position,
            Size = springs[index].Size,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AutoButtonColor = false,
            ZIndex = springs[index].ZIndex,

            [React.Event.InputBegan] = function(button, input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    connection.current = RunService.Heartbeat:Connect(function()
                        local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset().Y)
                        local yPos = mousePos.Y
                        local frame = button.Parent

                        api.start(function(i)
                            if i == index then
                                return {
                                    Position = UDim2.fromScale(0.5, (yPos - frame.AbsolutePosition.Y) / frame.AbsoluteSize.Y),
                                    ZIndex = 10,
                                    immediate = true,
                                }
                            end
                            return {
                                ZIndex = 1,
                                immediate = true,
                            }
                        end)

                        api.start(function(i)
                            if i == index then
                                return {
                                    Size = UDim2.new(1, 15, 0.13, 15),
                                }
                            end
                            return {}
                        end)

                        local buttons: { ImageButton } = frame:GetChildren()

                        table.sort(buttons, function(a, b)
                            return a.AbsolutePosition.Y < b.AbsolutePosition.Y
                        end)

                        local sortedButtonNums = {}
                        for _, v in ipairs(buttons) do
                            table.insert(sortedButtonNums, tonumber(v.Name))
                        end

                        api.start(function(i)
                            if i ~= index then
                                return {
                                    Position = UDim2.fromScale(0.5, ((table.find(sortedButtonNums, i) or 1) - 1) * 0.16 + 0.16),
                                }
                            end
                            return {}
                        end)
                    end)
                end
            end,
            [React.Event.InputEnded] = function(button,input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if connection.current then
                        connection.current:Disconnect()
                        connection.current = nil
                    end

                    local buttons = button.Parent:GetChildren()

                    table.sort(buttons, function(a, b)
                        return a.AbsolutePosition.Y < b.AbsolutePosition.Y
                    end)

                    local sortedButtonNums = {}
                    for _, v in ipairs(buttons) do
                        table.insert(sortedButtonNums, tonumber(v.Name))
                    end

                    api.start(function(i)
                        return {
                            Position = UDim2.fromScale(0.5, ((table.find(sortedButtonNums, i) or 1) - 1) * 0.16 + 0.16),
                            Size = UDim2.fromScale(1, 0.13),
                        }
                    end)
                end
            end
        }, {
            UICorner = e("UICorner"),
            UIGradient = e("UIGradient", {
                Color = buttonProp.gradient,
            }),
            UIStroke = e("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Color3.fromRGB(95, 95, 95),
                Thickness = 2,
                Transparency = 0,
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
            }),
        })
    end

	return e("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.3, 0.7),
		BackgroundTransparency = 1,
	}, contents)
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
