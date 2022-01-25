local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactSpring = require(ReplicatedStorage.Packages.RoactSpring)

local e = Roact.createElement

local function Button(props, hooks)
    local springs, api = RoactSpring.useSprings(hooks, 5, function(i)
        return {
            from = {
                Position = UDim2.fromScale(0.5, i * 0.2),
                Size = UDim2.fromScale(1, 0.18),
            },
        }
    end)
    local connection = hooks.useValue()

    local buttons = {}

    for index = 1, 5 do
        buttons[index] = e("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = springs[index].Position.value,
            Size = springs[index].Size.value,
            BackgroundColor3 = Color3.fromRGB(99, 255, 130),
            AutoButtonColor = false,
            Text = "Click me",

            [Roact.Event.InputBegan] = function(button, input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    connection.value = RunService.Heartbeat:Connect(function()
                        local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset().Y)
                        local yPos = mousePos.Y
                        local frame = button.Parent

                        api.start(function(i)
                            if i == index then
                                return {
                                    Position = UDim2.fromScale(0.5, (yPos - frame.AbsolutePosition.Y) / frame.AbsoluteSize.Y),
                                }, {
                                    immediate = true,
                                }
                            end
                            return {}
                        end)

                        api.start(function(i)
                            if i == index then
                                return {
                                    Size = UDim2.new(1, 20, 0.18, 20),
                                }, RoactSpring.constants.config.stiff
                            end
                            return {}
                        end)

                        local buttons = frame:GetChildren()

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
                                    Position = UDim2.fromScale(0.5, (table.find(sortedButtonNums, i) - 1) * 0.2 + 0.2),
                                }
                            end
                            return {}
                        end)
                    end)
                end
            end,
            [Roact.Event.InputEnded] = function(button,input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if connection.value then
                        connection.value:Disconnect()
                        connection.value = nil
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
                            Position = UDim2.fromScale(0.5, (table.find(sortedButtonNums, i) - 1) * 0.2 + 0.2),
                            Size = UDim2.fromScale(1, 0.18),
                        }
                    end)
                end
            end
        }, {
            UICorner = e("UICorner"),
        })
    end

	return e("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.4, 0.7),
		BackgroundTransparency = 1,
	}, buttons)
end

Button = Hooks.new(Roact)(Button)

return function(target)
	local handle = Roact.mount(e(Button), target, "Button")

	return function()
		Roact.unmount(handle)
	end
end